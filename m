Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8C84A49B3
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 13:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997991; cv=none; b=rd67fEKU+KsqX4XwwaCzLpC7g+BMRlgBzCcQDqURUU2NDRnPY8oTN5e/oPDzQng81pgsS7i3wKyO+uoo8203ddAIeSVJ923NxiQo1deLh1Q7SOotTH9CN9ud/jpXjK0oWVQ1edgc3SF0nkqlgZs6r+2ym60GxWb7W7MXlpYuE2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997991; c=relaxed/simple;
	bh=eWGOuzxLl4ww8+RUexIOLldrycXKg0mPt+5jK5IMoA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rac6K9mU2IYDf+oY0oMEDXfkP3iG+sSwERLzxk40LIMAymsi9DjrpRimr6XbaUsrzLK2zkKBbQEiCjTRpYLdPuGlcNisCLSSjqZ39k+0rcvjIGIroYKRQ9rWRFCqao27mcMgXXMsy3T7hSFbsiQQgsh8EuH9gmuTQYCOQcSFT0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hoxwGtXt; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hoxwGtXt"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485b1d2874fso1084379f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 06:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997987; x=1790602787; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mH7BvLrcnLu8WRQAlFxz4vQAXzatlrTdCQIygZg9AG4=;
        b=hoxwGtXtgAHWlACwMH9vW6RTrVaRHO/hq8Twc1pBYoc+0/X9N/ObzDGnTxo1TTDo5Q
         GosZX8RCNmtz1ztTIKCT+xGMVYi5TqUOQi2FBkM7K8+PTfrkrolNLCOq11TPagcugFWO
         waerIr16zUlOZF4i8F3ASTLDWTs/BNiAkvLbYQKkKYOaiY4CmJ2poSIUsgb+YHHgqwVh
         oCtZawXzWmR/UIpVCPLZH85cfMXZVMozzQAXQQR8MbKieoJ3FDCiQDcu1POE+55LMAz6
         O3KyedZvqSqXT/RnWd5YOlzrgluoskt/JW0TlI/C5yOg1Fh7ROommI859bDAysyLCJtJ
         Etbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997987; x=1790602787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mH7BvLrcnLu8WRQAlFxz4vQAXzatlrTdCQIygZg9AG4=;
        b=hFdJyKwwuGg9ib/wfrhTsyJ3Qh+1jU05hwTMaKjv9BcCPN43Q2Qk+VzgRnsOpQmxLs
         oLPkCB1/xOwjAMMVFYOrROnb2Zb10wuAuKMC7YZegLGswKXshKmkCwX1/szGv6mb3Yp1
         H46drLWzIcJP6NBSDW/iDHuCfK8GdNhWGfOyjZiEcbAZRltkFPJCrFsJZuaqXxoLPgLh
         qDJCP9cnioj3VUZYjAoVFPoA1nZwPsTia1+OemPV9vxcwvn4tg0Fe2Bl9/sxKQkx5jqy
         VRdSx0AewSXnIiqIQ5sUFRKV2FlnTw6O93J0cUeuobJciUquUAhVGk91SCQCp0+7Utcy
         Za4A==
X-Forwarded-Encrypted: i=1; AKwUvBxn9FG+w5MDlJCzOaywePYv9bAp9+AcnqRuwrT2nAECiKwkIgtqtAW0nLiN01xGg/nq1wN3xuogfA==@lists.linux.dev
X-Gm-Message-State: AFuF++netjQlHqvftHF0gRMJEKl3IvhCNNw6Spj/YoqMBYIBXz00MYkR
	0lLr9L5gCeqUjaAoTEP8FtDLoj8s79+e2/JnpunARlQonDbZkobyUUfs
