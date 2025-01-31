Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B701C07C9;
	Fri, 31 Jan 2025 12:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738326291; cv=none; b=kOvny/Idt1ZaY3indoyvHXDs38bM8O24NHItmQXczYyuHdD4wsib/COrgl0dSisSruqBSYaoor1XkWxqQUNb36WIAfpZrIjhA9SpQN3lwSpwxS2BOkp8hfNFFhsJOJ3iLXZRUQMi31MFg6Pfhs1DgaBQlIcZ+H2BGOr9gZwLj1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738326291; c=relaxed/simple;
	bh=A987CPUzD1ZzI260qej/2fv84VTiLhp1CMfmlo7ioa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skjrVlkqWRHaVjf37p9sbsruBjm/69hrwUXDBy5OE4GJCSwIbTxxTEjehH4FekvIN96YxYeS1ckwRo4MkOKpMHTf3oLwNBVULO5Eah5MXmB4inlt4codGHpG+VXvuEzZ3TdH4bimlPX+8BfxnqqLmkRTtKhvJ2mN1vy/D49Qs+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2rEZJ+le; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2rEZJ+le"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fW3WJTOwBYORp9MDbl4bSzPU0nz1D3ja9KowP154nz4=; b=2rEZJ+leASkTWLWbcT1306zTFk
	UzCJHk1UIozxfAXJ3PWmn4BZ7tOsL9MQ4Ba/IlU/2mOzuxjsmPpxkJh4UXkPNKoOONDgyymOpOBi7
	GQgvMFSHqd9H2AhgJ1xUtNgcn/FF28hpAdtFO9ReLuUSWZs1RMLuOVR8+4Ykh9QWwxbQeYzkQ5yys
	HQiMnYa1rJSbNvvWDN9FCeLajiLiQYd+w2lkPmZ6X0Ud9Z+YOuBjwElGZ16uXZh3APSZzcyyjHK2A
	NHQrTc4Lnbc/LLS1Xwyxgr0vUctvPQhRP+oXzoXg3A0j6iTOfgcrAMmnhhTa8ISd0Mnxv6oJ6uaCh
	wpcg7xTw==;
Received: from 2a02-8389-2341-5b80-85a0-dd45-e939-a129.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:85a0:dd45:e939:a129] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tdq4k-0000000Ab2G-2BFt;
	Fri, 31 Jan 2025 12:24:47 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH 3/3] block: split struct bio_integrity_data
Date: Fri, 31 Jan 2025 13:24:18 +0100
Message-ID: <20250131122436.1317268-4-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250131122436.1317268-1-hch@lst.de>
References: <20250131122436.1317268-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Many of the fields in struct bio_integrity_data are only needed for
the default integrity buffer in the block layer, and the variable
sized array at the end of the structure makes it very hard to embed
into caller allocated structures.

Reduce struct bio_integrity_data to the minimal structure needed in
common code, and create containing structures for the payload + bvec
allocation for submitter provided buffers, and the default integrity
code.  Stop using mempools for the submitter buffers as they don't sit
below the I/O stack, and instead always use the mempool for automatic
integrity metadata instead of depending on bio_set that is submitter
controlled and thus often doesn't have the mempool initialized.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity.c               | 107 ++++++----------------------
 block/bio.c                         |   6 --
 block/blk.h                         |   2 +-
 block/integrity-default.c           |  75 +++++++++++++------
 block/t10-pi.c                      |   6 +-
 drivers/md/dm-integrity.c           |  12 ----
 drivers/md/dm-table.c               |   6 --
 drivers/md/md.c                     |  13 ----
 drivers/target/target_core_iblock.c |  12 ----
 include/linux/bio-integrity.h       |  25 +------
 include/linux/bio.h                 |   4 --
 11 files changed, 80 insertions(+), 188 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index aa9f96612319..608594a154a5 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -7,13 +7,12 @@
  */
 
 #include <linux/blk-integrity.h>
-#include <linux/mempool.h>
-#include <linux/export.h>
-#include <linux/bio.h>
-#include <linux/slab.h>
 #include "blk.h"
 
