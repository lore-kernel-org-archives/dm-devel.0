Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC50C433EF
	for <dm-devel@archiver.kernel.org>; Tue, 18 Jan 2022 07:21:03 +0000 (UTC)
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-P48j4C43MgmBWf8s853w_Q-1; Tue, 18 Jan 2022 02:20:58 -0500
X-MC-Unique: P48j4C43MgmBWf8s853w_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C32E1927827;
	Tue, 18 Jan 2022 07:20:47 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BF6579459;
	Tue, 18 Jan 2022 07:20:47 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 24A144BB7C;
	Tue, 18 Jan 2022 07:20:47 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
	[10.11.54.9])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 20I7KjgM013055 for <dm-devel@listman.util.phx.redhat.com>;
	Tue, 18 Jan 2022 02:20:45 -0500
Received: by smtp.corp.redhat.com (Postfix)
	id 7981B492D1D; Tue, 18 Jan 2022 07:20:45 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast05.extmail.prod.ext.rdu2.redhat.com [10.11.55.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 74F07492D19
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:20:45 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5883D8001EA
	for <dm-devel@redhat.com>; Tue, 18 Jan 2022 07:20:45 +0000 (UTC)
Received: from bombadil.infradead.org (bombadil.infradead.org
	[198.137.202.133]) by relay.mimecast.com with ESMTP with STARTTLS
	(version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
	us-mta-440-6bNhtVhbN9adjFdk3DrX8w-1; Tue, 18 Jan 2022 02:20:43 -0500
X-MC-Unique: 6bNhtVhbN9adjFdk3DrX8w-1
Received: from [2001:4bb8:184:72a4:a4a9:19c0:5242:7768] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1n9inH-000Zhx-H9; Tue, 18 Jan 2022 07:20:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Date: Tue, 18 Jan 2022 08:19:49 +0100
Message-Id: <20220118071952.1243143-17-hch@lst.de>
In-Reply-To: <20220118071952.1243143-1-hch@lst.de>
References: <20220118071952.1243143-1-hch@lst.de>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by
	bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-loop: dm-devel@redhat.com
Cc: linux-block@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-nilfs@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.co>,
	dm-devel@redhat.com, "Md . Haris Iqbal " <haris.iqbal@ionos.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	linux-fsdevel@vger.kernel.org, xen-devel@lists.xenproject.org,
	Andrew Morton <akpm@linux-foundation.org>, ntfs3@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>, Pavel Begunkov <asml.silence@gmail.com>,
	drbd-dev@lists.linbit.com
Subject: [dm-devel] [PATCH 16/19] block: pass a block_device and opf to
	bio_alloc_kiocb
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Pass the block_device and operation that we plan to use this bio for to
bio_alloc_kiocb to optimize the assigment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 12 ++++++++----
 block/fops.c        | 17 ++++++++---------
 include/linux/bio.h |  4 ++--
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index a58bc82d3c85f..8853ed6260cfd 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1729,7 +1729,9 @@ EXPORT_SYMBOL(bioset_init_from_src);
 /**
  * bio_alloc_kiocb - Allocate a bio from bio_set based on kiocb
  * @kiocb:	kiocb describing the IO
+ * @bdev:	block device to allocate the bio for (can be %NULL)
  * @nr_vecs:	number of iovecs to pre-allocate
+ * @opf:	operation and flags for bio
  * @bs:		bio_set to allocate from
  *
  * Description:
@@ -1740,14 +1742,14 @@ EXPORT_SYMBOL(bioset_init_from_src);
  *    MUST be done from process context, not hard/soft IRQ.
  *
  */
-struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
-			    struct bio_set *bs)
+struct bio *bio_alloc_kiocb(struct kiocb *kiocb, struct block_device *bdev,
+		unsigned short nr_vecs, unsigned int opf, struct bio_set *bs)
 {
 	struct bio_alloc_cache *cache;
 	struct bio *bio;
 
 	if (!(kiocb->ki_flags & IOCB_ALLOC_CACHE) || nr_vecs > BIO_INLINE_VECS)
-		return bio_alloc_bioset(NULL, nr_vecs, 0, GFP_KERNEL, bs);
+		return bio_alloc_bioset(bdev, nr_vecs, opf, GFP_KERNEL, bs);
 
 	cache = per_cpu_ptr(bs->cache, get_cpu());
 	if (cache->free_list) {
@@ -1756,12 +1758,14 @@ struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
 		cache->nr--;
 		put_cpu();
 		bio_init(bio, nr_vecs ? bio->bi_inline_vecs : NULL, nr_vecs);
+		bio_set_dev(bio, bdev);
+		bio->bi_opf = opf;
 		bio->bi_pool = bs;
 		bio_set_flag(bio, BIO_PERCPU_CACHE);
 		return bio;
 	}
 	put_cpu();
-	bio = bio_alloc_bioset(NULL, nr_vecs, 0, GFP_KERNEL, bs);
+	bio = bio_alloc_bioset(bdev, nr_vecs, opf, GFP_KERNEL, bs);
 	bio_set_flag(bio, BIO_PERCPU_CACHE);
 	return bio;
 }
diff --git a/block/fops.c b/block/fops.c
index 26bf15c770d21..3a62b8b912750 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -190,6 +190,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	struct blkdev_dio *dio;
 	struct bio *bio;
 	bool is_read = (iov_iter_rw(iter) == READ), is_sync;
+	unsigned int opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb);
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
@@ -197,7 +198,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	    (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
-	bio = bio_alloc_kiocb(iocb, nr_pages, &blkdev_dio_pool);
+	bio = bio_alloc_kiocb(iocb, bdev, nr_pages, opf, &blkdev_dio_pool);
 
 	dio = container_of(bio, struct blkdev_dio, bio);
 	atomic_set(&dio->ref, 1);
@@ -223,7 +224,6 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	blk_start_plug(&plug);
 
 	for (;;) {
-		bio_set_dev(bio, bdev);
 		bio->bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 		bio->bi_write_hint = iocb->ki_hint;
 		bio->bi_private = dio;
@@ -238,11 +238,9 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		}
 
 		if (is_read) {
-			bio->bi_opf = REQ_OP_READ;
 			if (dio->flags & DIO_SHOULD_DIRTY)
 				bio_set_pages_dirty(bio);
 		} else {
-			bio->bi_opf = dio_bio_write_op(iocb);
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
 		if (iocb->ki_flags & IOCB_NOWAIT)
@@ -259,6 +257,8 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		atomic_inc(&dio->ref);
 		submit_bio(bio);
 		bio = bio_alloc(GFP_KERNEL, nr_pages);
+		bio_set_dev(bio, bdev);
+		bio->bi_opf = opf;
 	}
 
 	blk_finish_plug(&plug);
@@ -311,6 +311,8 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 					unsigned int nr_pages)
 {
 	struct block_device *bdev = iocb->ki_filp->private_data;
+	bool is_read = iov_iter_rw(iter) == READ;
+	unsigned int opf = is_read ? REQ_OP_READ : dio_bio_write_op(iocb);
 	struct blkdev_dio *dio;
 	struct bio *bio;
 	loff_t pos = iocb->ki_pos;
@@ -320,11 +322,10 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	    (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
-	bio = bio_alloc_kiocb(iocb, nr_pages, &blkdev_dio_pool);
+	bio = bio_alloc_kiocb(iocb, bdev, nr_pages, opf, &blkdev_dio_pool);
 	dio = container_of(bio, struct blkdev_dio, bio);
 	dio->flags = 0;
 	dio->iocb = iocb;
-	bio_set_dev(bio, bdev);
 	bio->bi_iter.bi_sector = pos >> SECTOR_SHIFT;
 	bio->bi_write_hint = iocb->ki_hint;
 	bio->bi_end_io = blkdev_bio_end_io_async;
@@ -347,14 +348,12 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	}
 	dio->size = bio->bi_iter.bi_size;
 
-	if (iov_iter_rw(iter) == READ) {
-		bio->bi_opf = REQ_OP_READ;
+	if (is_read) {
 		if (iter_is_iovec(iter)) {
 			dio->flags |= DIO_SHOULD_DIRTY;
 			bio_set_pages_dirty(bio);
 		}
 	} else {
-		bio->bi_opf = dio_bio_write_op(iocb);
 		task_io_account_write(bio->bi_iter.bi_size);
 	}
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 2f63ae9a71e1a..5c5ada2ebb270 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -408,8 +408,8 @@ extern int bioset_init_from_src(struct bio_set *bs, struct bio_set *src);
 struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
 			     unsigned int opf, gfp_t gfp_mask,
 			     struct bio_set *bs);
-struct bio *bio_alloc_kiocb(struct kiocb *kiocb, unsigned short nr_vecs,
-		struct bio_set *bs);
+struct bio *bio_alloc_kiocb(struct kiocb *kiocb, struct block_device *bdev,
+		unsigned short nr_vecs, unsigned int opf, struct bio_set *bs);
 struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned short nr_iovecs);
 extern void bio_put(struct bio *);
 
-- 
2.30.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

