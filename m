From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated lib ...
Date: 16 Jan 2009 22:47:32 -0000
Message-ID: <20090116224732.31931.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-01-16 22:47:31

Modified files:
	.              : multipath.conf.annotated 
	libmultipath   : callout.c 

Log message:
	Fix for 480048.  multipathd was not releasing fds when a fork failed in
	execute_program. Also, the error messages from execute_program were not very
	helpful. This patch fixes both

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.18.2.9&r2=1.18.2.10
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/callout.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5&r2=1.5.2.1

--- multipath-tools/multipath.conf.annotated	2008/09/08 22:01:19	1.18.2.9
+++ multipath-tools/multipath.conf.annotated	2009/01/16 22:47:31	1.18.2.10
@@ -38,6 +38,13 @@
 #	# scope   : multipath
 #	# desc    : the default path grouping policy to apply to unspecified
 #	#           multipaths
+#	# values  : failover           = 1 path per priority group
+#	#           multibus           = all valid paths in 1 priority group
+#	#           group_by_serial    = 1 priority group per detected serial
+#	#                                number
+#	#           group_by_prio      = 1 priority group per path priority
+#	#                                value
+#	#           group_by_node_name = 1 priority group per target node name
 #	# default : failover
 #	#
 #	path_grouping_policy	multibus
@@ -47,7 +54,7 @@
 #	# scope   : multipath
 #	# desc    : the default program and args to callout to obtain a unique 
 #	#           path identifier. Absolute path required
-#	# default : /sbin/scsi_id -g -u -s
+#	# default : "/sbin/scsi_id -g -u -s /block/%n"
 #	#
 #	getuid_callout	"/sbin/scsi_id -g -u -s /block/%n"
 #
@@ -65,12 +72,23 @@
 #	# name    : path_checker
 #	# scope   : multipath & multipathd
 #	# desc    : the default method used to determine the paths' state
-#	# values  : readsector0|tur|emc_clariion|hp_sw|directio
+#	# values  : directio|tur|hp_sw|rdac|emc_clariion|readsector0|cciss_tur
 #	# default : readsector0
 #	#
 #	#path_checker	readsector0
 #
 #	#
+#	# name    : features
+#	# scope   : multipath
+#	# desc    : The default extra features of multipath devices. The
+#	#           only existing feature currently is queue_if_no_path, which
+#	#           is the same as setting no_path_retry to queue.
+#	# values  : "1 queue_if_no_path"
+#	# default : (null)
+#	#
+#	features        "1 queue_if_no_path"
+#
+#	#
 #	# name    : rr_min_io
 #	# scope   : multipath
 #	# desc    : the number of IO to route to a path before switching
@@ -258,21 +276,20 @@
 #		# name    : path_grouping_policy
 #		# scope   : multipath
 #		# desc    : path grouping policy to apply to this multipath
-#		# values  : failover, multibus, group_by_serial
+#		# values  : failover           = 1 path per priority group
+#		#           multibus           = all valid paths in 1 priority
+#		#                                group
+#		#           group_by_serial    = 1 priority group per detected
+#		#                                serial number
+#		#           group_by_prio      = 1 priority group per path
+#		#                                priority value
+#		#           group_by_node_name = 1 priority group per target
+#		#                                node name
 #		# default : failover
 #		#
 #		path_grouping_policy	multibus
 #
 #		#
-#		# name    : path_checker
-#		# scope   : multipathd
-#		# desc    : path checking alorithm to use to check path state
-#		# values  : readsector0, tur
-#		# default : readsector0
-#		#
-#		# path_checker		readsector0
-#		
-#		#
 #		# name    : path_selector
 #		# desc    : the path selector algorithm to use for this mpath
 #		#           these algo are offered by the kernel mpath target
@@ -284,19 +301,29 @@
 #		#
 #		# name    : failback
 #		# scope   : multipathd
-#		# desc    : tell the daemon to manage path group failback, or not to.
-#		#	    0 means immediate failback, values >0 means deffered failback
-#		#	    expressed in seconds.
+#		# desc    : tell the daemon to manage path group failback, or
+#		#	    or not to. 0 means immediate failback, values >0
+#		#	    means deffered failback expressed in seconds.
 #		# values  : manual|immediate|n > 0
 #		# default : manual
 #		#
 #		failback		immediate
 #
 #		#
+#		# name    : rr_weight
+#		# scope   : multipath
+#		# desc    : if set to priorities the multipath configurator will
+#		#	    assign path weights as "path prio * rr_min_io"
+#		# values  : priorities|uniform
+#		# default : uniform
+#		#
+#		rr_weight	priorities
+#
+#		#
 #		# name    : no_path_retry
 #		# scope   : multipath & multipathd
-#		# desc    : tell the number of retries until disable queueing, or
-#		#           "fail" means immediate failure (no queueing),
+#		# desc    : tell the number of retries until disable queueing,
+#		#           or "fail" means immediate failure (no queueing),
 #		#           "queue" means never stop queueing
 #		# values  : queue|fail|n (>0)
 #		# default : (null)
@@ -384,11 +411,15 @@
 #		# scope   : multipath
 #		# desc    : path grouping policy to apply to multipath hosted
 #		#           by this storage controller
