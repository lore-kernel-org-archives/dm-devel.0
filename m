From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 1/3] multipath-tools: revert add TEGILE devices
	to hardware table
Date: Sat,  6 Aug 2016 11:59:31 +0200
Message-ID: <1470477573-3725-2-git-send-email-xose.vazquez@gmail.com>
References: <1470477573-3725-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1470477573-3725-1-git-send-email-xose.vazquez@gmail.com>
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

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index 187c109..69200f1 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -846,21 +846,6 @@ static struct hwentry default_hw[] = {
 		.flush_on_last_del = FLUSH_ENABLED,
 		.dev_loss      = 30,
 	},
-	/*
-	 * Tegile Systems
-	 */
-	{
-		.vendor        = "TEGILE",
-		.product       = "(ZEBI-(FC|ISCSI)|INTELLIFLASH)",
-		.hwhandler     = "1 alua",
-		.selector      = "round-robin 0",
-		.no_path_retry = 10,
-		.dev_loss      = 50,
-		.prio_name     = PRIO_ALUA,
-		.pgpolicy      = GROUP_BY_PRIO,
-		.pgfailback    = 30,
-		.minio         = 128,
-	},
 #if 0
 	/*
 	 * Copy this TEMPLATE to add new hardware.
-- 
2.7.4
