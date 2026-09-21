Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAE74A2069
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 13:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789998015; cv=none; b=j2bY8kvN1cj4jEQ+arbgvyCt2Ed/tduZJ88sNr44qv4ECrmiwGq+EscBJ/y9TJMq1Y4dSpoUB/XfL8BXQlnTlNGCkNBZA8AREMXwX3S0s8rdCtusDYN0c4/OMi73Ew5uorDOBqIRY1Jcx0MuId5XaM4Lv85JzMkDAF2HOseSlaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789998015; c=relaxed/simple;
	bh=rQeme4mOWh7F18Z9nPG3uk3qctIZf5OLv1gSfE+PgWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hvqvm8cEPYHFMpn/hVMp4MDjVfpHoS14kKZgqSWp3T7RkSITsBjo75w9QFlg4qTP4zgeTeADRIhqekfBAtrkrJWNzl3YSe4kvKwI/XesyjZ/ZjwjwvCNUZxWn/DP75B2tCbtgjWzbSJEWG6DZ+SXhTuoRQczTRmPd2EIa0xCzaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bRn6HQEy; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bRn6HQEy"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b912d37b5so17502095e9.2
        for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 06:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789998007; x=1790602807; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NH6ys1CTIdRnJg9xiwn6C8F70peAM9vhMfijPWQg7aQ=;
        b=bRn6HQEyqO5bt4XMNjV5YRFoJCGBMLW6l0/xNjqnBPcN6TcXe6WzpAGhOXP4bWVFjg
         FJPWjqSdm5QPwEwOCv8b5Zf7uZitvnolnTiaGv7vau7E2TjSA4YOvGxfWPtP4JcbmAni
         pbsGSY2BQ1Vh2W2K6KUNjNZewDMTadGrpHbMhrhE1b+EvPlLIoHMRpsbPwnKR6dJcHhI
         janlhM34N2LioRPZUVDx8t/T2YsLQAiLPTbNniZpM+dnS/5/3CXHWCmmIDv10PpaG+Oh
         LYkIQoQwDDyRQuQ2Ogp1Wz2an9UDqqAy632X8hwUhq4N0lHp7nEHWaEb+GM9MBdhvsVa
         pcKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789998007; x=1790602807;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NH6ys1CTIdRnJg9xiwn6C8F70peAM9vhMfijPWQg7aQ=;
        b=BKsZLF0QwKHb5KItMClDEQjr79TpMNgKUATl+hrLWx20lozNqItB8EYscYmEFSeuPH
         +KAwdHv0g1hEAGXbBT6COoPocKw7nFssvOGOmGNDp94CGyZkkMaipZCJ2hFmToG6Pmnq
         tTv15uXj0diIxpk7sBRIXjbGOU0V1wT2v9IKwTY+nT+itxeAzoqZhEf9mbrO0p/O8v5w
         DunJSyINoORCgV5zg3OmKZ8WdIpt36DLyXMMr/mhJROnZ4fhmVHYjiXIexE3fbXbiltG
         +qgpZUrwyH22maAZeQIYfpZkuYVcVEEAWJ4gZrokMYCTNO3PcCwMEYb28wmRyvjMDPVb
         eDjA==
X-Forwarded-Encrypted: i=1; AKwUvByMzQkwKe9TR7LG3YS3pwxObEGN3fONsqTK359K4zp/EUOCPsZpBtkJX6ydzwlMnZhSwbw8zGkraQ==@lists.linux.dev
X-Gm-Message-State: AFuF++lqxE3ync8XrMXR7EfHSCesgu8xBkXLX3oMd/PsBr/E2FaxyBmS
	zP6rbEc8a9qVmxFQBGPyVR3Gp2EEBnp8H9N8A3XgqER+HxfmzpJCdKYN
X-Gm-Gg: AYBFou1OkSyFiVLQnQgLTnhZsCNfRzA66YVY+nMfk2UNLWdzIlCcLxTBhLc7A/HMnnn
	SSaHTSQIvZuWAbyXuPDsIVyND8KlUCasQCKMdsxnmMarHOP6GniNCuD4Fvs7fQBDShAjfdptoa/
	kxZidfSZzZ5VMB0Bt+QKoCxM5/ZisFFm0xKTKJUTWzCu8DVFv8B4Xr/B4uu+WQmWbpSIUId6rVJ
	jWIwrTgnvrxuw/6U1dQNhJ3abfRRBIJjbDNpf37adEyVWFD+VYJZCaYSdDgVVTGzbIO8fnuGru4
	kM9tStZP6RfrcMBz2BiRK8vzHR8LHVV7kZGpFOBV+z9zWCv3w4/5oMyVSVTDSUr0r0J7xgmQL5v
	mu0l9BPfXzTPyb+lT+NDh8F1tX4Vooyo3FIvcnQcItkBZqjL7HybBr58Bv0F4PoD1NQMc9/WCuU
	dzQ/OURN6NnqxuEaxTJPbDLup0N3L+ZTV4XvWd2UUZDTbIGjqAFhExKHaLDVoK0arB3gnYC9Vvk
	rN0RCHVUvfd+/QPCm4IgZUmYO9aqNiTDsrmyVjfCVZF060Rnn7sDuJ55I1k9YLkOK4Lv1ANnzSC
	iy70LzZijqoEUIYC2XYd3j2mNPiVSQ==
