From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 6/9] dm: Simplify dm_old_stop_queue()
Date: Wed, 31 Aug 2016 15:17:24 -0700
Message-ID: <a34ce7a7-8dfa-f0fd-131f-b78402f95eb7@sandisk.com>
References: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <18db2396-cd4f-1d52-1ffa-21b9b512eaf4@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm-rq.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 1ca7463..8dc8cfb 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -89,12 +89,8 @@ static void dm_old_stop_queue(struct request_queue *q)
 	unsigned long flags;
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (blk_queue_stopped(q)) {
-		spin_unlock_irqrestore(q->queue_lock, flags);
-		return;
-	}
-
-	blk_stop_queue(q);
+	if (!blk_queue_stopped(q))
+		blk_stop_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
-- 
2.9.3
