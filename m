From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 15 Jan 2008 01:34:38 -0000
Message-ID: <20080115013438.27243.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-01-15 01:34:36

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.synthetic 
	libmultipath   : config.c config.h dict.c discovery.c structs.h 
	multipath      : multipath.conf.redhat 
	multipathd     : main.c 

Log message:
	Fix for bz 251346. Added a max_fds paramter to /etc/multipath.conf. This allows
	you to set the maximum number of open fds that multipathd can use, like with
	ulimit -n.  Also added some code so that multipath closes the file descriptor
	after it's used by the checker function, since multipath doesn't need to keep
	them always open like multipathd does.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.4&r2=1.18.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.synthetic.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.11.2.2&r2=1.11.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.19.2.4&r2=1.19.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.2&r2=1.18.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.3&r2=1.17.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.5&r2=1.32.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.1&r2=1.18.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath/multipath.conf.redhat.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.6.2.6&r2=1.6.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.4&r2=1.69.2.5

--- multipath-tools/multipath.conf.annotated	2008/01/14 23:49:34	1.18.2.4
+++ multipath-tools/multipath.conf.annotated	2008/01/15 01:34:36	1.18.2.5
@@ -80,6 +80,16 @@
 #	rr_min_io	100
 #
 #	#
+#	# name    : max_fds
+#	# scope   : multipathd
+#	# desc    : Sets the maximum number of open file descriptors for the
+#	#           multipathd process.
+#	# values  : unlimited|n > 0
+#	# default : None
+#	#
+#	max_fds		8192
+#
+#	#
 #	# name    : rr_weight
 #	# scope   : multipath
 #	# desc    : if set to priorities the multipath configurator will assign
--- multipath-tools/multipath.conf.synthetic	2007/06/19 18:12:15	1.11.2.2
+++ multipath-tools/multipath.conf.synthetic	2008/01/15 01:34:36	1.11.2.3
@@ -11,6 +11,7 @@
 #	prio_callout		/bin/true
 #	path_checker		readsector0
 #	rr_min_io		100
+#	max_fds			8192
 #	rr_weight		priorities
 #	failback		immediate
 #	no_path_retry		fail
--- multipath-tools/libmultipath/config.c	2007/12/15 00:27:39	1.19.2.4
+++ multipath-tools/libmultipath/config.c	2008/01/15 01:34:36	1.19.2.5
@@ -411,6 +411,7 @@
 
 	conf->dev_type = DEV_NONE;
 	conf->minio = 1000;
