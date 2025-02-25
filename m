Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9D3156231;
	Tue, 25 Feb 2025 15:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740498297; cv=none; b=hfrc+nQDToi2cVcHcvz6G7QDKNaNjW15rs+XzR5mMTmeA/z8fKJs4EupVYvOiLK2GGbT/nEHWQqsW0Ncj3k+Iv2hPMb/Z3/ITW3CGx7Xc/P3HZHLh34t7PzlaaqrXmkE1QhUHQwP65u3gmKtAgyXevBepts/IP7eHXbF2VZ6tJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740498297; c=relaxed/simple;
	bh=XeEXPrJIUVbwipZvjxAthJ7gTX1RRL7aOqYK1mIzA6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SUYz4P+llkXEiumdbQys0FrPEzmEs7zpQOpV2kNCbL668JWXyiMm208Co9zUx+9S0kCyj928iNM3+6l9uvo5WfFPYTDnOUmEzzJp5ZC5tgrb2KgnVHu5RU6A0D0XEtM4BIDZhtyjVfr1Qeg0xzStxhaRO/PtvqUT2jEWeOFj4KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OO9vUQX1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OO9vUQX1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=C3Q/8ICyBpK2V5Uqlrn3xxRSg0ecp/Y0AYctyf0+xys=; b=OO9vUQX1wcoYPwLoUYVCccVWad
	G2XNiiyVBEl9xa2+ktmaRgdmpItcNfy0cceEqAgfOXLFUy+t57lTFHvvhIhrRbBdKzlZNCl3qnR3I
	ZsCfhTv7629A0IT7kkhgHhN+UFWspcBlerWGSN80So4VsKINI066MlfMrENXCCh/L8zL268twIDBK
	pQcYUZvMrxHkR2OpYqBvRhtgCew2gPJd3K+KM4Ok35ck1eN82NsPXsEDuXNK+1jdXsb3ulisux1wX
	kViG16wlTkkQOY9GagqsiaLHouicZTXwRjlp9tIli9GILj7r8A46VUsWVK4vesSRqvaqGFYgdQo4r
	pve15L0Q==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tmx74-000000006hy-07Kt;
	Tue, 25 Feb 2025 15:44:50 +0000
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
	target-devel@vger.kernel.org,
	Anuj Gupta <anuj20.g@samsung.com>,
	Hannes Reinecke <hare@suse.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 2/3] block: move the block layer auto-integrity code into a new file
Date: Tue, 25 Feb 2025 07:44:32 -0800
Message-ID: <20250225154449.422989-3-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250225154449.422989-1-hch@lst.de>
References: <20250225154449.422989-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The code that automatically creates a integrity payload and generates and
verifies the checksums for bios that don't have submitter-provided
integrity payload currently sits right in the middle of the block
integrity metadata infrastructure.  Split it into a separate file to
make the different layers clear.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/Makefile             |   3 +-
 block/bio-integrity-auto.c | 162 +++++++++++++++++++++++++++++++++++++
 block/bio-integrity.c      | 159 ------------------------------------
 3 files changed, 164 insertions(+), 160 deletions(-)
 create mode 100644 block/bio-integrity-auto.c

diff --git a/block/Makefile b/block/Makefile
index 33748123710b..3a941dc0d27f 100644
--- a/block/Makefile
+++ b/block/Makefile
@@ -26,7 +26,8 @@ obj-$(CONFIG_MQ_IOSCHED_KYBER)	+= kyber-iosched.o
 bfq-y				:= bfq-iosched.o bfq-wf2q.o bfq-cgroup.o
 obj-$(CONFIG_IOSCHED_BFQ)	+= bfq.o
 
-obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o blk-integrity.o t10-pi.o
+obj-$(CONFIG_BLK_DEV_INTEGRITY) += bio-integrity.o blk-integrity.o t10-pi.o \
+				   bio-integrity-auto.o
 obj-$(CONFIG_BLK_DEV_ZONED)	+= blk-zoned.o
 obj-$(CONFIG_BLK_WBT)		+= blk-wbt.o
 obj-$(CONFIG_BLK_DEBUG_FS)	+= blk-mq-debugfs.o
