From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated lib ...
Date: 29 Aug 2008 21:30:35 -0000
Message-ID: <20080829213035.28009.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-08-29 21:30:34

Modified files:
	.              : multipath.conf.annotated 
	libmultipath   : dict.c structs.h 
	multipathd     : main.c 

Log message:
	Fix for bz #457226. The kernel doesn't allow "ulimit -n unlimited" because
	you can't set the max number of open fds greater than NR_OPEN.  So multipath's
	max_fds config option now allows the value "max" instead of "unlimited", which
	sets the max open fds to NR_OPEN.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.6&r2=1.18.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.17.2.5&r2=1.17.2.6
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.3&r2=1.18.2.4
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.69.2.8&r2=1.69.2.9

--- multipath-tools/multipath.conf.annotated	2008/08/25 20:59:05	1.18.2.6
+++ multipath-tools/multipath.conf.annotated	2008/08/29 21:30:34	1.18.2.7
@@ -84,7 +84,7 @@
 #	# scope   : multipathd
 #	# desc    : Sets the maximum number of open file descriptors for the
 #	#           multipathd process.
-#	# values  : unlimited|n > 0
+#	# values  : max|n > 0
 #	# default : None
 #	#
 #	max_fds		8192
--- multipath-tools/libmultipath/dict.c	2008/08/25 20:59:06	1.17.2.5
+++ multipath-tools/libmultipath/dict.c	2008/08/29 21:30:34	1.17.2.6
@@ -155,8 +155,8 @@
 		return 1;
 
 	if (strlen(buff) == 9 &&
-	    !strcmp(buff, "unlimited"))
-		conf->max_fds = MAX_FDS_UNLIMITED;
+	    !strcmp(buff, "max"))
+		conf->max_fds = MAX_FDS_MAX;
 	else
 		conf->max_fds = atoi(buff);
 	FREE(buff);
@@ -1653,8 +1653,8 @@
 	if (!conf->max_fds)
 		return 0;
 
-	if (conf->max_fds < 0)
-		return snprintf(buff, len, "unlimited");	
+	if (conf->max_fds == MAX_FDS_MAX)
+		return snprintf(buff, len, "max");	
 	return snprintf(buff, len, "%d", conf->max_fds);
 }
 
--- multipath-tools/libmultipath/structs.h	2008/08/25 20:59:06	1.18.2.3
+++ multipath-tools/libmultipath/structs.h	2008/08/29 21:30:34	1.18.2.4
@@ -20,7 +20,7 @@
 #define NO_PATH_RETRY_FAIL	-1
 #define NO_PATH_RETRY_QUEUE	-2
 
-#define MAX_FDS_UNLIMITED	-1
+#define MAX_FDS_MAX		(1024 * 1024)
 
 enum free_path_switch {
 	KEEP_PATHS,
--- multipath-tools/multipathd/main.c	2008/08/27 19:14:58	1.69.2.8
+++ multipath-tools/multipathd/main.c	2008/08/29 21:30:34	1.69.2.9
@@ -1479,14 +1479,9 @@
 
 	if (conf->max_fds) {
 		struct rlimit fd_limit;
-		if (conf->max_fds > 0) {
-			fd_limit.rlim_cur = conf->max_fds;
-			fd_limit.rlim_max = conf->max_fds;
-		}
-		else {
-			fd_limit.rlim_cur = RLIM_INFINITY;
-			fd_limit.rlim_max = RLIM_INFINITY;
-		}
+		
+		fd_limit.rlim_cur = conf->max_fds;
+		fd_limit.rlim_max = conf->max_fds;
 		if (setrlimit(RLIMIT_NOFILE, &fd_limit) < 0)
 			condlog(0, "can't set open fds limit to %d : %s\n",
 				conf->max_fds, strerror(errno));
