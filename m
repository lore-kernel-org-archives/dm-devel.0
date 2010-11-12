From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 12 Nov 2010 20:17:12 -0000
Message-ID: <20101112201712.6278.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-11-12 20:17:12

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #647358. Update and add HP default configurations

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.27&r2=1.5.4.28
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.33&r2=1.20.2.34

--- multipath-tools/multipath.conf.defaults	2010/09/21 18:06:04	1.5.4.27
+++ multipath-tools/multipath.conf.defaults	2010/11/12 20:17:09	1.5.4.28
@@ -59,7 +59,7 @@
 #       }
 #       device {
 #               vendor                  "(COMPAQ|HP)"
-#               product                 "HSV1[01]1|HSV2[01]0|HSV300|HSV4[05]0"
+#               product                 "HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_alua /dev/%n"	
 #		features		"0"
@@ -67,7 +67,7 @@
 #               path_grouping_policy    group_by_prio
 #		failback		immediate
 #		rr_weight		uniform
-#               no_path_retry		12 
+#               no_path_retry		18
 #		rr_min_io		100
 #               path_checker            tur
 #        }
@@ -163,6 +163,20 @@
 #		path_checker		cciss_tur
 #	}
 #       device {
+#               vendor                  "HP"
+#               product                 "P2000 G3*|P2000G3 FC/iSCSI"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_alua /dev/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#               no_path_retry		18
+#		rr_min_io		100
+#               path_checker            tur
+#        }
+#       device {
 #               vendor                  "DDN"
 #               product                 "SAN DataDirector"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
--- multipath-tools/libmultipath/hwtable.c	2010/09/21 18:06:05	1.20.2.33
+++ multipath-tools/libmultipath/hwtable.c	2010/11/12 20:17:12	1.20.2.34
@@ -91,9 +91,9 @@
 		.checker_name  = HP_SW,
 	},
 	{
-		/* EVA 3000/5000 with new firmware, EVA 4000/6000/8000, EVA 4400 */
+		/* EVA 3000/5000 with new firmware, EVA 4x00/6x00/8x00 */
 		.vendor        = "(COMPAQ|HP)",
-		.product       = "HSV1[01]1|HSV2[01]0|HSV300|HSV4[05]|HSV4[05]0",
+		.product       = "HSV1[01]1|HSV2[01]0|HSV3[046]0|HSV4[05]0",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
 		.features      = DEFAULT_FEATURES,
@@ -102,7 +102,7 @@
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = 12,
+		.no_path_retry = 18,
 		.minio         = 100,
 		.checker_name  = TUR,
 	},
@@ -201,6 +201,22 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = CCISS_TUR,
 	},
+	{
+		/* HP P2000 product family */
+		.vendor        = "HP",
+		.product       = "P2000 G3*|P2000G3 FC/iSCSI",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 18,
+		.minio         = 100,
+		.checker_name  = TUR,
+	},
 	/*
 	 * DDN controller family
 	 *