X-Received: by 2002:a05:600c:8709:b0:49d:870:7a69 with SMTP id 5b1f17b1804b1-49fc573514bmr197593185e9.12.1789998007283;
        Mon, 21 Sep 2026 06:40:07 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-26.dab.02.net. [82.132.213.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc585920fsm617171605e9.4.2026.09.21.06.40.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:40:06 -0700 (PDT)
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
Subject: [PATCH v6 13/13] io_uring/rsrc: add dmabuf backed registered buffers
Date: Mon, 21 Sep 2026 14:38:57 +0100
Message-ID: <0d82253d5e930981e6a21503e145a1ebd280f995.1789997898.git.asml.silence@gmail.com>
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

Implement dmabuf backed registered buffers. To register them, the user
should specify IO_REGBUF_TYPE_DMABUF for the regitration and pass the
desired dmabuf fd and a file for which it should be registered.

From there, it can be used with io_uring read/write requests
IORING_OP_{READ,WRITE}_FIXED) as normal. The requests should be issued
against the file specified during registration, and otherwise they'll be
failed. The user should also be prepared to handle spurious -EAGAIN by
reissuing the request.

Internally, dmabuf registered buffers is an optin feature for io_uring
request opcodes and they should pass a special flag on import to use it.

Suggested-by: David Wei <dw@davidwei.uk>
Suggested-by: Vishal Verma <vishal1.verma@intel.com>
Suggested-by: Tushar Gohad <tushar.gohad@intel.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |   5 +
 include/uapi/linux/io_uring.h  |   6 +-
 io_uring/io_uring.c            |   3 +-
 io_uring/rsrc.c                | 161 ++++++++++++++++++++++++++++++++-
 io_uring/rsrc.h                |  18 ++++
 io_uring/rw.c                  |   6 +-
 6 files changed, 191 insertions(+), 8 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 90fea94ad202..3d41ca622114 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -11,6 +11,7 @@
 
 struct iou_loop_params;
 struct io_uring_bpf_ops;
+struct dma_buf_io_map;
 
 enum {
 	/*
@@ -610,6 +611,7 @@ enum {
 	REQ_F_IMPORT_BUFFER_BIT,
 	REQ_F_SQE_COPIED_BIT,
 	REQ_F_IOPOLL_BIT,
+	REQ_F_DROP_DMABUF_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -705,6 +707,8 @@ enum {
 	REQ_F_SQE_COPIED	= IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
 	/* request must be iopolled to completion (set in ->issue()) */
 	REQ_F_IOPOLL		= IO_REQ_FLAG(REQ_F_IOPOLL_BIT),
+	/* there is a dma map attached to request that needs to be dropped */
+	REQ_F_DROP_DMABUF	= IO_REQ_FLAG(REQ_F_DROP_DMABUF_BIT),
 };
 
 struct io_tw_req {
@@ -827,6 +831,7 @@ struct io_kiocb {
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
 	struct io_wq_work		work;
+	struct dma_buf_io_map		*dmabuf_map;
 
 	struct io_big_cqe {
 		u64			extra1;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 98b259901185..c39297e8beb6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -810,6 +810,7 @@ enum io_uring_rsrc_reg_flags {
 enum io_uring_regbuf_type {
 	IO_REGBUF_TYPE_EMPTY,
 	IO_REGBUF_TYPE_UADDR,
+	IO_REGBUF_TYPE_DMABUF,
 
 	__IO_REGBUF_TYPE_MAX,
 };
@@ -819,7 +820,10 @@ struct io_uring_regbuf_desc {
 	__u32 flags;
 	__u64 size;
 	__u64 uaddr;
-	__u64 __resv[7];
+
+	__s32 dmabuf_fd;
+	__s32 target_fd;
+	__u64 __resv[6];
 };
 
 /* Skip updating fd indexes set to this value in the fd table */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a67b2adeda36..267b2a43131a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -109,7 +109,7 @@
 
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | IO_REQ_LINK_FLAGS | \
 				 REQ_F_REISSUE | REQ_F_POLLED | \
-				 IO_REQ_CLEAN_FLAGS)
+				 IO_REQ_CLEAN_FLAGS | REQ_F_DROP_DMABUF)
 
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
@@ -1134,6 +1134,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 				io_queue_next(req);
 			if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
 				io_clean_op(req);
+			io_req_drop_dmabuf(req);
 		}
 		io_put_file(req);
 		io_req_put_rsrc_nodes(req);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 79e3c686ecc1..cb7495df13b7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -10,6 +10,7 @@
 #include <linux/compat.h>
 #include <linux/io_uring.h>
 #include <linux/io_uring/cmd.h>
+#include <linux/dma-buf-io.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -881,6 +882,93 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 	return true;
 }
 
