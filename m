From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 2 Dec 2009 19:15:29 -0000
Message-ID: <20091202191529.21773.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-12-02 19:15:28

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #540882
	Add default configurations for IBM, LSI, and DELL storage

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.17&r2=1.5.4.18
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.24&r2=1.20.2.25

--- multipath-tools/multipath.conf.defaults	2009/09/28 18:41:20	1.5.4.17
+++ multipath-tools/multipath.conf.defaults	2009/12/02 19:15:28	1.5.4.18
@@ -187,15 +187,44 @@
 #		path_checker		emc_clariion
 #	}
 #	device {
+#		vendor			"(LSI|ENGENIO)"
+#		product			"INF.*"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#		prio_callout		"/sbin/mpath_prio_rdac /dev/%n"
+#		features		"2 pg_init_retries 50"
+#		hardware_handler	"1 rdac"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		15
+#		rr_min_io		1000
+#               path_checker            rdac
+#	}
+#	device {
 #		vendor                  "DELL"
-#               product                 "MD3000"
+#               product                 "MD3000|MD3000i"
 #		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
 #               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"	
-#		features		"0"
+#		features		"2 pg_init_retries 50"
+#               hardware_handler        "1 rdac"
+#		path_grouping_policy	group_by_prio
+#               failback                immediate
+#		no_path_retry		15
+#		rr_min_io		1000
+#               path_checker            rdac
+#       }
+#	device {
+#		vendor                  "DELL"
+#               product                 "MD32xx|MD32xxi"
+#		getuid_callout          "/sbin/scsi_id -g -u -s /block/%n"
+#               prio_callout            "/sbin/mpath_prio_rdac /dev/%n"
+#		features		"2 pg_init_retries 50"
 #               hardware_handler        "1 rdac"
 #		path_grouping_policy	group_by_prio
-#               failback                manual
-#               path_checker            readsector0
+#               failback                immediate
+#		no_path_retry		15
+#		rr_min_io		1000
+#               path_checker            rdac
 #       }
 #       device {
 #               vendor                  "EMC"
@@ -284,6 +313,20 @@
 #		rr_min_io		1000
 #               path_checker            rdac
 #	}
+#	device {
+#		vendor			"IBM"
+#		product			"1745|1746"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#		prio_callout		"/sbin/mpath_prio_rdac /dev/%n"
+#		features		"2 pg_init_retries 50"
+#		hardware_handler	"1 rdac"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		rr_weight		uniform
+#		no_path_retry		15
+#		rr_min_io		1000
+#               path_checker            rdac
+#	}
 #       device {
 #               vendor                  "IBM"
 #               product                 "1815"
--- multipath-tools/libmultipath/hwtable.c	2009/11/04 21:47:06	1.20.2.24
+++ multipath-tools/libmultipath/hwtable.c	2009/12/02 19:15:28	1.20.2.25
@@ -402,6 +402,21 @@
 		.checker_name  = RDAC,
 	},
 	{
+		.vendor        = "IBM",
+		.product       = "1745|1746",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 15,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+	},
+	{
 		/* IBM DS4800 */
 		.vendor        = "IBM",
 		.product       = "1815",
@@ -810,23 +825,54 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = RDAC,
 	},
+	{
+		.vendor        = "(LSI|ENGENIO)",
+		.product       = "INF.*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 15,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
+	},
 	/*
 	 * DELL arrays
 	 */
 	{
 		.vendor        = "DELL",
-		.product       = "MD3000",
+		.product       = "MD3000|MD3000i",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
-		.features      = DEFAULT_FEATURES,
+		.features      = "2 pg_init_retries 50",
 		.hwhandler     = "1 rdac",
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = -FAILBACK_MANUAL,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.no_path_retry = 15,
 		.minio         = DEFAULT_MINIO,
-		.checker_name  = READSECTOR0,
+		.checker_name  = RDAC,
+	},
+	{
+	/* DELL MD32xx/MD32xxi */
+		.vendor        = "DELL",
+		.product       = "MD32xx|MD32xxi",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_rdac /dev/%n",
+		.features      = "2 pg_init_retries 50",
+		.hwhandler     = "1 rdac",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 15,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = RDAC,
 	},
 	/*
 	 * Compellent Technologies, Inc.
