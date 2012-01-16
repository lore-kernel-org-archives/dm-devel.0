From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath hwtable.c
Date: 16 Jan 2012 22:22:05 -0000
Message-ID: <20120116222205.20282.qmail@sourceware.org>
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
Changes by:	bmarzins@sourceware.org	2012-01-16 22:22:05

Modified files:
	libmultipath   : hwtable.c 

Log message:
	Fix for bzs 781480/742906. change config for HP P2000 SAS

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/hwtable.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.20.2.36&r2=1.20.2.37

--- multipath-tools/libmultipath/hwtable.c	2011/10/26 04:55:18	1.20.2.36
+++ multipath-tools/libmultipath/hwtable.c	2012/01/16 22:22:05	1.20.2.37
@@ -173,7 +173,7 @@
 	{
                  /* HP P2000 product family */
                 .vendor        = "HP",
-                .product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 SAS|P2000 G3 iSCSI",
+                .product       = "P2000 G3 FC|P2000G3 FC/iSCSI|P2000 G3 iSCSI",
                 .getuid        = DEFAULT_GETUID,
                 .getprio       = "/sbin/mpath_prio_alua /dev/%n",
                 .features      = DEFAULT_FEATURES,
@@ -187,6 +187,22 @@
                 .checker_name  = TUR,
         },
 	{
+		/* HP P2000 SAS */
+		.vendor        = "HP",
+		.product       = "P2000 G3 SAS",
+		.getuid        = "/sbin/cciss_id /block/%n",
+		.getprio       = "/sbin/mpath_prio_alua /dev/%c",
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
+	{
                  /* HP SVSP Active-Standby */
                 .vendor        = "HP",
                 .product       = "HSVX700",
