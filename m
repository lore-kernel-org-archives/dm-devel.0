Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325A8342CB2
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337394; cv=none; b=njve2na898HjtdQ/A9X7sdEQZBinGI2LcoDhMMJrC7CcP77zgU0ST+X3J1fhXuAMSQZAZXdsmHm6/VWVzZbK7SxhxTUvhU8/0bE+/sEKZzIhPTGEfyFK5TVxXhWqsLqQpDqbxeeDTSXRbFcYuAwPmRqf5/PprU/vq5Cq640OAec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337394; c=relaxed/simple;
	bh=74XT/YcpL6u3pCQJh393Sbt1vl2bLCbf4FmkhI3qmoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tITCZlqV2ZUT6iH7Qx81Ij587LqoTUHsAJiCNgl72VtVwpicWJJiHfGYI3WjbDBSKUID5Rk1vrKEhdUl5L1SjhP8en60q9QewmdYG2jgomiIbF0xnkhLMifH8TXYJNRZwHWywcsnSLRnjf7YsuZ+WFremv4D5TxqQqdFfdqt4wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J6kRVTX2; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J6kRVTX2"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a020e65269so9829285e9.2
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:43:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791337390; x=1791942190; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=A+VjBFsuZYeJUSxMs311afilNm9e5ulL53j6D1D3BK4=;
        b=J6kRVTX2Fq7lEay6zWMJYE94wuUMoHNy7x0hOo9x2CChU5N3mLQmxEDNjQgff6n/0q
         QQltHz9dgUiKCAs4vbJlmffR4E0wlhCI4OsU6jfCZKJz0at26jvtUPBHwGzeOLQXFz50
         WI0u6w1yzRmDiRM/s+JjlGL7kR5DlTp75xhQQUgR8lH46PZrAF/IDusXl507d0kOePE+
         YGCTwXn9cHpqDSuSACJ694K5wcHVVku+SZtUBr+kF1sIcn2WiSL+h64GA7aV3jRhLzRm
         Y+S8EDLzpPfAciW6HewIEix6Z9DFecasYFs96O+qTVoN7YJdnsUm+lmeTIsarLLF7Nme
         pNVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791337390; x=1791942190;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=A+VjBFsuZYeJUSxMs311afilNm9e5ulL53j6D1D3BK4=;
        b=Z76Qn6BdyMkIp5oYYVhpOYQTiImzqvFYwKDs8IxLpxFpAt60+eLcJo7KpxpMQTdmGz
         F7O5Kn5E/H4JwWcM68xVZ39HnOOqWPVfXPF3ZfX5l4xJOUG3kiomAeNR91VuiALLh3iW
         8VMdRbJsBOXYUQ4EXe16s4myejaLXIY2PulWpN1SUjo800md2g7IhDmrc08XWgkkZ0Fa
         EA/UbJ5CV5CODB8Fx6MDxvbyTIrmK69prNuslp8T/hZVrBGEZwjzK7iAYd4C9Cxh0sXL
         zIGD2uCZgcKP8dt0i63UjpDJZLBwDvcFVpRpwumESCeqzdYLqtybX+AsLLq0QoXS/5+W
         +Ftw==
X-Forwarded-Encrypted: i=1; AKwUvBypJrbj3vwX847UFANz0+bQRzM+L5JMnl8QCiUXfr5CMBSmWdxk3UWhBjpJ6DT5KI7WMUdqCufhsw==@lists.linux.dev
X-Gm-Message-State: AFuF++nrpdhYTExfsYhk1Vb7pkp1f117MV9bAhHMR9rg7Zqjz83Ds2MX
	CGtmGzBJI08KqQJyQouDlXxt/WHZOD+NyeNsK5m6dXaWcyrSe1hC8HDp
X-Gm-Gg: AYBFou0BFHHgpSJ/2ZcPlAA55KgJoLljEpZlL9QAcN0J4Cl+bpDSMl9exVYTfN/JFvE
	AcVR2A+6UCa7v59+nTEOzZcRrcVmHWMqloF/u9YawLjFxT3iKEYUEmE15B7wxWlqkfncO/yPd2M
	QIxb7j/9mMIEnsVcuxHpQTVfFnawKrtU/QWHkoTRZX2tk3jsljbC3kN33ummcdiP7El3n1vT352
	Ay/McpZsCJQPMlJCRu1axHSZ/ea0xFiPQj08qDrScT4LscK+7lVsurBywiKHas4HIQ2kbMe50YL
	6caeRIjoJwxVv04CHOidOsiLTvaWhbAmld8/eum1r5brK5VqtSN9Itj9OnNcOVd40i3cAea4p81
	DuJBaCEfhH8JOp0jLM4ApX3Y4ivCf9eghMlVBNGNByu38jd67pTBaDtC7RZ1MIdRXwV3tN7PyMs
	GRzHP+vqSWMOJqE23VJ81vu0T7ad6bAOaj+nMD4PSCxNDgIwqMKuTAQOYDFxKdngzPxiMaj/+TU
	y/R2FPmVEpBKKy8KcQsn+0PF7Tzs3UCEf18TCHJHweQBIWHpId326q3VxrJ+L5GwmsRnVq/nOcC
	RBlJL0qUhuA=
