From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 01/11] block: make generic_make_request
	handle arbitrarily sized bios
Date: Wed,  6 May 2015 23:34:11 -0700
Message-ID: <1430980461-5235-2-git-send-email-mlin@kernel.org>
References: <1430980461-5235-1-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <drbd-user-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
In-Reply-To: <1430980461-5235-1-git-send-email-mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <http://lists.linbit.com/mailman/options/drbd-user>,
	<mailto:drbd-user-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linbit.com/pipermail/drbd-user>
List-Post: <mailto:drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
List-Help: <mailto:drbd-user-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=help>
List-Subscribe: <http://lists.linbit.com/mailman/listinfo/drbd-user>,
	<mailto:drbd-user-request-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org?subject=subscribe>
Sender: drbd-user-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Errors-To: drbd-user-bounces-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>, Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>, Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Jim Paris <jim-XrPbb/hENzg@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>, drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
List-Id: dm-devel.ids

From: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The way the block layer is currently written, it goes to great lengths
to avoid having to split bios; upper layer code (such as bio_add_page())
checks what the underlying device can handle and tries to always create
bios that don't need to be split.

But this approach becomes unwieldy and eventually breaks down with
stacked devices and devices with dynamic limits, and it adds a lot of
complexity. If the block layer could split bios as needed, we could
eliminate a lot of complexity elsewhere - particularly in stacked
drivers. Code that creates bios can then create whatever size bios are
convenient, and more importantly stacked drivers don't have to deal with
both their own bio size limitations and the limitations of the
(potentially multiple) devices underneath them.  In the future this will
let us delete merge_bvec_fn and a bunch of other code.

We do this by adding calls to blk_queue_split() to the various
make_request functions that need it - a few can already handle arbitrary
size bios. Note that we add the call _after_ any call to
blk_queue_bounce(); this means that blk_queue_split() and
blk_recalc_rq_segments() don't need to be concerned with bouncing
affecting segment merging.

Some make_request_fn() callbacks were simple enough to audit and verify
they don't need blk_queue_split() calls. The skipped ones are:

 * nfhd_make_request (arch/m68k/emu/nfblock.c)
 * axon_ram_make_request (arch/powerpc/sysdev/axonram.c)
 * simdisk_make_request (arch/xtensa/platforms/iss/simdisk.c)
 * brd_make_request (ramdisk - drivers/block/brd.c)
 * mtip_submit_request (drivers/block/mtip32xx/mtip32xx.c)
 * loop_make_request
 * null_queue_bio
 * bcache's make_request fns

Some others are almost certainly safe to remove now, but will be left
for future patches.

Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>
Cc: Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Lars Ellenberg <drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org>
Cc: drbd-user-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org
Cc: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Cc: Geoff Levand <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jim Paris <jim-XrPbb/hENzg@public.gmane.org>
Cc: Joshua Morris <josh.h.morris-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: Philip Kelleher <pjk1939-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Nitin Gupta <ngupta-KNmc09w0p+Ednm+yROfE0A@public.gmane.org>
Cc: Oleg Drokin <oleg.drokin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andreas Dilger <andreas.dilger-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kent Overstreet <kent.overstreet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
[dpark: skip more mq-based drivers, resolve merge conflicts, etc.]
Signed-off-by: Dongsu Park <dpark-VwIFZPTo/vqsTnJN9+BGXg@public.gmane.org>
Signed-off-by: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-core.c                            |  19 ++--
 block/blk-merge.c                           | 159 ++++++++++++++++++++++++++--
 block/blk-mq.c                              |   2 +
 drivers/block/drbd/drbd_req.c               |   2 +
 drivers/block/pktcdvd.c                     |   6 +-
 drivers/block/ps3vram.c                     |   2 +
 drivers/block/rsxx/dev.c                    |   2 +
 drivers/block/umem.c                        |   2 +
 drivers/block/zram/zram_drv.c               |   2 +
 drivers/md/dm.c                             |   2 +
 drivers/md/md.c                             |   2 +
 drivers/s390/block/dcssblk.c                |   2 +
 drivers/s390/block/xpram.c                  |   2 +
 drivers/staging/lustre/lustre/llite/lloop.c |   2 +
 include/linux/blkdev.h                      |   3 +
 15 files changed, 187 insertions(+), 22 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index fd154b9..909f317 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -617,6 +617,10 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (q->id < 0)
 		goto fail_q;
 
