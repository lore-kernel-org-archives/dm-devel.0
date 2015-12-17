From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 6/6] brd: Accept non-aligned discard requests
	with size zero
Date: Thu, 17 Dec 2015 12:43:12 +0100
Message-ID: <56729FD0.3070309@sandisk.com>
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

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/block/brd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 7e0a54e..a757c7b 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -339,8 +339,9 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
 	blk_queue_split(q, &bio, q->bio_split);
 
 	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
-		if (sector & ((PAGE_SIZE >> SECTOR_SHIFT) - 1) ||
-		    bio->bi_iter.bi_size & ~PAGE_MASK)
+		if (bio->bi_iter.bi_size &&
+		    (sector & ((PAGE_SIZE >> SECTOR_SHIFT) - 1) ||
+		     bio->bi_iter.bi_size & ~PAGE_MASK))
 			goto io_error;
 		discard_from_brd(brd, sector, bio->bi_iter.bi_size);
 		goto out;
-- 
2.1.4