+struct io_regbuf_dma {
+	struct dma_buf_io_ctx		*ctx;
+	struct file			*target_file;
+};
+
+static void io_release_reg_dmabuf(void *priv)
+{
+	struct io_regbuf_dma *db = priv;
+
+	fput(db->target_file);
+	dma_buf_io_ctx_release(db->ctx);
+}
+
+static struct io_rsrc_node *io_register_dmabuf(struct io_ring_ctx *ctx,
+						struct io_uring_regbuf_desc *desc)
+{
+	struct io_rsrc_node *node = NULL;
+	struct io_mapped_ubuf *imu = NULL;
+	struct io_regbuf_dma *regbuf = NULL;
+	struct file *target_file = NULL;
+	struct dma_buf *dmabuf = NULL;
+	int ret;
+
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return ERR_PTR(-EOPNOTSUPP);
+	if (ctx->flags & IORING_SETUP_IOPOLL)
+		return ERR_PTR(-EOPNOTSUPP);
+	if (desc->uaddr || desc->size)
+		return ERR_PTR(-EINVAL);
+
+	ret = -ENOMEM;
+	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+	imu = io_alloc_imu(ctx, 0);
+	if (!imu)
+		goto err;
+	regbuf = kzalloc(sizeof(*regbuf), GFP_KERNEL);
+	if (!regbuf)
+		goto err;
+
+	ret = -EBADF;
+	target_file = fget(desc->target_fd);
+	if (!target_file)
+		goto err;
+
+	dmabuf = dma_buf_get(desc->dmabuf_fd);
+	if (IS_ERR(dmabuf)) {
+		ret = PTR_ERR(dmabuf);
+		dmabuf = NULL;
+		goto err;
+	}
+	ret = io_validate_user_buf_range(0, dmabuf->size);
+	if (ret)
+		goto err;
+
+	ret = dma_buf_io_ctx_create(target_file, dmabuf, DMA_BIDIRECTIONAL,
+				    &regbuf->ctx);
+	if (ret)
+		goto err;
+
+	regbuf->target_file = target_file;
+	imu->nr_bvecs = 0;
+	imu->ubuf = 0;
+	imu->len = dmabuf->size;
+	imu->folio_shift = 0;
+	imu->release = io_release_reg_dmabuf;
+	imu->priv = regbuf;
+	imu->flags = IO_REGBUF_F_DMABUF;
+	imu->dir = IO_BUF_DEST | IO_BUF_SOURCE;
+	refcount_set(&imu->refs, 1);
+	node->buf = imu;
+	dma_buf_put(dmabuf);
+	return node;
+err:
+	kfree(regbuf);
+	if (imu)
+		io_free_imu(ctx, imu);
+	if (node)
+		io_cache_free(&ctx->node_cache, node);
+	if (target_file)
+		fput(target_file);
+	if (dmabuf)
+		dma_buf_put(dmabuf);
+	return ERR_PTR(ret);
+}
+
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 						   struct io_uring_regbuf_desc *desc)
 {
@@ -899,6 +987,12 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (!mem_is_zero(&desc->__resv, sizeof(desc->__resv)) || desc->flags)
 		return ERR_PTR(-EINVAL);
 
+	if (desc->type == IO_REGBUF_TYPE_DMABUF)
+		return io_register_dmabuf(ctx, desc);
+
+	if (desc->dmabuf_fd || desc->target_fd)
+		return ERR_PTR(-EINVAL);
+
 	if (desc->type == IO_REGBUF_TYPE_EMPTY) {
 		if (uaddr || size)
 			return ERR_PTR(-EFAULT);
@@ -1223,9 +1317,59 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 	return 0;
 }
 
-static int io_import_fixed(int ddir, struct iov_iter *iter,
+void io_drop_dmabuf_node(struct io_kiocb *req)
+{
+	struct io_mapped_ubuf *imu;
+
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return;
+	if (WARN_ON_ONCE(req->buf_node->type != IORING_RSRC_BUFFER))
+		return;
+	imu = req->buf_node->buf;
+	if (WARN_ON_ONCE(!(imu->flags & IO_REGBUF_F_DMABUF)))
+		return;
+	dma_buf_io_map_drop(req->dmabuf_map);
+	req->flags &= ~REQ_F_DROP_DMABUF;
+}
+
+static int io_import_dmabuf(struct io_kiocb *req,
+			   int ddir, struct iov_iter *iter,
+			   struct io_mapped_ubuf *imu,
+			   size_t len, size_t offset,
+			   unsigned issue_flags)
+{
+	bool nowait = issue_flags & IO_URING_F_NONBLOCK;
+	struct io_regbuf_dma *db = imu->priv;
+	struct dma_buf_io_map *map;
+
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return -EOPNOTSUPP;
+	if (!len)
+		return -EFAULT;
+	if (req->file != db->target_file)
+		return -EBADF;
+
+	if (req->flags & REQ_F_DROP_DMABUF) {
+		map = req->dmabuf_map;
+		goto init_iter;
+	}
+
+	map = dma_buf_io_get_map(db->ctx, nowait);
+	if (unlikely(IS_ERR(map)))
+		return PTR_ERR(map);
+	req->dmabuf_map = map;
+	req->flags |= REQ_F_DROP_DMABUF;
+init_iter:
+	iov_iter_dmabuf_map(iter, ddir, map, offset, len);
+	return 0;
+}
+
+static int io_import_fixed(struct io_kiocb *req,
+			   int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
-			   u64 buf_addr, size_t len)
+			   u64 buf_addr, size_t len,
+			   unsigned issue_flags,
+			   unsigned import_flags)
 {
 	const struct bio_vec *bvec;
 	size_t folio_mask;
@@ -1245,6 +1389,12 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	offset = buf_addr - imu->ubuf;
 
+	if (imu->flags & IO_REGBUF_F_DMABUF) {
+		if (!(import_flags & IO_REGBUF_IMPORT_ALLOW_DMABUF))
+			return -EFAULT;
+		return io_import_dmabuf(req, ddir, iter, imu, len, offset,
+					issue_flags);
+	}
 	if (imu->flags & IO_REGBUF_F_KBUF)
 		return io_import_kbuf(ddir, iter, imu, len, offset);
 
@@ -1307,7 +1457,8 @@ int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	node = io_find_buf_node(req, issue_flags);
 	if (!node)
 		return -EFAULT;
-	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
+	return io_import_fixed(req, ddir, iter, node->buf, buf_addr, len,
+				issue_flags, import_flags);
 }
 
 static int io_buffer_acct_cloned_hpages(struct io_ring_ctx *ctx,
@@ -1729,7 +1880,9 @@ int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 	iovec_off = vec->nr - nr_iovs;
 	iov = vec->iovec + iovec_off;
 
-	if (imu->flags & IO_REGBUF_F_KBUF) {
+	if (imu->flags & IO_REGBUF_F_DMABUF) {
+		return -EOPNOTSUPP;
+	} else if (imu->flags & IO_REGBUF_F_KBUF) {
 		int ret = io_kern_bvec_size(iov, nr_iovs, imu, &nr_segs);
 
 		if (unlikely(ret))
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 351995b61e68..8e36a954169e 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -28,6 +28,11 @@ struct io_rsrc_node {
 enum {
 	IO_REGBUF_F_KBUF		= 1 << 0,
 	IO_REGBUF_F_UNCLONEABLE		= 1 << 1,
+	IO_REGBUF_F_DMABUF		= 1 << 3,
+};
+
+enum {
+	IO_REGBUF_IMPORT_ALLOW_DMABUF		= 1 << 1,
 };
 
 struct io_mapped_ubuf {
@@ -170,4 +175,17 @@ static inline void io_alloc_cache_vec_kasan(struct iou_vec *iv)
 		io_vec_free(iv);
 }
 
+void io_drop_dmabuf_node(struct io_kiocb *req);
+
+static inline void io_req_drop_dmabuf(struct io_kiocb *req)
+{
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return;
+	if (!(req->flags & REQ_F_DROP_DMABUF))
+		return;
+	if (WARN_ON_ONCE(!(req->flags & REQ_F_BUF_NODE)))
+		return;
+	io_drop_dmabuf_node(req);
+}
+
 #endif
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0c9494fd21be..a13dd2138c06 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -367,8 +367,8 @@ static int io_init_rw_fixed(struct io_kiocb *req, unsigned int issue_flags,
 	if (io->bytes_done)
 		return 0;
 
-	ret = io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
-				issue_flags);
+	ret = __io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
+				  issue_flags, IO_REGBUF_IMPORT_ALLOW_DMABUF);
 	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
@@ -583,6 +583,8 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
+	io_req_drop_dmabuf(req);
+
 	/* ring owner may block in freeze_super() before task_work runs */
 	if (kiocb->ki_flags & IOCB_WRITE)
 		io_req_end_write(req);
-- 
2.54.0

