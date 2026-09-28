Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F3B4CDDDD
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 13:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602381; cv=none; b=YFxIDCOAIOkK0OI29H073pmPHAFDvreWI5AbjB82b3FCPD/qkM4PZiZ8otkYBVBVvyEIetLzzFEVL129Yi5xd4KFu+qczt0SXgvN/aAIFFFzASyixNRlC+2VC43zRnO9kojKCaAYvV6dIvHU1ZgfwTbiOF2e9vWTwzr6+lfIb0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602381; c=relaxed/simple;
	bh=04/EubsUzuOGVVBdV5+op4CBOIm0uE7Wxal5AldmltA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BN9tvJayknHy4/NQW4e1iTTkxBerPHqWuv3LG5SHG5oZu7tIU492mp6EwReziEvJXyjAnq7SYm/LU8Pb22HGXRl7ckx1qXPjxSj/exjFk1/Wau6KxLSziXTzV+flslg8ZG7Aj7pto5gRofyZ5qe3YLNwsr6V3tkfl30Nv1YXpuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RMrOoybI; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RMrOoybI"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f91so1770919f8f.1
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 06:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790602373; x=1791207173; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cVsh0B/AKhKUiV66cIH1/p0W39OWw+1tNkq32iVCj/M=;
        b=RMrOoybItxcFPi03ZoHIrYRbVxyLDUWi8H6R2h+MGtdTih1z+yUkTamlbFe6Zsb4Mg
         6+AdEkwof+t/BSpMzvM1fowqeTikk68UTaJaXAxcRfE+n2t1qLzOn8wjB/jhMVCxATcB
         nkdG7f7J2rtM+iIcBt+83clLllILKlgy3uPnMYvEgNeUVnje81MTY1CJC1y1E8SIXKmr
         nvzXZYhwNIuxUNTd60k3seUx2ETL/6Z4niP7kcpUEOYxxxiEl/I5+Z1bfxtltbsjJyCh
         GWR9qzb3sKeutn1NZHZHfJ0RB257onCP62vFEfkV/oFmgp0wO0Qb4c9latHKThFzg1hs
         2g/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790602373; x=1791207173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cVsh0B/AKhKUiV66cIH1/p0W39OWw+1tNkq32iVCj/M=;
        b=Pv0Qh2O61t79rjvnuG0WBrihQRf+Ex1B6lL+iG2N2qOe+GDc6gsHY/RFzmyXVduOEs
         EFEfQSUJCIzZ4iegsHPjT0z+S+mQo67P1L/qifEdnqAv3hthhuz+7EgRNF9mVkEawLdx
         GLQGMbgx/GsNHlHOkbkcWOuoD7GnRqdVy2+egIdfeJ9jPPoQqDiSc7CHWDRjgBSqnGfP
         y7D12OUgXZhTN8MCYgjxq3e8jQx+CpjiisisVBiOjWt0vag4+OiU2SM5CGukZOa1fWuz
         7d4bqbGW+JFsDI+j6/ethUijAp9N/GwZo5I1dpAvhJBfO77ufd7btE/DGizjc2iHTojg
         7UfQ==
X-Forwarded-Encrypted: i=1; AKwUvBxs2Aywr4A0tEIH7b+rSAoyHOpmmC0tLcm62rtG3wk1Jef79a876SR1XH2pGJrLHELT2I0JxH0I8g==@lists.linux.dev
X-Gm-Message-State: AFq9FYKmgOZcyNg/lDJHD4VhPIoV+ppomL6ASk/QDugkuczvJgH3xnWN
	CIDj/WSp2DP6G4plhfPdIbSJWe9207JyBPje7MqoT6vKYBujbQNqP+TQ
