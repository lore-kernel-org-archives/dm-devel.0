From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 25 Aug 2008 20:59:08 -0000
Message-ID: <20080825205908.14166.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-08-25 20:59:06

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.synthetic 
	kpartx         : devmapper.c devmapper.h kpartx.c 
	libmultipath   : config.c config.h configure.c devmapper.c 
	                 devmapper.h dict.c propsel.c propsel.h 
	                 structs.h structs_vec.c 

Log message:
	Fix for bz #431843.  Added three new parameters to /etc/multipath.conf:
	mode, uid, and gid.  These can be used to override the default values when
	multipath device nodes are created. Unfortunately, you cannot do name
	resolution with static binaries, since you must load libnss dynamically, so
	uid and gid must use the numerical user id and group id.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.5&r2=1.18.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.synthetic.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.3&r2=1.11.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.8&r2=1.8.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/kpartx/kpartx.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.9&r2=1.9.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19.2.5&r2=1.19.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.4&r2=1.18.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.2&r2=1.2.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.22.2.4&r2=1.22.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.2&r2=1.11.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.4&r2=1.17.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11&r2=1.11.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.2&r2=1.18.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs_vec.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.1.2.1&r2=1.1.2.2

--- multipath-tools/multipath.conf.annotated	2008/01/15 01:34:36	1.18.2.5
+++ multipath-tools/multipath.conf.annotated	2008/08/25 20:59:05	1.18.2.6
@@ -143,6 +143,33 @@
 #	# default : "/var/lib/multipath/bindings"
 #	bindings_file "/etc/multipath_bindings"
 #
+#	#
+#	# name    : mode
+#	# scope   : multipath
+#	# desc    : The mode to use for the multipath device nodes, in octal.
+#	# values  : 0000 - 0777
+#	# default : determined by the process
+#	mode    0644
+#
+#	#
+#	# name    : uid
+#	# scope   : multipath
+#	# desc    : The user id to use for the multipath device nodes. You
+#	#           must use the numeric user id.
+#	# values  : <user_id_number>
+#	# default : determined by the process
+#	uid     0
+#
+#	#
+#	# name    : gid
+#	# scope   : multipath
+#	# desc    : The group id to use for the multipath device nodes. You
+#	#           must use the numeric group id.
+#	# values  : <group_id_number>
+#	# default : determined by the process
+#	gid     0
+#
+
 #}
 #	
 ##
@@ -264,6 +291,34 @@
 #		# default : 1000
 #		#
 #		rr_min_io	100
+#
+#		#
+#		# name    : mode
+#		# scope   : multipath
+#		# desc    : The mode to use for the multipath device node,
+#		#           in octal.
+#		# values  : 0000 - 0777
+#		# default : determined by the process
+#		mode    0644
+#
+#		#
+#		# name    : uid
+#		# scope   : multipath
+#		# desc    : The user id to use for the multipath device node.
+#		#           You must use the numeric user id.
+#		# values  : <user_id_number>
+#		# default : determined by the process
+#		uid     0
+#
+#		#
+#		# name    : gid
+#		# scope   : multipath
+#		# desc    : The group id to use for the multipath device node.
+#		#           You must use the numeric group id.
+#		# values  : <group_id_number>
+#		# default : determined by the process
+#		gid     0
+#
 #	}
 #	multipath {
 #		wwid	1DEC_____321816758474
--- multipath-tools/multipath.conf.synthetic	2008/01/15 01:34:36	1.11.2.3
+++ multipath-tools/multipath.conf.synthetic	2008/08/25 20:59:05	1.11.2.4
@@ -16,6 +16,9 @@
 #	failback		immediate
 #	no_path_retry		fail
 #	user_friendly_names	no
+#	mode			0666
+#	uid			0
+#	gid			0
 #}
 #blacklist {
 #       wwid 26353900f02796769
--- multipath-tools/kpartx/devmapper.c	2006/10/13 23:28:47	1.8
+++ multipath-tools/kpartx/devmapper.c	2008/08/25 20:59:06	1.8.2.1
@@ -74,7 +74,8 @@
 
 extern int
 dm_addmap (int task, const char *name, const char *target,
-	   const char *params, uint64_t size, const char *uuid, int part) {
+	   const char *params, uint64_t size, const char *uuid, int part,
+	   mode_t mode, uid_t uid, gid_t gid) {
 	int r = 0;
 	struct dm_task *dmt;
 	char *prefixed_uuid = NULL;
@@ -100,6 +101,13 @@
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
--- multipath-tools/kpartx/devmapper.h	2006/10/13 23:28:47	1.5
+++ multipath-tools/kpartx/devmapper.h	2008/08/25 20:59:06	1.5.2.1
@@ -3,7 +3,7 @@
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *, uint64_t,
-	       const char *, int);
+	       const char *, int, mode_t, uid_t, gid_t);
 int dm_map_present (char *);
 char * dm_mapname(int major, int minor);
 dev_t dm_get_first_dep(char *devname);
