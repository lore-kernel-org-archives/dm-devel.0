Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BCF35C6AE
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791336746; cv=none; b=LaoVQUVkkeTUcHCdosxrqaA3whlRHRMMTM1vl102k69FUHID6rRlo1oqlUKg0H/DFzFZ38QuOJxz5jhpb+mukqIUar7xlrwfq5LKZOiO6nDERjfoowUKDyTnEQCv2fjt1lprJKNsoM9/HuC8AyNI56pwUjY23MXpFH+lN3Xa5nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791336746; c=relaxed/simple;
	bh=QPXU2/SLnQ7AORSgIx0ttp54lxWXmErk0iSxoqmcFWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uz9ACA8oMW9Ew5v89BH8dwaai8EktpxdWjw7UL0q4SLaQRB1che78EocmQ7alMqhA9cUXcvWkwKTHSSLJrs3k+wet4m/NPktjEBDSqCR6wztaxXZhpcH/znosNZMLN94TI8khJqlkCNUvu7+hBpjaSpeFMpr6ofuBsc9sInfn2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qNUkdOQU; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qNUkdOQU"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a02718da81so10886955e9.1
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791336742; x=1791941542; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aoanzUq8HIZ5IYwt+xH4d2szWfJuaAfjXc9CmDQwbK8=;
        b=qNUkdOQU3JQ5c4/cuSCBALZU8Eppgm2gmKJUVH2ulXJtvHUDd703xTUT/30L0stVrj
         WZ5Lb6OreEHVvfWVF2LYtNFGgNMagB1VmsfnxeY8cTy7Z7Aa/Ir5voJ02h0b5h62anX3
         FstnZQE6ao7IpACoG3dqp4Bv3Leg7aoVznrGodC0AdjG1YwAfZjaHnmS/x8Rki61WznM
         pwjW5TwBZdUD4PqybMD3l8+FutRx954touRmUHWPNnQxs96ZPZe244uyyOk6waMgpG+n
         rCPzymvK5Njvhink7+iM/ClwEBL5VdKl+SD7CFprKR14sSKV94r3FGGwdOMMRnQ3TdVs
         hxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791336742; x=1791941542;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aoanzUq8HIZ5IYwt+xH4d2szWfJuaAfjXc9CmDQwbK8=;
        b=dQkg7ReqMdRDXtrcZK1tDsu0DUlzu1cYPcHiCLCsFkYKnOrvNYqa3wgAh/jIwqyXfn
         rmjpsCNsLLJkvVRCEyHCPFelaVMIF2BXz/QCd67f5RCEXuguI6w+Cxyut+r7iPhmveDk
         9EmBmAiXJMKEuZ/IRIB92+6zaw+iXBKQMnpYRCrUEAaA3YvaY2M9lDBuqKQc02CZSeh+
         7cYsbxQLeI1yvNSir9EyoOq9+rUw8LU1G2UXIxzp6LVpWQubjnXhngf2uJVPUkfJ/WW/
         1c/GUeVohHExxdHEWBdAZVtOiE987KlPmzOzWzVscHCeCH9mvVfgUgeh3rdL+/oySLXb
         aM+g==
X-Forwarded-Encrypted: i=1; AKwUvBwYDCMbXcH65yvCrSOAILm1QSVNeIMiC47xStb2Li8nsMk+ZBeYJBNyr4njmKY7ePmkxmyO6jlvJA==@lists.linux.dev
X-Gm-Message-State: AFuF++nr6s1SZmmxR/RvqQr3WjcGqXtSM/qShkR+1CDHccOwlHgkmXvj
	9OxexKXClYWUEFZ4GXvNJgj3C3tRDz4/qgzfCds6zgWfDXhv44EYAp2L
