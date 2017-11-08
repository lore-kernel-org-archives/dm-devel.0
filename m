From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] bio: have bio_kmap_irq return the size of mapped data
 (fwd)
Date: Wed, 8 Nov 2017 08:20:58 -0700
Message-ID: <650d7a0d-f344-155a-5b53-4ce368c4aca4@kernel.dk>
References: <alpine.LRH.2.02.1711071641090.1339@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108094730.GA7074@infradead.org>
 <alpine.LRH.2.02.1711080733220.12294@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108150559.GB10374@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171108150559.GB10374@infradead.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On 11/08/2017 08:05 AM, Christoph Hellwig wrote:
> On Wed, Nov 08, 2017 at 07:38:44AM -0500, Mikulas Patocka wrote:
>>> To be honest I think we should just remove bio_kmap_irq.  It is currently
>>> unused and assumes there is only a single bvec to map.
>>
>> It could be removed from include/linux/bio.h and moved to my driver. But 
>> if we leave it in bio.h, it could be used by others as well.
>>
>> bio_kmap_irq can iterate over the whole bio if we use bio_advance on the 
>> bio.
> 
> The bio_kmap_irq name implies it maps the whole bio, but it only maps
> the current segment.  Now if there were plenty of users and it was
> non-trivial we could say we should fix the name and documentation.
> But given how trivial it is I'd rather have you open code it to clearly
> document what you are doing.

On top of that, there are no users of it at all...


diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 9490f2845f06..01c0a03407cc 100644
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
@@ -1137,7 +1137,7 @@ use dma_map_sg for scatter gather) to be able to ship it to the driver. For
 PIO drivers (or drivers that need to revert to PIO transfer once in a
 while (IDE for example)), where the CPU is doing the actual data
 transfer a virtual mapping is needed. If the driver supports highmem I/O,
-(Sec 1.1, (ii) ) it needs to use __bio_kmap_atomic and bio_kmap_irq to
+(Sec 1.1, (ii) ) it needs to use __bio_kmap_atomic or similar to
 temporarily map a bio into the virtual address space.
 
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 9c75f58f6a50..1d7e63d7505f 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -573,17 +573,6 @@ static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
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

-- 
Jens Axboe
