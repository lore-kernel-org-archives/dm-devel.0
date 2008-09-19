From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/configure.c libmu ...
Date: 19 Sep 2008 03:27:10 -0000
Message-ID: <20080919032710.28653.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2008-09-19 03:27:08

Modified files:
	libmultipath   : configure.c configure.h devmapper.c devmapper.h 
	multipathd     : cli.c cli.h cli_handlers.c cli_handlers.h 
	                 main.c main.h 

Log message:
	Fix for bz #455692. There is now a command for multipathd, 'resize map'. This
	does online grows or shrinks for your multipath device. It has some warts.
	
	1. It needs to remove and re-add every path in the device. This can cause two
	annoyances. First, if you only have one valid path, you go into an all paths
	down scenario. However, you will immediately re-add the path, so it won't
	trigger problem #2. Second, if the path is inaccessable, you may not be able to
	re-add it.
	
	2. You can't disable flushing on suspend for a device-mapper device, when you
	want to change size. This means that if all your paths are down, you will fail
	the queued IOs when you suspend. This is a problem with the device-mapper kernel
	code, and there's no real way to avoid it, except by fixing it in the kernel.
	
	This commit also has some minor fixups for 238421, and adds the ability to
	disable and restore queueing on all multipath devices through multipathd

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.3&r2=1.2.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1&r2=1.1.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.22.2.5&r2=1.22.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.4&r2=1.11.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.2&r2=1.6.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/cli_handlers.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.2&r2=1.3.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.13&r2=1.69.2.14
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7&r2=1.7.2.1

--- multipath-tools/libmultipath/configure.c	2008/08/25 20:59:06	1.2.2.3
+++ multipath-tools/libmultipath/configure.c	2008/09/19 03:27:08	1.2.2.4
@@ -360,7 +360,16 @@
 			r = dm_addmap(DM_DEVICE_RELOAD, DEFAULT_TARGET, mpp, 0,
 				      1);
 		if (r)
-			r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias);
+			r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, 1);
+		break;
+
+	case ACT_RESIZE:
+		r = dm_addmap(DM_DEVICE_RELOAD, DEFAULT_TARGET, mpp, 0, 0);
+		if (!r)
+			r = dm_addmap(DM_DEVICE_RELOAD, DEFAULT_TARGET, mpp, 0,
+				      1);
+		if (r)
+			r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias, 0);
 		break;
 
 	case ACT_RENAME:
--- multipath-tools/libmultipath/configure.h	2006/06/06 18:46:38	1.1
+++ multipath-tools/libmultipath/configure.h	2008/09/19 03:27:08	1.1.2.1
@@ -15,7 +15,8 @@
 	ACT_RELOAD,
 	ACT_SWITCHPG,
 	ACT_RENAME,
-	ACT_CREATE
+	ACT_CREATE,
+	ACT_RESIZE,
 };
 
 #define FLUSH_ONE 1
--- multipath-tools/libmultipath/devmapper.c	2008/08/25 20:59:06	1.22.2.5
+++ multipath-tools/libmultipath/devmapper.c	2008/09/19 03:27:08	1.22.2.6
@@ -130,7 +130,7 @@
 }
 
 extern int