--- multipath-tools/kpartx/kpartx.c	2006/10/13 23:28:47	1.9
+++ multipath-tools/kpartx/kpartx.c	2008/08/25 20:59:06	1.9.2.1
@@ -424,7 +424,9 @@
 					DM_DEVICE_RELOAD : DM_DEVICE_CREATE);
 
 				dm_addmap(op, partname, DM_TARGET, params,
-					  slices[j].size, uuid, j+1);
+					  slices[j].size, uuid, j+1,
+					  buf.st_mode & 0777, buf.st_uid,
+					  buf.st_gid);
 
 				if (op == DM_DEVICE_RELOAD)
 					dm_simplecmd(DM_DEVICE_RESUME,
--- multipath-tools/libmultipath/config.c	2008/01/15 01:34:36	1.19.2.5
+++ multipath-tools/libmultipath/config.c	2008/08/25 20:59:06	1.19.2.6
@@ -412,6 +412,7 @@
 	conf->dev_type = DEV_NONE;
 	conf->minio = 1000;
 	conf->max_fds = 0;
+	conf->attribute_flags = 0;
 
 	/*
 	 * read the config file
--- multipath-tools/libmultipath/config.h	2008/08/22 21:55:43	1.18.2.4
+++ multipath-tools/libmultipath/config.h	2008/08/25 20:59:06	1.18.2.5
@@ -1,6 +1,8 @@
 #ifndef _CONFIG_H
 #define _CONFIG_H
 
+#include <sys/types.h>
+
 #define ORIGIN_DEFAULT 0
 #define ORIGIN_CONFIG  1
 
@@ -43,6 +45,10 @@
 	int no_path_retry;
 	int minio;
 	int pg_timeout;
+	int attribute_flags;
+	uid_t uid;
+	gid_t gid;
+	mode_t mode;
 };
 
 struct config {
@@ -65,6 +71,10 @@
 	int pg_timeout;
 	int max_fds;
 	int force_reload;
+	int attribute_flags;
+	uid_t uid;
+	gid_t gid;
+	mode_t mode;
 
 	char * dev;
 	char * udev_dir;
--- multipath-tools/libmultipath/configure.c	2008/08/22 21:55:43	1.2.2.2
+++ multipath-tools/libmultipath/configure.c	2008/08/25 20:59:06	1.2.2.3
@@ -18,7 +18,6 @@
 
 #include "vector.h"
 #include "memory.h"
-#include "devmapper.h"
 #include "defaults.h"
 #include "structs.h"
 #include "structs_vec.h"
@@ -34,6 +33,7 @@
 #include "pgpolicies.h"
 #include "dict.h"
 #include "alias.h"
+#include "devmapper.h"
 
 extern int
 setup_map (struct multipath * mpp)
@@ -334,13 +334,11 @@
 		if (dm_map_present(mpp->alias))
 			break;
 
-		r = dm_addmap(DM_DEVICE_CREATE, mpp->alias, DEFAULT_TARGET,
-			      mpp->params, mpp->size, mpp->wwid, 0);
+		r = dm_addmap(DM_DEVICE_CREATE, DEFAULT_TARGET, mpp, 1, 0);
 
 		if (!r)
-			r = dm_addmap(DM_DEVICE_CREATE, mpp->alias,
-				      DEFAULT_TARGET, mpp->params, mpp->size,
-				      mpp->wwid, 1);
+			r = dm_addmap(DM_DEVICE_CREATE, DEFAULT_TARGET, mpp, 1,
+				      1);
 		/*
 		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE plus
 		 * DM_TABLE_LOAD. Failing the second part leaves an
@@ -357,12 +355,10 @@
 		break;
 
 	case ACT_RELOAD:
-		r = dm_addmap(DM_DEVICE_RELOAD, mpp->alias, DEFAULT_TARGET,
-			      mpp->params, mpp->size, NULL, 0);
+		r = dm_addmap(DM_DEVICE_RELOAD, DEFAULT_TARGET, mpp, 0, 0);
 		if (!r)
-			r = dm_addmap(DM_DEVICE_RELOAD, mpp->alias,
-				      DEFAULT_TARGET, mpp->params, mpp->size,
-				      NULL, 1);
+			r = dm_addmap(DM_DEVICE_RELOAD, DEFAULT_TARGET, mpp, 0,
+				      1);
 		if (r)
 			r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias);
 		break;
--- multipath-tools/libmultipath/devmapper.c	2008/08/22 21:55:43	1.22.2.4
+++ multipath-tools/libmultipath/devmapper.c	2008/08/25 20:59:06	1.22.2.5
@@ -152,44 +152,53 @@
 }
 
 extern int
-dm_addmap (int task, const char *name, const char *target,
-	   const char *params, unsigned long long size, const char *uuid,
+dm_addmap (int task, const char *target, struct multipath *mpp, int use_wwid,
 	   int ro) {
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
 
 	if (ro)
 		dm_task_set_ro(dmt);
 
-	if (uuid){
-		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(uuid) + 1);
-		if (!prefixed_uuid) {
+	if (use_wwid && mpp->wwid){
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
+
 	dm_task_no_open_count(dmt);
 
 	r = dm_task_run (dmt);
 
 	freeout:
-	if (prefixed_uuid)
-		free(prefixed_uuid);
+	if (prefixed_wwid)
+		free(prefixed_wwid);
 
 	addout:
 	dm_task_destroy (dmt);
--- multipath-tools/libmultipath/devmapper.h	2008/08/22 21:55:43	1.11.2.2
+++ multipath-tools/libmultipath/devmapper.h	2008/08/25 20:59:06	1.11.2.3
@@ -1,8 +1,7 @@
 void dm_init(void);
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
-int dm_addmap (int, const char *, const char *, const char *,
-	       unsigned long long, const char *uuid, int);
+int dm_addmap (int, const char *, struct multipath *, int, int); 
 int dm_map_present (char *);
 int dm_get_map(char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
--- multipath-tools/libmultipath/dict.c	2008/01/15 01:34:36	1.17.2.4
+++ multipath-tools/libmultipath/dict.c	2008/08/25 20:59:06	1.17.2.5
@@ -5,6 +5,8 @@
  * Copyright (c) 2005 Kiyoshi Ueda, NEC
  */
 #include <checkers.h>
+#include <sys/types.h>
+#include <pwd.h>
 
 #include "vector.h"
 #include "hwtable.h"
@@ -163,6 +165,79 @@
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
+	   char passwd_buf[1024];
+	   struct passwd info, *found;
+	 */
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+	/* Can't do this for statically linked binaries, because libnss
+	   must be dynamically loaded.  When we can use dynamically link
+	   binaries in the initramfs, we can put this back */
+	/*if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+	  conf->attribute_flags |= (1 << ATTR_UID);
+	  conf->uid = info.pw_uid;
+	  }
+	  else */if (sscanf(buff, "%u", &uid) == 1){
+		  conf->attribute_flags |= (1 << ATTR_UID);
+		  conf->uid = uid;
+	  }
+	  FREE(buff);
+	  return 0;
+}
+
+static int
+def_gid_handler(vector strvec)
+{
+	gid_t gid;
+	char *buff;
+	/*
+	   char passwd_buf[1024];
+	   struct passwd info, *found;
+	 */
+
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+
+	/*if (getpwnam_r(buff, &info, passwd_buf, 1024, &found) == 0 && found) {
+	  conf->attribute_flags |= (1 << ATTR_GID);
+	  conf->gid = info.pw_gid;
+	  }
+	  else */if (sscanf(buff, "%u", &gid) == 1){
+		  conf->attribute_flags |= (1 << ATTR_GID);
+		  conf->gid = gid;
+	  }
+	  FREE(buff);
+	  return 0;
+}
+
+static int
 def_weight_handler(vector strvec)
 {
 	char * buff;
@@ -938,6 +1013,88 @@
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
+	   char passwd_buf[1024];
+	   struct passwd info, *found;
+	 */
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
+	  mpe->attribute_flags |= (1 << ATTR_UID);
+	  mpe->uid = info.pw_uid;
+	  }
+	  else */if (sscanf(buff, "%u", &uid) == 1){
+		  mpe->attribute_flags |= (1 << ATTR_UID);
+		  mpe->uid = uid;
+	  }
+	  FREE(buff);
+	  return 0;
+}
+
+static int
+mp_gid_handler(vector strvec)
+{
+	gid_t gid;
+	char *buff;
+	/*
+	   char passwd_buf[1024];
+	   struct passwd info, *found;
+	 */
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
+	  mpe->attribute_flags |= (1 << ATTR_GID);
+	  mpe->gid = info.pw_gid;
+	  }
+	  else */if (sscanf(buff, "%u", &gid) == 1){
+		  mpe->attribute_flags |= (1 << ATTR_GID);
+		  mpe->gid = gid;
+	  }
+	  FREE(buff);
+	  return 0;
+}
+
+static int
 mp_pg_timeout_handler(vector strvec)
 {
 	int pg_timeout;
@@ -1018,6 +1175,36 @@
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
+	return snprintf(buff, len, "%u", mpe->uid);
+}
+
+static int
+snprint_mp_gid(char * buff, int len, void * data)
+{
+	struct mpentry * mpe = (struct mpentry *)data;
+
+	if ((mpe->attribute_flags & (1 << ATTR_GID)) == 0)
+		return 0;
+	return snprintf(buff, len, "%u", mpe->gid);
+}
+
+static int
 snprint_mp_failback (char * buff, int len, void * data)
 {
 	struct mpentry * mpe = (struct mpentry *)data;
@@ -1472,6 +1659,30 @@
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
+	return snprintf(buff, len, "%u", conf->uid);
+}
+
+static int
+snprint_def_gid(char * buff, int len, void * data)
+{
+	if ((conf->attribute_flags & (1 << ATTR_GID)) == 0)
+		return 0;
+	return snprintf(buff, len, "%u", conf->gid);
+}
+
+static int
 snprint_def_rr_weight (char * buff, int len, void * data)
 {
 	if (!conf->rr_weight)
@@ -1590,6 +1801,9 @@
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
 	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
+	install_keyword("mode", &def_mode_handler, &snprint_def_mode);
+	install_keyword("uid", &def_uid_handler, &snprint_def_uid);
+	install_keyword("gid", &def_gid_handler, &snprint_def_gid);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
@@ -1657,5 +1871,8 @@
 	install_keyword("no_path_retry", &mp_no_path_retry_handler, &snprint_mp_no_path_retry);
 	install_keyword("rr_min_io", &mp_minio_handler, &snprint_mp_rr_min_io);
 	install_keyword("pg_timeout", &mp_pg_timeout_handler, &snprint_mp_pg_timeout);
+	install_keyword("mode", &mp_mode_handler, &snprint_mp_mode);
+	install_keyword("uid", &mp_uid_handler, &snprint_mp_uid);
+	install_keyword("gid", &mp_gid_handler, &snprint_mp_gid);
 	install_sublevel_end();
 }
