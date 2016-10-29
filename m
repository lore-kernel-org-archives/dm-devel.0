From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 02/60] block drivers: convert to bio_init_with_vec_table()
Date: Sat, 29 Oct 2016 16:08:01 +0800
Message-ID: <1477728600-12938-3-git-send-email-tom.leiming@gmail.com>
References: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1477728600-12938-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Ming Lei <tom.leiming@gmail.com>, Jiri Kosina <jikos@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Joern Engel <joern@logfs.org>, Prasad Joshi <prasadjoshi.linux@gmail.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>E
List-Id: dm-devel.ids

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 drivers/block/floppy.c        |  3 +--
 drivers/md/bcache/io.c        |  4 +---
 drivers/md/bcache/journal.c   |  4 +---
 drivers/md/bcache/movinggc.c  |  7 +++----
 drivers/md/bcache/super.c     | 13 ++++---------
 drivers/md/bcache/writeback.c |  6 +++---
 drivers/md/dm-bufio.c         |  4 +---
 drivers/md/raid5.c            |  9 ++-------
 drivers/nvme/target/io-cmd.c  |  4 +---
 fs/logfs/dev_bdev.c           |  4 +---
 10 files changed, 18 insertions(+), 40 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index e3d8e4ced4a2..cdc916a95137 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3806,8 +3806,7 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 
 	cbdata.drive = drive;
 
-	bio_init(&bio);
-	bio.bi_io_vec = &bio_vec;
+	bio_init_with_vec_table(&bio, &bio_vec, 1);
 	bio_vec.bv_page = page;
 	bio_vec.bv_len = size;
 	bio_vec.bv_offset = 0;
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index e97b0acf7b8d..af9489087cd3 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -24,9 +24,7 @@ struct bio *bch_bbio_alloc(struct cache_set *c)
 	struct bbio *b = mempool_alloc(c->bio_meta, GFP_NOIO);
 	struct bio *bio = &b->bio;
 
-	bio_init(bio);
-	bio->bi_max_vecs	 = bucket_pages(c);
-	bio->bi_io_vec		 = bio->bi_inline_vecs;
+	bio_init_with_vec_table(bio, bio->bi_inline_vecs, bucket_pages(c));
 
 	return bio;
 }
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 6925023e12d4..b966f28d1b98 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -448,13 +448,11 @@ static void do_journal_discard(struct cache *ca)
 
 		atomic_set(&ja->discard_in_flight, DISCARD_IN_FLIGHT);
 
-		bio_init(bio);
+		bio_init_with_vec_table(bio, bio->bi_inline_vecs, 1);
 		bio_set_op_attrs(bio, REQ_OP_DISCARD, 0);
 		bio->bi_iter.bi_sector	= bucket_to_sector(ca->set,
 						ca->sb.d[ja->discard_idx]);
 		bio->bi_bdev		= ca->bdev;
-		bio->bi_max_vecs	= 1;
-		bio->bi_io_vec		= bio->bi_inline_vecs;
 		bio->bi_iter.bi_size	= bucket_bytes(ca);
 		bio->bi_end_io		= journal_discard_endio;
 
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 5c4bddecfaf0..9d7991f69030 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -77,15 +77,14 @@ static void moving_init(struct moving_io *io)
 {
 	struct bio *bio = &io->bio.bio;
 
-	bio_init(bio);
+	bio_init_with_vec_table(bio, bio->bi_inline_vecs,
+				DIV_ROUND_UP(KEY_SIZE(&io->w->key),
+					     PAGE_SECTORS));
 	bio_get(bio);
 	bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
 
 	bio->bi_iter.bi_size	= KEY_SIZE(&io->w->key) << 9;
-	bio->bi_max_vecs	= DIV_ROUND_UP(KEY_SIZE(&io->w->key),
-					       PAGE_SECTORS);
 	bio->bi_private		= &io->cl;
-	bio->bi_io_vec		= bio->bi_inline_vecs;
 	bch_bio_map(bio, NULL);
 }
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 849ad441cd76..d8a6d807b498 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1152,9 +1152,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	dc->bdev = bdev;
 	dc->bdev->bd_holder = dc;
 
-	bio_init(&dc->sb_bio);
-	dc->sb_bio.bi_max_vecs	= 1;
-	dc->sb_bio.bi_io_vec	= dc->sb_bio.bi_inline_vecs;
+	bio_init_with_vec_table(&dc->sb_bio, dc->sb_bio.bi_inline_vecs, 1);
 	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;
 	get_page(sb_page);
 
@@ -1814,9 +1812,8 @@ static int cache_alloc(struct cache *ca)
 	__module_get(THIS_MODULE);
 	kobject_init(&ca->kobj, &bch_cache_ktype);
 