X-Gm-Gg: AYBFou0k7jw4TXu4f22XxRMwBn0eulAXWrYBG7oSNn6+g3u/uOqzJxXh++9Bb535Jp4
	XS9/2cFUQ37ecyzuMoP3HFmvCGl22REK1oICeZRu46v+dwQFoSBXI0Ft2ayC/ezRahFEvwI9dKu
	iOPXFFpgqH3E4sLg6qYPcIxGSAzDZwxghgFrifErVeudd4u84s8BVuZrP6fvrwnSgGFTL2Xs1F8
	3Ddyt8yKknnTdzU8BKzoW8k60Mvkx79n9ID0x6tnyqtHZLc5VJpOfcVXmEtjHc0rgq6qnaoIlru
	QgeNAdaGkoigP/YbbGdeG7TJXE+DhMFjkXKxXZ3K1cmOSlQJt/XJCfgjoViI2tDIp7Awvz+gNRn
	kM0+213m2EWU3NrE4MYUPXrkj3z4DeHCr5BFE4OffAmWyhjKUmaRrFzZs5doEgQpUMGKRrNkDOz
	Trvi4oDrL861m2QLh8vf5zMUVy8Th9d9d+qJZfvIqL50tShJ/MK6TwC8L2MD3VRmQBKsgIcfYo5
	K2ihs1BVKu1PLT4q2Fc5498h94TsEnbuaFgPx84Rceo2u8gtgxXKU/bSgIZjcKqWcqQkrHOmujZ
X-Received: by 2002:a05:600c:a087:b0:49e:6861:50f7 with SMTP id 5b1f17b1804b1-4a1802e94a5mr7710125e9.5.1791336741653;
        Tue, 06 Oct 2026 18:32:21 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f6538b7sm21183615e9.13.2026.10.06.18.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:32:20 -0700 (PDT)
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
Subject: [PATCH v8 06/13] nvme seaparate file
Date: Wed,  7 Oct 2026 02:31:49 +0100
Message-ID: <442b27c0019950bec9b4de5b022db6a95633b14d.1791336002.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791336002.git.asml.silence@gmail.com>
References: <cover.1791336002.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/Makefile     |   1 +
 drivers/nvme/host/pci-dmabuf.c | 164 ++++++++++++++++++++++
 drivers/nvme/host/pci-dmabuf.h |  73 ++++++++++
 drivers/nvme/host/pci.c        | 246 +++------------------------------
 4 files changed, 255 insertions(+), 229 deletions(-)
 create mode 100644 drivers/nvme/host/pci-dmabuf.c
 create mode 100644 drivers/nvme/host/pci-dmabuf.h

diff --git a/drivers/nvme/host/Makefile b/drivers/nvme/host/Makefile
index 67563a69f7dc..8288b986d713 100644
--- a/drivers/nvme/host/Makefile
+++ b/drivers/nvme/host/Makefile
@@ -21,6 +21,7 @@ nvme-core-$(CONFIG_NVME_HWMON)		+= hwmon.o
 nvme-core-$(CONFIG_NVME_HOST_AUTH)	+= auth.o
 
 nvme-y					+= pci.o
+nvme-$(CONFIG_DMA_SHARED_BUFFER)	+= pci-dmabuf.o
 
 nvme-fabrics-y				+= fabrics.o
 
