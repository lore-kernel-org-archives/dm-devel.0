From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.annotated ./m ...
Date: 17 Jan 2009 00:46:53 -0000
Message-ID: <20090117004653.11141.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-01-17 00:46:52

Modified files:
	.              : multipath.conf.annotated 
	                 multipath.conf.defaults 
	libmultipath   : dict.c hwtable.c structs.h 
	multipathd     : main.c 

Log message:
	Fixes for bz #214809 and #457228.  Added default configs for hp-sw hardware
	handler and changed max_fds to use max instead of unlimited, since the kernel
	doesn't allow a process to open unlimited fds.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.annotated.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.7&r2=1.16.2.8
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.5.2.11&r2=1.5.2.12
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/dict.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.6&r2=1.16.2.7
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.16.2.15&r2=1.16.2.16
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/structs.h.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.17.2.8&r2=1.17.2.9
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipathd/main.c.diff?cvsroot=dm&only_with_tag=RHEL4_FC5&r1=1.66.2.5&r2=1.66.2.6

--- multipath-tools/multipath.conf.annotated	2009/01/16 21:30:42	1.16.2.7
+++ multipath-tools/multipath.conf.annotated	2009/01/17 00:46:51	1.16.2.8
@@ -113,7 +113,7 @@
 #	# scope   : multipathd
 #	# desc    : Sets the maximum number of open file descriptors for the
 #	#           multipathd process.
-#	# values  : unlimited|n > 0
+#	# values  : max|n > 0
 #	# default : None
 #	#
 #	max_fds		8192
--- multipath-tools/multipath.conf.defaults	2009/01/15 22:47:36	1.5.2.11
+++ multipath-tools/multipath.conf.defaults	2009/01/17 00:46:51	1.5.2.12
@@ -49,7 +49,7 @@
 #               product                 "MSA|HSV1.0.*"
 #               path_grouping_policy    group_by_prio
 #               prio_callout            "/sbin/mpath_prio_hp_sw /dev/%n"
-#               hardware_handler        "1 hp_sw"
+#               hardware_handler        "1 hp-sw"
 #               path_checker            "hp_sw"
 #               no_path_retry           12
 #		rr_min_io		100
@@ -127,8 +127,13 @@
 #       device {
 #               vendor                  "DEC"
 #               product                 "HSG80"
-#               path_grouping_policy    group_by_serial
-#               getuid_callout          "/sbin/scsi_id -g -u -s"
+#               path_grouping_policy    group_by_prio
+#               prio_callout		"/sbin/mpath_prio_hp_sw /dev/%n"
+#               hardware_handler	"1 hp-sw"
+#               features		"1 queue_if_no_path"
+#		path_checker		hp_sw
+#               no_path_retry           12
+#		rr_min_io		100
 #       }
 #       device {
 #               vendor                  "DGC"
--- multipath-tools/libmultipath/dict.c	2009/01/16 21:30:43	1.16.2.6
+++ multipath-tools/libmultipath/dict.c	2009/01/17 00:46:51	1.16.2.7
@@ -152,9 +152,9 @@
 	if (!buff)
 		return 1;
 
-	if (strlen(buff) == 9 &&
-	    !strcmp(buff, "unlimited"))
-		conf->max_fds = MAX_FDS_UNLIMITED;
+	if (strlen(buff) == 3 &&
+	    !strcmp(buff, "max"))
+		conf->max_fds = MAX_FDS_MAX;
 	else
 		conf->max_fds = atoi(buff);
 	FREE(buff);
--- multipath-tools/libmultipath/hwtable.c	2009/01/15 22:47:36	1.16.2.15
+++ multipath-tools/libmultipath/hwtable.c	2009/01/17 00:46:51	1.16.2.16
@@ -14,7 +14,6 @@
 	r += store_hwe(hw, "3PARdata", "VV", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "APPLE*", "Xserve RAID ", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "DDN", "SAN DataDirector", MULTIBUS, DEFAULT_GETUID);
-	r += store_hwe(hw, "DEC", "HSG80", GROUP_BY_SERIAL, DEFAULT_GETUID);
 	r += store_hwe(hw, "EMC", "SYMMETRIX", MULTIBUS,
 		       "/sbin/scsi_id -g -u -ppre-spc3-83 -s /block/%n");
 	r += store_hwe(hw, "FSC", "CentricStor", GROUP_BY_SERIAL, DEFAULT_GETUID);
@@ -25,7 +24,10 @@
 	r += store_hwe(hw, "STK", "OPENstorage D280", GROUP_BY_SERIAL, DEFAULT_GETUID);
 	r += store_hwe(hw, "SUN", "StorEdge 3510", MULTIBUS, DEFAULT_GETUID);
 	r += store_hwe(hw, "SUN", "T4", MULTIBUS, DEFAULT_GETUID);
-
+	r += store_hwe_ext(hw, "DEC", "HSG80", GROUP_BY_PRIO,
+			   DEFAULT_GETUID, "/sbin/mpath_prio_hp_sw /dev/%n",
+			   "1 hp-sw", "1 queue_if_no_path", "hp_sw",
+			   FAILBACK_UNDEF, NULL, 12, 0, 100);
 	r + store_hwe_ext(hw, "GNBD", "GNBD", MULTIBUS,
         		  "/sbin/gnbd_import -q -U /block/%n", NULL, "0", "0",
 			  "directio", FAILBACK_UNDEF, NULL, 0, 0, 0);
@@ -35,7 +37,7 @@
 	                   100);
 	r += store_hwe_ext(hw, "COMPAQ", "MSA|HSV1.0.*", GROUP_BY_PRIO,
 	                   DEFAULT_GETUID, "/sbin/mpath_prio_hp_sw /dev/%n",
-	                   "1 hp_sw", "0", "hp_sw", FAILBACK_UNDEF, NULL, 12, 0,
+	                   "1 hp-sw", "0", "hp_sw", FAILBACK_UNDEF, NULL, 12, 0,
 	                   100);
 	r += store_hwe_ext(hw, "(COMPAQ|HP)", "HSV1[01]1|HSV2[01]0|HSV300",
 			   GROUP_BY_PRIO, DEFAULT_GETUID,
--- multipath-tools/libmultipath/structs.h	2008/04/14 22:40:08	1.17.2.8
+++ multipath-tools/libmultipath/structs.h	2009/01/17 00:46:51	1.17.2.9
@@ -20,7 +20,7 @@
 #define NO_PATH_RETRY_FAIL	-1
 #define NO_PATH_RETRY_QUEUE	-2
 
-#define MAX_FDS_UNLIMITED	-1
+#define MAX_FDS_MAX		(1024 * 1024)
 
 enum free_path_switch {
 	KEEP_PATHS,
--- multipath-tools/multipathd/main.c	2008/10/17 18:37:53	1.66.2.5
+++ multipath-tools/multipathd/main.c	2009/01/17 00:46:52	1.66.2.6
@@ -1625,14 +1625,9 @@
 
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
