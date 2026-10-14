Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319304FB9A7
	for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 11:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791975760; cv=none; b=SvumiScbh8noaI+nVmedEmqTs/iTL3vsGVIJgg7pMd7Rva2Hh2IjEXasJKwT65Fm/fkieUV/aTbCxfF4dQvH4aqGgBBk6kbCwFDRD1ZsVI+dEpCL4yLb5dpERJZzVZA8zbJiXI8XkIOXrHd3mePcVcXptQ4vpqQAxIWfPtyTbHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791975760; c=relaxed/simple;
	bh=0a99AkCdYYlGDSLNyvcoHvxyA0h7cLM0HZDY04APdmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeB36F7b8BlQYZvG66csRXlNZBXWk/mUyT+HQoTOiO9TkSlQCIiNaLFS0L7+uAhBq4B8FNgocdLXrBWAvLAQck+gih6GQTFmolw7W1KEmqCQ8g1LLEngCACdvIwk49FM4TSb/c/J+DKPzN8XDy6uKvJq0lAq/QldFPnFS7SWJOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fq+ZPJqH; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fq+ZPJqH"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a16aaf2067so10596715e9.0
        for <dm-devel@lists.linux.dev>; Wed, 14 Oct 2026 04:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791975750; x=1792580550; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SVgIYOF9sl5M4BcUqDAxFWbO5yiW+j2eX94ter+J4Q4=;
        b=Fq+ZPJqH4cuQ50O/jX9zHoiZDmOrjWU4M56nYVxI3QXTCdc9mMeLeAqhoF+V/999QD
         O7hpT+kJgZU6nemtmsyLEaEogldlk3DON68JMTkf26V2R1U0bdd9FsYNhLJCkjWQ5Wso
         EZi6XVYFVjzovq2FCy0LV1hIgC7X51a/WeHH0fj7teNI89sx8Ow1Pr8ZSQdMBXPqpemk
         YSjTgFsEU6aiEItBn603oZ7XEgpaBnlK9j8kJ/TG3ky/bSdcxHv3DiGOIDZ+X1a1yPRb
         dwnVt60PACXxlrTlk6VXq5kWoXa6f4U6uRvtjI/tFWXLpoyG/9LAyzy60WyehZZw5YR/
         egBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791975750; x=1792580550;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SVgIYOF9sl5M4BcUqDAxFWbO5yiW+j2eX94ter+J4Q4=;
        b=1dBI5jNLAQUkFYqzRglc77M08H40dcGXKQgFflDh9B+cVV59E8i5uXhkCC4rLawVm2
         qjcaxI+mrVnBGLMj8yANJ0NmwzKkdJr0K/Bb6/N9BOlN2ek79Iu3O48HqfuAUj/juiiE
         o1I9X60wK/WdWxGXwKwtgyOCEbAr6ddOuJZETFiAyi79TJHhaNnYYkptibivOdjhV6pF
         +xp9A0d4G5/gt/nQf6VVUS17Y+q7ivoZHQ37AAxdVU+IuAC6/Z/R5LA3D4vzVesjowc+
         gGb+YTAarLVjnPD2xDWJar0c2f/qisga37bYypyrD3AmZ0O1yVyI5QmXBAQoMNM65pK0
         Whdg==
X-Forwarded-Encrypted: i=1; AKwUvBxIwtd911OCuegWPGcTxk4iH/llA7nQoFfl35bu1b9yxZDc9OVZI8Jt7ZI6WU4MFaPtiZ+jV/2bTQ==@lists.linux.dev
X-Gm-Message-State: AFq9FYKomedkuEpdRoWjFulWjQXW2V0mxduaR4Y4ivU1L4WncGv91+wq
	QMClX2TDkDjrhnp7hN/43ST0J8n3hzWc+CK21NJkmaLRFDPpT74ihlBr
X-Gm-Gg: AYBFou1VvsFCLtCav9+Sw87DNpAb/RzCsPTRmrveFvgJY760O9sOMlg/cg3XEf9GXL2
	Eey/YSlqoSlbsCav43Alh9zVDWX00NQCOVHTApyuSO1363pmJATMajAUzwTmmqOtPIYHzfJzNmk
	tnjFGkCuyGfRPmIJx0il4i1KO5MnLH8QAoRb1IiTnSXG7GF+goR0xDZgHCjnkhZmC5d8KoalFSM
	k3pfkq8SfS5oHDh5a9dCVH22VcB4HmMweNDUN50fSue+1K89jyG7P1f2ASnxbRPbwMgCi+MSwn5
	SwRY07VSxrpSMapHnLtijlDlxCEm2LZ1v/2NCGBszesr0Ru6qc7YoJoLnDcOGIFaL/ZVCL35/a+
	xmtotKRgbPrOiH47FVlUZ55Euwkkc/CDYfw1UbUDI+GvIbpuO08etqrj9rcJewfgg74EVBuQgKW
	tnqc4/o1HR/Dn69SghlVwNgHw2JppkDee4DnUCSTDpVWi/Tpukd7bxhTRn6SQWbNyZ0NFFk6o+m
	ny4/ZqdKqUmITAzZRf/DEaIGW+HaXyuioHKhWaUY4Lrih6hwGzTSlffYKJrf4T3tkuQ1MHxAVrO
X-Received: by 2002:a05:600c:3e87:b0:4a0:a34:6e7d with SMTP id 5b1f17b1804b1-4a18e4bacbfmr282470095e9.18.1791975749999;
        Wed, 14 Oct 2026 04:02:29 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b45eb78csm38078845e9.2.2026.10.14.04.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:02:29 -0700 (PDT)
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
Subject: [PATCH v11 06/13] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
Date: Wed, 14 Oct 2026 12:02:04 +0100
Message-ID: <42788b01948b58b891476006cb7ee9f9f5e917db.1791975048.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1791975048.git.asml.silence@gmail.com>
References: <cover.1791975048.git.asml.silence@gmail.com>
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
index 77317e5d00f9..a65b77726e4b 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1147,7 +1147,7 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	return BLK_STS_IOERR;
 }
 
-static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
+static void nvme_pci_dma_iter_set_sgl(struct nvme_sgl_desc *sge,
 		struct blk_dma_iter *iter)
 {
 	sge->addr = cpu_to_le64(iter->addr);
@@ -1177,7 +1177,7 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 	iod->cmd.common.flags = NVME_CMD_SGL_METABUF;
 
 	if (entries == 1 || blk_rq_dma_map_coalesce(&iod->dma_state)) {
-		nvme_pci_sgl_set_data(&iod->cmd.common.dptr.sgl, iter);
+		nvme_pci_dma_iter_set_sgl(&iod->cmd.common.dptr.sgl, iter);
 		iod->total_len += iter->len;
 		return BLK_STS_OK;
 	}
@@ -1199,7 +1199,7 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 			iter->status = BLK_STS_IOERR;
 			break;
 		}
-		nvme_pci_sgl_set_data(&sg_list[mapped++], iter);
+		nvme_pci_dma_iter_set_sgl(&sg_list[mapped++], iter);
 		iod->total_len += iter->len;
 	} while (blk_rq_dma_map_iter_next(req, nvmeq->dev->dev, iter));
 
@@ -1359,13 +1359,13 @@ static blk_status_t nvme_pci_setup_meta_iter(struct request *req)
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

