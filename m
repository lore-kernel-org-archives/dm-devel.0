From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] multipath_tools: Add IBM Virtual SCSI to
	hwtable
Date: Thu, 04 Jun 2009 13:10:38 -0500
Message-ID: <200906041810.n54IAdAQ006547@d01av04.pok.ibm.com>
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
To: dm-devel@redhat.com
Cc: brking@linux.vnet.ibm.com
List-Id: dm-devel.ids


Add entry to the hwtable for IBM Power Virtual SCSI devices.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 libmultipath/hwtable.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff -puN libmultipath/hwtable.c~mpath_vios libmultipath/hwtable.c
--- multipath-tools/libmultipath/hwtable.c~mpath_vios	2009-06-03 17:40:56.000000000 -0500
+++ multipath-tools-bjking1/libmultipath/hwtable.c	2009-06-04 09:54:33.000000000 -0500
@@ -634,6 +634,28 @@ static struct hwentry default_hw[] = {
 		.checker_name  = TUR,
 		.prio_name     = PRIO_ALUA,
 	},
+	/*
+	 * IBM Power Virtual SCSI Devices
+	 *
+	 * Maintainer : Brian King, IBM
+	 * Mail : brking@linux.vnet.ibm.com
+	 */
+	{
+		/* AIX VDASD */
+		.vendor        = "AIX",
+		.product       = "VDASD",
+		.getuid        = DEFAULT_GETUID,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = DEFAULT_HWHANDLER,
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = MULTIBUS,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = (300 / DEFAULT_CHECKINT),
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = DIRECTIO,
+		.prio_name     = DEFAULT_PRIO,
+	},
 	{
 		/* DELL MD3000 */
 		.vendor        = "DELL",
_
