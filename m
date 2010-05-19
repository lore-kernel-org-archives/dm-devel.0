From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] multipath_tools: Fixup IBM Virtual SCSI
	hwtable entries
Date: Wed, 19 May 2010 15:26:24 -0500
Message-ID: <201005192026.o4JKQQmP009575@d03av02.boulder.ibm.com>
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


Removes a hwtable entry for a IBM Virtual SCSI vendor/device ID that
is no longer going to be released. Adds a new vendor/device ID for
a new IBM Virtual SCSI vendor/device ID. This is needed since path
switching on this device type is expensive, so we don't want to do
round robin. Additionally, the default health checker (direct IO)
does not work for this device type.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 libmultipath/hwtable.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN libmultipath/hwtable.c~mpath_nxtgen libmultipath/hwtable.c
--- multipath-tools/libmultipath/hwtable.c~mpath_nxtgen	2010-04-12 16:27:00.000000000 -0500
+++ multipath-tools-bjking1/libmultipath/hwtable.c	2010-05-12 12:40:54.000000000 -0500
@@ -703,20 +703,20 @@ static struct hwentry default_hw[] = {
 		.prio_name     = DEFAULT_PRIO,
 	},
 	{
-		/* AIX NVDISK */
-		.vendor        = "AIX",
-		.product       = "NVDISK",
+		/* IBM 3303      NVDISK */
+		.vendor        = "IBM",
+		.product       = "3303      NVDISK",
 		.getuid        = DEFAULT_GETUID,
 		.features      = DEFAULT_FEATURES,
-		.hwhandler     = "1 alua",
+		.hwhandler     = DEFAULT_HWHANDLER,
 		.selector      = DEFAULT_SELECTOR,
-		.pgpolicy      = GROUP_BY_PRIO,
+		.pgpolicy      = FAILOVER,
 		.pgfailback    = -FAILBACK_IMMEDIATE,
 		.rr_weight     = RR_WEIGHT_NONE,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.minio         = DEFAULT_MINIO,
 		.checker_name  = TUR,
-		.prio_name     = PRIO_ALUA,
+		.prio_name     = DEFAULT_PRIO,
 	},
 
 	{
_
