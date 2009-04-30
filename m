From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH] Add uid, gid, and mode config attributes
Date: Thu, 30 Apr 2009 11:31:37 -0500
Message-ID: <1241109097-30252-1-git-send-email-bmarzins@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This adds the ability to set uid, gid, and mode for the multipath device
nodes. Also, kpartx created device nodes will inherit the uid, gid, and
mode of their parent device. These attributes can be set in either the
defaults or the multipaths section of /etc/multipath.conf

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 kpartx/devmapper.c       |   10 ++-
 kpartx/devmapper.h       |    2 +-
 kpartx/kpartx.c          |    8 ++-
 libmultipath/config.c    |    1 +
 libmultipath/config.h    |   10 ++
 libmultipath/configure.c |   17 ++--
 libmultipath/devmapper.c |   57 +++++++------
 libmultipath/devmapper.h |   19 +++--
 libmultipath/dict.c      |  211 ++++++++++++++++++++++++++++++++++++++++++++++
 libmultipath/propsel.c   |   54 ++++++++++++
 libmultipath/propsel.h   |    3 +
 libmultipath/structs.h   |   11 +++
 multipath.conf.annotated |   54 ++++++++++++
 multipath.conf.synthetic |    3 +
 14 files changed, 412 insertions(+), 48 deletions(-)

diff --git a/kpartx/devmapper.c b/kpartx/devmapper.c
index 5686276..48d2998 100644
--- a/kpartx/devmapper.c
+++ b/kpartx/devmapper.c
@@ -78,7 +78,8 @@ dm_simplecmd (int task, const char *name, int no_flush) {
 
 extern int
 dm_addmap (int task, const char *name, const char *target,
-	   const char *params, uint64_t size, const char *uuid, int part) {
+	   const char *params, uint64_t size, const char *uuid, int part,
+	   mode_t mode, uid_t uid, gid_t gid) {
 	int r = 0;
 	struct dm_task *dmt;
 	char *prefixed_uuid = NULL;
@@ -104,6 +105,13 @@ dm_addmap (int task, const char *name, const char *target,
 			goto addout;
 	}
 
+	if (!dm_task_set_mode(dmt, mode))
+		goto addout;
+	if (!dm_task_set_uid(dmt, uid))
+		goto addout;
+	if (!dm_task_set_gid(dmt, gid))
+		goto addout;
+
 	dm_task_no_open_count(dmt);
 
 	r = dm_task_run (dmt);
diff --git a/kpartx/devmapper.h b/kpartx/devmapper.h
index ca05239..7ac0bf1 100644
--- a/kpartx/devmapper.h
+++ b/kpartx/devmapper.h
@@ -1,7 +1,7 @@
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *, int);
 int dm_addmap (int, const char *, const char *, const char *, uint64_t,
-	       const char *, int);
+	       const char *, int, mode_t, uid_t, gid_t);
 int dm_map_present (char *);
 char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
