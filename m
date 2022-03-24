Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4C8CC433F5
	for <dm-devel@archiver.kernel.org>; Thu, 24 Mar 2022 07:40:09 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-t1tDN6qGOpa6Ut9BEedp6Q-1; Thu, 24 Mar 2022 03:40:05 -0400
X-MC-Unique: t1tDN6qGOpa6Ut9BEedp6Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 247171C068EF;
	Thu, 24 Mar 2022 07:40:03 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B964F7AE2;
	Thu, 24 Mar 2022 07:40:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 66217194034B;
	Thu, 24 Mar 2022 07:40:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 11FB81940347
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 07:40:00 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BAF4C4021DE; Thu, 24 Mar 2022 07:40:00 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B74C04021C0
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 07:40:00 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D3103835B9B
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 07:40:00 +0000 (UTC)
Received: from verein.lst.de (verein.lst.de [213.95.11.211]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-609-JOF_BIvpO9m8hhKeIAx-Ug-1; Thu, 24 Mar 2022 03:39:56 -0400
X-MC-Unique: JOF_BIvpO9m8hhKeIAx-Ug-1
Received: by verein.lst.de (Postfix, from userid 2407)
 id B5F3468B05; Thu, 24 Mar 2022 08:39:52 +0100 (CET)
Date: Thu, 24 Mar 2022 08:39:52 +0100
From: Christoph Hellwig <hch@lst.de>
To: Mike Snitzer <snitzer@redhat.com>
Message-ID: <20220324073952.GA13462@lst.de>
References: <20220323194524.5900-1-snitzer@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20220323194524.5900-1-snitzer@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Subject: Re: [dm-devel] [PATCH v2 0/4] block/dm: use BIOSET_PERCPU_CACHE
 from bio_alloc_bioset
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
 hch@lst.de, ming.lei@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Wed, Mar 23, 2022 at 03:45:20PM -0400, Mike Snitzer wrote:
> I tried to address your review of the previous set. Patch 1 and 2 can
> obviously be folded but I left them split out for review purposes.
> Feel free to see if these changes are meaningful for nvme's use.
> Happy for either you to take on iterating on these block changes
> further or you letting me know what changes you'd like made.

I'd be tempted to go with something like the version below, which
does away with the bio flag and the bio_alloc_kiocb wrapper to
further simplify the interface.  The additional changes neeed for
dm like the bioset_init_from_src changes and move of bio_clear_polled
can then built on top of that.

---
From ec0493b86a3240e7f9f2d46a1298bd40ccf15e80 Mon Sep 17 00:00:00 2001
From: Mike Snitzer <snitzer@redhat.com>
Date: Wed, 23 Mar 2022 15:45:21 -0400
Subject: block: allow using the per-cpu bio cache from bio_alloc_bioset

Replace the BIO_PERCPU_CACHE bio-internal flag with a REQ_ALLOC_CACHE
one that can be passed to bio_alloc / bio_alloc_bioset, and implement
the percpu cache allocation logic in a helper called from
bio_alloc_bioset.  This allows any bio_alloc_bioset user to use the
percpu caches instead of having the functionality tied to struct kiocb.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
[hch: refactored a bit]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c               | 86 +++++++++++++++++++--------------------
 block/blk.h               |  3 +-
 block/fops.c              | 11 +++--
 include/linux/bio.h       |  2 -
 include/linux/blk_types.h |  3 +-
 5 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 33979f306e9e7..d780e2cbea437 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -420,6 +420,28 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
 	queue_work(bs->rescue_workqueue, &bs->rescue_work);
 }
 
+static struct bio *bio_alloc_percpu_cache(struct block_device *bdev,
+		unsigned short nr_vecs, unsigned int opf, gfp_t gfp,
+		struct bio_set *bs)
+{
+	struct bio_alloc_cache *cache;
+	struct bio *bio;
+
+	cache = per_cpu_ptr(bs->cache, get_cpu());
+	if (!cache->free_list) {
+		put_cpu();
+		return NULL;
+	}
+	bio = cache->free_list;
+	cache->free_list = bio->bi_next;
+	cache->nr--;
+	put_cpu();
+
+	bio_init(bio, bdev, nr_vecs ? bio->bi_inline_vecs : NULL, nr_vecs, opf);
+	bio->bi_pool = bs;
+	return bio;
+}
+
 /**
  * bio_alloc_bioset - allocate a bio for I/O
  * @bdev:	block device to allocate the bio for (can be %NULL)
@@ -452,6 +474,9 @@ static void punt_bios_to_rescuer(struct bio_set *bs)
  * submit_bio_noacct() should be avoided - instead, use bio_set's front_pad
  * for per bio allocations.
  *
+ * If REQ_ALLOC_CACHE is set, the final put of the bio MUST be done from process
+ * context, not hard/soft IRQ.
+ *
  * Returns: Pointer to new bio on success, NULL on failure.
  */
 struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
@@ -466,6 +491,21 @@ struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
 	if (WARN_ON_ONCE(!mempool_initialized(&bs->bvec_pool) && nr_vecs > 0))
 		return NULL;
 