X-Gm-Gg: AYBFou29az5nsi0Ukc3aulnFbxkDAvZWrjfrtqdbhQzaxBaYy6k8no+uSQtnsslR3Vz
	VPb2YXFckpBFW/pAKMiR8tAiNh2quwNVLYISKYgcRMALWBRRrXNvtFbEto+QBJQpFEKq1Jo1UdQ
	wX1wpvxqsawLWw8xJhRIahatbeVuRn4XexM5y6I6hXhqHHN9UU4Iy3o3rnezJm/TidtY2jEG/BC
	U7dGx50f9DGsFXRbckBSNBm/jqwiz33/putNO0BHViXDYgAAfG8X+IRxgIUbqbsnpPG1HzW6u/c
	s0VlNQsJpm2uMjnTjHYWLHZdnuuzT5ngVmXqWI2lsD6ZBj3G3EavWcTDRkmP3pBDZeq7n7j7IkH
	e22T1mw0PYJ+17/xlfwuDTQ1Gck6ay6uOsAC0MkrUVkbp+obwDLB/rTvmkB+62rL3e9v4WJCQpX
	dlJKyuv8D+69oP8PqN1RV2Ojq7t1zuSsMmi04WVJRW1MKA/5zEbx44RfgzZT8KwtEE8QS5iigDs
	KEXSurwW6C69dYYCI/CGjKGoAZDu+bm3bG6Jiuh/Bd0cShOi64ooaRhGGEgf15H1+snzAZ1xP4v
	FLxGm1lw3Ms=
X-Received: by 2002:a5d:59c4:0:b0:488:6da0:b83d with SMTP id ffacd0b85a97d-4887db39e6cmr20780234f8f.44.1790602373373;
        Mon, 28 Sep 2026 06:32:53 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a349731sm28090164f8f.12.2026.09.28.06.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 06:32:52 -0700 (PDT)
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
Subject: [PATCH v7 06/13] nvme-pci: implement dma-buf backed requests
Date: Mon, 28 Sep 2026 14:32:22 +0100
Message-ID: <e99dd5221c71cbf9aafb5737468d814cb83b9174.1790602223.git.asml.silence@gmail.com>
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

