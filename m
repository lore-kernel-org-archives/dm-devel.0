From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: reorder NVDISK devices
Date: Thu,  1 Aug 2019 19:21:38 +0200
Message-ID: <20190801172138.15049-1-xose.vazquez@gmail.com>
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
Cc: Brian King <brking@linux.vnet.ibm.com>, DM-DEVEL ML <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Otherwise "3303[ ]+NVDISK" is never reached, because "NVDISK" regex takes
priority over it.

Cc: Brian King <brking@linux.vnet.ibm.com>
Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: DM-DEVEL ML <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index a06872e..8209554 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -696,12 +696,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 	},
-	{
-		/* 3303 NVDISK */
-		.vendor        = "IBM",
-		.product       = "3303[ ]+NVDISK",
-		.no_path_retry = (300 / DEFAULT_CHECKINT),
-	},
 	{
 		/* AIX NVDISK */
 		.vendor        = "AIX",
@@ -712,6 +706,12 @@ static struct hwentry default_hw[] = {
 		.no_path_retry = (300 / DEFAULT_CHECKINT),
 		.prio_name     = PRIO_ALUA,
 	},
+	{
+		/* 3303 NVDISK */
+		.vendor        = "IBM",
+		.product       = "3303[ ]+NVDISK",
+		.no_path_retry = (300 / DEFAULT_CHECKINT),
+	},
         /*
          * Lenovo
          */
-- 
2.21.0
