From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 43/78] Fixup device-mapper 'cookie' handling
Date: Mon, 16 Mar 2015 13:36:30 +0100
Message-ID: <1426509425-15978-44-git-send-email-hare@suse.de>
References: <1426509425-15978-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1426509425-15978-1-git-send-email-hare@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christophe Varoqui <christophe.varoqui@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

device-mapper has a 'cookie', which is inserted with the ioctl
for modifying device-mapper devices.
It is used as a synchronization point between udev and any other
applications to notify the latter when udev has finished
processing the event.
Originally multipath would only use a single cookie for every
transaction, and wait for that cookie at the end of the program.
Which works well if you only have one transaction, but for several
(like calling 'multipath') it will actually overwrite the cookie
and fail to wait for earlier events.
This causes libdevmapper to create the device nodes on its own,
and the device nodes not being handled by udev.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 kpartx/devmapper.c        | 53 +++++++++++++++++++++++++++++++++++------------
 kpartx/devmapper.h        |  4 ++--
 kpartx/kpartx.c           | 22 +++++++++-----------
 libmultipath/config.h     |  1 -
 libmultipath/configure.c  |  5 +++--
 libmultipath/devmapper.c  | 48 +++++++++++++++++++++++++++++++-----------
 libmultipath/devmapper.h  |  2 +-
 multipath/main.c          |  2 --
 multipathd/cli_handlers.c |  4 ++--
 9 files changed, 94 insertions(+), 47 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index a3272d4..82be990 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -14,13 +14,6 @@
 #define MAX_PREFIX_LEN 8
 #define PARAMS_SIZE 1024
 
-#ifndef LIBDM_API_COOKIE
-static inline int dm_task_set_cookie(struct dm_task *dmt, uint32_t *c, int a)
-{
-	return 1;
-}
-#endif
-
 extern int
 dm_prereq (char * str, int x, int y, int z)
 {
@@ -60,10 +53,13 @@ dm_prereq (char * str, int x, int y, int z)
 }
 
 extern int
