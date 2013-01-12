From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH V3 10/18] multipath: rely on udev device creation
	for kpartx
Date: Sat, 12 Jan 2013 00:04:47 -0600
Message-ID: <1357970695-3396-10-git-send-email-bmarzins@redhat.com>
References: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1357970695-3396-1-git-send-email-bmarzins@redhat.com>
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
Cc: Christophe Varoqui <christophe.varoqui@gmail.com>
List-Id: dm-devel.ids

Since kpartx and multipathd don't wait on udev creating the device, there
was a race between libdevmapper and udev to create the device. This meant
that sometimes the /dev/mapper/ devices were devnodes, and sometimes they
were symlinks. Now, for multipathd and kpartx called without -s,
libdevmapper won't create the device nodes, so that udev will always be
responsible for it.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/devmapper.c       | 4 ++--
 kpartx/devmapper.h       | 2 ++
 kpartx/kpartx.c          | 6 +++---
 libmultipath/devmapper.c | 6 +++---
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 4baebd9..24a43ee 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -78,7 +78,7 @@ dm_simplecmd (int task, const char *name, int no_flush, uint32_t *cookie) {
 	if (no_flush)
 		dm_task_no_flush(dmt);
 
-	if (udev_wait_flag && !dm_task_set_cookie(dmt, cookie, 0))
+	if (udev_wait_flag && !dm_task_set_cookie(dmt, cookie, (udev_sync)? 0 : DM_UDEV_DISABLE_LIBRARY_FALLBACK))
 		goto out;
 	r = dm_task_run(dmt);
 
@@ -128,7 +128,7 @@ dm_addmap (int task, const char *name, const char *target,
 
 	dm_task_no_open_count(dmt);
 
-	if (task == DM_DEVICE_CREATE && !dm_task_set_cookie(dmt, cookie, 0))
+	if (task == DM_DEVICE_CREATE && !dm_task_set_cookie(dmt, cookie, (udev_sync)? 0 : DM_UDEV_DISABLE_LIBRARY_FALLBACK))
 		goto addout;
 	r = dm_task_run (dmt);
 
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index 8e350a0..0edc063 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -2,6 +2,8 @@
 #define MINOR(dev)      ((dev & 0xff) | ((dev >> 12) & 0xfff00))
 #define MKDEV(ma,mi)    ((mi & 0xff) | (ma << 8) | ((mi & ~0xff) << 12))
 
+extern int udev_sync;
+
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *, int, uint32_t *);
 int dm_addmap (int, const char *, const char *, const char *, uint64_t,
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index f359afe..dd57294 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -56,6 +56,7 @@ struct pt {
 } pts[MAXTYPES];
 
 int ptct = 0;
+int udev_sync = 0;
 
 static void
 addpts(char *t, ptreader f)
@@ -205,7 +206,6 @@ main(int argc, char **argv){
 	int loopro = 0;
 	int hotplug = 0;
 	int loopcreated = 0;
-	int sync = 0;
 	struct stat buf;
 	uint32_t cookie = 0;
 
@@ -267,7 +267,7 @@ main(int argc, char **argv){
 			what = DELETE;
 			break;
 		case 's':
-			sync = 1;
+			udev_sync = 1;
 			break;
 		case 'u':
 			what = UPDATE;
@@ -278,7 +278,7 @@ main(int argc, char **argv){
 	}
 
 #ifdef LIBDM_API_COOKIE
-	if (!sync)
+	if (!udev_sync)
 		dm_udev_set_sync_support(0);
 #endif
 
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index f474e97..67481c4 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -219,7 +219,7 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync) {
 		dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
 #endif
 
-	if (udev_wait_flag && !dm_task_set_cookie(dmt, &conf->cookie, 0))
+	if (udev_wait_flag && !dm_task_set_cookie(dmt, &conf->cookie, (conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0))
 		goto out;
 	r = dm_task_run (dmt);
 
@@ -284,7 +284,7 @@ dm_addmap (int task, const char *target, struct multipath *mpp, char * params,
 	dm_task_no_open_count(dmt);
 
 	if (task == DM_DEVICE_CREATE &&
-	    !dm_task_set_cookie(dmt, &conf->cookie, 0))
+	    !dm_task_set_cookie(dmt, &conf->cookie, (conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0))
 		goto freeout;
 	r = dm_task_run (dmt);
 
@@ -1268,7 +1268,7 @@ dm_rename (char * old, char * new)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_set_cookie(dmt, &conf->cookie, 0))
+	if (!dm_task_set_cookie(dmt, &conf->cookie, (conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0))
 		goto out;
 	if (!dm_task_run(dmt))
 		goto out;
-- 
1.8.0
