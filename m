Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FF4BC433EF
	for <dm-devel@archiver.kernel.org>; Fri, 25 Mar 2022 07:27:28 +0000 (UTC)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-205-JGyovwmkOLOerEMucC95vg-1; Fri, 25 Mar 2022 03:27:23 -0400
X-MC-Unique: JGyovwmkOLOerEMucC95vg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54BFB1C04B75;
	Fri, 25 Mar 2022 07:27:22 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2308F401E7B;
	Fri, 25 Mar 2022 07:27:21 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7E399194034E;
	Fri, 25 Mar 2022 07:27:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7ECCE1940341
 for <dm-devel@listman.corp.redhat.com>; Thu, 24 Mar 2022 20:35:35 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 711BF9E62; Thu, 24 Mar 2022 20:35:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 6C8469E60
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 20:35:31 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 473A485A5A8
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 20:35:31 +0000 (UTC)
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com
 [209.85.222.176]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-CCL8mdlYM5GpneeiS6jM9A-1; Thu, 24 Mar 2022 16:35:29 -0400
X-MC-Unique: CCL8mdlYM5GpneeiS6jM9A-1
Received: by mail-qk1-f176.google.com with SMTP id g8so4528671qke.2
 for <dm-devel@redhat.com>; Thu, 24 Mar 2022 13:35:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=g6h21K3Ky29VFE3mJvKyCbaa9it+HvvCtx+rdJYmSmQ=;
 b=cfuxyIXD0fL2rDqBvt8SjwDI6dOO68LSKMmkxho6+NSeIGN/OClSp5D+3TTFdo507p
 cLM3+n8bq+OJk4g/7FyrB7tbkWid7YViSWd61JBtKeRNmGB06wxEA85XuS5ttFWkV6By
 ZTzJvDuUKCk91Zp1i2LdzDu0yllhrUgmVJlc5G5ugpv0TZQMCwmKGkIZ0XBEKwMmfHJG
 DIq8wlyTZnauI9Uhv59L5VkNZEs+Y49ImhexGVOCVt+68t9XKBAsHJNqQ2HJIzQZhw1m
 lmd+64lVsBzhLa59yk6BuzBTlSTP3qWnkkCm6HBGINbD9ityVhmG4NVx2DemttZkqc/F
 XUTQ==
X-Gm-Message-State: AOAM5329s/CYJwxTgqRrNwbRrB+QU3Hidw6VHFXr8hUqgJFg4G5IZZfm
 j1QSwQ0VopEE/r+pkEo/257YX04=
X-Google-Smtp-Source: ABdhPJw7KfeQ1+LTdcr0w85VNwHWcJi0T5xCLbC7duGcefjDUjMLc3QnPfSkHnE3ib+VNOCB5JU5DQ==
X-Received: by 2002:a05:620a:2546:b0:680:a53b:63c with SMTP id
 s6-20020a05620a254600b00680a53b063cmr2294772qko.287.1648154129176; 
 Thu, 24 Mar 2022 13:35:29 -0700 (PDT)
Received: from localhost (pool-68-160-176-52.bstnma.fios.verizon.net.
 [68.160.176.52]) by smtp.gmail.com with ESMTPSA id
 w4-20020a05620a0e8400b0067b1bcd081csm2068371qkm.66.2022.03.24.13.35.28
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 24 Mar 2022 13:35:28 -0700 (PDT)
From: Mike Snitzer <snitzer@kernel.org>
To: axboe@kernel.dk
Date: Thu, 24 Mar 2022 16:35:24 -0400
Message-Id: <20220324203526.62306-2-snitzer@kernel.org>
In-Reply-To: <20220324203526.62306-1-snitzer@kernel.org>
References: <20220324203526.62306-1-snitzer@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Mailman-Approved-At: Fri, 25 Mar 2022 07:27:19 +0000
Subject: [dm-devel] [PATCH v3 1/3] block: allow using the per-cpu bio cache
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, hch@lst.de,
 ming.lei@redhat.com
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Replace the BIO_PERCPU_CACHE bio-internal flag with a REQ_ALLOC_CACHE
one that can be passed to bio_alloc / bio_alloc_bioset, and implement
the percpu cache allocation logic in a helper called from
bio_alloc_bioset.  This allows any bio_alloc_bioset user to use the
percpu caches instead of having the functionality tied to struct kiocb.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
[hch: refactored a bit]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c               | 86 ++++++++++++++++++++++-------------------------
 block/blk.h               |  3 +-
 block/fops.c              | 11 ++++--
 include/linux/bio.h       |  2 --
 include/linux/blk_types.h |  3 +-
 5 files changed, 52 insertions(+), 53 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 33979f306e9e..09b714469b06 100644
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
+			 * No cached bio available, bio returned below marked with
+			 * REQ_ALLOC_CACHE to particpate in per-cpu alloc cache.
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
index 6f21859c7f0f..9cb04f24ba8a 100644
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
index 3696665e586a..f8227ef0719f 100644
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
@@ -320,7 +322,10 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
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
index 4c21f6e69e18..10406f57d339 100644
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
index 0c3563b45fe9..d4ba5251a3a0 100644
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
2.15.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

