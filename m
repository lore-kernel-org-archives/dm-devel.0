From: bmarzins@sourceware.org
Subject: multipath-tools libmultipath/config.h libmulti ...
Date: 8 Sep 2010 21:40:30 -0000
Message-ID: <20100908214030.2514.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-09-08 21:40:30

Modified files:
	libmultipath   : config.h dict.c structs.h 
	multipathd     : main.c 

Log message:
	fix for bz #574813.  There is a new default multipath configuration option,
	"log_checker_err", setting this to "once" will cause multipathd to only log the
	first path failure message at verbosity 2.  Further path failure messages are
	logged at verbosity 3.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.12&r2=1.18.2.13
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.14&r2=1.17.2.15
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.7&r2=1.18.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.29&r2=1.69.2.30

--- multipath-tools/libmultipath/config.h	2010/09/03 20:59:14	1.18.2.12
+++ multipath-tools/libmultipath/config.h	2010/09/08 21:40:29	1.18.2.13
@@ -80,6 +80,7 @@
 	int checker_timeout;
 	int allow_queueing;
 	int pg_prio_calc;
+	int log_checker_err;
 	uid_t uid;
 	gid_t gid;
 	mode_t mode;
--- multipath-tools/libmultipath/dict.c	2010/09/03 20:59:14	1.17.2.14
+++ multipath-tools/libmultipath/dict.c	2010/09/08 21:40:30	1.17.2.15
@@ -435,7 +435,24 @@
 	return 0;
 }
 	
+static int
+def_log_checker_err_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
 
+	if (strlen(buff) == 4 && !strcmp(buff, "once"))
+		conf->log_checker_err = LOG_CHKR_ERR_ONCE;
+	else if (strlen(buff) == 6 && !strcmp(buff, "always"))
+		conf->log_checker_err = LOG_CHKR_ERR_ALWAYS;
+
+	free(buff);
+	return 0;
+}
 static int
 bindings_file_handler(vector strvec)
 {
@@ -2004,6 +2021,14 @@
 }
 
 static int
+snprint_def_log_checker_err (char *buff, int len, void *data)
+{
+	if (conf->log_checker_err == LOG_CHKR_ERR_ONCE)
+		return snprintf(buff, len, "once");
+	return snprintf(buff, len, "always");
+}
+
+static int
 snprint_def_bindings_file (char * buff, int len, void * data)
 {
 	if (conf->bindings_file == NULL)
@@ -2066,6 +2091,7 @@
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
 	install_keyword("user_friendly_names", &names_handler, &snprint_def_user_friendly_names);
 	install_keyword("pg_prio_calc", &def_pg_prio_calc_handler, &snprint_def_pg_prio_calc);
+	install_keyword("log_checker_err", &def_log_checker_err_handler, &snprint_def_log_checker_err);
 	install_keyword("bindings_file", &bindings_file_handler, &snprint_def_bindings_file);
 	install_keyword("mode", &def_mode_handler, &snprint_def_mode);
 	install_keyword("uid", &def_uid_handler, &snprint_def_uid);
--- multipath-tools/libmultipath/structs.h	2010/09/03 20:59:14	1.18.2.7
+++ multipath-tools/libmultipath/structs.h	2010/09/08 21:40:30	1.18.2.8
@@ -89,6 +89,11 @@
 	PG_PRIO_CALC_AVG,
 };
 
+enum log_checker_err_states {
+	LOG_CHKR_ERR_ALWAYS,
+	LOG_CHKR_ERR_ONCE,
+};
+
 struct scsi_idlun {
 	int dev_id;
 	int host_unique_id;
--- multipath-tools/multipathd/main.c	2010/09/01 18:29:18	1.69.2.29
+++ multipath-tools/multipathd/main.c	2010/09/08 21:40:30	1.69.2.30
@@ -74,7 +74,10 @@
 #define CALLOUT_DIR "/var/cache/multipathd"
 
 #define LOG_MSG(a,b) \
-	if (strlen(b)) condlog(a, "%s: %s", pp->dev, b);
+do { \
+	if (strlen(b)) \
+		condlog(a, "%s: %s", pp->dev, b); \
+} while(0)
 
 pthread_cond_t exit_cond = PTHREAD_COND_INITIALIZER;
 pthread_mutex_t exit_mutex = PTHREAD_MUTEX_INITIALIZER;
@@ -1111,8 +1114,12 @@
 				condlog(4, "%s: delay next check %is",
 						pp->dev_t, pp->tick);
 			}
-			else if (newstate == PATH_DOWN)
-				LOG_MSG(2, checker_message(&pp->checker));
+			else if (newstate == PATH_DOWN) {
+				if (conf->log_checker_err == LOG_CHKR_ERR_ONCE)
+					LOG_MSG(3, checker_message(&pp->checker));
+				else
+					LOG_MSG(2, checker_message(&pp->checker));
+			}
 
 			pp->state = newstate;
 
