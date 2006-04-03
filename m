From: David Wysochanski <davidw@netapp.com>
Subject: [PATCH] update netapp and IBM nseries (netapp) hwtable.c
	targets
Date: Mon, 03 Apr 2006 17:36:34 -0400
Message-ID: <44319562.80106@netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070000050100020407030104"
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------070000050100020407030104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Should apply to latest source.

--------------070000050100020407030104
Content-Type: text/x-patch;
 name="update-netapp-ibm-nseries-hwtable.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="update-netapp-ibm-nseries-hwtable.patch"

--- libmultipath/hwtable.c.orig	2006-04-03 16:54:34.865830000 -0400
+++ libmultipath/hwtable.c	2006-04-03 17:23:14.464443000 -0400
@@ -315,25 +315,46 @@ static struct hwentry default_hw[] = {
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = DIRECTIO,
 	},
-	/*
+ 	/*
 	 * NETAPP controler family
 	 *
 	 * Maintainer : Dave Wysochanski
-	 * Mail : davidw netapp com
+	 * Mail : davidw@netapp.com
 	 */
 	{
 		.vendor        = "NETAPP",
-		.product       = "LUN",
+		.product       = "LUN.*",
 		.getuid        = DEFAULT_GETUID,
 		.getprio       = "/sbin/mpath_prio_netapp /dev/%n",
 		.features      = "1 queue_if_no_path",
 		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
 		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = FAILBACK_UNDEF,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = NO_PATH_RETRY_UNDEF,
-		.minio         = DEFAULT_MINIO,
+		.minio         = 128,
+		.checker_name  = READSECTOR0,
+	},
+ 	/*
+	 * IBM NSeries (NETAPP) controler family
+	 *
+	 * Maintainer : Dave Wysochanski
+	 * Mail : davidw@netapp.com
+	 */
+	{
+		.vendor        = "IBM",
+		.product       = "Nseries.*",
+		.getuid        = DEFAULT_GETUID,
+		.getprio       = "/sbin/mpath_prio_netapp /dev/%n",
+		.features      = "1 queue_if_no_path",
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = NO_PATH_RETRY_UNDEF,
+		.minio         = 128,
 		.checker_name  = READSECTOR0,
 	},
 	/*

--------------070000050100020407030104
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------070000050100020407030104--
