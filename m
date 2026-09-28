Received: from mail-wr2-f35.google.com (mail-wr2-f35.google.com [74.125.225.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D2D4CC62D
	for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 13:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790602384; cv=none; b=b4Oxdq3OLwnUjCWln6an0JDW5rASQETYSG0gbBLAMD6zSm+AV90ceeHBPm9WB4x/sR5n1Ae5uqI4r3XpevTB6e32wOoeVuU7gwb13F/imVKPKnLBWJFdTnvguFxR08KHqI+G57YO14+bmYTgQ5MNLKui4aB2K1UWLCU8bSXgeTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790602384; c=relaxed/simple;
	bh=wiOPOVzZkfrXRxbFz1UgU3+Xbr5CbqnKoLrDHMr2xo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osvPoayjQc61yX8ZQ5gS0dQxv/l2yHAoTud8I5op+PQP5FUBz2BxEjc2Yz/gfpEHEZsjmea+hRuHYWn8z1gEpwP62Ft0CxI8uw4QwxmdlEFMkMarcglX9oL1nZ1t00YRzcdlL0t8WVuf6Tu++IBJdC4BfRqUlxFum6Z+yoXIe3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CeBJv2QF; arc=none smtp.client-ip=74.125.225.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CeBJv2QF"
Received: by mail-wr2-f35.google.com with SMTP id ffacd0b85a97d-4887f6cf16bso1859120f8f.0
        for <dm-devel@lists.linux.dev>; Mon, 28 Sep 2026 06:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790602375; x=1791207175; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z28dlsJTIpkqTAOZ5w69VF46XysVuY21MZeRZQmbEno=;
        b=CeBJv2QFAQu8Mqy4GOawfvcHtp4vz3EsgkrK/RpxTOlpj7b+TxHBg7n7zbDrUD8AO8
         asIbjydUMnlYjRN557RoEL4MvCLIhW32pFh6g24HHE5sdgIR3H5TaDXNkMZu6dGW3HFo
         jDegTG437fOjEtcgVQiLR+pC6v7Gjw/2MufMcnl3aHTAxNBP4qlAibsIQXKbqB6urq8N
         Yg5QKu9w2KghjPhcX2sSKqOJ5zynVp+AXpimcvCqbtmH3mQysnrJkND87fSNSQA8RrOE
         BtGshuj7XbskT4m7QOcJPnkIDnrjuYJqk6B5+KBELXoKEt+20zqyvut5LAAc0y1hHVno
         DA9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790602375; x=1791207175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Z28dlsJTIpkqTAOZ5w69VF46XysVuY21MZeRZQmbEno=;
        b=0Z5cQHAn0ymJBUPhTntm3PKSYgUrrdtArHtH+dwEvwd0cHspoTutPXomZdiYLX/tK0
         gyyRblUuxTAHHCBpTVww0ye+pQ3MD57FVgg5wSB12BFBkqrY7YEWnd2ifjeKsEjsqm/V
         zQ0+zaoaQDYmRwyV9q7VDsYsn3Mx976t+GS+TSu4eab7wIgebqH4GyceNlxNBO5ewB2d
         9iyraypKGFHOevf937WcpqrUBbxsyLKq4Ij7UVxexpm9pp+QfM4ecn5yJNM5zgT+Ow2V
         4ocVhZxf6w3YZNg5WTPCP6UpMQ6XoPL7OF2L7OrIyac5yhnNjE9hANGaClgQylDaG6Ot
         guag==
X-Forwarded-Encrypted: i=1; AKwUvBzjmzGcn9knmpfFpd2a5I/JxQvGfnbmL63nxD8Lm03y7bfcG4E3pKSPBY1DiEKxFK5+gH52yKoPaw==@lists.linux.dev
X-Gm-Message-State: AFq9FYJ5Jgb2MPHflh29Jm6ks32046FoYwkmDWfS+OVpc4loBkoURnYP
	eo0vVVUevh75yCeWkDJTNRd5pz1thf7dQ6YLMS/jptXyQzgfB+Zw9iSf
X-Gm-Gg: AYBFou1bkbjrBj32TMgkpynxSXA0WM+Nu85EXPTiE3KacxBEqWkJKDcF8wwWOGFF5iU
	U90cdxCqtLp5fO9sajqpRFlp6ep7FVQy0EKhGEYJHVYt3RlzhwAjUhQQoO855ZvWdFBoyuDR4w1
	vIml9cZ11kR+EC7qPYV1KwEb4C1frdPcvJ+BU8yGtJe613R3nlgn4AYt8WDIPztwv9wMPHY0BSs
	dWXdq9xLphTyOEu4oQ6xKIEvuTjYnqUsrd4a+1mIHjPULrvcOVc/Q80MvP9HDzg3NW+YaKFv2d2
	sboaqWljeAZ7OmX/WK855stgqtoIfvfDq2bMdeU8cJjbcpw/Ic+Y70hOjg0YXEUyxrBtNQlValt
	BFN5MNu1hM6qxBWolvYHbkWCoCgYwJ++vP71vXf9zDXbLj0YoheDhAAN0fpGpXf8khYklGWYudz
	CmIXYkj617+LA+ZJWaCFZLzy042X/yk8DUa1hW3JJGJMyNSkzjFwCp0t8emIuwW/Xil/yxikmTC
	dAajflpT1CWuaa4uP/I+BIkUOZd2i5G85tMMPXtDaBIbRPXr+HCDzyNUY5MNP4tKmBlCfIX7+HK
X-Received: by 2002:a5d:5d87:0:b0:487:342:d147 with SMTP id ffacd0b85a97d-4887db39b7fmr20252053f8f.39.1790602374884;
        Mon, 28 Sep 2026 06:32:54 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a349731sm28090164f8f.12.2026.09.28.06.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 06:32:54 -0700 (PDT)
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
Subject: [PATCH v7 07/13] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
Date: Mon, 28 Sep 2026 14:32:23 +0100
Message-ID: <f950827b5805d13f08f0060df0eebc4ed56814fc.1790602223.git.asml.silence@gmail.com>
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

Rename the blk_dma_iter based nvme_pci_sgl_set_data() to
nvme_pci_dma_iter_set_sgl().

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/pci.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e58bdd9a4098..bb8051c62926 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1277,7 +1277,7 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	return BLK_STS_IOERR;
 }
 
-static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
+static void nvme_pci_dma_iter_set_sgl(struct nvme_sgl_desc *sge,
 		struct blk_dma_iter *iter)
 {
 	sge->addr = cpu_to_le64(iter->addr);
@@ -1307,7 +1307,7 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 	iod->cmd.common.flags = NVME_CMD_SGL_METABUF;
 
 	if (entries == 1 || blk_rq_dma_map_coalesce(&iod->dma_state)) {
-		nvme_pci_sgl_set_data(&iod->cmd.common.dptr.sgl, iter);
+		nvme_pci_dma_iter_set_sgl(&iod->cmd.common.dptr.sgl, iter);
 		iod->total_len += iter->len;
 		return BLK_STS_OK;
 	}
@@ -1329,7 +1329,7 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 			iter->status = BLK_STS_IOERR;
 			break;
 		}
-		nvme_pci_sgl_set_data(&sg_list[mapped++], iter);
+		nvme_pci_dma_iter_set_sgl(&sg_list[mapped++], iter);
 		iod->total_len += iter->len;
 	} while (blk_rq_dma_map_iter_next(req, nvmeq->dev->dev, iter));
 
@@ -1492,13 +1492,13 @@ static blk_status_t nvme_pci_setup_meta_iter(struct request *req)
 	iod->cmd.common.metadata = cpu_to_le64(sgl_dma);
 	if (entries == 1) {
 		iod->meta_total_len = iter.len;
-		nvme_pci_sgl_set_data(sg_list, &iter);
+		nvme_pci_dma_iter_set_sgl(sg_list, &iter);
 		return BLK_STS_OK;
 	}
 
 	sgl_dma += sizeof(*sg_list);
 	do {
-		nvme_pci_sgl_set_data(&sg_list[++i], &iter);
+		nvme_pci_dma_iter_set_sgl(&sg_list[++i], &iter);
 		iod->meta_total_len += iter.len;
 	} while (blk_rq_integrity_dma_map_iter_next(req, dev->dev, &iter));
 
-- 
2.54.0

