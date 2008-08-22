From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/config.h libmulti ...
Date: 22 Aug 2008 21:55:45 -0000
Message-ID: <20080822215545.4867.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-08-22 21:55:44

Modified files:
	libmultipath   : config.h configure.c devmapper.c devmapper.h 
	                 print.c print.h 
	multipath      : main.c 

Log message:
	Fix for bz 444421. Pulled in various patches from upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.3&r2=1.18.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/configure.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.2.2.1&r2=1.2.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.22.2.3&r2=1.22.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/devmapper.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.1&r2=1.11.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/print.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/print.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.3.2.1&r2=1.3.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.44.2.5&r2=1.44.2.6

--- multipath-tools/libmultipath/config.h	2008/01/15 01:34:36	1.18.2.3
+++ multipath-tools/libmultipath/config.h	2008/08/22 21:55:43	1.18.2.4
@@ -64,6 +64,7 @@
 	int user_friendly_names;
 	int pg_timeout;
 	int max_fds;
+	int force_reload;
 
 	char * dev;
 	char * udev_dir;
--- multipath-tools/libmultipath/configure.c	2007/06/15 19:03:02	1.2.2.1
+++ multipath-tools/libmultipath/configure.c	2008/08/22 21:55:43	1.2.2.2
@@ -169,6 +169,12 @@
 			mpp->alias);
 		return;
 	}
