From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 09/60] dm: dm.c: replace 'bio->bi_vcnt == 1' with !bio_multiple_segments
Date: Sat, 29 Oct 2016 16:08:08 +0800
Message-ID: <1477728600-12938-10-git-send-email-tom.leiming@gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ming Lei <tom.leiming@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
        SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Avoid to access .bi_vcnt directly, because it may be not what
the driver expected any more after supporting multipage bvec.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/dm-rq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 1d0d2adc050a..8534cbf8ce35 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -819,7 +819,8 @@ static void dm_old_request_fn(struct request_queue *q)
 			pos = blk_rq_pos(rq);
 
 		if ((dm_old_request_peeked_before_merge_deadline(md) &&
-		     md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
+		     md_in_flight(md) && rq->bio &&
+		     !bio_multiple_segments(rq->bio) &&
 		     md->last_rq_pos == pos && md->last_rq_rw == rq_data_dir(rq)) ||
 		    (ti->type->busy && ti->type->busy(ti))) {
 			blk_delay_queue(q, 10);
-- 
2.7.4
