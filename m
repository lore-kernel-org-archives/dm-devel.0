Received: from mail-wr2-f41.google.com (mail-wr2-f41.google.com [74.125.225.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11A84C900F
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 13:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602383; cv=none; b=Y5PQ301g0Kt9MEGnxhlO5ibhgLcA/m7FecTi+ecvD4PRhsjB5v752Jm8VeWgN3a2MJrQeJu8d2m47h0VCCCYGZ/1BlCeMgS3vIdh1j8yLcSeIkZDSxkRckk29qDaPfc+uN7SG7PdrkzcJpi9k30kQbva5toVGb7zP52kO/1umKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602383; c=relaxed/simple;
	bh=M6hLYVFKnXK9dPYxl8iRzXzPnel4ScDW0eLjXw//xzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2rs7hc3eqW4IkbGKuoTt+InEdWGAILEm/RTnJgb88OfTrmcIe0cY6nnktPzqWds0Bs1jTGhxcE44J/pE10L4BwjGFK+g53w2mXsLy2FDXd3xGkxsoqF9n9LZx8DMc9gRwQf7SqZDMWcpL9wWXKuBDNkXBf6RNYbpGCQAwBWICY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k0FPuG2M; arc=none smtp.client-ip=74.125.225.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k0FPuG2M"
Received: by mail-wr2-f41.google.com with SMTP id ffacd0b85a97d-4834977ae75so1793980f8f.3
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 06:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790602377; x=1791207177; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j1oj1dAJP0I40+o8SeAXsOmkZXs4Z4JZibo2wpFxfPw=;
        b=k0FPuG2MCIVUl/L8zeLeLBFhqxpftdwIdXFxNSJ25c8aKRFDXuJmrNDYbzIlOdsWK9
         yEljCWNQukldie8rOdnO+bETa3IL0oUUukPgrlQzpOE/q0+yq6BThOjMW1m6oLBwEPDe
         1SS9TkW7sfAJmqpoS/Z9RosMOmMKRu39IG+TnFRvyaAeDdcexHAkD0ljfnk/hc6lZE7I
         LMQuAch+McUIDtpWcEnYBlxPK6S/9ohCjsiiQdX4TVoyO9L9ng/rGYwrqPP8Lwni+JMf
         VvlkgX7CvbBx0FOrSfptLjcRhZEyDa9AcV+Qdpg9KQINXo7EGA/2aGeMn5XpA2LTXwiS
         x+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790602377; x=1791207177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j1oj1dAJP0I40+o8SeAXsOmkZXs4Z4JZibo2wpFxfPw=;
        b=L2G8JkXicMCbzvd2D0oLa3VhAtd5dsK20MyyOiZLKTfGNzVuxZ07FC5HINaEyZRY4t
         z2gu0vs1BDB+QqxCDOfMZxVH2NVpzS9xuZbqQwVXT8dyeP3trC1tH1ubJUq9IIr3jOj5
         rF9hELdLbVFsIpeTkq+guShyHlrLEyIgSvC111ytxDfEh+ICbbnFd//rjMVZOY3IG32t
         aWPg6r/Yqi59B6I0Nr73qudtAejjcEFGCBr6CDQF44GDEFNKomsks5tsqy4neu2ak5nZ
         LJK8qtSzYlDcfuwIQrzOHvdniTfSXHj9/8nKyhzkylImbMAbc3AWDXJhPgpQ7xzk8HAk
         IT0A==
X-Forwarded-Encrypted: i=1; AKwUvBxBKFZ22zjIkXcV3uSWfNyMVx7lL6EbnDp9pulUhQ7HaY+YZsyuLB0/XvHEBSquKR9rTgKNaDPy4w==@lists.linux.dev
X-Gm-Message-State: AFq9FYIWZXrmLBQC/FoAcfRshqwTFU/NBYrUBQs8l8CsDZ+itMFX2PTX
	/6xRFMZcU3/Z15bAO0gu6JbbqecNV8yeIo927buteHqI9gh7MRyaMg2i
X-Gm-Gg: AYBFou1jgttj6Hrapmj0u0StT0CXS5EBaHwA3txJcfw27NFgz3rd3ch2EVE4ItPJZUG
	VFlVSbugQ1ThkowKQyfQX3KtfVJ3scKVoYGZK4FExlI45xSdJL3dX07w04Q0hS6K5KrrpGCZxEM
	5UdSYdqsXzhlv9Zz+9ZEXpUXreV3X7qPJda7U6J+DjHPxymPfJTdXznVHBhDkv2rOWRPvA/1inn
	w9VSg3B/4EPzmLDdT6HBSOkpXOy41lUsUFx3XaAsS1Z6bRr9c7jScgU+yV1t36CMGu0fMClP+BE
	XLExUw8iA7VPN7p97q0x9IW+LhDQUmuf0TnKTpOPx0VKUZ1Ep99TLwI5HZpCCe0pks4WPtPcG3N
	cq+DBFSRxaeAHU2GwfB5I5H/EHgJHgcvlZKW4hclIrqCIZk8Kp0K8plXuBqWnOFAR3/yMmVqRbn
	QhjD+6nSiEFhPsqPyKYPHcTvd1UCskBHXSBWAFiGzHQWEx5nx8MIZqJRR0wXGzaO2YsgofyvDs5
	wfYtsmVlfNPZnV6WGgVTRjGsqkald8QhwZ1L4xAEYvvFur5muz1thqndXF4waMpZLc6dgXQLrLK
X-Received: by 2002:a5d:5f53:0:b0:488:8b07:f3fc with SMTP id ffacd0b85a97d-48aeddea01dmr1376199f8f.17.1790602376733;
        Mon, 28 Sep 2026 06:32:56 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a349731sm28090164f8f.12.2026.09.28.06.32.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 06:32:55 -0700 (PDT)
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
Subject: [PATCH v7 08/13] nvme-pci: add SGL support for the dmabuf path
Date: Mon, 28 Sep 2026 14:32:24 +0100
Message-ID: <9d09ba51f1335a17576f3b92f0e93230c39751d2.1790602223.git.asml.silence@gmail.com>
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
index bb8051c62926..36d8987bb28d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1277,12 +1277,18 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
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
@@ -1293,6 +1299,145 @@ static void nvme_pci_sgl_set_seg(struct nvme_sgl_desc *sge,
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
@@ -1388,7 +1533,7 @@ static blk_status_t nvme_map_data(struct request *req)
 	blk_status_t ret;
 
 	if (blk_mq_rq_is_dmabuf(req))
-		return nvme_rq_setup_dmabuf_map(req, nvmeq);
+		return nvme_rq_setup_dmabuf(req, nvmeq, use_sgl);
 
 	/*
 	 * Try to skip the DMA iterator for single segment requests, as that
-- 
2.54.0

