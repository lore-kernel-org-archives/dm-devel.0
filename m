From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 14 Apr 2008 22:32:06 -0000
Message-ID: <20080414223206.14781.qmail@sourceware.org>
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
Branch: 	RHEL4_FC5
Changes by:	bmarzins@sourceware.org	2008-04-14 22:32:04

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.synthetic 
	kpartx         : devmapper.c devmapper.h kpartx.c 
	libmultipath   : config.c config.h devmapper.c devmapper.h 
	                 dict.c propsel.c propsel.h structs.h 
	multipath      : main.c 

Log message:
	Fix for bz #251388.  Added three new parameters to /etc/multipath.conf:
	mode, uid, and gid.  These can be used to override the default values when
	multipath device nodes are created. Unfortunately, you cannot do name
	resolution with static binaries, since you must load libnss dynamically, so
	uid and gid must use the numerical user id and group id.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.4&r2=1.16.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.synthetic.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.10.2.1&r2=1.10.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.6.2.1&r2=1.6.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.3.2.1&r2=1.3.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/kpartx.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.7.2.2&r2=1.7.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.2&r2=1.17.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.2&r2=1.17.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.18.2.1&r2=1.18.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.10&r2=1.10.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.3&r2=1.16.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.9.2.1&r2=1.9.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4.2.1&r2=1.4.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.6&r2=1.17.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.41.2.6&r2=1.41.2.7

--- multipath-tools/multipath.conf.annotated	2008/01/25 22:30:00	1.16.2.4
+++ multipath-tools/multipath.conf.annotated	2008/04/14 22:32:03	1.16.2.5
@@ -161,6 +161,32 @@
 #	# default : "/var/lib/multipath/bindings"
 #	bindings_file "/etc/multipath_bindings"
 #
+#	#
+#	# name    : mode
+#	# scope   : multipath
+#	# desc    : The mode to use for the multipath device nodes, in octal.
+#	# values  : 0000 - 0777
+#	# default : determined by the process
+#	mode	0644
+#
+#	#
+#	# name    : uid
+#	# scope   : multipath
+#	# desc    : The user id to use for the multipath device nodes. You
+#	#           must use the numeric user id.
+#	# values  : <user_id_number>
+#	# default : determined by the process
+#	uid	0
+#
+#	#
+#	# name    : gid
+#	# scope   : multipath
+#	# desc    : The group id to use for the multipath device nodes. You
+#	#           must use the numeric group id.
+#	# values  : <group_id_number>
+#	# default : determined by the process
+#	gid	0
+#
 #}
 #	
 ##
@@ -256,6 +282,33 @@
 #		# values  : queue|fail|n (>0)
 #		#
 #		no_path_retry  queue
+#		#
+#		# name    : mode
+#		# scope   : multipath
+#		# desc    : The mode to use for the multipath device node,
+#		#           in octal.
+#		# values  : 0000 - 0777
+#		# default : determined by the process
+#		mode	0644
+#
+#		#
+#		# name    : uid
+#		# scope   : multipath
+#		# desc    : The user id to use for the multipath device node.
+#		#           You must use the numeric user id.
+#		# values  : <user_id_number>
+#		# default : determined by the process
+#		uid	0
+#
+#		#
+#		# name    : gid
+#		# scope   : multipath
+#		# desc    : The group id to use for the multipath device node.
+#		#           You must use the numeric group id.
+#		# values  : <group_id_number>
+#		# default : determined by the process
+#		gid	0
+#
 #	}
 #	multipath {
 #		wwid	1DEC_____321816758474
--- multipath-tools/multipath.conf.synthetic	2008/01/25 22:30:00	1.10.2.1
+++ multipath-tools/multipath.conf.synthetic	2008/04/14 22:32:03	1.10.2.2
@@ -16,6 +16,9 @@
 #	failback		immediate
 #	no_path_retry		fail
 #	user_friendly_name	yes
+#	mode			0666
+#	uid			0
+#	gid			0
 #}
 #devnode_blacklist {
 #       wwid 26353900f02796769
--- multipath-tools/kpartx/devmapper.c	2006/09/19 21:06:40	1.6.2.1
+++ multipath-tools/kpartx/devmapper.c	2008/04/14 22:32:04	1.6.2.2
@@ -72,7 +72,8 @@
 
 extern int
 dm_addmap (int task, const char *name, const char *target,
-	   const char *params, unsigned long size, const char *uuid, int part) {
+	   const char *params, unsigned long size, const char *uuid, int part,
+	   mode_t mode, uid_t uid, gid_t gid) {
 	int r = 0;
 	struct dm_task *dmt;
 	char *prefixed_uuid = NULL;
@@ -98,6 +99,13 @@
 			goto freeout;
 	}
 
