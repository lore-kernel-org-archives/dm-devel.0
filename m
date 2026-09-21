Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7884C4A0921
	for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 13:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789997988; cv=none; b=czCgDH9WDWI8r/ScCdLolReSSxmk/sQBi8Zkp5U/M6KvtExUQcd38ZtvPdwP58V1SWrHyHUMg9Nrj991MbvrRfCqwNAl0aR/peUc8WHstiRxUtVoFmIMfDyRP+pUWTM/UKo74YlxvElhHVwVtirZbZrxeKn8Qr3W6jQ+0ikNKk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789997988; c=relaxed/simple;
	bh=smDKQevZZNHOYCALAT7ddU35ycdlQd+jI7KY7MHT/MI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tqewlx4uJwHQSuV6C+e9Y5T4sWcjXZkBQgoIzpl/qHC0jo+ljeScpe1RDI9diWRGGRAnpo0lS/jKUT8A4j+U5xi29JRGbr723wCgs+LuaskXH8cqMI+zjmSpa+Uxa+8se9OTU7DrjAd7c1TBis8Elh7TGOlRzEuC7ekuzuyHucI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XvYJHt4s; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XvYJHt4s"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e66390995so16109855e9.2
        for <dm-devel@lists.linux.dev>; Mon, 21 Sep 2026 06:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789997984; x=1790602784; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EHTjFNHsfPkUevAeFTZNd93AhuEIP81I0y/DmV6dihY=;
        b=XvYJHt4sliI1PwwazYPW6Rx7wZToGwqP/AwPNq2/vGcLSz0bnjQyDdrK3Enew1FHsJ
         NcsfN1uk45aGO5yUHuhFdTXdIl/uka4K0O+WRgPuqCXvFUYx15PCsUldTsrpz/3+lMRR
         2q7BLl86OT92/9QHzG87mngI1DM1CqBjCDRYgOZ4w00SAUk0+9FGYbQ0oW9OTJWZ9g/s
         dE/ircYrzM+2iDnmWI3mw7w/i7O3IJl2cenCCSNUh9xz3CXZMETm9Jyy0qyf9fDsrwhW
         tpAbz5YuzKZi/mE/5q7OlPXT3DS2wARI8EFkG2xS22nO8WCzwWOs2nKZlaWEkW4s+B9U
         1yWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789997984; x=1790602784;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EHTjFNHsfPkUevAeFTZNd93AhuEIP81I0y/DmV6dihY=;
        b=ANWgEkE2zXym+FbMBcoDoC+/cacRB0EIaxrltQf0B8gkOH+4qWMfqkXa4kablWZJ9C
         GZ3EZP7sOXetsqGPdMs50eBzSiunPuHnUyBV8vkn5rSdUW0ZtHM519OFRuOtHCCkwJgf
         q/RpdDn+hOZiQz7tM/aQ+DIDT3CQEDV0vPhXJx9FoKFXv+JZz/UgUUCWizAsid2YfH9l
         dXn7geBHSIejTxqMRVG3n5nv2Ea3Inicm4lwlMEvdbPsAzKkUwF6dWeL96SaHJy1ZbL6
         izsbl4Ovzw5W2TyxrxkFSrp9tSwTyeBz7uE/NS4X5tXF7ma+qDPNW/Ymp/d64khM8hFw
         vySA==
X-Forwarded-Encrypted: i=1; AKwUvBwku/t8BVK8H/pJE/A2B1n5wvyQ06akDLSQGdJGmlWXjk2MZJa35WvUPgKs6yuuvD4WlPdyQCAExg==@lists.linux.dev
X-Gm-Message-State: AFuF++m7IeFmeADUGlPW60wM1T5g6h5pYHpjIeLsRqJ2j1WDxQtNYXqr
	jLSpeErwRJ7jZvAT2ptUa1wIh1Iaoh0dZOsei3OoM9QLFmnHGLyH+PZU
