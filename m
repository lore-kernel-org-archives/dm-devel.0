Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38A6352022
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791336742; cv=none; b=adaYWgUskQ+CvMuf4bw6bEHokOWHW7+MdT2ixhKy7PHXB6zIF+0XpBJmtN6hwUZsTyCaVyx2WuihgX5+bgPogXwew9/PwfuMKG6ZwIkUil4Ohc7QcY8gChSKRemc3ZPSlzgDS19ergdpVBY3jdHnjQrPTgQ4utQ4Jn75DJlzt1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791336742; c=relaxed/simple;
	bh=0a99AkCdYYlGDSLNyvcoHvxyA0h7cLM0HZDY04APdmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Imvp4mveXNv0+L2r1Uw8/Pjj5mhnpXiFBoLyfN2oEgkgkVOJV4X9TWcwOnADj390PZvbhHwpTByFT05DaOKSfShTN7snkIF8fxgiI49aop0hWrrFFHU7u3wOyFvxtG0zpLgB44T9CZc+Fow7CvVkgw9CjR+NKuhqUav9mJEJgNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FxqK41Ly; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FxqK41Ly"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4995b0343c1so21776975e9.3
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791336739; x=1791941539; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SVgIYOF9sl5M4BcUqDAxFWbO5yiW+j2eX94ter+J4Q4=;
        b=FxqK41LySi11ePo2DRz2Hzy2xpkQ4vGE2270L7CYlLKACDHFRAQbypAN+mG3vfGYf9
         EsjZXILWQCK3wVAMwEOMcrq/yxkrs1iqTMsVjPX8yaDhWwTaMuDghoKa/ZkIVNUNYVuM
         pbOCdBnMqcchUtmMJOxkpK5QWTVoM69ounPbVrUDMEBT+bOFp5LKPtVQeAnrzbD+0b9S
         ZcRX3marFK4mb3XPfAxOM3sTQeLgZJ2l2sLRgJiIhuLoUyacnjNyxi2cKZGrCTph1eWk
         K1ql+v5q3g7N3wRBBE8TzpGoy6rUZGFQYEBxuP/b0EPQyV3G8eOk+NH7WjXnkOueGIN1
         HJPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791336739; x=1791941539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SVgIYOF9sl5M4BcUqDAxFWbO5yiW+j2eX94ter+J4Q4=;
        b=sNxXFO7USxETN+S7VBkYnooSvPUdSdhWiKilOZ5bkK8pN4rzyQ6sTEJSnP0j9WQ/CA
         HFj20/9ekxOsE85psv+sJkzyCn8nwi+MB3JdqbiBYeHC/a9/NzJP9wTdFXsVn99Z65Es
         nmt+xRre7URg/LPP4zFaUoTzzU5H37LA6TN4vgpWelqN63gFhYvZUPpSz0T3pmFY6Gnc
         jrCSJWC5cbSpIUff8yqKGy9qcDmE0nkM4csbbey9la9Ns9pQSE20Px+CmOjLz27//B6c
         EIffoDy1X+Xp1JOfOAJ8FoLp9hc8ZAKBBt/7l/mkG67Ix+MDrTuBltW3j0l266aDzb4k
         Ljug==
X-Forwarded-Encrypted: i=1; AKwUvBwJIutr42tZqJ0PTpJ3of/KlPR6w464UFIeGTjehq33ktSVT9C50t2UD9JOqBfFupHAqb4RgrpIYA==@lists.linux.dev
X-Gm-Message-State: AFuF++mNY4ovZbkwbFL1yiDDJrZvGyDAdDq/ILAHjOqoBUOA9Rsq+2ZS
	x8UOVyHNwmCHLX1NvE6FROZn6e7erTrH9XmN+b4A5bqzgzzgdLMBI38C
X-Gm-Gg: AYBFou3/1uWIbd2DvNdUAyYLFXlleDGp4L0Sie0wX5nlEcs6Ne1ZreGDAmJkS7x3TOV
	ktCzAce6szbDr8nnOqt5SW2hYZD5bpDgxs1mPOZ5wgs5tCUdy/GfMALsqrNNyX9Htwq/46r/5iz
	N1naBXJyF17WWzrJaoVWjfsXtp6h7W+Nvc1Agr3XQjvYjvg5bzl0YQg45swKs7n0OrevE/U9YLd
	3vGPqO+z+ky4tKt+CkpG2hSmxrJ9RDhtbk4rQgr2utKVFDENShdLZPhvj9HkfsG785BAQM20uT+
	wp432FnLc8F5G9MZf2UmfwENUsYWY9CrXh3FdCCTG611vkqHjz+PndTCluNIF4GaVZG4LsJ6hmv
	tJDJ6FL4HR2CQPR18r8WWBfoMYu4mkgGfoCxDDIQiMdeJcbHIY/UDyln/DQI0Mv3xVRA9WgCJNr
	nrneg5Vvf79hdu4uvaFC+CvH5CDXW/LLfNYy9CRIApTlFp/EEdO/1KrR8GokM5j8aF098ZhYBd1
	/LirYNJsc1pH0RXlzAbvCCmBfSzIbg8mkvghE6Ds/b0L0M+Y7I7rBhXJTR+vZmLUMTtpYzchv8S
	QZ6Mdt26ydg=
X-Received: by 2002:a05:600c:3f0c:b0:4a0:251c:fa72 with SMTP id 5b1f17b1804b1-4a1803038damr7433835e9.11.1791336738926;
        Tue, 06 Oct 2026 18:32:18 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f6538b7sm21183615e9.13.2026.10.06.18.32.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:32:18 -0700 (PDT)
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
Subject: [PATCH v8 04/13] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
Date: Wed,  7 Oct 2026 02:31:47 +0100
Message-ID: <2f8b57f68fd3e432085b3a7767971778bc7d1919.1791336002.git.asml.silence@gmail.com>
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

