Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 912B04A2607
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 13:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997978; cv=none; b=jNfPwqD6hByLQdmrq+dwDNH3zlnuGsOW3es3DivAX01Op58sSgRJkISdpm/h3PolO1jG9yH5gj+7OXlpJ5OBh4U2t1tu5xRCsINZ2JHnn8iEuqSrrWHVowUNQdt/hI1WaACgBMNEa3yLtVY7GLJ2jwrHYTwj3OwRcktu6WtiyaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997978; c=relaxed/simple;
	bh=SPDNlCQKU7wLOqZjUSkqlJqBFbH1fKRBG8UUakIzbGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i6UHPsf6txvhQpAmw/s3B3uneUQVmItvlsNjTpT8+wkPkTISVZzIV76nltLMM2ycQ3w7JCZD6FzaSkV8q7tVEorChJFvxnqevEcJqBMEqm1SBdch2CZh7mE9aUirE11NKbpfP/GcC36YaYS/lxhwAx/B8TWfQitsnuI/X1o7NKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MvWoodGa; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MvWoodGa"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e79a408deso16963435e9.2
        for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 06:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997974; x=1790602774; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dxtQQDz5ZZ2oYc2awZZ8esOC2pl4iP5YFfGRHxTLRW8=;
        b=MvWoodGaf42OyvdSBZEI0ObPVPv/4jCjBI6h8+eCo5Iu/a0vrBr33Zw3JxzzAMH/t+
         4j3AwuypyjRUU8in2DtuZvvurzJXBusYlNXBu1twB/Hb1hUodPU3Uulxg7LDO75lKHwO
         +/8/940QbZHiXwkZH4o1Poa0Bx9I9dD7Nak4dv0DnJh+k73o/egz/TQ8onHJ98PwrEvU
         0iJDQmuT/GO+mCXLzYQ6Yv/biVWuTSB8/jMKVLM8q2tABnZ+HSxUNX73x6IeE1PVDY72
         Ye8zIEfpnWHVq9S/ay31SWxTKkK7MIMOYwEycNyPLzv/JZaAlu9YrHrKe63lpxxlFWIN
         9+SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997974; x=1790602774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dxtQQDz5ZZ2oYc2awZZ8esOC2pl4iP5YFfGRHxTLRW8=;
        b=L9YfXjTzi3jF+891WDCqc/uk5PGiPaEpXqhe8Mq/AvzfLde81tXY+wKgNgsGGqjS33
         RNP5jZXa2RH1vfmk6oU+XgmA0+gzomEMbSht0VeoaGL6ibDdp9QRKhWSNsYAwLdU7GZZ
         efXTvi6f7MbHB9Fi20Cgb6M/h/O0FjSEtRDJVzbPyuERJeF799ZLWAmGsQj957jkExRJ
         1NVqCC+SNYMuTaHQu664T9kjZzs+nMZ3ZyFxePoRw2bsYtSX/osMMGi4qZE/wY4k8zsx
         6Tf7jfJcQ8pMyc6OGRX1/9uDap6s0koyGmbHOE9dEohd8hopapnxZMRyszIp4FJcIms+
         HZkA==
X-Forwarded-Encrypted: i=1; AKwUvBwsz0yhFsZiW+9OQat763iGYc8Ec4ohm7pds3sxMAGpKrPGBCyoigluigpeAcZEtIJv8jHMf9lrxA==@lists.linux.dev
X-Gm-Message-State: AFuF++kXq/mnl2tQpeuIrNtne1fFESrYRkDayV+pxgpcAa+ouooOOPTT
	I4fvLXwvEYdiv84f2yr1oq7aZI2p624wP53qAldTuIgAOil/ODegNHl0
