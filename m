From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] multipath_tools: Add IBM Virtual SCSI ALUA
	device type to hwtable
Date: Tue, 16 Feb 2010 13:44:59 -0600
Message-ID: <201002161944.o1GJirOk014950@d01av01.pok.ibm.com>
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
To: dm-devel@redhat.com
Cc: brking@linux.vnet.ibm.com
List-Id: dm-devel.ids


Add entry to the hwtable for IBM Power Virtual SCSI ALUA devices

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 libmultipath/hwtable.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff -puN libmultipath/hwtable.c~mpath_nvdisk libmultipath/hwtable.c
--- multipath-tools/libmultipath/hwtable.c~mpath_nvdisk	2010-02-16 13:42:42.000000000 -0600
+++ multipath-tools-bjking1/libmultipath/hwtable.c	2010-02-16 13:42:42.000000000 -0600
@@ -673,6 +673,23 @@ static struct hwentry default_hw[] = {
 		.prio_name     = DEFAULT_PRIO,
 	},
 	{
+		/* AIX NVDISK */
+		.vendor        = "AIX",
+		.product       = "NVDISK",
+		.getuid        = DEFAULT_GETUID,
+		.features      = DEFAULT_FEATURES,
+		.hwhandler     = "1 alua",
+		.selector      = DEFAULT_SELECTOR,
+		.pgpolicy      = GROUP_BY_PRIO,
+		.pgfailback    = -FAILBACK_IMMEDIATE,
+		.rr_weight     = RR_WEIGHT_NONE,
+		.no_path_retry = (300 / DEFAULT_CHECKINT),
+		.minio         = DEFAULT_MINIO,
+		.checker_name  = TUR,
+		.prio_name     = PRIO_ALUA,
+	},
+
+	{
 		/* DELL MD3000 */
 		.vendor        = "DELL",
 		.product       = "MD3000",
_
