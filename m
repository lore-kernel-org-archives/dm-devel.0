From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] bio: have bio_kmap_irq return the size of
 mapped data (fwd)
Date: Wed, 8 Nov 2017 07:34:36 -0800
Message-ID: <20171108153436.GA24548@infradead.org>
References: <alpine.LRH.2.02.1711071641090.1339@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108094730.GA7074@infradead.org>
 <alpine.LRH.2.02.1711080733220.12294@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108150559.GB10374@infradead.org>
 <650d7a0d-f344-155a-5b53-4ce368c4aca4@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <650d7a0d-f344-155a-5b53-4ce368c4aca4@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Mikulas Patocka <mpatocka@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Nov 08, 2017 at 08:20:58AM -0700, Jens Axboe wrote:
> On top of that, there are no users of it at all...

But Mikulas wants to add one :)

Note that __bio_kmap_atomic has the same issues, only has a single
users either and would be cleaner if opencoded there as it already
has the current bvec.  See patch below.

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 9490f2845f06..0ec30dc950eb 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -216,7 +216,7 @@ may need to abort DMA operations and revert to PIO for the transfer, in
 which case a virtual mapping of the page is required. For SCSI it is also
 done in some scenarios where the low level driver cannot be trusted to
 handle a single sg entry correctly. The driver is expected to perform the
-kmaps as needed on such occasions using the __bio_kmap_atomic and bio_kmap_irq
+kmaps as needed on such occasions using the bio_kmap_irq and friends
 routines as appropriate. A driver could also use the blk_queue_bounce()
 routine on its own to bounce highmem i/o to low memory for specific requests
 if so desired.
@@ -1137,8 +1137,8 @@ use dma_map_sg for scatter gather) to be able to ship it to the driver. For
 PIO drivers (or drivers that need to revert to PIO transfer once in a
 while (IDE for example)), where the CPU is doing the actual data
 transfer a virtual mapping is needed. If the driver supports highmem I/O,
-(Sec 1.1, (ii) ) it needs to use __bio_kmap_atomic and bio_kmap_irq to
-temporarily map a bio into the virtual address space.
+(Sec 1.1, (ii) ) it needs to use kmap_atomic or similar to temporarily map
+a bio into the virtual address space.
 
 
 8. Prior/Related/Impacted patches
diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index c45b90bb9339..eacf1e433518 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -110,13 +110,13 @@ static blk_qc_t simdisk_make_request(struct request_queue *q, struct bio *bio)
 	sector_t sector = bio->bi_iter.bi_sector;
 
 	bio_for_each_segment(bvec, bio, iter) {
-		char *buffer = __bio_kmap_atomic(bio, iter);
+		char *buffer = kmap_atomic(bvec.bv_page) + bvec.bv_offset;
 		unsigned len = bvec.bv_len >> SECTOR_SHIFT;
 
 		simdisk_transfer(dev, sector, len, buffer,
 				bio_data_dir(bio) == WRITE);
 		sector += len;
-		__bio_kunmap_atomic(buffer);
+		kunmap_atomic(buffer)
 	}
 
 	bio_endio(bio);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 8559e9563c52..48ebe6be07b7 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -157,7 +157,7 @@ EXPORT_SYMBOL(blk_set_stacking_limits);
  * Caveat:
  *    The driver that does this *must* be able to deal appropriately
  *    with buffers in "highmemory". This can be accomplished by either calling
- *    __bio_kmap_atomic() to get a temporary kernel mapping, or by calling
+ *    kmap_atomic() to get a temporary kernel mapping, or by calling
  *    blk_queue_bounce() to create a buffer in normal memory.
  **/
 void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 275c91c99516..65f613612fb0 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -128,18 +128,6 @@ static inline void *bio_data(struct bio *bio)
  */
 #define bvec_to_phys(bv)	(page_to_phys((bv)->bv_page) + (unsigned long) (bv)->bv_offset)
 
-/*
- * queues that have highmem support enabled may still need to revert to
- * PIO transfers occasionally and thus map high pages temporarily. For
- * permanent PIO fall back, user is probably better off disabling highmem
- * I/O completely on that queue (see ide-dma for example)
- */
-#define __bio_kmap_atomic(bio, iter)				\
-	(kmap_atomic(bio_iter_iovec((bio), (iter)).bv_page) +	\
-		bio_iter_iovec((bio), (iter)).bv_offset)
-
-#define __bio_kunmap_atomic(addr)	kunmap_atomic(addr)
-
 /*
  * merge helpers etc
  */
@@ -575,17 +563,6 @@ static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 }
 #endif
 
-static inline char *__bio_kmap_irq(struct bio *bio, struct bvec_iter iter,
-				   unsigned long *flags)
-{
-	return bvec_kmap_irq(&bio_iter_iovec(bio, iter), flags);
-}
-#define __bio_kunmap_irq(buf, flags)	bvec_kunmap_irq(buf, flags)
-
-#define bio_kmap_irq(bio, flags) \
-	__bio_kmap_irq((bio), (bio)->bi_iter, (flags))
-#define bio_kunmap_irq(buf,flags)	__bio_kunmap_irq(buf, flags)
-
 /*
  * BIO list management for use by remapping drivers (e.g. DM or MD) and loop.
  *