-static struct kmem_cache *bip_slab;
+struct bio_integrity_alloc {
+	struct bio_integrity_payload	bip;
+	struct bio_vec			bvecs[];
+};
 
 /**
  * bio_integrity_free - Free bio integrity payload
@@ -23,21 +22,23 @@ static struct kmem_cache *bip_slab;
  */
 void bio_integrity_free(struct bio *bio)
 {
-	struct bio_integrity_payload *bip = bio_integrity(bio);
-	struct bio_set *bs = bio->bi_pool;
-
-	if (bs && mempool_initialized(&bs->bio_integrity_pool)) {
-		if (bip->bip_vec)
-			bvec_free(&bs->bvec_integrity_pool, bip->bip_vec,
-				  bip->bip_max_vcnt);
-		mempool_free(bip, &bs->bio_integrity_pool);
-	} else {
-		kfree(bip);
-	}
+	kfree(bio_integrity(bio));
 	bio->bi_integrity = NULL;
 	bio->bi_opf &= ~REQ_INTEGRITY;
 }
 
+void bio_integrity_init(struct bio *bio, struct bio_integrity_payload *bip,
+		struct bio_vec *bvecs, unsigned int nr_vecs)
+{
+	memset(bip, 0, sizeof(*bip));
+	bip->bip_max_vcnt = nr_vecs;
+	if (nr_vecs)
+		bip->bip_vec = bvecs;
+
+	bio->bi_integrity = bip;
+	bio->bi_opf |= REQ_INTEGRITY;
+}
+
 /**
  * bio_integrity_alloc - Allocate integrity payload and attach it to bio
  * @bio:	bio to attach integrity metadata to
@@ -52,48 +53,16 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 						  gfp_t gfp_mask,
 						  unsigned int nr_vecs)
 {
-	struct bio_integrity_payload *bip;
-	struct bio_set *bs = bio->bi_pool;
-	unsigned inline_vecs;
+	struct bio_integrity_alloc *bia;
 
 	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	if (!bs || !mempool_initialized(&bs->bio_integrity_pool)) {
-		bip = kmalloc(struct_size(bip, bip_inline_vecs, nr_vecs), gfp_mask);
-		inline_vecs = nr_vecs;
-	} else {
-		bip = mempool_alloc(&bs->bio_integrity_pool, gfp_mask);
-		inline_vecs = BIO_INLINE_VECS;
-	}
-
-	if (unlikely(!bip))
+	bia = kmalloc(struct_size(bia, bvecs, nr_vecs), gfp_mask);
+	if (unlikely(!bia))
 		return ERR_PTR(-ENOMEM);
-
-	memset(bip, 0, sizeof(*bip));
-
-	/* always report as many vecs as asked explicitly, not inline vecs */
-	bip->bip_max_vcnt = nr_vecs;
-	if (nr_vecs > inline_vecs) {
-		bip->bip_vec = bvec_alloc(&bs->bvec_integrity_pool,
-					  &bip->bip_max_vcnt, gfp_mask);
-		if (!bip->bip_vec)
-			goto err;
-	} else if (nr_vecs) {
-		bip->bip_vec = bip->bip_inline_vecs;
-	}
-
-	bip->bip_bio = bio;
-	bio->bi_integrity = bip;
-	bio->bi_opf |= REQ_INTEGRITY;
-
-	return bip;
-err:
-	if (bs && mempool_initialized(&bs->bio_integrity_pool))
-		mempool_free(bip, &bs->bio_integrity_pool);
-	else
-		kfree(bip);
-	return ERR_PTR(-ENOMEM);
+	bio_integrity_init(bio, &bia->bip, bia->bvecs, nr_vecs);
+	return &bia->bip;
 }
 EXPORT_SYMBOL(bio_integrity_alloc);
 
@@ -467,35 +436,3 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	return 0;
 }