+	if (opf & REQ_ALLOC_CACHE) {
+		if (bs->cache && nr_vecs <= BIO_INLINE_VECS) {
+			bio = bio_alloc_percpu_cache(bdev, nr_vecs, opf,
+						     gfp_mask, bs);
+			if (bio)
+				return bio;
+			/*
+			 * No cached bio available, mark bio returned below to
+			 * particpate in per-cpu alloc cache.
+			 */
+		} else {
+			opf &= ~REQ_ALLOC_CACHE;
+		}
+	}
+
 	/*
 	 * submit_bio_noacct() converts recursion to iteration; this means if
 	 * we're running beneath it, any bios we allocate and submit will not be
@@ -712,7 +752,7 @@ void bio_put(struct bio *bio)
 			return;
 	}
 
-	if (bio_flagged(bio, BIO_PERCPU_CACHE)) {
+	if (bio->bi_opf & REQ_ALLOC_CACHE) {
 		struct bio_alloc_cache *cache;
 
 		bio_uninit(bio);
@@ -1734,50 +1774,6 @@ int bioset_init_from_src(struct bio_set *bs, struct bio_set *src)
 }
 EXPORT_SYMBOL(bioset_init_from_src);
 
-/**
- * bio_alloc_kiocb - Allocate a bio from bio_set based on kiocb
- * @kiocb:	kiocb describing the IO
- * @bdev:	block device to allocate the bio for (can be %NULL)
- * @nr_vecs:	number of iovecs to pre-allocate
- * @opf:	operation and flags for bio
- * @bs:		bio_set to allocate from
- *
- * Description:
- *    Like @bio_alloc_bioset, but pass in the kiocb. The kiocb is only
- *    used to check if we should dip into the per-cpu bio_set allocation
- *    cache. The allocation uses GFP_KERNEL internally. On return, the
- *    bio is marked BIO_PERCPU_CACHEABLE, and the final put of the bio
- *    MUST be done from process context, not hard/soft IRQ.
- *
- */
-struct bio *bio_alloc_kiocb(struct kiocb *kiocb, struct block_device *bdev,
-		unsigned short nr_vecs, unsigned int opf, struct bio_set *bs)
-{
-	struct bio_alloc_cache *cache;
-	struct bio *bio;
-
-	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
-		return bio_alloc_bioset(bdev, nr_vecs, opf, GFP_KERNEL, bs);
-
-	cache = per_cpu_ptr(bs->cache, get_cpu());
-	if (cache->free_list) {
-		bio = cache->free_list;
-		cache->free_list = bio->bi_next;
-		cache->nr--;
-		put_cpu();
-		bio_init(bio, bdev, nr_vecs ? bio->bi_inline_vecs : NULL,
-			 nr_vecs, opf);
-		bio->bi_pool = bs;
-		bio_set_flag(bio, BIO_PERCPU_CACHE);
-		return bio;
-	}
-	put_cpu();
-	bio = bio_alloc_bioset(bdev, nr_vecs, opf, GFP_KERNEL, bs);
-	bio_set_flag(bio, BIO_PERCPU_CACHE);
-	return bio;
-}
-EXPORT_SYMBOL_GPL(bio_alloc_kiocb);
-
 static int __init init_bio(void)
 {
 	int i;
diff --git a/block/blk.h b/block/blk.h
index 6f21859c7f0ff..9cb04f24ba8a7 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -454,8 +454,7 @@ extern struct device_attribute dev_attr_events_poll_msecs;
 static inline void bio_clear_polled(struct bio *bio)
 {
 	/* can't support alloc cache if we turn off polling */
-	bio_clear_flag(bio, BIO_PERCPU_CACHE);
-	bio->bi_opf &= ~REQ_POLLED;
+	bio->bi_opf &= ~(REQ_POLLED | REQ_ALLOC_CACHE);
 }
 
 long blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg);
diff --git a/block/fops.c b/block/fops.c
index e49096354dcd6..d1da85bdec31e 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -198,8 +198,10 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	    (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
-	bio = bio_alloc_kiocb(iocb, bdev, nr_pages, opf, &blkdev_dio_pool);
-
+	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
+		opf |= REQ_ALLOC_CACHE;
+	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
+			       &blkdev_dio_pool);
 	dio = container_of(bio, struct blkdev_dio, bio);
 	atomic_set(&dio->ref, 1);
 	/*
@@ -322,7 +324,10 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	    (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
-	bio = bio_alloc_kiocb(iocb, bdev, nr_pages, opf, &blkdev_dio_pool);
+	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
+		opf |= REQ_ALLOC_CACHE;
+	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
+			       &blkdev_dio_pool);
 	dio = container_of(bio, struct blkdev_dio, bio);
 	dio->flags = 0;
 	dio->iocb = iocb;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4c21f6e69e182..10406f57d339e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -408,8 +408,6 @@ extern int bioset_init_from_src(struct bio_set *bs, struct bio_set *src);
 struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
 			     unsigned int opf, gfp_t gfp_mask,
 			     struct bio_set *bs);
-struct bio *bio_alloc_kiocb(struct kiocb *kiocb, struct block_device *bdev,
-		unsigned short nr_vecs, unsigned int opf, struct bio_set *bs);
 struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned short nr_iovecs);
 extern void bio_put(struct bio *);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 0c3563b45fe90..d4ba5251a3a0b 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -328,7 +328,6 @@ enum {
 	BIO_QOS_MERGED,		/* but went through rq_qos merge path */
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_LOCKED,	/* Owns a zoned device zone write lock */
-	BIO_PERCPU_CACHE,	/* can participate in per-cpu alloc cache */
 	BIO_FLAG_LAST
 };
 
@@ -415,6 +414,7 @@ enum req_flag_bits {
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
 
 	__REQ_POLLED,		/* caller polls for completion using bio_poll */
+	__REQ_ALLOC_CACHE,	/* allocate IO from cache if available */
 
 	/* for driver use */
 	__REQ_DRV,
@@ -440,6 +440,7 @@ enum req_flag_bits {
 
 #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
 #define REQ_POLLED		(1ULL << __REQ_POLLED)
+#define REQ_ALLOC_CACHE		(1ULL << __REQ_ALLOC_CACHE)
 
 #define REQ_DRV			(1ULL << __REQ_DRV)
 #define REQ_SWAP		(1ULL << __REQ_SWAP)
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