X-Gm-Gg: AYBFou1cxdvXnJnAWU8Nm4f+GQlRWujrtmmpBYy7WzhMkXRY17dbISMDU6iVArrjJCb
	zqNte3eSkFC5UXAcGyCZodAkvM0qjRS47++wCo20DiT9yl2eKJhsHYuD9ztlG4y/4PRiSMM4L+v
	edijPHcnPuPGS+6oE1qzVfCvdBuGEKnex4Xb9njwftfjq+iFGucbrsH+OkF/hvhOm8Yw2KpoBc2
	PCavQCawNQC7anHFhK5XMjFIHGaUFH4qzkgWQEUmf3+n45F9sq7zAkWydK8ALOvTETA3rO9cM8r
	1V+Pb/pzGVSGS65WIRi8FjtYWSgdsH5gy5QccAY0hczA/n/2pSJC3B3Ssf9UItrT4LH1TeQ/xen
	bSwx44jeDxU/K80fw/AcgwqoU2LQH5sp0Dzw8GpohNq3LZx0/kSS1CL8jsMDqFxq5NcK1/irbmK
	lzqXnGUcwYzH2LEzvs/x3m09f4ErnVPrF0W54eVtdNYPD3NVx8LYD9DDKypYOGGg7p2aLhI0qwH
	Fy2gyasDNEfWhPchI9I2fMF8I30GKEd92daxOkL633zqHy/Efgxs4iVuHAq86BW0Rz9jCXICM2L
	sP9Ez9/tXPL6tSPfXhFBFkIt+bExMQ==
X-Received: by 2002:a05:600c:1d06:b0:49e:8222:3451 with SMTP id 5b1f17b1804b1-49fc5001358mr167903285e9.14.1789997987144;
        Mon, 21 Sep 2026 06:39:47 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-26.dab.02.net. [82.132.213.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc585920fsm617171605e9.4.2026.09.21.06.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:39:46 -0700 (PDT)
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
Subject: [PATCH v6 08/13] nvme-pci: add SGL support for the dmabuf path
Date: Mon, 21 Sep 2026 14:38:52 +0100
Message-ID: <1a50e7e88263f97403f8df8583dbb1953600f2a9.1789997898.git.asml.silence@gmail.com>
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

From: Anuj Gupta <anuj20.g@samsung.com>

Add SGL support in addition to PRP for dmabuf-backed requests,
building the descriptor list from the mapping's sg_table.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/pci.c | 153 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 149 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 8dc4002fa696..4756f114154c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1297,12 +1297,18 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	return BLK_STS_IOERR;
 }
 
+static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
+		dma_addr_t addr, u32 len)
+{
+	sge->addr = cpu_to_le64(addr);
+	sge->length = cpu_to_le32(len);
+	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
+}
+
 static void nvme_pci_dma_iter_set_sgl(struct nvme_sgl_desc *sge,
 		struct blk_dma_iter *iter)
 {
-	sge->addr = cpu_to_le64(iter->addr);
-	sge->length = cpu_to_le32(iter->len);
-	sge->type = NVME_SGL_FMT_DATA_DESC << 4;
+	nvme_pci_sgl_set_data(sge, iter->addr, iter->len);
 }
 
 static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
@@ -1313,6 +1319,145 @@ static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
 	sge->type = NVME_SGL_FMT_LAST_SEG_DESC << 4;
 }
 
