From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] dm-crypt: don't mess with BIP_BLOCK_INTEGRITY
Date: Wed,  9 Aug 2017 17:48:09 +0200
Message-ID: <20170809154809.2168-3-hch@lst.de>
References: <20170809154809.2168-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170809154809.2168-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: mpatocka@redhat.com, gmazyland@gmail.com, martin.petersen@oracle.com, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

This flag is never set right after calling bio_integrity_alloc,
so don't clear it and confuse the reader.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-crypt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index cdf6b1e12460..73c2e270cda6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -933,9 +933,6 @@ static int dm_crypt_integrity_io_alloc(struct dm_crypt_io *io, struct bio *bio)
 	bip->bip_iter.bi_size = tag_len;
 	bip->bip_iter.bi_sector = io->cc->start + io->sector;
 
-	/* We own the metadata, do not let bio_free to release it */
-	bip->bip_flags &= ~BIP_BLOCK_INTEGRITY;
-
 	ret = bio_integrity_add_page(bio, virt_to_page(io->integrity_metadata),
 				     tag_len, offset_in_page(io->integrity_metadata));
 	if (unlikely(ret != tag_len))
-- 
2.11.0
