From: Tahsin Erdogan <tahsin@google.com>
Subject: [PATCH] dm: fix parameter to blk_delay_queue()
Date: Fri, 15 Jul 2016 06:27:08 -0700
Message-ID: <1468589228-20722-1-git-send-email-tahsin@google.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tahsin Erdogan <tahsin@google.com>
List-Id: dm-devel.ids

Second parameter to blk_delay_queue() must be in msec units not jiffies.

Signed-off-by: Tahsin Erdogan <tahsin@google.com>
---
 drivers/md/dm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1b2f96205361..17c63265a205 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2175,7 +2175,7 @@ static void dm_request_fn(struct request_queue *q)
 		     md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
 		     md->last_rq_pos == pos && md->last_rq_rw == rq_data_dir(rq)) ||
 		    (ti->type->busy && ti->type->busy(ti))) {
-			blk_delay_queue(q, HZ / 100);
+			blk_delay_queue(q, 10);
 			return;
 		}
 
-- 
2.8.0.rc3.226.g39d4020

