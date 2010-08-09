From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 9 Aug 2010 21:35:58 -0000
Message-ID: <20100809213558.25495.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-08-09 21:35:58

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz565579  New default configurations.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.21&r2=1.5.4.22
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.28&r2=1.20.2.29

--- multipath-tools/multipath.conf.defaults	2010/08/09 18:38:21	1.5.4.21
+++ multipath-tools/multipath.conf.defaults	2010/08/09 21:35:58	1.5.4.22
@@ -490,6 +490,46 @@
 #		rr_min_io		1000
 #               path_checker            tur
 #	}
+#	device {
+#		vendor			"IBM"
+#		product			"3303      NVDISK"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    failover
+#		failback		immediate
+#		no_path_retry		60
+#		rr_weight		uniform
+#		rr_min_io		1000
+#               path_checker            tur
+#	}
+#	device {
+#		vendor			"AIX"
+#		product			"VDASD"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#		features		"0"
+#		hardware_handler	"0"
+#               path_grouping_policy    multibus
+#		failback		immediate
+#		no_path_retry		60
+#		rr_weight		uniform
+#		rr_min_io		1000
+#               path_checker            directio
+#	}
+#	device {
+#		vendor			"AIX"
+#		product			"NVDISK"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#		prio_callout		"/sbin/mpath_prio_alua /dev/%n"
+#		features		"0"
+#		hardware_handler	"1 alua"
+#               path_grouping_policy    group_by_prio
+#		failback		immediate
+#		no_path_retry		60
+#		rr_weight		uniform
+#		rr_min_io		1000
+#               path_checker            tur
+#	}
 #       device {
 #               vendor                  "SGI"
 #               product                 "TP9[13]00"
--- multipath-tools/libmultipath/hwtable.c	2010/08/09 18:38:21	1.20.2.28
+++ multipath-tools/libmultipath/hwtable.c	2010/08/09 21:35:58	1.20.2.29
@@ -657,6 +657,23 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
 	},
+	{
+		/* IBM 3303      NVDISK */
+		.vendor        = "IBM",
+		.product       = "3303      NVDISK",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = NULL,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = FAILOVER,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = (300 / DEFAULT_CHECKINT),
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+	},
+
 	/*
 	 * IBM Power Virtual SCSI Devices
 	 *
@@ -679,6 +696,23 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = DIRECTIO,
 	},
+	{
+		/* AIX NVDISK */
+		.vendor        = "AIX",
+		.product       = "NVDISK",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_alua /dev/%n",
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 alua",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = (300 / DEFAULT_CHECKINT),
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+	},
+
 	/*
 	 * SGI arrays
 	 *
