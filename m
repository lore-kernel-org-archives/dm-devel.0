Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7333421106;
	Mon, 26 Feb 2024 10:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943507; cv=none; b=Aa1BTiLC2PuGXsGMcczZR9hPkErDrvBiuOHy7XFCCFoBUoRiCHO/RDUNRPPePRF++b5osb4GRjanigLFVqd+0CUCQF8G2VK0nVKD6u++vMs1PtAdKvYrm3U20hGlwCRi3bu5shv5goDESOnIk01/J4uSE/OkzaIW5/EM9KPEsfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943507; c=relaxed/simple;
	bh=QyWcRrNxVgK384e9YKYldUdazeaevTm41k1lsqyTxkw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MbJ401dKgPHFeNAFqpuQ4HchFMjBIrKw0lTUjwU0aDqP1jvWacxkd2I/7VvZNSLTLntp70FPNFq5m3HKW90zIH+XL5PTOcACqrqkEfoByKy5lrJL0FbjUQqhwl9yPDORgm5WtuqSqSiGSfufXJ8vtFP+UTVK6RHVVUdv2ZO5J8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lX3fK5Mo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lX3fK5Mo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fs+hHzeY50NjZ+wR6CygHlhg6UmFfdzm3awOpeO+YYg=; b=lX3fK5Mos3bVKyiReLKAy74d77
	OlNeuMFrECES3IMZI2+mz/WP+gFirc2rsbHnVBvKXc53k9Uc5r3xM6nPGi45iRzv4f2QowTebqCHJ
	0CpwHGgQ24r0eTM1ABEn4Uiwuju2EgWpJ/jFiooU0v2lSdXUBHU7DVY9h5QHmvB7FaSBKsp3vn5Oa
	xIyTsCOJ3kl3RPV8SHnW/3BYxdzY48BYwwLD2Jy2PLSjZtM2Nn77/Claxy8XR12rItU8k7N2wX9uV
	7BfliIcmFsyY/779OU4eRdn7hb2GVl1C1NMgCxaXhBVlH6xF1f3S7UvlJIdrptmCDWQyWm0O4A7wu
	ro7SUxLQ==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYGr-000000005CO-0Tit;
	Mon, 26 Feb 2024 10:31:41 +0000
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
Subject: [PATCH 16/16] drbd: atomically update queue limits in drbd_reconsider_queue_parameters
Date: Mon, 26 Feb 2024 11:30:04 +0100
Message-Id: <20240226103004.281412-17-hch@lst.de>
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

Switch drbd_reconsider_queue_parameters to set up the queue parameters
in an on-stack queue_limits structure and apply the atomically.  Remove
various helpers that have become so trivial that they can be folded into
drbd_reconsider_queue_parameters.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_nl.c | 119 ++++++++++++++---------------------
 1 file changed, 46 insertions(+), 73 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 94ed2b3ea6361d..fbd92803dc1da4 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1216,11 +1216,6 @@ static unsigned int drbd_max_peer_bio_size(struct drbd_device *device)
 	return DRBD_MAX_BIO_SIZE;
 }
 
