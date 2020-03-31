From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [RFC Patch 2/3] libmultipath: make sysfs_is_multipathed
	able to return wwid
Date: Mon, 30 Mar 2020 21:00:54 -0500
Message-ID: <1585620055-27112-3-git-send-email-bmarzins@redhat.com>
References: <1585620055-27112-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1585620055-27112-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>, Martin Wilck <Martin.Wilck@suse.com>
List-Id: dm-devel.ids

sysfs_is_multipathed reads the wwid of the dm device holding a path to
check if its a multipath device.  Add code to optinally set pp->wwid to
that wwid.  This will be used by a future patch.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 libmultipath/sysfs.c | 22 +++++++++++++++++++---
 libmultipath/sysfs.h |  2 +-
 multipath/main.c     |  7 ++++---
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/libmultipath/sysfs.c b/libmultipath/sysfs.c
index 62ec2ed7..034f082f 100644
--- a/libmultipath/sysfs.c
+++ b/libmultipath/sysfs.c
@@ -295,7 +295,7 @@ static int select_dm_devs(const struct dirent *di)
 	return fnmatch("dm-*", di->d_name, FNM_FILE_NAME) == 0;
 }
 
-bool sysfs_is_multipathed(const struct path *pp)
+bool sysfs_is_multipathed(struct path *pp, bool set_wwid)
 {
 	char pathbuf[PATH_MAX];
 	struct scandir_result sr;
@@ -342,9 +342,25 @@ bool sysfs_is_multipathed(const struct path *pp)
 		if (nr == sizeof(uuid) && !memcmp(uuid, "mpath-", sizeof(uuid)))
 			found = true;
 		else if (nr < 0) {
-			condlog(1, "%s: error reading from %s: %s",
-				__func__, pathbuf, strerror(errno));
+			condlog(1, "%s: error reading from %s: %m",
+				__func__, pathbuf);
 		}
+		if (found && set_wwid) {
+			nr = read(fd, pp->wwid, WWID_SIZE);
+			if (nr < 0) {
+				condlog(1, "%s: error reading from %s: %m",
+					__func__, pathbuf);
+				pp->wwid[0] = '\0';
+			} else if (nr == WWID_SIZE) {
+				condlog(4, "%s: overflow while reading from %s",
+					__func__, pathbuf);
+				pp->wwid[0] = '\0';
+			} else {
+				pp->wwid[nr] = '\0';
+				strchop(pp->wwid);
+			}
+                }
+
 		pthread_cleanup_pop(1);
 	}
 	pthread_cleanup_pop(1);
diff --git a/libmultipath/sysfs.h b/libmultipath/sysfs.h
index 9ae30b39..72b39ab2 100644
--- a/libmultipath/sysfs.h
+++ b/libmultipath/sysfs.h
@@ -14,5 +14,5 @@ ssize_t sysfs_bin_attr_get_value(struct udev_device *dev, const char *attr_name,
 				 unsigned char * value, size_t value_len);
 int sysfs_get_size (struct path *pp, unsigned long long * size);
 int sysfs_check_holders(char * check_devt, char * new_devt);
-bool sysfs_is_multipathed(const struct path *pp);
+bool sysfs_is_multipathed(struct path *pp, bool set_wwid);
 #endif
diff --git a/multipath/main.c b/multipath/main.c
index cf9d2a28..545ead87 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -638,7 +638,8 @@ configure (struct config *conf, enum mpath_cmds cmd,
 			 * Shortcut for find_multipaths smart:
 			 * Quick check if path is already multipathed.
 			 */
-			if (sysfs_is_multipathed(VECTOR_SLOT(pathvec, 0))) {
+			if (sysfs_is_multipathed(VECTOR_SLOT(pathvec, 0),
+						 false)) {
 				r = RTVL_YES;
 				goto print_valid;
 			}
@@ -747,8 +748,8 @@ configure (struct config *conf, enum mpath_cmds cmd,
 			/*
 			 * Check if we raced with multipathd
 			 */
-			r = sysfs_is_multipathed(VECTOR_SLOT(pathvec, 0)) ?
-				RTVL_YES : RTVL_NO;
+			r = sysfs_is_multipathed(VECTOR_SLOT(pathvec, 0),
+						 false) ? RTVL_YES : RTVL_NO;
 		}
 		goto print_valid;
 	}
-- 
2.17.2
