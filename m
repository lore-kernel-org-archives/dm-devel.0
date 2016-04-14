From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v1 20/27] dm: dm-bufio.c: use bio_set_vec_table()
Date: Thu, 14 Apr 2016 20:02:38 +0800
Message-ID: <1460635375-28282-21-git-send-email-tom.leiming@gmail.com>
References: <1460635375-28282-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1460635375-28282-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID Multiple Disks
	SUPPORT" <linux-raid@vger.kernel.org>
List-Id: dm-devel.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/md/dm-bufio.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cd77216..0e48ad7 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -624,8 +624,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 	int len;
 
 	bio_init(&b->bio);
-	b->bio.bi_io_vec = b->bio_vec;
-	b->bio.bi_max_vecs = DM_BUFIO_INLINE_VECS;
+	bio_set_vec_table(&b->bio, b->bio_vec, DM_BUFIO_INLINE_VECS);
 	b->bio.bi_iter.bi_sector = block << b->c->sectors_per_block_bits;
 	b->bio.bi_bdev = b->c->bdev;
 	b->bio.bi_end_io = inline_endio;
-- 
1.9.1