-static void blk_queue_discard_granularity(struct request_queue *q, unsigned int granularity)
-{
-	q->limits.discard_granularity = granularity;
-}
-
 static unsigned int drbd_max_discard_sectors(struct drbd_connection *connection)
 {
 	/* when we introduced REQ_WRITE_SAME support, we also bumped
@@ -1247,62 +1242,6 @@ static bool drbd_discard_supported(struct drbd_connection *connection,
 	return true;
 }
 
-static void decide_on_discard_support(struct drbd_device *device,
-		struct drbd_backing_dev *bdev)
-{
-	struct drbd_connection *connection =
-		first_peer_device(device)->connection;
-	struct request_queue *q = device->rq_queue;
-	unsigned int max_discard_sectors;
-
-	if (!drbd_discard_supported(connection, bdev))
-		goto not_supported;
-
-	/*
-	 * We don't care for the granularity, really.
-	 *
-	 * Stacking limits below should fix it for the local device.  Whether or
-	 * not it is a suitable granularity on the remote device is not our
-	 * problem, really. If you care, you need to use devices with similar
-	 * topology on all peers.
-	 */
-	blk_queue_discard_granularity(q, 512);
-	max_discard_sectors = drbd_max_discard_sectors(connection);
-	blk_queue_max_discard_sectors(q, max_discard_sectors);
-	return;
-
-not_supported:
-	blk_queue_discard_granularity(q, 0);
-	blk_queue_max_discard_sectors(q, 0);
-}
-
-static void fixup_write_zeroes(struct drbd_device *device, struct request_queue *q)
-{
-	/* Fixup max_write_zeroes_sectors after blk_stack_limits():
-	 * if we can handle "zeroes" efficiently on the protocol,
-	 * we want to do that, even if our backend does not announce
-	 * max_write_zeroes_sectors itself. */
-	struct drbd_connection *connection = first_peer_device(device)->connection;
-	/* If the peer announces WZEROES support, use it.  Otherwise, rather
-	 * send explicit zeroes than rely on some discard-zeroes-data magic. */
-	if (connection->agreed_features & DRBD_FF_WZEROES)
-		q->limits.max_write_zeroes_sectors = DRBD_MAX_BBIO_SECTORS;
-	else
-		q->limits.max_write_zeroes_sectors = 0;
-}
-
-static void fixup_discard_support(struct drbd_device *device, struct request_queue *q)
-{
-	unsigned int max_discard = device->rq_queue->limits.max_discard_sectors;
-	unsigned int discard_granularity =
-		device->rq_queue->limits.discard_granularity >> SECTOR_SHIFT;
-
-	if (discard_granularity > max_discard) {
-		blk_queue_discard_granularity(q, 0);
-		blk_queue_max_discard_sectors(q, 0);
-	}
-}
-
 /* This is the workaround for "bio would need to, but cannot, be split" */
 static unsigned int drbd_backing_dev_max_segments(struct drbd_device *device)
 {
@@ -1320,8 +1259,11 @@ static unsigned int drbd_backing_dev_max_segments(struct drbd_device *device)
 void drbd_reconsider_queue_parameters(struct drbd_device *device,
 		struct drbd_backing_dev *bdev, struct o_qlim *o)
 {
+	struct drbd_connection *connection =
+		first_peer_device(device)->connection;
 	struct request_queue * const q = device->rq_queue;
 	unsigned int now = queue_max_hw_sectors(q) << 9;
+	struct queue_limits lim;
 	struct request_queue *b = NULL;
 	unsigned int new;
 
@@ -1348,24 +1290,55 @@ void drbd_reconsider_queue_parameters(struct drbd_device *device,
 		drbd_info(device, "max BIO size = %u\n", new);
 	}
 
+	lim = queue_limits_start_update(q);
 	if (bdev) {
-		blk_set_stacking_limits(&q->limits);
-		blk_queue_max_segments(q,
-			drbd_backing_dev_max_segments(device));
+		blk_set_stacking_limits(&lim);
+		lim.max_segments = drbd_backing_dev_max_segments(device);
 	} else {
-		blk_queue_max_segments(q, BLK_MAX_SEGMENTS);
+		lim.max_segments = BLK_MAX_SEGMENTS;
 	}
 
-	blk_queue_max_hw_sectors(q, new >> SECTOR_SHIFT);
-	blk_queue_segment_boundary(q, PAGE_SIZE - 1);
-	decide_on_discard_support(device, bdev);
+	lim.max_hw_sectors = new >> SECTOR_SHIFT;
+	lim.seg_boundary_mask = PAGE_SIZE - 1;
 
-	if (bdev) {
-		blk_stack_limits(&q->limits, &b->limits, 0);
-		disk_update_readahead(device->vdisk);
+	/*
+	 * We don't care for the granularity, really.
+	 *
+	 * Stacking limits below should fix it for the local device.  Whether or
+	 * not it is a suitable granularity on the remote device is not our
+	 * problem, really. If you care, you need to use devices with similar
+	 * topology on all peers.
+	 */
+	if (drbd_discard_supported(connection, bdev)) {
+		lim.discard_granularity = 512;
+		lim.max_hw_discard_sectors =
+			drbd_max_discard_sectors(connection);
+	} else {
+		lim.discard_granularity = 0;
+		lim.max_hw_discard_sectors = 0;
 	}
-	fixup_write_zeroes(device, q);
-	fixup_discard_support(device, q);
+
+	if (bdev)
+		blk_stack_limits(&lim, &b->limits, 0);
+
+	/*
+	 * If we can handle "zeroes" efficiently on the protocol, we want to do
+	 * that, even if our backend does not announce max_write_zeroes_sectors
+	 * itself.
+	 */
+	if (connection->agreed_features & DRBD_FF_WZEROES)
+		lim.max_write_zeroes_sectors = DRBD_MAX_BBIO_SECTORS;
+	else
+		lim.max_write_zeroes_sectors = 0;
+
+	if ((lim.discard_granularity >> SECTOR_SHIFT) >
+	    lim.max_hw_discard_sectors) {
+		lim.discard_granularity = 0;
+		lim.max_hw_discard_sectors = 0;
+	}
+
+	if (queue_limits_commit_update(q, &lim))
+		drbd_err(device, "setting new queue limits failed\n");
 }
 
 /* Starts the worker thread */
-- 
2.39.2

