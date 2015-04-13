From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 5/7] md: use block_device name vsprintf helper
Date: Mon, 13 Apr 2015 16:31:38 +0400
Message-ID: <1428928300-9132-6-git-send-email-dmonakhov@openvz.org>
References: <1428928300-9132-1-git-send-email-dmonakhov@openvz.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1428928300-9132-1-git-send-email-dmonakhov@openvz.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, Dmitry Monakhov <dmonakhov@openvz.org>, viro@zeniv.linux.org.uk
List-Id: dm-devel.ids


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 drivers/md/bcache/debug.c    |    6 +-
 drivers/md/bcache/io.c       |    8 +--
 drivers/md/bcache/super.c    |   32 ++++------
 drivers/md/dm-cache-target.c |    5 +-
 drivers/md/dm-table.c        |   32 ++++-----
 drivers/md/dm-thin.c         |    8 +--
 drivers/md/linear.c          |    5 +-
 drivers/md/md.c              |  141 ++++++++++++++++--------------------------
 drivers/md/multipath.c       |   29 +++-----
 drivers/md/raid0.c           |   33 ++++------
 drivers/md/raid1.c           |   37 ++++-------
 drivers/md/raid10.c          |   64 +++++++------------
 drivers/md/raid5.c           |   37 +++++------
 13 files changed, 171 insertions(+), 266 deletions(-)

diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 8b1f1d5..fb61f55 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -104,7 +104,6 @@ void bch_btree_verify(struct btree *b)
 
 void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 {
-	char name[BDEVNAME_SIZE];
 	struct bio *check;
 	struct bio_vec bv, *bv2;
 	struct bvec_iter iter;
@@ -127,9 +126,8 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 					p2 + bv.bv_offset,
 					bv.bv_len),
 				 dc->disk.c,