diff --git a/drivers/nvme/host/pci-dmabuf.c b/drivers/nvme/host/pci-dmabuf.c
new file mode 100644
index 000000000000..d58a38a75d67
--- /dev/null
+++ b/drivers/nvme/host/pci-dmabuf.c
@@ -0,0 +1,164 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
+ */
+
+#include <linux/dma-resv.h>
+
+#include "pci-dmabuf.h"
+
+static void nvme_dmabuf_invalidate_mappings(struct dma_buf_attachment *attach)
+{
+	struct dma_buf_io_ctx *ctx = attach->importer_priv;
+
+	dma_buf_io_invalidate_mappings(ctx);
+}
+
+static const struct dma_buf_attach_ops nvme_dmabuf_importer_ops = {
+	.invalidate_mappings	= nvme_dmabuf_invalidate_mappings,
+	.allow_peer2peer	= true,
+};
+
+static struct dma_buf_io_map *nvme_dma_buf_io_map(struct dma_buf_io_ctx *ctx)
+{
+	unsigned nr_entries = ctx->dmabuf->size / NVME_CTRL_PAGE_SIZE;
+	struct nvme_dma_buf_io_ctx *nvme_ctx = ctx->dev_priv;
+	struct dma_buf_attachment *attach = nvme_ctx->attach;
+	unsigned long tmp, i = 0;
+	struct nvme_dmabuf_map *map;
+	struct scatterlist *sg;
+	struct sg_table *sgt;
+	int ret;
+
+	dma_resv_assert_held(ctx->dmabuf->resv);
+
+	if (ctx->dmabuf->size % NVME_CTRL_PAGE_SIZE)
+		return ERR_PTR(-EINVAL);
+
+	map = kvmalloc_flex(*map, dma_list, nr_entries);
+	if (!map)
+		return ERR_PTR(-ENOMEM);
+	map->nr_entries = nr_entries;
+
+	sgt = dma_buf_map_attachment(attach, ctx->dir);
+	if (IS_ERR(sgt)) {
+		ret = PTR_ERR(sgt);
+		sgt = NULL;
+		goto err;
+	}
+
+	for_each_sgtable_dma_sg(sgt, sg, tmp) {
+		dma_addr_t dma_addr = sg_dma_address(sg);
+		unsigned long sg_len = sg_dma_len(sg);
+
+		if ((sg_len % NVME_CTRL_PAGE_SIZE) ||
+		    (dma_addr % NVME_CTRL_PAGE_SIZE)) {
+			ret = -EINVAL;
+			goto err;
+		}
+		while (sg_len) {
+			map->dma_list[i++] = dma_addr;
+			dma_addr += NVME_CTRL_PAGE_SIZE;
+			sg_len -= NVME_CTRL_PAGE_SIZE;
+		}
+	}
+
+	ret = dma_buf_io_init_map(ctx, &map->base, sgt);
+	if (ret)
+		goto err;
+	map->sgt = sgt;
+	return &map->base;
+err:
+	if (sgt)
+		dma_buf_unmap_attachment(attach, sgt, ctx->dir);
+	kvfree(map);
+	return ERR_PTR(ret);
+}
+
+static void nvme_dma_buf_io_unmap(struct dma_buf_io_ctx *ctx,
+		struct dma_buf_io_map *map_base)
+{
+	struct nvme_dma_buf_io_ctx *nvme_ctx = ctx->dev_priv;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(map_base);
+
+	dma_resv_assert_held(ctx->dmabuf->resv);
+
+	dma_buf_unmap_attachment(nvme_ctx->attach, map->sgt, ctx->dir);
+	kvfree(map);
+}
+
+static void nvme_dma_buf_io_release(struct dma_buf_io_ctx *base_ctx)
+{
+	struct nvme_dma_buf_io_ctx *ctx = base_ctx->dev_priv;
+	struct nvme_dma_buf_list *buf_list = ctx->buf_list;
+
+	mutex_lock(&buf_list->lock);
+	if (!list_empty(&ctx->list)) {
+		dma_buf_detach(ctx->base->dmabuf, ctx->attach);
+		list_del_init(&ctx->list);
+	}
+	mutex_unlock(&buf_list->lock);
+
+	nvme_put_ctrl(ctx->ctrl);
+	kfree(ctx);
+}
+
+void __nvme_pci_remove_dmabuf(struct nvme_dma_buf_list *list)
+{
+	struct nvme_dma_buf_io_ctx *ctx, *tmp;
+
+	mutex_lock(&list->lock);
+	list_for_each_entry_safe(ctx, tmp, &list->ctxs, list) {
+		dma_buf_io_detach(ctx->base);
+		dma_buf_detach(ctx->base->dmabuf, ctx->attach);
+		list_del_init(&ctx->list);
+	}
+	mutex_unlock(&list->lock);
+}
+
+const struct dma_buf_io_ops nvme_dma_buf_io_ops = {
+	.map		= nvme_dma_buf_io_map,
+	.unmap		= nvme_dma_buf_io_unmap,
+	.release	= nvme_dma_buf_io_release,
+};
+
+static int nvme_init_io_ctx_locked(struct nvme_ctrl *ctrl,
+		struct nvme_dma_buf_list *buf_list,
+		struct dma_buf_io_ctx *ctx)
+{
+	struct nvme_dma_buf_io_ctx *nvme_ctx;
+	struct dma_buf_attachment *attach;
+
+	nvme_ctx = kzalloc_obj(*nvme_ctx);
+	if (!nvme_ctx)
+		return -ENOMEM;
+
+	attach = dma_buf_dynamic_attach(ctx->dmabuf, ctrl->dev,
+					&nvme_dmabuf_importer_ops, ctx);
+	if (IS_ERR(attach)) {
+		kfree(nvme_ctx);
+		return PTR_ERR(attach);
+	}
+
+	nvme_get_ctrl(ctrl);
+	list_add(&nvme_ctx->list, &buf_list->ctxs);
+	nvme_ctx->attach = attach;
+	nvme_ctx->base = ctx;
+	nvme_ctx->ctrl = ctrl;
+	nvme_ctx->buf_list = buf_list;
+	ctx->dev_priv = nvme_ctx;
+	ctx->dev_ops = &nvme_dma_buf_io_ops;
+	return 0;
+}
+
+int __nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
+		struct nvme_dma_buf_list *buf_list,
+		struct dma_buf_io_ctx *ctx)
+{
+	int ret;
+
+	mutex_lock(&buf_list->lock);
+	ret = nvme_init_io_ctx_locked(ctrl, buf_list, ctx);
+	mutex_unlock(&buf_list->lock);
+	return ret;
+}
diff --git a/drivers/nvme/host/pci-dmabuf.h b/drivers/nvme/host/pci-dmabuf.h
new file mode 100644
index 000000000000..8e91f7f4ece5
--- /dev/null
+++ b/drivers/nvme/host/pci-dmabuf.h
@@ -0,0 +1,73 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (C) 2026 Pavel Begunkov <asml.silence@gmail.com>
+ */
+
+#ifndef _NVME_PCI_DMABUF_H
+#define _NVME_PCI_DMABUF_H
+
+#include <linux/dma-buf-io.h>
+
+#include "nvme.h"
+
+struct nvme_dma_buf_list {
+	struct list_head ctxs;
+	struct mutex lock;
+};
+
+struct nvme_dma_buf_io_ctx {
+	struct dma_buf_attachment *attach;
+	struct nvme_dma_buf_list *buf_list;
+	struct dma_buf_io_ctx *base;
+	struct nvme_ctrl *ctrl;
+	struct list_head list;
+};
+
+struct nvme_dmabuf_map {
+	struct dma_buf_io_map base;
+	struct sg_table *sgt;
+	unsigned nr_entries;
+	dma_addr_t dma_list[] __counted_by(nr_entries);
+};
+
+static inline struct nvme_dmabuf_map *to_nvme_dmabuf_map(
+	struct dma_buf_io_map *map)
+{
+	return container_of(map, struct nvme_dmabuf_map, base);
+}
+
+static inline struct nvme_dmabuf_map *nvme_req_to_map(struct request *req)
+{
+	struct dma_buf_io_map *map = req->bio->bi_dmabuf_map;
+
+	return to_nvme_dmabuf_map(map);
+}
+
+void __nvme_pci_remove_dmabuf(struct nvme_dma_buf_list *list);
+int __nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
+		struct nvme_dma_buf_list *buf_list,
+		struct dma_buf_io_ctx *ctx);
+
+static inline void nvme_pci_remove_dmabuf(struct nvme_dma_buf_list *list)
+{
+	if (IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		__nvme_pci_remove_dmabuf(list);
+}
+
+static inline int nvme_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
+		struct nvme_dma_buf_list *buf_list,
+		struct dma_buf_io_ctx *ctx)
+{
+	if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
+		return -EOPNOTSUPP;
+	return __nvme_init_dma_buf_io_ctx(ctrl, buf_list, ctx);
+}
+
+static inline void nvme_init_buf_list(struct nvme_dma_buf_list *buf_list)
+{
+	INIT_LIST_HEAD(&buf_list->ctxs);
+	mutex_init(&buf_list->lock);
+}
+
+
+#endif /* _NVME_PCI_DMABUF_H */
\ No newline at end of file
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 68e0d4dcade4..a0506c93fa16 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -27,11 +27,10 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/sed-opal.h>
-#include <linux/dma-buf-io.h>
-#include <linux/dma-resv.h>
 
 #include "trace.h"
 #include "nvme.h"