-dm_simplecmd (int task, const char *name) {
+dm_simplecmd (int task, const char *name, int no_flush) {
 	int r = 0;
 	struct dm_task *dmt;
 
@@ -142,7 +142,8 @@
 
 	dm_task_no_open_count(dmt);
 	dm_task_skip_lockfs(dmt);       /* for DM_DEVICE_RESUME */
-	dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
+	if (no_flush)
+		dm_task_no_flush(dmt);		/* for DM_DEVICE_SUSPEND/RESUME */
 
 	r = dm_task_run (dmt);
 
@@ -474,7 +475,7 @@
 		return 1;
 	}	
 
-	r = dm_simplecmd(DM_DEVICE_REMOVE, mapname);
+	r = dm_simplecmd(DM_DEVICE_REMOVE, mapname, 0);
 
 	if (r) {
 		condlog(4, "multipath map %s removed", mapname);
@@ -883,7 +884,7 @@
 				 */
 				condlog(4, "partition map %s removed",
 					names->name);
-				dm_simplecmd(DM_DEVICE_REMOVE, names->name);
+				dm_simplecmd(DM_DEVICE_REMOVE, names->name, 0);
 		   }
 
 		next = names->next;
--- multipath-tools/libmultipath/devmapper.h	2008/08/26 22:25:07	1.11.2.4
+++ multipath-tools/libmultipath/devmapper.h	2008/09/19 03:27:08	1.11.2.5
@@ -4,7 +4,7 @@
 
 void dm_init(void);
 int dm_prereq (char *, int, int, int);
-int dm_simplecmd (int, const char *);
+int dm_simplecmd (int, const char *, int);
 int dm_addmap (int, const char *, struct multipath *, int, int); 
 int dm_map_present (char *);
 int dm_get_map(char *, unsigned long long *, char *);
--- multipath-tools/multipathd/cli.c	2008/09/04 20:09:48	1.5.2.2
+++ multipath-tools/multipathd/cli.c	2008/09/19 03:27:08	1.5.2.3
@@ -131,6 +131,7 @@
 	r += add_key(keys, "fail", FAIL, 0);
 	r += add_key(keys, "disablequeueing", DISABLEQ, 0);
 	r += add_key(keys, "restorequeueing", RESTOREQ, 0);
+	r += add_key(keys, "resize", RESIZE, 0);
 	r += add_key(keys, "paths", PATHS, 0);
 	r += add_key(keys, "maps", MAPS, 0);
 	r += add_key(keys, "multipaths", MAPS, 0);
--- multipath-tools/multipathd/cli.h	2008/09/04 20:09:48	1.5.2.2
+++ multipath-tools/multipathd/cli.h	2008/09/19 03:27:08	1.5.2.3
@@ -9,6 +9,7 @@
 	__FAIL,
 	__DISABLEQ,
 	__RESTOREQ,
+	__RESIZE,
 	__PATHS,
 	__MAPS,
 	__PATH,
@@ -33,6 +34,7 @@
 #define FAIL		(1 << __FAIL)
 #define DISABLEQ	(1 << __DISABLEQ)
 #define RESTOREQ	(1 << __RESTOREQ)
+#define RESIZE		(1 << __RESIZE)
 #define PATHS		(1 << __PATHS)
 #define MAPS		(1 << __MAPS)
 #define PATH		(1 << __PATH)
--- multipath-tools/multipathd/cli_handlers.c	2008/09/04 20:09:48	1.6.2.2
+++ multipath-tools/multipathd/cli_handlers.c	2008/09/19 03:27:08	1.6.2.3
@@ -13,6 +13,8 @@
 #include <blacklist.h>
 #include <debug.h>
 #include <print.h>
+#include <discovery.h>
+#include <errno.h>
 
 #include "main.h"
 #include "cli.h"
@@ -343,11 +345,17 @@
 	struct multipath *mpp;
 	int minor;
 
+	condlog(2, "%s: restore map queueing (operator)", mapname);
 	if (sscanf(mapname, "dm-%d", &minor) == 1)
 		mpp = find_mp_by_minor(vecs->mpvec, minor);
 	else
 		mpp = find_mp_by_alias(vecs->mpvec, mapname);
 
+	if (!mpp) {
+		condlog(0, "%s: invalid map name, cannot restore queueing", mapname);
+		return 1;
+	}
+
 	if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
 			mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
 		dm_queue_if_no_path(mpp->alias, 1);
@@ -360,6 +368,27 @@
 }
 
 int
+cli_restore_all_queueing(void *v, char **reply, int *len, void *data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	struct multipath *mpp;
+	int i;
+
+	condlog(2, "restore queueing (operator)");
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		if (mpp->no_path_retry != NO_PATH_RETRY_UNDEF &&
+		    mpp->no_path_retry != NO_PATH_RETRY_FAIL) {
+			dm_queue_if_no_path(mpp->alias, 1);
+			if (mpp->nr_active > 0)
+				mpp->retry_tick = 0;
+			else
+				mpp->retry_tick = mpp->no_path_retry * conf->checkint;
+		}
+	}
+	return 0;
+}
+
+int
 cli_disable_queueing(void *v, char **reply, int *len, void *data)
 {
 	struct vectors * vecs = (struct vectors *)data;
@@ -367,17 +396,162 @@
 	struct multipath *mpp;
 	int minor;
 
+	condlog(2, "%s: disable map queueing (operator)", mapname);
 	if (sscanf(mapname, "dm-%d", &minor) == 1)
 		mpp = find_mp_by_minor(vecs->mpvec, minor);
 	else
 		mpp = find_mp_by_alias(vecs->mpvec, mapname);
 
+	if (!mpp) {
+		condlog(0, "%s: invalid map name, cannot disable queueing", mapname);
+		return 1;
+	}
+
 	mpp->retry_tick = 0;
 	dm_queue_if_no_path(mpp->alias, 0);
 	return 0;
 }
 
 int