-				 "verify failed at dev %s sector %llu",
-				 bdevname(dc->bdev, name),
-				 (uint64_t) bio->bi_iter.bi_sector);
+				 "verify failed at dev %pg sector %llu",
+				 dc->bdev, (uint64_t) bio->bi_iter.bi_sector);
 
 		kunmap_atomic(p1);
 	}
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index fa028fa..7e21113 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -188,18 +188,16 @@ void bch_count_io_errors(struct cache *ca, int error, const char *m)
 	}
 
 	if (error) {
-		char buf[BDEVNAME_SIZE];
 		unsigned errors = atomic_add_return(1 << IO_ERROR_SHIFT,
 						    &ca->io_errors);
 		errors >>= IO_ERROR_SHIFT;
 
 		if (errors < ca->set->error_limit)
-			pr_err("%s: IO error on %s, recovering",
-			       bdevname(ca->bdev, buf), m);
+			pr_err("%pg: IO error on %s, recovering", ca->bdev , m);
 		else
 			bch_cache_set_error(ca->set,
-					    "%s: too many IO errors %s",
-					    bdevname(ca->bdev, buf), m);
+					    "%pg: too many IO errors %s",
+					    ca->bdev, m);
 	}
 }
 
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 4dd2bb7..b15b7db 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -907,7 +907,6 @@ void bch_cached_dev_run(struct cached_dev *dc)
 static void cached_dev_detach_finish(struct work_struct *w)
 {
 	struct cached_dev *dc = container_of(w, struct cached_dev, detach);
-	char buf[BDEVNAME_SIZE];
 	struct closure cl;
 	closure_init_stack(&cl);
 
@@ -930,7 +929,7 @@ static void cached_dev_detach_finish(struct work_struct *w)
 
 	mutex_unlock(&bch_register_lock);
 
-	pr_info("Caching disabled for %s", bdevname(dc->bdev, buf));
+	pr_info("Caching disabled for %pg", dc->bdev);
 
 	/* Drop ref we took in cached_dev_detach() */
 	closure_put(&dc->disk.cl);
@@ -960,27 +959,24 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 {
 	uint32_t rtime = cpu_to_le32(get_seconds());
 	struct uuid_entry *u;
-	char buf[BDEVNAME_SIZE];
-
-	bdevname(dc->bdev, buf);
 
 	if (memcmp(dc->sb.set_uuid, c->sb.set_uuid, 16))
 		return -ENOENT;
 
 	if (dc->disk.c) {
-		pr_err("Can't attach %s: already attached", buf);
+		pr_err("Can't attach %pg: already attached", dc->bdev);
 		return -EINVAL;
 	}
 
 	if (test_bit(CACHE_SET_STOPPING, &c->flags)) {
-		pr_err("Can't attach %s: shutting down", buf);
+		pr_err("Can't attach %pg: shutting down", dc->bdev);
 		return -EINVAL;
 	}
 
 	if (dc->sb.block_size < c->sb.block_size) {
 		/* Will die */
-		pr_err("Couldn't attach %s: block size less than set's block size",
-		       buf);
+		pr_err("Couldn't attach %pg: block size less than set's block size",
+		       dc->bdev);
 		return -EINVAL;
 	}
 
@@ -996,13 +992,13 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 
 	if (!u) {
 		if (BDEV_STATE(&dc->sb) == BDEV_STATE_DIRTY) {
-			pr_err("Couldn't find uuid for %s in set", buf);
+			pr_err("Couldn't find uuid for %pg in set", dc->bdev);
 			return -ENOENT;
 		}
 
 		u = uuid_find_empty(c);
 		if (!u) {
-			pr_err("Not caching %s, no room for UUID", buf);
+			pr_err("Not caching %pg, no room for UUID", dc->bdev);
 			return -EINVAL;
 		}
 	}
@@ -1054,8 +1050,8 @@ int bch_cached_dev_attach(struct cached_dev *dc, struct cache_set *c)
 	bch_cached_dev_run(dc);
 	bcache_device_link(&dc->disk, c, "bdev");
 
-	pr_info("Caching %s as %s on set %pU",
-		bdevname(dc->bdev, buf), dc->disk.disk->disk_name,
+	pr_info("Caching %pg as %s on set %pU",
+		dc->bdev, dc->disk.disk->disk_name,
 		dc->disk.c->sb.set_uuid);
 	return 0;
 }
@@ -1161,7 +1157,6 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 				 struct block_device *bdev,
 				 struct cached_dev *dc)
 {
-	char name[BDEVNAME_SIZE];
 	const char *err = "cannot allocate memory";
 	struct cache_set *c;
 
@@ -1185,7 +1180,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	if (bch_cache_accounting_add_kobjs(&dc->accounting, &dc->disk.kobj))
 		goto err;
 
-	pr_info("registered backing device %s", bdevname(bdev, name));
+	pr_info("registered backing device %pg", bdev);
 
 	list_add(&dc->list, &uncached_devices);
 	list_for_each_entry(c, &bch_cache_sets, list)
@@ -1197,7 +1192,7 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 
 	return;
 err:
-	pr_notice("error opening %s: %s", bdevname(bdev, name), err);
+	pr_notice("error opening %pg: %s", bdev, err);
 	bcache_device_stop(&dc->disk);
 }
 
@@ -1860,7 +1855,6 @@ static int cache_alloc(struct cache_sb *sb, struct cache *ca)
 static void register_cache(struct cache_sb *sb, struct page *sb_page,
 				struct block_device *bdev, struct cache *ca)
 {
-	char name[BDEVNAME_SIZE];
 	const char *err = "cannot allocate memory";
 
 	memcpy(&ca->sb, sb, sizeof(struct cache_sb));
@@ -1890,12 +1884,12 @@ static void register_cache(struct cache_sb *sb, struct page *sb_page,
 	if (err)
 		goto err;
 
-	pr_info("registered cache device %s", bdevname(bdev, name));
+	pr_info("registered cache device %pg", bdev);
 out:
 	kobject_put(&ca->kobj);
 	return;
 err:
-	pr_notice("error opening %s: %s", bdevname(bdev, name), err);
+	pr_notice("error opening %pg: %s", bdev, err);
 	goto out;
 }
 
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 7755af3..f31cfdf 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2027,7 +2027,6 @@ static int parse_metadata_dev(struct cache_args *ca, struct dm_arg_set *as,
 {
 	int r;
 	sector_t metadata_dev_size;
-	char b[BDEVNAME_SIZE];
 
 	if (!at_least_one_arg(as, error))
 		return -EINVAL;
@@ -2041,8 +2040,8 @@ static int parse_metadata_dev(struct cache_args *ca, struct dm_arg_set *as,
 
 	metadata_dev_size = get_dev_size(ca->metadata_dev);
 	if (metadata_dev_size > DM_CACHE_METADATA_MAX_SECTORS_WARNING)
-		DMWARN("Metadata device %s is larger than %u sectors: excess space will not be used.",
-		       bdevname(ca->metadata_dev->bdev, b), THIN_METADATA_MAX_SECTORS);
+		DMWARN("Metadata device %pg is larger than %u sectors: excess space will not be used.",
+		       ca->metadata_dev->bdev, THIN_METADATA_MAX_SECTORS);
 
 	return 0;
 }
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 6554d91..8c1e279 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -282,7 +282,6 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
 	unsigned short logical_block_size_sectors =
 		limits->logical_block_size >> SECTOR_SHIFT;
-	char b[BDEVNAME_SIZE];
 
 	/*
 	 * Some devices exist without request functions,
@@ -291,9 +290,9 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	 */
 	q = bdev_get_queue(bdev);
 	if (!q || !q->make_request_fn) {
-		DMWARN("%s: %s is not yet initialised: "
+		DMWARN("%s: %pg is not yet initialised: "
 		       "start=%llu, len=%llu, dev_size=%llu",
-		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       dm_device_name(ti->table->md), bdev,
 		       (unsigned long long)start,
 		       (unsigned long long)len,
 		       (unsigned long long)dev_size);
@@ -304,9 +303,9 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		return 0;
 
 	if ((start >= dev_size) || (start + len > dev_size)) {
-		DMWARN("%s: %s too small for target: "
+		DMWARN("%s: %pg too small for target: "
 		       "start=%llu, len=%llu, dev_size=%llu",
-		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       dm_device_name(ti->table->md), bdev,
 		       (unsigned long long)start,
 		       (unsigned long long)len,
 		       (unsigned long long)dev_size);
@@ -318,19 +317,19 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 
 	if (start & (logical_block_size_sectors - 1)) {
 		DMWARN("%s: start=%llu not aligned to h/w "
-		       "logical block size %u of %s",
+		       "logical block size %u of %pg",
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)start,
-		       limits->logical_block_size, bdevname(bdev, b));
+		       limits->logical_block_size, bdev);
 		return 1;
 	}
 
 	if (len & (logical_block_size_sectors - 1)) {
 		DMWARN("%s: len=%llu not aligned to h/w "
-		       "logical block size %u of %s",
+		       "logical block size %u of %pg",
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)len,
-		       limits->logical_block_size, bdevname(bdev, b));
+		       limits->logical_block_size, bdev);
 		return 1;
 	}
 
@@ -425,19 +424,18 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
-	char b[BDEVNAME_SIZE];
 
 	if (unlikely(!q)) {
-		DMWARN("%s: Cannot set limits for nonexistent device %s",
-		       dm_device_name(ti->table->md), bdevname(bdev, b));
+		DMWARN("%s: Cannot set limits for nonexistent device %pg",
+		       dm_device_name(ti->table->md), bdev);
 		return 0;
 	}
 
 	if (bdev_stack_limits(limits, bdev, start) < 0)
-		DMWARN("%s: adding target device %s caused an alignment inconsistency: "
+		DMWARN("%s: adding target device %pg caused an alignment inconsistency: "
 		       "physical_block_size=%u, logical_block_size=%u, "
 		       "alignment_offset=%u, start=%llu",
-		       dm_device_name(ti->table->md), bdevname(bdev, b),
+		       dm_device_name(ti->table->md), bdev,
 		       q->limits.physical_block_size,
 		       q->limits.logical_block_size,
 		       q->limits.alignment_offset,
@@ -1660,14 +1658,12 @@ int dm_table_any_congested(struct dm_table *t, int bdi_bits)
 
 	list_for_each_entry(dd, devices, list) {
 		struct request_queue *q = bdev_get_queue(dd->dm_dev->bdev);
-		char b[BDEVNAME_SIZE];
 
 		if (likely(q))
 			r |= bdi_congested(&q->backing_dev_info, bdi_bits);
 		else
-			DMWARN_LIMIT("%s: any_congested: nonexistent device %s",
-				     dm_device_name(t->md),
-				     bdevname(dd->dm_dev->bdev, b));
+			DMWARN_LIMIT("%s: any_congested: nonexistent device %pg",
+				     dm_device_name(t->md), dd->dm_dev->bdev);
 	}
 
 	list_for_each_entry(cb, &t->target_callbacks, list)
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 921aafd..c15e1c1 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2427,7 +2427,6 @@ static void disable_passdown_if_not_supported(struct pool_c *pt)
 	struct queue_limits *data_limits = &bdev_get_queue(data_bdev)->limits;
 	sector_t block_size = pool->sectors_per_block << SECTOR_SHIFT;
 	const char *reason = NULL;
-	char buf[BDEVNAME_SIZE];
 
 	if (!pt->adjusted_pf.discard_passdown)
 		return;
@@ -2445,7 +2444,7 @@ static void disable_passdown_if_not_supported(struct pool_c *pt)
 		reason = "discard granularity not a factor of block size";
 
 	if (reason) {
-		DMWARN("Data device (%s) %s: Disabling discard passdown.", bdevname(data_bdev, buf), reason);
+		DMWARN("Data device (%pg) %s: Disabling discard passdown.", data_bdev, reason);
 		pt->adjusted_pf.discard_passdown = false;
 	}
 }
@@ -2770,11 +2769,10 @@ static sector_t get_dev_size(struct block_device *bdev)
 static void warn_if_metadata_device_too_big(struct block_device *bdev)
 {
 	sector_t metadata_dev_size = get_dev_size(bdev);
-	char buffer[BDEVNAME_SIZE];
 
 	if (metadata_dev_size > THIN_METADATA_MAX_SECTORS_WARNING)
-		DMWARN("Metadata device %s is larger than %u sectors: excess space will not be used.",
-		       bdevname(bdev, buffer), THIN_METADATA_MAX_SECTORS);
+		DMWARN("Metadata device %pg is larger than %u sectors: excess space will not be used.",
+		       bdev, THIN_METADATA_MAX_SECTORS);
 }
 
 static sector_t get_metadata_dev_size(struct block_device *bdev)
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index fa7d577..48425d6 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -258,7 +258,6 @@ static void linear_free(struct mddev *mddev, void *priv)
 
 static void linear_make_request(struct mddev *mddev, struct bio *bio)
 {
-	char b[BDEVNAME_SIZE];
 	struct dev_info *tmp_dev;
 	struct bio *split;
 	sector_t start_sector, end_sector, data_offset;
@@ -306,10 +305,10 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 out_of_bounds:
 	printk(KERN_ERR
 	       "md/linear:%s: make_request: Sector %llu out of bounds on "
-	       "dev %s: %llu sectors, offset %llu\n",
+	       "dev %pg: %llu sectors, offset %llu\n",
 	       mdname(mddev),
 	       (unsigned long long)bio->bi_iter.bi_sector,
-	       bdevname(tmp_dev->rdev->bdev, b),
+	       tmp_dev->rdev->bdev,
 	       (unsigned long long)tmp_dev->rdev->sectors,
 	       (unsigned long long)start_sector);
 	bio_io_error(bio);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 717daad..fd7aa19 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -788,8 +788,6 @@ EXPORT_SYMBOL_GPL(sync_page_io);
 
 static int read_disk_sb(struct md_rdev *rdev, int size)
 {
-	char b[BDEVNAME_SIZE];
-
 	if (rdev->sb_loaded)
 		return 0;
 
@@ -799,8 +797,8 @@ static int read_disk_sb(struct md_rdev *rdev, int size)
 	return 0;
 
 fail:
-	printk(KERN_WARNING "md: disabled device %s, could not read superblock.\n",
-		bdevname(rdev->bdev,b));
+	printk(KERN_WARNING "md: disabled device %pg, could not read superblock.\n",
+		rdev->bdev);
 	return -EINVAL;
 }
 
@@ -947,7 +945,6 @@ EXPORT_SYMBOL(md_check_no_bitmap);
  */
 static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_version)
 {
-	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	mdp_super_t *sb;
 	int ret;
 
@@ -964,21 +961,20 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 
 	ret = -EINVAL;
 
-	bdevname(rdev->bdev, b);
 	sb = page_address(rdev->sb_page);
 
 	if (sb->md_magic != MD_SB_MAGIC) {
-		printk(KERN_ERR "md: invalid raid superblock magic on %s\n",
-		       b);
+		printk(KERN_ERR "md: invalid raid superblock magic on %pg\n",
+		       rdev->bdev);
 		goto abort;
 	}
 
 	if (sb->major_version != 0 ||
 	    sb->minor_version < 90 ||
 	    sb->minor_version > 91) {
-		printk(KERN_WARNING "Bad version number %d.%d on %s\n",
+		printk(KERN_WARNING "Bad version number %d.%d on %pg\n",
 			sb->major_version, sb->minor_version,
-			b);
+			rdev->bdev);
 		goto abort;
 	}
 
@@ -986,8 +982,8 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		goto abort;
 
 	if (md_csum_fold(calc_sb_csum(sb)) != md_csum_fold(sb->sb_csum)) {
-		printk(KERN_WARNING "md: invalid superblock checksum on %s\n",
-			b);
+		printk(KERN_WARNING "md: invalid superblock checksum on %pg\n",
+			rdev->bdev);
 		goto abort;
 	}
 
@@ -1008,14 +1004,14 @@ static int super_90_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor
 		__u64 ev1, ev2;
 		mdp_super_t *refsb = page_address(refdev->sb_page);
 		if (!uuid_equal(refsb, sb)) {
-			printk(KERN_WARNING "md: %s has different UUID to %s\n",
-				b, bdevname(refdev->bdev,b2));
+			printk(KERN_WARNING "md: %pg has different UUID to %pg\n",
+				rdev->bdev, refdev->bdev);
 			goto abort;
 		}
 		if (!sb_equal(refsb, sb)) {
-			printk(KERN_WARNING "md: %s has same UUID"
-			       " but different superblock to %s\n",
-			       b, bdevname(refdev->bdev, b2));
+			printk(KERN_WARNING "md: %pg has same UUID"
+			       " but different superblock to %pg\n",
+			       rdev->bdev, refdev->bdev);
 			goto abort;
 		}
 		ev1 = md_event(sb);
@@ -1373,7 +1369,6 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 	int ret;
 	sector_t sb_start;
 	sector_t sectors;
-	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	int bmask;
 
 	/*
@@ -1417,13 +1412,11 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		return -EINVAL;
 
 	if (calc_sb_1_csum(sb) != sb->sb_csum) {
-		printk("md: invalid superblock checksum on %s\n",
-			bdevname(rdev->bdev,b));
+		printk("md: invalid superblock checksum on %pg\n", rdev->bdev);
 		return -EINVAL;
 	}
 	if (le64_to_cpu(sb->data_size) < 10) {
-		printk("md: data_size too small on %s\n",
-		       bdevname(rdev->bdev,b));
+		printk("md: data_size too small on %pg\n", rdev->bdev);
 		return -EINVAL;
 	}
 	if (sb->pad0 ||
@@ -1508,10 +1501,9 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 		    sb->level != refsb->level ||
 		    sb->layout != refsb->layout ||
 		    sb->chunksize != refsb->chunksize) {
-			printk(KERN_WARNING "md: %s has strangely different"
-				" superblock to %s\n",
-				bdevname(rdev->bdev,b),
-				bdevname(refdev->bdev,b2));
+			printk(KERN_WARNING "md: %pg has strangely different"
+				" superblock to %pg\n",
+				rdev->bdev, refdev->bdev);
 			return -EINVAL;
 		}
 		ev1 = le64_to_cpu(sb->events);
@@ -2096,11 +2088,9 @@ static void md_delayed_delete(struct work_struct *ws)
 
 static void unbind_rdev_from_array(struct md_rdev *rdev)
 {
-	char b[BDEVNAME_SIZE];
-
 	bd_unlink_disk_holder(rdev->bdev, rdev->mddev->gendisk);
 	list_del_rcu(&rdev->same_set);
-	printk(KERN_INFO "md: unbind<%s>\n", bdevname(rdev->bdev,b));
+	printk(KERN_INFO "md: unbind<%pg>\n", rdev->bdev);
 	rdev->mddev = NULL;
 	sysfs_remove_link(&rdev->kobj, "block");
 	sysfs_put(rdev->sysfs_state);
@@ -2149,10 +2139,8 @@ void md_autodetect_dev(dev_t dev);
 
 static void export_rdev(struct md_rdev *rdev)
 {
-	char b[BDEVNAME_SIZE];
 
-	printk(KERN_INFO "md: export_rdev(%s)\n",
-		bdevname(rdev->bdev,b));
+	printk(KERN_INFO "md: export_rdev(%pg)\n", rdev->bdev);
 	md_rdev_clear(rdev);
 #ifndef MODULE
 	if (test_bit(AutoDetected, &rdev->flags))
@@ -2310,8 +2298,6 @@ repeat:
 
 	bitmap_update_sb(mddev->bitmap);
 	rdev_for_each(rdev, mddev) {
-		char b[BDEVNAME_SIZE];
-
 		if (rdev->sb_loaded != 1)
 			continue; /* no noise on spare devices */
 
@@ -2319,8 +2305,8 @@ repeat:
 			md_super_write(mddev,rdev,
 				       rdev->sb_start, rdev->sb_size,
 				       rdev->sb_page);
-			pr_debug("md: (write) %s's sb offset: %llu\n",
-				 bdevname(rdev->bdev, b),
+			pr_debug("md: (write) %pg's sb offset: %llu\n",
+				 rdev->bdev,
 				 (unsigned long long)rdev->sb_start);
 			rdev->sb_events = mddev->events;
 			if (rdev->badblocks.size) {
@@ -2332,8 +2318,7 @@ repeat:
 			}
 
 		} else
-			pr_debug("md: %s (skipping faulty)\n",
-				 bdevname(rdev->bdev, b));
+			pr_debug("md: %pg (skipping faulty)\n", rdev->bdev);
 
 		if (mddev->level == LEVEL_MULTIPATH)
 			/* only need to write one superblock... */
@@ -3037,7 +3022,6 @@ EXPORT_SYMBOL_GPL(md_rdev_init);
  */
 static struct md_rdev *md_import_device(dev_t newdev, int super_format, int super_minor)
 {
-	char b[BDEVNAME_SIZE];
 	int err;
 	struct md_rdev *rdev;
 	sector_t size;
@@ -3064,8 +3048,8 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 	size = i_size_read(rdev->bdev->bd_inode) >> BLOCK_SIZE_BITS;
 	if (!size) {
 		printk(KERN_WARNING
-			"md: %s has zero or unknown size, marking faulty!\n",
-			bdevname(rdev->bdev,b));
+			"md: %pg has zero or unknown size, marking faulty!\n",
+			rdev->bdev);
 		err = -EINVAL;
 		goto abort_free;
 	}
@@ -3075,16 +3059,15 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
 			load_super(rdev, NULL, super_minor);
 		if (err == -EINVAL) {
 			printk(KERN_WARNING
-				"md: %s does not have a valid v%d.%d "
+				"md: %pg does not have a valid v%d.%d "
 			       "superblock, not importing!\n",
-				bdevname(rdev->bdev,b),
-			       super_format, super_minor);
+				rdev->bdev, super_format, super_minor);
 			goto abort_free;
 		}
 		if (err < 0) {
 			printk(KERN_WARNING
-				"md: could not read %s's sb, not importing!\n",
-				bdevname(rdev->bdev,b));
+				"md: could not read %pg's sb, not importing!\n",
+				rdev->bdev);
 			goto abort_free;
 		}
 	}
@@ -3107,7 +3090,6 @@ static void analyze_sbs(struct mddev *mddev)
 {
 	int i;
 	struct md_rdev *rdev, *freshest, *tmp;
-	char b[BDEVNAME_SIZE];
 
 	freshest = NULL;
 	rdev_for_each_safe(rdev, tmp, mddev)
@@ -3120,9 +3102,8 @@ static void analyze_sbs(struct mddev *mddev)
 			break;
 		default:
 			printk( KERN_ERR \
-				"md: fatal superblock inconsistency in %s"
-				" -- removing from array\n",
-				bdevname(rdev->bdev,b));
+				"md: fatal superblock inconsistency in %pg"
+				" -- removing from array\n", rdev->bdev);
 			kick_rdev_from_array(rdev);
 		}
 
@@ -3135,8 +3116,8 @@ static void analyze_sbs(struct mddev *mddev)
 		    (rdev->desc_nr >= mddev->max_disks ||
 		     i > mddev->max_disks)) {
 			printk(KERN_WARNING
-			       "md: %s: %s: only %d devices permitted\n",
-			       mdname(mddev), bdevname(rdev->bdev, b),
+			       "md: %s: %pg: only %d devices permitted\n",
+			       mdname(mddev), rdev->bdev,
 			       mddev->max_disks);
 			kick_rdev_from_array(rdev);
 			continue;
@@ -3144,9 +3125,8 @@ static void analyze_sbs(struct mddev *mddev)
 		if (rdev != freshest)
 			if (super_types[mddev->major_version].
 			    validate_super(mddev, rdev)) {
-				printk(KERN_WARNING "md: kicking non-fresh %s"
-					" from array!\n",
-					bdevname(rdev->bdev,b));
+				printk(KERN_WARNING "md: kicking non-fresh %pg"
+					" from array!\n", rdev->bdev);
 				kick_rdev_from_array(rdev);
 				continue;
 			}
@@ -5024,7 +5004,6 @@ int md_run(struct mddev *mddev)
 		/* Warn if this is a potentially silly
 		 * configuration.
 		 */
-		char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 		struct md_rdev *rdev2;
 		int warned = 0;
 
@@ -5034,12 +5013,11 @@ int md_run(struct mddev *mddev)
 				    rdev->bdev->bd_contains ==
 				    rdev2->bdev->bd_contains) {
 					printk(KERN_WARNING
-					       "%s: WARNING: %s appears to be"
+					       "%s: WARNING: %pg appears to be"
 					       " on the same physical disk as"
-					       " %s.\n",
+					       " %pg.\n",
 					       mdname(mddev),
-					       bdevname(rdev->bdev,b),
-					       bdevname(rdev2->bdev,b2));
+					       rdev->bdev,rdev2->bdev);
 					warned = 1;
 				}
 			}