+#include "pci-dmabuf.h"
 
 #define SQ_SIZE(q)	((q)->q_depth << (q)->sqes)
 #define CQ_SIZE(q)	((q)->q_depth * sizeof(struct nvme_completion))
@@ -320,8 +319,7 @@ struct nvme_dev {
 	bool hmb;
 	struct sg_table *hmb_sgt;
 	mempool_t *dmavec_mempool;
-	struct list_head dmabuf_ctxs;
-	struct mutex dmabuf_lock;
+	struct nvme_dma_buf_list dmabufs;
 
 	/* shadow doorbell buffer support: */
 	__le32 *dbbuf_dbs;
@@ -401,13 +399,6 @@ struct nvme_queue {
 	struct completion delete_done;
 };
 
-struct nvme_dmabuf_map {
-	struct dma_buf_io_map base;
-	struct sg_table *sgt;
-	unsigned nr_entries;
-	dma_addr_t dma_list[] __counted_by(nr_entries);
-};
-
 /* bits for iod->flags */
 enum nvme_iod_flags {
 	/* this command has been aborted by the timeout handler */
@@ -876,48 +867,12 @@ static void nvme_free_descriptors(struct request *req)
 	}
 }
 
-static inline struct nvme_dmabuf_map *
-to_nvme_dmabuf_map(struct dma_buf_io_map *map)
-{
-	return container_of(map, struct nvme_dmabuf_map, base);
-}
-
-static void nvme_dmabuf_map_sync_for_cpu(struct nvme_dev *nvme_dev,
-		struct request *req)
-{
-	struct bio *bio = req->bio;
-	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
-
-	dma_sync_sgtable_for_cpu(nvme_dev->dev, map->sgt, rq_dma_dir(req));
-}
-
-static void nvme_dmabuf_map_sync_for_device(struct nvme_dev *nvme_dev,
-		struct request *req)
-{
-	struct bio *bio = req->bio;
-	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
-
-	dma_sync_sgtable_for_device(nvme_dev->dev, map->sgt, rq_dma_dir(req));
-}
-
-static void nvme_rq_clean_dmabuf_map(struct nvme_dev *dev,
-		struct request *req)
-{
-	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-
-	nvme_dmabuf_map_sync_for_cpu(dev, req);
-
-	if (iod->nr_descriptors)
-		nvme_free_descriptors(req);
-}
-
 static blk_status_t nvme_rq_setup_dmabuf_map(struct request *req,
 		struct nvme_queue *nvmeq)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct bio *bio = req->bio;
