From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH v5 4/6] block: Add support for REQ_ALLOCATE flag
Date: Wed, 22 Jan 2020 13:58:13 +0300
Message-ID: <157969069360.174869.18184061012552778480.stgit@localhost.localdomain>
References: <157968992539.174869.7490844754165043549.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <157968992539.174869.7490844754165043549.stgit@localhost.localdomain>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, bob.liu@oracle.com, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, darrick.wong@oracle.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, chaitanya.kulkarni@wdc.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, ktkhai@virtuozzo.com
List-Id: dm-devel.ids

This adds support for REQ_ALLOCATE extension of REQ_OP_WRITE_ZEROES
operation, which encourages a block device driver to just allocate
blocks (or mark them allocated) instead of actual blocks zeroing.
REQ_ALLOCATE is aimed to be used for network filesystems providing
a block device interface. Also, block devices, which map a file
on other filesystem (like loop), may use this for less fragmentation
and batching fallocate() requests. Hypervisors like QEMU may
introduce optimizations of clusters allocations based on this.

BLKDEV_ZERO_ALLOCATE is a new corresponding flag for
blkdev_issue_zeroout().

Stacking devices start from zero max_allocate_sectors limit for now,
and the support is going to be implemented separate for each device
in the future.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 block/blk-lib.c           |   17 ++++++++++-------
 block/blk-settings.c      |    4 ++++
 fs/block_dev.c            |    4 ++++
 include/linux/blk_types.h |    5 ++++-
 include/linux/blkdev.h    |   13 ++++++++++---
 5 files changed, 32 insertions(+), 11 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 3e38c93cfc53..9cd6f86523ba 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -214,7 +214,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		struct bio **biop, unsigned flags)
 {
 	struct bio *bio = *biop;
-	unsigned int max_write_zeroes_sectors;
+	unsigned int max_write_zeroes_sectors, req_flags = 0;
 	struct request_queue *q = bdev_get_queue(bdev);
 
 	if (!q)
@@ -224,18 +224,21 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		return -EPERM;
 
 	/* Ensure that max_write_zeroes_sectors doesn't overflow bi_size */
-	max_write_zeroes_sectors = bdev_write_zeroes_sectors(bdev, 0);
+	max_write_zeroes_sectors = bdev_write_zeroes_sectors(bdev, flags);
 
 	if (max_write_zeroes_sectors == 0)
 		return -EOPNOTSUPP;
 
+	if (flags & BLKDEV_ZERO_NOUNMAP)
+		req_flags |= REQ_NOUNMAP;
+	if (flags & BLKDEV_ZERO_ALLOCATE)
+		req_flags |= REQ_ALLOCATE|REQ_NOUNMAP;
+
 	while (nr_sects) {
 		bio = blk_next_bio(bio, 0, gfp_mask);
 		bio->bi_iter.bi_sector = sector;
 		bio_set_dev(bio, bdev);
-		bio->bi_opf = REQ_OP_WRITE_ZEROES;
-		if (flags & BLKDEV_ZERO_NOUNMAP)
-			bio->bi_opf |= REQ_NOUNMAP;
+		bio->bi_opf = REQ_OP_WRITE_ZEROES | req_flags;
 
 		if (nr_sects > max_write_zeroes_sectors) {
 			bio->bi_iter.bi_size = max_write_zeroes_sectors << 9;
@@ -362,7 +365,7 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	sector_t bs_mask;
 	struct bio *bio;
 	struct blk_plug plug;
-	bool try_write_zeroes = !!bdev_write_zeroes_sectors(bdev, 0);
+	bool try_write_zeroes = !!bdev_write_zeroes_sectors(bdev, flags);
 
 	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
 	if ((sector | nr_sects) & bs_mask)
@@ -391,7 +394,7 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			try_write_zeroes = false;
 			goto retry;
 		}
-		if (!bdev_write_zeroes_sectors(bdev, 0)) {
+		if (!bdev_write_zeroes_sectors(bdev, flags)) {
 			/*
 			 * Zeroing offload support was indicated, but the
 			 * device reported ILLEGAL REQUEST (for some devices
diff --git a/block/blk-settings.c b/block/blk-settings.c
index c8eda2e7b91e..8d5df9d37239 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -48,6 +48,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->chunk_sectors = 0;
 	lim->max_write_same_sectors = 0;
 	lim->max_write_zeroes_sectors = 0;
+	lim->max_allocate_sectors = 0;
 	lim->max_discard_sectors = 0;
 	lim->max_hw_discard_sectors = 0;
 	lim->discard_granularity = 0;
@@ -83,6 +84,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->max_dev_sectors = UINT_MAX;
 	lim->max_write_same_sectors = UINT_MAX;
 	lim->max_write_zeroes_sectors = UINT_MAX;
+	lim->max_allocate_sectors = 0;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 
@@ -506,6 +508,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 					b->max_write_same_sectors);
 	t->max_write_zeroes_sectors = min(t->max_write_zeroes_sectors,
 					b->max_write_zeroes_sectors);
+	t->max_allocate_sectors = min(t->max_allocate_sectors,
+					b->max_allocate_sectors);
 	t->bounce_pfn = min_not_zero(t->bounce_pfn, b->bounce_pfn);
 
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask,
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 69bf2fb6f7cd..1ffef894b3bd 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -2122,6 +2122,10 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
 					     GFP_KERNEL, BLKDEV_ZERO_NOFALLBACK);
 		break;
+	case FALLOC_FL_KEEP_SIZE:
+		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
+			GFP_KERNEL, BLKDEV_ZERO_ALLOCATE | BLKDEV_ZERO_NOFALLBACK);
+		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
 		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
 					     GFP_KERNEL, 0);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 70254ae11769..86accd2caa4e 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -335,7 +335,9 @@ enum req_flag_bits {
 
 	/* command specific flags for REQ_OP_WRITE_ZEROES: */
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
-
+	__REQ_ALLOCATE,		/* only notify about allocated blocks,
+				 * and do not actually zero them
+				 */
 	__REQ_HIPRI,
 
 	/* for driver use */
@@ -362,6 +364,7 @@ enum req_flag_bits {
 #define REQ_CGROUP_PUNT		(1ULL << __REQ_CGROUP_PUNT)
 
 #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
+#define REQ_ALLOCATE		(1ULL << __REQ_ALLOCATE)
 #define REQ_HIPRI		(1ULL << __REQ_HIPRI)
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 264202fa3bf8..20c94a7f9411 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -337,6 +337,7 @@ struct queue_limits {
 	unsigned int		max_hw_discard_sectors;
 	unsigned int		max_write_same_sectors;
 	unsigned int		max_write_zeroes_sectors;
+	unsigned int		max_allocate_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
 
@@ -991,6 +992,8 @@ static inline struct bio_vec req_bvec(struct request *rq)
 static inline unsigned int blk_queue_get_max_write_zeroes_sectors(
 		struct request_queue *q, unsigned int op_flags)
 {
+	if (op_flags & REQ_ALLOCATE)
+		return q->limits.max_allocate_sectors;
 	return q->limits.max_write_zeroes_sectors;
 }
 
@@ -1227,6 +1230,7 @@ extern int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
+#define BLKDEV_ZERO_ALLOCATE	(1 << 2)  /* allocate range of blocks */
 
 extern int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop,
@@ -1431,10 +1435,13 @@ static inline unsigned int bdev_write_zeroes_sectors(struct block_device *bdev,
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (q)
-		return q->limits.max_write_zeroes_sectors;
+	if (!q)
+		return 0;
 
-	return 0;
+	if (flags & BLKDEV_ZERO_ALLOCATE)
+		return q->limits.max_allocate_sectors;
+	else
+		return q->limits.max_write_zeroes_sectors;
 }
 
 static inline enum blk_zoned_model bdev_zoned_model(struct block_device *bdev)
