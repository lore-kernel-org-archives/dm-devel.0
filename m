Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40224367B96
	for <dm-devel@lists.linux.dev>; Wed,  7 Oct 2026 01:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791336749; cv=none; b=mIZG2iCZZdf8oO+yytlBFlpAMvbiWkhfYUaD564qrO+yhr6Yww3ipxeJOpXZ3a+34j+hYMg3YDk93sDCjgcMJSVQclIeD/KGj3bEVS2gD+NWV4J4ZVRf1pXdY7jQ7yKm9p3KEYX45vYUZe/NpyYWWMU1NzyahMK35G8+QlkUah0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791336749; c=relaxed/simple;
	bh=Pm6Rb7wT+j3sduRH8AC/hPaPOXEeHtixW7LlbFfv5Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDtMRdAztEtFDePzzg9IcgbtP4Yo2pApcnVD8f3R0MU9ag2aa7njqDIYXHs0zsDvH6AYV4q9awUPnswvKh1Lvq6xX0AJ+819KtbD7lCRcVDn1VU+nmquQeS0UYViuykhrPzpGXH4gFHd+oW+AC9asmGAgLVf8EQnU1tm/nTRP04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OeYSsHfE; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OeYSsHfE"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a0213948d3so8584905e9.2
        for <dm-devel@lists.linux.dev>; Tue, 06 Oct 2026 18:32:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791336745; x=1791941545; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fZk+12RxIUpX87ik4Sju0ydtLd9LDkS9K++2ovit7qo=;
        b=OeYSsHfElxC/OlVMyuw9fen+tmoUhsMN8+p2fy++qwJucyvQZ6A/VQi+7z4BhMwY7g
         pr6wZ+2Bj7oZMuKN2s2ONAGFttia1xZA45SxVQ8/+G5mnyyor+ChnaOgvbbOpNrsxmXY
         vdOS2M9mBinghHzf3uFG77H1T4qvpobqBNGxLM0ZigJh4E27d576I6HS996N5nRx19jE
         30nmle8u4XL4kBnRnAm7zCk0KhnPIv/zeCuJOfhLRbtt4lpfDx01FXkqggT2McPp8Q48
         9Q3OVrGsw75zupY4EBrQpx7nCyWuvQ2T6tKwaiUQ2mjEMJQ7rWrqhheDJdJEuYl9Dkrr
         8VwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791336745; x=1791941545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fZk+12RxIUpX87ik4Sju0ydtLd9LDkS9K++2ovit7qo=;
        b=bpl/Y0kJxBYn0LoQ6nCcvTJBCMkH2oxqJEO5hmD9TfmvQ24kWTKjj+nDHMUAE3Ln0+
         fQFQOP3cne7Bb/ItaWseXPi8BC+fbUA/UuULFTbIEuljleZWnYaW2RFDhUYIcjzEtQ0X
         8UrBfEWwtf2yFkE/BJHHsTXyACtOgmVtIQVJkQceSRnZvYQsz8f5JobXVmaHsXwPw5Ur
         MHNFNahJwbMl1HZ+yHvAyNvf2hBR+jERBg3JP8IGQbeDwUtlgKJh2z8qupfLtCS3JwWh
         PrzbiG1kb26IQVkPnIlK/o9TC6CDnlCIDJ8fwmH7m6zwm9WcbFExnHsQ/SBcmBzSefDl
         Ze6g==
X-Forwarded-Encrypted: i=1; AKwUvBwBkRQurpRqK5Cs3ZOhtAsowtu7BT0lzxNozh9udZ58+JtQjiDONviALhtjk/Wj8u6KZukJX6zsFw==@lists.linux.dev
X-Gm-Message-State: AFuF++l3455WCYbkc/CnrtuFLwV/vSI1I+cSQUhgwY1b+K/beqCk2TyH
	IIx9957OVTI6E+4wvhdjVfmo1cw5UCy4V8nWkwNBGpeuKsQtjTF/dd/5
X-Gm-Gg: AYBFou2wr9jPExbzrcMvJKscR0nPZ0pZ+ImC2W72MBBQGUCc7v5QmYcXP/+yjrCy4Yt
	RhJdP7RCRahCKHSIPgOE5R8w+lfCUGbaej8pL3hECqoV/U41a5vq6C3nxId3yOwC4SyS/xx9KFX
	ooEMaWBEiQ/36qBUGIP69U9zhlVOzI2SuNeUQDRBEikvHmQ9QrbLX3zzuzC3yFJS+sclVmdbUDS
	Z95yoRV9Ru42IwRMAuZMDVQ9rh3+vQT6Ll19DvHEqtNBw6AQMFQl3lim4JjwbGD0X8fw6/wxbiq
	M4yEHXsHPY0hbbK9ek4L8A3HWJxdeHV6X7tg2oOdT7baEevh9zmuUErns+AsvmaGRskeBBpNpOB
	FbEYREjtznxaOqCE8ZTsgXiQwBjrBZfoS3LpUc0kQ3JstU/VJNDBPX6phwJa1NWJqMHb2fGvHSK
	iTk+0LM4K07GnroZkN+SzvVagr0Qqzj7bBHDX/vfFZS7VI7lr7wcs2UPs1TP/GFZi/zXJ9fL1vh
	51TroHAdWGCWzMfNMOKqNUmMewF+uawdfSB9ZsLTPBid4DC6xUlUWyF3vECPD2VX905qF2I+qBK
X-Received: by 2002:a05:600c:3b8d:b0:49f:fbad:29c1 with SMTP id 5b1f17b1804b1-4a1806611acmr8359665e9.33.1791336745490;
        Tue, 06 Oct 2026 18:32:25 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17f6538b7sm21183615e9.13.2026.10.06.18.32.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 18:32:23 -0700 (PDT)
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
Subject: [PATCH v8 08/13] nvme sgl fixup
Date: Wed,  7 Oct 2026 02:31:51 +0100
Message-ID: <e4caf53b7334af5390d4098cb5883ff551246a5c.1791336002.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/nvme/host/pci.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 651f7654d73b..79b3c1092e4d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1287,16 +1287,15 @@ static blk_status_t nvme_rq_setup_dmabuf_sgl(struct request *req,
 		struct nvme_queue *nvmeq, unsigned int entries)
 {
 	struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
-	struct bio *bio = req->bio;
-	struct nvme_dmabuf_map *map = to_nvme_dmabuf_map(bio->bi_dmabuf_map);
+	struct nvme_dmabuf_map *map = nvme_req_to_map(req);
 	size_t length = blk_rq_payload_bytes(req);
 	struct nvme_sgl_desc *sg_list = &iod->cmd.common.dptr.sgl;
+	size_t offset = req->bio->bi_iter.bi_offset;
 	bool pooled = entries > 1;
 	dma_addr_t sgl_dma = 0;
 	unsigned int mapped = 0;
 	unsigned long tmp;
 	struct scatterlist *sg;
-	size_t offset = bio->bi_iter.bi_offset;
 	size_t remaining = length;
 
 	if (!entries)
@@ -1305,8 +1304,6 @@ static blk_status_t nvme_rq_setup_dmabuf_sgl(struct request *req,
 	iod->cmd.common.flags = NVME_CMD_SGL_METABUF;
 	iod->total_len = length;
 
-	nvme_dmabuf_map_sync_for_device(nvmeq->dev, req);
-
 	/* entries == 1 fits in the inline descriptor; more needs a pool. */
 	if (pooled) {
 		if (entries <= NVME_SMALL_POOL_SIZE / sizeof(*sg_list))
-- 
2.54.0