-	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
-	unsigned bvec_done = bio->bi_iter.bi_offset;
+	struct nvme_dmabuf_map *map = nvme_req_to_map(req);
+	unsigned bvec_done = req->bio->bi_iter.bi_offset;
 	unsigned map_idx = bvec_done / NVME_CTRL_PAGE_SIZE;
 	unsigned offset = bvec_done & (NVME_CTRL_PAGE_SIZE - 1);
 	int length = blk_rq_payload_bytes(req) - (NVME_CTRL_PAGE_SIZE - offset);
@@ -928,8 +883,6 @@ static blk_status_t nvme_rq_setup_dmabuf_map(struct request *req,
 	__le64 *prp_list;
 	unsigned i;
 
-	nvme_dmabuf_map_sync_for_device(nvmeq->dev, req);
-
 	if (length <= 0) {
 		prp2_dma = 0;
 		goto done;
@@ -1062,10 +1015,8 @@ static void nvme_unmap_data(struct request *req)
 	struct device *dma_dev = nvmeq->dev->dev;
 	unsigned int attrs = 0;
 
-	if (blk_mq_rq_is_dmabuf(req)) {
-		nvme_rq_clean_dmabuf_map(nvmeq->dev, req);
-		return;
-	}
+	if (blk_mq_rq_is_dmabuf(req))
+		goto out_free_desc;
 
 	if (iod->flags & IOD_SINGLE_SEGMENT) {
 		static_assert(offsetof(union nvme_data_ptr, prp1) ==
@@ -1091,6 +1042,7 @@ static void nvme_unmap_data(struct request *req)
 			nvme_free_prps(req, attrs);
 	}
 
+out_free_desc:
 	if (iod->nr_descriptors)
 		nvme_free_descriptors(req);
 }
@@ -2411,175 +2363,6 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
 	return result;
 }
 
-#ifdef CONFIG_DMA_SHARED_BUFFER
-
-struct nvme_dma_buf_io_ctx {
-	struct dma_buf_attachment *attach;
-	struct dma_buf_io_ctx *ctx;
-	struct nvme_dev *dev;
-	struct list_head list;
-};
-
-static void nvme_dmabuf_invalidate_mappings(struct dma_buf_attachment *attach)
-{
-	struct dma_buf_io_ctx *ctx = attach->importer_priv;
-
-	dma_buf_io_invalidate_mappings(ctx);
-}
-
-static const struct dma_buf_attach_ops nvme_dmabuf_importer_ops = {
-	.invalidate_mappings	= nvme_dmabuf_invalidate_mappings,
-	.allow_peer2peer	= true,
-};
-
-static struct dma_buf_io_map *nvme_dma_buf_io_map(struct dma_buf_io_ctx *ctx)
-{
-	unsigned nr_entries = ctx->dmabuf->size / NVME_CTRL_PAGE_SIZE;
-	struct nvme_dma_buf_io_ctx *nvme_ctx = ctx->dev_priv;
-	struct dma_buf_attachment *attach = nvme_ctx->attach;
-	unsigned long tmp, i = 0;
-	struct nvme_dmabuf_map *map;
-	struct scatterlist *sg;
-	struct sg_table *sgt;
-	int ret;
-
-	dma_resv_assert_held(ctx->dmabuf->resv);
-
-	if (ctx->dmabuf->size % NVME_CTRL_PAGE_SIZE)
-		return ERR_PTR(-EINVAL);
-
-	map = kvmalloc_flex(*map, dma_list, nr_entries);
-	if (!map)
-		return ERR_PTR(-ENOMEM);
-	map->nr_entries = nr_entries;
-
-	sgt = dma_buf_map_attachment(attach, ctx->dir);
-	if (IS_ERR(sgt)) {
-		ret = PTR_ERR(sgt);
-		sgt = NULL;
-		goto err;
-	}
-
-	for_each_sgtable_dma_sg(sgt, sg, tmp) {
-		dma_addr_t dma_addr = sg_dma_address(sg);
-		unsigned long sg_len = sg_dma_len(sg);
-
-		if ((sg_len % NVME_CTRL_PAGE_SIZE) ||
-		    (dma_addr % NVME_CTRL_PAGE_SIZE)) {
-			ret = -EINVAL;
-			goto err;
-		}
-		while (sg_len) {
-			map->dma_list[i++] = dma_addr;
-			dma_addr += NVME_CTRL_PAGE_SIZE;
-			sg_len -= NVME_CTRL_PAGE_SIZE;
-		}
-	}
-
-	ret = dma_buf_io_init_map(ctx, &map->base, sgt);
-	if (ret)
-		goto err;
-	map->sgt = sgt;
-	return &map->base;
-err:
-	if (sgt)
-		dma_buf_unmap_attachment(attach, sgt, ctx->dir);
-	kvfree(map);
-	return ERR_PTR(ret);
-}
-
-static void nvme_dma_buf_io_unmap(struct dma_buf_io_ctx *ctx,
-		struct dma_buf_io_map *map_base)
-{
-	struct nvme_dma_buf_io_ctx *nvme_ctx = ctx->dev_priv;
-	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(map_base);
-
-	dma_resv_assert_held(ctx->dmabuf->resv);
-
-	dma_buf_unmap_attachment(nvme_ctx->attach, map->sgt, ctx->dir);
-	kvfree(map);
-}
-
-static void nvme_dma_buf_io_release(struct dma_buf_io_ctx *ctx)
-{
-	struct nvme_dma_buf_io_ctx *nvme_ctx = ctx->dev_priv;
-	struct nvme_dev *dev = nvme_ctx->dev;
-
-	mutex_lock(&dev->dmabuf_lock);
-	if (!list_empty(&nvme_ctx->list)) {
-		dma_buf_detach(ctx->dmabuf, nvme_ctx->attach);
-		list_del_init(&nvme_ctx->list);
-	}
-	mutex_unlock(&dev->dmabuf_lock);
-
-	nvme_put_ctrl(&dev->ctrl);
-	kfree(nvme_ctx);
-}
-
-const struct dma_buf_io_ops nvme_dma_buf_io_ops = {
-	.map		= nvme_dma_buf_io_map,
-	.unmap		= nvme_dma_buf_io_unmap,
-	.release	= nvme_dma_buf_io_release,
-};
-
-static int __nvme_pci_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
-		struct dma_buf_io_ctx *ctx)
-{
-	struct nvme_dev *dev = to_nvme_dev(ctrl);
-	struct nvme_dma_buf_io_ctx *nvme_ctx;
-	struct dma_buf_attachment *attach;
-
-	nvme_ctx = kzalloc_obj(*nvme_ctx);
-	if (!nvme_ctx)
-		return -ENOMEM;
-
-	attach = dma_buf_dynamic_attach(ctx->dmabuf, dev->dev,
-					&nvme_dmabuf_importer_ops, ctx);
-	if (IS_ERR(attach)) {
-		kfree(nvme_ctx);
-		return PTR_ERR(attach);
-	}
-
-	nvme_get_ctrl(ctrl);
-	list_add(&nvme_ctx->list, &dev->dmabuf_ctxs);
-	nvme_ctx->attach = attach;
-	nvme_ctx->ctx = ctx;
-	nvme_ctx->dev = dev;
-	ctx->dev_priv = nvme_ctx;
-	ctx->dev_ops = &nvme_dma_buf_io_ops;
-	return 0;
-}
-
-static int nvme_pci_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
-		struct dma_buf_io_ctx *ctx)
-{
-	struct nvme_dev *dev = to_nvme_dev(ctrl);
-	int ret;
-
-	mutex_lock(&dev->dmabuf_lock);
-	ret = __nvme_pci_init_dma_buf_io_ctx(ctrl, ctx);
-	mutex_unlock(&dev->dmabuf_lock);
-	return ret;
-}
-
-static void nvme_pci_remove_dmabuf(struct nvme_dev *dev)
-{
-	struct nvme_dma_buf_io_ctx *ctx, *tmp;
-
-	mutex_lock(&dev->dmabuf_lock);
-	list_for_each_entry_safe(ctx, tmp, &dev->dmabuf_ctxs, list) {
-		dma_buf_io_detach(ctx->ctx);
-		dma_buf_detach(ctx->ctx->dmabuf, ctx->attach);
-		list_del_init(&ctx->list);
-	}
-	mutex_unlock(&dev->dmabuf_lock);
-}
-#else
-static void nvme_pci_remove_dmabuf(struct nvme_dev *dev)
-{
-}
-#endif
-
 static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
