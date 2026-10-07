Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D662351C06
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791337408; cv=none; b=fnHUzEwyXOrSpEjt4uD6gJB860pIRs4eVynCoQHOv2eZL+j3wqi8Yw1ezImLnewZAVBJc5QMJ5KneLk3KqXZ9K/3fqEocMNnIJW6s9VFlU6vNvJu9pL10EHch7lerOznG01vbNAYEGznZZTr04GHy9UnMGDYrPdR0A4DqIYp2CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791337408; c=relaxed/simple;
	bh=0a99AkCdYYlGDSLNyvcoHvxyA0h7cLM0HZDY04APdmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfzohQplIvnO0jS2/tjb+rMO+8skgbdrOjZCjDnPLm1J2v9jKbgP2ABYeJJ/Z4QeabY/C/HBOQidKDGMTLFXXtELV/yo72VpJHopvg7FRaUkmSsBfJjQHYOMSxgPoQ//lmzjoMtPt84YMylMI28pNA0RK6BWlYGcU8CbVR6i4ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R6tXHLtD; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R6tXHLtD"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a1698ea378so10372375e9.2
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791337399; x=1791942199; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SVgIYOF9sl5M4BcUqDAxFWbO5yiW+j2eX94ter+J4Q4=;
        b=R6tXHLtDMt3CZxdI8k70PxPzCuc+B1MWVqGZtd4VqpceprPqXbr5RF0O8VZRpNOKy5
         xt1n/VO3TJhqtQL/GMMdjHYPKuSpD1Va/y2NPMJTSTgeT1XTTopRe2oryU5pCNWInaEk
         6OhN8THryVpBDwfv2uWYrhPxnX2zpP44mjPZU52lwwq4U8Xy4xvUoqFzGxEPXMN9eHbk
         F+zcStPDPHWEIl9xsURQGDNsj/iZg3IEkBAl4eqch0PLpsXgM7QJyrxJMVt9vcMWJ3qd
         8nUvfcZlxCqSlynb+YDQi43w4MESRnQ/C+EDBXBSe6dTkyOFgpZUOWZHP3tLYzcsjhJ6
         vg8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791337399; x=1791942199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SVgIYOF9sl5M4BcUqDAxFWbO5yiW+j2eX94ter+J4Q4=;
        b=jo0kjXi7eqGSr6qb+WpYj+GnlNLYoyQ5bU2Qp4kkrXnRvqKBguTqbptbipYmWW8VK/
         XlmFWwvvjiQpVQ0clBOCx7IS0GrSE/ALxWWMx3u6tPiZaQCFt4rgyvgi+QtxhtdVOA99
         QWxlrMz4U1yKmxtwWpXAp7S3jqdeYlDCadugynJJZZhBlfqT+INJRcYMxZU4oKIcWnxB
         59vQ2eLe9yCF719NCYIfNPeTLoAnUqESS3A9jU6CndydRImUaghRQiSq0Ad0yPKlvT9G
         bxcg1PeEGdrpz62js7h5vr0rfRe3d3zfQUbjBnF/4noIRdaq9XRNkvh6OEt7FHwPSx+E
         EwYA==
X-Forwarded-Encrypted: i=1; AKwUvBwTwZnesK6zMZQVCP9SxRS+dduAxvVowT9YlhWgXAIixtd3SkU/gZJf5n599tv3uLwE1U7O7OVGWQ==@lists.linux.dev
X-Gm-Message-State: AFuF++kPF3Y20tHufQDxDvmoQmsl2EHsNg6GvbZ1ilVImtC3cw5OjmYG
	IZqFMyQLVnIoSDU73ZzWggoBE2xyYV7uHxS+lshaY781CDtVqnd/0h57KXKd1w==
X-Gm-Gg: AYBFou3ye3Bcb5QXvTVQzGm6IbIsQYNQVUiP4mSigNI3TkMrdn67P/RkmuyzEa0sw49
	Or5PshqQu2DE3yKbHdugr9qUzv3v/aVjWZz1YmTuBrojsVabEdDHZ3yxk7XiTHexpHwuSnh1OMW
	BUGP13+ZjVz/0igzgVASMPNwZ01MqgYSPmSoeji0wCEeLj7CIS6Kt3wnQHPs4qCz9Vad4DRMxCd
	UmxBL+BlZ9xGbg0HtvvNAVbw1ajw0B8ueHZW7bfXrIvipsX0LYU6abN9OLmQImgaPwtdOhxnfJK
	pfg44BLWfDQPQ41vOnt+m4THxIE1esy/TvQ4JtS04lJ+MiW9I87Wyf2TAMJnhSRZZtoGwUyU8VQ
	hSaUyOR5miEL81szvnf6+nNysO/dyCuEJDqUmhWrKPYqib6KWV0AlzrxFDYHgPFhbbWxja9KNFz
	xKhPA8bVBDV0JvVCIHKHpUeNj8O3Neu3pnop1njm7mfJjVXmlsH9190xgAEbOShClOqO63+QlRL
	421HDj0FRUk75uJfwzB4rU8rYwz1P4KE4TCbe4+WuN3aTe7wGkFb63HGtRZXY6xUc8X+XNW0y2G
X-Received: by 2002:a05:600c:348f:b0:49f:dd9f:6038 with SMTP id 5b1f17b1804b1-4a18043b38dmr6958715e9.25.1791337399492;
        Tue, 06 Oct 2026 18:43:19 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f653d7csm26423895e9.14.2026.10.06.18.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:43:18 -0700 (PDT)
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
Subject: [PATCH v9 06/13] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
Date: Wed,  7 Oct 2026 02:42:49 +0100
Message-ID: <2f8b57f68fd3e432085b3a7767971778bc7d1919.1791336930.git.asml.silence@gmail.com>
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

