Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD34556BBD
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924934; cv=none; b=Gq3ElHOSBfE0r1eE05xJ3EwGHWSwvniPZ3ylz+BdzonczdoZgZiaiqSpWpn9uzlaCBAoTk9zYpd7r93ov6FlnsVjE2R2CE6fAwbSI12dAFiNFYXO1p6nQvBRH9Cn4NrngdQ7YYcbCk4H7SQY0l630XmkRiSWRjlll4+/L/M0zqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924934; c=relaxed/simple;
	bh=WSYuJ2CSe5MQPAXNnecfuqbBxEyZXfqX7o9X0AvpCs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntOPrVW3UPg9C5I+uBcHa58cNIDx+p57Np+ET38iwDbFK91FgGqDBguKuCPJap/5XxOmIZ/c3DCxdxsDwlSZFP7BtXjwmvZtOPAxhhj+Ha4bPGIl2i/Dcc1vVRz5mn7zwcTGf5h3h28NhV4hDJ64BQkdgt8wALq2AHk/ROnv8f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TOIKN6+2; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TOIKN6+2"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48c4649b3aaso2155796f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791924923; x=1792529723; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VU42MfuIm5UeQYpyXXcu/MIJJ21cHTHg0N7CAKjDZ/U=;
        b=TOIKN6+2w0J28ki0vWLUNJSncJ59remJoo6iDjol/QJ2kgkGZDoaDKRlHXe8abnhwB
         0l8sEBqXMLG1E5e+eMLbSQZ5kdaB145j0ZbPE3KhjAKvbWwtPm0TT+T97SDIMdXzoD97
         kEhiWAYBwK90hEbAxm5MOB+3I7rUI9V+oH4TFkxEzKwqZ4Z6tLf3vrioX+3fyWs7MRn6
         oUaPi+DSta+D0XEsFLEtCsUiTe25kfBxxrtM5XNS7csbv2qNLqFHEfgd8IXOW+V7h6p+
         VMbpvkd3MS1djx4u93MV/kRhoILiZPQgmGzt2ghqbxEEmib9dHtbXsBzIR8fwJszV9P7
         rKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791924923; x=1792529723;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VU42MfuIm5UeQYpyXXcu/MIJJ21cHTHg0N7CAKjDZ/U=;
        b=jhLAY+nayddAHbbNACr3z81s+DT/FXQa9NtijSHtpu32Tz4OCo5PCfL/Rbyq4q61xL
         Io5bxpV9ixmisbjJuFNOc6XwR3HS/rDcPGWuXtgKiIpazxhw8KO09TNnufK9YiKQ+/rj
         OHSTOjaVrRVNuYMXEStIdHuQwvdZcw1YnBeQ154V8MPWGT9P0qp4VXG3xwG7Fi0+ZtZG
         zQ2qI3eIdFbt8MbpWzviF6GDqg0hUa2GGSic4+RjnP4kwzyq4awigI4kVxDUxem+tDDF
         BuZsv02r+uIpBgG9PkH+by/zCSBYjASf554Y2W6Ac7YGWSjk1tnvl1xu+1o7V8mOlldG
         p5pg==
X-Forwarded-Encrypted: i=1; AKwUvBzHYd/vNf09/YE+xjTMjeR3rtW4FUAck4iuWSZTXuS7PX6D2jiHPvRpvQ6PJGRfXpEneksS5NC3FQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYJfAVhhQ1cxipv+XYRIF53W9+2x4oEFnxDR1lbN4FiIygBDNdZf
	ksZxvvp3Bd3VwD+cr1UZWLNuO2n/7z4EX9F4LfjTXFCrFKZqnDUiodGt
X-Gm-Gg: AYBFou1Za57hrww431WwTQAr94VHYhJ9FhQVolUk8hgREUq/A70Dbsaz0rX2e/n2t9S
	Heb6+cFuz27qsUoHM8UTubDhf+hXWU9EBtnOCdzw7nYCsEXGJrdCBPQy6/c6oIPvOE7GH6WnHtL
	dxiwtNJulX9P/kRvg4s4RRq8/2+c88Py8mIau4I8+mmwSvn0dHyV3yrADeng+aX+MUQ3Lo+Othv
	GpNUh4mwi8Tp5hpslikvQg8rA5GmnkT4SCdyhBgklSRyrKekH5jaVuOUdHc6+YPvNiaGZCrGJd3
	jVWH+ajM+Ssr4+9xJ0kVU52zTuG1J3JHxkaOozUrb8SJJKhagOMiqUQM6nB2CHacJpY0rU5EvJG
	Ln6nxGdVy8/ZDdGjY9vClEs8yhDAdg7WBik1mw4CAZCWVxFGi6z/63RGakJQ1XyVpbalKjq2JOo
	VDMXZYG+N1rAg/2ZXu/3Xh3t5ou01eh3vtQWArqsmnhTlRxgkNEDGqyqLnjlrW9+tUdXuFfZJ5B
	S7eKvBaTkKxTVNDnmTjRD190JbBYN8qd7CPn16p/m3TeNY8tClH+g9WEZRVsp8Xm4CXLJ7a+KFy
	5gqP+bjt/LQ=
X-Received: by 2002:a05:6000:4594:b0:48d:debc:dc12 with SMTP id ffacd0b85a97d-48ddebcdc57mr8980574f8f.23.1791924922619;
        Tue, 13 Oct 2026 13:55:22 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de7273a0esm2380730f8f.29.2026.10.13.13.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 13:55:21 -0700 (PDT)
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
	Matthew Brost <matthew.brost@intel.com>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	dm-devel@lists.linux.dev
Subject: [PATCH v10 04/13] block: introduce dma map backed bio type
Date: Tue, 13 Oct 2026 21:54:48 +0100
Message-ID: <b0b9f8e5032a210af2028dcf1bc2157a236202d5.1791924581.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791924581.git.asml.silence@gmail.com>
References: <cover.1791924581.git.asml.silence@gmail.com>
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
 block/bio.c               | 15 +++++++++--
 block/blk-merge.c         | 52 +++++++++++++++++++++++++++++++++++++++
 block/blk-mq.c            |  6 +++++
 block/fops.c              |  2 +-
 include/linux/bio.h       |  9 ++++---
 include/linux/blk-mq.h    |  7 ++++++
 include/linux/blk_types.h | 14 ++++++++++-
 include/linux/bvec.h      |  3 ++-
 8 files changed, 99 insertions(+), 9 deletions(-)

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
index 258a726071d1..501ddc01c449 100644
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
@@ -493,6 +543,8 @@ unsigned int blk_recalc_rq_segments(struct request *rq)
 
 	if (!rq->bio)
 		return 0;
+	if (op_is_dmabuf(rq->bio->bi_opf))
+		return 1;
 
 	switch (bio_op(rq->bio)) {
 	case REQ_OP_DISCARD:
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e929f94b25c7..1b7f8cbbda8b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3150,6 +3150,12 @@ void blk_mq_submit_bio(struct bio *bio)
 		goto queue_exit;
 	}
 
+	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
+		bdev_has_integrity_csum(bio->bi_bdev))) {
+		bio_endio_status(bio, BLK_STS_NOTSUPP);
+		goto queue_exit;
+	}
+
 	if ((bio->bi_opf & REQ_POLLED) && !blk_mq_can_poll(q)) {
 		bio_endio_status(bio, BLK_STS_NOTSUPP);
 		goto queue_exit;
diff --git a/block/fops.c b/block/fops.c
index 9905ed24a157..827dc9eecba7 100644
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