@@ -3655,7 +3438,7 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
 	mutex_unlock(&dev->shutdown_lock);
 
 	if (shutdown)
-		nvme_pci_remove_dmabuf(dev);
+		nvme_pci_remove_dmabuf(&dev->dmabufs);
 }
 
 static int nvme_disable_prepare_reset(struct nvme_dev *dev, bool shutdown)
@@ -3863,6 +3646,14 @@ static unsigned long nvme_pci_get_virt_boundary(struct nvme_ctrl *ctrl,
 	return 0;
 }
 
+static int nvme_pci_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
+		struct dma_buf_io_ctx *ctx)
+{
+	struct nvme_dev *dev = to_nvme_dev(ctrl);
+
+	return nvme_init_dma_buf_io_ctx(ctrl, &dev->dmabufs, ctx);
+}
+
 static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
 	.name			= "pcie",
 	.module			= THIS_MODULE,
@@ -3878,9 +3669,7 @@ static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
 	.print_device_info	= nvme_pci_print_device_info,
 	.supports_pci_p2pdma	= nvme_pci_supports_pci_p2pdma,
 	.get_virt_boundary	= nvme_pci_get_virt_boundary,
-#ifdef CONFIG_DMA_SHARED_BUFFER
 	.init_dma_buf_io_ctx	= nvme_pci_init_dma_buf_io_ctx,
-#endif
 };
 
 static int nvme_dev_map(struct nvme_dev *dev)
@@ -4003,8 +3792,7 @@ static struct nvme_dev *nvme_pci_alloc_dev(struct pci_dev *pdev,
 		return ERR_PTR(-ENOMEM);
 	INIT_WORK(&dev->ctrl.reset_work, nvme_reset_work);
 	mutex_init(&dev->shutdown_lock);
-	INIT_LIST_HEAD(&dev->dmabuf_ctxs);
-	mutex_init(&dev->dmabuf_lock);
+	nvme_init_buf_list(&dev->dmabufs);
 
 	dev->nr_write_queues = write_queues;
 	dev->nr_poll_queues = poll_queues;
-- 
2.54.0

