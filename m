From: wysochanski@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 25 Jan 2008 22:30:06 -0000
Message-ID: <20080125223006.25631.qmail@sourceware.org>
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
Changes by:	wysochanski@sourceware.org	2008-01-25 22:30:00

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.synthetic 
	libmultipath   : config.c config.h dict.c discovery.c structs.h 
	multipathd     : main.c 

Log message:
	Fix for bz #217130. Add max_fds config parameter to fix multipathd problems with large number of paths

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.3&r2=1.16.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.synthetic.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.10&r2=1.10.2.1
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.1&r2=1.17.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/config.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.1&r2=1.17.2.2
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.2&r2=1.16.2.3
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.28.2.4&r2=1.28.2.5
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.5&r2=1.17.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.66.2.2&r2=1.66.2.3

--- multipath-tools/multipath.conf.annotated	2007/12/03 18:42:15	1.16.2.3
+++ multipath-tools/multipath.conf.annotated	2008/01/25 22:30:00	1.16.2.4
@@ -109,6 +109,16 @@
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
--- multipath-tools/multipath.conf.synthetic	2005/11/21 23:28:31	1.10
+++ multipath-tools/multipath.conf.synthetic	2008/01/25 22:30:00	1.10.2.1
@@ -11,6 +11,7 @@
 #	prio_callout		/bin/true
 #	path_checker		readsector0
 #	rr_min_io		100
+#	max_fds			8192
 #	rr_weight		priorities
 #	failback		immediate
 #	no_path_retry		fail
--- multipath-tools/libmultipath/config.c	2006/12/01 23:45:18	1.17.2.1
+++ multipath-tools/libmultipath/config.c	2008/01/25 22:30:00	1.17.2.2
@@ -406,6 +406,7 @@
 
 	conf->dev_type = DEV_NONE;
 	conf->rr_min_io = DEFAULT_RR_MIN_IO;
+	conf->max_fds = 0;
 	conf->bindings_file = DEFAULT_BINDINGS_FILE;
 
 	/*
--- multipath-tools/libmultipath/config.h	2006/12/01 23:45:18	1.17.2.1
+++ multipath-tools/libmultipath/config.h	2008/01/25 22:30:00	1.17.2.2
@@ -67,6 +67,7 @@
 	int no_path_retry;
 	int user_friendly_names;
 	int pg_timeout;
+	int max_fds;
 
 	char * dev;
 	char * udev_dir;
--- multipath-tools/libmultipath/dict.c	2007/10/11 20:17:17	1.16.2.2
+++ multipath-tools/libmultipath/dict.c	2008/01/25 22:30:00	1.16.2.3
@@ -140,6 +140,26 @@
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
@@ -806,6 +826,7 @@
 	install_keyword("path_checker", &def_path_checker_handler);
 	install_keyword("failback", &default_failback_handler);
 	install_keyword("rr_min_io", &def_rr_min_io_handler);
+	install_keyword("max_fds", &max_fds_handler);
 	install_keyword("rr_weight", &def_weight_handler);
 	install_keyword("no_path_retry", &def_no_path_retry_handler);
 	install_keyword("pg_timeout", &default_pg_timeout_handler);
--- multipath-tools/libmultipath/discovery.c	2007/07/24 20:35:24	1.28.2.4
+++ multipath-tools/libmultipath/discovery.c	2008/01/25 22:30:00	1.28.2.5
@@ -749,6 +749,10 @@
 		condlog(3, "serial = %s", pp->serial);
 	}
 
+#ifndef DAEMON
+	close(pp->fd);
+	pp->fd = -1;
+#endif
 	return 0;
 }
 
@@ -844,5 +848,11 @@
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
--- multipath-tools/libmultipath/structs.h	2007/07/24 20:35:24	1.17.2.5
+++ multipath-tools/libmultipath/structs.h	2008/01/25 22:30:00	1.17.2.6
@@ -18,6 +18,8 @@
 #define NO_PATH_RETRY_FAIL	-1
 #define NO_PATH_RETRY_QUEUE	-2
 
+#define MAX_FDS_UNLIMITED	-1
+
 enum free_path_switch {
 	KEEP_PATHS,
 	FREE_PATHS
--- multipath-tools/multipathd/main.c	2007/04/26 17:47:01	1.66.2.2
+++ multipath-tools/multipathd/main.c	2008/01/25 22:30:00	1.66.2.3
@@ -12,6 +12,8 @@
 #include <sys/types.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 
 /*
  * libsysfs
@@ -1602,6 +1604,21 @@
 		conf->max_checkint = MAX_CHECKINT;
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
