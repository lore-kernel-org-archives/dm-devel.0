From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH 4/6] multipath-tools: delete minio_rq attribute
	when it is equal to default value
Date: Sat,  9 Jul 2016 01:58:46 +0200
Message-ID: <1468022328-5905-5-git-send-email-xose.vazquez@gmail.com>
References: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1468022328-5905-1-git-send-email-xose.vazquez@gmail.com>
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

      1                 .minio_rq      = 1,

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 libmultipath/hwtable.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/libmultipath/hwtable.c b/libmultipath/hwtable.c
index efc1759..d3be19a 100644
--- a/libmultipath/hwtable.c
+++ b/libmultipath/hwtable.c
@@ -914,7 +914,6 @@ static struct hwentry default_hw[] = {
 		.pgfailback    = 30,
 		.rr_weight     = RR_WEIGHT_PRIO,
 		.no_path_retry = NO_PATH_RETRY_FAIL,
-		.minio_rq      = 1,
 		.flush_on_last_del = FLUSH_ENABLED,
 		.fast_io_fail  = 5,
 		.dev_loss      = 30,
-- 
2.7.4
