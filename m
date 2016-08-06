From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 3/3] multipath-tools: revert add VIOLIN/CONCERTO
	ARRAY to hardware table
Date: Sat,  6 Aug 2016 11:59:33 +0200
Message-ID: <1470477573-3725-4-git-send-email-xose.vazquez@gmail.com>
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
index d46cd00..af37c10 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -816,21 +816,6 @@ static struct hwentry default_hw[] = {
 		.pgpolicy      = MULTIBUS,
 		.pgfailback    = FAILBACK_UNDEF,
 	},
-	/*
-	 * Violin Memory
-	 */
-	{
-		.vendor        = "VIOLIN",
-		.product       = "CONCERTO ARRAY",
-		.selector      = "round-robin 0",
-		.pgpolicy      = MULTIBUS,
-		.prio_name     = PRIO_ALUA,
-		.minio         = 100,
-		.rr_weight     = RR_WEIGHT_PRIO,
-		.pgfailback    = -FAILBACK_IMMEDIATE,
-		.features      = "1 queue_if_no_path",
-		.no_path_retry = 300,
-	},
 #if 0
 	/*
 	 * Copy this TEMPLATE to add new hardware.
-- 
2.7.4