diff --git a/kpartx/kpartx.c b/kpartx/kpartx.c
index afb956e..2e0d97d 100644
--- a/kpartx/kpartx.c
+++ b/kpartx/kpartx.c
@@ -462,7 +462,9 @@ main(int argc, char **argv){
 					DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
 
 				if (!dm_addmap(op, partname, DM_TARGET, params,
-					  slices[j].size, uuid, j+1)) {
+					       slices[j].size, uuid, j+1,
+					       buf.st_mode & 0777, buf.st_uid,
+					       buf.st_gid)) {
 					fprintf(stderr, "create/reload failed on %s\n",
 						partname);
 					r++;
@@ -524,7 +526,9 @@ main(int argc, char **argv){
 					      DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
 
 					dm_addmap(op, partname, DM_TARGET, params,
-						  slices[j].size, uuid, j+1);
+						  slices[j].size, uuid, j+1,
+						  buf.st_mode & 0777,
+						  buf.st_uid, buf.st_gid);
 
 					if (op == DM_DEVICE_RELOAD)
 						dm_simplecmd(DM_DEVICE_RESUME,
diff --git a/libmultipath/config.c b/libmultipath/config.c
index 4f62fc5..e7e962e 100644
--- a/libmultipath/config.c
+++ b/libmultipath/config.c
@@ -440,6 +440,7 @@ load_config (char * file)
 	conf->bindings_file = DEFAULT_BINDINGS_FILE;
 	conf->multipath_dir = set_default(DEFAULT_MULTIPATHDIR);
 	conf->flush_on_last_del = 0;
+	conf->attribute_flags = 0;
 
 	/*
 	 * preload default hwtable
diff --git a/libmultipath/config.h b/libmultipath/config.h
index ca4f292..50a728c 100644
--- a/libmultipath/config.h
+++ b/libmultipath/config.h
@@ -1,6 +1,8 @@
 #ifndef _CONFIG_H
 #define _CONFIG_H
 
+#include <sys/types.h>
+
 #define ORIGIN_DEFAULT 0
 #define ORIGIN_CONFIG  1
 
@@ -45,6 +47,10 @@ struct mpentry {
 	int minio;
 	int pg_timeout;
 	int flush_on_last_del;
+	int attribute_flags;
+	uid_t uid;
+	gid_t gid;
+	mode_t mode;
 };
 
 struct config {
@@ -68,6 +74,10 @@ struct config {
 	int force_reload;
 	int daemon;
 	int flush_on_last_del;
+	int attribute_flags;
+	uid_t uid;
+	gid_t gid;
+	mode_t mode;
 
 	char * dev;
 	char * sysfs_dir;
diff --git a/libmultipath/configure.c b/libmultipath/configure.c
index 783ea40..ef7a6d4 100644
--- a/libmultipath/configure.c
+++ b/libmultipath/configure.c
@@ -67,6 +67,9 @@ setup_map (struct multipath * mpp)
 	select_minio(mpp);
 	select_no_path_retry(mpp);
 	select_pg_timeout(mpp);
+	select_mode(mpp);
+	select_uid(mpp);
+	select_gid(mpp);
 
 	/*
 	 * assign paths to path groups -- start with no groups and all paths
@@ -346,28 +349,26 @@ domap (struct multipath * mpp)
 			break;
 		}
 
-		r = dm_addmap_create(mpp->alias, mpp->params, mpp->size,
-				     mpp->wwid);
+		r = dm_addmap_create(mpp);
 
 		if (!r)
-			 r = dm_addmap_create_ro(mpp->alias, mpp->params,
-						 mpp->size, mpp->wwid);
+			 r = dm_addmap_create_ro(mpp);
 
 		lock_multipath(mpp, 0);
 		break;
 
 	case ACT_RELOAD:
-		r = dm_addmap_reload(mpp->alias, mpp->params, mpp->size, NULL);
+		r = dm_addmap_reload(mpp);
 		if (!r)
-			r = dm_addmap_reload_ro(mpp->alias, mpp->params, mpp->size, NULL);
+			r = dm_addmap_reload_ro(mpp);
 		if (r)
 			r = dm_simplecmd_noflush(DM_DEVICE_RESUME, mpp->alias);
 		break;
 
  	case ACT_RESIZE:
-  		r = dm_addmap_reload(mpp->alias, mpp->params, mpp->size, NULL);
+  		r = dm_addmap_reload(mpp);
   		if (!r)
-  			r = dm_addmap_reload_ro(mpp->alias, mpp->params, mpp->size, NULL);
+  			r = dm_addmap_reload_ro(mpp);
   		if (r)
   			r = dm_simplecmd_flush(DM_DEVICE_RESUME, mpp->alias);
 		break;
diff --git a/libmultipath/devmapper.c b/libmultipath/devmapper.c
index 0048ed0..8883a37 100644
--- a/libmultipath/devmapper.c
+++ b/libmultipath/devmapper.c
@@ -184,8 +184,7 @@ dm_simplecmd_noflush (int task, const char *name) {
 }
 
 extern int
-dm_addmap (int task, const char *name, const char *target,
-	   const char *params, unsigned long long size, const char *uuid,
+dm_addmap (int task, const char *target, struct multipath *mpp, int use_uuid,
 	   int ro) {
 	int r = 0;
 	struct dm_task *dmt;
@@ -194,27 +193,37 @@ dm_addmap (int task, const char *name, const char *target,
 	if (!(dmt = dm_task_create (task)))
 		return 0;
 
-	if (!dm_task_set_name (dmt, name))
+	if (!dm_task_set_name (dmt, mpp->alias))
 		goto addout;
 
-	if (!dm_task_add_target (dmt, 0, size, target, params))
+	if (!dm_task_add_target (dmt, 0, mpp->size, target, mpp->params))
 		goto addout;
 
 	if (ro)
 		dm_task_set_ro(dmt);
 
-	if (uuid){
-		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(uuid) + 1);
+	if (use_uuid && mpp->wwid){
+		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(mpp->wwid) + 1);
 		if (!prefixed_uuid) {
 			condlog(0, "cannot create prefixed uuid : %s\n",
 				strerror(errno));
 			goto addout;
 		}
-		sprintf(prefixed_uuid, UUID_PREFIX "%s", uuid);
+		sprintf(prefixed_uuid, UUID_PREFIX "%s", mpp->wwid);
 		if (!dm_task_set_uuid(dmt, prefixed_uuid))
 			goto freeout;
 	}
 
+	if (mpp->attribute_flags & (1 << ATTR_MODE) &&
+	    !dm_task_set_mode(dmt, mpp->mode))
+		goto freeout;
+	if (mpp->attribute_flags & (1 << ATTR_UID) &&
+	    !dm_task_set_uid(dmt, mpp->uid))
+		goto freeout;
+	if (mpp->attribute_flags & (1 << ATTR_GID) &&
+	    !dm_task_set_gid(dmt, mpp->gid))
+		goto freeout;
+
 	dm_task_no_open_count(dmt);
 
 	r = dm_task_run (dmt);
@@ -230,19 +239,17 @@ dm_addmap (int task, const char *name, const char *target,
 }
 
 static int
-_dm_addmap_create (const char *name, const char *params,
-		  unsigned long long size, const char *uuid, int ro) {
+_dm_addmap_create (struct multipath *mpp, int ro) {
 	int r;
-	r = dm_addmap(DM_DEVICE_CREATE, name, TGT_MPATH, params, size, uuid,
-		      ro);
+	r = dm_addmap(DM_DEVICE_CREATE, TGT_MPATH, mpp, 1, ro);
 	/*
 	 * DM_DEVICE_CREATE is actually DM_DEV_CREATE + DM_TABLE_LOAD.
 	 * Failing the second part leaves an empty map. Clean it up.
 	 */
-	if (!r && dm_map_present(name)) {
+	if (!r && dm_map_present(mpp->alias)) {
 		condlog(3, "%s: failed to load map (a path might be in use)",
-			name);
-		dm_flush_map(name);
+			mpp->alias);
+		dm_flush_map(mpp->alias);
 	}
 	return r;
 }
@@ -251,29 +258,23 @@ _dm_addmap_create (const char *name, const char *params,
 #define ADDMAP_RO 1
 
 extern int
-dm_addmap_create (const char *name, const char *params,
-		  unsigned long long size, const char *uuid) {
-	return _dm_addmap_create(name, params, size, uuid, ADDMAP_RW);
+dm_addmap_create (struct multipath *mpp) {
+	return _dm_addmap_create(mpp, ADDMAP_RW);
 }
 
 extern int
-dm_addmap_create_ro (const char *name, const char *params,
-		  unsigned long long size, const char *uuid) {
-	return _dm_addmap_create(name, params, size, uuid, ADDMAP_RO);
+dm_addmap_create_ro (struct multipath *mpp) {
+	return _dm_addmap_create(mpp, ADDMAP_RO);
 }
 
 extern int
-dm_addmap_reload (const char *name, const char *params,
-		  unsigned long long size, const char *uuid) {
-	return dm_addmap(DM_DEVICE_RELOAD, name, TGT_MPATH, params, size, uuid,
-			 ADDMAP_RW);
+dm_addmap_reload (struct multipath *mpp) {
+	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, 0, ADDMAP_RW);
 }
 
 extern int
-dm_addmap_reload_ro (const char *name, const char *params,
-		     unsigned long long size, const char *uuid) {
-	return dm_addmap(DM_DEVICE_RELOAD, name, TGT_MPATH, params, size, uuid,
-			 ADDMAP_RO);
+dm_addmap_reload_ro (struct multipath *mpp) {
+	return dm_addmap(DM_DEVICE_RELOAD, TGT_MPATH, mpp, 0, ADDMAP_RO);
 }
 
 extern int
diff --git a/libmultipath/devmapper.h b/libmultipath/devmapper.h
index 984ba39..9bbf48b 100644
--- a/libmultipath/devmapper.h
+++ b/libmultipath/devmapper.h
@@ -1,3 +1,8 @@
+#ifndef _DEVMAPPER_H
+#define _DEVMAPPER_H
+
+#include "structs.h"
+
 #define TGT_MPATH	"multipath"
 #define TGT_PART	"linear"
 
@@ -5,14 +10,10 @@ void dm_init(void);
 int dm_prereq (void);
 int dm_simplecmd_flush (int, const char *);
 int dm_simplecmd_noflush (int, const char *);
-int dm_addmap_create (const char *, const char *,
-                      unsigned long long size, const char *uuid);
-int dm_addmap_create_ro (const char *, const char *,
-			 unsigned long long size, const char *uuid);
-int dm_addmap_reload (const char *, const char *,
-                      unsigned long long size, const char *uuid);
-int dm_addmap_reload_ro (const char *, const char *,
-			 unsigned long long size, const char *uuid);
+int dm_addmap_create (struct multipath *mpp);
+int dm_addmap_create_ro (struct multipath *mpp);
+int dm_addmap_reload (struct multipath *mpp);
+int dm_addmap_reload_ro (struct multipath *mpp);
 int dm_map_present (const char *);
 int dm_get_map(char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
@@ -35,3 +36,5 @@ int dm_get_uuid(char *name, char *uuid);
 int dm_get_info (char * mapname, struct dm_info ** dmi);
 int dm_rename (char * old, char * new);
 int dm_get_name(char * uuid, char * name);
+
+#endif /* _DEVMAPPER_H */
diff --git a/libmultipath/dict.c b/libmultipath/dict.c
index e5f2f52..2902e89 100644
--- a/libmultipath/dict.c
+++ b/libmultipath/dict.c
@@ -4,6 +4,9 @@
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
  * Copyright (c) 2005 Kiyoshi Ueda, NEC
  */
+#include <sys/types.h>
+#include <pwd.h>
+
 #include "checkers.h"
 #include "vector.h"
 #include "hwtable.h"
@@ -173,6 +176,74 @@ max_fds_handler(vector strvec)
 }
 
 static int
+def_mode_handler(vector strvec)
+{
+	mode_t mode;
+	char *buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	if (sscanf(buff, "%o", &mode) == 1 && mode <= 0777) {
+		conf->attribute_flags |= (1 << ATTR_MODE);
+		conf->mode = mode;
+	}
+
+	FREE(buff);
+	return 0;
+}
+
+static int
+def_uid_handler(vector strvec)
+{
+	uid_t uid;
+	char *buff;
+	char passwd_buf[1024];
+	struct passwd info, *found;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+	if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+		conf->attribute_flags |= (1 << ATTR_UID);
+		conf->uid = info.pw_uid;
+	}
+	else if (sscanf(buff, "%u", &uid) == 1){
+		conf->attribute_flags |= (1 << ATTR_UID);
+		conf->uid = uid;
+	}
+
+	FREE(buff);
+	return 0;
+}
+
+static int
+def_gid_handler(vector strvec)
+{
+	gid_t gid;
+	char *buff;
+	char passwd_buf[1024];
+	struct passwd info, *found;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+		conf->attribute_flags |= (1 << ATTR_GID);
+		conf->gid = info.pw_gid;
+	}
+	else if (sscanf(buff, "%u", &gid) == 1){
+		conf->attribute_flags |= (1 << ATTR_GID);
+		conf->gid = gid;
+	}
+	FREE(buff);
+	return 0;
+}
+
+static int
 def_weight_handler(vector strvec)
 {
 	char * buff;
@@ -908,6 +979,86 @@ mp_failback_handler(vector strvec)
 }
 
 static int
+mp_mode_handler(vector strvec)
+{
+	mode_t mode;
+	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
+	char *buff;
+
+	if (!mpe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+	if (sscanf(buff, "%o", &mode) == 1 && mode <= 0777) {
+		mpe->attribute_flags |= (1 << ATTR_MODE);
+		mpe->mode = mode;
+	}
+
+	FREE(buff);
+	return 0;
+}
+
+static int
+mp_uid_handler(vector strvec)
+{
+	uid_t uid;
+	char *buff;
+	char passwd_buf[1024];
+	struct passwd info, *found;
+
+	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
+
+	if (!mpe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+		mpe->attribute_flags |= (1 << ATTR_UID);
+		mpe->uid = info.pw_uid;
+	}
+	else if (sscanf(buff, "%u", &uid) == 1){
+		mpe->attribute_flags |= (1 << ATTR_UID);
+		mpe->uid = uid;
+	}
+	FREE(buff);
+	return 0;
+}
+
+static int
+mp_gid_handler(vector strvec)
+{
+	gid_t gid;
+	char *buff;
+	char passwd_buf[1024];
+	struct passwd info, *found;
+
+	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
+
+	if (!mpe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+		mpe->attribute_flags |= (1 << ATTR_GID);
+		mpe->gid = info.pw_gid;
+	}
+	else if (sscanf(buff, "%u", &gid) == 1) {
+		mpe->attribute_flags |= (1 << ATTR_GID);
+		mpe->gid = gid;
+	}
+	FREE(buff);
+	return 0;
+}
+
+static int
 mp_weight_handler(vector strvec)
 {
 	struct mpentry * mpe = VECTOR_LAST_SLOT(conf->mptable);
@@ -1103,6 +1254,36 @@ snprint_mp_failback (char * buff, int len, void * data)
 }
 
 static int
+snprint_mp_mode(char * buff, int len, void * data)
+{
+	struct mpentry * mpe = (struct mpentry *)data;
+
+	if ((mpe->attribute_flags & (1 << ATTR_MODE)) == 0)
+		return 0;
+	return snprintf(buff, len, "0%o", mpe->mode);
+}
+
+static int
+snprint_mp_uid(char * buff, int len, void * data)
+{
+	struct mpentry * mpe = (struct mpentry *)data;
+
+	if ((mpe->attribute_flags & (1 << ATTR_UID)) == 0)
+		return 0;
+	return snprintf(buff, len, "0%o", mpe->uid);
+}
+
+static int
+snprint_mp_gid(char * buff, int len, void * data)
+{
+	struct mpentry * mpe = (struct mpentry *)data;
+
+	if ((mpe->attribute_flags & (1 << ATTR_GID)) == 0)
+		return 0;
+	return snprintf(buff, len, "0%o", mpe->gid);
+}
+
+static int
 snprint_mp_rr_weight (char * buff, int len, void * data)
 {
 	struct mpentry * mpe = (struct mpentry *)data;
@@ -1580,6 +1761,30 @@ snprint_max_fds (char * buff, int len, void * data)
 }
 
 static int
+snprint_def_mode(char * buff, int len, void * data)
+{
+	if ((conf->attribute_flags & (1 << ATTR_MODE)) == 0)
+		return 0;
+	return snprintf(buff, len, "0%o", conf->mode);
+}
+
+static int
+snprint_def_uid(char * buff, int len, void * data)
+{
+	if ((conf->attribute_flags & (1 << ATTR_UID)) == 0)
+		return 0;
+	return snprintf(buff, len, "0%o", conf->uid);
+}
+
+static int
+snprint_def_gid(char * buff, int len, void * data)
+{
+	if ((conf->attribute_flags & (1 << ATTR_GID)) == 0)
+		return 0;
+	return snprintf(buff, len, "0%o", conf->gid);
+}
+
+static int
 snprint_def_rr_weight (char * buff, int len, void * data)
 {
 	if (!conf->rr_weight)
@@ -1701,6 +1906,9 @@ init_keywords(void)
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("flush_on_last_del", &def_flush_on_last_del_handler, &snprint_def_flush_on_last_del);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
+	install_keyword("mode", &def_mode_handler, &snprint_def_mode);
+	install_keyword("uid", &def_uid_handler, &snprint_def_uid);
+	install_keyword("gid", &def_gid_handler, &snprint_def_gid);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
@@ -1770,5 +1978,8 @@ init_keywords(void)
 	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_rr_min_io);
 	install_keyword("pg_timeout", &mp_pg_timeout_handler, &snprint_mp_pg_timeout);
 	install_keyword("flush_on_last_del", &mp_flush_on_last_del_handler, &snprint_mp_flush_on_last_del);
+	install_keyword("mode", &mp_mode_handler, &snprint_mp_mode);
+	install_keyword("uid", &mp_uid_handler, &snprint_mp_uid);
+	install_keyword("gid", &mp_gid_handler, &snprint_mp_gid);
 	install_sublevel_end();
 }
diff --git a/libmultipath/propsel.c b/libmultipath/propsel.c
index c1bc591..b534ae2 100644
--- a/libmultipath/propsel.c
+++ b/libmultipath/propsel.c
@@ -26,6 +26,60 @@ pgpolicyfn *pgpolicies[] = {
 	group_by_node_name
 };
 
+extern int
+select_mode (struct multipath *mp)
+{
+	if (mp->mpe && (mp->mpe->attribute_flags & (1 << ATTR_MODE))) {
+		mp->attribute_flags |= (1 << ATTR_MODE);
+		mp->mode = mp->mpe->mode;
+		condlog(3, "mode = 0%o (LUN setting)", mp->mode);
+	}
+	else if (conf->attribute_flags & (1 << ATTR_MODE)) {
+		mp->attribute_flags |= (1 << ATTR_MODE);
+		mp->mode = conf->mode;
+		condlog(3, "mode = 0%o (config file default)", mp->mode);
+	}
+	else
+		mp->attribute_flags &= ~(1 << ATTR_MODE);
+	return 0;
+}
+
+extern int
+select_uid (struct multipath *mp)
+{
+	if (mp->mpe && (mp->mpe->attribute_flags & (1 << ATTR_UID))) {
+		mp->attribute_flags |= (1 << ATTR_UID);
+		mp->uid = mp->mpe->uid;
+		condlog(3, "uid = %u (LUN setting)", mp->uid);
+	}
+	else if (conf->attribute_flags & (1 << ATTR_UID)) {
+		mp->attribute_flags |= (1 << ATTR_UID);
+		mp->uid = conf->uid;
+		condlog(3, "uid = %u (config file default)", mp->uid);
+	}
+	else
+		mp->attribute_flags &= ~(1 << ATTR_UID);
+	return 0;
+}
+
+extern int
+select_gid (struct multipath *mp)
+{
+	if (mp->mpe && (mp->mpe->attribute_flags & (1 << ATTR_GID))) {
+		mp->attribute_flags |= (1 << ATTR_GID);
+		mp->gid = mp->mpe->gid;
+		condlog(3, "gid = %u (LUN setting)", mp->gid);
+	}
+	else if (conf->attribute_flags & (1 << ATTR_GID)) {
+		mp->attribute_flags |= (1 << ATTR_GID);
+		mp->gid = conf->gid;
+		condlog(3, "gid = %u (config file default)", mp->gid);
+	}
+	else
+		mp->attribute_flags &= ~(1 << ATTR_GID);
+	return 0;
+}
+
 /*
  * selectors :
  * traverse the configuration layers from most specific to most generic
diff --git a/libmultipath/propsel.h b/libmultipath/propsel.h
index 818060b..f098d28 100644
--- a/libmultipath/propsel.h
+++ b/libmultipath/propsel.h
@@ -12,3 +12,6 @@ int select_no_path_retry(struct multipath *mp);
 int select_pg_timeout(struct multipath *mp);
 int select_flush_on_last_del(struct multipath *mp);
 int select_minio(struct multipath *mp);
+int select_mode(struct multipath *mp);
+int select_uid(struct multipath *mp);
+int select_gid(struct multipath *mp);
diff --git a/libmultipath/structs.h b/libmultipath/structs.h
index d7c3c88..f7eca60 100644
--- a/libmultipath/structs.h
+++ b/libmultipath/structs.h
@@ -1,6 +1,8 @@
 #ifndef _STRUCTS_H
 #define _STRUCTS_H
 
+#include <sys/types.h>
+
 #define WWID_SIZE		128
 #define SERIAL_SIZE		64
 #define NODE_NAME_SIZE		19
@@ -67,6 +69,11 @@ enum pgtimeouts {
 	PGTIMEOUT_NONE
 };
 
+enum attribute_bits {
+	ATTR_UID,
+	ATTR_GID,
+	ATTR_MODE,
+};
 
 enum flush_states {
 	FLUSH_UNDEF,
@@ -159,6 +166,10 @@ struct multipath {
 	int minio;
 	int pg_timeout;
 	int flush_on_last_del;
+	int attribute_flags;
+	uid_t uid;
+	gid_t gid;
+	mode_t mode;
 	unsigned long long size;
 	vector paths;
 	vector pg;
diff --git a/multipath.conf.annotated b/multipath.conf.annotated
index 7f5fe0d..1b8f7cc 100644
--- a/multipath.conf.annotated
+++ b/multipath.conf.annotated
@@ -163,6 +163,32 @@
 #	# default : no
 #	user_friendly_names no
 #
+#	#
+#	# name    : mode
+#	# scope   : multipath
+#	# desc    : The mode to use for the multipath device nodes, in octal.
+#	# values  : 0000 - 0777
+#	# default : determined by the process
+#	mode 0644
+#
+#	#
+#	# name    : uid
+#	# scope   : multipath
+#	# desc    : The user id to use for the multipath device nodes. You
+#	#           may use either the numeric or symbolic uid
+#	# values  : <user_id>
+#	# default : determined by the process
+#	uid 0
+#
+#	#
+#	# name    : gid
+#	# scope   : multipath
+#	# desc    : The group id to user for the multipath device nodes. You
+#	#           may use either the numeric or symbolic gid
+#	# values  : <group_id>
+#	# default : determined by the process
+#	gid disk
+#
 #}
 #	
 ##
@@ -298,6 +324,34 @@
 #		# default : no
 #		#
 #		flush_on_last_del       yes
+#
+#		#
+#		# name    : mode
+#		# scope   : multipath
+#		# desc    : The mode to use for the multipath device nodes, in
+#		#           octal.
+#		# values  : 0000 - 0777
+#		# default : determined by the process
+#		mode 0644
+#
+#		#
+#		# name    : uid
+#		# scope   : multipath
+#		# desc    : The user id to use for the multipath device nodes.
+#		#           You may use either the numeric or symbolic uid
+#		# values  : <user_id>
+#		# default : determined by the process
+#		uid 0
+#
+#		#
+#		# name    : gid
+#		# scope   : multipath
+#		# desc    : The group id to user for the multipath device nodes.
+#		#           You may use either the numeric or symbolic gid
+#		# values  : <group_id>
+#		# default : determined by the process
+#		gid 0
+#
 #	}
 #	multipath {
 #		wwid	1DEC_____321816758474
diff --git a/multipath.conf.synthetic b/multipath.conf.synthetic
index efa84f0..3e0fd6e 100644
--- a/multipath.conf.synthetic
+++ b/multipath.conf.synthetic
@@ -17,6 +17,9 @@
 #	failback		immediate
 #	no_path_retry		fail
 #	user_friendly_names	no
+#	mode			644
+#	uid			0
+#	gid			disk
 #}
 #blacklist {
 #       wwid 26353900f02796769
-- 
1.5.3.3
