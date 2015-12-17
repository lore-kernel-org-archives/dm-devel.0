From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 5/6] brd: Split bio if needed
Date: Thu, 17 Dec 2015 12:42:37 +0100
Message-ID: <56729FAD.8010503@sandisk.com>
References: <56729ECF.50906@sandisk.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <56729ECF.50906@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@fb.com>
Cc: Jan Kara <jack@suse.cz>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Dmitry Monakhov <dmonakhov@openvz.org>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

If a bio is submitted to the brd driver that does not satisfy the
requirements of this driver, split the bio.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-merge.c   | 2 +-
 drivers/block/brd.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 2ce5a78..c158577 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -39,7 +39,7 @@ static struct bio *blk_bio_discard_split(struct request_queue *q,
 		if (end == end_r && bio_sectors(bio) == end_r - start)
 			return NULL;
 		return bio_split(bio, end_r - start, GFP_NOIO, bs);
-	} else if (q->limits.discard_zeroes_data) {
+	} else if (q->limits.discard_zeroes_data && start < end) {
 		end = min(end, start_r + granularity);
 		wr = bio_alloc_bioset(GFP_NOIO, end - start, bs);
 		if (WARN_ON_ONCE(!wr))
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 1914c63..7e0a54e 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -336,6 +336,8 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
 	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk))
 		goto io_error;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
 		if (sector & ((PAGE_SIZE >> SECTOR_SHIFT) - 1) ||
 		    bio->bi_iter.bi_size & ~PAGE_MASK)
-- 
2.1.4