+	q->bio_split = bioset_create(4, 0);
+	if (!q->bio_split)
+		goto fail_id;
+
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
@@ -626,7 +630,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 	err = bdi_init(&q->backing_dev_info);
 	if (err)
-		goto fail_id;
+		goto fail_split;
 
 	setup_timer(&q->backing_dev_info.laptop_mode_wb_timer,
 		    laptop_mode_timer_fn, (unsigned long) q);
@@ -668,6 +672,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 
 fail_bdi:
 	bdi_destroy(&q->backing_dev_info);
+fail_split:
+	bioset_free(q->bio_split);
 fail_id:
 	ida_simple_remove(&blk_queue_ida, q->id);
 fail_q:
@@ -1584,6 +1590,8 @@ void blk_queue_bio(struct request_queue *q, struct bio *bio)
 	struct request *req;
 	unsigned int request_count = 0;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	/*
 	 * low level driver can indicate that it wants pages above a
 	 * certain limit bounced to low memory (ie for highmem, or even
@@ -1807,15 +1815,6 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
-	if (likely(bio_is_rw(bio) &&
-		   nr_sectors > queue_max_hw_sectors(q))) {
-		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
-		       bdevname(bio->bi_bdev, b),
-		       bio_sectors(bio),
-		       queue_max_hw_sectors(q));
-		goto end_io;
-	}
-
 	part = bio->bi_bdev->bd_part;
 	if (should_fail_request(part, bio->bi_iter.bi_size) ||
 	    should_fail_request(&part_to_disk(part)->part0,
diff --git a/block/blk-merge.c b/block/blk-merge.c
index fd3fee8..dc14255 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -9,12 +9,158 @@
 
 #include "blk.h"
 
+static struct bio *blk_bio_discard_split(struct request_queue *q,
+					 struct bio *bio,
+					 struct bio_set *bs)
+{
+	unsigned int max_discard_sectors, granularity;
+	int alignment;
+	sector_t tmp;
+	unsigned split_sectors;
+
+	/* Zero-sector (unknown) and one-sector granularities are the same.  */
+	granularity = max(q->limits.discard_granularity >> 9, 1U);
+
+	max_discard_sectors = min(q->limits.max_discard_sectors, UINT_MAX >> 9);
+	max_discard_sectors -= max_discard_sectors % granularity;
+
+	if (unlikely(!max_discard_sectors)) {
+		/* XXX: warn */
+		return NULL;
+	}
+
+	if (bio_sectors(bio) <= max_discard_sectors)
+		return NULL;
+
+	split_sectors = max_discard_sectors;
+
+	/*
+	 * If the next starting sector would be misaligned, stop the discard at
+	 * the previous aligned sector.
+	 */
+	alignment = (q->limits.discard_alignment >> 9) % granularity;
+
+	tmp = bio->bi_iter.bi_sector + split_sectors - alignment;
+	tmp = sector_div(tmp, granularity);
+
+	if (split_sectors > tmp)
+		split_sectors -= tmp;
+
+	return bio_split(bio, split_sectors, GFP_NOIO, bs);
+}
+
+static struct bio *blk_bio_write_same_split(struct request_queue *q,
+					    struct bio *bio,
+					    struct bio_set *bs)
+{
+	if (!q->limits.max_write_same_sectors)
+		return NULL;
+
+	if (bio_sectors(bio) <= q->limits.max_write_same_sectors)
+		return NULL;
+
+	return bio_split(bio, q->limits.max_write_same_sectors, GFP_NOIO, bs);
+}
+
+static struct bio *blk_bio_segment_split(struct request_queue *q,
+					 struct bio *bio,
+					 struct bio_set *bs)
+{
+	struct bio *split;
+	struct bio_vec bv, bvprv;
+	struct bvec_iter iter;
+	unsigned seg_size = 0, nsegs = 0;
+	int prev = 0;
+
+	struct bvec_merge_data bvm = {
+		.bi_bdev	= bio->bi_bdev,
+		.bi_sector	= bio->bi_iter.bi_sector,
+		.bi_size	= 0,
+		.bi_rw		= bio->bi_rw,
+	};
+
+	bio_for_each_segment(bv, bio, iter) {
+		if (q->merge_bvec_fn &&
+		    q->merge_bvec_fn(q, &bvm, &bv) < (int) bv.bv_len)
+			goto split;
+
+		bvm.bi_size += bv.bv_len;
+
+		if (bvm.bi_size >> 9 > queue_max_sectors(q))
+			goto split;
+
+		/*
+		 * If the queue doesn't support SG gaps and adding this
+		 * offset would create a gap, disallow it.
+		 */
+		if (q->queue_flags & (1 << QUEUE_FLAG_SG_GAPS) &&
+		    prev && bvec_gap_to_prev(&bvprv, bv.bv_offset))
+			goto split;
+
+		if (prev && blk_queue_cluster(q)) {
+			if (seg_size + bv.bv_len > queue_max_segment_size(q))
+				goto new_segment;
+			if (!BIOVEC_PHYS_MERGEABLE(&bvprv, &bv))
+				goto new_segment;
+			if (!BIOVEC_SEG_BOUNDARY(q, &bvprv, &bv))
+				goto new_segment;
+
+			seg_size += bv.bv_len;
+			bvprv = bv;
+			prev = 1;
+			continue;
+		}
+new_segment:
+		if (nsegs == queue_max_segments(q))
+			goto split;
+
+		nsegs++;
+		bvprv = bv;
+		prev = 1;
+		seg_size = bv.bv_len;
+	}
+
+	return NULL;
+split:
+	split = bio_clone_bioset(bio, GFP_NOIO, bs);
+
+	split->bi_iter.bi_size -= iter.bi_size;
+	bio->bi_iter = iter;
+
+	if (bio_integrity(bio)) {
+		bio_integrity_advance(bio, split->bi_iter.bi_size);
+		bio_integrity_trim(split, 0, bio_sectors(split));
+	}
+
+	return split;
+}
+
+void blk_queue_split(struct request_queue *q, struct bio **bio,
+		     struct bio_set *bs)
+{
+	struct bio *split;
+
+	if ((*bio)->bi_rw & REQ_DISCARD)
+		split = blk_bio_discard_split(q, *bio, bs);
+	else if ((*bio)->bi_rw & REQ_WRITE_SAME)
+		split = blk_bio_write_same_split(q, *bio, bs);
+	else
+		split = blk_bio_segment_split(q, *bio, q->bio_split);
+
+	if (split) {
+		bio_chain(split, *bio);
+		generic_make_request(*bio);
+		*bio = split;
+	}
+}
+EXPORT_SYMBOL(blk_queue_split);
+
 static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio,
 					     bool no_sg_merge)
 {
 	struct bio_vec bv, bvprv = { NULL };
-	int cluster, high, highprv = 1;
+	int cluster, prev = 0;
 	unsigned int seg_size, nr_phys_segs;
 	struct bio *fbio, *bbio;
 	struct bvec_iter iter;
@@ -36,7 +182,6 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	cluster = blk_queue_cluster(q);
 	seg_size = 0;
 	nr_phys_segs = 0;
-	high = 0;
 	for_each_bio(bio) {
 		bio_for_each_segment(bv, bio, iter) {
 			/*
@@ -46,13 +191,7 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 			if (no_sg_merge)
 				goto new_segment;
 
-			/*
-			 * the trick here is making sure that a high page is
-			 * never considered part of another segment, since
-			 * that might change with the bounce page.
-			 */
-			high = page_to_pfn(bv.bv_page) > queue_bounce_pfn(q);
-			if (!high && !highprv && cluster) {
+			if (prev && cluster) {
 				if (seg_size + bv.bv_len
 				    > queue_max_segment_size(q))
 					goto new_segment;
@@ -72,8 +211,8 @@ new_segment:
 
 			nr_phys_segs++;
 			bvprv = bv;
+			prev = 1;
 			seg_size = bv.bv_len;
-			highprv = high;
 		}
 		bbio = bio;
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index ade8a2d..64db12e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1326,6 +1326,8 @@ static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
 		return;
 	}
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if (use_plug && !blk_queue_nomerges(q) &&
 	    blk_attempt_plug_merge(q, bio, &request_count))
 		return;
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 3907202..a6265bc 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1497,6 +1497,8 @@ void drbd_make_request(struct request_queue *q, struct bio *bio)
 	struct drbd_device *device = (struct drbd_device *) q->queuedata;
 	unsigned long start_jif;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	start_jif = jiffies;
 
 	/*
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 09e628da..ea10bd9 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2446,6 +2446,10 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 	char b[BDEVNAME_SIZE];
 	struct bio *split;
 
+	blk_queue_bounce(q, &bio);
+
+	blk_queue_split(q, &bio, q->bio_split);
+
 	pd = q->queuedata;
 	if (!pd) {
 		pr_err("%s incorrect request queue\n",
@@ -2476,8 +2480,6 @@ static void pkt_make_request(struct request_queue *q, struct bio *bio)
 		goto end_io;
 	}
 
-	blk_queue_bounce(q, &bio);
-
 	do {
 		sector_t zone = get_zone(bio->bi_iter.bi_sector, pd);
 		sector_t last_zone = get_zone(bio_end_sector(bio) - 1, pd);
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index ef45cfb..e32e799 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -605,6 +605,8 @@ static void ps3vram_make_request(struct request_queue *q, struct bio *bio)
 
 	dev_dbg(&dev->core, "%s\n", __func__);
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	spin_lock_irq(&priv->lock);
 	busy = !bio_list_empty(&priv->list);
 	bio_list_add(&priv->list, bio);
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index ac8c62c..50ef199 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -148,6 +148,8 @@ static void rsxx_make_request(struct request_queue *q, struct bio *bio)
 	struct rsxx_bio_meta *bio_meta;
 	int st = -EINVAL;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	might_sleep();
 
 	if (!card)
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 4cf81b5..13d577c 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -531,6 +531,8 @@ static void mm_make_request(struct request_queue *q, struct bio *bio)
 		 (unsigned long long)bio->bi_iter.bi_sector,
 		 bio->bi_iter.bi_size);
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	spin_lock_irq(&card->lock);
 	*card->biotail = bio;
 	bio->bi_next = NULL;
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index c94386a..74c44b9 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1054,6 +1054,8 @@ static ssize_t io_stat_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 	ssize_t ret;
 
+	blk_queue_split(queue, &bio, queue->bio_split);
+
 	down_read(&zram->init_lock);
 	ret = scnprintf(buf, PAGE_SIZE,
 			"%8llu %8llu %8llu %8llu\n",
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a930b72..34f6063 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1784,6 +1784,8 @@ static void dm_make_request(struct request_queue *q, struct bio *bio)
 
 	map = dm_get_live_table(md, &srcu_idx);
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	generic_start_io_acct(rw, bio_sectors(bio), &dm_disk(md)->part0);
 
 	/* if we're suspended, we have to queue this io for later */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d4f31e1..5349f76 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -257,6 +257,8 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 	unsigned int sectors;
 	int cpu;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if (mddev == NULL || mddev->pers == NULL
 	    || !mddev->ready) {
 		bio_io_error(bio);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index da21281..267ca3a 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -826,6 +826,8 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 	unsigned long source_addr;
 	unsigned long bytes_done;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	bytes_done = 0;
 	dev_info = bio->bi_bdev->bd_disk->private_data;
 	if (dev_info == NULL)
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index 7d4e939..1305ed3 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -190,6 +190,8 @@ static void xpram_make_request(struct request_queue *q, struct bio *bio)
 	unsigned long page_addr;
 	unsigned long bytes;
 
+	blk_queue_split(q, &bio, q->bio_split);
+
 	if ((bio->bi_iter.bi_sector & 7) != 0 ||
 	    (bio->bi_iter.bi_size & 4095) != 0)
 		/* Request is not page-aligned. */
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index 413a840..a8645a9 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -340,6 +340,8 @@ static void loop_make_request(struct request_queue *q, struct bio *old_bio)
 	int rw = bio_rw(old_bio);
 	int inactive;
 
+	blk_queue_split(q, &old_bio, q->bio_split);
+
 	if (!lo)
 		goto err;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7f9a516..93b81a2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -488,6 +488,7 @@ struct request_queue {
 
 	struct blk_mq_tag_set	*tag_set;
 	struct list_head	tag_set_list;
+	struct bio_set		*bio_split;
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
@@ -812,6 +813,8 @@ extern void blk_rq_unprep_clone(struct request *rq);
 extern int blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
 extern void blk_delay_queue(struct request_queue *, unsigned long);
+extern void blk_queue_split(struct request_queue *, struct bio **,
+			    struct bio_set *);
 extern void blk_recount_segments(struct request_queue *, struct bio *);
 extern int scsi_verify_blk_ioctl(struct block_device *, unsigned int);
 extern int scsi_cmd_blk_ioctl(struct block_device *, fmode_t,
-- 
1.9.1
