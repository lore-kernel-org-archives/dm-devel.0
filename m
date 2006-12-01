From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/config.c libmulti ...
Date: 1 Dec 2006 23:45:20 -0000
Message-ID: <20061201234520.27306.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2006-12-01 23:45:19

Modified files:
	libmultipath   : config.c config.h defaults.h dict.c hwtable.c 
	                 propsel.c propsel.h structs.h 
	multipath      : main.c 
	path_priority/pp_alua: main.c 
	path_priority/pp_hds_modular: pp_hds_modular.c 

Log message:
	Fixes for bugs 217014, 192645, 215509, 187534, and 215505
	
	Applied Dave Wysochanski's patches.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17&r2=1.17.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17&r2=1.17.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/defaults.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.6&r2=1.6.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16&r2=1.16.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.4&r2=1.16.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.9&r2=1.9.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/propsel.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.4&r2=1.4.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.2&r2=1.17.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.41.2.3&r2=1.41.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_alua/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.2&r2=1.2.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/path_priority/pp_hds_modular/pp_hds_modular.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.1&r2=1.1.2.1

--- multipath-tools/libmultipath/config.c	2006/04/19 18:03:46	1.17
+++ multipath-tools/libmultipath/config.c	2006/12/01 23:45:18	1.17.2.1
@@ -263,7 +263,8 @@
 int
 store_hwe_ext (vector hwtable, char * vendor, char * product, int pgp,
 	   char * getuid, char * getprio, char * hwhandler,
-	   char * features, char * checker, int pgfailback, char * blacklist)
+	   char * features, char * checker, int pgfailback, char * blacklist,
+	   int no_path_retry, int rr_weight, int rr_min_io)
 {
 	struct hwentry * hwe;
 
@@ -329,6 +330,15 @@
 		store_regex(hwe->blist, blacklist);
 	}
 
+	if (no_path_retry)
+		hwe->no_path_retry = no_path_retry;
+
+	if (rr_weight)
+		hwe->rr_weight = rr_weight;
+
+	if (rr_min_io)
+		hwe->rr_min_io = rr_min_io;
+
 	if (!vector_alloc_slot(hwtable))
 		goto out;
 
@@ -395,7 +405,7 @@
 		conf->verbosity = 2;
 
 	conf->dev_type = DEV_NONE;
