From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 29 Aug 2008 18:30:27 -0000
Message-ID: <20080829183027.12698.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2008-08-29 18:30:27

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #456126, pull configs from upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.12&r2=1.5.4.13
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.14&r2=1.20.2.15

--- multipath-tools/multipath.conf.defaults	2008/07/12 17:36:56	1.5.4.12
+++ multipath-tools/multipath.conf.defaults	2008/08/29 18:30:26	1.5.4.13
@@ -162,12 +162,12 @@
 #		vendor                  "DELL"
 #               product                 "MD3000"
 #		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
-#               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
 #		features		"0"
 #               hardware_handler        "1 rdac"
 #		path_grouping_policy	group_by_prio
 #               failback                manual
-#               path_checker            rdac
+#               path_checker            readsector0
 #       }
 #       device {
 #               vendor                  "EMC"
@@ -217,29 +217,71 @@
 #       }
 #       device {
 #               vendor                  "IBM"
+#               product                 "1722-600"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"1 rdac"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		300
+#		rr_min_io		1000
+#               path_checker            rdac
+#	}
+#       device {
+#               vendor                  "IBM"
+#               product                 "1726-4xx"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		300
+#		rr_min_io		1000
+#               path_checker            rdac
+#	}
+#       device {
+#               vendor                  "IBM"
 #               product                 "1742"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
-#               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
 #		features		"0"
-#		hardware_handler	"0"
+#		hardware_handler	"1 rdac"
 #               path_grouping_policy    group_by_prio
 #		failback		immediate
 #		rr_weight		uniform
 #		rr_min_io		1000
-#               path_checker            tur
+#               path_checker            rdac
+#	}
+#       device {
+#               vendor                  "IBM"
+#               product                 "1815"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#               path_checker            rdac
 #	}
 #       device {
 #               vendor                  "IBM"
 #               product                 "3526"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
-#               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
 #		features		"0"
-#		hardware_handler	"0"
+#		hardware_handler	"1 rdac"
 #               path_grouping_policy    group_by_prio
 #		failback		immediate
 #		rr_weight		uniform
 #		rr_min_io		1000
-#               path_checker            tur
+#               path_checker            rdac
 #	}
 #	device {
 #		vendor			"IBM"
@@ -377,26 +419,41 @@
 #               vendor                  "SGI"
 #               product                 "TP9[45]00"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
-#               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
 #		features		"0"
-#		hardware_handler	"0"
+#		hardware_handler	"1 rdac"
 #               path_grouping_policy    group_by_prio
 #		failback		immediate
 #		rr_weight		uniform
 #		rr_min_io		1000
-#               path_checker            tur
+#               path_checker            rdac
+#	}
+#       device {
+#               vendor                  "SGI"
+#               product                 "IS.*"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#               path_checker            rdac
 #	}
 #       device {
 #               vendor                  "STK"
 #               product                 "OPENstorage D280"
 #		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
-#               prio_callout            "/sbin/mpath_prio_tpc /dev/%n"	
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
 #		features		"0"
-#		hardware_handler	"0"
+#		hardware_handler	"1 rdac"
 #               path_grouping_policy    group_by_prio
 #		failback		immediate
 #		rr_weight		uniform
 #		rr_min_io		1000
+#               path_checker            tur
 #       }
 #       device {
 #               vendor                  "SUN"
@@ -409,6 +466,45 @@
 #		rr_min_io		1000
 #		path_checker		readsector0
 #       }
+#       device {
+#               vendor                  "PIVOT3"
+#               product                 "RAIGE VOLUME"
+#		getuid_callout		"/sbin/scsi_id -p 0x80 -g -u -d /block/%n"
+#		features		"1 queue_if_no_path"
+#		hardware_handler	"0"
+#               path_grouping_policy    multibus
+#		rr_weight		uniform
+#		rr_min_io		100
+#               path_checker            tur
+#	}
+#       device {
+#               vendor                  "SUN"
+#               product                 "CSM200_R"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#               path_checker            rdac
+#	}
+#       device {
+#               vendor                  "SUN"
+#               product                 "LCSM100_F"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
+#		features		"0"
+#		hardware_handler	"1 rdac"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		queue
+#		rr_min_io		1000
+#               path_checker            rdac
+#	}
 #	device {
 #		vendor			"GNBD"
 #		product			"GNBD"
--- multipath-tools/libmultipath/hwtable.c	2008/07/12 17:36:56	1.20.2.14
+++ multipath-tools/libmultipath/hwtable.c	2008/08/29 18:30:27	1.20.2.15
@@ -290,36 +290,84 @@
 		.checker_name  = READSECTOR0,
 	},
 	{
+		/* IBM FAStT 1722-600 */
+		.vendor        = "IBM",
+		.product       = "1722-600",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 300,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+	},
+	{
+		/* IBM DS3400 */
+		.vendor        = "IBM",
+		.product       = "1726-4xx",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 300,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+	},
+	{
 		/* IBM DS4100 / FAStT100 */
 		.vendor        = "IBM",
 		.product       = "1742",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_tpc /dev/%n",
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = TUR,
+		.checker_name  = RDAC,
+	},
+	{
+		/* IBM DS4800 */
+		.vendor        = "IBM",
+		.product       = "1815",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
 	},
 	{
 		/* IBM Netfinity Fibre Channel RAID Controller Unit */
 		.vendor        = "IBM",
 		.product       = "3526",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_tpc /dev/%n",
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = TUR,
+		.checker_name  = RDAC,
 	},
 	{
 		/* IBM DS4200 / FAStT200 */
@@ -523,16 +571,31 @@
 		.vendor        = "SGI",
 		.product       = "TP9[45]00",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_tpc /dev/%n",
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = TUR,
+		.checker_name  = RDAC,
+	},
+	{
+		.vendor        = "SGI",
+		.product       = "IS.*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
 	},
 	/*
 	 * STK arrays
@@ -544,9 +607,9 @@
 		.vendor        = "STK",
 		.product       = "OPENstorage D280",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_tpc /dev/%n",
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = DEFAULT_HWHANDLER,
+		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
@@ -577,13 +640,65 @@
 		.checker_name  = READSECTOR0,
 	},
 	/*
+	 * Pivot3 RAIGE
+	 *
+	 * Maintainer : Bart Brooks, Pivot3
+	 * Mail : bartb@pivot3.com
+	 */
+	{
+		.vendor        = "PIVOT3",
+		.product       = "RAIGE VOLUME",
+		.getuid        = "/sbin/scsi_id -p 0x80 -g -u -d /dev/%n",
+		.getprio       = NULL,
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = 100,
+		.checker_name  = TUR,
+	},
+	{
+		.vendor        = "SUN",
+		.product       = "CSM200_R",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+	},
+	/* SUN/LSI 2540 */
+	{
+		.vendor        = "SUN",
+		.product       = "LCSM100_F",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_QUEUE,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+	},
+	/*
 	 * DELL arrays
 	 */
 	{
 		.vendor        = "DELL",
 		.product       = "MD3000",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = "/sbin/mpath_prio_tpc /dev/%n",
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
 		.features      = DEFAULT_FEATURES,
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