diff --git a/block/bio-integrity-auto.c b/block/bio-integrity-auto.c
new file mode 100644
index 000000000000..357241fa0f20
--- /dev/null
+++ b/block/bio-integrity-auto.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2007, 2008, 2009 Oracle Corporation
+ * Written by: Martin K. Petersen <martin.petersen@oracle.com>
+ *
+ * Automatically generate and verify integrity data on PI capable devices if the
+ * bio submitter didn't provide PI itself.  This ensures that kernel verifies
+ * data integrity even if the file system (or other user of the block device) is
+ * not aware of PI.
+ */
+#include <linux/blk-integrity.h>
+#include <linux/workqueue.h>
+#include "blk.h"
+
+static struct workqueue_struct *kintegrityd_wq;
+
+static void bio_integrity_verify_fn(struct work_struct *work)
+{
+	struct bio_integrity_payload *bip =
+		container_of(work, struct bio_integrity_payload, bip_work);
+	struct bio *bio = bip->bip_bio;
+
+	blk_integrity_verify(bio);
+
+	kfree(bvec_virt(bip->bip_vec));
+	bio_integrity_free(bio);
+	bio_endio(bio);
+}
+
+/**
+ * __bio_integrity_endio - Integrity I/O completion function
+ * @bio:	Protected bio
+ *
+ * Normally I/O completion is done in interrupt context.  However, verifying I/O
+ * integrity is a time-consuming task which must be run in process context.
+ *
+ * This function postpones completion accordingly.
+ */
+bool __bio_integrity_endio(struct bio *bio)
+{
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	struct bio_integrity_payload *bip = bio_integrity(bio);
+
+	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status && bi->csum_type) {
+		INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
+		queue_work(kintegrityd_wq, &bip->bip_work);
+		return false;
+	}
+
+	kfree(bvec_virt(bip->bip_vec));
+	bio_integrity_free(bio);
+	return true;
+}
+
+/**
+ * bio_integrity_prep - Prepare bio for integrity I/O
+ * @bio:	bio to prepare
+ *
+ * Checks if the bio already has an integrity payload attached.  If it does, the
+ * payload has been generated by another kernel subsystem, and we just pass it
+ * through.
+ * Otherwise allocates integrity payload and for writes the integrity metadata
+ * will be generated.  For reads, the completion handler will verify the
+ * metadata.
+ */
+bool bio_integrity_prep(struct bio *bio)
+{
+	struct bio_integrity_payload *bip;
+	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
+	gfp_t gfp = GFP_NOIO;
+	unsigned int len;
+	void *buf;
+
+	if (!bi)
+		return true;
+
+	if (!bio_sectors(bio))
+		return true;
+
+	/* Already protected? */
+	if (bio_integrity(bio))
+		return true;
+
+	switch (bio_op(bio)) {
+	case REQ_OP_READ:
+		if (bi->flags & BLK_INTEGRITY_NOVERIFY)
+			return true;
+		break;
+	case REQ_OP_WRITE:
+		if (bi->flags & BLK_INTEGRITY_NOGENERATE)
+			return true;
+
+		/*
+		 * Zero the memory allocated to not leak uninitialized kernel
+		 * memory to disk for non-integrity metadata where nothing else
+		 * initializes the memory.
+		 */
+		if (bi->csum_type == BLK_INTEGRITY_CSUM_NONE)
+			gfp |= __GFP_ZERO;
+		break;
+	default:
+		return true;
+	}
+
+	/* Allocate kernel buffer for protection data */
+	len = bio_integrity_bytes(bi, bio_sectors(bio));
+	buf = kmalloc(len, gfp);
+	if (!buf)
+		goto err_end_io;
+
+	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);
+	if (IS_ERR(bip)) {
+		kfree(buf);
+		goto err_end_io;
+	}
+
+	bip->bip_flags |= BIP_BLOCK_INTEGRITY;
+	bip_set_seed(bip, bio->bi_iter.bi_sector);
+
+	if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
+		bip->bip_flags |= BIP_IP_CHECKSUM;
+	if (bi->csum_type)
+		bip->bip_flags |= BIP_CHECK_GUARD;
+	if (bi->flags & BLK_INTEGRITY_REF_TAG)
+		bip->bip_flags |= BIP_CHECK_REFTAG;
+
+	if (bio_integrity_add_page(bio, virt_to_page(buf), len,
+			offset_in_page(buf)) < len)
+		goto err_end_io;
+
+	/* Auto-generate integrity metadata if this is a write */
+	if (bio_data_dir(bio) == WRITE)
+		blk_integrity_generate(bio);
+	else
+		bip->bio_iter = bio->bi_iter;
+	return true;
+
+err_end_io:
+	bio->bi_status = BLK_STS_RESOURCE;
+	bio_endio(bio);
+	return false;
+}
+EXPORT_SYMBOL(bio_integrity_prep);
+
+void blk_flush_integrity(void)
+{
+	flush_workqueue(kintegrityd_wq);
+}
+
+static int __init blk_integrity_auto_init(void)
+{
+	/*
+	 * kintegrityd won't block much but may burn a lot of CPU cycles.
+	 * Make it highpri CPU intensive wq with max concurrency of 1.
+	 */
+	kintegrityd_wq = alloc_workqueue("kintegrityd", WQ_MEM_RECLAIM |
+					 WQ_HIGHPRI | WQ_CPU_INTENSIVE, 1);
+	if (!kintegrityd_wq)
+		panic("Failed to create kintegrityd\n");
+	return 0;
+}
+subsys_initcall(blk_integrity_auto_init);
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 5d81ad9a3d20..aa9f96612319 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -10,17 +10,10 @@
 #include <linux/mempool.h>
 #include <linux/export.h>
 #include <linux/bio.h>