+	if (!dm_task_set_mode(dmt, mode))
+		goto freeout;
+	if (!dm_task_set_uid(dmt, uid))
+		goto freeout;
+	if (!dm_task_set_gid(dmt, gid))
+		goto freeout;
+
 	dm_task_no_open_count(dmt);
 
 	r = dm_task_run (dmt);
--- multipath-tools/kpartx/devmapper.h	2006/09/19 21:06:40	1.3.2.1
+++ multipath-tools/kpartx/devmapper.h	2008/04/14 22:32:04	1.3.2.2
@@ -1,7 +1,7 @@
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *, unsigned long,
-	       char *, int);
+	       char *, int, mode_t, uid_t, gid_t);
 int dm_map_present (char *);
 const char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
--- multipath-tools/kpartx/kpartx.c	2007/10/19 21:41:56	1.7.2.2
+++ multipath-tools/kpartx/kpartx.c	2008/04/14 22:32:04	1.7.2.3
@@ -511,7 +511,9 @@
 					DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
 
 				dm_addmap(op, partname, DM_TARGET, params,
-					  slices[j].size, uuid, j+1);
+					  slices[j].size, uuid, j+1,
+					  buf.st_mode & 0777, buf.st_uid,
+					  buf.st_gid);
 
 				if (op == DM_DEVICE_RELOAD)
 					dm_simplecmd(DM_DEVICE_RESUME,
--- multipath-tools/libmultipath/config.c	2008/01/25 22:30:00	1.17.2.2
+++ multipath-tools/libmultipath/config.c	2008/04/14 22:32:04	1.17.2.3
@@ -407,6 +407,7 @@
 	conf->dev_type = DEV_NONE;
 	conf->rr_min_io = DEFAULT_RR_MIN_IO;
 	conf->max_fds = 0;
+	conf->attribute_flags = 0;
 	conf->bindings_file = DEFAULT_BINDINGS_FILE;
 
 	/*
--- multipath-tools/libmultipath/config.h	2008/01/25 22:30:00	1.17.2.2
+++ multipath-tools/libmultipath/config.h	2008/04/14 22:32:04	1.17.2.3
@@ -1,6 +1,8 @@
 #ifndef _CONFIG_H
 #define _CONFIG_H
 
+#include <sys/types.h>
+
 #ifndef _VECTOR_H
 #include "vector.h"
 #endif
@@ -41,6 +43,10 @@
 	int rr_weight;
 	int no_path_retry;
 	int pg_timeout;
+	int attribute_flags;
+	uid_t uid;
+	gid_t gid;
+	mode_t mode;
 
 	char * wwid;
 	char * selector;
@@ -68,6 +74,10 @@
 	int user_friendly_names;
 	int pg_timeout;
 	int max_fds;
+	int attribute_flags;
+	uid_t uid;
+	gid_t gid;
+	mode_t mode;
 
 	char * dev;
 	char * udev_dir;
--- multipath-tools/libmultipath/devmapper.c	2007/07/31 22:19:56	1.18.2.1
+++ multipath-tools/libmultipath/devmapper.c	2008/04/14 22:32:04	1.18.2.2
@@ -111,40 +111,48 @@
 }
 
 extern int
-dm_addmap (int task, const char *name, const char *target,
-	   const char *params, unsigned long long size, const char *uuid) {
+dm_addmap (int task, const char *target, struct multipath *mpp, int use_wwid) {
 	int r = 0;
 	struct dm_task *dmt;
-	char *prefixed_uuid = NULL;
+	char *prefixed_wwid = NULL;
 
 	if (!(dmt = dm_task_create (task)))
 		return 0;
 
-	if (!dm_task_set_name (dmt, name))
+	if (!dm_task_set_name (dmt, mpp->alias))
 		goto addout;
 
-	if (!dm_task_add_target (dmt, 0, size, target, params))
+	if (!dm_task_add_target (dmt, 0, mpp->size, target, mpp->params))
 		goto addout;
 
-	if (uuid) {
-		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(uuid) + 1);
-		if (!prefixed_uuid) {
+	if (use_wwid && mpp->wwid) {
+		prefixed_wwid = MALLOC(UUID_PREFIX_LEN + strlen(mpp->wwid) + 1);
+		if (!prefixed_wwid) {
 			condlog(0, "cannot create prefixed uuid : %s\n",
 				strerror(errno));
 			goto addout;
 		}
-		sprintf(prefixed_uuid, UUID_PREFIX "%s", uuid);
-		if (!dm_task_set_uuid(dmt, prefixed_uuid)) 
+		sprintf(prefixed_wwid, UUID_PREFIX "%s", mpp->wwid);
+		if (!dm_task_set_uuid(dmt, prefixed_wwid)) 
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
 	dm_task_no_open_count(dmt);
 
 	r = dm_task_run (dmt);
 
 	freeout:
-	if (prefixed_uuid)
-		free(prefixed_uuid);
+	if (prefixed_wwid)
+		free(prefixed_wwid);
 
 	addout:
 	dm_task_destroy (dmt);
--- multipath-tools/libmultipath/devmapper.h	2005/11/04 23:35:28	1.10
+++ multipath-tools/libmultipath/devmapper.h	2008/04/14 22:32:04	1.10.2.1
@@ -2,8 +2,7 @@
 void dm_restore_log(void);
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
-int dm_addmap (int, const char *, const char *, const char *,
-	       unsigned long long, const char *uuid);
+int dm_addmap (int, const char *, struct multipath *mpp, int use_wwid);
 int dm_map_present (char *);
 int dm_get_map(char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
--- multipath-tools/libmultipath/dict.c	2008/01/25 22:30:00	1.16.2.3
+++ multipath-tools/libmultipath/dict.c	2008/04/14 22:32:04	1.16.2.4
@@ -4,6 +4,9 @@
  * Copyright (c) 2005 Benjamin Marzinski, Redhat
  * Copyright (c) 2005 Kiyoshi Ueda, NEC
  */
+#include <sys/types.h>
+#include <pwd.h>
+
 #include "vector.h"
 #include "hwtable.h"
 #include "structs.h"
@@ -160,6 +163,79 @@
 }
 
 static int
