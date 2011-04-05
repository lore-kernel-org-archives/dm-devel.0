From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath config.c config.h ...
Date: 5 Apr 2011 18:41:46 -0000
Message-ID: <20110405184146.1540.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2011-04-05 18:41:45

Modified files:
	libmultipath   : config.c config.h defaults.h dict.c discovery.c 

Log message:
	Fix for bz #674366.  Multipath has a new defaults config value file_timeout.
	This allows users to set the length of time multipathd will wait for a necessary
	file to appear. Previously, it used the hardcoded value, WAIT_MAX_SECONDS.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19.2.9&r2=1.19.2.10
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.14&r2=1.18.2.15
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/defaults.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.7.2.1&r2=1.7.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.18&r2=1.17.2.19
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.19&r2=1.32.2.20

--- multipath-tools/libmultipath/config.c	2009/05/15 21:01:26	1.19.2.9
+++ multipath-tools/libmultipath/config.c	2011/04/05 18:41:45	1.19.2.10
@@ -417,6 +417,7 @@
 	conf->max_fds = 0;
 	conf->attribute_flags = 0;
 	conf->flush_on_last_del = 0;
+	conf->file_timeout = DEFAULT_FILE_TIMEOUT;
 
 	/*
 	 * read the config file
--- multipath-tools/libmultipath/config.h	2011/02/18 18:27:00	1.18.2.14
+++ multipath-tools/libmultipath/config.h	2011/04/05 18:41:45	1.18.2.15
@@ -84,6 +84,7 @@
 	int pg_prio_calc;
 	int log_checker_err;
 	int fast_io_fail;
+	int file_timeout;
 	unsigned int dev_loss;
 	uid_t uid;
 	gid_t gid;
--- multipath-tools/libmultipath/defaults.h	2009/04/29 04:41:33	1.7.2.1
+++ multipath-tools/libmultipath/defaults.h	2011/04/05 18:41:45	1.7.2.2
@@ -12,6 +12,7 @@
 #define DEFAULT_PGTIMEOUT      -PGTIMEOUT_NONE
 #define DEFAULT_USER_FRIENDLY_NAMES    0
 #define DEFAULT_VERBOSITY      2
+#define DEFAULT_FILE_TIMEOUT	90
 
 #define DEFAULT_CHECKINT	5
 #define MAX_CHECKINT(a)		(a << 2)
--- multipath-tools/libmultipath/dict.c	2011/03/18 19:50:40	1.17.2.18
+++ multipath-tools/libmultipath/dict.c	2011/04/05 18:41:45	1.17.2.19
@@ -85,6 +85,21 @@
 }
 
 static int
+file_timeout_handler(vector strvec)
+{
+	char * buff;
+	buff = set_value(strvec);
+	if (!buff)
+		return 1;
+	conf->file_timeout = atoi(buff);
+	if (conf->file_timeout < 0)
+		 conf->file_timeout = DEFAULT_FILE_TIMEOUT;
+
+	FREE(buff);
+	return 0;
+}
+
+static int
 udev_dir_handler(vector strvec)
 {
 	conf->udev_dir = set_value(strvec);
@@ -1848,6 +1863,12 @@
 }
 
 static int
+snprint_file_timeout(char * buff, int len, void * data)
+{
+	return snprintf(buff, len, "%i", conf->file_timeout);
+}
+
+static int
 snprint_def_udev_dir (char * buff, int len, void * data)
 {
 	if (!conf->udev_dir)
@@ -2153,6 +2174,7 @@
 	install_keyword("gid", &def_gid_handler, &snprint_def_gid);
 	install_keyword("fast_io_fail_tmo", &def_fast_io_fail_handler, &snprint_def_fast_io_fail);
 	install_keyword("dev_loss_tmo", &def_dev_loss_handler, &snprint_def_dev_loss);
+	install_keyword("file_timeout", &file_timeout_handler, &snprint_file_timeout);
 	__deprecated install_keyword("default_selector", &def_selector_handler, NULL);
 	__deprecated install_keyword("default_path_grouping_policy", &def_pgpolicy_handler, NULL);
 	__deprecated install_keyword("default_getuid_callout", &def_getuid_callout_handler, NULL);
--- multipath-tools/libmultipath/discovery.c	2011/03/07 15:45:15	1.32.2.19
+++ multipath-tools/libmultipath/discovery.c	2011/04/05 18:41:45	1.32.2.20
@@ -181,7 +181,6 @@
  * not multipath(8), ran by udev
  */
 #if DAEMON
-#define WAIT_MAX_SECONDS 90
 #define WAIT_LOOP_PER_SECOND 5
 
 static int
@@ -190,7 +189,7 @@
 	int loop;
 	struct stat stats;
 
-	loop = WAIT_MAX_SECONDS * WAIT_LOOP_PER_SECOND;
+	loop = conf->file_timeout * WAIT_LOOP_PER_SECOND;
 	
 	while (--loop) {
 		if (stat(filename, &stats) == 0)
@@ -632,7 +631,7 @@
 		return 1;
 
 #if DAEMON
-	int loop = WAIT_MAX_SECONDS * WAIT_LOOP_PER_SECOND;
+	int loop = conf->file_timeout * WAIT_LOOP_PER_SECOND;
 
 	while (loop--) {
 		sdev = sysfs_open_device_path(attr_buff);