-	conf->minio = 1000;
+	conf->rr_min_io = DEFAULT_RR_MIN_IO;
 	conf->bindings_file = DEFAULT_BINDINGS_FILE;
 
 	/*
--- multipath-tools/libmultipath/config.h	2006/04/19 18:03:46	1.17
+++ multipath-tools/libmultipath/config.h	2006/12/01 23:45:18	1.17.2.1
@@ -17,6 +17,7 @@
 	int pgpolicy;
 	int checker_index;
 	int pgfailback;
+	int rr_min_io;
 	int rr_weight;
 	int no_path_retry;
 	int pg_timeout;
@@ -36,6 +37,7 @@
 	int selector_args;
 	int pgpolicy;
 	int pgfailback;
+	int rr_min_io;
 	int rr_weight;
 	int no_path_retry;
 	int pg_timeout;
@@ -56,7 +58,7 @@
 	int default_pgpolicy;
 	int default_checker_index;
 	int dev_type;
-	int minio;
+	int rr_min_io;
 	int checkint;
 	int max_checkint;
 	int pgfailback;
@@ -98,7 +100,8 @@
 int store_hwe_ext (vector hwtable, char * vendor, char * product, int pgp,
 		char * getuid, char * getprio, char * hwhandler,
 		char * features, char * checker, int pgfailback,
-		char * blacklist);
+		char * blacklist, int no_path_retry, int rr_weight,
+		int rr_min_io);
 
 int load_config (char * file);
 struct config * alloc_config (void);
--- multipath-tools/libmultipath/defaults.h	2005/10/27 02:16:12	1.6
+++ multipath-tools/libmultipath/defaults.h	2006/12/01 23:45:18	1.6.2.1
@@ -10,5 +10,6 @@
 #define DEFAULT_SOCKET		"/var/run/multipathd.sock"
 #define DEFAULT_CONFIGFILE	"/etc/multipath.conf"
 #define DEFAULT_BINDINGS_FILE	"/var/lib/multipath/bindings"
+#define DEFAULT_RR_MIN_IO       1000
 
 char * set_default (char * str);
--- multipath-tools/libmultipath/dict.c	2006/04/19 18:03:46	1.16
+++ multipath-tools/libmultipath/dict.c	2006/12/01 23:45:18	1.16.2.1
@@ -124,7 +124,7 @@
 }
 
 static int
-def_minio_handler(vector strvec)
+def_rr_min_io_handler(vector strvec)
 {
 	char * buff;
 
@@ -133,7 +133,7 @@
 	if (!buff)
 		return 1;
 
-	conf->minio = atoi(buff);
+	conf->rr_min_io = atoi(buff);
 	FREE(buff);
 
 	return 0;
@@ -794,7 +794,7 @@
 	install_keyword("features", &def_features_handler);
 	install_keyword("path_checker", &def_path_checker_handler);
 	install_keyword("failback", &default_failback_handler);
-	install_keyword("rr_min_io", &def_minio_handler);
+	install_keyword("rr_min_io", &def_rr_min_io_handler);
 	install_keyword("rr_weight", &def_weight_handler);
 	install_keyword("no_path_retry", &def_no_path_retry_handler);
 	install_keyword("pg_timeout", &default_pg_timeout_handler);
--- multipath-tools/libmultipath/hwtable.c	2006/09/19 21:06:40	1.16.2.4
+++ multipath-tools/libmultipath/hwtable.c	2006/12/01 23:45:18	1.16.2.5
@@ -12,6 +12,7 @@
 	int r = 0;
 
 	r += store_hwe(hw, "3PARdata", "VV", MULTIBUS, DEFAULT_GETUID);
+	r += store_hwe(hw, "APPLE*", "Xserve RAID ", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "COMPAQ", "HSV110*", GROUP_BY_SERIAL, DEFAULT_GETUID);
 	r += store_hwe(hw, "COMPAQ", "MSA1000", GROUP_BY_SERIAL, DEFAULT_GETUID);
 	r += store_hwe(hw, "DDN", "SAN DataDirector", MULTIBUS, DEFAULT_GETUID);
@@ -20,7 +21,7 @@
 		       "/sbin/scsi_id -g -u -ppre-spc3-83 -s /block/%n");
 	r += store_hwe(hw, "FSC", "CentricStor", GROUP_BY_SERIAL, DEFAULT_GETUID);
 	r += store_hwe(hw, "HP", "HSV110", GROUP_BY_SERIAL, DEFAULT_GETUID);
-	r += store_hwe(hw, "HP", "{HSV2*,A6189A}", MULTIBUS, DEFAULT_GETUID);
+	r += store_hwe(hw, "HP", "A6189A", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "IBM", "ProFibre 4000R", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "SGI", "TP9100", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "SGI", "TP9300", MULTIBUS, DEFAULT_GETUID);
@@ -30,40 +31,63 @@
 
 	r + store_hwe_ext(hw, "GNBD", "GNBD", MULTIBUS,
         		  "/sbin/gnbd_import -q -U /block/%n", NULL, "0", "0",
-			  "directio", FAILBACK_UNDEF, NULL);
+			  "directio", FAILBACK_UNDEF, NULL, 0, 0, 0);
         r += store_hwe_ext(hw, "HP", "MSA VOLUME", GROUP_BY_PRIO, DEFAULT_GETUID,
-		   "/sbin/mpath_prio_alua %d", "0", "0", "tur", FAILBACK_UNDEF, NULL);
-        r += store_hwe_ext(hw, "HP", "HSV101", GROUP_BY_PRIO, DEFAULT_GETUID,
-		    "/sbin/mpath_prio_alua %d", "0","1 queue_if_no_path", "tur",
-		    FAILBACK_UNDEF, NULL);
-        r += store_hwe_ext(hw, "COMPAQ", "HSV111*", GROUP_BY_PRIO, DEFAULT_GETUID,
-		    "/sbin/mpath_prio_alua %d", "0", "1 queue_if_no_path", "tur",
-		    FAILBACK_UNDEF, NULL);
-	r += store_hwe_ext(hw, "{HITACHI,HP}", "OPEN-*", MULTIBUS, DEFAULT_GETUID, NULL, "0", "0",
-		    "tur", FAILBACK_UNDEF, NULL);
+		   "/sbin/mpath_prio_alua %d", "0", "0", "tur", FAILBACK_UNDEF, NULL,
+		   0, 0, 0);
+	r += store_hwe_ext(hw, "HP", "HSV101", GROUP_BY_PRIO, DEFAULT_GETUID,
+		"/sbin/mpath_prio_alua %n", "0", "0", "tur",
+		-FAILBACK_IMMEDIATE, NULL, 60, 0, 100);
+	r += store_hwe_ext(hw, "HP", "HSV2[10]0", GROUP_BY_PRIO, DEFAULT_GETUID,
+		"/sbin/mpath_prio_alua %n", "0", "0", "tur",
+		-FAILBACK_IMMEDIATE, NULL, 60, 0, 100);
+	r += store_hwe_ext(hw, "COMPAQ", "HSV111", GROUP_BY_PRIO,
+		DEFAULT_GETUID, "/sbin/mpath_prio_alua %n", "0", "0", "tur",
+		-FAILBACK_IMMEDIATE, NULL, 60, 0, 100);
+	r += store_hwe_ext(hw, "{HITACHI,HP}", "OPEN-*", MULTIBUS,
+		DEFAULT_GETUID, NULL, "0", "0", "tur", -FAILBACK_IMMEDIATE,
+		NULL, 60, 0, 100);
         r += store_hwe_ext(hw, "HP", "*33[89]0*", MULTIBUS, DEFAULT_GETUID, NULL, "0", "0",
-		    "tur", FAILBACK_UNDEF, NULL);
+		    "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "DGC", "*", GROUP_BY_PRIO,
                    DEFAULT_GETUID, "/sbin/mpath_prio_emc /dev/%n", "1 emc",
-		   "1 queue_if_no_path", "emc_clariion", -FAILBACK_IMMEDIATE, "LUN_Z");
+		   "1 queue_if_no_path", "emc_clariion", -FAILBACK_IMMEDIATE, "LUN_Z",
+		   0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "3542", GROUP_BY_SERIAL, DEFAULT_GETUID,
-		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL);
+		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
+	r += store_hwe_ext(hw, "IBM", "2105*", GROUP_BY_SERIAL, DEFAULT_GETUID,
+		   NULL, "0", "1 queue_in_no_path", "tur", FAILBACK_UNDEF, NULL,
+		   0, 0, 0);
+	r += store_hwe_ext(hw, "IBM", "1750500", GROUP_BY_PRIO,
+		   DEFAULT_GETUID, "/sbin/mpath_prio_alua /dev/%n", "0",
+		   "1 queue_in_no_path", "tur", -FAILBACK_IMMEDIATE, NULL, 0, 0,
+		   0);
+	r += store_hwe_ext(hw, "IBM", "2107900", GROUP_BY_SERIAL,
+		   DEFAULT_GETUID, NULL, "0", "1 queue_in_no_path", "tur",
+		   FAILBACK_UNDEF, NULL, 0, 0, 0);
+	r += store_hwe_ext(hw, "IBM", "2145", GROUP_BY_PRIO, DEFAULT_GETUID,
+		   "/sbin/mpath_prio_alua /dev/%n", "0", "1 queue_in_no_path",
+		   "tur", -FAILBACK_IMMEDIATE, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "IBM", "S/390 DASD ECKD", MULTIBUS,
 		   "/sbin/dasdview -j /dev/%n", NULL, "0", "0",
-		   "directio", FAILBACK_UNDEF);
+		   "directio", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "NETAPP", "LUN", GROUP_BY_PRIO, DEFAULT_GETUID,
 		  "/sbin/mpath_prio_netapp /dev/%n", NULL,
-		  "1 queue_if_no_path", "readsector0", FAILBACK_UNDEF, NULL);
+		  "1 queue_if_no_path", "readsector0", FAILBACK_UNDEF, NULL, 0, 0, 0);
+	r += store_hwe_ext(hw, "IBM", "Nseries", GROUP_BY_PRIO, DEFAULT_GETUID,
+		  "/sbin/mpath_prio_netapp /dev/%n", NULL,
+		  "1 queue_if_no_path", "readsector0", -FAILBACK_IMMEDIATE,
+		  NULL, 0, 0, 128);
 	r += store_hwe_ext(hw, "Pillar", "Axiom 500", GROUP_BY_PRIO,
 		   DEFAULT_GETUID, "/sbin/mpath_prio_alua %d", "0", "0",
-		   "tur", FAILBACK_UNDEF, NULL);
+		   "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "SGI", "TP9400", MULTIBUS, DEFAULT_GETUID,
-		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL);
+		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "SGI", "TP9500", FAILOVER, DEFAULT_GETUID,
-		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL);
+		   NULL, "0", "0", "tur", FAILBACK_UNDEF, NULL, 0, 0, 0);
 	r += store_hwe_ext(hw, "HITACHI", "DF*", GROUP_BY_PRIO,
 		   DEFAULT_GETUID, "/sbin/mpath/prio_hds_modular %d", "0", "0",
-		   "readsector0", -FAILBACK_IMMEDIATE, NULL);
+		   "readsector0", -FAILBACK_IMMEDIATE, NULL, 0, 0, 0);
 
 	return r;
 }
--- multipath-tools/libmultipath/propsel.c	2005/11/16 20:24:57	1.9
+++ multipath-tools/libmultipath/propsel.c	2006/12/01 23:45:18	1.9.2.1
@@ -11,6 +11,7 @@
 #include "debug.h"
 #include "pgpolicies.h"
 #include "alias.h"
+#include "defaults.h"
 
 #include "../libcheckers/checkers.h"
 
@@ -20,6 +21,33 @@
  * stop at first explicit setting found
  */
 extern int