-
-int bioset_integrity_create(struct bio_set *bs, int pool_size)
-{
-	if (mempool_initialized(&bs->bio_integrity_pool))
-		return 0;
-
-	if (mempool_init_slab_pool(&bs->bio_integrity_pool,
-				   pool_size, bip_slab))
-		return -1;
-
-	if (biovec_init_pool(&bs->bvec_integrity_pool, pool_size)) {
-		mempool_exit(&bs->bio_integrity_pool);
-		return -1;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(bioset_integrity_create);
-
-void bioset_integrity_free(struct bio_set *bs)
-{
-	mempool_exit(&bs->bio_integrity_pool);
-	mempool_exit(&bs->bvec_integrity_pool);
-}
-
-void __init bio_integrity_init(void)
-{
-	bip_slab = kmem_cache_create("bio_integrity_payload",
-				     sizeof(struct bio_integrity_payload) +
-				     sizeof(struct bio_vec) * BIO_INLINE_VECS,
-				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
-}
diff --git a/block/bio.c b/block/bio.c
index f0c416e5931d..dabc1a6c41b1 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1657,7 +1657,6 @@ void bioset_exit(struct bio_set *bs)
 	mempool_exit(&bs->bio_pool);
 	mempool_exit(&bs->bvec_pool);
 
-	bioset_integrity_free(bs);
 	if (bs->bio_slab)
 		bio_put_slab(bs);
 	bs->bio_slab = NULL;
@@ -1737,8 +1736,6 @@ static int __init init_bio(void)
 
 	BUILD_BUG_ON(BIO_FLAG_LAST > 8 * sizeof_field(struct bio, bi_flags));
 
-	bio_integrity_init();
-
 	for (i = 0; i < ARRAY_SIZE(bvec_slabs); i++) {
 		struct biovec_slab *bvs = bvec_slabs + i;
 
@@ -1754,9 +1751,6 @@ static int __init init_bio(void)
 			BIOSET_NEED_BVECS | BIOSET_PERCPU_CACHE))
 		panic("bio: can't allocate bios\n");
 
-	if (bioset_integrity_create(&fs_bio_set, BIO_POOL_SIZE))
-		panic("bio: can't create integrity pool\n");
-
 	return 0;
 }
 subsys_initcall(init_bio);
diff --git a/block/blk.h b/block/blk.h
index 90fa5f28ccab..8f5554a6989e 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -710,7 +710,7 @@ int bdev_open(struct block_device *bdev, blk_mode_t mode, void *holder,
 int bdev_permission(dev_t dev, blk_mode_t mode, void *holder);
 
 void blk_integrity_generate(struct bio *bio);
-void blk_integrity_verify(struct bio *bio);
+void blk_integrity_verify_iter(struct bio *bio, struct bvec_iter *saved_iter);
 void blk_integrity_prepare(struct request *rq);
 void blk_integrity_complete(struct request *rq, unsigned int nr_bytes);
 
diff --git a/block/integrity-default.c b/block/integrity-default.c
index 00ec9c001c71..3150f35ef708 100644
--- a/block/integrity-default.c
+++ b/block/integrity-default.c
@@ -12,18 +12,34 @@
 #include <linux/workqueue.h>
 #include "blk.h"
 
+struct bio_integrity_data {
+	struct bio			*bio;
+	struct bvec_iter		saved_bio_iter;
+	struct work_struct		work;
+	struct bio_integrity_payload	bip;
+	struct bio_vec			bvec;
+};
+
+static struct kmem_cache *bid_slab;
+static mempool_t bid_pool;
 static struct workqueue_struct *kintegrityd_wq;
 
-static void bio_integrity_verify_fn(struct work_struct *work)
+static void bio_integrity_finish(struct bio_integrity_data *bid)
 {
-	struct bio_integrity_payload *bip =
-		container_of(work, struct bio_integrity_payload, bip_work);
-	struct bio *bio = bip->bip_bio;
+	bid->bio->bi_integrity = NULL;
+	bid->bio->bi_opf &= ~REQ_INTEGRITY;
+	kfree(bvec_virt(bid->bip.bip_vec));
+	mempool_free(bid, &bid_pool);
+}
 
-	blk_integrity_verify(bio);
+static void bio_integrity_verify_fn(struct work_struct *work)
+{
+	struct bio_integrity_data *bid =
+		container_of(work, struct bio_integrity_data, work);
+	struct bio *bio = bid->bio;
 
-	kfree(bvec_virt(bip->bip_vec));
-	bio_integrity_free(bio);
+	blk_integrity_verify_iter(bio, &bid->saved_bio_iter);
+	bio_integrity_finish(bid);
 	bio_endio(bio);
 }
 
@@ -40,15 +56,16 @@ bool __bio_integrity_endio(struct bio *bio)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
+	struct bio_integrity_data *bid =
+		container_of(bip, struct bio_integrity_data, bip);
 
 	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status && bi->csum_type) {
-		INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
-		queue_work(kintegrityd_wq, &bip->bip_work);
+		INIT_WORK(&bid->work, bio_integrity_verify_fn);
+		queue_work(kintegrityd_wq, &bid->work);
 		return false;
 	}
 
-	kfree(bvec_virt(bip->bip_vec));
-	bio_integrity_free(bio);
+	bio_integrity_finish(bid);
 	return true;
 }
 
