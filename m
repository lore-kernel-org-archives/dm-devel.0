From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] multipath: add udev sync support.
Date: Mon, 17 May 2010 14:03:38 -0500
Message-ID: <20100517190338.GO3295@ether.msp.redhat.com>
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
List-Id: dm-devel.ids

device-mapper in now able to synchronize operations through udev.  This patch
allows multipath and kpartx to make use of this feature. If kpartx is run with
"-s", it waits for the partitions to be created before returning. Multipath
will now always wait for the devices to be created before returning.

This feature requires dm_task_set_cookie() which was finalized in device-mapper
version 1.2.38

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/devmapper.c       |   10 ++++++++--
 kpartx/devmapper.h       |    4 ++--
 kpartx/kpartx.c          |   28 ++++++++++++++++++++--------
 libmultipath/config.h    |    2 ++
 libmultipath/configure.c |    2 +-
 libmultipath/devmapper.c |   31 ++++++++++++++++++++-----------
 libmultipath/devmapper.h |    8 +++++---
 multipath/main.c         |    1 +
 multipathd/main.c        |    1 +
 9 files changed, 60 insertions(+), 27 deletions(-)

Index: multipath-tools-100510/kpartx/devmapper.c
===================================================================
--- multipath-tools-100510.orig/kpartx/devmapper.c
+++ multipath-tools-100510/kpartx/devmapper.c
@@ -52,8 +52,10 @@ dm_prereq (char * str, int x, int y, int
 }
 
 extern int
