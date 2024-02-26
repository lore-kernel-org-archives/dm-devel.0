Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A78E1DFD1;
	Mon, 26 Feb 2024 10:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943471; cv=none; b=NugomMVpUS4r/WKS+4wgj8Y8VWwilnaAbb+DJnKL16fjl1YE9NKE1Ch1XbWxz1/waTdLEDezy3mKq7tvKJ6Rsf3Kv1+aWJ+rgg4lHHUVIVVyG/y4dS7PZHc8t1Niem7+2pmspUV4Pq2j0mgqDbjtoRq2nh6q6aqLUMsNK9cKp7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943471; c=relaxed/simple;
	bh=XpLAWU/T29R3Tx7M5y0bBtN8HvoYCHtVCtBpYdyGND0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TQcVRdnct60vZ+Ip/qn+aTPXZxZzjJxWJVloxNl0icq9ohM6501gkAzUjpJx48PqKsZJtfkguDHbnfiKkW8M3Ep0C4RFgNSAjemqbDHlwU3VRFUcVO0SMSnFa+/irEhxOagOGxRUoge7fHWU5bY4XCO1qIIjTNIw6qXhn8gUXIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NsXMOweT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NsXMOweT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=f3zgMPRzyEaVBtSoLHLNya392ZrbcPY31mEsET5i7T0=; b=NsXMOweTN1zS7Pd9VMsqipxzkm
	WQCkFR0uW4gfG05h6igL8Aez15SL5DsmtoT+mzzhtgHs3ispfG8En18092R8f8pvAP5SD4hjLvoj6
	QkzSQGIBZ/nZM5bkfT9gShIJKmq/x1s8jd5LlItju1ZVbxwbtEKSwCPs4hpYViKCL6pQ7nU5ES49X
	Tv2AHWT5VVTuLW7vt1+MlqU1WxHXhOjjNnuCdvIX1m2vqzF7Am/fnwJHNDeXcGqMvg2c0mKmfNERZ
	iGEioZQ4ZGh1/XSajE4ymFsB/52MHXtnWAfnz+0k4x4SfMszX6LLhGgFwbzXL2dIeUogPQZREvp9E
	lkiCK0zg==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYGJ-000000004ud-2AFt;
	Mon, 26 Feb 2024 10:31:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>
Cc: drbd-dev@lists.linbit.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 10/16] drbd: pass the max_hw_sectors limit to blk_alloc_disk
Date: Mon, 26 Feb 2024 11:29:58 +0100
Message-Id: <20240226103004.281412-11-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226103004.281412-1-hch@lst.de>
References: <20240226103004.281412-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Pass a queue_limits structure with the max_hw_sectors limit to
blk_alloc_disk instead of updating the limit on the allocated gendisk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index cea1e537fd56c1..113b441d4d3670 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2690,6 +2690,14 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	int id;
 	int vnr = adm_ctx->volume;
 	enum drbd_ret_code err = ERR_NOMEM;
+	struct queue_limits lim = {
+		/*
+		 * Setting the max_hw_sectors to an odd value of 8kibyte here.
+		 * This triggers a max_bio_size message upon first attach or
+		 * connect.
+		 */
+		.max_hw_sectors		= DRBD_MAX_BIO_SIZE_SAFE >> 8,
+	};
 
 	device = minor_to_device(minor);
 	if (device)
@@ -2708,7 +2716,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	drbd_init_set_defaults(device);
 
-	disk = blk_alloc_disk(NULL, NUMA_NO_NODE);
+	disk = blk_alloc_disk(&lim, NUMA_NO_NODE);
 	if (IS_ERR(disk)) {
 		err = PTR_ERR(disk);
 		goto out_no_disk;
@@ -2729,9 +2737,6 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	blk_queue_flag_set(QUEUE_FLAG_STABLE_WRITES, disk->queue);
 	blk_queue_write_cache(disk->queue, true, true);
-	/* Setting the max_hw_sectors to an odd value of 8kibyte here
-	   This triggers a max_bio_size message upon first attach or connect */
-	blk_queue_max_hw_sectors(disk->queue, DRBD_MAX_BIO_SIZE_SAFE >> 8);
 
 	device->md_io.page = alloc_page(GFP_KERNEL);
 	if (!device->md_io.page)
-- 
2.39.2