Enable BIO_DMABUF_MAP backed requests. On registration we map the
dma-buf and store it as a prp list, which is then used to initialise
requests. All attached contexts are stored in a new list dmabuf_ctxs,
and additions/removals are synchronised with dmabuf_lock.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/core.c |  12 ++
 drivers/nvme/host/nvme.h |   2 +
 drivers/nvme/host/pci.c  | 308 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 322 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index beea23d04a70..d81462e864a4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2699,6 +2699,17 @@ static int nvme_report_zones(struct gendisk *disk, sector_t sector,
 #define nvme_report_zones	NULL
 #endif /* CONFIG_BLK_DEV_ZONED */
 
+static int nvme_init_dma_buf_io_ctx(struct block_device *bdev,
+		struct dma_buf_io_ctx *ctx)
+{
+	struct nvme_ns *ns = bdev->bd_disk->private_data;
+	struct nvme_ctrl *ctrl = ns->ctrl;
+
+	if (!ctrl->ops->init_dma_buf_io_ctx)
+		return -EINVAL;
+	return ctrl->ops->init_dma_buf_io_ctx(ctrl, ctx);
+}
+
 const struct block_device_operations nvme_bdev_ops = {
 	.owner		= THIS_MODULE,
 	.ioctl		= nvme_ioctl,
@@ -2709,6 +2720,7 @@ const struct block_device_operations nvme_bdev_ops = {
 	.get_unique_id	= nvme_get_unique_id,
 	.report_zones	= nvme_report_zones,
 	.pr_ops		= &nvme_pr_ops,
+	.init_dma_buf_io_ctx = nvme_init_dma_buf_io_ctx,
 };
 
 static int nvme_wait_ready(struct nvme_ctrl *ctrl, u32 mask, u32 val,
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 2cff9fcbf740..befb7faba9ca 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -667,6 +667,8 @@ struct nvme_ctrl_ops {
 	int (*get_address)(struct nvme_ctrl *ctrl, char *buf, int size);
 	void (*print_device_info)(struct nvme_ctrl *ctrl);
 	bool (*supports_pci_p2pdma)(struct nvme_ctrl *ctrl);
+	int (*init_dma_buf_io_ctx)(struct nvme_ctrl *ctrl,
+				   struct dma_buf_io_ctx *ctx);
 	unsigned long (*get_virt_boundary)(struct nvme_ctrl *ctrl, bool is_admin);
 };
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a953c0697f99..e58bdd9a4098 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -27,6 +27,8 @@
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <linux/io-64-nonatomic-hi-lo.h>
 #include <linux/sed-opal.h>
+#include <linux/dma-buf-io.h>
+#include <linux/dma-resv.h>
 
 #include "trace.h"
 #include "nvme.h"
@@ -318,6 +320,8 @@ struct nvme_dev {
 	bool hmb;
 	struct sg_table *hmb_sgt;
 	mempool_t *dmavec_mempool;
+	struct list_head dmabuf_ctxs;
+	struct mutex dmabuf_lock;
 
 	/* shadow doorbell buffer support: */
 	__le32 *dbbuf_dbs;
@@ -397,6 +401,13 @@ struct nvme_queue {
 	struct completion delete_done;
 };
 
+struct nvme_dmabuf_map {
+	struct dma_buf_io_map base;
+	struct sg_table *sgt;
+	unsigned nr_entries;
+	dma_addr_t dma_list[];
+};
+
 /* bits for iod->flags */
 enum nvme_iod_flags {
 	/* this command has been aborted by the timeout handler */
@@ -865,6 +876,120 @@ static void nvme_free_descriptors(struct request *req)
 	}
 }
 
+static inline struct nvme_dmabuf_map *
+to_nvme_dmabuf_map(struct dma_buf_io_map *map)
+{
+	return container_of(map, struct nvme_dmabuf_map, base);
+}
+
+static void nvme_dmabuf_map_sync_for_cpu(struct nvme_dev *nvme_dev,
+		struct request *req)
+{
+	struct device *dev = nvme_dev->dev;
+	enum dma_data_direction dma_dir;
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
+
+	dma_dir = rq_data_dir(req) == READ ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	dma_sync_sgtable_for_cpu(dev, map->sgt, dma_dir);
+}
+
+static void nvme_dmabuf_map_sync_for_device(struct nvme_dev *nvme_dev,
+		struct request *req)
+{
+	struct device *dev = nvme_dev->dev;
+	enum dma_data_direction dma_dir;
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
+
+	dma_dir = rq_data_dir(req) == READ ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	dma_sync_sgtable_for_device(dev, map->sgt, dma_dir);
+}
+
+static void nvme_rq_clean_dmabuf_map(struct nvme_dev *dev,
+		struct request *req)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+
+	nvme_dmabuf_map_sync_for_cpu(dev, req);
+
+	if (iod->nr_descriptors)
+		nvme_free_descriptors(req);
+}
+
+static blk_status_t nvme_rq_setup_dmabuf_map(struct request *req,
+		struct nvme_queue *nvmeq)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
+	unsigned bvec_done = bio->bi_iter.bi_offset;
+	unsigned map_idx = bvec_done / NVME_CTRL_PAGE_SIZE;
+	unsigned offset = bvec_done & (NVME_CTRL_PAGE_SIZE - 1);
+	int length = blk_rq_payload_bytes(req) - (NVME_CTRL_PAGE_SIZE - offset);
+	dma_addr_t *dma_list = map->dma_list;
+	u64 prp1_dma = dma_list[map_idx++] + offset;
+	u64 dma_addr, prp2_dma;
+	dma_addr_t prp_dma;
+	__le64 *prp_list;
+	unsigned i;
+
+	nvme_dmabuf_map_sync_for_device(nvmeq->dev, req);
+
+	if (length <= 0) {
+		prp2_dma = 0;
+		goto done;
+	}
+
+	if (length <= NVME_CTRL_PAGE_SIZE) {
+		prp2_dma = dma_list[map_idx];
+		goto done;
+	}
+
+	if (DIV_ROUND_UP(length, NVME_CTRL_PAGE_SIZE) <=
+	    NVME_SMALL_POOL_SIZE / sizeof(__le64))
+		iod->flags |= IOD_SMALL_DESCRIPTOR;
+
+	prp_list = dma_pool_alloc(nvme_dma_pool(nvmeq, iod), GFP_ATOMIC,
+			&prp_dma);
+	if (!prp_list)
+		return BLK_STS_RESOURCE;
+
+	iod->descriptors[iod->nr_descriptors++] = prp_list;
+	prp2_dma = prp_dma;
+	i = 0;
+	for (;;) {
+		if (i == NVME_CTRL_PAGE_SIZE >> 3) {
+			__le64 *old_prp_list = prp_list;
+
+			prp_list = dma_pool_alloc(nvmeq->descriptor_pools.large,
+					GFP_ATOMIC, &prp_dma);
+			if (!prp_list)
+				goto free_prps;
+			iod->descriptors[iod->nr_descriptors++] = prp_list;
+			prp_list[0] = old_prp_list[i - 1];
+			old_prp_list[i - 1] = cpu_to_le64(prp_dma);
+			i = 1;
+		}
+
+		dma_addr = dma_list[map_idx++];
+		prp_list[i++] = cpu_to_le64(dma_addr);
+
+		length -= NVME_CTRL_PAGE_SIZE;
+		if (length <= 0)
+			break;
+	}
+done:
+	iod->cmd.common.dptr.prp1 = cpu_to_le64(prp1_dma);
+	iod->cmd.common.dptr.prp2 = cpu_to_le64(prp2_dma);
+	return BLK_STS_OK;
+free_prps:
+	iod->cmd.common.dptr.prp1 = cpu_to_le64(prp1_dma);
+	iod->cmd.common.dptr.prp2 = cpu_to_le64(prp2_dma);
+	nvme_free_descriptors(req);
+	return BLK_STS_RESOURCE;
+}
+
 static void nvme_free_prps(struct request *req, unsigned int attrs)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
@@ -943,6 +1068,11 @@ static void nvme_unmap_data(struct request *req)
 	struct device *dma_dev = nvmeq->dev->dev;
 	unsigned int attrs = 0;
 
+	if (blk_mq_rq_is_dmabuf(req)) {
+		nvme_rq_clean_dmabuf_map(nvmeq->dev, req);
+		return;
+	}
+
 	if (iod->flags & IOD_SINGLE_SEGMENT) {
 		static_assert(offsetof(union nvme_data_ptr, prp1) ==
 				offsetof(union nvme_data_ptr, sgl.addr));
@@ -1257,6 +1387,9 @@ static blk_status_t nvme_map_data(struct request *req)
 	struct blk_dma_iter iter;
 	blk_status_t ret;
 
+	if (blk_mq_rq_is_dmabuf(req))
+		return nvme_rq_setup_dmabuf_map(req, nvmeq);
+
 	/*
 	 * Try to skip the DMA iterator for single segment requests, as that
 	 * significantly improves performances for small I/O sizes.
@@ -2284,6 +2417,172 @@ static int nvme_create_queue(struct nvme_queue *nvmeq, int qid, bool polled)
 	return result;
 }
 
+#ifdef CONFIG_DMA_SHARED_BUFFER
+
+struct nvme_dma_buf_io_ctx {
+	struct dma_buf_attachment *attach;
+	struct dma_buf_io_ctx *ctx;
+	struct nvme_dev *dev;
+	struct list_head list;
+};
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
+	map = kvmalloc_flex(*map, dma_list, nr_entries);
+	if (!map)
+		return ERR_PTR(-ENOMEM);
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
+	map->nr_entries = nr_entries;
+	map->sgt = sgt;
+	return &map->base;
+err:
+	if (sgt)
+		dma_buf_unmap_attachment(attach, sgt, ctx->dir);
+	kfree(map);
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
+static void nvme_dma_buf_io_release(struct dma_buf_io_ctx *ctx)
+{
+	struct nvme_dma_buf_io_ctx *nvme_ctx = ctx->dev_priv;
+	struct nvme_dev *dev = nvme_ctx->dev;
+
+	mutex_lock(&dev->dmabuf_lock);
+	if (!list_empty(&nvme_ctx->list)) {
+		dma_buf_detach(ctx->dmabuf, nvme_ctx->attach);
+		list_del_init(&nvme_ctx->list);
+	}
+	mutex_unlock(&dev->dmabuf_lock);
+
+	nvme_put_ctrl(&dev->ctrl);
+	kfree(nvme_ctx);
+}
+
+const struct dma_buf_io_ops nvme_dma_buf_io_ops = {
+	.map		= nvme_dma_buf_io_map,
+	.unmap		= nvme_dma_buf_io_unmap,
+	.release	= nvme_dma_buf_io_release,
+};
+
+static int __nvme_pci_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
+		struct dma_buf_io_ctx *ctx)
+{
+	struct nvme_dev *dev = to_nvme_dev(ctrl);
+	struct nvme_dma_buf_io_ctx *nvme_ctx;
+	struct dma_buf_attachment *attach;
+
+	nvme_ctx = kzalloc_obj(*nvme_ctx);
+	if (!nvme_ctx)
+		return -ENOMEM;
+
+	attach = dma_buf_dynamic_attach(ctx->dmabuf, dev->dev,
+					&nvme_dmabuf_importer_ops, ctx);
+	if (IS_ERR(attach)) {
+		kfree(nvme_ctx);
+		return PTR_ERR(attach);
+	}
+
+	nvme_get_ctrl(ctrl);
+	list_add(&nvme_ctx->list, &dev->dmabuf_ctxs);
+	nvme_ctx->attach = attach;
+	nvme_ctx->ctx = ctx;
+	nvme_ctx->dev = dev;
+	ctx->dev_priv = nvme_ctx;
+	ctx->dev_ops = &nvme_dma_buf_io_ops;
+	return 0;
+}
+
+static int nvme_pci_init_dma_buf_io_ctx(struct nvme_ctrl *ctrl,
+		struct dma_buf_io_ctx *ctx)
+{
+	struct nvme_dev *dev = to_nvme_dev(ctrl);
+	int ret;
+
+	mutex_lock(&dev->dmabuf_lock);
+	ret = __nvme_pci_init_dma_buf_io_ctx(ctrl, ctx);
+	mutex_unlock(&dev->dmabuf_lock);
+	return ret;
+}
+
+static void nvme_pci_remove_dmabuf(struct nvme_dev *dev)
+{
+	struct nvme_dma_buf_io_ctx *ctx, *tmp;
+
+	mutex_lock(&dev->dmabuf_lock);
+	list_for_each_entry_safe(ctx, tmp, &dev->dmabuf_ctxs, list) {
+		dma_buf_io_detach(ctx->ctx);
+		dma_buf_detach(ctx->ctx->dmabuf, ctx->attach);
+		list_del_init(&ctx->list);
+	}
+	mutex_unlock(&dev->dmabuf_lock);
+}
+#else
+static void nvme_pci_remove_dmabuf(struct nvme_dev *dev)
+{
+}
+#endif
+
 static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
@@ -3357,6 +3656,9 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
 			nvme_unquiesce_admin_queue(&dev->ctrl);
 	}
 	mutex_unlock(&dev->shutdown_lock);
+
+	if (shutdown)
+		nvme_pci_remove_dmabuf(dev);
 }
 
 static int nvme_disable_prepare_reset(struct nvme_dev *dev, bool shutdown)
@@ -3579,6 +3881,9 @@ static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
 	.print_device_info	= nvme_pci_print_device_info,
 	.supports_pci_p2pdma	= nvme_pci_supports_pci_p2pdma,
 	.get_virt_boundary	= nvme_pci_get_virt_boundary,
+#ifdef CONFIG_DMA_SHARED_BUFFER
+	.init_dma_buf_io_ctx	= nvme_pci_init_dma_buf_io_ctx,
+#endif
 };
 
 static int nvme_dev_map(struct nvme_dev *dev)
@@ -3701,6 +4006,8 @@ static struct nvme_dev *nvme_pci_alloc_dev(struct pci_dev *pdev,
 		return ERR_PTR(-ENOMEM);
 	INIT_WORK(&dev->ctrl.reset_work, nvme_reset_work);
 	mutex_init(&dev->shutdown_lock);
+	INIT_LIST_HEAD(&dev->dmabuf_ctxs);
+	mutex_init(&dev->dmabuf_lock);
 
 	dev->nr_write_queues = write_queues;
 	dev->nr_poll_queues = poll_queues;
@@ -4344,5 +4651,6 @@ MODULE_AUTHOR("Matthew Wilcox <willy@linux.intel.com>");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0");
 MODULE_DESCRIPTION("NVMe host PCIe transport driver");
+MODULE_IMPORT_NS("DMA_BUF");
 module_init(nvme_init);
 module_exit(nvme_exit);
-- 
2.54.0

