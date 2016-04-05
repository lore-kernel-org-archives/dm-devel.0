From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 19/27] dm: dm.c: replace 'bio->bi_vcnt == 1' with !bio_multiple_segments
Date: Tue,  5 Apr 2016 20:07:34 +0800
Message-ID: <1459858062-21075-5-git-send-email-tom.leiming@gmail.com>
References: <1459858062-21075-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459858062-21075-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <tom.leiming@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/dm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index be49057..4c34f88 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2172,7 +2172,8 @@ static void dm_request_fn(struct request_queue *q)
 			pos = blk_rq_pos(rq);
 
 		if ((dm_request_peeked_before_merge_deadline(md) &&
-		     md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
+		     md_in_flight(md) && rq->bio &&
+		     !bio_multiple_segments(rq->bio) &&
 		     md->last_rq_pos == pos && md->last_rq_rw == rq_data_dir(rq)) ||
 		    (ti->type->busy && ti->type->busy(ti))) {
 			blk_delay_queue(q, HZ / 100);
-- 
1.9.1