X-Received: by 2002:a05:600c:a00e:b0:4a0:1a18:b742 with SMTP id 5b1f17b1804b1-4a1800d3de4mr8466785e9.2.1791337390371;
        Tue, 06 Oct 2026 18:43:10 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f653d7csm26423895e9.14.2026.10.06.18.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:43:09 -0700 (PDT)
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
Subject: [PATCH v9 01/13] dma-buf: introduce initial file I/O infrastructure
Date: Wed,  7 Oct 2026 02:42:44 +0100
Message-ID: <b44df9fed6e346110c504ee312bb0083c7e75574.1791336930.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791336930.git.asml.silence@gmail.com>
References: <cover.1791336930.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The goal is to be able to natively use dma-buf in the read-write / IO
path. This patch adds basic building blocks serving as a glue and API
between drivers and upper layer subsystems providing the uAPI. Later
patches implement it for NVMe raw block devices and expose it to the
user space via io_uring.

There are two main objects. struct dma_buf_io_ctx and struct
dma_buf_io_map. The ctx is used during initial registration and serves
as an interface between the upper layer user like io_uring and to the
importer subsystem / driver. The map represents the actual dma map
established for the target device[s] with dma_buf_map_attachment() and
stored in a device specific format. The context is created via a new
file operation ->init_dma_buf_io_ctx.

The ctx-map separation exists to facilitate map invalidation (see
dma_buf_io_invalidate_mappings()). A ctx can create
multiple maps during its lifetime, but there can only be no more than
one (active) map attached to it. Invalidation drops the active map
if present, and any new I/O request will try to create a new one.

The primary task of dma_buf_io_map is to count requests using it
and wait for their completion when we want to destroy the DMA map.

[un]mapping and any work with dma addresses is delegated to the
importer driver via an ops table stored in the ctx, see struct
dma_buf_io_ops. Only the target driver / subsystem knows about devices
it wants to use the dma-buf with, especially in case of multi-device
filesystems or stacking in the future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/dma-buf/Makefile     |   2 +-
 drivers/dma-buf/dma-buf-io.c | 183 +++++++++++++++++++++++++++++++++++
 include/linux/dma-buf-io.h   | 105 ++++++++++++++++++++
 include/linux/fs.h           |   2 +
 4 files changed, 291 insertions(+), 1 deletion(-)
 create mode 100644 drivers/dma-buf/dma-buf-io.c
 create mode 100644 include/linux/dma-buf-io.h

diff --git a/drivers/dma-buf/Makefile b/drivers/dma-buf/Makefile
index b25d7550bacf..523731b0f83e 100644
--- a/drivers/dma-buf/Makefile
+++ b/drivers/dma-buf/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-y := dma-buf.o dma-fence.o dma-fence-array.o dma-fence-chain.o \
-	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o
+	 dma-fence-unwrap.o dma-resv.o dma-buf-mapping.o dma-buf-io.o
 obj-$(CONFIG_DMABUF_HEAPS)	+= dma-heap.o
 obj-$(CONFIG_DMABUF_HEAPS)	+= heaps/
 obj-$(CONFIG_SYNC_FILE)		+= sync_file.o
