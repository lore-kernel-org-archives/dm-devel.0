Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F844C9E1C
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 13:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602375; cv=none; b=HhjjKxmxLkrwNkxI7C8tAReE02OsSmb23eUbPRrE8HeeKZeNl2ztoKz+aEgTL9mzjDFc8m8HIP6OFnbqC8sqWblb8BA7sbhDkyf5kxi1nZRJIx27Jd+5N8rNkiKSPlM6AutJ3LXzxvf/1ZyzSy5xXe77QRphPUbgaEcJxdzF3fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602375; c=relaxed/simple;
	bh=j3pz2Fuj7nVIXtfL0+9vjgtsmZcjqUTN9QEUrQrBWDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1XOA/4wseBRhFHTQZQP3uqyxo4aAyC5t7cWzSJlNQHVv43v6DSuk5vr6jWgi4/MXnYSV7ZlxzwZD2Hd6eeVoPhmQ6f19jK7GbYhtD5CFruU9mXKKGI0GsUxRpHoTc1GacC283M75SsVJ5J2P/iCgyidbvAwxH8lY3x0XiC/YQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M7o8RVAs; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M7o8RVAs"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ffa15f67fso10580285e9.2
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 06:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790602370; x=1791207170; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AhzjnL4sENHY8mgNL3frpr16ZkLf9hho77d9PMQT7Tw=;
        b=M7o8RVAsNMwHhHhvLGIWJexbRj9Zj5JbWuvAu9rHNTo1H4omsddqRKzmu38v0uxPi0
         Ni5vlQRSgrR6DyC5Sw5qEJMS45jhYjcaub6YUFOsVu8raKQbLb6073123YIcr01/+CzN
         KLWlMSCxmyuVzJVdO6nTZG3TsT6+yjb6zAcT97sXDNX1/byRVc9lfossSikBQY+3GdiT
         MmiTF9eWOIweGqsNdMP6TD8yH5Q7nQZz0l+sIUduGCO/Sr2SC8xQOxQ/ylOdZIZl7Srh
         tr9q/aNO5GPkUJBTNZgZAdug+36nnS70p+p48AhGp08LyQ/F4IRzeZwfdb+lq78OTh/S
         8iHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790602370; x=1791207170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AhzjnL4sENHY8mgNL3frpr16ZkLf9hho77d9PMQT7Tw=;
        b=pOIL0fpQFtFdI+qVAKshHiIMreWX/zyXJ1PZaCzRRkwoTCirWChzXTEYicq546eGmf
         czV4gyPRfRx05AcZUq4QXcFuISnCXrz/OWoXIukWaoKQlyXw12Bgg36I8D32Pbhsc2br
         cVTB4HqS7Xql1sBle2vXK9O7gZBaacF8IrZa3QD65uHmVMzCAXB/mlgAOcICuClBg+Ad
         dLVfqg1WhKQrPGdJ0unRSTCFAyqfw3vI2LpL727ZFWWuNPYZKSCOsmB+x4TNlOKClV9R
         qO1Ee9RuDHrz7fpMn3VYE1b7Un49r/KNZX9Rfg7GPT7sSPOOi24akIocDT+Sg5atTSo8
         aPNg==
X-Forwarded-Encrypted: i=1; AKwUvBzfy1uyCIO17Iss6vqSmGsnRHDymqwRCoSzX0xZ0cgzP3YCiVSy2Cc4wAzuVB3FmATtTeMxQX6C2Q==@lists.linux.dev
X-Gm-Message-State: AFuF++lYhcTqeV4khshy2NESPfy9dbjZiEE4mYpvWT1gOaSWAxvMQRnb
	kIdEegrqzm506XtysDrLIs7sZTksVKWCGYIQi3btzE1c6uC9PBPHR6m7
X-Gm-Gg: AYBFou3ce+Mf+2651XfsZxoKdRrsLRWMztL4IKs/5XroeNb/p4Ak4j45RzDNhUgQmk9
	bIzUfZr7OT01JjThdAbnqtlsn7EYJa86Dzeg9ibhlKkTyAqGpYJj0Nkj2WO9rH4j6yCV81v2VSz
	kp79v+sU+niv8IdebNVqFr0gjaUsCghLJgnoN5oA1rAWHek1+8UO9WQFm/jwVuvMlBiGOQkON7L
	WeEHHhgNsMQPQ3i3wC4JoXB1jx5FhWbxv7dB+JQPdPJHPtsn9ErRsnADaQOFPQC0zyUS6MJ3NKX
	H2SKUf68S9OFXzeEHZLS+kbu1kL6tuwsJFsN0tC0O69PB17VnTh47a5kVZG6X+eeMrmr8VyFNfQ
	Je9VjIuJjYHFbmpYrbt2LA6xNrPM17B0YJJJSALsUH31wbqQ66Jedh/i80IEX3+bTz3UtUDMCXG
	Gv/AvRurqIgGK8xUFVnueBFhOWWSibSC6XoQFU/Rq0iba6wio7xaW88RdpeoSmFT5P7vDNC1n+J
	Xo+sMWiWZWAeC6No1UnBgo/k4URolzizCtXh8ZCd1F6GXaJf1KbpIwgYpGqN5LOVmGNETHUC3Wj