X-Gm-Gg: AYBFou0M3PiXUaohtGaLbboRLbbaZSvlWKvRTu0iYEzy3Jcd7NwxhBYzYMm1FN0O7Ww
	xez9cGb1/SECPFRcx5NdLOm2KwWRbeaXfVqIbaKOAZktT/cloFhxJnxxxlie1cpLAVrzw9mtIFn
	hXo6GoYIRCarZlARZLJfyy2rO0SoFEY92cRSsspjRNq6NKOUgI+7VRtPTFvM6sP7dKTCYNqFfiO
	uGQ4eO2vr66VpjHtjqzV2SlG+CcBuhsvcMYf+vtRm5rusUg7+RG/QpXo0LpBEeVwoPXSDHmpTp2
	MQBtTz6LAB87g9UDpVVqZ55PabXdLOKwE9YOyQC+rBEVvx5m0vAvWp+2/xCE43fOQaM1I7jvzA3
	3+8FNgtWN4DDzvmxQ/sspLP5+SdJNh2d9qMn2CvrGVFxoLLF5ZBmiQLy7bP98rFr6bPpB99z5AM
	GspokOAmZABOuaMl5zWNV8YC72UqYc1VIIgV3ae+5KcQNbGMSYBZvTY9JCMzDHvpQoj7UnOaoT+
	PlxJngLcxCBl8OEfw1G96zYDkVr8mN0eqsU2albWMjUJ9RIoY8OsyrD3e89Zf5dQMPXN1FonL2K
	duVaQ86jCT40Oxcrz9zO/NrLxrMjSw==
X-Received: by 2002:a05:600d:1a:b0:49e:6778:c2bd with SMTP id 5b1f17b1804b1-49fc5a10c99mr131242505e9.6.1789997973654;
        Mon, 21 Sep 2026 06:39:33 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-26.dab.02.net. [82.132.213.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc585920fsm617171605e9.4.2026.09.21.06.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:39:32 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: linux-block@vger.kernel.org
Cc: asml.silence@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v6 04/13] block: introduce dma map backed bio type
Date: Mon, 21 Sep 2026 14:38:48 +0100
Message-ID: <a3ee719abc440ca139f1a945fdaf43a45f0c6b57.1789997898.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1789997898.git.asml.silence@gmail.com>
References: <cover.1789997898.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Premapped buffers don't require a generic bio_vec since these have
already been dma mapped. Repurpose the bi_io_vec space to strore dmabuf
maps as they are mutually exclusive.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c               | 15 +++++++++++--
 block/blk-merge.c         | 45 +++++++++++++++++++++++++++++++++++++++
 block/fops.c              |  2 +-
 include/linux/bio.h       |  9 ++++----
 include/linux/blk-mq.h    |  7 ++++++
 include/linux/blk_types.h | 14 +++++++++++-
 include/linux/bvec.h      |  3 ++-
 7 files changed, 86 insertions(+), 9 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b48091c7663f..1e0d9714c541 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -881,7 +881,11 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 	bio->bi_write_stream = bio_src->bi_write_stream;
 	bio->bi_bvec_gap_bit = bio_src->bi_bvec_gap_bit;
 	bio->bi_iter = bio_src->bi_iter;