@@ -65,8 +82,8 @@ bool __bio_integrity_endio(struct bio *bio)
  */
 bool bio_integrity_prep(struct bio *bio)
 {
-	struct bio_integrity_payload *bip;
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	struct bio_integrity_data *bid;
 	gfp_t gfp = GFP_NOIO;
 	unsigned int len;
 	void *buf;
@@ -102,27 +119,30 @@ bool bio_integrity_prep(struct bio *bio)
 		return true;
 	}
 
+	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
+		return true;
+
 	/* Allocate kernel buffer for protection data */
 	len = bio_integrity_bytes(bi, bio_sectors(bio));
 	buf = kmalloc(len, gfp);
 	if (!buf)
 		goto err_end_io;
+	bid = mempool_alloc(&bid_pool, GFP_NOIO);
+	if (!bid)
+		goto err_free_buf;
+	bio_integrity_init(bio, &bid->bip, &bid->bvec, 1);
 
-	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);
-	if (IS_ERR(bip)) {
-		kfree(buf);
-		goto err_end_io;
-	}
+	bid->bio = bio;
 
-	bip->bip_flags |= BIP_BLOCK_INTEGRITY;
-	bip_set_seed(bip, bio->bi_iter.bi_sector);
+	bid->bip.bip_flags |= BIP_BLOCK_INTEGRITY;
+	bip_set_seed(&bid->bip, bio->bi_iter.bi_sector);
 
 	if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
-		bip->bip_flags |= BIP_IP_CHECKSUM;
+		bid->bip.bip_flags |= BIP_IP_CHECKSUM;
 	if (bi->csum_type)
-		bip->bip_flags |= BIP_CHECK_GUARD;
+		bid->bip.bip_flags |= BIP_CHECK_GUARD;
 	if (bi->flags & BLK_INTEGRITY_REF_TAG)
-		bip->bip_flags |= BIP_CHECK_REFTAG;
+		bid->bip.bip_flags |= BIP_CHECK_REFTAG;
 
 	if (bio_integrity_add_page(bio, virt_to_page(buf), len,
 			offset_in_page(buf)) < len)
@@ -132,9 +152,11 @@ bool bio_integrity_prep(struct bio *bio)
 	if (bio_data_dir(bio) == WRITE)
 		blk_integrity_generate(bio);
 	else
-		bip->bio_iter = bio->bi_iter;
+		bid->saved_bio_iter = bio->bi_iter;
 	return true;
 
+err_free_buf:
+	kfree(buf);
 err_end_io:
 	bio->bi_status = BLK_STS_RESOURCE;
 	bio_endio(bio);
