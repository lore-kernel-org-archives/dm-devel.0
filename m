From: Malahal Naineni <malahal@us.ibm.com>
Subject: [PATCH] imported patch
	propagate-bounce-gfp-to-stacked-drivers.patch
Date: Sun, 29 Aug 2010 11:00:28 -0700
Message-ID: <8305d08f6ecf4245e8f9.1283104828@malahal>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jaxboe@fusionio.com, dm-devel@redhat.com
List-Id: dm-devel.ids

diff -r 5d97698a7bc5 -r 8305d08f6ecf block/blk-settings.c
--- a/block/blk-settings.c	Wed Aug 25 13:44:33 2010 -0700
+++ b/block/blk-settings.c	Wed Aug 25 13:44:33 2010 -0700
@@ -126,6 +126,7 @@ void blk_set_default_limits(struct queue
 	lim->io_opt = 0;
 	lim->misaligned = 0;
 	lim->no_cluster = 0;
+	lim->bounce_gfp = 0;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
@@ -204,7 +205,7 @@ void blk_queue_bounce_limit(struct reque
 	unsigned long b_pfn = dma_mask >> PAGE_SHIFT;
 	int dma = 0;
 
-	q->bounce_gfp = GFP_NOIO;
+	q->limits.bounce_gfp = GFP_NOIO;
 #if BITS_PER_LONG == 64
 	/*
 	 * Assume anything <= 4GB can be handled by IOMMU.  Actually
@@ -221,7 +222,7 @@ void blk_queue_bounce_limit(struct reque
 #endif
 	if (dma) {
 		init_emergency_isa_pool();
-		q->bounce_gfp = GFP_NOIO | GFP_DMA;
+		q->limits.bounce_gfp = GFP_NOIO | GFP_DMA;
 		q->limits.bounce_pfn = b_pfn;
 	}
 }
@@ -549,6 +550,7 @@ int blk_stack_limits(struct queue_limits
 
 	t->no_cluster |= b->no_cluster;
 	t->discard_zeroes_data &= b->discard_zeroes_data;
+	t->bounce_gfp |= b->bounce_gfp;
 
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
diff -r 5d97698a7bc5 -r 8305d08f6ecf block/scsi_ioctl.c
--- a/block/scsi_ioctl.c	Wed Aug 25 13:44:33 2010 -0700
+++ b/block/scsi_ioctl.c	Wed Aug 25 13:44:33 2010 -0700
@@ -436,7 +436,7 @@ int sg_scsi_ioctl(struct request_queue *
 
 	bytes = max(in_len, out_len);
 	if (bytes) {
-		buffer = kzalloc(bytes, q->bounce_gfp | GFP_USER| __GFP_NOWARN);
+		buffer = kzalloc(bytes, q->limits.bounce_gfp | GFP_USER| __GFP_NOWARN);
 		if (!buffer)
 			return -ENOMEM;
 
diff -r 5d97698a7bc5 -r 8305d08f6ecf drivers/ata/libata-scsi.c
--- a/drivers/ata/libata-scsi.c	Wed Aug 25 13:44:33 2010 -0700
+++ b/drivers/ata/libata-scsi.c	Wed Aug 25 13:44:33 2010 -0700
@@ -1140,7 +1140,7 @@ static int ata_scsi_dev_config(struct sc
 					 ATA_DMA_PAD_SZ - 1);
 
 		/* configure draining */
-		buf = kmalloc(ATAPI_MAX_DRAIN, q->bounce_gfp | GFP_KERNEL);
+		buf = kmalloc(ATAPI_MAX_DRAIN, q->limits.bounce_gfp | GFP_KERNEL);
 		if (!buf) {
 			ata_dev_printk(dev, KERN_ERR,
 				       "drain buffer allocation failed\n");
diff -r 5d97698a7bc5 -r 8305d08f6ecf fs/bio-integrity.c
--- a/fs/bio-integrity.c	Wed Aug 25 13:44:33 2010 -0700
+++ b/fs/bio-integrity.c	Wed Aug 25 13:44:33 2010 -0700
@@ -413,7 +413,7 @@ int bio_integrity_prep(struct bio *bio)
 
 	/* Allocate kernel buffer for protection data */
 	len = sectors * blk_integrity_tuple_size(bi);
-	buf = kmalloc(len, GFP_NOIO | __GFP_NOFAIL | q->bounce_gfp);
+	buf = kmalloc(len, GFP_NOIO | __GFP_NOFAIL | q->limits.bounce_gfp);
 	if (unlikely(buf == NULL)) {
 		printk(KERN_ERR "could not allocate integrity buffer\n");
 		return -EIO;
diff -r 5d97698a7bc5 -r 8305d08f6ecf fs/bio.c
--- a/fs/bio.c	Wed Aug 25 13:44:33 2010 -0700
+++ b/fs/bio.c	Wed Aug 25 13:44:33 2010 -0700
@@ -871,7 +871,7 @@ struct bio *bio_copy_user_iov(struct req
 
 			i++;
 		} else {
-			page = alloc_page(q->bounce_gfp | gfp_mask);
+			page = alloc_page(q->limits.bounce_gfp | gfp_mask);
 			if (!page) {
 				ret = -ENOMEM;
 				break;
diff -r 5d97698a7bc5 -r 8305d08f6ecf include/linux/blkdev.h
--- a/include/linux/blkdev.h	Wed Aug 25 13:44:33 2010 -0700
+++ b/include/linux/blkdev.h	Wed Aug 25 13:44:33 2010 -0700
@@ -248,6 +248,11 @@ struct queue_limits {
 	unsigned char		discard_misaligned;
 	unsigned char		no_cluster;
 	signed char		discard_zeroes_data;
+
+	/*
+	 * queue needs bounce pages for pages above this limit
+	 */
+	gfp_t			bounce_gfp;
 };
 
 struct request_queue
@@ -298,11 +303,6 @@ struct request_queue
 	void			*queuedata;
 
 	/*
-	 * queue needs bounce pages for pages above this limit
-	 */
-	gfp_t			bounce_gfp;
-
-	/*
 	 * various queue flags, see QUEUE_* below
 	 */
 	unsigned long		queue_flags;
diff -r 5d97698a7bc5 -r 8305d08f6ecf mm/bounce.c
--- a/mm/bounce.c	Wed Aug 25 13:44:33 2010 -0700
+++ b/mm/bounce.c	Wed Aug 25 13:44:33 2010 -0700
@@ -207,7 +207,7 @@ static void __blk_queue_bounce(struct re
 
 		to = bio->bi_io_vec + i;
 
-		to->bv_page = mempool_alloc(pool, q->bounce_gfp);
+		to->bv_page = mempool_alloc(pool, q->limits.bounce_gfp);
 		to->bv_len = from->bv_len;
 		to->bv_offset = from->bv_offset;
 		inc_zone_page_state(to->bv_page, NR_BOUNCE);
@@ -282,7 +282,7 @@ void blk_queue_bounce(struct request_que
 	 * to or bigger than the highest pfn in the system -- in that case,
 	 * don't waste time iterating over bio segments
 	 */
-	if (!(q->bounce_gfp & GFP_DMA)) {
+	if (!(q->limits.bounce_gfp & GFP_DMA)) {
 		if (queue_bounce_pfn(q) >= blk_max_pfn)
 			return;
 		pool = page_pool;