-	bio->bi_io_vec = bio_src->bi_io_vec;
+
+	if (op_is_dmabuf(bio->bi_opf))
+		bio->bi_dmabuf_map = bio_src->bi_dmabuf_map;
+	else
+		bio->bi_io_vec = bio_src->bi_io_vec;
 
 	if (bio->bi_bdev) {
 		if (bio->bi_bdev == bio_src->bi_bdev &&
@@ -1204,16 +1208,23 @@ EXPORT_SYMBOL_GPL(__bio_release_pages);
 
 bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter)
 {
-	if (!iov_iter_is_bvec(iter))
+	if (!iov_iter_is_bvec(iter) && !iov_iter_is_dmabuf_map(iter))
 		return false;
 
 	WARN_ON_ONCE(bio->bi_max_vecs);
 
+	static_assert(offsetof(struct bio, bi_io_vec) ==
+		      offsetof(struct bio, bi_dmabuf_map));
+	static_assert(offsetof(struct iov_iter, bvec) ==
+		      offsetof(struct iov_iter, dmabuf_map));
+
 	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
 	bio->bi_iter.bi_idx = 0;
 	bio->bi_iter.bi_offset = iter->iov_offset;
 	bio->bi_iter.bi_size = iov_iter_count(iter);
 	bio_set_flag(bio, BIO_CLONED);
+	if (iov_iter_is_dmabuf_map(iter))
+		bio->bi_opf |= REQ_NOMERGE | REQ_DMABUF;
 	return true;
 }
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 258a726071d1..f0ece378c2d1 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -9,6 +9,7 @@
 #include <linux/blk-integrity.h>
 #include <linux/part_stat.h>
 #include <linux/blk-cgroup.h>
+#include <linux/dma-buf-io.h>
 
 #include <trace/events/block.h>
 
@@ -319,6 +320,36 @@ static inline unsigned int bvec_seg_gap(struct bio_vec *bvprv,
 	return bv->bv_offset | (bvprv->bv_offset + bvprv->bv_len);
 }
 
+static inline int bio_split_io_at_dmabuf(struct bio *bio,
+		const struct queue_limits *lim, unsigned *segs,
+		unsigned max_bytes, unsigned len_align_mask,
+		unsigned start_align_mask)
+{
+	unsigned bytes = min(bio->bi_iter.bi_size, max_bytes);
+	unsigned seg_shift = bio->bi_dmabuf_map->min_seg_shift;
+	unsigned offset = bio->bi_iter.bi_offset & ((1U << seg_shift) - 1);
+	u64 max_segs_bytes;
+
+	if ((bio->bi_iter.bi_offset & start_align_mask) ||
+	    (bio->bi_iter.bi_size & len_align_mask))
+		return -EINVAL;
+
+	/* single contiguous range into the dma-buf */
+	*segs = 1;
+
+	/*
+	 * Limit by the number of segments. We don't expose the underlying
+	 * mapping layout, but with a known minimum segment size, any I/O
+	 * consisting of N full segments should be able to cover at least
+	 * this much.
+	 */
+	max_segs_bytes = (u64)lim->max_segments << seg_shift;
+	bytes = min_t(u64, bytes, max_segs_bytes - offset);
+	if (bytes != bio->bi_iter.bi_size)
+		return bytes;
+	return 0;
+}
+
 /**
  * bio_split_io_at - check if and where to split a bio
  * @bio:  [in] bio to be split
@@ -346,6 +377,19 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		len_align_mask |= (bc->bc_key->crypto_cfg.data_unit_size - 1);
 	}
 
+	if (op_is_dmabuf(bio->bi_opf)) {
+		int ret;
+
+		ret = bio_split_io_at_dmabuf(bio, lim, &nsegs, max_bytes,
+					     len_align_mask, start_align_mask);
+		if (ret < 0)
+			return ret;
+		if (!ret)
+			goto out;
+		bytes = ret;
+		goto split;
+	}
+
 	bio_for_each_bvec(bv, bio, iter) {
 		if (bv.bv_offset & start_align_mask ||
 		    bv.bv_len & len_align_mask)
@@ -376,6 +420,7 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		bvprvp = &bvprv;
 	}
 
+out:
 	*segs = nsegs;
 	bio->bi_bvec_gap_bit = ffs(gaps);
 	return 0;
diff --git a/block/fops.c b/block/fops.c
index b182d0b30748..09fa42f8d8fa 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -362,7 +362,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	 * Users don't rely on the iterator being in any particular
 	 * state for async I/O returning -EIOCBQUEUED, hence we can
 	 * avoid expensive iov_iter_advance(). Bypass
-	 * bio_iov_iter_get_pages() and set the bvec directly.
+	 * bio_iov_iter_get_pages() and set the bvec/dmabuf directly.
 	 */
 	if (!bio_iov_iter_set(bio, iter)) {
 		ret = blkdev_iov_iter_get_pages(bio, iter, bdev);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 892ca469c570..7a794ce723b8 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -80,7 +80,8 @@ static inline bool bio_no_advance_iter(const struct bio *bio)
 {
 	return bio_op(bio) == REQ_OP_DISCARD ||
 	       bio_op(bio) == REQ_OP_SECURE_ERASE ||
-	       bio_op(bio) == REQ_OP_WRITE_ZEROES;
+	       bio_op(bio) == REQ_OP_WRITE_ZEROES ||
+	       op_is_dmabuf(bio->bi_opf);
 }
 
 static inline void *bio_data(struct bio *bio)
@@ -438,12 +439,12 @@ static inline void bio_wouldblock_error(struct bio *bio)
 
 /*
  * Calculate number of bvec segments that should be allocated to fit data
- * pointed by @iter. If @iter is backed by bvec it's going to be reused
- * instead of allocating a new one.
+ * pointed by @iter. If @iter is backed by a bvec or a dmabuf, the bvec array /
+ * the dma map are going to be reused, and so no extra allocation is required.
  */
 static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
 {
-	if (iov_iter_is_bvec(iter))
+	if (iov_iter_is_bvec(iter) || iov_iter_is_dmabuf_map(iter))
 		return 0;
 	return iov_iter_npages(iter, max_segs);
 }
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index af878597afb8..7c7504c84e09 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -1017,6 +1017,13 @@ static inline void *blk_mq_rq_to_pdu(struct request *rq)
 	return rq + 1;
 }
 
+static inline bool blk_mq_rq_is_dmabuf(struct request *rq)
+{
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return false;
+	return rq->bio && op_is_dmabuf(rq->bio->bi_opf);
+}
+
 static inline struct blk_mq_hw_ctx *queue_hctx(struct request_queue *q, int id)
 {
 	struct blk_mq_hw_ctx *hctx;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 98e21b4cbf32..0cc09b975d8f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -233,7 +233,12 @@ struct bio {
 	atomic_t		__bi_remaining;
 
 	/* The actual vec list, preserved by bio_reset() */
-	struct bio_vec		*bi_io_vec;
+	union {
+		struct bio_vec		*bi_io_vec;
+		/* Driver specific dma map, valid IFF REQ_DMABUF is set */
+		struct dma_buf_io_map	*bi_dmabuf_map;
+	};
+
 	struct bvec_iter	bi_iter;
 
 	union {
@@ -402,6 +407,7 @@ enum req_flag_bits {
 	__REQ_DRV,		/* for driver use */
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
 	__REQ_ATOMIC,		/* for atomic write operations */
+	__REQ_DMABUF,		/* Using premmaped dma buffers */
 	/*
 	 * Command specific flags, keep last:
 	 */
@@ -434,6 +440,7 @@ enum req_flag_bits {
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
+#define REQ_DMABUF	(__force blk_opf_t)(1ULL << __REQ_DMABUF)
 
 #define REQ_NOUNMAP	(__force blk_opf_t)(1ULL << __REQ_NOUNMAP)
 
@@ -487,6 +494,11 @@ static inline bool op_is_discard(blk_opf_t op)
 	return (op & REQ_OP_MASK) == REQ_OP_DISCARD;
 }
 
+static inline bool op_is_dmabuf(blk_opf_t op)
+{
+	return op & REQ_DMABUF;
+}
+
 /*
  * Check if a bio or request operation is a zone management operation.
  */
diff --git a/include/linux/bvec.h b/include/linux/bvec.h
index fc566ee1c1ff..b63914ff56e3 100644
--- a/include/linux/bvec.h
+++ b/include/linux/bvec.h
@@ -108,7 +108,8 @@ struct bvec_iter {
 	unsigned int		bi_idx;
 
 	/*
-	 * Current offset in the bvec entry pointed to by `bi_idx`.
+	 * Current offset in the bvec entry pointed to by `bi_idx` or into
+	 * a dma-buf map.
 	 */
 	unsigned int		bi_offset;
 } __packed __aligned(4);
-- 
2.54.0

