From: NeilBrown <neilb@suse.com>
Subject: [PATCH 3/5] blk: make the bioset rescue_workqueue optional.
Date: Fri, 10 Mar 2017 17:00:47 +1100
Message-ID: <148912564728.4002.2778999158838279841.stgit@noble>
References: <148912539296.4002.219258660543808741.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <148912539296.4002.219258660543808741.stgit@noble>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, Pavel Machek <pavel@ucw.cz>, Jack Wang <jinpu.wang@profitbricks.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Kent Overstreet <kent.overstreet@gmail.com>
List-Id: dm-devel.ids

This patch converts bioset_create() and bioset_create_nobvec()
to not create a workqueue so alloctions will never trigger
punt_bios_to_rescuer().
It also introduces bioset_create_rescued() and bioset_create_nobvec_rescued()
which preserve the old behaviour.

*All* callers of bioset_create() and bioset_create_nobvec() are
converted to the _rescued() version, so that no change in behaviour
is experienced.

It is hoped that most, if not all, biosets can end up being the
non-rescued version.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 block/bio.c                         |   30 +++++++++++++++++++++++++-----
 block/blk-core.c                    |    2 +-
 drivers/block/drbd/drbd_main.c      |    2 +-
 drivers/md/bcache/super.c           |    4 ++--
 drivers/md/dm-crypt.c               |    2 +-
 drivers/md/dm-io.c                  |    2 +-
 drivers/md/dm.c                     |    5 +++--
 drivers/md/md.c                     |    2 +-
 drivers/md/raid5-cache.c            |    2 +-
 drivers/target/target_core_iblock.c |    2 +-
 fs/block_dev.c                      |    2 +-
 fs/btrfs/extent_io.c                |    4 ++--
 fs/xfs/xfs_super.c                  |    2 +-
 include/linux/bio.h                 |    2 ++
 14 files changed, 43 insertions(+), 20 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index e75878f8b14a..3790c3f376b6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -362,6 +362,8 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
 	struct bio_list punt, nopunt;
 	struct bio *bio;
 
+	if (!WARN_ON_ONCE(!bs->rescue_workqueue))
+		return;
 	/*
 	 * In order to guarantee forward progress we must punt only bios that
 	 * were allocated from this bio_set; otherwise, if there was a bio on
@@ -472,7 +474,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
 		if (current->bio_list &&
 		    (!bio_list_empty(&current->bio_list[0]) ||
-		     !bio_list_empty(&current->bio_list[1])))
+		     !bio_list_empty(&current->bio_list[1])) &&
+		    bs->rescue_workqueue)
 			gfp_mask &= ~__GFP_DIRECT_RECLAIM;
 
 		p = mempool_alloc(bs->bio_pool, gfp_mask);
@@ -1941,7 +1944,8 @@ EXPORT_SYMBOL(bioset_free);
 
 static struct bio_set *__bioset_create(unsigned int pool_size,
 				       unsigned int front_pad,
-				       bool create_bvec_pool)
+				       bool create_bvec_pool,
+				       bool create_rescue_workqueue)
 {
 	unsigned int back_pad = BIO_INLINE_VECS * sizeof(struct bio_vec);
 	struct bio_set *bs;
@@ -1972,6 +1976,9 @@ static struct bio_set *__bioset_create(unsigned int pool_size,
 			goto bad;
 	}
 
+	if (!create_rescue_workqueue)
+		return bs;
+
 	bs->rescue_workqueue = alloc_workqueue("bioset", WQ_MEM_RECLAIM, 0);
 	if (!bs->rescue_workqueue)
 		goto bad;
@@ -1997,10 +2004,16 @@ static struct bio_set *__bioset_create(unsigned int pool_size,
  */
 struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 {
-	return __bioset_create(pool_size, front_pad, true);
+	return __bioset_create(pool_size, front_pad, true, false);
 }
 EXPORT_SYMBOL(bioset_create);
 
