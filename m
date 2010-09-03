From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath config.h dict.c s ...
Date: 3 Sep 2010 20:59:15 -0000
Message-ID: <20100903205915.4039.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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
Changes by:	bmarzins@sourceware.org	2010-09-03 20:59:14

Modified files:
	libmultipath   : config.h dict.c structs.h switchgroup.c 

Log message:
	Fix for bz #570513. multipath has a new default option "pg_prio_calc". Setting
	this to "avg" makes multipath compute use the average priority of the paths in
	a pathgroup for the group's priority, the same as upstream and rhel6.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.11&r2=1.18.2.12
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.13&r2=1.17.2.14
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.6&r2=1.18.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/switchgroup.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.2.2&r2=1.5.2.3

--- multipath-tools/libmultipath/config.h	2010/04/24 05:28:06	1.18.2.11
+++ multipath-tools/libmultipath/config.h	2010/09/03 20:59:14	1.18.2.12
@@ -79,6 +79,7 @@
 	int queue_without_daemon;
 	int checker_timeout;
 	int allow_queueing;
+	int pg_prio_calc;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/dict.c	2010/08/27 21:02:07	1.17.2.13
+++ multipath-tools/libmultipath/dict.c	2010/09/03 20:59:14	1.17.2.14
@@ -416,6 +416,27 @@
 }
 
 static int
+def_pg_prio_calc_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	if (strlen(buff) == 3 && !strcmp(buff, "sum"))
+		conf->pg_prio_calc = PG_PRIO_CALC_SUM;
+	else if ((strlen(buff) == 3 && !strcmp(buff, "avg")) ||
+		 (strlen(buff) == 7 && !strcmp(buff, "average")))
+		conf->pg_prio_calc = PG_PRIO_CALC_AVG;
+
+	FREE(buff);
+	return 0;
+}
+	
+
+static int
 bindings_file_handler(vector strvec)
 {
 	conf->bindings_file = set_value(strvec);
@@ -1975,6 +1996,14 @@
 }
 
 static int
+snprint_def_pg_prio_calc (char * buff, int len, void *data)
+{
+	if (conf->pg_prio_calc == PG_PRIO_CALC_AVG)
+		return snprintf(buff, len, "avg");
+	return snprintf(buff, len, "sum");
+}
+
+static int
 snprint_def_bindings_file (char * buff, int len, void * data)
 {
 	if (conf->bindings_file == NULL)
@@ -2036,6 +2065,7 @@
 	install_keyword("checker_timeout", &def_checker_timeout_handler, &snprint_def_checker_timeout);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
+	install_keyword("pg_prio_calc", &def_pg_prio_calc_handler, &snprint_def_pg_prio_calc);
 	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
 	install_keyword("mode", &def_mode_handler, &snprint_def_mode);
 	install_keyword("uid", &def_uid_handler, &snprint_def_uid);
--- multipath-tools/libmultipath/structs.h	2008/09/08 22:01:20	1.18.2.6
+++ multipath-tools/libmultipath/structs.h	2010/09/03 20:59:14	1.18.2.7
@@ -84,6 +84,11 @@
 	QUE_NO_DAEMON_ON,
 };
 
+enum pg_prio_calc_states {
+	PG_PRIO_CALC_SUM,
+	PG_PRIO_CALC_AVG,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
--- multipath-tools/libmultipath/switchgroup.c	2007/06/01 00:26:41	1.5.2.2
+++ multipath-tools/libmultipath/switchgroup.c	2010/09/03 20:59:14	1.5.2.3
@@ -7,16 +7,18 @@
 #include "vector.h"
 #include "structs.h"
 #include "switchgroup.h"
+#include "config.h"
 
 extern int
 select_path_group (struct multipath * mpp)
 {
 	int i, j;
 	int highest = 0;
+	int most_paths = 0;
 	int bestpg = 1;
 	struct pathgroup * pgp;
 	struct path * pp;
-	int priority;
+	int priority, enabled_paths;
 
 	if (!mpp->pg)
 		return 1;
@@ -26,15 +28,28 @@
 			continue;
 
 		priority = 0;
+		enabled_paths = 0;
 
 		vector_foreach_slot (pgp->paths, pp, j) {
-			if (pp->state != PATH_DOWN)
+			if (pp->state != PATH_DOWN) {
 				priority += pp->priority;
+				enabled_paths++;
+			}
 		}
-		pgp->priority = priority;
+		if (conf->pg_prio_calc == PG_PRIO_CALC_AVG)
+			pgp->priority = priority / enabled_paths;
+		else
+			pgp->priority = priority;
 
 		if (pgp->priority > highest) {
 			highest = pgp->priority;
+			most_paths = enabled_paths;
+			bestpg = i + 1;
+		}
+		else if (pgp->priority == highest &&
+			 conf->pg_prio_calc == PG_PRIO_CALC_AVG &&
+			 enabled_paths > most_paths) {
+			most_paths = enabled_paths;
 			bestpg = i + 1;
 		}
 	}
