From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 12 Jul 2008 02:44:14 -0000
Message-ID: <20080712024414.31283.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-07-12 02:44:14

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #439366. Applied patch to update HP configuration defaults.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.10&r2=1.5.4.11
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.12&r2=1.20.2.13

--- multipath-tools/multipath.conf.defaults	2008/07/12 00:07:33	1.5.4.10
+++ multipath-tools/multipath.conf.defaults	2008/07/12 02:44:14	1.5.4.11
@@ -46,8 +46,8 @@
 #		path_checker		readsector0
 #	}
 #       device {
-#               vendor                  "(COMPAQ|HP)"
-#               product                 "(MSA|HSV)1.*"
+#               vendor                  "COMPAQ"
+#               product                 "MSA|HSV1.0.*"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #		features		"0"
 #		hardware_handler	"1 hp_sw"
@@ -58,7 +58,21 @@
 #       }
 #       device {
 #               vendor                  "(COMPAQ|HP)"
-#               product                 "HSV2.*"
+#               product                 "HSV1[01]1|HSV2[01]0|HSV300"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"	
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#               no_path_retry		12 
+#		rr_min_io		100
+#               path_checker            tur
+#        }
+#       device {
+#               vendor                  "HP"
+#               product                 "MSA VOLUME"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua %n"	
 #		features		"0"
@@ -66,8 +80,22 @@
 #               path_grouping_policy    group_by_prio
 #		failback		immediate
 #		rr_weight		uniform
-#               no_path_retry		60 
-#		rr_min_io		1000
+#               no_path_retry		12 
+#		rr_min_io		100
+#		path_checker		tur
+#	}
+#	device {
+#		vendor			"HP"
+#		product			"MSA2[02]12*"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#		prio_callout		"/bin/true"    
+#		features		"0"
+#		hardware_handler	"0"
+#		path_grouping_policy	multibus 
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		12
+#		rr_min_io		100
 #               path_checker            tur
 #        }
 #       device {
@@ -90,7 +118,7 @@
 #               path_grouping_policy    multibus
 #		failback		immediate
 #		rr_weight		uniform
-#		rr_min_io		100
+#		rr_min_io		1000
 #		path_checker		tur
 #	}
 #       device {
--- multipath-tools/libmultipath/hwtable.c	2008/07/12 00:07:33	1.20.2.12
+++ multipath-tools/libmultipath/hwtable.c	2008/07/12 02:44:14	1.20.2.13
@@ -75,8 +75,9 @@
 		.checker_name  = HP_SW,
 	},
 	{
-		.vendor        = "(COMPAQ|HP)",
-		.product       = "(MSA|HSV)1.*",
+		/* MSA 1000/MSA1500, EVA 3000/5000 with old firmware */
+		.vendor        = "COMPAQ",
+		.product       = "MSA|HSV1.0.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = NULL,
 		.features      = DEFAULT_FEATURES,
@@ -90,17 +91,50 @@
 		.checker_name  = HP_SW,
 	},
 	{
+		/* EVA 3000/5000 with new firmware, EVA 4000/6000/8000, EVA 4400 */
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "HSV2.*",
+		.product       = "HSV1[01]1|HSV2[01]0|HSV300",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_alua %n",
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 12,
+		.minio         = 100,
+		.checker_name  = TUR,
+	},
+	{
+		/* MSA 1000/1500 with new firmware */
+		.vendor        = "HP",
+		.product       = "MSA VOLUME",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 60,
+		.no_path_retry = 12,
+		.minio         = 100,
+		.checker_name  = TUR,
+	},
+	{
+		 /* HP MSA2000 product family */
+		.vendor        = "HP",
+		.product       = "MSA2[02]12*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/bin/true",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 12,
 		.minio         = 100,
 		.checker_name  = TUR,
 	},
@@ -215,8 +249,8 @@
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = 100,
+		.no_path_retry = 12,
+		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
 	},
 	{
