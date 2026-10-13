Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C694955D884
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924958; cv=none; b=eNI9i2P969my7Q2h7ceCbNrgMEZ6tlyVEXBAn/EPaAe6zevwQIKhwrvWpIHczmL9bdag9Ca/q/FGiL77BeZlaiEX6olwE/z/YFtQA1Eu9uXwRoV4viKY8q4T0/WbwgcsRKSEJBvWfAipecwdRU8d0Hu9ob/o9tXewL/ps86azR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924958; c=relaxed/simple;
	bh=BJdHB/ejV+CxAqyvc96eqP9MAroM09p6ojnCtOYYwsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tj+WNUliTEHadLB7ytzSraGMX+EDKa/P21U60tzosCzvfBpoz3oTuPE/rgtur+D1f6Bf0WXxd0tqc8hbpiVUz1VAWKLbTRUX/6V3PEdBEeN+ug4SEUHUY2avGfu7zajcHg0B3qtbCTz/ISc7rHXTNPZz62dNx7sxfwQ2VCaXfXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j3iM2k+9; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j3iM2k+9"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48de72fc832so382843f8f.1
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791924948; x=1792529748; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Az43PS/qS00pmQNyOpOlhDk/xvxDJzb8VYH9IXe9HrU=;
        b=j3iM2k+9o6B6TP9mCRRsupfPYUntueqDZ6sGT/2lrj8RCcpxCzHbR0lgb0SdCNlTWL
         YQOzyCBXzx4MRLb71/WuGsZX76TMa2rlTkMqkib6g6ttHd6rjLDopLnmPqZh3UA4sV8Z
         M1aAQ2fkLZerGo8/FZWnQNS2edraFpErkuxPMcHTRSx1Y0GeURAgwMlkVpRzxxh3Oi40
         2UzONpqsPmRMia/5dpyxFl8icDnNsfdVkWqpJd5uZlKsAyYChNAy9aDmls1QUHfT5KnN
         e4i82kj9Zl4d/yX43OZPzaisxJZPkQtDKcR/bbaq4hHQhyI6L2Eue3+kjwoLGfOHBlYv
         xXuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791924948; x=1792529748;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Az43PS/qS00pmQNyOpOlhDk/xvxDJzb8VYH9IXe9HrU=;
        b=w+FL6Rc/O+UCCLQwtQgicA20ujnFoW9qy3l+pKukhrW/m0E5cnYDUfWgfAEeVzATIJ
         UnvP+Xt6m3HUUMwJ5RgNxpCwlGQMgOYd7Og0Y5b0JFdMW5ZW/GSMHPRBKXtpqoKCAnoj
         xpCYiRnollO53spAcVlgg9+NKFJpdyQ/CoHAn3QDP22PvhyEp9A5zoAOb0NAg9Dd+NvG
         oIULIz+Ygg5UtXUTUgZ2LRYSUIhYa8CEsBVBXBi36FCZdTXt4M5okUPBaul1ODQ5ykpJ
         nMSn7fXaxHuCZRQdlk3OIf1HON5iHb7Sk9M5B9Q4db61ujY5C1GCmIIhJ96lt6Gx0Iov
         MzmA==
X-Forwarded-Encrypted: i=1; AKwUvBzyc7ntTDrYTxT/I0qhZ4mqsYHcsJfdFDybnXU47RtRp5mfAZRqW7qrRvTuc03s1iNL7QDNo897aQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYJuW91BAxVsOBJlmQhaTTSRhKDdFpowCb4RTYcpEti1ShxXW4pI
	fdh92ZoDdKdktF0+UXXeSDJEUu58avXrg1edOBCk8gPPFF83nQcxOLfh