-	bio_init(&ca->journal.bio);
-	ca->journal.bio.bi_max_vecs = 8;
-	ca->journal.bio.bi_io_vec = ca->journal.bio.bi_inline_vecs;
+	bio_init_with_vec_table(&ca->journal.bio,
+				ca->journal.bio.bi_inline_vecs, 8);
 
 	free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
 
@@ -1852,9 +1849,7 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	ca->bdev = bdev;
 	ca->bdev->bd_holder = ca;
 
-	bio_init(&ca->sb_bio);
-	ca->sb_bio.bi_max_vecs	= 1;
-	ca->sb_bio.bi_io_vec	= ca->sb_bio.bi_inline_vecs;
+	bio_init_with_vec_table(&ca->sb_bio, ca->sb_bio.bi_inline_vecs, 1);
 	ca->sb_bio.bi_io_vec[0].bv_page = sb_page;
 	get_page(sb_page);
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index e51644e503a5..b2568cef8c86 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -106,14 +106,14 @@ static void dirty_init(struct keybuf_key *w)
 	struct dirty_io *io = w->private;
 	struct bio *bio = &io->bio;
 
-	bio_init(bio);
+	bio_init_with_vec_table(bio, bio->bi_inline_vecs,
+				DIV_ROUND_UP(KEY_SIZE(&w->key),
+					     PAGE_SECTORS));
 	if (!io->dc->writeback_percent)
 		bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
 
 	bio->bi_iter.bi_size	= KEY_SIZE(&w->key) << 9;
-	bio->bi_max_vecs	= DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS);
 	bio->bi_private		= w;
-	bio->bi_io_vec		= bio->bi_inline_vecs;
 	bch_bio_map(bio, NULL);
 }
 
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 125aedc3875f..5b13e7e7c8aa 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -611,9 +611,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 	char *ptr;
 	int len;
 
-	bio_init(&b->bio);
-	b->bio.bi_io_vec = b->bio_vec;
-	b->bio.bi_max_vecs = DM_BUFIO_INLINE_VECS;
+	bio_init_with_vec_table(&b->bio, b->bio_vec, DM_BUFIO_INLINE_VECS);
 	b->bio.bi_iter.bi_sector = block << b->c->sectors_per_block_bits;
 	b->bio.bi_bdev = b->c->bdev;
 	b->bio.bi_end_io = inline_endio;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 92ac251e91e6..eae7b4cf34d4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2004,13 +2004,8 @@ static struct stripe_head *alloc_stripe(struct kmem_cache *sc, gfp_t gfp,
 		for (i = 0; i < disks; i++) {
 			struct r5dev *dev = &sh->dev[i];
 
-			bio_init(&dev->req);
-			dev->req.bi_io_vec = &dev->vec;
-			dev->req.bi_max_vecs = 1;
-
-			bio_init(&dev->rreq);
-			dev->rreq.bi_io_vec = &dev->rvec;
-			dev->rreq.bi_max_vecs = 1;
+			bio_init_with_vec_table(&dev->req, &dev->vec, 1);
+			bio_init_with_vec_table(&dev->rreq, &dev->rvec, 1);
 		}
 	}
 	return sh;
diff --git a/drivers/nvme/target/io-cmd.c b/drivers/nvme/target/io-cmd.c
index 4a96c2049b7b..6a32b0b68b1e 100644
--- a/drivers/nvme/target/io-cmd.c
+++ b/drivers/nvme/target/io-cmd.c
@@ -37,9 +37,7 @@ static void nvmet_inline_bio_init(struct nvmet_req *req)
 {
 	struct bio *bio = &req->inline_bio;
 
-	bio_init(bio);
-	bio->bi_max_vecs = NVMET_MAX_INLINE_BIOVEC;
-	bio->bi_io_vec = req->inline_bvec;
+	bio_init_with_vec_table(bio, req->inline_bvec, NVMET_MAX_INLINE_BIOVEC);
 }
 
 static void nvmet_execute_rw(struct nvmet_req *req)
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index a8329cc47dec..2bf53b0ffe83 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -19,9 +19,7 @@ static int sync_request(struct page *page, struct block_device *bdev, int op)
 	struct bio bio;
 	struct bio_vec bio_vec;
 
-	bio_init(&bio);
-	bio.bi_max_vecs = 1;
-	bio.bi_io_vec = &bio_vec;
+	bio_init_with_vec_table(&bio, &bio_vec, 1);
 	bio_vec.bv_page = page;
 	bio_vec.bv_len = PAGE_SIZE;
 	bio_vec.bv_offset = 0;
-- 
2.7.4