-#		# values  : failover        = 1 path per priority group
-#		#           multibus        = all valid paths in 1 priority
-#		#                             group
-#		#           group_by_serial = 1 priority group per detected
-#		#                             serial number
+#		# values  : failover           = 1 path per priority group
+#		#           multibus           = all valid paths in 1 priority
+#		#                                group
+#		#           group_by_serial    = 1 priority group per detected
+#		#                                serial number
+#		#           group_by_prio      = 1 priority group per path
+#		#                                priority value
+#		#           group_by_node_name = 1 priority group per target
+#		#                                node name
 #		# default : failover
 #		#
 #		path_grouping_policy	multibus
@@ -398,7 +429,7 @@
 #		# scope   : multipath
 #		# desc    : the program and args to callout to obtain a unique 
 #		#           path identifier. Absolute path required
-#		# default : /sbin/scsi_id -g -u -s
+#		# default : "/sbin/scsi_id -g -u -s /block/%n"
 #		#
 #		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
 #
@@ -417,7 +448,8 @@
 #		# name    : path_checker
 #		# scope   : multipathd
 #		# desc    : path checking alorithm to use to check path state
-#		# values  : readsector0, tur
+#		# values  : directio|tur|hp_sw|rdac|emc_clariion|readsector0|
+#		#           cciss_tur
 #		# default : readsector0
 #		#
 #		path_checker		readsector0
@@ -432,6 +464,49 @@
 #		path_selector		"round-robin 0"
 #
 #		#
+#		# name    : features
+#		# scope   : multipath
+#		# desc    : The default extra features of multipath devices. The
+#		#           only existing feature currently is queue_if_no_path,
+#		#           which is the same as setting no_path_retry to queue.
+#		# values  : "1 queue_if_no_path"
+#		# default : (null)
+#		#
+#		features        "1 queue_if_no_path"
+#
+#               #
+#               # name    : hardware_handler
+#               # scope   : multipath
+#               # desc    : If set, it specifies a module that will be used to
+#               #           perform hardware specific actions when switching
+#               #           path groups or handling IO errors
+#               # values  : "0"|"1 emc"|"1 hp-sw"|"1 rdac"
+#               # default : "0"
+#               #
+#               hardware_handler "1 emc"
+#
+#		#
+#		# name    : rr_weight
+#		# scope   : multipath
+#		# desc    : if set to priorities the multipath configurator will
+#		#	    assign path weights as "path prio * rr_min_io"
+#		# values  : priorities|uniform
+#		# default : uniform
+#		#
+#		rr_weight	priorities
+#
+#		#
+#		# name    : no_path_retry
+#		# scope   : multipath & multipathd
+#		# desc    : tell the number of retries until disable queueing,
+#		#           or "fail" means immediate failure (no queueing),
+#		#           "queue" means never stop queueing
+#		# values  : queue|fail|n (>0)
+#		# default : (null)
+#		#
+#		#no_path_retry  queue
+#
+#		#
 #		# name    : failback
 #		# scope   : multipathd
 #		# desc    : tell the daemon to manage path group failback, or not to.
--- multipath-tools/libmultipath/callout.c	2006/06/06 18:32:43	1.5
+++ multipath-tools/libmultipath/callout.c	2009/01/16 22:47:31	1.5.2.1
@@ -64,9 +64,10 @@
 
 	retval = pipe(fds);
 
-	if (retval != 0)
+	if (retval != 0) {
+		condlog(0, "error creating pipe for callout: %s", strerror(errno));
 		return -1;
-
+	}
 
 	pid = fork();
 
@@ -79,9 +80,12 @@
 		dup(fds[1]);
 
 		retval = execv(argv[0], argv);
-
+		condlog(0, "error execing %s : %s", argv[0], strerror(errno));
 		exit(-1);
 	case -1:
+		condlog(0, "fork failed: %s", strerror(errno));
+		close(fds[0]);
+		close(fds[1]);
 		return -1;
 	default:
 		/* parent reads from fds[0] */
@@ -95,13 +99,16 @@
 
 			i += count;
 			if (i >= len-1) {
+				condlog(0, "not enough space for response from %s", argv[0]);
 				retval = -1;
 				break;
 			}
 		}
 
-		if (count < 0)
+		if (count < 0) {
+			condlog(0, "no response from %s", argv[0]);
 			retval = -1;
+		}
 
 		if (i > 0 && value[i-1] == '\n')
 			i--;
@@ -110,8 +117,18 @@
 		wait(&status);
 		close(fds[0]);
 
-		if (!WIFEXITED(status) || (WEXITSTATUS(status) != 0))
-			retval = -1;
+		retval = -1;
+		if (WIFEXITED(status)) {
+			status = WEXITSTATUS(status);
+			if (status == 0)
+				retval = 0;
+			else
+				condlog(0, "%s exitted with %d", argv[0], status);
+		}
+		else if (WIFSIGNALED(status))
+			condlog(0, "%s was terminated by signal %d", argv[0], WTERMSIG(status));
+		else
+			condlog(0, "%s terminated abnormally", argv[0]);
 	}
 	return retval;
 }