+cli_disable_all_queueing(void *v, char **reply, int *len, void *data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	struct multipath *mpp;
+	int i;
+
+	condlog(2, "disable queueing (operator)");
+	vector_foreach_slot(vecs->mpvec, mpp, i) {
+		mpp->retry_tick = 0;
+		dm_queue_if_no_path(mpp->alias, 0);
+	}
+	return 0;
+}
+
+
+int
+reload_paths(struct multipath *mpp, struct vectors * vecs)
+{
+	struct pathgroup *pgp;
+	struct path *pp;
+	int i, j, err = 1;
+	char *dev;
+	vector path_names;
+
+	path_names = vector_alloc();
+	if (!path_names){
+		condlog(0, "%s: unable to allcoate space for pathnames vector",
+			mpp->alias);
+		return 1;
+	}
+	vector_foreach_slot(mpp->pg, pgp, i) {
+		vector_foreach_slot(pgp->paths, pp, j) {
+
+			dev = strdup(pp->dev);
+			if (!dev) {
+				condlog(0, "%s: unable to allocate space for path name", mpp->alias);
+				goto out;
+			}
+			if (!vector_alloc_slot(path_names)){
+				condlog(0, "%s: unable to allocate space for path name slot", mpp->alias);
+				free(dev);
+				goto out;
+			}
+			vector_set_slot(path_names, dev);
+		}
+	}
+	vector_foreach_slot(path_names, dev, i) {
+		err = ev_remove_path(dev, vecs);
+		if (err) {
+			condlog(0, "%s: couldn't remove path '%s' : %s",
+				mpp->alias, dev, strerror(errno));
+			goto out;
+		}
+		err = ev_add_path(dev, vecs);
+		if (err)
+			condlog(0, "%s: couldn't add path '%s' : %s",
+				mpp->alias, dev, strerror(errno));
+	}
+out:
+	vector_foreach_slot(path_names, dev, i)
+		free(dev);
+	vector_free(path_names);
+	return err;
+}
+
+int resize_map(struct multipath *mpp, unsigned long long size, struct vectors * vecs)
+{
+	mpp->size = size;
+	update_mpp_paths(mpp, vecs->pathvec);
+	setup_map(mpp);
+	mpp->action = ACT_RESIZE;
+	if (domap(mpp) <= 0) {
+		condlog(0, "%s: failed to resize map : %s", mpp->alias,
+			strerror(errno));
+		return 1;
+	}
+	return 0;
+}
+
+int
+cli_resize(void *v, char **reply, int *len, void *data)
+{
+	struct vectors * vecs = (struct vectors *)data;
+	char * mapname = get_keyparam(v, MAP);
+	struct multipath *mpp;
+	int minor;
+	unsigned long long size;
+	struct pathgroup *pgp;
+	struct path *pp;
+
+	condlog(2, "%s: resize map (operator)", mapname);
+	if (sscanf(mapname, "dm-%d", &minor) == 1)
+		mpp = find_mp_by_minor(vecs->mpvec, minor);
+	else
+		mpp = find_mp_by_alias(vecs->mpvec, mapname);
+
+	if (!mpp) {
+		condlog(0, "%s: invalid map name. cannot resize", mapname);
+		return 1;
+	}
+
+	pgp = VECTOR_SLOT(mpp->pg, 0);
+	pp = VECTOR_SLOT(pgp->paths, 0);
+	if (sysfs_get_size(sysfs_path, pp->dev, &size)) {
+		condlog(0, "%s: couldn't get size for sysfs. cannot resize",
+			mapname);
+		return 1;
+	}
+	if (size == mpp->size) {
+		condlog(0, "%s: map is still the same size (%llu)", mapname,
+			mpp->size);
+		return 0;
+	}
+	condlog(3, "%s old size is %llu, new size is %llu", mapname, mpp->size,
+		size);
+	if (size > mpp->size) {
+		if (reload_paths(mpp, vecs) != 0) {
+			condlog(0, "%s: failed to reload paths", mapname);
+			return 1;
+		}
+		if (resize_map(mpp, size, vecs) != 0)
+			return 1;
+	}
+	else {
+		if (resize_map(mpp, size, vecs) != 0)
+			return 1;
+		if (reload_paths(mpp, vecs) != 0) {
+			condlog(0, "%s: failed to reload paths", mapname);
+			return 1;
+		}
+	}
+	dm_lib_release();
+	setup_multipath(vecs, mpp);
+	sync_map_state(mpp);
+
+	return 0;
+}
+
+int
 cli_switch_group(void * v, char ** reply, int * len, void * data)
 {
 	char * mapname = get_keyparam(v, MAP);
@@ -403,7 +577,7 @@
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	int r = dm_simplecmd(DM_DEVICE_SUSPEND, param);
+	int r = dm_simplecmd(DM_DEVICE_SUSPEND, param, 1);
 
 	condlog(2, "%s: suspend (operator)", param);
 
@@ -424,7 +598,7 @@
 {
 	struct vectors * vecs = (struct vectors *)data;
 	char * param = get_keyparam(v, MAP);
-	int r = dm_simplecmd(DM_DEVICE_RESUME, param);
+	int r = dm_simplecmd(DM_DEVICE_RESUME, param, 1);
 
 	condlog(2, "%s: resume (operator)", param);
 
--- multipath-tools/multipathd/cli_handlers.h	2008/09/04 20:09:48	1.3.2.2
+++ multipath-tools/multipathd/cli_handlers.h	2008/09/19 03:27:08	1.3.2.3
@@ -14,7 +14,10 @@
 int cli_switch_group(void * v, char ** reply, int * len, void * data);
 int cli_reconfigure(void * v, char ** reply, int * len, void * data);
 int cli_disable_queueing(void * v, char ** reply, int * len, void * data);
+int cli_disable_all_queueing(void * v, char ** reply, int * len, void * data);
 int cli_restore_queueing(void * v, char ** reply, int * len, void * data);
+int cli_restore_all_queueing(void * v, char ** reply, int * len, void * data);
+int cli_resize(void * v, char ** reply, int * len, void * data);
 int cli_suspend(void * v, char ** reply, int * len, void * data);
 int cli_resume(void * v, char ** reply, int * len, void * data);
 int cli_reinstate(void * v, char ** reply, int * len, void * data);
--- multipath-tools/multipathd/main.c	2008/09/12 23:49:57	1.69.2.13
+++ multipath-tools/multipathd/main.c	2008/09/19 03:27:08	1.69.2.14
@@ -158,7 +158,7 @@
 	return 0;
 }
 
-static void
+void
 sync_map_state(struct multipath *mpp)
 {
 	struct pathgroup *pgp;
@@ -768,6 +768,9 @@
 	add_handler(FAIL+PATH, cli_fail);
 	add_handler(DISABLEQ+MAP, cli_disable_queueing);
 	add_handler(RESTOREQ+MAP, cli_restore_queueing);
+	add_handler(DISABLEQ+MAPS, cli_disable_all_queueing);
+	add_handler(RESTOREQ+MAPS, cli_restore_all_queueing);
+	add_handler(RESIZE+MAP, cli_resize);
 
 	uxsock_listen(&uxsock_trigger, ap);
 
--- multipath-tools/multipathd/main.h	2006/06/06 18:32:44	1.7
+++ multipath-tools/multipathd/main.h	2008/09/19 03:27:08	1.7.2.1
@@ -9,5 +9,6 @@
 int ev_remove_path (char *, struct vectors *);
 int ev_add_map (char *, struct vectors *);
 int ev_remove_map (char *, struct vectors *);
+void sync_map_state (struct multipath *);
 
 #endif /* MAIN_H */