@@ -5469,8 +5447,7 @@ static void autorun_array(struct mddev *mddev)
 	printk(KERN_INFO "md: running: ");
 
 	rdev_for_each(rdev, mddev) {
-		char b[BDEVNAME_SIZE];
-		printk("<%s>", bdevname(rdev->bdev,b));
+		printk("<%pg>", rdev->bdev);
 	}
 	printk("\n");
 
@@ -5497,7 +5474,6 @@ static void autorun_devices(int part)
 {
 	struct md_rdev *rdev0, *rdev, *tmp;
 	struct mddev *mddev;
-	char b[BDEVNAME_SIZE];
 
 	printk(KERN_INFO "md: autorun ...\n");
 	while (!list_empty(&pending_raid_disks)) {
@@ -5507,13 +5483,12 @@ static void autorun_devices(int part)
 		rdev0 = list_entry(pending_raid_disks.next,
 					 struct md_rdev, same_set);
 
-		printk(KERN_INFO "md: considering %s ...\n",
-			bdevname(rdev0->bdev,b));
+		printk(KERN_INFO "md: considering %pg ...\n", rdev0->bdev);
 		INIT_LIST_HEAD(&candidates);
 		rdev_for_each_list(rdev, tmp, &pending_raid_disks)
 			if (super_90_load(rdev, rdev0, 0) >= 0) {
-				printk(KERN_INFO "md:  adding %s ...\n",
-					bdevname(rdev->bdev,b));
+				printk(KERN_INFO "md:  adding %pg ...\n",
+				       rdev->bdev);
 				list_move(&rdev->same_set, &candidates);
 			}
 		/*
@@ -5530,8 +5505,8 @@ static void autorun_devices(int part)
 			unit = MINOR(dev);
 		}
 		if (rdev0->preferred_minor != unit) {
-			printk(KERN_INFO "md: unit number in %s is bad: %d\n",
-			       bdevname(rdev0->bdev, b), rdev0->preferred_minor);
+			printk(KERN_INFO "md: unit number in %pg is bad: %d\n",
+			       rdev0->bdev, rdev0->preferred_minor);
 			break;
 		}
 
@@ -5550,8 +5525,8 @@ static void autorun_devices(int part)
 		else if (mddev->raid_disks || mddev->major_version
 			 || !list_empty(&mddev->disks)) {
 			printk(KERN_WARNING
-				"md: %s already running, cannot run %s\n",
-				mdname(mddev), bdevname(rdev0->bdev,b));
+				"md: %s already running, cannot run %pg\n",
+				mdname(mddev), rdev0->bdev);
 			mddev_unlock(mddev);
 		} else {
 			printk(KERN_INFO "md: created %s\n", mdname(mddev));
@@ -5716,7 +5691,6 @@ static int get_disk_info(struct mddev *mddev, void __user * arg)
 
 static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 {
-	char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
 	dev_t dev = MKDEV(info->major,info->minor);
 
@@ -5741,9 +5715,8 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 				.load_super(rdev, rdev0, mddev->minor_version);
 			if (err < 0) {
 				printk(KERN_WARNING
-					"md: %s has different UUID to %s\n",
-					bdevname(rdev->bdev,b),
-					bdevname(rdev0->bdev,b2));
+					"md: %pg has different UUID to %pg\n",
+					rdev->bdev, rdev0->bdev);
 				export_rdev(rdev);
 				return -EINVAL;
 			}
@@ -5884,7 +5857,6 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
 
 static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 {
-	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
 
 	rdev = find_rdev(mddev, dev);
@@ -5903,14 +5875,13 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 
 	return 0;
 busy:
-	printk(KERN_WARNING "md: cannot remove active disk %s from %s ...\n",
-		bdevname(rdev->bdev,b), mdname(mddev));
+	printk(KERN_WARNING "md: cannot remove active disk %pg from %s ...\n",
+		rdev->bdev, mdname(mddev));
 	return -EBUSY;
 }
 
 static int hot_add_disk(struct mddev *mddev, dev_t dev)
 {
-	char b[BDEVNAME_SIZE];
 	int err;
 	struct md_rdev *rdev;
 
@@ -5947,8 +5918,8 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 
 	if (test_bit(Faulty, &rdev->flags)) {
 		printk(KERN_WARNING
-			"md: can not hot-add faulty %s disk to %s!\n",
-			bdevname(rdev->bdev,b), mdname(mddev));
+			"md: can not hot-add faulty %pg disk to %s!\n",
+			rdev->bdev, mdname(mddev));
 		err = -EINVAL;
 		goto abort_export;
 	}
@@ -6905,10 +6876,8 @@ static void status_unused(struct seq_file *seq)
 	seq_printf(seq, "unused devices: ");
 
 	list_for_each_entry(rdev, &pending_raid_disks, same_set) {
-		char b[BDEVNAME_SIZE];
 		i++;
-		seq_printf(seq, "%s ",
-			      bdevname(rdev->bdev,b));
+		seq_printf(seq, "%pg ", rdev->bdev);
 	}
 	if (!i)
 		seq_printf(seq, "<none>");
@@ -7102,9 +7071,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
 		sectors = 0;
 		rcu_read_lock();
 		rdev_for_each_rcu(rdev, mddev) {
-			char b[BDEVNAME_SIZE];
-			seq_printf(seq, " %s[%d]",
-				bdevname(rdev->bdev,b), rdev->desc_nr);
+			seq_printf(seq, " %pg[%d]", rdev->bdev, rdev->desc_nr);
 			if (test_bit(WriteMostly, &rdev->flags))
 				seq_printf(seq, "(W)");
 			if (test_bit(Faulty, &rdev->flags)) {
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index ac3ede2..ae2eec2 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -94,11 +94,9 @@ static void multipath_end_request(struct bio *bio, int error)
 		/*
 		 * oops, IO error:
 		 */
-		char b[BDEVNAME_SIZE];
 		md_error (mp_bh->mddev, rdev);
-		printk(KERN_ERR "multipath: %s: rescheduling sector %llu\n",
-		       bdevname(rdev->bdev,b),
-		       (unsigned long long)bio->bi_iter.bi_sector);
+		printk(KERN_ERR "multipath: %pg: rescheduling sector %llu\n",
+		       rdev->bdev, (unsigned long long)bio->bi_iter.bi_sector);
 		multipath_reschedule_retry(mp_bh);
 	} else
 		multipath_end_bh_io(mp_bh, error);
@@ -181,7 +179,6 @@ static int multipath_congested(struct mddev *mddev, int bits)
 static void multipath_error (struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct mpconf *conf = mddev->private;
-	char b[BDEVNAME_SIZE];
 
 	if (conf->raid_disks - mddev->degraded <= 1) {
 		/*
@@ -205,12 +202,11 @@ static void multipath_error (struct mddev *mddev, struct md_rdev *rdev)
 	}
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
-	printk(KERN_ALERT "multipath: IO failure on %s,"
+	printk(KERN_ALERT "multipath: IO failure on %pg,"
 	       " disabling IO path.\n"
 	       "multipath: Operation continuing"
 	       " on %d IO paths.\n",
-	       bdevname(rdev->bdev, b),
-	       conf->raid_disks - mddev->degraded);
+	       rdev->bdev,  conf->raid_disks - mddev->degraded);
 }
 
 static void print_multipath_conf (struct mpconf *conf)
@@ -227,12 +223,11 @@ static void print_multipath_conf (struct mpconf *conf)
 			 conf->raid_disks);
 
 	for (i = 0; i < conf->raid_disks; i++) {
-		char b[BDEVNAME_SIZE];
 		tmp = conf->multipaths + i;
 		if (tmp->rdev)
-			printk(" disk%d, o:%d, dev:%s\n",
-				i,!test_bit(Faulty, &tmp->rdev->flags),
-			       bdevname(tmp->rdev->bdev,b));
+			printk(" disk%d, o:%d, dev:%pg\n",
+			       i,!test_bit(Faulty, &tmp->rdev->flags),
+			       tmp->rdev->bdev);
 	}
 }
 
@@ -337,7 +332,6 @@ static void multipathd(struct md_thread *thread)
 
 	md_check_recovery(mddev);
 	for (;;) {
-		char b[BDEVNAME_SIZE];
 		spin_lock_irqsave(&conf->device_lock, flags);
 		if (list_empty(head))
 			break;
@@ -349,15 +343,14 @@ static void multipathd(struct md_thread *thread)
 		bio->bi_iter.bi_sector = mp_bh->master_bio->bi_iter.bi_sector;
 
 		if ((mp_bh->path = multipath_map (conf))<0) {
-			printk(KERN_ALERT "multipath: %s: unrecoverable IO read"
+			printk(KERN_ALERT "multipath: %pg: unrecoverable IO read"
 				" error for block %llu\n",
-				bdevname(bio->bi_bdev,b),
+				bio->bi_bdev,
 				(unsigned long long)bio->bi_iter.bi_sector);
 			multipath_end_bh_io(mp_bh, -EIO);
 		} else {
-			printk(KERN_ERR "multipath: %s: redirecting sector %llu"
-				" to another IO path\n",
-				bdevname(bio->bi_bdev,b),
+			printk(KERN_ERR "multipath: %pg: redirecting sector %llu"
+				" to another IO path\n", bio->bi_bdev,
 				(unsigned long long)bio->bi_iter.bi_sector);
 			*bio = *(mp_bh->master_bio);
 			bio->bi_iter.bi_sector +=
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 3ed9f42..e954f01 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -48,18 +48,17 @@ static void dump_zones(struct mddev *mddev)
 	int j, k;
 	sector_t zone_size = 0;
 	sector_t zone_start = 0;
-	char b[BDEVNAME_SIZE];
 	struct r0conf *conf = mddev->private;
 	int raid_disks = conf->strip_zone[0].nb_dev;
+
 	printk(KERN_INFO "md: RAID0 configuration for %s - %d zone%s\n",
 	       mdname(mddev),
 	       conf->nr_strip_zones, conf->nr_strip_zones==1?"":"s");
 	for (j = 0; j < conf->nr_strip_zones; j++) {
 		printk(KERN_INFO "md: zone%d=[", j);
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			printk(KERN_CONT "%s%s", k?"/":"",
-			bdevname(conf->devlist[j*raid_disks
-						+ k]->bdev, b));
+			printk(KERN_CONT "%s%pg", k?"/":"",
+			       (conf->devlist[j*raid_disks + k]->bdev));
 		printk(KERN_CONT "]\n");
 
 		zone_size  = conf->strip_zone[j].zone_end - zone_start;
@@ -80,17 +79,14 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	struct md_rdev *smallest, *rdev1, *rdev2, *rdev, **dev;
 	struct strip_zone *zone;
 	int cnt;
-	char b[BDEVNAME_SIZE];
-	char b2[BDEVNAME_SIZE];
 	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
 	bool discard_supported = false;
 
 	if (!conf)
 		return -ENOMEM;
 	rdev_for_each(rdev1, mddev) {
-		pr_debug("md/raid0:%s: looking at %s\n",
-			 mdname(mddev),
-			 bdevname(rdev1->bdev, b));
+		pr_debug("md/raid0:%s: looking at %pg\n",
+			 mdname(mddev), rdev1->bdev);
 		c = 0;
 
 		/* round size to chunk_size */
@@ -99,12 +95,11 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		rdev1->sectors = sectors * mddev->chunk_sectors;
 
 		rdev_for_each(rdev2, mddev) {
-			pr_debug("md/raid0:%s:   comparing %s(%llu)"
-				 " with %s(%llu)\n",
-				 mdname(mddev),
-				 bdevname(rdev1->bdev,b),
+			pr_debug("md/raid0:%s:   comparing %pg(%llu)"
+				 " with %pg(%llu)\n",
+				 mdname(mddev), rdev1->bdev,
 				 (unsigned long long)rdev1->sectors,
-				 bdevname(rdev2->bdev,b2),
+				 rdev2->bdev,
 				 (unsigned long long)rdev2->sectors);
 			if (rdev2 == rdev1) {
 				pr_debug("md/raid0:%s:   END\n",
@@ -227,15 +222,13 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 		for (j=0; j<cnt; j++) {
 			rdev = conf->devlist[j];
 			if (rdev->sectors <= zone->dev_start) {
-				pr_debug("md/raid0:%s: checking %s ... nope\n",
-					 mdname(mddev),
-					 bdevname(rdev->bdev, b));
+				pr_debug("md/raid0:%s: checking %pg ... nope\n",
+					 mdname(mddev), rdev->bdev);
 				continue;
 			}
-			pr_debug("md/raid0:%s: checking %s ..."
+			pr_debug("md/raid0:%s: checking %pg ..."
 				 " contained as device %d\n",
-				 mdname(mddev),
-				 bdevname(rdev->bdev, b), c);
+				 mdname(mddev),rdev->bdev, c);
 			dev[c] = rdev;
 			c++;
 			if (!smallest || rdev->sectors < smallest->sectors) {
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d34e238..1927ef5 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -348,13 +348,11 @@ static void raid1_end_read_request(struct bio *bio, int error)
 		/*
 		 * oops, read error:
 		 */
-		char b[BDEVNAME_SIZE];
 		printk_ratelimited(
-			KERN_ERR "md/raid1:%s: %s: "
+			KERN_ERR "md/raid1:%s: %pg: "
 			"rescheduling sector %llu\n",
 			mdname(conf->mddev),
-			bdevname(conf->mirrors[mirror].rdev->bdev,
-				 b),
+			conf->mirrors[mirror].rdev->bdev,
 			(unsigned long long)r1_bio->sector);
 		set_bit(R1BIO_ReadError, &r1_bio->state);
 		reschedule_retry(r1_bio);
@@ -1462,7 +1460,6 @@ static void status(struct seq_file *seq, struct mddev *mddev)
 
 static void error(struct mddev *mddev, struct md_rdev *rdev)
 {
-	char b[BDEVNAME_SIZE];
 	struct r1conf *conf = mddev->private;
 
 	/*
@@ -1497,9 +1494,9 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	printk(KERN_ALERT
-	       "md/raid1:%s: Disk failure on %s, disabling device.\n"
+	       "md/raid1:%s: Disk failure on %pg, disabling device.\n"
 	       "md/raid1:%s: Operation continuing on %d devices.\n",
-	       mdname(mddev), bdevname(rdev->bdev, b),
+	       mdname(mddev), rdev->bdev,
 	       mdname(mddev), conf->raid_disks - mddev->degraded);
 }
 
@@ -1517,13 +1514,12 @@ static void print_conf(struct r1conf *conf)
 
 	rcu_read_lock();
 	for (i = 0; i < conf->raid_disks; i++) {
-		char b[BDEVNAME_SIZE];
 		struct md_rdev *rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev)
-			printk(KERN_DEBUG " disk %d, wo:%d, o:%d, dev:%s\n",
+			printk(KERN_DEBUG " disk %d, wo:%d, o:%d, dev:%pg\n",
 			       i, !test_bit(In_sync, &rdev->flags),
 			       !test_bit(Faulty, &rdev->flags),
-			       bdevname(rdev->bdev,b));
+			       rdev->bdev);
 	}
 	rcu_read_unlock();
 }
@@ -1861,17 +1857,15 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 		} while (!success && d != r1_bio->read_disk);
 
 		if (!success) {
-			char b[BDEVNAME_SIZE];
 			int abort = 0;
 			/* Cannot read from anywhere, this block is lost.
 			 * Record a bad block on each device.  If that doesn't
 			 * work just disable and interrupt the recovery.
 			 * Don't fail devices as that won't really help.
 			 */
-			printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O read error"
+			printk(KERN_ALERT "md/raid1:%s: %pg: unrecoverable I/O read error"
 			       " for block %llu\n",
-			       mdname(mddev),
-			       bdevname(bio->bi_bdev, b),
+			       mdname(mddev), bio->bi_bdev,
 			       (unsigned long long)r1_bio->sector);
 			for (d = 0; d < conf->raid_disks * 2; d++) {
 				rdev = conf->mirrors[d].rdev;
@@ -2146,7 +2140,6 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 		}
 		d = start;
 		while (d != read_disk) {
-			char b[BDEVNAME_SIZE];
 			if (d==0)
 				d = conf->raid_disks * 2;
 			d--;
@@ -2158,11 +2151,11 @@ static void fix_read_error(struct r1conf *conf, int read_disk,
 					atomic_add(s, &rdev->corrected_errors);
 					printk(KERN_INFO
 					       "md/raid1:%s: read error corrected "
-					       "(%d sectors at %llu on %s)\n",
+					       "(%d sectors at %llu on %pg)\n",
 					       mdname(mddev), s,
 					       (unsigned long long)(sect +
 					           rdev->data_offset),
-					       bdevname(rdev->bdev, b));
+					       rdev->bdev);
 				}
 			}
 		}
@@ -2306,7 +2299,6 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	int max_sectors;
 	struct mddev *mddev = conf->mddev;
 	struct bio *bio;
-	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev;
 
 	clear_bit(R1BIO_ReadError, &r1_bio->state);
@@ -2328,13 +2320,12 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	rdev_dec_pending(conf->mirrors[r1_bio->read_disk].rdev, conf->mddev);
 
 	bio = r1_bio->bios[r1_bio->read_disk];
-	bdevname(bio->bi_bdev, b);
 read_more:
 	disk = read_balance(conf, r1_bio, &max_sectors);
 	if (disk == -1) {
-		printk(KERN_ALERT "md/raid1:%s: %s: unrecoverable I/O"
+		printk(KERN_ALERT "md/raid1:%s: %pg: unrecoverable I/O"
 		       " read error for block %llu\n",
-		       mdname(mddev), b, (unsigned long long)r1_bio->sector);
+		       mdname(mddev), bio->bi_bdev, (unsigned long long)r1_bio->sector);
 		raid_end_bio_io(r1_bio);
 	} else {
 		const unsigned long do_sync
@@ -2352,10 +2343,10 @@ read_more:
 		rdev = conf->mirrors[disk].rdev;
 		printk_ratelimited(KERN_ERR
 				   "md/raid1:%s: redirecting sector %llu"
-				   " to other mirror: %s\n",
+				   " to other mirror: %pg\n",
 				   mdname(mddev),
 				   (unsigned long long)r1_bio->sector,
-				   bdevname(rdev->bdev, b));
+				   rdev->bdev);
 		bio->bi_iter.bi_sector = r1_bio->sector + rdev->data_offset;
 		bio->bi_bdev = rdev->bdev;
 		bio->bi_end_io = raid1_end_read_request;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a7196c4..f37779d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -402,11 +402,9 @@ static void raid10_end_read_request(struct bio *bio, int error)
 		/*
 		 * oops, read error - keep the refcount on the rdev
 		 */
-		char b[BDEVNAME_SIZE];
 		printk_ratelimited(KERN_ERR
-				   "md/raid10:%s: %s: rescheduling sector %llu\n",
-				   mdname(conf->mddev),
-				   bdevname(rdev->bdev, b),
+				   "md/raid10:%s: %pg: rescheduling sector %llu\n",
+				   mdname(conf->mddev), rdev->bdev,
 				   (unsigned long long)r10_bio->sector);
 		set_bit(R10BIO_ReadError, &r10_bio->state);
 		reschedule_retry(r10_bio);
@@ -1653,7 +1651,6 @@ static int enough(struct r10conf *conf, int ignore)
 
 static void error(struct mddev *mddev, struct md_rdev *rdev)
 {
-	char b[BDEVNAME_SIZE];
 	struct r10conf *conf = mddev->private;
 	unsigned long flags;
 
@@ -1683,9 +1680,9 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 	printk(KERN_ALERT
-	       "md/raid10:%s: Disk failure on %s, disabling device.\n"
+	       "md/raid10:%s: Disk failure on %pg, disabling device.\n"
 	       "md/raid10:%s: Operation continuing on %d devices.\n",
-	       mdname(mddev), bdevname(rdev->bdev, b),
+	       mdname(mddev), rdev->bdev,
 	       mdname(mddev), conf->geo.raid_disks - mddev->degraded);
 }
 
@@ -1703,13 +1700,12 @@ static void print_conf(struct r10conf *conf)
 		conf->geo.raid_disks);
 
 	for (i = 0; i < conf->geo.raid_disks; i++) {
-		char b[BDEVNAME_SIZE];
 		tmp = conf->mirrors + i;
 		if (tmp->rdev)
-			printk(KERN_DEBUG " disk %d, wo:%d, o:%d, dev:%s\n",
+			printk(KERN_DEBUG " disk %d, wo:%d, o:%d, dev:%pg\n",
 				i, !test_bit(In_sync, &tmp->rdev->flags),
 			        !test_bit(Faulty, &tmp->rdev->flags),
-				bdevname(tmp->rdev->bdev,b));
+				tmp->rdev->bdev);
 	}
 }
 
@@ -2371,17 +2367,14 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 	check_decay_read_errors(mddev, rdev);
 	atomic_inc(&rdev->read_errors);
 	if (atomic_read(&rdev->read_errors) > max_read_errors) {
-		char b[BDEVNAME_SIZE];
-		bdevname(rdev->bdev, b);
-
 		printk(KERN_NOTICE
-		       "md/raid10:%s: %s: Raid device exceeded "
+		       "md/raid10:%s: %pg: Raid device exceeded "
 		       "read_error threshold [cur %d:max %d]\n",
-		       mdname(mddev), b,
+		       mdname(mddev), rdev->bdev,
 		       atomic_read(&rdev->read_errors), max_read_errors);
 		printk(KERN_NOTICE
-		       "md/raid10:%s: %s: Failing raid device\n",
-		       mdname(mddev), b);
+		       "md/raid10:%s: %pg: Failing raid device\n",
+		       mdname(mddev), rdev->bdev);
 		md_error(mddev, conf->mirrors[d].rdev);
 		r10_bio->devs[r10_bio->read_slot].bio = IO_BLOCKED;
 		return;
@@ -2450,8 +2443,6 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 		/* write it back and re-read */
 		rcu_read_lock();
 		while (sl != r10_bio->read_slot) {
-			char b[BDEVNAME_SIZE];
-
 			if (sl==0)
 				sl = conf->copies;
 			sl--;
@@ -2473,25 +2464,22 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 				printk(KERN_NOTICE
 				       "md/raid10:%s: read correction "
 				       "write failed"
-				       " (%d sectors at %llu on %s)\n",
+				       " (%d sectors at %llu on %pg)\n",
 				       mdname(mddev), s,
 				       (unsigned long long)(
 					       sect +
 					       choose_data_offset(r10_bio,
 								  rdev)),
-				       bdevname(rdev->bdev, b));
-				printk(KERN_NOTICE "md/raid10:%s: %s: failing "
+				       rdev->bdev);
+				printk(KERN_NOTICE "md/raid10:%s: %pg: failing "
 				       "drive\n",
-				       mdname(mddev),
-				       bdevname(rdev->bdev, b));
+				       mdname(mddev), rdev->bdev);
 			}
 			rdev_dec_pending(rdev, mddev);
 			rcu_read_lock();
 		}
 		sl = start;
 		while (sl != r10_bio->read_slot) {
-			char b[BDEVNAME_SIZE];
-
 			if (sl==0)
 				sl = conf->copies;
 			sl--;
@@ -2513,26 +2501,25 @@ static void fix_read_error(struct r10conf *conf, struct mddev *mddev, struct r10
 				printk(KERN_NOTICE
 				       "md/raid10:%s: unable to read back "
 				       "corrected sectors"
-				       " (%d sectors at %llu on %s)\n",
+				       " (%d sectors at %llu on %pg)\n",
 				       mdname(mddev), s,
 				       (unsigned long long)(
 					       sect +
 					       choose_data_offset(r10_bio, rdev)),
-				       bdevname(rdev->bdev, b));
-				printk(KERN_NOTICE "md/raid10:%s: %s: failing "
+				       rdev->bdev);
+				printk(KERN_NOTICE "md/raid10:%s: %pg: failing "
 				       "drive\n",
-				       mdname(mddev),
-				       bdevname(rdev->bdev, b));
+				       mdname(mddev), rdev->bdev);
 				break;
 			case 1:
 				printk(KERN_INFO
 				       "md/raid10:%s: read error corrected"
-				       " (%d sectors at %llu on %s)\n",
+				       " (%d sectors at %llu on %pg)\n",
 				       mdname(mddev), s,
 				       (unsigned long long)(
 					       sect +
 					       choose_data_offset(r10_bio, rdev)),
-				       bdevname(rdev->bdev, b));
+				       rdev->bdev);
 				atomic_add(s, &rdev->corrected_errors);
 			}
 
@@ -2610,7 +2597,6 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	struct bio *bio;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev = r10_bio->devs[slot].rdev;
-	char b[BDEVNAME_SIZE];
 	unsigned long do_sync;
 	int max_sectors;
 
@@ -2623,7 +2609,6 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	 * frozen.
 	 */
 	bio = r10_bio->devs[slot].bio;
-	bdevname(bio->bi_bdev, b);
 	bio_put(bio);
 	r10_bio->devs[slot].bio = NULL;
 
@@ -2639,9 +2624,9 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 read_more:
 	rdev = read_balance(conf, r10_bio, &max_sectors);
 	if (rdev == NULL) {
-		printk(KERN_ALERT "md/raid10:%s: %s: unrecoverable I/O"
+		printk(KERN_ALERT "md/raid10:%s: %pg: unrecoverable I/O"
 		       " read error for block %llu\n",
-		       mdname(mddev), b,
+		       mdname(mddev), bio->bi_bdev,
 		       (unsigned long long)r10_bio->sector);
 		raid_end_bio_io(r10_bio);
 		return;
@@ -2651,10 +2636,9 @@ read_more:
 	slot = r10_bio->read_slot;
 	printk_ratelimited(
 		KERN_ERR
-		"md/raid10:%s: %s: redirecting "
+		"md/raid10:%s: %pg: redirecting "
 		"sector %llu to another mirror\n",
-		mdname(mddev),
-		bdevname(rdev->bdev, b),
+		mdname(mddev), rdev->bdev,
 		(unsigned long long)r10_bio->sector);
 	bio = bio_clone_mddev(r10_bio->master_bio,
 			      GFP_NOIO, mddev);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index cd2f96b..6a5f777 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1971,7 +1971,6 @@ static void raid5_end_read_request(struct bio * bi, int error)
 	struct r5conf *conf = sh->raid_conf;
 	int disks = sh->disks, i;
 	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
-	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev = NULL;
 	sector_t s;
 
@@ -2010,10 +2009,10 @@ static void raid5_end_read_request(struct bio * bi, int error)
 			printk_ratelimited(
 				KERN_INFO
 				"md/raid:%s: read error corrected"
-				" (%lu sectors at %llu on %s)\n",
+				" (%lu sectors at %llu on %pg)\n",
 				mdname(conf->mddev), STRIPE_SECTORS,
 				(unsigned long long)s,
-				bdevname(rdev->bdev, b));
+				rdev->bdev);
 			atomic_add(STRIPE_SECTORS, &rdev->corrected_errors);
 			clear_bit(R5_ReadError, &sh->dev[i].flags);
 			clear_bit(R5_ReWrite, &sh->dev[i].flags);
@@ -2023,7 +2022,6 @@ static void raid5_end_read_request(struct bio * bi, int error)
 		if (atomic_read(&rdev->read_errors))
 			atomic_set(&rdev->read_errors, 0);
 	} else {
-		const char *bdn = bdevname(rdev->bdev, b);
 		int retry = 0;
 		int set_bad = 0;
 
@@ -2033,34 +2031,34 @@ static void raid5_end_read_request(struct bio * bi, int error)
 			printk_ratelimited(
 				KERN_WARNING
 				"md/raid:%s: read error on replacement device "
-				"(sector %llu on %s).\n",
+				"(sector %llu on %pg).\n",
 				mdname(conf->mddev),
 				(unsigned long long)s,
-				bdn);
+				rdev->bdev);
 		else if (conf->mddev->degraded >= conf->max_degraded) {
 			set_bad = 1;
 			printk_ratelimited(
 				KERN_WARNING
 				"md/raid:%s: read error not correctable "
-				"(sector %llu on %s).\n",
+				"(sector %llu on %pg).\n",
 				mdname(conf->mddev),
 				(unsigned long long)s,
-				bdn);
+				rdev->bdev);
 		} else if (test_bit(R5_ReWrite, &sh->dev[i].flags)) {
 			/* Oh, no!!! */
 			set_bad = 1;
 			printk_ratelimited(
 				KERN_WARNING
 				"md/raid:%s: read error NOT corrected!! "
-				"(sector %llu on %s).\n",
+				"(sector %llu on %pg).\n",
 				mdname(conf->mddev),
 				(unsigned long long)s,
-				bdn);
+				rdev->bdev);
 		} else if (atomic_read(&rdev->read_errors)
 			 > conf->max_nr_stripes)
 			printk(KERN_WARNING
-			       "md/raid:%s: Too many read errors, failing device %s.\n",
-			       mdname(conf->mddev), bdn);
+			       "md/raid:%s: Too many read errors, failing device %pg.\n",
+			       mdname(conf->mddev), rdev->bdev);
 		else
 			retry = 1;
 		if (set_bad && test_bit(In_sync, &rdev->flags)
@@ -2182,7 +2180,6 @@ static void raid5_build_block(struct stripe_head *sh, int i, int previous)
 
 static void error(struct mddev *mddev, struct md_rdev *rdev)
 {
-	char b[BDEVNAME_SIZE];
 	struct r5conf *conf = mddev->private;
 	unsigned long flags;
 	pr_debug("raid456: error called\n");
@@ -2197,10 +2194,10 @@ static void error(struct mddev *mddev, struct md_rdev *rdev)
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	printk(KERN_ALERT
-	       "md/raid:%s: Disk failure on %s, disabling device.\n"
+	       "md/raid:%s: Disk failure on %pg, disabling device.\n"
 	       "md/raid:%s: Operation continuing on %d devices.\n",
 	       mdname(mddev),
-	       bdevname(rdev->bdev, b),
+	       rdev->bdev,
 	       mdname(mddev),
 	       conf->raid_disks - mddev->degraded);
 }
@@ -5930,10 +5927,9 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		}
 
 		if (test_bit(In_sync, &rdev->flags)) {
-			char b[BDEVNAME_SIZE];
-			printk(KERN_INFO "md/raid:%s: device %s operational as raid"
+			printk(KERN_INFO "md/raid:%s: device %pg operational as raid"
 			       " disk %d\n",
-			       mdname(mddev), bdevname(rdev->bdev, b), raid_disk);
+			       mdname(mddev), rdev->bdev, raid_disk);
 		} else if (rdev->saved_raid_disk != raid_disk)
 			/* Cannot rely on bitmap to complete recovery */
 			conf->fullsync = 1;
@@ -6387,12 +6383,11 @@ static void print_raid5_conf (struct r5conf *conf)
 	       conf->raid_disks - conf->mddev->degraded);
 
 	for (i = 0; i < conf->raid_disks; i++) {
-		char b[BDEVNAME_SIZE];
 		tmp = conf->disks + i;
 		if (tmp->rdev)
-			printk(KERN_DEBUG " disk %d, o:%d, dev:%s\n",
+			printk(KERN_DEBUG " disk %d, o:%d, dev:%pg\n",
 			       i, !test_bit(Faulty, &tmp->rdev->flags),
-			       bdevname(tmp->rdev->bdev, b));
+			       tmp->rdev->bdev);
 	}
 }
 
-- 
1.7.1
