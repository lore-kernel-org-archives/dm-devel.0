Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E0C30F7FB
	for <dm-devel@lists.linux.dev>; Sat,  1 Aug 2026 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785599426; cv=none; b=qZIG3P+vJH6mCd7nwKf3Gvk4eIc4NMAlarfTDVd8Ev4X5BHMTB8CXnI7vqdExamwqlqCd8Fz31wR5LbNCsvjcx5OObz07WCUldgiJZUtFv/GTsHLjDV1woI0nntF2yzahG3pyzfdAfaGNq2f3W0kMm8vdTruhhSedMa1oEZB/Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785599426; c=relaxed/simple;
	bh=5jZAhWEaWbKaEJ0h/lpCMDFZsTZrSyaTXCzcWYUXgLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrWuqPus9QXA+M/paOdVLYpvZbxbE7zAbIY65DGC3aGadcYwTVPXlhhjc+IZVzz75o3bQC4fk9X1S3hSg7+ro3S+/K1foVgsQyoh0GbhYemSojCrjMtt+bOscUcpLpQ/XvUw8aJpIZtBaCOd2Bvu5fxQJv10gHxcJIxLxundHlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RyU55AZG; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RyU55AZG"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2cf6d65d8a7so26950305ad.0
        for <dm-devel@lists.linux.dev>; Sat, 01 Aug 2026 08:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785599424; x=1786204224; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UQw568s99USSdIytlPm2Vpoz5MduETOEjKRltqiPXcQ=;
        b=RyU55AZGOHouTX6TRVawlu29jtkJdUkpsS81FwSy7pIFog8JfRuKaHCG7/uBXEKCAT
         P4hAWiulxxdK9A7kOE3YpsSOp3kpJWmwjdD03pc2cUgfqX+9I4DAYn8kU4mLR9r9ipKY
         8cecG2sSAl3G2MLG3mo2aUj0uBYM3arOOc01i+LfJ1rMVUpu+0shnF/nMBPIOnz3dyDA
         xupJq8vnSwc5zb+8c26HJ+ve9bQBGKML6Mfl9tI5AQoy/MydTivw1Dayhuy+Y+Dk3/IY
         wqGKJn3SN7wnDJ72heY1TcNEm56QAohzXFzao3A9Mtlu4aM8vsO1z59dFAfjZ4wNoqV9
         b3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785599424; x=1786204224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UQw568s99USSdIytlPm2Vpoz5MduETOEjKRltqiPXcQ=;
        b=PFJYJzZMbV/XJMRSwv8b8n1Q7PArdQHVP/27a6OQUm38P8Nl+r6rr74meCNiowjbi+
         FqzRxsC01S6Hqx1x/WCh8gztqfZclUH9QaskH5kMRGxFaBLXf9m9gJG24gtQkCUWwpCz
         RmR18npXAfGwlPQ1lskSjORZAH++iy3FSrmVhmRg88GT6YtCLlwmMbZOW57Sivq/y71o
         bPr2iNTwJyJRKA/2XPNtiPlLCdhWyQT1NGwpp4zW0h4WE0s/zNtIu26cVzYSCvCntbm1
         0SOj6nu7Jnm86bJrhNsww1QUCzTV3YuJlicZWdEmm+3licKll2NNOvTQJYY5ACzBtrOY
         95ew==
X-Forwarded-Encrypted: i=1; AHgh+RpKQdWXOXkVitHrnCH8rH5qb/VkntkE081M8n/cnf/FnrCbL5LVExPnTEORdkBO9WINIqNeZHCfCA==@lists.linux.dev
X-Gm-Message-State: AOJu0YwajzMymlXXQYmBoVnry/4JSgRnZrEsOQnG9UdLdOqdiw5SJpJM
	gfy0w4zxf0jq5Ekaqdyg9zWlafNv0yOB0GEMtirizZMc3Y+tFeIV4hCP
X-Gm-Gg: AR+sD11K7fKkHe8+C0n32XuyDdyrHUUX40Xvdu9dBNyWlSTCIIYex1GMPflRWORCMmI
	ksAN+jKexiceXLCS3MblZpqCdrbZwVhEdRp4/MS9BBowrMG7ZNQc/ZjXoPjjzwszAwfxQPNlLET
	NG0oKoHNLyAOCnnzgLDwoTGsIwADl646AT90m6Vmm2Vt7HO/2GYk+aQ0wVC41yLqXeZC76vTU1C
	r4AXgIdOEyhhUZtbsuVO4Koqrjzv+Tn3bEOydwt8fLloKeiPDm7JfvdG4MhGpZcegRpwqRH/KFS
	eAws/KghnO4tHT8p2LAXdn+So+kfBSQVOOM5H7rvcA6NwI9j1+7kRaH3EMj78mEQaq3+ODy404T
	M9PfRV1RK64ozRpSiB7/Sqz68I2yGPLxoDQtV0UaU74d2/neyvHHCUtPWNgqb5pdEXlPO5Q7pQv
	h57aGSGLshQ/tI5u01ar/E2Ofa+1eh5XT0X3AsKrdPAXwcbx7jBcUi1M/MpGHecs3wY90N1PmBD
	rqo/bRt8tzFXkg4tLFvddxtwMordn/GwnGWPxha8lSTa7J9j2phSDxg3g==
X-Received: by 2002:a17:902:d2cf:b0:2ca:a03a:29b2 with SMTP id d9443c01a7336-2d0521a5657mr42155635ad.8.1785599424386;
        Sat, 01 Aug 2026 08:50:24 -0700 (PDT)
Received: from 127.net ([2620:10d:c092:600::1:61d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b12202bsm18287605ad.66.2026.08.01.08.50.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2026 08:50:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	David Sterba <dsterba@suse.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	dm-devel@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-btrfs@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: [PATCH v5 10/16] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
Date: Sat,  1 Aug 2026 16:46:22 +0100
Message-ID: <ff507b4895521074938d82fe2647e003359ec2be.1785596451.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1785596451.git.asml.silence@gmail.com>
References: <cover.1785596451.git.asml.silence@gmail.com>
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
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/pci.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5608ede6c479..7b8ed101a13b 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1287,7 +1287,7 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	return BLK_STS_IOERR;
 }
 
-static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
+static void nvme_pci_dma_iter_set_sgl(struct nvme_sgl_desc *sge,
 		struct blk_dma_iter *iter)
 {
 	sge->addr = cpu_to_le64(iter->addr);
@@ -1317,7 +1317,7 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 	iod->cmd.common.flags = NVME_CMD_SGL_METABUF;
 
 	if (entries == 1 || blk_rq_dma_map_coalesce(&iod->dma_state)) {
-		nvme_pci_sgl_set_data(&iod->cmd.common.dptr.sgl, iter);
+		nvme_pci_dma_iter_set_sgl(&iod->cmd.common.dptr.sgl, iter);
 		iod->total_len += iter->len;
 		return BLK_STS_OK;
 	}
@@ -1339,7 +1339,7 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 			iter->status = BLK_STS_IOERR;
 			break;
 		}
-		nvme_pci_sgl_set_data(&sg_list[mapped++], iter);
+		nvme_pci_dma_iter_set_sgl(&sg_list[mapped++], iter);
 		iod->total_len += iter->len;
 	} while (blk_rq_dma_map_iter_next(req, nvmeq->dev->dev, iter));
 
@@ -1502,13 +1502,13 @@ static blk_status_t nvme_pci_setup_meta_iter(struct request *req)
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