+	conf->max_fds = 0;
 
 	/*
 	 * read the config file
--- multipath-tools/libmultipath/config.h	2007/12/15 00:27:39	1.18.2.2
+++ multipath-tools/libmultipath/config.h	2008/01/15 01:34:36	1.18.2.3
@@ -63,6 +63,7 @@
 	int no_path_retry;
 	int user_friendly_names;
 	int pg_timeout;
+	int max_fds;
 
 	char * dev;
 	char * udev_dir;
--- multipath-tools/libmultipath/dict.c	2007/12/15 00:27:39	1.17.2.3
+++ multipath-tools/libmultipath/dict.c	2008/01/15 01:34:36	1.17.2.4
@@ -143,6 +143,26 @@
 }
 
 static int
+max_fds_handler(vector strvec)
+{
+	char * buff;
+
+	buff = set_value(strvec);
+
+	if (!buff)
+		return 1;
+
+	if (strlen(buff) == 9 &&
+	    !strcmp(buff, "unlimited"))
+		conf->max_fds = MAX_FDS_UNLIMITED;
+	else
+		conf->max_fds = atoi(buff);
+	FREE(buff);
+
+	return 0;
+}
+
+static int
 def_weight_handler(vector strvec)
 {
 	char * buff;
@@ -1441,6 +1461,17 @@
 }
 
 static int
+snprint_max_fds (char * buff, int len, void * data)
+{
+	if (!conf->max_fds)
+		return 0;
+
+	if (conf->max_fds < 0)
+		return snprintf(buff, len, "unlimited");	
+	return snprintf(buff, len, "%d", conf->max_fds);
+}
+
+static int
 snprint_def_rr_weight (char * buff, int len, void * data)
 {
 	if (!conf->rr_weight)
@@ -1553,6 +1584,7 @@
 	install_keyword("path_checker", &def_path_checker_handler, &snprint_def_path_checker);
 	install_keyword("failback", &default_failback_handler, &snprint_def_failback);
 	install_keyword("rr_min_io", &def_minio_handler, &snprint_def_rr_min_io);
+	install_keyword("max_fds", &max_fds_handler, &snprint_max_fds);
 	install_keyword("rr_weight", &def_weight_handler, &snprint_def_rr_weight);
 	install_keyword("no_path_retry", &def_no_path_retry_handler, &snprint_def_no_path_retry);
 	install_keyword("pg_timeout", &def_pg_timeout_handler, &snprint_def_pg_timeout);
--- multipath-tools/libmultipath/discovery.c	2007/06/18 17:37:18	1.32.2.5
+++ multipath-tools/libmultipath/discovery.c	2008/01/15 01:34:36	1.32.2.6
@@ -820,6 +820,10 @@
 	if (mask & DI_WWID && !strlen(pp->wwid))
 		get_uid(pp);
 
+#ifndef DAEMON
+	close(pp->fd);
+	pp->fd = -1;
+#endif
 	return 0;
 
 blank:
@@ -828,5 +832,11 @@
 	 */
 	memset(pp->wwid, 0, WWID_SIZE);
 	pp->state = PATH_DOWN;
+#ifndef DAEMON
+	if (pp->fd > 0){
+		close(pp->fd);
+		pp->fd = -1;
+	}
+#endif
 	return 0;
 }
--- multipath-tools/libmultipath/structs.h	2007/06/18 17:37:18	1.18.2.1
+++ multipath-tools/libmultipath/structs.h	2008/01/15 01:34:36	1.18.2.2
@@ -18,6 +18,8 @@
 #define NO_PATH_RETRY_FAIL	-1
 #define NO_PATH_RETRY_QUEUE	-2
 
+#define MAX_FDS_UNLIMITED	-1
+
 enum free_path_switch {
 	KEEP_PATHS,
 	FREE_PATHS
--- multipath-tools/multipath/multipath.conf.redhat	2008/01/02 19:06:12	1.6.2.6
+++ multipath-tools/multipath/multipath.conf.redhat	2008/01/15 01:34:36	1.6.2.7
@@ -39,6 +39,7 @@
 #	prio_callout		/bin/true
 #	path_checker		readsector0
 #	rr_min_io		100
+#	max_fds			8192
 #	rr_weight		priorities
 #	failback		immediate
 #	no_path_retry		fail
--- multipath-tools/multipathd/main.c	2007/12/17 22:27:38	1.69.2.4
+++ multipath-tools/multipathd/main.c	2008/01/15 01:34:36	1.69.2.5
@@ -13,6 +13,8 @@
 #include <sys/mount.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 
 /*
  * libsysfs
@@ -1451,6 +1453,21 @@
 		conf->max_checkint = MAX_CHECKINT(conf->checkint);
 	}
 
+	if (conf->max_fds) {
+		struct rlimit fd_limit;
+		if (conf->max_fds > 0) {
+			fd_limit.rlim_cur = conf->max_fds;
+			fd_limit.rlim_max = conf->max_fds;
+		}
+		else {
+			fd_limit.rlim_cur = RLIM_INFINITY;
+			fd_limit.rlim_max = RLIM_INFINITY;
+		}
+		if (setrlimit(RLIMIT_NOFILE, &fd_limit) < 0)
+			condlog(0, "can't set open fds limit to %d : %s\n",
+				conf->max_fds, strerror(errno));
+	}
+
 	if (pidfile_create(DEFAULT_PIDFILE, getpid())) {
 		if (logsink)
 			log_thread_stop();