+static unsigned int nvme_pci_dmabuf_sgl_nents(struct request *req)
+{
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
+	struct scatterlist *sg;
+	unsigned long tmp;
+	size_t offset = bio->bi_iter.bi_offset;
+	size_t remaining = blk_rq_payload_bytes(req);
+	unsigned int nents = 0;
+
+	for_each_sgtable_dma_sg(map->sgt, sg, tmp) {
+		size_t sg_len = sg_dma_len(sg);
+
+		if (!remaining)
+			break;
+		if (offset >= sg_len) {
+			offset -= sg_len;
+			continue;
+		}
+
+		sg_len -= offset;
+		offset = 0;
+
+		do {
+			size_t chunk = min(remaining, sg_len);
+
+			nents++;
+			sg_len -= chunk;
+			remaining -= chunk;
+		} while (sg_len && remaining);
+	}
+
+	if (unlikely(remaining))
+		return 0;
+
+	return nents;
+}
+
+static blk_status_t nvme_rq_setup_dmabuf_sgl(struct request *req,
+		struct nvme_queue *nvmeq, unsigned int entries)
+{
+	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
+	struct bio *bio = req->bio;
+	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
+	size_t length = blk_rq_payload_bytes(req);
+	struct nvme_sgl_desc *sg_list = &iod->cmd.common.dptr.sgl;
+	bool pooled = entries > 1;
+	dma_addr_t sgl_dma = 0;
+	unsigned int mapped = 0;
+	unsigned long tmp;
+	struct scatterlist *sg;
+	size_t offset = bio->bi_iter.bi_offset;
+	size_t remaining = length;
+
+	if (!entries)
+		return BLK_STS_IOERR;
+
+	iod->cmd.common.flags = NVME_CMD_SGL_METABUF;
+	iod->total_len = length;
+
+	nvme_dmabuf_map_sync_for_device(nvmeq->dev, req);
+
+	/* entries == 1 fits in the inline descriptor; more needs a pool. */
+	if (pooled) {
+		if (entries <= NVME_SMALL_POOL_SIZE / sizeof(*sg_list))
+			iod->flags |= IOD_SMALL_DESCRIPTOR;
+
+		sg_list = dma_pool_alloc(nvme_dma_pool(nvmeq, iod), GFP_ATOMIC,
+					 &sgl_dma);
+		if (!sg_list)
+			return BLK_STS_RESOURCE;
+		iod->descriptors[iod->nr_descriptors++] = sg_list;
+	}
+
+	for_each_sgtable_dma_sg(map->sgt, sg, tmp) {
+		size_t sg_len = sg_dma_len(sg);
+		dma_addr_t addr = sg_dma_address(sg);
+
+		if (!remaining)
+			break;
+		if (offset >= sg_len) {
+			offset -= sg_len;
+			continue;
+		}
+
+		addr += offset;
+		sg_len -= offset;
+		offset = 0;
+
+		do {
+			u32 chunk = min_t(size_t, remaining, sg_len);
+
+			if (WARN_ON_ONCE(mapped == entries))
+				goto err_free;
+			nvme_pci_sgl_set_data(&sg_list[mapped++], addr, chunk);
+
+			addr += chunk;
+			sg_len -= chunk;
+			remaining -= chunk;
+		} while (sg_len && remaining);
+	}
+
+	if (unlikely(remaining))
+		goto err_free;
+
+	if (pooled)
+		nvme_pci_sgl_set_seg(&iod->cmd.common.dptr.sgl, sgl_dma,
+				     mapped);
+	return BLK_STS_OK;
+err_free:
+	if (pooled) {
+		iod->nr_descriptors--;
+		dma_pool_free(nvme_dma_pool(nvmeq, iod), sg_list, sgl_dma);
+	}
+	return BLK_STS_IOERR;
+}
+
+static blk_status_t nvme_rq_setup_dmabuf(struct request *req,
+		struct nvme_queue *nvmeq, enum nvme_use_sgl use_sgl)
+{
+	unsigned int entries;
+	size_t avg_seg;
+
+	if (use_sgl == SGL_UNSUPPORTED)
+		return nvme_rq_setup_dmabuf_map(req, nvmeq);
+
+	entries = nvme_pci_dmabuf_sgl_nents(req);
+
+	if (use_sgl == SGL_FORCED)
+		return nvme_rq_setup_dmabuf_sgl(req, nvmeq, entries);
+
+	avg_seg = entries ?
+		DIV_ROUND_UP(blk_rq_payload_bytes(req), entries) : 0;
+	if (sgl_threshold && avg_seg >= sgl_threshold)
+		return nvme_rq_setup_dmabuf_sgl(req, nvmeq, entries);
+
+	return nvme_rq_setup_dmabuf_map(req, nvmeq);
+}
+
 static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 		struct blk_dma_iter *iter)
 {
@@ -1408,7 +1553,7 @@ static blk_status_t nvme_map_data(struct request *req)
 	blk_status_t ret;
 
 	if (blk_mq_rq_is_dmabuf(req))
-		return nvme_rq_setup_dmabuf_map(req, nvmeq);
+		return nvme_rq_setup_dmabuf(req, nvmeq, use_sgl);
 
 	/*
 	 * Try to skip the DMA iterator for single segment requests, as that
-- 
2.54.0