X-Gm-Gg: AYBFou0L7mHnAUEdSbupFzU6xIMzukh+mjD6qeezKkZwObki/MqONsOu7QW+7IX8YPs
	2/7HbrdYQvkNvMWLstUHl32mmPkZV4bJWV6mdDMHQih44Wsws2hL0TzmhP6YurWcTL4+SthkNCe
	Kvg9gz/g0P+Bb+6s2F/CRpJLzC/xb3OdjJd2L7raFI6J+TEQF7SezcJSYNHLv4iDrsbPGisFtzi
	RZi1kKhrLQmF1KlT0b7esPV8ZXjn7qU/7K5cQNlfMW6SzKz7eH7pIjRrA5KjynC9Ola+TK4yl5d
	NYBFFEAWm9QJcxwE6KybmIctDe7l3Y4y5bV5aHRSyouJbD6No9Ih2jrXFiFaWFwd3CMwJXwjuAK
	7Bb7tCUC6SEFjphW3Hyf5MtF7FDia3Y0gjPQByZHRW6QJj0yO+laLqZCnKZRI2CM/ZRVp/40RH7
	m+PULBlBHyUZ7Y6T77LCyKyh0l3rhJQWn7tVI2ANowg6gjD0Fw0ASHl0517lhfeKHE7vTDFNiZs
	EkGUnxnzGsnw6NW5tB49buj62BrMA+WAV3AyieRv3f4/wkb+Pt8mFM/TyE8DrHkkvzFEabeCj/E
	OgaSCOI8q0U=
