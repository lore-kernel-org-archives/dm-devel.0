From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 01/12] block: bio: pass bvec table to bio_init()
Date: Fri, 11 Nov 2016 20:05:29 +0800
Message-ID: <1478865957-25252-2-git-send-email-tom.leiming@gmail.com>
References: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1478865957-25252-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@kernel.dk>, Jiri Kosina <jikos@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "maintainer:DEVICE-MAPPER LVM" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, Joern Engel <joern@logfs.org>, Prasad Joshi <prasadjoshi.linux@gmail.com>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>, Eric Wheeler <git@linux.ewheeler.net>
List-Id: dm-devel.ids

Some drivers often use external bvec table, so introduce
this helper for this case. It is always safe to access the
bio->bi_io_vec in this way for this case.

After converting to this usage, it will becomes a bit easier
to evaluate the remaining direct access to bio->bi_io_vec,
so it can help to prepare for the following multipage bvec
support.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 block/bio.c                   |  8 ++++++--
 drivers/block/floppy.c        |  3 +--
 drivers/md/bcache/io.c        |  4 +---
 drivers/md/bcache/journal.c   |  4 +---
 drivers/md/bcache/movinggc.c  |  6 ++----
 drivers/md/bcache/request.c   |  2 +-
 drivers/md/bcache/super.c     | 12 +++---------
 drivers/md/bcache/writeback.c |  5 ++---
 drivers/md/dm-bufio.c         |  4 +---
 drivers/md/dm.c               |  2 +-
 drivers/md/multipath.c        |  2 +-
 drivers/md/raid5-cache.c      |  2 +-
 drivers/md/raid5.c            |  9 ++-------
 drivers/nvme/target/io-cmd.c  |  4 +---
 fs/logfs/dev_bdev.c           |  4 +---
 include/linux/bio.h           |  3 ++-
 16 files changed, 27 insertions(+), 47 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 2cf6ebabc68c..de257ced69b1 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -270,11 +270,15 @@ static void bio_free(struct bio *bio)
 	}
 }
 
-void bio_init(struct bio *bio)
+void bio_init(struct bio *bio, struct bio_vec *table,
+	      unsigned short max_vecs)
 {
 	memset(bio, 0, sizeof(*bio));
 	atomic_set(&bio->__bi_remaining, 1);
 	atomic_set(&bio->__bi_cnt, 1);
+
+	bio->bi_io_vec = table;
+	bio->bi_max_vecs = max_vecs;
 }
 EXPORT_SYMBOL(bio_init);
 
@@ -480,7 +484,7 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		return NULL;
 
 	bio = p + front_pad;
-	bio_init(bio);
+	bio_init(bio, NULL, 0);
 
 	if (nr_iovecs > inline_vecs) {
 		unsigned long idx = 0;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index e3d8e4ced4a2..6a3ff2b2e3ae 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3806,8 +3806,7 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 
 	cbdata.drive = drive;
 
-	bio_init(&bio);
-	bio.bi_io_vec = &bio_vec;
+	bio_init(&bio, &bio_vec, 1);
 	bio_vec.bv_page = page;
 	bio_vec.bv_len = size;
 	bio_vec.bv_offset = 0;
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index e97b0acf7b8d..db45a88c0ce9 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -24,9 +24,7 @@ struct bio *bch_bbio_alloc(struct cache_set *c)
 	struct bbio *b = mempool_alloc(c->bio_meta, GFP_NOIO);
 	struct bio *bio = &b->bio;
 
-	bio_init(bio);
-	bio->bi_max_vecs	 = bucket_pages(c);
-	bio->bi_io_vec		 = bio->bi_inline_vecs;
+	bio_init(bio, bio->bi_inline_vecs, bucket_pages(c));
 
 	return bio;
 }
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 6925023e12d4..1198e53d5670 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -448,13 +448,11 @@ static void do_journal_discard(struct cache *ca)
 
 		atomic_set(&ja->discard_in_flight, DISCARD_IN_FLIGHT);
 