+def_mode_handler(vector strvec)
+{
+	mode_t mode;
+	char *buff;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	if (sscanf(buff, "%o", &mode) == 1 && mode <= 0777){
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
+	/*
+	char passwd_buf[1024];
+	struct passwd info, *found;
+	*/
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+	/* Can't do this for statically linked binaries, because libnss
+	   must be dynamically loaded.  When we can use dynamically link
+	   binaries in the initramfs, we can put this back */
+	/*if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+		conf->attribute_flags |= (1 << ATTR_UID);
+		conf->uid = info.pw_uid;
+	}
+	else */if (sscanf(buff, "%u", &uid) == 1){
+		conf->attribute_flags |= (1 << ATTR_UID);
+		conf->uid = uid;
+	}
+	FREE(buff);
+	return 0;
+}
+
+static int
+def_gid_handler(vector strvec)
+{
+	gid_t gid;
+	char *buff;
+	/*
+	char passwd_buf[1024];
+	struct passwd info, *found;
+	*/
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	/*if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+		conf->attribute_flags |= (1 << ATTR_GID);
+		conf->gid = info.pw_gid;
+	}
+	else */if (sscanf(buff, "%u", &gid) == 1){
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
@@ -781,6 +857,88 @@
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
+	if (sscanf(buff, "%o", &mode) == 1 && mode <= 0777){
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
+	/*
+	char passwd_buf[1024];
+	struct passwd info, *found;
+	*/
+	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
+
+	if (!mpe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	/*if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+		mpe->attribute_flags |= (1 << ATTR_UID);
+		mpe->uid = info.pw_uid;
+	}
+	else */if (sscanf(buff, "%u", &uid) == 1){
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
+	/*
+	char passwd_buf[1024];
+	struct passwd info, *found;
+	*/
+	struct mpentry *mpe = VECTOR_LAST_SLOT(conf->mptable);
+
+	if (!mpe)
+		return 1;
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	/*if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+		mpe->attribute_flags |= (1 << ATTR_GID);
+		mpe->gid = info.pw_gid;
+	}
+	else */if (sscanf(buff, "%u", &gid) == 1){
+		mpe->attribute_flags |= (1 << ATTR_GID);
+		mpe->gid = gid;
+	}
+	FREE(buff);
+	return 0;
+}
+
+static int
 mp_pg_timeout_handler(vector strvec)
 {
 	int pg_timeout;
@@ -832,6 +990,9 @@
 	install_keyword("pg_timeout", &default_pg_timeout_handler);
 	install_keyword("user_friendly_names", &names_handler);
 	install_keyword("bindings_file", &bindings_file_handler);
+	install_keyword("mode", &def_mode_handler);
+	install_keyword("uid", &def_uid_handler);
+	install_keyword("gid", &def_gid_handler);
 
 	/*
 	 * deprecated synonyms
@@ -877,6 +1038,9 @@
 	install_keyword("rr_weight", &mp_weight_handler);
 	install_keyword("no_path_retry", &mp_no_path_retry_handler);
 	install_keyword("pg_timeout", &mp_pg_timeout_handler);
+	install_keyword("mode",	&mp_mode_handler);
+	install_keyword("uid", &mp_uid_handler);
+	install_keyword("gid", &mp_gid_handler);
 	install_sublevel_end();
 
 	return keywords;
--- multipath-tools/libmultipath/propsel.c	2006/12/01 23:45:18	1.9.2.1
+++ multipath-tools/libmultipath/propsel.c	2008/04/14 22:32:04	1.9.2.2
@@ -173,6 +173,60 @@
 }
 
 extern int
+select_mode (struct multipath *mp)
+{
+	if (mp->mpe && (mp->mpe->attribute_flags & (1 << ATTR_MODE))) {
+		mp->attribute_flags |= (1 << ATTR_MODE);
+		mp->mode = mp->mpe->mode;
+		condlog(3, "mode = 0%o (multipath setting)", mp->mode);
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
+		condlog(3, "uid = %u (multipath setting)", mp->uid);
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
+		condlog(3, "gid = %u (multipath setting)", mp->gid);
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
+extern int
 select_features (struct multipath * mp)
 {
 	if (mp->hwe && mp->hwe->features) {
--- multipath-tools/libmultipath/propsel.h	2006/12/01 23:45:18	1.4.2.1
+++ multipath-tools/libmultipath/propsel.h	2008/04/14 22:32:04	1.4.2.2
@@ -11,3 +11,6 @@
 int select_no_path_retry(struct multipath *mp);
 int select_pg_timeout(struct multipath *mp);
 int select_rr_min_io(struct multipath *mp);
+int select_mode(struct multipath *mp);
+int select_uid(struct multipath *mp);
+int select_gid(struct multipath *mp);
--- multipath-tools/libmultipath/structs.h	2008/01/25 22:30:00	1.17.2.6
+++ multipath-tools/libmultipath/structs.h	2008/04/14 22:32:04	1.17.2.7
@@ -1,6 +1,8 @@
 #ifndef _STRUCTS_H
 #define _STRUCTS_H
 
+#include <sys/types.h>
+
 #define WWID_SIZE		128
 #define SERIAL_SIZE		64
 #define NODE_NAME_SIZE		19
@@ -63,6 +65,12 @@
 	PGTIMEOUT_NONE
 };
 
+enum attribute_bits {
+	ATTR_UID,
+	ATTR_GID,
+	ATTR_MODE,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
@@ -133,6 +141,11 @@
 	int no_path_retry; /* number of retries after all paths are down */
 	int retry_tick;    /* remaining times for retries */
 	int pg_timeout;
+	int attribute_flags;
+	uid_t uid;
+	gid_t gid;
+	mode_t mode;
+
 	unsigned long long size;
 	vector paths;
 	vector pg;
--- multipath-tools/multipath/main.c	2007/12/17 23:15:22	1.41.2.6
+++ multipath-tools/multipath/main.c	2008/04/14 22:32:04	1.41.2.7
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.41.2.6 2007/12/17 23:15:22 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.41.2.7 2008/04/14 22:32:04 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -33,7 +33,6 @@
 #include <vector.h>
 #include <memory.h>
 #include <libdevmapper.h>
-#include <devmapper.h>
 #include <checkers.h>
 #include <path_state.h>
 #include <blacklist.h>
@@ -51,6 +50,7 @@
 #include <sysfs/libsysfs.h>
 #include <print.h>
 #include <alias.h>
+#include <devmapper.h>
 
 #include "main.h"
 #include "pgpolicies.h"
@@ -669,8 +669,7 @@
 		if (dm_map_present(mpp->alias))
 			break;
 
-		r = dm_addmap(DM_DEVICE_CREATE, mpp->alias, DEFAULT_TARGET,
-			      mpp->params, mpp->size, mpp->wwid);
+		r = dm_addmap(DM_DEVICE_CREATE, DEFAULT_TARGET, mpp, 1);
 
 		/*
 		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE plus
@@ -689,8 +688,7 @@
 		break;
 
 	case ACT_RELOAD:
-		r = (dm_addmap(DM_DEVICE_RELOAD, mpp->alias, DEFAULT_TARGET,
-			      mpp->params, mpp->size, NULL) &&
+		r = (dm_addmap(DM_DEVICE_RELOAD, DEFAULT_TARGET, mpp, 0) &&
 		     dm_simplecmd(DM_DEVICE_RESUME, mpp->alias));
 		break;
 
@@ -774,6 +772,9 @@
 		mpp->hwe = pp1->hwe;
 		strcpy(mpp->wwid, pp1->wwid);
 		select_alias(mpp);
+		select_mode(mpp);
+		select_uid(mpp);
+		select_gid(mpp);
 
 		pp1->mpp = mpp;
 		mpp->size = pp1->size;