--- multipath-tools/libmultipath/propsel.c	2006/08/02 21:37:22	1.11
+++ multipath-tools/libmultipath/propsel.c	2008/08/25 20:59:06	1.11.2.1
@@ -331,6 +331,60 @@
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
 select_pg_timeout(struct multipath *mp)
 {
 	if (mp->mpe && mp->mpe->pg_timeout != PGTIMEOUT_UNDEF) {
--- multipath-tools/libmultipath/propsel.h	2006/06/06 18:32:43	1.5
+++ multipath-tools/libmultipath/propsel.h	2008/08/25 20:59:06	1.5.2.1
@@ -11,3 +11,6 @@
 int select_no_path_retry(struct multipath *mp);
 int select_pg_timeout(struct multipath *mp);
 int select_minio(struct multipath *mp);
+int select_mode(struct multipath *mp);
+int select_uid(struct multipath *mp);
+int select_gid(struct multipath *mp);
--- multipath-tools/libmultipath/structs.h	2008/01/15 01:34:36	1.18.2.2
+++ multipath-tools/libmultipath/structs.h	2008/08/25 20:59:06	1.18.2.3
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
@@ -136,6 +144,11 @@
 	int retry_tick;    /* remaining times for retries */
 	int minio;
 	int pg_timeout;
+	int attribute_flags;
+	uid_t uid;
+	gid_t gid;
+	mode_t mode;
+
 	unsigned long long size;
 	vector paths;
 	vector pg;
--- multipath-tools/libmultipath/structs_vec.c	2007/06/15 19:03:02	1.1.2.1
+++ multipath-tools/libmultipath/structs_vec.c	2008/08/25 20:59:06	1.1.2.2
@@ -343,6 +343,9 @@
 
 	strcpy(mpp->wwid, pp->wwid);
 	select_alias(mpp);
+	select_mode(mpp);
+	select_uid(mpp);
+	select_gid(mpp);
 	mpp->size = pp->size;
 
 	if (adopt_paths(vecs->pathvec, mpp))
