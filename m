From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] bio-integrity: only verify integrity on the lowest stacked driver
Date: Wed,  9 Aug 2017 17:47:27 +0200
Message-ID: <20170809154727.2085-3-hch@lst.de>
References: <20170809154727.2085-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170809154727.2085-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: mpatocka@redhat.com, gmazyland@gmail.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This gets us back to the behavior in 4.12 and earlier.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Fixes: 7c20f116 ("bio-integrity: stop abusing bi_end_io")
---
 block/bio-integrity.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index dcfb968c8259..9b1ea478577b 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -388,11 +388,10 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 bool __bio_integrity_endio(struct bio *bio)
 {
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
+	struct bio_integrity_payload *bip = bio_integrity(bio);
 
 	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status &&
-	    bi->profile->verify_fn)
-		struct bio_integrity_payload *bip = bio_integrity(bio);
-
+	    (bip->bip_flags & BIP_BLOCK_INTEGRITY) && bi->profile->verify_fn) {
 		INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
 		queue_work(kintegrityd_wq, &bip->bip_work);
 		return false;
-- 
2.11.0