@@ -149,6 +171,13 @@ void blk_flush_integrity(void)
 
 static int __init blk_integrity_default_init(void)
 {
+	bid_slab = kmem_cache_create("bio_integrity_data",
+			sizeof(struct bio_integrity_data), 0,
+			SLAB_HWCACHE_ALIGN | SLAB_PANIC, NULL);
+
+	if (mempool_init_slab_pool(&bid_pool, BIO_POOL_SIZE, bid_slab))
+		panic("bio: can't create integrity pool\n");
+
 	/*
 	 * kintegrityd won't block much but may burn a lot of CPU cycles.
 	 * Make it highpri CPU intensive wq with max concurrency of 1.
diff --git a/block/t10-pi.c b/block/t10-pi.c
index 2d05421f0fa5..de172d56b1f3 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -404,7 +404,7 @@ void blk_integrity_generate(struct bio *bio)
 	}
 }
 
-void blk_integrity_verify(struct bio *bio)
+void blk_integrity_verify_iter(struct bio *bio, struct bvec_iter *saved_iter)
 {
 	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
 	struct bio_integrity_payload *bip = bio_integrity(bio);
@@ -418,9 +418,9 @@ void blk_integrity_verify(struct bio *bio)
 	 */
 	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
 	iter.interval = 1 << bi->interval_exp;
-	iter.seed = bip->bio_iter.bi_sector;
+	iter.seed = saved_iter->bi_sector;
 	iter.prot_buf = bvec_virt(bip->bip_vec);
-	__bio_for_each_segment(bv, bio, bviter, bip->bio_iter) {
+	__bio_for_each_segment(bv, bio, bviter, *saved_iter) {
 		void *kaddr = bvec_kmap_local(&bv);
 		blk_status_t ret = BLK_STS_OK;
 
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index ee9f7cecd78e..e743657379f7 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4808,23 +4808,11 @@ static int dm_integrity_ctr(struct dm_target *ti, unsigned int argc, char **argv
 			ti->error = "Cannot allocate bio set";
 			goto bad;
 		}
-		r = bioset_integrity_create(&ic->recheck_bios, RECHECK_POOL_SIZE);
-		if (r) {
-			ti->error = "Cannot allocate bio integrity set";
-			r = -ENOMEM;
-			goto bad;
-		}
 		r = bioset_init(&ic->recalc_bios, 1, 0, BIOSET_NEED_BVECS);
 		if (r) {
 			ti->error = "Cannot allocate bio set";
 			goto bad;
 		}
-		r = bioset_integrity_create(&ic->recalc_bios, 1);
-		if (r) {
-			ti->error = "Cannot allocate bio integrity set";
-			r = -ENOMEM;
-			goto bad;
-		}
 	}
 
 	ic->metadata_wq = alloc_workqueue("dm-integrity-metadata",
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0ef5203387b2..904025eaea5b 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1081,15 +1081,9 @@ static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *
 		__alignof__(struct dm_io)) + DM_IO_BIO_OFFSET;
 	if (bioset_init(&pools->io_bs, pool_size, io_front_pad, bioset_flags))
 		goto out_free_pools;
-	if (mempool_needs_integrity &&
-	    bioset_integrity_create(&pools->io_bs, pool_size))
-		goto out_free_pools;
 init_bs:
 	if (bioset_init(&pools->bs, pool_size, front_pad, 0))
 		goto out_free_pools;
-	if (mempool_needs_integrity &&
-	    bioset_integrity_create(&pools->bs, pool_size))
-		goto out_free_pools;
 
 	t->mempools = pools;
 	return 0;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 22f7bd3b94d5..a51cd83483e9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2359,19 +2359,6 @@ int md_integrity_register(struct mddev *mddev)
 		return 0; /* shouldn't register */
 
 	pr_debug("md: data integrity enabled on %s\n", mdname(mddev));
-	if (bioset_integrity_create(&mddev->bio_set, BIO_POOL_SIZE) ||
-	    (mddev->level != 1 && mddev->level != 10 &&
-	     bioset_integrity_create(&mddev->io_clone_set, BIO_POOL_SIZE))) {
-		/*
-		 * No need to handle the failure of bioset_integrity_create,
-		 * because the function is called by md_run() -> pers->run(),
-		 * md_run calls bioset_exit -> bioset_integrity_free in case
-		 * of failure case.
-		 */
-		pr_err("md: failed to create integrity pool for %s\n",
-		       mdname(mddev));
-		return -EINVAL;
-	}
 	return 0;
 }
 EXPORT_SYMBOL(md_integrity_register);
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c8dc92a7d63e..73564efd11d2 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -167,18 +167,6 @@ static int iblock_configure_device(struct se_device *dev)
 		break;
 	}
 