X-Received: by 2002:a05:6000:298e:10b0:487:2387:7c9 with SMTP id ffacd0b85a97d-48dbaadb47emr19950255f8f.14.1791924947986;
        Tue, 13 Oct 2026 13:55:47 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de7273a0esm2380730f8f.29.2026.10.13.13.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 13:55:46 -0700 (PDT)
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
Subject: [PATCH v10 13/13] io_uring/rsrc: add dmabuf backed registered buffers
Date: Tue, 13 Oct 2026 21:54:57 +0100
Message-ID: <a5ee0fca8c4ee18f159b0f014d30a721f428d8c0.1791924581.git.asml.silence@gmail.com>
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
 include/linux/io_uring_types.h |  5 +++
 include/uapi/linux/io_uring.h  |  6 ++-
 io_uring/Makefile              |  1 +
 io_uring/dma-buf.c             | 66 +++++++++++++++++++++++++++++
 io_uring/dma-buf.h             | 76 ++++++++++++++++++++++++++++++++++
 io_uring/rsrc.c                | 59 ++++++++++++++++++++++++--
 io_uring/rsrc.h                |  5 +++
 io_uring/rw.c                  | 33 +++++++++++----
 8 files changed, 237 insertions(+), 14 deletions(-)
 create mode 100644 io_uring/dma-buf.c
 create mode 100644 io_uring/dma-buf.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 90fea94ad202..73cd11d173df 100644
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
+	REQ_F_DMABUF_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -705,6 +707,8 @@ enum {
 	REQ_F_SQE_COPIED	= IO_REQ_FLAG(REQ_F_SQE_COPIED_BIT),
 	/* request must be iopolled to completion (set in ->issue()) */
 	REQ_F_IOPOLL		= IO_REQ_FLAG(REQ_F_IOPOLL_BIT),
+	/* there is a dma map attached to request that needs to be dropped */
+	REQ_F_DMABUF		= IO_REQ_FLAG(REQ_F_DMABUF_BIT),
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
index abb590833a0f..b456f45fa8de 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -811,6 +811,7 @@ enum io_uring_rsrc_reg_flags {
 enum io_uring_regbuf_type {
 	IO_REGBUF_TYPE_EMPTY,
 	IO_REGBUF_TYPE_UADDR,
+	IO_REGBUF_TYPE_DMABUF,
 
 	__IO_REGBUF_TYPE_MAX,
 };
@@ -820,7 +821,10 @@ struct io_uring_regbuf_desc {
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
diff --git a/io_uring/Makefile b/io_uring/Makefile
index c54e328d1410..965bb60e9f7b 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -26,3 +26,4 @@ obj-$(CONFIG_PROC_FS) += fdinfo.o
 obj-$(CONFIG_IO_URING_MOCK_FILE) += mock_file.o
 obj-$(CONFIG_IO_URING_BPF) += bpf_filter.o
 obj-$(CONFIG_IO_URING_BPF_OPS) += bpf-ops.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o
diff --git a/io_uring/dma-buf.c b/io_uring/dma-buf.c
new file mode 100644
index 000000000000..1a1a88640823
--- /dev/null
+++ b/io_uring/dma-buf.c
@@ -0,0 +1,66 @@
+#include "dma-buf.h"
+
+static inline void io_release_dmabuf(void *priv)
+{
+	struct io_buf_dma *bd = priv;
+
+	fput(bd->target_file);
+	dma_buf_io_ctx_release(bd->ctx);
+	kfree(bd);
+}
+
+int __io_register_dmabuf(struct io_ring_ctx *ctx,
+			struct io_uring_regbuf_desc *desc,
+			struct io_mapped_ubuf *imu)
+{
+	struct io_buf_dma *bd = NULL;
+	struct file *target_file = NULL;
+	struct dma_buf *dmabuf = NULL;
+	int ret;
+
+	if (ctx->flags & IORING_SETUP_IOPOLL)
+		return -EOPNOTSUPP;
+	if (desc->uaddr || desc->size)
+		return -EINVAL;
+
+	bd = kzalloc(sizeof(*bd), GFP_KERNEL);
+	if (!bd)
+		return -ENOMEM;
+
+	target_file = fget(desc->target_fd);
+	if (!target_file) {
+		ret = -EBADF;
+		goto err;
+	}
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
+				    &bd->ctx);
+	if (ret)
+		goto err;
+
+	bd->target_file = target_file;
+	imu->len = dmabuf->size;
+	imu->release = io_release_dmabuf;
+	imu->priv = bd;
+	imu->flags = IO_REGBUF_F_DMABUF | IO_REGBUF_F_UNCLONEABLE;
+	imu->dir = IO_BUF_DEST | IO_BUF_SOURCE;
+	dma_buf_put(dmabuf);
+	return 0;
+err:
+	kfree(bd);
+	if (target_file)
+		fput(target_file);
+	if (dmabuf)
+		dma_buf_put(dmabuf);
+	return ret;
+}
+
diff --git a/io_uring/dma-buf.h b/io_uring/dma-buf.h
new file mode 100644
index 000000000000..a876a9e5e272
--- /dev/null
+++ b/io_uring/dma-buf.h
@@ -0,0 +1,76 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_DMA_BUF_H
+#define IOU_DMA_BUF_H
+
+#include <linux/dma-buf-io.h>
+#include <linux/io_uring_types.h>
+
+#include "rsrc.h"
+
+struct io_buf_dma {
+	struct dma_buf_io_ctx		*ctx;
+	struct file			*target_file;
+};
+
+int __io_register_dmabuf(struct io_ring_ctx *ctx,
+			struct io_uring_regbuf_desc *desc,
+			struct io_mapped_ubuf *imu);
+
+static inline void io_detach_dmabuf_map(struct io_kiocb *req)
+{
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return;
+	if (!(req->flags & REQ_F_DMABUF) || !req->dmabuf_map)
+		return;
+	dma_buf_io_map_drop(req->dmabuf_map);
+	req->dmabuf_map = NULL;
+}
+
+static inline int io_attach_dmabuf_map(struct io_kiocb *req,
+					struct iov_iter *iter,
+					unsigned issue_flags)
+{
+	bool nowait = issue_flags & IO_URING_F_NONBLOCK;
+	struct dma_buf_io_map *map;
+	struct io_buf_dma *bd;
+
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return -EOPNOTSUPP;
+	if (!(req->flags & REQ_F_DMABUF))
+		return 0;
+
+	bd = req->buf_node->buf->priv;
+	map = dma_buf_io_get_map(bd->ctx, nowait);
+	if (unlikely(IS_ERR(map)))
+		return PTR_ERR(map);
+	req->dmabuf_map = map;
+	iter->dmabuf_map = map;
+	return 0;
+}
+
+static inline int io_import_dmabuf_map(struct io_kiocb *req,
+				int ddir, struct iov_iter *iter,
+				struct io_mapped_ubuf *imu,
+				size_t len, size_t offset)
+{
+	struct io_buf_dma *bd = imu->priv;
+
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return -EOPNOTSUPP;
+	if (req->file != bd->target_file)
+		return -EBADF;
+	req->flags |= REQ_F_DMABUF;
+	iov_iter_dmabuf_map(iter, ddir, NULL, offset, len);
+	return 0;
+}
+
+static inline int io_register_dmabuf(struct io_ring_ctx *ctx,
+			struct io_uring_regbuf_desc *desc,
+			struct io_mapped_ubuf *imu)
+{
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return -EOPNOTSUPP;
+	return __io_register_dmabuf(ctx, desc, imu);
+}
+
+#endif /* IOU_DMA_BUF_H */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index f42d201738cd..2e89e091afbb 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -10,6 +10,7 @@
 #include <linux/compat.h>
 #include <linux/io_uring.h>
 #include <linux/io_uring/cmd.h>
+#include <linux/dma-buf-io.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -19,6 +20,7 @@
 #include "rsrc.h"
 #include "memmap.h"
 #include "register.h"
+#include "dma-buf.h"
 
 struct io_rsrc_update {
 	struct file			*file;
@@ -898,6 +900,38 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 	return true;
 }
 
+static struct io_rsrc_node *io_register_dmabuf_desc(struct io_ring_ctx *ctx,
+						    struct io_uring_regbuf_desc *desc)
+{
+	struct io_rsrc_node *node = NULL;
+	struct io_mapped_ubuf *imu = NULL;
+	int ret;
+
+	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+
+	imu = io_alloc_imu(ctx, 0);
+	if (!imu) {
+		ret = -ENOMEM;
+		goto err;
+	}
+	memset(imu, 0, sizeof(*imu));
+	refcount_set(&imu->refs, 1);
+
+	ret = io_register_dmabuf(ctx, desc, imu);
+	if (ret)
+		goto err;
+	node->buf = imu;
+	return node;
+err:
+	if (imu)
+		io_free_imu(ctx, imu);
+	if (node)
+		io_cache_free(&ctx->node_cache, node);
+	return ERR_PTR(ret);
+}
+
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 						   struct io_uring_regbuf_desc *desc)
 {
@@ -918,6 +952,12 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (!mem_is_zero(&desc->__resv, sizeof(desc->__resv)) || desc->flags)
 		return ERR_PTR(-EINVAL);
 
+	if (desc->type == IO_REGBUF_TYPE_DMABUF)
+		return io_register_dmabuf_desc(ctx, desc);
+
+	if (desc->dmabuf_fd || desc->target_fd)
+		return ERR_PTR(-EINVAL);
+
 	if (desc->type == IO_REGBUF_TYPE_EMPTY) {
 		if (uaddr || size)
 			return ERR_PTR(-EFAULT);
@@ -1242,9 +1282,12 @@ static int io_import_kbuf(int ddir, struct iov_iter *iter,
 	return 0;
 }
 
-static int io_import_fixed(int ddir, struct iov_iter *iter,
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
@@ -1264,6 +1307,11 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	offset = buf_addr - imu->ubuf;
 
+	if (imu->flags & IO_REGBUF_F_DMABUF) {
+		if (!(import_flags & IO_REGBUF_IMPORT_ALLOW_DMABUF))
+			return -EFAULT;
+		return io_import_dmabuf_map(req, ddir, iter, imu, len, offset);
+	}
 	if (imu->flags & IO_REGBUF_F_KBUF)
 		return io_import_kbuf(ddir, iter, imu, len, offset);
 
@@ -1326,7 +1374,8 @@ int __io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	node = io_find_buf_node(req, issue_flags);
 	if (!node)
 		return -EFAULT;
-	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
+	return io_import_fixed(req, ddir, iter, node->buf, buf_addr, len,
+				issue_flags, import_flags);
 }
 
 static int io_buffer_acct_cloned_hpages(struct io_ring_ctx *ctx,
@@ -1753,7 +1802,9 @@ int __io_import_reg_vec(int ddir, struct iov_iter *iter,
 	iovec_off = vec->nr - nr_iovs;
 	iov = vec->iovec + iovec_off;
 
-	if (imu->flags & IO_REGBUF_F_KBUF) {
+	if (imu->flags & IO_REGBUF_F_DMABUF) {
+		return -EOPNOTSUPP;
+	} else if (imu->flags & IO_REGBUF_F_KBUF) {
 		int ret = io_kern_bvec_size(iov, nr_iovs, imu, &nr_segs);
 
 		if (unlikely(ret))
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 351995b61e68..d893cc5e580a 100644
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
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 999d9a1cc5a5..d33b925a848e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -23,6 +23,7 @@
 #include "rsrc.h"
 #include "poll.h"
 #include "rw.h"
+#include "dma-buf.h"
 
 static void io_complete_rw(struct kiocb *kiocb, long res);
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res);
@@ -358,13 +359,18 @@ static int io_init_rw_fixed(struct io_kiocb *req, unsigned int issue_flags,
 	struct io_async_rw *io = req->async_data;
 	int ret;
 
-	if (io->bytes_done)
-		return 0;
+	if (!io->bytes_done) {
+		ret = __io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
+					  issue_flags, IO_REGBUF_IMPORT_ALLOW_DMABUF);
+		if (ret)
+			return ret;
+		iov_iter_save_state(&io->iter, &io->iter_state);
+	}
 
-	ret = io_import_reg_buf(req, &io->iter, rw->addr, rw->len, ddir,
-				issue_flags);
-	iov_iter_save_state(&io->iter, &io->iter_state);
-	return ret;
+	ret = io_attach_dmabuf_map(req, &io->iter, issue_flags);
+	if (ret)
+		return ret;
+	return 0;
 }
 
 int io_prep_read_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -577,6 +583,8 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
+	io_detach_dmabuf_map(req);
+
 	/* ring owner may block in freeze_super() before task_work runs */
 	if (kiocb->ki_flags & IOCB_WRITE)
 		io_req_end_write(req);
@@ -698,7 +706,7 @@ static ssize_t loop_rw_iter(int ddir, struct io_rw *rw, struct iov_iter *iter)
 	    !(kiocb->ki_filp->f_flags & O_NONBLOCK))
 		return -EAGAIN;
 	if ((req->flags & REQ_F_BUF_NODE) &&
-	     (req->buf_node->buf->flags & IO_REGBUF_F_KBUF))
+	     (req->buf_node->buf->flags & (IO_REGBUF_F_KBUF|IO_REGBUF_F_DMABUF)))
 		return -EFAULT;
 
 	ppos = io_kiocb_ppos(kiocb);
@@ -1226,7 +1234,10 @@ int io_read_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	return io_read(req, issue_flags);
+	ret = io_read(req, issue_flags);
+	if (ret != -EIOCBQUEUED)
+		io_detach_dmabuf_map(req);
+	return ret;
 }
 
 int io_write_fixed(struct io_kiocb *req, unsigned int issue_flags)
@@ -1237,7 +1248,11 @@ int io_write_fixed(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	return io_write(req, issue_flags);
+	ret = io_write(req, issue_flags);
+	if (ret != -EIOCBQUEUED)
+		io_detach_dmabuf_map(req);
+	return ret;
+
 }
 
 void io_rw_fail(struct io_kiocb *req)
-- 
2.54.0