diff --git a/drivers/dma-buf/dma-buf-io.c b/drivers/dma-buf/dma-buf-io.c
new file mode 100644
index 000000000000..9ba9c17f900a
--- /dev/null
+++ b/drivers/dma-buf/dma-buf-io.c
@@ -0,0 +1,183 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common infrastructure for supporing dma-buf in the I/O path.
+ *
+ * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
+ */
+#include <linux/dma-buf-io.h>
+#include <linux/dma-resv.h>
+
+static void dma_buf_io_map_release(struct dma_buf_io_map *map)
+{
+	struct dma_buf_io_ctx *ctx = map->ctx;
+
+	dma_resv_assert_held(ctx->dmabuf->resv);
+
+	percpu_ref_exit(&map->refs);
+	ctx->dev_ops->unmap(ctx, map);
+}
+
+static void dma_buf_io_map_refs_cb(struct percpu_ref *ref)
+{
+	struct dma_buf_io_map *map = container_of(ref, struct dma_buf_io_map, refs);
+
+	complete(&map->drained);
+}
+
+static void dma_buf_io_kill_map(struct dma_buf_io_ctx *ctx)
+{
+	struct dma_buf_io_map *map;
+
+	dma_resv_assert_held(ctx->dmabuf->resv);
+
+	map = rcu_dereference_protected(ctx->map,
+				dma_resv_held(ctx->dmabuf->resv));
+	if (!map)
+		return;
+
+	rcu_assign_pointer(ctx->map, NULL);
+	percpu_ref_kill(&map->refs);
+	/* make sure the map is not visible via ctx->map */
+	synchronize_rcu_expedited();
+	wait_for_completion(&map->drained);
+	dma_buf_io_map_release(map);
+}
+
+int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map,
+			struct sg_table *sgt)
+{
+	unsigned seg_shift = ~0U;
+	struct scatterlist *sg;
+	unsigned long tmp;
+	int ret;
+
+	for_each_sgtable_dma_sg(sgt, sg, tmp)
+		seg_shift = min(seg_shift, __ffs(sg_dma_len(sg)));
+
+	ret = percpu_ref_init(&map->refs, dma_buf_io_map_refs_cb, 0, GFP_KERNEL);
+	if (ret)
+		return ret;
+	init_completion(&map->drained);
+	map->min_seg_shift = seg_shift;
+	map->ctx = ctx;
+	return 0;
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_io_init_map, "DMA_BUF");
+
+static struct dma_buf_io_map *__dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
+{
+	struct dma_buf *dmabuf = ctx->dmabuf;
+	struct dma_buf_io_map *map;
+	long ret;
+
+	dma_resv_assert_held(dmabuf->resv);
+
+	if (ctx->is_dead)
+		return ERR_PTR(-ENOENT);
+
+	map = __dma_buf_io_get_map(ctx);
+	if (map)
+		return map;
+
+	map = ctx->dev_ops->map(ctx);
+	if (IS_ERR(map))
+		return map;
+
+	if (WARN_ON_ONCE(!map->min_seg_shift))
+		return ERR_PTR(-EFAULT);
+
+	ret = dma_resv_wait_timeout(dmabuf->resv, DMA_RESV_USAGE_KERNEL,
+				    true, MAX_SCHEDULE_TIMEOUT);
+	if (ret <= 0) {
+		if (!ret)
+			ret = -EAGAIN;
+		dma_buf_io_map_release(map);
+		return ERR_PTR(ret);
+	}
+
+	/* get a reference for the caller */
+	percpu_ref_get(&map->refs);
+	rcu_assign_pointer(ctx->map, map);
+	return map;
+}
+
+struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx)
+{
+	struct dma_buf_io_map *map;
+	int ret;
+
+	ret = dma_resv_lock_interruptible(ctx->dmabuf->resv, NULL);
+	if (ret)
+		return ERR_PTR(ret);
+
+	map = __dma_buf_io_create_map(ctx);
+	dma_resv_unlock(ctx->dmabuf->resv);
+	return map;
+}
+
+static void dma_buf_io_ctx_shutdown(struct dma_buf_io_ctx *ctx)
+{
+	dma_resv_lock(ctx->dmabuf->resv, NULL);
+	ctx->is_dead = true;
+	dma_buf_io_kill_map(ctx);
+	dma_resv_unlock(ctx->dmabuf->resv);
+}
+
+int dma_buf_io_ctx_create(struct file *file,
+			   struct dma_buf *dmabuf,
+			   enum dma_data_direction dir,
+			   struct dma_buf_io_ctx **out_ctx)
+{
+	struct dma_buf_io_ctx *ctx;
+	int ret;
+
+	if (!file->f_op->init_dma_buf_io_ctx)
+		return -EOPNOTSUPP;
+
+	ctx = kzalloc_obj(*ctx);
+	if (!ctx)
+		return -ENOMEM;
+	ctx->dir = dir;
+	ctx->dmabuf = dmabuf;
+	get_dma_buf(dmabuf);
+
+	ret = file->f_op->init_dma_buf_io_ctx(file, ctx);
+	if (ret) {
+		kfree(ctx);
+		dma_buf_put(dmabuf);
+		return ret;
+	}
+
+	if (WARN_ON_ONCE(!ctx->dev_ops ||
+			 !ctx->dev_ops->map ||
+			 !ctx->dev_ops->unmap ||
+			 !ctx->dev_ops->release))
+		return -EINVAL;
+
+	*out_ctx = ctx;
+	return 0;
+}
+
+void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx)
+{
+	dma_buf_io_ctx_shutdown(ctx);
+
+	if (WARN_ON_ONCE(rcu_dereference_protected(ctx->map, true)))
+		return;
+
+	ctx->dev_ops->release(ctx);
+	dma_buf_put(ctx->dmabuf);
+	kfree(ctx);
+}
+
+void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx)
+{
+	dma_buf_io_kill_map(ctx);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_io_invalidate_mappings, "DMA_BUF");
+
+void dma_buf_io_detach(struct dma_buf_io_ctx *ctx)
+{
+	dma_buf_io_ctx_shutdown(ctx);
+}
+EXPORT_SYMBOL_NS_GPL(dma_buf_io_detach, "DMA_BUF");
diff --git a/include/linux/dma-buf-io.h b/include/linux/dma-buf-io.h
new file mode 100644
index 000000000000..8ac338df51ff
--- /dev/null
+++ b/include/linux/dma-buf-io.h
@@ -0,0 +1,105 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __DMA_BUF_IO_H__
+#define __DMA_BUF_IO_H__
+
+#include <linux/dma-buf.h>
+
+struct dma_buf_io_ctx;
+struct dma_buf_io_map;
+
+struct dma_buf_io_ops {
+	/*
+	 * Create a new map for the given ctx. Called with the reservation
+	 * lock held.
+	 */
+	struct dma_buf_io_map *(*map)(struct dma_buf_io_ctx *ctx);
+
+	/*
+	 * Clean up device specific parts of the @map. Called with the
+	 * reservation lock held.
+	 */
+	void (*unmap)(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map);
+
+	/*
+	 * The user tries to destroy the ctx. Release all device specific
+	 * parts of the token.
+	 */
+	void (*release)(struct dma_buf_io_ctx *);
+};
+
+struct dma_buf_io_map {
+	/*
+	 * Counts attached requests and other users. Device specific unmapping
+	 * is deferred until all refs are dropped.
+	 */
+	struct percpu_ref		refs;
+	/*
+	 * Shift for the minimum segment size of the mapping.
+	 */
+	unsigned			min_seg_shift;
+
+	struct dma_buf_io_ctx		*ctx;
+	struct completion		drained;
+};
+
+struct dma_buf_io_ctx {
+	struct dma_buf_io_map __rcu		*map;
+	struct dma_buf				*dmabuf;
+	enum dma_data_direction			dir;
+	bool					is_dead;
+
+	void					*dev_priv;
+	const struct dma_buf_io_ops		*dev_ops;
+};
+
+int dma_buf_io_ctx_create(struct file *file,
+			   struct dma_buf *dmabuf,
+			   enum dma_data_direction dir,
+			   struct dma_buf_io_ctx **ctx);
+void dma_buf_io_ctx_release(struct dma_buf_io_ctx *ctx);
+
+struct dma_buf_io_map *dma_buf_io_create_map(struct dma_buf_io_ctx *ctx);
+
+static inline struct dma_buf_io_map *
+__dma_buf_io_get_map(struct dma_buf_io_ctx *ctx)
+{
+	struct dma_buf_io_map *map;
+
+	guard(rcu)();
+
+	map = rcu_dereference(ctx->map);
+	if (unlikely(!map || !percpu_ref_tryget_live_rcu(&map->refs)))
+		return NULL;
+
+	return map;
+}
+
+static inline struct dma_buf_io_map *
+dma_buf_io_get_map(struct dma_buf_io_ctx *ctx, bool nowait)
+{
+	struct dma_buf_io_map *map;
+
+	map = __dma_buf_io_get_map(ctx);
+	if (likely(map))
+		return map;
+
+	if (nowait)
+		return ERR_PTR(-EAGAIN);
+	return dma_buf_io_create_map(ctx);
+}
+
+static inline void dma_buf_io_map_drop(struct dma_buf_io_map *map)
+{
+	percpu_ref_put(&map->refs);
+}
+
+/*
+ * Device API
+ */
+
+void dma_buf_io_invalidate_mappings(struct dma_buf_io_ctx *ctx);
+int dma_buf_io_init_map(struct dma_buf_io_ctx *ctx, struct dma_buf_io_map *map,
+			struct sg_table *sgt);
+void dma_buf_io_detach(struct dma_buf_io_ctx *ctx);
+
+#endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index f9d1e05e8ae6..05c1ff495732 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1914,6 +1914,7 @@ struct dir_context {
 #define COPY_FILE_SPLICE		(1 << 0)
 
 struct io_uring_cmd;
+struct dma_buf_io_ctx;
 struct offset_ctx;
 
 struct file_operations {
@@ -1960,6 +1961,7 @@ struct file_operations {
 	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
 				unsigned int poll_flags);
 	int (*mmap_prepare)(struct vm_area_desc *);
+	int (*init_dma_buf_io_ctx)(struct file *, struct dma_buf_io_ctx *);
 } __randomize_layout;
 
 /* Supports async buffered reads */
-- 
2.54.0