+	if (conf->force_reload) {
+		mpp->action = ACT_RELOAD;
+		condlog(3, "%s: set ACT_RELOAD (forced by user)",
+			mpp->alias);
+		return;
+	}
 	if (cmpp->size != mpp->size) {
 		mpp->action = ACT_RELOAD;
 		condlog(3, "%s: set ACT_RELOAD (size change)",
@@ -329,8 +335,12 @@
 			break;
 
 		r = dm_addmap(DM_DEVICE_CREATE, mpp->alias, DEFAULT_TARGET,
-			      mpp->params, mpp->size, mpp->wwid);
+			      mpp->params, mpp->size, mpp->wwid, 0);
 
+		if (!r)
+			r = dm_addmap(DM_DEVICE_CREATE, mpp->alias,
+				      DEFAULT_TARGET, mpp->params, mpp->size,
+				      mpp->wwid, 1);
 		/*
 		 * DM_DEVICE_CREATE is actually DM_DEV_CREATE plus
 		 * DM_TABLE_LOAD. Failing the second part leaves an
@@ -347,9 +357,14 @@
 		break;
 
 	case ACT_RELOAD:
-		r = (dm_addmap(DM_DEVICE_RELOAD, mpp->alias, DEFAULT_TARGET,
-			      mpp->params, mpp->size, NULL) &&
-		     dm_simplecmd(DM_DEVICE_RESUME, mpp->alias));
+		r = dm_addmap(DM_DEVICE_RELOAD, mpp->alias, DEFAULT_TARGET,
+			      mpp->params, mpp->size, NULL, 0);
+		if (!r)
+			r = dm_addmap(DM_DEVICE_RELOAD, mpp->alias,
+				      DEFAULT_TARGET, mpp->params, mpp->size,
+				      NULL, 1);
+		if (r)
+			r = dm_simplecmd(DM_DEVICE_RESUME, mpp->alias);
 		break;
 
 	case ACT_RENAME:
@@ -415,6 +430,10 @@
 
 	memset(empty_buff, 0, WWID_SIZE);
 
+	if (conf->force_reload)
+		vector_foreach_slot (pathvec, pp1, k)
+			pp1->mpp = NULL;
+
 	vector_foreach_slot (pathvec, pp1, k) {
 		/* skip this path for some reason */
 
--- multipath-tools/libmultipath/devmapper.c	2007/08/16 16:41:58	1.22.2.3
+++ multipath-tools/libmultipath/devmapper.c	2008/08/22 21:55:43	1.22.2.4
@@ -153,7 +153,8 @@
 
 extern int
 dm_addmap (int task, const char *name, const char *target,
-	   const char *params, unsigned long long size, const char *uuid) {
+	   const char *params, unsigned long long size, const char *uuid,
+	   int ro) {
 	int r = 0;
 	struct dm_task *dmt;
 	char *prefixed_uuid = NULL;
@@ -167,6 +168,9 @@
 	if (!dm_task_add_target (dmt, 0, size, target, params))
 		goto addout;
 
+	if (ro)
+		dm_task_set_ro(dmt);
+
 	if (uuid){
 		prefixed_uuid = MALLOC(UUID_PREFIX_LEN + strlen(uuid) + 1);
 		if (!prefixed_uuid) {
--- multipath-tools/libmultipath/devmapper.h	2007/06/15 19:03:02	1.11.2.1
+++ multipath-tools/libmultipath/devmapper.h	2008/08/22 21:55:43	1.11.2.2
@@ -2,7 +2,7 @@
 int dm_prereq (char *, int, int, int);
 int dm_simplecmd (int, const char *);
 int dm_addmap (int, const char *, const char *, const char *,
-	       unsigned long long, const char *uuid);
+	       unsigned long long, const char *uuid, int);
 int dm_map_present (char *);
 int dm_get_map(char *, unsigned long long *, char *);
 int dm_get_status(char *, char *);
--- multipath-tools/libmultipath/print.c	2008/07/09 20:11:33	1.5.2.2
+++ multipath-tools/libmultipath/print.c	2008/08/22 21:55:43	1.5.2.3
@@ -94,6 +94,17 @@
 }
 
 static int
+snprint_ro (char * buff, size_t len, struct multipath * mpp)
+{
+	if (!mpp->dmi)
+		return snprintf(buff, len, "n/a");
+	if (mpp->dmi->read_only)
+		return snprintf(buff, len, "ro");
+	else
+		return snprintf(buff, len, "rw");
+}
+
+static int
 snprint_progress (char * buff, size_t len, int cur, int total)
 {
 	int i = PROGRESS_LEN * cur / total;
@@ -367,6 +378,7 @@
 	{'F', "failback",      0, snprint_failback},
 	{'Q', "queueing",      0, snprint_queueing},
 	{'N', "paths",         0, snprint_nb_paths},
+	{'r', "write_prot",    0, snprint_ro},
 	{'t', "dm-st",         0, snprint_dm_map_state},
 	{'S', "size",          0, snprint_multipath_size},
 	{'f', "features",      0, snprint_features},
@@ -688,7 +700,7 @@
 	if (fwd > len)
 		return len;
 	fwd += snprint_multipath(buff + fwd, len - fwd,
-				 "[size=%S][features=%f][hwhandler=%h]", mpp);
+				 "[size=%S][features=%f][hwhandler=%h][%r]", mpp);
 	if (fwd > len)
 		return len;
 
--- multipath-tools/libmultipath/print.h	2007/01/10 20:08:08	1.3.2.1
+++ multipath-tools/libmultipath/print.h	2008/08/22 21:55:43	1.3.2.2
@@ -1,7 +1,7 @@
 #define PRINT_PATH_LONG      "%w %i %d %D %p %t%T %s"
 #define PRINT_PATH_INDENT    " \\_ %i %d %D %t%T"
 #define PRINT_PATH_CHECKER   "%i %d %D %p %t%T %C"
-#define PRINT_MAP_STATUS     "%n %F %Q %N %t"
+#define PRINT_MAP_STATUS     "%n %F %Q %N %t %r"
 #define PRINT_MAP_STATS      "%n %0 %1 %2 %3 %4"
 #define PRINT_MAP_NAMES      "%n %d %w"
 #define PRINT_PG_INDENT      "\\_ %s [prio=%p]%t"
--- multipath-tools/multipath/main.c	2008/05/12 17:46:41	1.44.2.5
+++ multipath-tools/multipath/main.c	2008/08/22 21:55:43	1.44.2.6
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.44.2.5 2008/05/12 17:46:41 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.44.2.6 2008/08/22 21:55:43 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -72,7 +72,7 @@
 usage (char * progname)
 {
 	fprintf (stderr, VERSION_STRING);
-	fprintf (stderr, "Usage: %s\t[-v level] [-d] [-h|-l|-ll|-f|-F]\n",
+	fprintf (stderr, "Usage: %s\t[-v level] [-d] [-h|-l|-ll|-f|-F|-r]\n",
 		progname);
 	fprintf (stderr,
 		"\t\t\t[-p failover|multibus|group_by_serial|group_by_prio]\n" \
@@ -90,6 +90,7 @@
 		"\t-ll\t\tshow multipath topology (maximum info)\n" \
 		"\t-f\t\tflush a multipath device map\n" \
 		"\t-F\t\tflush all multipath device maps\n" \
+		"\t-r\t\tforce devmap reload\n" \
 		"\t-p policy\tforce all maps to specified policy :\n" \
 		"\t   failover\t\t1 path per priority group\n" \
 		"\t   multibus\t\tall paths in 1 priority group\n" \
@@ -323,7 +324,7 @@
 	if (load_config(DEFAULT_CONFIGFILE))
 		exit(1);
 
-	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:")) != EOF ) {
+	while ((arg = getopt(argc, argv, ":dhl::FfM:v:p:b:r")) != EOF ) {
 		switch(arg) {
 		case 1: printf("optarg : %s\n",optarg);
 			break;
@@ -368,6 +369,9 @@
 				usage(argv[0]);
 			}                
 			break;
+		case 'r':
+			conf->force_reload = 1;
+			break;
 		case 'h':
 			usage(argv[0]);
 		case ':':