-	if (dev->dev_attrib.pi_prot_type) {
-		struct bio_set *bs = &ib_dev->ibd_bio_set;
-
-		if (bioset_integrity_create(bs, IBLOCK_BIO_POOL_SIZE) < 0) {
-			pr_err("Unable to allocate bioset for PI\n");
-			ret = -ENOMEM;
-			goto out_blkdev_put;
-		}
-		pr_debug("IBLOCK setup BIP bs->bio_integrity_pool: %p\n",
-			 &bs->bio_integrity_pool);
-	}
-
 	dev->dev_attrib.hw_pi_prot_type = dev->dev_attrib.pi_prot_type;
 	return 0;
 
diff --git a/include/linux/bio-integrity.h b/include/linux/bio-integrity.h
index 802f52e38efd..0a25716820fe 100644
--- a/include/linux/bio-integrity.h
+++ b/include/linux/bio-integrity.h
@@ -16,8 +16,6 @@ enum bip_flags {
 };
 
 struct bio_integrity_payload {
-	struct bio		*bip_bio;	/* parent bio */
-
 	struct bvec_iter	bip_iter;
 
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
@@ -25,12 +23,7 @@ struct bio_integrity_payload {
 	unsigned short		bip_flags;	/* control flags */
 	u16			app_tag;	/* application tag value */
 
-	struct bvec_iter	bio_iter;	/* for rewinding parent bio */
-
-	struct work_struct	bip_work;	/* I/O completion */
-
 	struct bio_vec		*bip_vec;
-	struct bio_vec		bip_inline_vecs[];/* embedded bvec array */
 };
 
 #define BIP_CLONE_FLAGS (BIP_MAPPED_INTEGRITY | BIP_IP_CHECKSUM | \
@@ -74,6 +67,8 @@ static inline void bip_set_seed(struct bio_integrity_payload *bip,
 	bip->bip_iter.bi_sector = seed;
 }
 
+void bio_integrity_init(struct bio *bio, struct bio_integrity_payload *bip,
+		struct bio_vec *bvecs, unsigned int nr_vecs);
 struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio, gfp_t gfp,
 		unsigned int nr);
 int bio_integrity_add_page(struct bio *bio, struct page *page, unsigned int len,
@@ -85,9 +80,6 @@ bool bio_integrity_prep(struct bio *bio);
 void bio_integrity_advance(struct bio *bio, unsigned int bytes_done);
 void bio_integrity_trim(struct bio *bio);
 int bio_integrity_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp_mask);
-int bioset_integrity_create(struct bio_set *bs, int pool_size);
-void bioset_integrity_free(struct bio_set *bs);
-void bio_integrity_init(void);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
@@ -96,15 +88,6 @@ static inline struct bio_integrity_payload *bio_integrity(struct bio *bio)
 	return NULL;
 }
 
-static inline int bioset_integrity_create(struct bio_set *bs, int pool_size)
-{
-	return 0;
-}
-
-static inline void bioset_integrity_free(struct bio_set *bs)
-{
-}
-
 static inline int bio_integrity_map_user(struct bio *bio, struct iov_iter *iter)
 {
 	return -EINVAL;
@@ -139,10 +122,6 @@ static inline void bio_integrity_trim(struct bio *bio)
 {
 }
 
-static inline void bio_integrity_init(void)
-{
-}
-
 static inline bool bio_integrity_flagged(struct bio *bio, enum bip_flags flag)
 {
 	return false;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4b79bf50f4f0..cafc7c215de8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -625,10 +625,6 @@ struct bio_set {
 
 	mempool_t bio_pool;
 	mempool_t bvec_pool;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-	mempool_t bio_integrity_pool;
-	mempool_t bvec_integrity_pool;
-#endif
 
 	unsigned int back_pad;
 	/*
-- 
2.45.2

