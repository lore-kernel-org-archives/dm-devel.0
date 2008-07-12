From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 12 Jul 2008 17:36:58 -0000
Message-ID: <20080712173658.21816.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-07-12 17:36:57

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix bz #446223. Added default configuration for DASD FBA devices.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.11&r2=1.5.4.12
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.13&r2=1.20.2.14

--- multipath-tools/multipath.conf.defaults	2008/07/12 02:44:14	1.5.4.11
+++ multipath-tools/multipath.conf.defaults	2008/07/12 17:36:56	1.5.4.12
@@ -313,6 +313,18 @@
 #               path_checker            directio
 #	}
 #	device {
+#		vendor			"IBM"
+#		product			"S/390 DASD FBA"
+#		product_blacklist	S/390.*"
+#		getuid_callout		"sbin/dasd_id /dev/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#		path_grouping_policy	multibus
+#		rr_weight		uniform
+#		rr_min_io		1000
+#		path_checker		directio
+#	}
+#	device {
 #		vendor			"NETAPP"
 #		product			"LUN"
 #		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
--- multipath-tools/libmultipath/hwtable.c	2008/07/12 02:44:14	1.20.2.13
+++ multipath-tools/libmultipath/hwtable.c	2008/07/12 17:36:56	1.20.2.14
@@ -418,6 +418,23 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = DIRECTIO,
 	},
+	{
+		/* IBM S/390 FBA DASD */
+		.vendor        = "IBM",
+		.product       = "S/390 DASD FBA",
+		.bl_product    = "S/390.*",
+		.getuid        = "/sbin/dasd_id /dev/%n",
+		.getprio       = NULL,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = DIRECTIO,
+	},
  	/*
 	 * NETAPP controller family
 	 *
