From: Christian Seiler <christian@iwakd.de>
Subject: Re: [PATCH] libmultipath: don't lock block device but
 use lock files
Date: Sun, 24 May 2015 10:05:15 +0200
Message-ID: <5561863B.5020001@iwakd.de>
References: <5560EA5C.6040001@iwakd.de> <556178AC.2010501@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040209010206040107060700"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <556178AC.2010501@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------040209010206040107060700
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

Thanks for your quick response!

On 05/24/2015 09:07 AM, Hannes Reinecke wrote:
> On 05/23/2015 11:00 PM, Christian Seiler wrote:
>> In recent versions udev uses flock() on the device node itself,
>> breaking libmultipath's current locking logic. Since libmultipath
>> doesn't actually modify anything on the device itself (and hence does
>> not actually need an exclusive lock on the device node, unlike e.g.
>> tools that create partitions etc.), and the reason for the lock is to
>> guard against multipath interfering with multipathd, use lock files
>> (named after the devices) in /run/lock/multipath instead.
>>
>> See the discussion under:
>> https://www.redhat.com/archives/dm-devel/2014-December/msg00083.html
>> Especially:
>> https://www.redhat.com/archives/dm-devel/2014-December/msg00117.html
>>
>> Signed-off-by: Christian Seiler <christian@iwakd.de>
>>
>> ---
> Well ... couldn't you just use a shared lock here?

I think you misunderstand the nature of the lock here: the lock is in
place to serialize different libmultipath instances against each other,
i.e. two multipath programs running at the same time or multipath
called at the same time multipathd is running. As was mentioned in the
mail I linked in the commit message of my patch: it was introduced in
commit [1] with a description of the problem.

So you definitely need an exclusive lock to serialize libmultipath
against other instances of it. Because with a shared lock, you don't
gain anything, that can always be taken, so it will always succeed. But
since udev uses a shared lock itself nowadays, taking it out on the
device node itself is not going to work, so that's why my patch
resorts to using lock files.

Of course, _additionally_ taking out a shared lock on the device might
be advisable if you want to protect against tools that modify devices,
such as partitioning tools etc. (This is the reason why udev takes out
a shared lock: to make sure that when processing events and determining
the contents of the device, problems with tools that modify the
partition table etc. don't occur.) But that's not really necessary for
multipath, because libmultipath only opens the device to do some
information gathering on the device (INQUIRY command, determine
geometry, etc.), but doesn't really care about the contents (there's
never a see/read done on the fd).

That said, I've noticed that my patch might cause multipathd to have
the lock file fds open unnecessarily, so I've updated it to close them
on regular unlocking (but not on failure, because that means there will
be a retry). Version 2 is attached.

> I thought to have send this patch already; hmm.

I didn't see that, sorry. (I started looking at this problem in-depth
yesterday, found the thread in December, noticed no followup there in
the archive's web interface, noticed no commit in git regarding this
issue and hence checked out the git source code for the first time and
started working on the patch.)

But as I elaborated: I don't think that helps.

Christian

[1] http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=commit;h=4bc295cef7a50ea46bfc7b98c65848babf56c822

--------------040209010206040107060700
Content-Type: text/x-diff;
	name="0001-libmultipath-don-t-lock-block-device-but-use-lock-fi.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename*0="0001-libmultipath-don-t-lock-block-device-but-use-lock-fi.pa";
	filename*1="tch"

=46rom 75d877f1161d4bd33dea2b57ce2ef371121e94e3 Mon Sep 17 00:00:00 2001
From: Christian Seiler <christian@iwakd.de>
Date: Sat, 23 May 2015 22:57:31 +0200
Subject: [PATCH v2] libmultipath: don't lock block device but use lock fi=
les

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
v2: don't keep lock fds open after regular unlocking (multipathd is long-=

    lived)

 libmultipath/configure.c | 50 ++++++++++++++++++++++++++++++++++++++++++=
++----
 libmultipath/configure.h |  2 ++
 libmultipath/structs.c   |  7 +++++++
 libmultipath/structs.h   |  3 +++
 4 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 24ad948..5bcd6d9 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -534,6 +534,8 @@ lock_multipath (struct multipath * mpp, int lock)
 	struct path * pp;
 	int i, j;
 	int x, y;
+	char *ptr;
+	size_t len;
=20
 	if (!mpp || !mpp->pg)
 		return 0;