-		bio_init(bio);
+		bio_init(bio, bio->bi_inline_vecs, 1);
 		bio_set_op_attrs(bio, REQ_OP_DISCARD, 0);
 		bio->bi_iter.bi_sector	= bucket_to_sector(ca->set,
 						ca->sb.d[ja->discard_idx]);
 		bio->bi_bdev		= ca->bdev;
-		bio->bi_max_vecs	= 1;
-		bio->bi_io_vec		= bio->bi_inline_vecs;
 		bio->bi_iter.bi_size	= bucket_bytes(ca);
 		bio->bi_end_io		= journal_discard_endio;
 
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 5c4bddecfaf0..13b8a907006d 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -77,15 +77,13 @@ static void moving_init(struct moving_io *io)
 {
 	struct bio *bio = &io->bio.bio;
 
-	bio_init(bio);
+	bio_init(bio, bio->bi_inline_vecs,
+		 DIV_ROUND_UP(KEY_SIZE(&io->w->key), PAGE_SECTORS));
 	bio_get(bio);
 	bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
 
 	bio->bi_iter.bi_size	= KEY_SIZE(&io->w->key) << 9;
-	bio->bi_max_vecs	= DIV_ROUND_UP(KEY_SIZE(&io->w->key),
-					       PAGE_SECTORS);
 	bio->bi_private		= &io->cl;
-	bio->bi_io_vec		= bio->bi_inline_vecs;
 	bch_bio_map(bio, NULL);
 }
 
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 0d99b5f4b3e6..f49c5417527d 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -623,7 +623,7 @@ static void do_bio_hook(struct search *s, struct bio *orig_bio)
 {
 	struct bio *bio = &s->bio.bio;
 
-	bio_init(bio);
+	bio_init(bio, NULL, 0);
 	__bio_clone_fast(bio, orig_bio);
 	bio->bi_end_io		= request_endio;
 	bio->bi_private		= &s->cl;
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 988edf928466..2fb5bfeb43e2 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1152,9 +1152,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	dc->bdev = bdev;
 	dc->bdev->bd_holder = dc;
 
-	bio_init(&dc->sb_bio);
-	dc->sb_bio.bi_max_vecs	= 1;
-	dc->sb_bio.bi_io_vec	= dc->sb_bio.bi_inline_vecs;
+	bio_init(&dc->sb_bio, dc->sb_bio.bi_inline_vecs, 1);
 	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;
 	get_page(sb_page);
 
@@ -1814,9 +1812,7 @@ static int cache_alloc(struct cache *ca)
 	__module_get(THIS_MODULE);
 	kobject_init(&ca->kobj, &bch_cache_ktype);
 
-	bio_init(&ca->journal.bio);
-	ca->journal.bio.bi_max_vecs = 8;
-	ca->journal.bio.bi_io_vec = ca->journal.bio.bi_inline_vecs;
+	bio_init(&ca->journal.bio, ca->journal.bio.bi_inline_vecs, 8);
 
 	free = roundup_pow_of_two(ca->sb.nbuckets) >> 10;
 
@@ -1852,9 +1848,7 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	ca->bdev = bdev;
 	ca->bdev->bd_holder = ca;
 
-	bio_init(&ca->sb_bio);
-	ca->sb_bio.bi_max_vecs	= 1;
-	ca->sb_bio.bi_io_vec	= ca->sb_bio.bi_inline_vecs;
+	bio_init(&ca->sb_bio, ca->sb_bio.bi_inline_vecs, 1);
 	ca->sb_bio.bi_io_vec[0].bv_page = sb_page;
 	get_page(sb_page);
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index e51644e503a5..69e1ae59cab8 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -106,14 +106,13 @@ static void dirty_init(struct keybuf_key *w)
 	struct dirty_io *io = w->private;
 	struct bio *bio = &io->bio;
 
-	bio_init(bio);
+	bio_init(bio, bio->bi_inline_vecs,
+		 DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS));
 	if (!io->dc->writeback_percent)
 		bio_set_prio(bio, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_IDLE, 0));
 
 	bio->bi_iter.bi_size	= KEY_SIZE(&w->key) << 9;
-	bio->bi_max_vecs	= DIV_ROUND_UP(KEY_SIZE(&w->key), PAGE_SECTORS);
 	bio->bi_private		= w;
