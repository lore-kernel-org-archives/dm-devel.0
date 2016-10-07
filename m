From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: add IBM/FlashSystem to hwtable
Date: Fri,  7 Oct 2016 15:15:22 +0200
Message-ID: <20161007131522.3442-1-xose.vazquez@gmail.com>
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
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

System          Vendor Product          Multipathing Policy
=============== ====== ================ =======================
FlashSystem 710 IBM    FlashSystem      Symmetric Active/Active
FlashSystem 720 IBM    FlashSystem      Symmetric Active/Active
FlashSystem 810 IBM    FlashSystem      Symmetric Active/Active
FlashSystem 820 IBM    FlashSystem      Symmetric Active/Active
FlashSystem 840 IBM    FlashSystem-9840 Symmetric Active/Active
FlashSystem 900 IBM    FlashSystem-9840 Symmetric Active/Active

Based on documentation from the manufacturer:
http://www.redbooks.ibm.com/redbooks/pdfs/sg248271.pdf

Cc: Hannes Reinecke <hare@suse.de>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index e1b055a..ff6989d 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -522,6 +522,13 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = NO_PATH_RETRY_QUEUE,
 		.pgpolicy      = MULTIBUS,
 	},
+	{
+		/* FlashSystem 710/720/810/820/840/900 */
+		.vendor        = "IBM",
+		.product       = "FlashSystem",
+		.no_path_retry = NO_PATH_RETRY_FAIL,
+		.pgpolicy      = MULTIBUS,
+	},
 		/*
 		 * IBM Power Virtual SCSI Devices
 		 *
-- 
2.10.1