+struct bio_set *bioset_create_rescued(unsigned int pool_size, unsigned int front_pad)
+{
+	return __bioset_create(pool_size, front_pad, true, true);
+}
+EXPORT_SYMBOL(bioset_create_rescued);
+
 /**
  * bioset_create_nobvec  - Create a bio_set without bio_vec mempool
  * @pool_size:	Number of bio to cache in the mempool
@@ -2012,10 +2025,17 @@ EXPORT_SYMBOL(bioset_create);
  */
 struct bio_set *bioset_create_nobvec(unsigned int pool_size, unsigned int front_pad)
 {
-	return __bioset_create(pool_size, front_pad, false);
+	return __bioset_create(pool_size, front_pad, false, false);
 }
 EXPORT_SYMBOL(bioset_create_nobvec);
 
+struct bio_set *bioset_create_nobvec_rescued(unsigned int pool_size,
+					     unsigned int front_pad)
+{
+	return __bioset_create(pool_size, front_pad, false, true);
+}
+EXPORT_SYMBOL(bioset_create_nobvec_rescued);
+
 #ifdef CONFIG_BLK_CGROUP
 
 /**
@@ -2130,7 +2150,7 @@ static int __init init_bio(void)
 	bio_integrity_init();
 	biovec_init_slabs();
 
-	fs_bio_set = bioset_create(BIO_POOL_SIZE, 0);
+	fs_bio_set = bioset_create_rescued(BIO_POOL_SIZE, 0);
 	if (!fs_bio_set)
 		panic("bio: can't allocate bios\n");
 
diff --git a/block/blk-core.c b/block/blk-core.c
index fae7966e1f98..430c82f646eb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -712,7 +712,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (q->id < 0)
 		goto fail_q;
 
-	q->bio_split = bioset_create(BIO_POOL_SIZE, 0);
+	q->bio_split = bioset_create_rescued(BIO_POOL_SIZE, 0);
 	if (!q->bio_split)
 		goto fail_id;
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 92c60cbd04ee..2c69c2ab0fff 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2166,7 +2166,7 @@ static int drbd_create_mempools(void)
 		goto Enomem;
 
 	/* mempools */