-	bio->bi_io_vec		= bio->bi_inline_vecs;
 	bch_bio_map(bio, NULL);
 }
 
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index b3ba142e59a4..262e75365cc0 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -611,9 +611,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 	char *ptr;
 	int len;
 
-	bio_init(&b->bio);
-	b->bio.bi_io_vec = b->bio_vec;
-	b->bio.bi_max_vecs = DM_BUFIO_INLINE_VECS;
+	bio_init(&b->bio, b->bio_vec, DM_BUFIO_INLINE_VECS);
 	b->bio.bi_iter.bi_sector = block << b->c->sectors_per_block_bits;
 	b->bio.bi_bdev = b->c->bdev;
 	b->bio.bi_end_io = inline_endio;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1b8b21aba34b..ffa97b742a68 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1525,7 +1525,7 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->bdev)
 		goto bad;
 
-	bio_init(&md->flush_bio);
+	bio_init(&md->flush_bio, NULL, 0);
 	md->flush_bio.bi_bdev = md->bdev;
 	md->flush_bio.bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
 
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 673efbd6fc47..4da06d813b8f 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -130,7 +130,7 @@ static void multipath_make_request(struct mddev *mddev, struct bio * bio)
 	}
 	multipath = conf->multipaths + mp_bh->path;
 
-	bio_init(&mp_bh->bio);
+	bio_init(&mp_bh->bio, NULL, 0);
 	__bio_clone_fast(&mp_bh->bio, bio);
 
 	mp_bh->bio.bi_iter.bi_sector += multipath->rdev->data_offset;
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 2bca090cd64e..8491edcfb5a6 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -1205,7 +1205,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	INIT_LIST_HEAD(&log->io_end_ios);
 	INIT_LIST_HEAD(&log->flushing_ios);
 	INIT_LIST_HEAD(&log->finished_ios);
-	bio_init(&log->flush_bio);
+	bio_init(&log->flush_bio, NULL, 0);
 
 	log->io_kc = KMEM_CACHE(r5l_io_unit, 0);
 	if (!log->io_kc)
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 70acdd379e44..5f9e28443c8a 100644
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
+			bio_init(&dev->req, &dev->vec, 1);
+			bio_init(&dev->rreq, &dev->rvec, 1);
 		}
 	}
 	return sh;
diff --git a/drivers/nvme/target/io-cmd.c b/drivers/nvme/target/io-cmd.c
index c2784cfc5e29..c58b67e61092 100644
--- a/drivers/nvme/target/io-cmd.c
+++ b/drivers/nvme/target/io-cmd.c
@@ -37,9 +37,7 @@ static void nvmet_inline_bio_init(struct nvmet_req *req)
 {
 	struct bio *bio = &req->inline_bio;
 
-	bio_init(bio);
-	bio->bi_max_vecs = NVMET_MAX_INLINE_BIOVEC;
-	bio->bi_io_vec = req->inline_bvec;
+	bio_init(bio, req->inline_bvec, NVMET_MAX_INLINE_BIOVEC);
 }
 
 static void nvmet_execute_rw(struct nvmet_req *req)
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index a8329cc47dec..dc8cafeee038 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -19,9 +19,7 @@ static int sync_request(struct page *page, struct block_device *bdev, int op)
 	struct bio bio;
 	struct bio_vec bio_vec;
 
-	bio_init(&bio);
-	bio.bi_max_vecs = 1;
-	bio.bi_io_vec = &bio_vec;
+	bio_init(&bio, &bio_vec, 1);
 	bio_vec.bv_page = page;
 	bio_vec.bv_len = PAGE_SIZE;
 	bio_vec.bv_offset = 0;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d367cd37a7f7..70a7244f08a7 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -420,7 +420,8 @@ extern int bio_phys_segments(struct request_queue *, struct bio *);
 extern int submit_bio_wait(struct bio *bio);
 extern void bio_advance(struct bio *, unsigned);
 
-extern void bio_init(struct bio *);
+extern void bio_init(struct bio *bio, struct bio_vec *table,
+		     unsigned short max_vecs);
 extern void bio_reset(struct bio *);
 void bio_chain(struct bio *, struct bio *);
 
-- 
2.7.4