-dm_simplecmd (int task, const char *name, int no_flush) {
+dm_simplecmd (int task, const char *name, int no_flush, uint32_t *cookie) {
 	int r = 0;
+	int udev_wait_flag = (task == DM_DEVICE_RESUME ||
+			      task == DM_DEVICE_REMOVE);
 	struct dm_task *dmt;
 
 	if (!(dmt = dm_task_create(task)))
@@ -68,6 +70,8 @@ dm_simplecmd (int task, const char *name
 	if (no_flush)
 		dm_task_no_flush(dmt);
 
+	if (udev_wait_flag && !dm_task_set_cookie(dmt, cookie, 0))
+		goto out;
 	r = dm_task_run(dmt);
 
 	out:
@@ -78,7 +82,7 @@ dm_simplecmd (int task, const char *name
 extern int
 dm_addmap (int task, const char *name, const char *target,
 	   const char *params, uint64_t size, const char *uuid, int part,
-	   mode_t mode, uid_t uid, gid_t gid) {
+	   mode_t mode, uid_t uid, gid_t gid, uint32_t *cookie) {
 	int r = 0;
 	struct dm_task *dmt;
 	char *prefixed_uuid = NULL;
@@ -113,6 +117,8 @@ dm_addmap (int task, const char *name, c
 
 	dm_task_no_open_count(dmt);
 
+	if (task == DM_DEVICE_CREATE && !dm_task_set_cookie(dmt, cookie, 0))
+		goto addout;
 	r = dm_task_run (dmt);
 
 	addout:
Index: multipath-tools-100510/kpartx/kpartx.c
===================================================================
--- multipath-tools-100510.orig/kpartx/kpartx.c
+++ multipath-tools-100510/kpartx/kpartx.c
@@ -82,7 +82,7 @@ initpts(void)
 	addpts("sun", read_sun_pt);
 }
 
-static char short_opts[] = "ladgvp:t:";
+static char short_opts[] = "ladgvp:t:s";
 
 /* Used in gpt.c */
 int force_gpt=0;
@@ -96,6 +96,7 @@ usage(void) {
 	printf("\t-p set device name-partition number delimiter\n");
 	printf("\t-g force GUID partition table (GPT)\n");
 	printf("\t-v verbose\n");
+	printf("\t-s sync mode. Don't return until the partitions are created\n");
 	return 1;
 }
 
@@ -198,7 +199,9 @@ main(int argc, char **argv){
 	int loopro = 0;
 	int hotplug = 0;
 	int loopcreated = 0;
+	int sync = 0;
 	struct stat buf;
+	uint32_t cookie = 0;
 
 	initpts();
 	init_crc32();
@@ -251,11 +254,17 @@ main(int argc, char **argv){
 		case 'd':
 			what = DELETE;
 			break;
+		case 's':
+			sync = 1;
+			break;
 		default:
 			usage();
 			exit(1);
 	}
 
+	if (!sync)
+		dm_udev_set_sync_support(0);
+
 	if (dm_prereq(DM_TARGET, 0, 0, 0) && (what == ADD || what == DELETE)) {
 		fprintf(stderr, "device mapper prerequisites not met\n");
 		exit(1);
@@ -413,8 +422,8 @@ main(int argc, char **argv){
 				if (!slices[j].size || !dm_map_present(partname))
 					continue;
 
-				if (!dm_simplecmd(DM_DEVICE_REMOVE,
-							partname, 0)) {
+				if (!dm_simplecmd(DM_DEVICE_REMOVE, partname,
+						  0, &cookie)) {
 					r++;
 					continue;
 				}
@@ -463,14 +472,14 @@ main(int argc, char **argv){
 				if (!dm_addmap(op, partname, DM_TARGET, params,
 					       slices[j].size, uuid, j+1,
 					       buf.st_mode & 0777, buf.st_uid,
-					       buf.st_gid)) {
+					       buf.st_gid, &cookie)) {
 					fprintf(stderr, "create/reload failed on %s\n",
 						partname);
 					r++;
 				}
 				if (op == DM_DEVICE_RELOAD &&
-				    !dm_simplecmd(DM_DEVICE_RESUME,
-							partname, 1)) {
+				    !dm_simplecmd(DM_DEVICE_RESUME, partname,
+						  1, &cookie)) {
 					fprintf(stderr, "resume failed on %s\n",
 						partname);
 					r++;
@@ -529,11 +538,13 @@ main(int argc, char **argv){
 					dm_addmap(op, partname, DM_TARGET, params,
 						  slices[j].size, uuid, j+1,
 						  buf.st_mode & 0777,
-						  buf.st_uid, buf.st_gid);
+						  buf.st_uid, buf.st_gid,
+						  &cookie);
 
 					if (op == DM_DEVICE_RELOAD)
 						dm_simplecmd(DM_DEVICE_RESUME,
-							     partname, 1);
+							     partname, 1,
+							     &cookie);
 
 					dm_devn(partname, &slices[j].major,
 						&slices[j].minor);
@@ -557,6 +568,7 @@ main(int argc, char **argv){
 		if (n > 0)
 			break;
 	}
+	dm_udev_wait(cookie);
 	dm_lib_release();
 	dm_lib_exit();
 
Index: multipath-tools-100510/kpartx/devmapper.h
===================================================================
--- multipath-tools-100510.orig/kpartx/devmapper.h
+++ multipath-tools-100510/kpartx/devmapper.h
@@ -3,9 +3,9 @@
 #define MKDEV(ma,mi)    ((mi & 0xff) | (ma << 8) | ((mi & ~0xff) << 12))
 
 int dm_prereq (char *, int, int, int);
-int dm_simplecmd (int, const char *, int);
+int dm_simplecmd (int, const char *, int, uint32_t *);
 int dm_addmap (int, const char *, const char *, const char *, uint64_t,
-	       const char *, int, mode_t, uid_t, gid_t);
+	       const char *, int, mode_t, uid_t, gid_t, uint32_t *);
 int dm_map_present (char *);
 char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
Index: multipath-tools-100510/libmultipath/config.h
===================================================================
--- multipath-tools-100510.orig/libmultipath/config.h
+++ multipath-tools-100510/libmultipath/config.h
@@ -2,6 +2,7 @@
 #define _CONFIG_H
 
 #include <sys/types.h>
+#include <stdint.h>
 
 #define ORIGIN_DEFAULT 0
 #define ORIGIN_CONFIG  1
@@ -83,6 +84,7 @@ struct config {
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
+	uint32_t cookie;
 
 	char * dev;
 	char * sysfs_dir;
Index: multipath-tools-100510/libmultipath/devmapper.c
===================================================================
--- multipath-tools-100510.orig/libmultipath/devmapper.c
+++ multipath-tools-100510/libmultipath/devmapper.c
@@ -77,7 +77,7 @@ dm_libprereq (void)
 {
 	char version[64];
 	int v[3];
-	int minv[3] = {1, 2, 8};
+	int minv[3] = {1, 2, 38};
 
 	dm_get_library_version(version, sizeof(version));
 	condlog(3, "libdevmapper version %s", version);
@@ -149,8 +149,10 @@ dm_prereq (void)
 }
 
 static int
-dm_simplecmd (int task, const char *name, int no_flush) {
+dm_simplecmd (int task, const char *name, int no_flush, int need_sync) {
 	int r = 0;
+	int udev_wait_flag = (need_sync && (task == DM_DEVICE_RESUME ||
+					    task == DM_DEVICE_REMOVE));
 	struct dm_task *dmt;
 
 	if (!(dmt = dm_task_create (task)))
@@ -166,6 +168,8 @@ dm_simplecmd (int task, const char *name
 		dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
 #endif
 
+	if (udev_wait_flag && !dm_task_set_cookie(dmt, &conf->cookie, 0))
+		goto out;
 	r = dm_task_run (dmt);
 
 	out:
@@ -174,13 +178,13 @@ dm_simplecmd (int task, const char *name
 }
 
 extern int
-dm_simplecmd_flush (int task, const char *name) {
-	return dm_simplecmd(task, name, 0);
+dm_simplecmd_flush (int task, const char *name, int needsync) {
+	return dm_simplecmd(task, name, 0, needsync);
 }
 
 extern int
 dm_simplecmd_noflush (int task, const char *name) {
-	return dm_simplecmd(task, name, 1);
+	return dm_simplecmd(task, name, 1, 1);
 }
 
 extern int
@@ -226,6 +230,9 @@ dm_addmap (int task, const char *target,
 
 	dm_task_no_open_count(dmt);
 
+	if (task == DM_DEVICE_CREATE &&
+	    !dm_task_set_cookie(dmt, &conf->cookie, 0))
+		goto freeout;
 	r = dm_task_run (dmt);
 
 	freeout:
@@ -249,7 +256,7 @@ _dm_addmap_create (struct multipath *mpp
 	if (!r && dm_map_present(mpp->alias)) {
 		condlog(3, "%s: failed to load map (a path might be in use)",
 			mpp->alias);
-		dm_flush_map(mpp->alias);
+		dm_flush_map_nosync(mpp->alias);
 	}
 	return r;
 }
@@ -529,7 +536,7 @@ out:
 }
 
 extern int
-dm_flush_map (const char * mapname)
+_dm_flush_map (const char * mapname, int need_sync)
 {
 	int r;
 
@@ -539,7 +546,7 @@ dm_flush_map (const char * mapname)
 	if (dm_type(mapname, TGT_MPATH) <= 0)
 		return 0; /* nothing to do */
 
-	if (dm_remove_partmaps(mapname))
+	if (dm_remove_partmaps(mapname, need_sync))
 		return 1;
 
 	if (dm_get_opencount(mapname)) {
@@ -547,7 +554,7 @@ dm_flush_map (const char * mapname)
 		return 1;
 	}
 
-	r = dm_simplecmd_flush(DM_DEVICE_REMOVE, mapname);
+	r = dm_simplecmd_flush(DM_DEVICE_REMOVE, mapname, need_sync);
 
 	if (r) {
 		condlog(4, "multipath map %s removed", mapname);
@@ -883,7 +890,7 @@ bad:
 }
 
 int
-dm_remove_partmaps (const char * mapname)
+dm_remove_partmaps (const char * mapname, int need_sync)
 {
 	struct dm_task *dmt;
 	struct dm_names *names;
@@ -946,7 +953,7 @@ dm_remove_partmaps (const char * mapname
 				 */
 				condlog(4, "partition map %s removed",
 					names->name);
-				dm_simplecmd_flush(DM_DEVICE_REMOVE, names->name);
+				dm_simplecmd_flush(DM_DEVICE_REMOVE, names->name, need_sync);
 		   }
 
 		next = names->next;
@@ -1102,6 +1109,8 @@ dm_rename (char * old, char * new)
 
 	dm_task_no_open_count(dmt);
 
+	if (!dm_task_set_cookie(dmt, &conf->cookie, 0))
+		goto out;
 	if (!dm_task_run(dmt))
 		goto out;
 
Index: multipath-tools-100510/libmultipath/devmapper.h
===================================================================
--- multipath-tools-100510.orig/libmultipath/devmapper.h
+++ multipath-tools-100510/libmultipath/devmapper.h
@@ -8,7 +8,7 @@
 
 void dm_init(void);
 int dm_prereq (void);
-int dm_simplecmd_flush (int, const char *);
+int dm_simplecmd_flush (int, const char *, int);
 int dm_simplecmd_noflush (int, const char *);
 int dm_addmap_create (struct multipath *mpp);
 int dm_addmap_create_ro (struct multipath *mpp);
@@ -18,7 +18,9 @@ int dm_map_present (const char *);
 int dm_get_map(char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
 int dm_type(const char *, char *);
-int dm_flush_map (const char *);
+int _dm_flush_map (const char *, int);
+#define dm_flush_map(mapname) _dm_flush_map(mapname, 1)
+#define dm_flush_map_nosync(mapname) _dm_flush_map(mapname, 0)
 int dm_flush_maps (void);
 int dm_fail_path(char * mapname, char * path);
 int dm_reinstate_path(char * mapname, char * path);
@@ -31,7 +33,7 @@ int dm_get_maps (vector mp);
 int dm_geteventnr (char *name);
 int dm_get_minor (char *name);
 char * dm_mapname(int major, int minor);
-int dm_remove_partmaps (const char * mapname);
+int dm_remove_partmaps (const char * mapname, int need_sync);
 int dm_get_uuid(char *name, char *uuid);
 int dm_get_info (char * mapname, struct dm_info ** dmi);
 int dm_rename (char * old, char * new);
Index: multipath-tools-100510/multipath/main.c
===================================================================
--- multipath-tools-100510.orig/multipath/main.c
+++ multipath-tools-100510/multipath/main.c
@@ -454,6 +454,7 @@ main (int argc, char *argv[])
 		condlog(3, "restart multipath configuration process");
 	
 out:
+	dm_udev_wait(conf->cookie);
 
 	sysfs_cleanup();
 	dm_lib_release();
Index: multipath-tools-100510/multipathd/main.c
===================================================================
--- multipath-tools-100510.orig/multipathd/main.c
+++ multipath-tools-100510/multipathd/main.c
@@ -1411,6 +1411,7 @@ child (void * param)
 		exit(1);
 	}
 	conf->daemon = 1;
+	dm_udev_set_sync_support(0);
 	/*
 	 * fetch and configure both paths and multipaths
 	 */
Index: multipath-tools-100510/libmultipath/configure.c
===================================================================
--- multipath-tools-100510.orig/libmultipath/configure.c
+++ multipath-tools-100510/libmultipath/configure.c
@@ -373,7 +373,7 @@ domap (struct multipath * mpp)
   		if (!r)
   			r = dm_addmap_reload_ro(mpp);
   		if (r)
-  			r = dm_simplecmd_flush(DM_DEVICE_RESUME, mpp->alias);
+  			r = dm_simplecmd_flush(DM_DEVICE_RESUME, mpp->alias, 1);
 		break;
 
 	case ACT_RENAME:
