Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260A554CF40
	for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 20:55:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791924933; cv=none; b=k/92VwA1HZpmazogIwiirH9vJZGzu9Yg+k4TUo6KVvvZqZlRjsTEWzPMqMzTAzm68N2Y+LlHfNYP1ZSI2h3oISrnYoLwpshic9YVj1c5scRcv4QHadNZ3SjevICCx+38uoRcvXoAOnJKfzhdeg19f5TCOl36PRHpjvhvxAJC0WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791924933; c=relaxed/simple;
	bh=0a99AkCdYYlGDSLNyvcoHvxyA0h7cLM0HZDY04APdmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4TODz8UgdFE850SU03rx+S2HHBqOQSAaQBBAQ3o+/P0Q2XA1YiOuKVo/mhykRw9egYVHl7bfsDehC+9ErqRcA3XSwwoioHMTbbGWocGLmt7EmkXjks29U3RFg3ci5QbN6o9YVhA3lVJyTX4509Ty+FPIQmld4wJ7xStKa6BiPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JCq4M0P0; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JCq4M0P0"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso2442292f8f.2
        for <dm-devel@lists.linux.dev>; Tue, 13 Oct 2026 13:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791924928; x=1792529728; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SVgIYOF9sl5M4BcUqDAxFWbO5yiW+j2eX94ter+J4Q4=;
        b=JCq4M0P0MEhcx5tQ0ULL8O+SzamSgEn2HBOGzWaATFibaDXCRIvmBz6cFFQWaZypCq
         pDvAHa6CbY4OS52DhjBXUEowaptV4EGNucYZOopgo7h7DerTtVnwJnA7qouAtEgtVXQG
         xz2+UZqKSgqn04lpDq9LOsIOFV9W3SVcaOER2R76JFx8MCX3oOynkvqRbO6IyYdltLvj
         qF9MYAPQtTjjgFgz2roOkr30N5QSDDAwGvPEJwyTt2eQjkRelzfhXQUfT9NMhxWoPGY5
         0ZJ1NMmO1VwMbq3Zhy9Es71nF/7hEsUD/yGgGJD7P52VwCtJ8WaNeb3skht4At+/z2OH
         o0PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791924928; x=1792529728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SVgIYOF9sl5M4BcUqDAxFWbO5yiW+j2eX94ter+J4Q4=;
        b=0pswxiwqa32/Ub5LQzej+f1Tj70l9IuY/UFM9zP2UVq83Vs4DwhhnUBHq5eZaQKQnT
         IUseaBt79pwoLusLSIcEIu4YzRKX6l+TBV1pfHymH1VCvlmUGmDo7X2knoLbZJ0P4rtg
         cqTClCnm+nEkWm1ZyXBOrDq58EmpSGBlXhSmn/swqM782QKkn1OShUZzX9NcbNX0OnSs
         z7j0VHg6PEu8hsNnn4sB5U1ii9oIhl0rtNZrrvCbKuvkiD5yZYybHEfg/K5Ugr0gw3AB
         TmTOEIpY9AnIANWP5SbTbvEURE9MDcEduN+HTm6vvDcqFe36ceeFkotGPV3qjqIlPFdu
         hMlA==
X-Forwarded-Encrypted: i=1; AKwUvBwEFShfwjAte0Pa/R71fsWGufw8oxeNqwtCehlkfajJ1m/Y8ieKDA+BklmXJEAXyy7YWHc7mqpZpw==@lists.linux.dev
X-Gm-Message-State: AFq9FYLoXwPY5vb10PCzwtHhMzl3y2eVWBrE0bkVu3gWOs7B8hX6QJgI
	slDUWbOeWGkv8FiQkytUVvCrso214PfR5RqIoI+UUrJyo3A2b2gxaqrB
X-Gm-Gg: AYBFou0vjX+LZmF1k6YJ83F9c2RHcmjO7kgcLqsLTHH/MboMpgziWPyPBAbDiwAm903
	nOmJpA9h8lRan43PwY0hITCDDOn17kfilvS0FcxgYb1aMBYYcJSzQMBtDCUP+WLM+SfThl/tMjx
	tHZKjG752Jtt3/G9zVMDP7o/Mj9xavHG/0bStWCaNu+FYaUtDMY8936/qQrF6dvgXYowmfL/Vq4
	LD/izrgfaJJgT5kDe/SVLayX7pI3fgTPlRL07Y0AVPS1FEq/Pcebv3pqCE6T7SwUBIJ5mwlozwA
	S1Ge24kVPnXzXjmcy+gutXjamAp9GhUpF4r7CzMnMrTtqDFftcY+Yhfldw7SmmQ/99oCxt7JnlJ
	a1B0JD4CsQZFjxle31QktclKCIP3oyJPHdhv0YrBrOCphkU52Gt30UMJmVkDEyXm8lYtbcdLmo/
	SjKH6tZ/ucLfi7bHHzFwsYNQQEAqkfq6iRqX+g+T8kcKIRgN8nPBSjxZ82JsxjD9J6XAXzkHgPc
	YSfE3RJ/yYTDEW2ha4uH37d0l0Xk9A3x4TjSqmbG1H42TNOYHUv00bgzSOy3cBVeeXHCp7UmWZ6
X-Received: by 2002:a05:6000:186f:b0:48c:7c69:2dce with SMTP id ffacd0b85a97d-48dbace9dfemr26073729f8f.16.1791924928152;
        Tue, 13 Oct 2026 13:55:28 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de7273a0esm2380730f8f.29.2026.10.13.13.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 13:55:27 -0700 (PDT)
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
Subject: [PATCH v10 06/13] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
Date: Tue, 13 Oct 2026 21:54:50 +0100
Message-ID: <54f1186d20a7c24075dd38eda1dfc7ac3705a13e.1791924581.git.asml.silence@gmail.com>
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