+select_rr_min_io (struct multipath * mp)
+{
+	if (mp->mpe && mp->mpe->rr_min_io) {
+		mp->rr_min_io = mp->mpe->rr_min_io;
+		condlog(3, "rr_min_io = %i (LUN setting)",
+			mp->rr_min_io);
+		return 0;
+	}
+	if (mp->hwe && mp->hwe->rr_min_io) {
+		mp->rr_min_io = mp->hwe->rr_min_io;
+		condlog(3, "rr_min_io = %i (controler setting)",
+			mp->rr_min_io);
+		return 0;
+	}
+	if (conf->rr_min_io) {
+		mp->rr_min_io = conf->rr_min_io;
+		condlog(3, "rr_min_io = %i (config file default)",
+			mp->rr_min_io);
+		return 0;
+	}
+	mp->rr_min_io = DEFAULT_RR_MIN_IO;
+	condlog(3, "rr_min_io = %i (internal default)",
+		mp->rr_min_io);
+	return 0;
+}
+
+extern int
 select_rr_weight (struct multipath * mp)
 {
 	if (mp->mpe && mp->mpe->rr_weight) {
--- multipath-tools/libmultipath/propsel.h	2005/11/04 23:35:28	1.4
+++ multipath-tools/libmultipath/propsel.h	2006/12/01 23:45:18	1.4.2.1
@@ -10,3 +10,4 @@
 int select_getprio (struct path * pp);
 int select_no_path_retry(struct multipath *mp);
 int select_pg_timeout(struct multipath *mp);
+int select_rr_min_io(struct multipath *mp);
--- multipath-tools/libmultipath/structs.h	2006/09/19 21:06:40	1.17.2.2
+++ multipath-tools/libmultipath/structs.h	2006/12/01 23:45:18	1.17.2.3
@@ -124,6 +124,7 @@
 	int action;
 	int pgfailback;
 	int failback_tick;
+	int rr_min_io;
 	int rr_weight;
 	int nr_active;     /* current available(= not known as failed) paths */
 	int no_path_retry; /* number of retries after all paths are down */
--- multipath-tools/multipath/main.c	2006/09/14 23:25:08	1.41.2.3
+++ multipath-tools/multipath/main.c	2006/12/01 23:45:18	1.41.2.4
@@ -1,7 +1,7 @@
 /*
  * Soft:        multipath device mapper target autoconfig
  *
- * Version:     $Id: main.c,v 1.41.2.3 2006/09/14 23:25:08 bmarzins Exp $
+ * Version:     $Id: main.c,v 1.41.2.4 2006/12/01 23:45:18 bmarzins Exp $
  *
  * Author:      Christophe Varoqui
  *
@@ -299,7 +299,7 @@
 {
 	int i, j;
 	int shift, freechar;
-	int minio;
+	int rr_min_io;
 	char * p;
 	struct pathgroup * pgp;
 	struct path * pp;
@@ -330,13 +330,13 @@
 		freechar -= shift;
 
 		vector_foreach_slot (pgp->paths, pp, j) {
-			minio = conf->minio;
+			rr_min_io = mp->rr_min_io;
 			
 			if (mp->rr_weight == RR_WEIGHT_PRIO && pp->priority)
-				minio *= pp->priority;
+				rr_min_io *= pp->priority;
 
 			shift = snprintf(p, freechar, " %s %d",
-					 pp->dev_t, minio);
+					 pp->dev_t, rr_min_io);
 			if (shift >= freechar) {
 				fprintf(stderr, "mp->params too small\n");
 				return 1;
@@ -376,6 +376,7 @@
 	select_features(mpp);
 	select_hwhandler(mpp);
 	select_rr_weight(mpp);
+	select_rr_min_io(mpp);
 	select_no_path_retry(mpp);
 	select_pg_timeout(mpp);
 
--- multipath-tools/path_priority/pp_alua/main.c	2005/10/12 21:57:26	1.2
+++ multipath-tools/path_priority/pp_alua/main.c	2006/12/01 23:45:18	1.2.2.1
@@ -12,8 +12,6 @@
  * 
  * This file is released under the GPL.
  */
-#include <linux/kdev_t.h>
-
 #include <sys/types.h>
 #include <sys/stat.h>
 
@@ -241,7 +239,7 @@
 			mknod(
 				devicepath,
 				S_IFBLK|S_IRUSR|S_IWUSR,
-				MKDEV(major, minor)
+				makedev(major, minor)
 			);
 			
 		}
--- multipath-tools/path_priority/pp_hds_modular/pp_hds_modular.c	2006/04/24 23:51:28	1.1
+++ multipath-tools/path_priority/pp_hds_modular/pp_hds_modular.c	2006/12/01 23:45:18	1.1.2.1
@@ -187,7 +187,7 @@
 	exit(1);
 	}
 
-print_help() {
+void print_help(void) {
 	printf("\n");
 	printf("Usage:       pp_hds_modular [-v] <device_major:device_minor>\n");
 	printf("Option:      -v verbose mode\n");