-dm_simplecmd (int task, const char *name, int no_flush, uint32_t *cookie, uint16_t udev_flags) {
+dm_simplecmd (int task, const char *name, int no_flush, uint16_t udev_flags) {
 	int r = 0;
 	int udev_wait_flag = (task == DM_DEVICE_RESUME ||
 			      task == DM_DEVICE_REMOVE);
+#ifdef LIBDM_API_COOKIE
+	uint32_t cookie = 0;
+#endif
 	struct dm_task *dmt;
 
 	if (!(dmt = dm_task_create(task)))
@@ -78,10 +74,23 @@ dm_simplecmd (int task, const char *name, int no_flush, uint32_t *cookie, uint16
 	if (no_flush)
 		dm_task_no_flush(dmt);
 
-	if (udev_wait_flag && !dm_task_set_cookie(dmt, cookie, ((udev_sync)? 0 : DM_UDEV_DISABLE_LIBRARY_FALLBACK) | udev_flags))
+#ifdef LIBDM_API_COOKIE
+	if (!udev_sync)
+		udev_flags |= DM_UDEV_DISABLE_LIBRARY_FALLBACK;
+	if (udev_wait_flag && !dm_task_set_cookie(dmt, &cookie, udev_flags)) {
+		dm_udev_complete(cookie);
 		goto out;
+	}
+#endif
 	r = dm_task_run(dmt);
-
+#ifdef LIBDM_API_COOKIE
+	if (udev_wait_flag) {
+		if (!r)
+			dm_udev_complete(cookie);
+		else
+			dm_udev_wait(cookie);
+	}
+#endif
 	out:
 	dm_task_destroy(dmt);
 	return r;
@@ -90,10 +99,14 @@ dm_simplecmd (int task, const char *name, int no_flush, uint32_t *cookie, uint16
 extern int
 dm_addmap (int task, const char *name, const char *target,
 	   const char *params, uint64_t size, int ro, const char *uuid, int part,
-	   mode_t mode, uid_t uid, gid_t gid, uint32_t *cookie) {
+	   mode_t mode, uid_t uid, gid_t gid) {
 	int r = 0;
 	struct dm_task *dmt;
 	char *prefixed_uuid = NULL;
+#ifdef LIBDM_API_COOKIE
+	uint32_t cookie = 0;
+	uint16_t udev_flags = 0;
+#endif
 
 	if (!(dmt = dm_task_create (task)))
 		return 0;
@@ -128,10 +141,24 @@ dm_addmap (int task, const char *name, const char *target,
 
 	dm_task_no_open_count(dmt);
 
-	if (task == DM_DEVICE_CREATE && !dm_task_set_cookie(dmt, cookie, (udev_sync)? 0 : DM_UDEV_DISABLE_LIBRARY_FALLBACK))
+#ifdef LIBDM_API_COOKIE
+	if (!udev_sync)
+		udev_flags = DM_UDEV_DISABLE_LIBRARY_FALLBACK;
+	if (task == DM_DEVICE_CREATE &&
+	    !dm_task_set_cookie(dmt, &cookie, udev_flags)) {
+		dm_udev_complete(cookie);
 		goto addout;
+	}
+#endif
 	r = dm_task_run (dmt);
-
+#ifdef LIBDM_API_COOKIE
+	if (task == DM_DEVICE_CREATE) {
+		if (!r)
+			dm_udev_complete(cookie);
+		else
+			dm_udev_wait(cookie);
+	}
+#endif
 addout:
 	dm_task_destroy (dmt);
 	free(prefixed_uuid);
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index 4b867df..ac1d5d9 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -10,9 +10,9 @@
 extern int udev_sync;
 
 int dm_prereq (char *, int, int, int);
-int dm_simplecmd (int, const char *, int, uint32_t *, uint16_t);
+int dm_simplecmd (int, const char *, int, uint16_t);
 int dm_addmap (int, const char *, const char *, const char *, uint64_t,
-	       int, const char *, int, mode_t, uid_t, gid_t, uint32_t *);
+	       int, const char *, int, mode_t, uid_t, gid_t);
 int dm_map_present (char *);
 char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index 18c1d23..d69f9af 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -208,7 +208,6 @@ main(int argc, char **argv){
 	int hotplug = 0;
 	int loopcreated = 0;
 	struct stat buf;
-	uint32_t cookie = 0;
 
 	initpts();
 	init_crc32();
@@ -281,6 +280,8 @@ main(int argc, char **argv){
 #ifdef LIBDM_API_COOKIE
 	if (!udev_sync)
 		dm_udev_set_sync_support(0);
+	else
+		dm_udev_set_sync_support(1);
 #endif
 
 	if (dm_prereq(DM_TARGET, 0, 0, 0) && (what == ADD || what == DELETE || what == UPDATE)) {
@@ -437,7 +438,7 @@ main(int argc, char **argv){
 					continue;
 
 				if (!dm_simplecmd(DM_DEVICE_REMOVE, partname,
-						  0, &cookie, 0)) {
+						  0, 0)) {
 					r++;
 					continue;
 				}
@@ -488,18 +489,19 @@ main(int argc, char **argv){
 				if (!dm_addmap(op, partname, DM_TARGET, params,
 					       slices[j].size, ro, uuid, j+1,
 					       buf.st_mode & 0777, buf.st_uid,
-					       buf.st_gid, &cookie)) {
+					       buf.st_gid)) {
 					fprintf(stderr, "create/reload failed on %s\n",
 						partname);
 					r++;
 				}
 				if (op == DM_DEVICE_RELOAD &&
 				    !dm_simplecmd(DM_DEVICE_RESUME, partname,
-						  1, &cookie, MPATH_UDEV_RELOAD_FLAG)) {
+						  1, MPATH_UDEV_RELOAD_FLAG)) {
 					fprintf(stderr, "resume failed on %s\n",
 						partname);
 					r++;
 				}
+
 				dm_devn(partname, &slices[j].major,
 					&slices[j].minor);
 
@@ -551,14 +553,12 @@ main(int argc, char **argv){
 					dm_addmap(op, partname, DM_TARGET, params,
 						  slices[j].size, ro, uuid, j+1,
 						  buf.st_mode & 0777,
-						  buf.st_uid, buf.st_gid,
-						  &cookie);
+						  buf.st_uid, buf.st_gid);
 
 					if (op == DM_DEVICE_RELOAD)
 						dm_simplecmd(DM_DEVICE_RESUME,
 							     partname, 1,
-							     &cookie, MPATH_UDEV_RELOAD_FLAG);
-
+							     MPATH_UDEV_RELOAD_FLAG);
 					dm_devn(partname, &slices[j].major,
 						&slices[j].minor);
 
@@ -590,7 +590,7 @@ main(int argc, char **argv){
 					continue;
 
 				if (!dm_simplecmd(DM_DEVICE_REMOVE,
-						  partname, 1, &cookie, 0)) {
+						  partname, 1, 0)) {
 					r++;
 					continue;
 				}
@@ -616,9 +616,7 @@ main(int argc, char **argv){
 		}
 		printf("loop deleted : %s\n", device);
 	}
-#ifdef LIBDM_API_COOKIE
-	dm_udev_wait(cookie);
-#endif
+
 	dm_lib_release();
 	dm_lib_exit();
 
diff --git a/libmultipath/config.h b/libmultipath/config.h
index d304a6c..eff127e 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -127,7 +127,6 @@ struct config {
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
-	uint32_t cookie;
 	int reassign_maps;
 	int retain_hwhandler;
 	int detect_prio;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 2465563..3c230a1 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -623,7 +623,8 @@ domap (struct multipath * mpp, char * params)
 	case ACT_RELOAD:
 		r = dm_addmap_reload(mpp, params);
 		if (r)
-			r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, MPATH_UDEV_RELOAD_FLAG);
+			r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias,
+						 0, MPATH_UDEV_RELOAD_FLAG);
 		break;
 
 	case ACT_RESIZE:
@@ -641,7 +642,7 @@ domap (struct multipath * mpp, char * params)
 		if (r) {
 			r = dm_addmap_reload(mpp, params);
 			if (r)
-				r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, MPATH_UDEV_RELOAD_FLAG);
+				r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias, 0, MPATH_UDEV_RELOAD_FLAG);
 		}
 		break;
 
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 1901052..f0b0da1 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -216,6 +216,7 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 	int r = 0;
 	int udev_wait_flag = (need_sync && (task == DM_DEVICE_RESUME ||
 					    task == DM_DEVICE_REMOVE));
+	uint32_t cookie = 0;
 	struct dm_task *dmt;
 
 	if (!(dmt = dm_task_create (task)))
@@ -234,10 +235,18 @@ dm_simplecmd (int task, const char *name, int no_flush, int need_sync, uint16_t
 	if (do_deferred(deferred_remove))
 		dm_task_deferred_remove(dmt);
 #endif
-	if (udev_wait_flag && !dm_task_set_cookie(dmt, &conf->cookie, ((conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0) | udev_flags))
+	if (udev_wait_flag && !dm_task_set_cookie(dmt, &cookie, ((conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0) | udev_flags)) {
+		dm_udev_complete(cookie);
 		goto out;
+	}
 	r = dm_task_run (dmt);
 
+	if (udev_wait_flag) {
+		if (!r)
+			dm_udev_complete(cookie);
+		else
+			udev_wait(cookie);
+	}
 	out:
 	dm_task_destroy (dmt);
 	return r;
@@ -249,8 +258,8 @@ dm_simplecmd_flush (int task, const char *name, int needsync, uint16_t udev_flag
 }
 
 extern int
-dm_simplecmd_noflush (int task, const char *name, uint16_t udev_flags) {
-	return dm_simplecmd(task, name, 1, 1, udev_flags, 0);
+dm_simplecmd_noflush (int task, const char *name, int needsync, uint16_t udev_flags) {
+	return dm_simplecmd(task, name, 1, needsync, udev_flags, 0);
 }
 
 static int
@@ -265,6 +274,7 @@ dm_addmap (int task, const char *target, struct multipath *mpp, char * params,
 	int r = 0;
 	struct dm_task *dmt;
 	char *prefixed_uuid = NULL;
+	uint32_t cookie = 0;
 
 	if (!(dmt = dm_task_create (task)))
 		return 0;
@@ -305,10 +315,18 @@ dm_addmap (int task, const char *target, struct multipath *mpp, char * params,
 	dm_task_no_open_count(dmt);
 
 	if (task == DM_DEVICE_CREATE &&
-	    !dm_task_set_cookie(dmt, &conf->cookie, (conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0))
+	    !dm_task_set_cookie(dmt, &cookie, (conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0)) {
+		dm_udev_complete(cookie);
 		goto freeout;
+	}
 	r = dm_task_run (dmt);
 
+	if (task == DM_DEVICE_CREATE) {
+		if (!r)
+			dm_udev_complete(cookie);
+		else
+			udev_wait(cookie);
+	}
 	freeout:
 	if (prefixed_uuid)
 		FREE(prefixed_uuid);
@@ -326,7 +344,8 @@ dm_addmap_create (struct multipath *mpp, char * params) {
 	for (ro = 0; ro <= 1; ro++) {
 		int err;
 
-		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, params, 1, ro))
+		if (dm_addmap(DM_DEVICE_CREATE, TGT_MPATH,
+			      mpp, params, 1, ro))
 			return 1;
 		/*
 		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
@@ -755,14 +774,14 @@ dm_suspend_and_flush_map (const char * mapname)
 	if (s)
 		queue_if_no_path = 0;
 	else
-		s = dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 0, 0);
+		s = dm_simplecmd_flush(DM_DEVICE_SUSPEND, mapname, 1, 0);
 
 	if (!dm_flush_map(mapname)) {
 		condlog(4, "multipath map %s removed", mapname);
 		return 0;
 	}
 	condlog(2, "failed to remove multipath map %s", mapname);
-	dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, 0);
+	dm_simplecmd_noflush(DM_DEVICE_RESUME, mapname, 1, 0);
 	if (queue_if_no_path)
 		s = dm_queue_if_no_path((char *)mapname, 1);
 	return 1;
@@ -1312,6 +1331,7 @@ dm_rename (char * old, char * new)
 {
 	int r = 0;
 	struct dm_task *dmt;
+	uint32_t cookie;
 
 	if (dm_rename_partmaps(old, new))
 		return r;
@@ -1327,14 +1347,18 @@ dm_rename (char * old, char * new)
 
 	dm_task_no_open_count(dmt);
 
-	if (!dm_task_set_cookie(dmt, &conf->cookie, (conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0))
-		goto out;
-	if (!dm_task_run(dmt))
+	if (!dm_task_set_cookie(dmt, &cookie, (conf->daemon)? DM_UDEV_DISABLE_LIBRARY_FALLBACK : 0))
 		goto out;
+	r = dm_task_run(dmt);
+
+	if (!r)
+		dm_udev_complete(cookie);
+	else
+		udev_wait(cookie);
 
-	r = 1;
 out:
 	dm_task_destroy(dmt);
+
 	return r;
 }
 
@@ -1399,7 +1423,7 @@ int dm_reassign_table(const char *name, char *old, char *new)
 			condlog(3, "%s: failed to reassign targets", name);
 			goto out_reload;
 		}
-		dm_simplecmd_noflush(DM_DEVICE_RESUME, name, MPATH_UDEV_RELOAD_FLAG);
+		dm_simplecmd_noflush(DM_DEVICE_RESUME, name, 1, MPATH_UDEV_RELOAD_FLAG);
 	}
 	r = 1;
 
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 5c8c50d..8188f48 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -16,7 +16,7 @@ void dm_init(void);
 int dm_prereq (void);
 int dm_drv_version (unsigned int * version, char * str);
 int dm_simplecmd_flush (int, const char *, int, uint16_t);
-int dm_simplecmd_noflush (int, const char *, uint16_t);
+int dm_simplecmd_noflush (int, const char *, int, uint16_t);
 int dm_addmap_create (struct multipath *mpp, char *params);
 int dm_addmap_reload (struct multipath *mpp, char *params);
 int dm_map_present (const char *);
diff --git a/multipath/main.c b/multipath/main.c
index 1c1191a..c46a9f6 100644
--- a/multipath/main.c
+++ b/multipath/main.c
@@ -675,8 +675,6 @@ main (int argc, char *argv[])
 		condlog(3, "restart multipath configuration process");
 
 out:
-	udev_wait(conf->cookie);
-
 	dm_lib_release();
 	dm_lib_exit();
 
diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
index 6abe72a..772531e 100644
--- a/multipathd/cli_handlers.c
+++ b/multipathd/cli_handlers.c
@@ -839,7 +839,7 @@ cli_suspend(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	int r = dm_simplecmd_noflush(DM_DEVICE_SUSPEND, param, 0);
+	int r = dm_simplecmd_noflush(DM_DEVICE_SUSPEND, param, 0, 0);
 
 	param = convert_dev(param, 0);
 	condlog(2, "%s: suspend (operator)", param);
@@ -861,7 +861,7 @@ cli_resume(void * v, char ** reply, int * len, void * data)
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	int r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, 0);
+	int r = dm_simplecmd_noflush(DM_DEVICE_RESUME, param, 0, 0);
 
 	param = convert_dev(param, 0);
 	condlog(2, "%s: resume (operator)", param);
-- 
1.8.4.5