X-Gm-Gg: AYBFou0MIb01HpQbgzUu1dfhb3fzkgZxP66iw0Kh9h6ld+si/48gm7fPFO/TlLWTdX5
	/QT2aWrbU+Nn6yFkQfk/DztbHJYBpM9MC60mXOTd6phrle7P9sNclGOF+GcIwclpm3R4tVDaX9c
	mcXwaToQtMPGg9v+7HzYG5YhJ31ODTdmTMn4pkitaQS4TFxc+TDFq/JkPH3o/RUVPBKEDAtov64
	+QTzNf3GiSze50DjDiBnok1AY6u/fTUZnduBCW7UVPBX5UFO3LwOVNqlr3u+lulgeqp8iSjOzLW
	RlzG99+SkiVNanbqQjLpFyREH4XaZGBLJLPtUpcF3+WejTHaowq8foltcEm+aGQ6kUvAHvAcfKK
	SrhnluaLnbZOq1KKIrs20vriHtxrZTtRIXdOhH1sbwWyHr55fXurfHa944vO455MJ9RCLDwz+22
	VK5/YDmza7z1vjb8S5QLemTyfHt5qYQ0eKBc2M4/IaKQ+P/xcoPbPq5qp4fbGhCNOw7EbuG7T0d
	5FT9PC3Hmhvxr9EK1J9RIbSUX8I7ZS0/qTbvgxmNNfLS3OuPvOJ8UMoFKZom2i8eI718yzIQjdc
	JpFRv2HuqkHDkGuuaVrpaAfEdMpkMg==
X-Received: by 2002:a05:600c:4505:b0:49a:a101:4157 with SMTP id 5b1f17b1804b1-49fc56db92fmr154368075e9.7.1789997983642;
        Mon, 21 Sep 2026 06:39:43 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-213-26.dab.02.net. [82.132.213.26])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fc585920fsm617171605e9.4.2026.09.21.06.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 06:39:43 -0700 (PDT)
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
Subject: [PATCH v6 07/13] nvme-pci: rename nvme_pci_sgl_set_data to nvme_pci_dma_iter_set_sgl
Date: Mon, 21 Sep 2026 14:38:51 +0100
Message-ID: <114bc2087c7811c849fafbf1392abd7edfb24471.1789997898.git.asml.silence@gmail.com>
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
index 3d645324f04e..8dc4002fa696 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1297,7 +1297,7 @@ static blk_status_t nvme_pci_setup_data_prp(struct request *req,
 	return BLK_STS_IOERR;
 }
 
-static void nvme_pci_sgl_set_data(struct nvme_sgl_desc *sge,
+static void nvme_pci_dma_iter_set_sgl(struct nvme_sgl_desc *sge,
 		struct blk_dma_iter *iter)
 {
 	sge->addr = cpu_to_le64(iter->addr);
@@ -1327,7 +1327,7 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 	iod->cmd.common.flags = NVME_CMD_SGL_METABUF;
 
 	if (entries == 1 || blk_rq_dma_map_coalesce(&iod->dma_state)) {
-		nvme_pci_sgl_set_data(&iod->cmd.common.dptr.sgl, iter);
+		nvme_pci_dma_iter_set_sgl(&iod->cmd.common.dptr.sgl, iter);
 		iod->total_len += iter->len;
 		return BLK_STS_OK;
 	}
@@ -1349,7 +1349,7 @@ static blk_status_t nvme_pci_setup_data_sgl(struct request *req,
 			iter->status = BLK_STS_IOERR;
 			break;
 		}
-		nvme_pci_sgl_set_data(&sg_list[mapped++], iter);
+		nvme_pci_dma_iter_set_sgl(&sg_list[mapped++], iter);
 		iod->total_len += iter->len;
 	} while (blk_rq_dma_map_iter_next(req, nvmeq->dev->dev, iter));
 
@@ -1512,13 +1512,13 @@ static blk_status_t nvme_pci_setup_meta_iter(struct request *req)
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

