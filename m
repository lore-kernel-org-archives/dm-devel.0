From: Christian Seiler <christian@iwakd.de>
Subject: [PATCH] libmultipath: don't lock block device but use
	lock files
Date: Sat, 23 May 2015 23:00:12 +0200
Message-ID: <5560EA5C.6040001@iwakd.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

In recent versions udev uses flock() on the device node itself,
breaking libmultipath's current locking logic. Since libmultipath
doesn't actually modify anything on the device itself (and hence does
not actually need an exclusive lock on the device node, unlike e.g.
tools that create partitions etc.), and the reason for the lock is to
guard against multipath interfering with multipathd, use lock files
(named after the devices) in /run/lock/multipath instead.

See the discussion under:
https://www.redhat.com/archives/dm-devel/2014-December/msg00083.html
Especially:
https://www.redhat.com/archives/dm-devel/2014-December/msg00117.html

Signed-off-by: Christian Seiler <christian@iwakd.de>

---
 libmultipath/configure.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 libmultipath/configure.h |  2 ++
 libmultipath/structs.c   |  7 +++++++
 libmultipath/structs.h   |  3 +++
 4 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 24ad948..f77f97f 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -534,6 +534,8 @@ lock_multipath (struct multipath * mpp, int lock)
 	struct path * pp;
 	int i, j;
 	int x, y;
+	char *ptr;
+	size_t len;
 
 	if (!mpp || !mpp->pg)
 		return 0;
@@ -542,11 +544,45 @@ lock_multipath (struct multipath * mpp, int lock)
 		if (!pgp->paths)
 			continue;
 		vector_foreach_slot(pgp->paths, pp, j) {
-			if (lock && flock(pp->fd, LOCK_EX | LOCK_NB) &&
+			if (!pp->lock_path) {
+				len = sizeof(CONFIGURE_LOCK_DIRECTORY) + strlen(udev_device_get_devnode(pp->udev)) + 1;
+				pp->lock_path = MALLOC(len);
+				if (!pp->lock_path) {
+					condlog(0, "couldn't allocate lock path");
+					goto fail;
+				}
+				if (safe_snprintf(pp->lock_path, len, "%s/%s",
+						  CONFIGURE_LOCK_DIRECTORY, udev_device_get_devnode(pp->udev))) {
+					condlog(0, "couldn't allocate lock path");
+					FREE(pp->lock_path);
+					pp->lock_path = NULL;
+					goto fail;
+				}
+				for (ptr = pp->lock_path + sizeof(CONFIGURE_LOCK_DIRECTORY); *ptr; ptr++) {
+					if ((*ptr < '0' || *ptr > '9') && (*ptr < 'A' || *ptr > 'Z') &&
+					    (*ptr < 'a' || *ptr > 'z') && *ptr != '-' && *ptr != '_' && *ptr != '.')
+						*ptr = '_';
+				}
+			}
+			if (pp->lock_fd < 0) {
+				pp->lock_fd = open(pp->lock_path, O_RDWR | O_CREAT, 0600);
+				if (pp->lock_fd < 0 && errno == ENOENT) {
+					if (mkdir(CONFIGURE_LOCK_DIRECTORY, 0700) < 0) {
+						condlog(0, "%s: couldn't create lock directory", CONFIGURE_LOCK_DIRECTORY);
+						goto fail;
+					}
+					pp->lock_fd = open(pp->lock_path, O_RDWR | O_CREAT, 0600);
+				}
+				if (pp->lock_fd < 0) {
+					condlog(0, "%s: couldn't open lock file", pp->lock_path);
+					goto fail;
+				}
+			}
+			if (lock && flock(pp->lock_fd, LOCK_EX | LOCK_NB) &&
 			    errno == EWOULDBLOCK)
 				goto fail;
-			else if (!lock)
-				flock(pp->fd, LOCK_UN);
+			else if (!lock && pp->lock_fd >= 0)
+				flock(pp->lock_fd, LOCK_UN);
 		}
 	}
 	return 0;
@@ -559,7 +595,8 @@ fail:
 		vector_foreach_slot(pgp->paths, pp, y) {
 			if (x == i && y >= j)
 				return 1;
-			flock(pp->fd, LOCK_UN);
+			if (pp->lock_fd >= 0)
+				flock(pp->fd, LOCK_UN);
 		}
 	}
 	return 1;
diff --git a/libmultipath/configure.h b/libmultipath/configure.h
index c014b55..0415453 100644
--- a/libmultipath/configure.h
+++ b/libmultipath/configure.h
@@ -24,6 +24,8 @@ enum actions {
 #define FLUSH_ONE 1
 #define FLUSH_ALL 2
 
+#define CONFIGURE_LOCK_DIRECTORY     "/run/lock/multipath"
+
 int setup_map (struct multipath * mpp, char * params, int params_size );
 int domap (struct multipath * mpp, char * params);
 int reinstate_paths (struct multipath *mpp);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 0538327..ca7bcb5 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -95,6 +95,7 @@ alloc_path (void)
 		pp->sg_id.scsi_id = -1;
 		pp->sg_id.lun = -1;
 		pp->fd = -1;
+		pp->lock_fd = -1;
 		pp->priority = PRIO_UNDEF;
 	}
 	return pp;
@@ -115,6 +116,12 @@ free_path (struct path * pp)
 	if (pp->fd >= 0)
 		close(pp->fd);
 
+	if (pp->lock_fd >= 0)
+		close(pp->lock_fd);
+
+	if (pp->lock_path)
+		free(pp->lock_path);
+
 	if (pp->udev) {
 		udev_device_unref(pp->udev);
 		pp->udev = NULL;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index c1fce04..916aea5 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -204,6 +204,9 @@ struct path {
 
 	/* configlet pointers */
 	struct hwentry * hwe;
+
+	int lock_fd;
+	char * lock_path;
 };
 
 typedef int (pgpolicyfn) (struct multipath *);
-- 
2.1.4