-	drbd_md_io_bio_set = bioset_create(DRBD_MIN_POOL_PAGES, 0);
+	drbd_md_io_bio_set = bioset_create_rescued(DRBD_MIN_POOL_PAGES, 0);
 	if (drbd_md_io_bio_set == NULL)
 		goto Enomem;
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 85e3f21c2514..6cb30792f0ed 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -786,7 +786,7 @@ static int bcache_device_init(struct bcache_device *d, unsigned block_size,
 
 	minor *= BCACHE_MINORS;
 
-	if (!(d->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
+	if (!(d->bio_split = bioset_create_rescued(4, offsetof(struct bbio, bio))) ||
 	    !(d->disk = alloc_disk(BCACHE_MINORS))) {
 		ida_simple_remove(&bcache_minor, minor);
 		return -ENOMEM;
@@ -1520,7 +1520,7 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 				sizeof(struct bbio) + sizeof(struct bio_vec) *
 				bucket_pages(c))) ||
 	    !(c->fill_iter = mempool_create_kmalloc_pool(1, iter_size)) ||
-	    !(c->bio_split = bioset_create(4, offsetof(struct bbio, bio))) ||
+	    !(c->bio_split = bioset_create_rescued(4, offsetof(struct bbio, bio))) ||
 	    !(c->uuids = alloc_bucket_pages(GFP_KERNEL, c)) ||
 	    !(c->moving_gc_wq = alloc_workqueue("bcache_gc",
 						WQ_MEM_RECLAIM, 0)) ||
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 389a3637ffcc..91a2d637d44f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1936,7 +1936,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	cc->bs = bioset_create(MIN_IOS, 0);
+	cc->bs = bioset_create_rescued(MIN_IOS, 0);
 	if (!cc->bs) {
 		ti->error = "Cannot allocate crypt bioset";
 		goto bad;
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 03940bf36f6c..fe1241c196b1 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -58,7 +58,7 @@ struct dm_io_client *dm_io_client_create(void)
 	if (!client->pool)
 		goto bad;
 
-	client->bios = bioset_create(min_ios, 0);
+	client->bios = bioset_create_rescued(min_ios, 0);
 	if (!client->bios)
 		goto bad;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index dfb75979e455..41b1f033841f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1002,7 +1002,8 @@ static void flush_current_bio_list(struct blk_plug_cb *cb, bool from_schedule)
 
 		while ((bio = bio_list_pop(&list))) {
 			struct bio_set *bs = bio->bi_pool;
-			if (unlikely(!bs) || bs == fs_bio_set) {
+			if (unlikely(!bs) || bs == fs_bio_set ||
+			    !bs->rescue_workqueue) {
 				bio_list_add(&current->bio_list[i], bio);
 				continue;
 			}
@@ -2577,7 +2578,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned t
 		BUG();
 	}
 
-	pools->bs = bioset_create_nobvec(pool_size, front_pad);
+	pools->bs = bioset_create_nobvec_rescued(pool_size, front_pad);
 	if (!pools->bs)
 		goto out;
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d7d2bb51a58d..e5f08a195837 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5220,7 +5220,7 @@ int md_run(struct mddev *mddev)
 	}
 
 	if (mddev->bio_set == NULL) {
-		mddev->bio_set = bioset_create(BIO_POOL_SIZE, 0);
+		mddev->bio_set = bioset_create_rescued(BIO_POOL_SIZE, 0);
 		if (!mddev->bio_set)
 			return -ENOMEM;
 	}
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 3f307be01b10..c95c6c046395 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -2831,7 +2831,7 @@ int r5l_init_log(struct r5conf *conf, struct md_rdev *rdev)
 	if (!log->io_pool)
 		goto io_pool;
 
-	log->bs = bioset_create(R5L_POOL_SIZE, 0);
+	log->bs = bioset_create_rescued(R5L_POOL_SIZE, 0);
 	if (!log->bs)
 		goto io_bs;
 
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index d316ed537d59..5bf3392195c6 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -93,7 +93,7 @@ static int iblock_configure_device(struct se_device *dev)
 		return -EINVAL;
 	}
 
-	ib_dev->ibd_bio_set = bioset_create(IBLOCK_BIO_POOL_SIZE, 0);
+	ib_dev->ibd_bio_set = bioset_create_rescued(IBLOCK_BIO_POOL_SIZE, 0);
 	if (!ib_dev->ibd_bio_set) {
 		pr_err("IBLOCK: Unable to create bioset\n");
 		goto out;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2eca00ec4370..c0ca5f0d0369 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -436,7 +436,7 @@ blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 
 static __init int blkdev_init(void)
 {
-	blkdev_dio_pool = bioset_create(4, offsetof(struct blkdev_dio, bio));
+	blkdev_dio_pool = bioset_create_rescued(4, offsetof(struct blkdev_dio, bio));
 	if (!blkdev_dio_pool)
 		return -ENOMEM;
 	return 0;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 28e81922a21c..34aa8893790a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -173,8 +173,8 @@ int __init extent_io_init(void)
 	if (!extent_buffer_cache)
 		goto free_state_cache;
 
-	btrfs_bioset = bioset_create(BIO_POOL_SIZE,
-				     offsetof(struct btrfs_io_bio, bio));
+	btrfs_bioset = bioset_create_rescued(BIO_POOL_SIZE,
+					     offsetof(struct btrfs_io_bio, bio));
 	if (!btrfs_bioset)
 		goto free_buffer_cache;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 890862f2447c..f4c4d6f41d91 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1756,7 +1756,7 @@ MODULE_ALIAS_FS("xfs");
 STATIC int __init
 xfs_init_zones(void)
 {
-	xfs_ioend_bioset = bioset_create(4 * MAX_BUF_PER_PAGE,
+	xfs_ioend_bioset = bioset_create_rescued(4 * MAX_BUF_PER_PAGE,
 			offsetof(struct xfs_ioend, io_inline_bio));
 	if (!xfs_ioend_bioset)
 		goto out;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8e521194f6fc..05730603fcf1 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -379,7 +379,9 @@ static inline struct bio *bio_next_split(struct bio *bio, int sectors,
 }
 
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
+extern struct bio_set *bioset_create_rescued(unsigned int, unsigned int);
 extern struct bio_set *bioset_create_nobvec(unsigned int, unsigned int);
+extern struct bio_set *bioset_create_nobvec_rescued(unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
 extern mempool_t *biovec_create_pool(int pool_entries);
 
