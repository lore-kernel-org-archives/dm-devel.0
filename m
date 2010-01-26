From: bmarzins@sourceware.org
Subject: multipath-tools ./multipath.conf.defaults libm ...
Date: 26 Jan 2010 05:50:45 -0000
Message-ID: <20100126055045.5404.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2010-01-26 05:50:45

Modified files:
	.              : multipath.conf.defaults 
	libmultipath   : hwtable.c 

Log message:
	Fix for bz #545822
	Add hwentry for EMC Invista

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/multipath.conf.defaults.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.5.4.18&r2=1.5.4.19
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.25&r2=1.20.2.26

--- multipath-tools/multipath.conf.defaults	2009/12/02 19:15:28	1.5.4.18
+++ multipath-tools/multipath.conf.defaults	2010/01/26 05:50:44	1.5.4.19
@@ -237,6 +237,20 @@
 #		rr_min_io		1000
 #		path_checker		readsector0
 #       }
+#      device {
+#               vendor                  "EMC"
+#               product                 "Invista"
+#               product_blacklist       "LUNZ"
+#		getuid_callout		"/sbin/scsi_id -g -u -s /block/%n"
+#               features                "0"
+#               hardware_handler        "0"
+#               path_selector           "round-robin 0"
+#               path_grouping_policy    failover
+#               rr_weight               uniform
+#               no_path_retry           5
+#               rr_min_io               1000
+#               path_checker            tur
+#      }
 #       device {
 #               vendor                  "FSC"
 #               product                 "CentricStor"
--- multipath-tools/libmultipath/hwtable.c	2009/12/02 19:15:28	1.20.2.25
+++ multipath-tools/libmultipath/hwtable.c	2010/01/26 05:50:45	1.20.2.26
@@ -300,6 +300,22 @@
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = READSECTOR0,
 	},
+	{
+		.vendor        = "EMC",
+		.product       = "Invista",
+		.bl_product    = "LUNZ",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = NULL,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = FAILOVER,
+		.pgfailback    = FAILBACK_UNDEF,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = 5,
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+	},
 	/*
 	 * IBM controller family
 	 *