X-Received: by 2002:a05:600c:4709:b0:49f:fbad:29c1 with SMTP id 5b1f17b1804b1-49ffbad2d61mr102147255e9.33.1790602369885;
        Mon, 28 Sep 2026 06:32:49 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a349731sm28090164f8f.12.2026.09.28.06.32.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 06:32:49 -0700 (PDT)
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
Subject: [PATCH v7 04/13] block: introduce dma map backed bio type
Date: Mon, 28 Sep 2026 14:32:20 +0100
Message-ID: <6fe0d7c85c2f981c5caab3d1532b6c73c604cdb1.1790602223.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1790602223.git.asml.silence@gmail.com>
References: <cover.1790602223.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Premapped buffers don't require a generic bio_vec since these have
already been dma mapped. Repurpose the bi_io_vec space to store dmabuf
maps as they are mutually exclusive.

The bio splitting differs from the normal path because it's already
pre-mapped and for the block layer it's just an offset into the dma-buf.
The actual segmentation is only available to the importer driver and not
the block layer, however, it doesn't contain alignment gaps and we don't
have to check it. For the same reason we can't precisely split by the
number of segments, but we use ->min_seg_shift stored in the map to
calculate the minimum number of bytes a request consisting of
lim->max_segments full segments can cover and split by that. It's
stricter and can add extra splitting. E.g. for a {4K, 4G} segmentation,
the min segment size is 4K, and we'll split it into bios of
(4K * lim->max_segments) bytes each, but it should be good enough for
now to cover the most popular use cases.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c               | 15 ++++++++++--
 block/blk-merge.c         | 50 +++++++++++++++++++++++++++++++++++++++
 block/fops.c              |  2 +-
 include/linux/bio.h       |  9 +++----
 include/linux/blk-mq.h    |  7 ++++++
 include/linux/blk_types.h | 14 ++++++++++-
 include/linux/bvec.h      |  3 ++-
 7 files changed, 91 insertions(+), 9 deletions(-)

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
index 258a726071d1..18f014ff3314 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -9,6 +9,7 @@
 #include <linux/blk-integrity.h>
 #include <linux/part_stat.h>
 #include <linux/blk-cgroup.h>
+#include <linux/dma-buf-io.h>
 
 #include <trace/events/block.h>
 
@@ -319,6 +320,41 @@ static inline unsigned int bvec_seg_gap(struct bio_vec *bvprv,
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
+	/*
+	 * dma-buf maps don't expose the underlying segmentation, but they're
+	 * guaranteed to not have alignment gaps, we only need to check the
+	 * start and length alignment.
+	 */
+	if ((bio->bi_iter.bi_offset & start_align_mask) ||
+	    (bio->bi_iter.bi_size & len_align_mask))
+		return -EINVAL;
+
+	/* Presented as a single contiguous range into the dma-buf */
+	*segs = 1;
+
+	/*
+	 * Limit by the number of segments by using the minimal segment size.
+	 * Any I/O consisting of N full segments should be able to cover at
+	 * least N multiplied by the segment size. It's stricter than walking
+	 * the segments and might cause extra splitting.
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
@@ -346,6 +382,19 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
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
@@ -376,6 +425,7 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		bvprvp = &bvprv;
 	}
 
+out:
 	*segs = nsegs;
 	bio->bi_bvec_gap_bit = ffs(gaps);
 	return 0;
diff --git a/block/fops.c b/block/fops.c
index 4d1ab0311b4d..641621db700f 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -363,7 +363,7 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	 * Users don't rely on the iterator being in any particular
 	 * state for async I/O returning -EIOCBQUEUED, hence we can
 	 * avoid expensive iov_iter_advance(). Bypass
-	 * bio_iov_iter_get_pages() and set the bvec directly.
+	 * bio_iov_iter_get_pages() and set the bvec/dmabuf directly.
 	 */
 	if (!bio_iov_iter_set(bio, iter)) {
 		ret = blkdev_iov_iter_get_pages(bio, iter, bdev);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 10ece05cbf43..47aef63dba3b 100644
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
@@ -444,12 +445,12 @@ static inline void bio_wouldblock_error(struct bio *bio)
 
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

