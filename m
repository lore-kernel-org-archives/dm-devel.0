From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 31 Aug 2009 17:17:11 -0000
Message-ID: <20090831171711.29021.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2009-08-31 17:17:11

Modified files:
	libmultipath   : hwtable.c 

Log message:
	Updated HP MSA configuration. Already Upstream.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.20&r2=1.20.2.21

--- multipath-tools/libmultipath/hwtable.c	2009/08/19 21:52:40	1.20.2.20
+++ multipath-tools/libmultipath/hwtable.c	2009/08/31 17:17:10	1.20.2.21
@@ -63,11 +63,11 @@
 		.vendor        = "DEC",
 		.product       = "HSG80",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
-		.features      = "2 pg_init_retries 10",
+		.getprio       = "/sbin/mpath_prio_hp_sw /dev/%n",
+		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp-sw",
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = GROUP_BY_SERIAL,
+		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
@@ -77,17 +77,17 @@
 	{
 		/* MSA 1000/MSA1500, EVA 3000/5000 with old firmware */
 		.vendor        = "COMPAQ",
-		.product       = "MSA|HSV1.0.*",
+		.product       = "(MSA|HSV)1.0.*",
 		.getuid        = DEFAULT_GETUID,
-		.getprio       = NULL,
-		.features      = "2 pg_init_retries 10",
+		.getprio       = "/sbin/mpath_prio_hp_sw /dev/%n",
+		.features      = "1 queue_if_no_path",
 		.hwhandler     = "1 hp-sw",
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = MULTIBUS,
+		.pgpolicy      = GROUP_BY_PRIO,
 		.pgfailback    = FAILBACK_UNDEF,
 		.rr_weight     = RR_WEIGHT_NONE,
-		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = DEFAULT_MINIO,
+		.no_path_retry = 12,
+		.minio         = 100,
 		.checker_name  = HP_SW,
 	},
 	{
