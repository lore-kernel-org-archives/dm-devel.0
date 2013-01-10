From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH v2] multipath: rely on udev device creation for
	kpartx and	multipathd
Date: Thu, 10 Jan 2013 14:49:33 -0600
Message-ID: <20130110204933.GV19059@ether.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
 kpartx/devmapper.c       |    4 ++--
 kpartx/devmapper.h       |    2 ++
 kpartx/kpartx.c          |    6 +++---
 libmultipath/devmapper.c |    6 +++---
 4 files changed, 10 insertions(+), 8 deletions(-)

Index: multipath-tools-130109/libmultipath/devmapper.c
===================================================================
--- multipath-tools-130109.orig/libmultipath/devmapper.c
+++ multipath-tools-130109/libmultipath/devmapper.c
@@ -219,7 +219,7 @@ dm_simplecmd (int task, const char *name
 		dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
 #endif
 
-	if (udev_wait_flag && !dm_task_set_cookie(dmt, &conf->cookie, 0))
+	if (udev_wait_flag && !dm_task_set_cookie(dmt, &conf->cookie, (conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0))
 		goto out;
 	r = dm_task_run (dmt);
 
@@ -284,7 +284,7 @@ dm_addmap (int task, const char *target,
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
Index: multipath-tools-130109/kpartx/devmapper.c
===================================================================
--- multipath-tools-130109.orig/kpartx/devmapper.c
+++ multipath-tools-130109/kpartx/devmapper.c
@@ -78,7 +78,7 @@ dm_simplecmd (int task, const char *name
 	if (no_flush)
 		dm_task_no_flush(dmt);
 
-	if (udev_wait_flag && !dm_task_set_cookie(dmt, cookie, 0))
+	if (udev_wait_flag && !dm_task_set_cookie(dmt, cookie, (udev_sync)? 0 : DM_UDEV_DISABLE_LIBRARY_FALLBACK))
 		goto out;
 	r = dm_task_run(dmt);
 
@@ -128,7 +128,7 @@ dm_addmap (int task, const char *name, c
 
 	dm_task_no_open_count(dmt);
 
-	if (task == DM_DEVICE_CREATE && !dm_task_set_cookie(dmt, cookie, 0))
+	if (task == DM_DEVICE_CREATE && !dm_task_set_cookie(dmt, cookie, (udev_sync)? 0 : DM_UDEV_DISABLE_LIBRARY_FALLBACK))
 		goto addout;
 	r = dm_task_run (dmt);
 
Index: multipath-tools-130109/kpartx/devmapper.h
===================================================================
--- multipath-tools-130109.orig/kpartx/devmapper.h
+++ multipath-tools-130109/kpartx/devmapper.h
@@ -2,6 +2,8 @@
 #define MINOR(dev)      ((dev & 0xff) | ((dev >> 12) & 0xfff00))
 #define MKDEV(ma,mi)    ((mi & 0xff) | (ma << 8) | ((mi & ~0xff) << 12))
 
+extern int udev_sync;
+
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *, int, uint32_t *);
 int dm_addmap (int, const char *, const char *, const char *, uint64_t,
Index: multipath-tools-130109/kpartx/kpartx.c
===================================================================
--- multipath-tools-130109.orig/kpartx/kpartx.c
+++ multipath-tools-130109/kpartx/kpartx.c
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
 