-#include <linux/workqueue.h>
 #include <linux/slab.h>
 #include "blk.h"
 
 static struct kmem_cache *bip_slab;
-static struct workqueue_struct *kintegrityd_wq;
-
-void blk_flush_integrity(void)
-{
-	flush_workqueue(kintegrityd_wq);
-}
 
 /**
  * bio_integrity_free - Free bio integrity payload
@@ -413,149 +406,6 @@ int bio_integrity_map_iter(struct bio *bio, struct uio_meta *meta)
 	return ret;
 }
 
-/**
- * bio_integrity_prep - Prepare bio for integrity I/O
- * @bio:	bio to prepare
- *
- * Description:  Checks if the bio already has an integrity payload attached.
- * If it does, the payload has been generated by another kernel subsystem,
- * and we just pass it through. Otherwise allocates integrity payload.
- * The bio must have data direction, target device and start sector set priot
- * to calling.  In the WRITE case, integrity metadata will be generated using
- * the block device's integrity function.  In the READ case, the buffer
- * will be prepared for DMA and a suitable end_io handler set up.
- */
-bool bio_integrity_prep(struct bio *bio)
-{
-	struct bio_integrity_payload *bip;
-	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
-	unsigned int len;
-	void *buf;
-	gfp_t gfp = GFP_NOIO;
-
-	if (!bi)
-		return true;
-
-	if (!bio_sectors(bio))
-		return true;
-
-	/* Already protected? */
-	if (bio_integrity(bio))
-		return true;
-
-	switch (bio_op(bio)) {
-	case REQ_OP_READ:
-		if (bi->flags & BLK_INTEGRITY_NOVERIFY)
-			return true;
-		break;
-	case REQ_OP_WRITE:
-		if (bi->flags & BLK_INTEGRITY_NOGENERATE)
-			return true;
-
-		/*
-		 * Zero the memory allocated to not leak uninitialized kernel
-		 * memory to disk for non-integrity metadata where nothing else
-		 * initializes the memory.
-		 */
-		if (bi->csum_type == BLK_INTEGRITY_CSUM_NONE)
-			gfp |= __GFP_ZERO;
-		break;
-	default:
-		return true;
-	}
-
-	/* Allocate kernel buffer for protection data */
-	len = bio_integrity_bytes(bi, bio_sectors(bio));
-	buf = kmalloc(len, gfp);
-	if (unlikely(buf == NULL)) {
-		goto err_end_io;
-	}
-
-	bip = bio_integrity_alloc(bio, GFP_NOIO, 1);
-	if (IS_ERR(bip)) {
-		kfree(buf);
-		goto err_end_io;
-	}
-
-	bip->bip_flags |= BIP_BLOCK_INTEGRITY;
-	bip_set_seed(bip, bio->bi_iter.bi_sector);
-
-	if (bi->csum_type == BLK_INTEGRITY_CSUM_IP)
-		bip->bip_flags |= BIP_IP_CHECKSUM;
-
-	/* describe what tags to check in payload */
-	if (bi->csum_type)
-		bip->bip_flags |= BIP_CHECK_GUARD;
-	if (bi->flags & BLK_INTEGRITY_REF_TAG)
-		bip->bip_flags |= BIP_CHECK_REFTAG;
-	if (bio_integrity_add_page(bio, virt_to_page(buf), len,
-			offset_in_page(buf)) < len) {
-		printk(KERN_ERR "could not attach integrity payload\n");
-		goto err_end_io;
-	}
-
-	/* Auto-generate integrity metadata if this is a write */
-	if (bio_data_dir(bio) == WRITE)
-		blk_integrity_generate(bio);
-	else
-		bip->bio_iter = bio->bi_iter;
-	return true;
-
-err_end_io:
-	bio->bi_status = BLK_STS_RESOURCE;
-	bio_endio(bio);
-	return false;
-}
-EXPORT_SYMBOL(bio_integrity_prep);
-
-/**
- * bio_integrity_verify_fn - Integrity I/O completion worker
- * @work:	Work struct stored in bio to be verified
- *
- * Description: This workqueue function is called to complete a READ
- * request.  The function verifies the transferred integrity metadata
- * and then calls the original bio end_io function.
- */
-static void bio_integrity_verify_fn(struct work_struct *work)
-{
-	struct bio_integrity_payload *bip =
-		container_of(work, struct bio_integrity_payload, bip_work);
-	struct bio *bio = bip->bip_bio;
-
-	blk_integrity_verify(bio);
-
-	kfree(bvec_virt(bip->bip_vec));
-	bio_integrity_free(bio);
-	bio_endio(bio);
-}
-
-/**
- * __bio_integrity_endio - Integrity I/O completion function
- * @bio:	Protected bio
- *
- * Description: Completion for integrity I/O
- *
- * Normally I/O completion is done in interrupt context.  However,
- * verifying I/O integrity is a time-consuming task which must be run
- * in process context.	This function postpones completion
- * accordingly.
- */
-bool __bio_integrity_endio(struct bio *bio)
-{
-	struct blk_integrity *bi = blk_get_integrity(bio->bi_bdev->bd_disk);
-	struct bio_integrity_payload *bip = bio_integrity(bio);
-
-	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status && bi->csum_type) {
-		INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
-		queue_work(kintegrityd_wq, &bip->bip_work);
-		return false;
-	}
-
-	kfree(bvec_virt(bip->bip_vec));
-	bio_integrity_free(bio);
-	return true;
-}
-
 /**
  * bio_integrity_advance - Advance integrity vector
  * @bio:	bio whose integrity vector to update
@@ -644,15 +494,6 @@ void bioset_integrity_free(struct bio_set *bs)
 
 void __init bio_integrity_init(void)
 {
-	/*
-	 * kintegrityd won't block much but may burn a lot of CPU cycles.
-	 * Make it highpri CPU intensive wq with max concurrency of 1.
-	 */
-	kintegrityd_wq = alloc_workqueue("kintegrityd", WQ_MEM_RECLAIM |
-					 WQ_HIGHPRI | WQ_CPU_INTENSIVE, 1);
-	if (!kintegrityd_wq)
-		panic("Failed to create kintegrityd\n");
-
 	bip_slab = kmem_cache_create("bio_integrity_payload",
 				     sizeof(struct bio_integrity_payload) +
 				     sizeof(struct bio_vec) * BIO_INLINE_VECS,
-- 
2.45.2