@@ -542,11 +544,48 @@ lock_multipath (struct multipath * mpp, int lock)
 		if (!pgp->paths)
 			continue;
 		vector_foreach_slot(pgp->paths, pp, j) {
-			if (lock && flock(pp->fd, LOCK_EX | LOCK_NB) &&
+			if (!pp->lock_path) {
+				len =3D sizeof(CONFIGURE_LOCK_DIRECTORY) + strlen(udev_device_get_de=
vnode(pp->udev)) + 1;
+				pp->lock_path =3D MALLOC(len);
+				if (!pp->lock_path) {
+					condlog(0, "couldn't allocate lock path");
+					goto fail;
+				}
+				if (safe_snprintf(pp->lock_path, len, "%s/%s",
+						  CONFIGURE_LOCK_DIRECTORY, udev_device_get_devnode(pp->udev))) {
+					condlog(0, "couldn't allocate lock path");
+					FREE(pp->lock_path);
+					pp->lock_path =3D NULL;
+					goto fail;
+				}
+				for (ptr =3D pp->lock_path + sizeof(CONFIGURE_LOCK_DIRECTORY); *ptr;=
 ptr++) {
+					if ((*ptr < '0' || *ptr > '9') && (*ptr < 'A' || *ptr > 'Z') &&
+					    (*ptr < 'a' || *ptr > 'z') && *ptr !=3D '-' && *ptr !=3D '_' &&=
 *ptr !=3D '.')
+						*ptr =3D '_';
+				}
+			}
+			if (pp->lock_fd < 0) {
+				pp->lock_fd =3D open(pp->lock_path, O_RDWR | O_CREAT, 0600);
+				if (pp->lock_fd < 0 && errno =3D=3D ENOENT) {
+					if (mkdir(CONFIGURE_LOCK_DIRECTORY, 0700) < 0) {
+						condlog(0, "%s: couldn't create lock directory", CONFIGURE_LOCK_DI=
RECTORY);
+						goto fail;
+					}
+					pp->lock_fd =3D open(pp->lock_path, O_RDWR | O_CREAT, 0600);
+				}
+				if (pp->lock_fd < 0) {
+					condlog(0, "%s: couldn't open lock file", pp->lock_path);
+					goto fail;
+				}
+			}
+			if (lock && flock(pp->lock_fd, LOCK_EX | LOCK_NB) &&
 			    errno =3D=3D EWOULDBLOCK)
 				goto fail;
-			else if (!lock)
-				flock(pp->fd, LOCK_UN);
+			else if (!lock && pp->lock_fd >=3D 0) {
+				flock(pp->lock_fd, LOCK_UN);
+				close(pp->lock_fd);
+				pp->lock_fd =3D -1;
+			}
 		}
 	}
 	return 0;
@@ -559,7 +598,10 @@ fail:
 		vector_foreach_slot(pgp->paths, pp, y) {
 			if (x =3D=3D i && y >=3D j)
 				return 1;
-			flock(pp->fd, LOCK_UN);
+			/* don't close the lock fd in failure case, we will want
+			 * to retry later */
+			if (pp->lock_fd >=3D 0)
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
=20
+#define CONFIGURE_LOCK_DIRECTORY     "/run/lock/multipath"
+
 int setup_map (struct multipath * mpp, char * params, int params_size );=

 int domap (struct multipath * mpp, char * params);
 int reinstate_paths (struct multipath *mpp);
diff --git a/libmultipath/structs.c b/libmultipath/structs.c
index 0538327..ca7bcb5 100644
--- a/libmultipath/structs.c
+++ b/libmultipath/structs.c
@@ -95,6 +95,7 @@ alloc_path (void)
 		pp->sg_id.scsi_id =3D -1;
 		pp->sg_id.lun =3D -1;
 		pp->fd =3D -1;
+		pp->lock_fd =3D -1;
 		pp->priority =3D PRIO_UNDEF;
 	}
 	return pp;
@@ -115,6 +116,12 @@ free_path (struct path * pp)
 	if (pp->fd >=3D 0)
 		close(pp->fd);
=20
+	if (pp->lock_fd >=3D 0)
+		close(pp->lock_fd);
+
+	if (pp->lock_path)
+		free(pp->lock_path);
+
 	if (pp->udev) {
 		udev_device_unref(pp->udev);
 		pp->udev =3D NULL;
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index c1fce04..916aea5 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -204,6 +204,9 @@ struct path {
=20
 	/* configlet pointers */
 	struct hwentry * hwe;
+
+	int lock_fd;
+	char * lock_path;
 };
=20
 typedef int (pgpolicyfn) (struct multipath *);
--=20
2.1.4


--------------040209010206040107060700
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------040209010206040107060700--
