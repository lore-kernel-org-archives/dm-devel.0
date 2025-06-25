Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C432A27FB07;
	Wed, 25 Jun 2025 09:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750844134; cv=none; b=VsI8iblpq9LLrDw39lhNf9MrpBnlS650wwg1Qozh4Ut3HEfavnNFXlxCQFHwqSM+0kqre/asQdYcXlm241OUcSPiUbER5iZclExRCmJp6NuA/FbZXUwF30K7UGIIywn5AD9W5UQn1w8UQIF1uIUnhV7OiolWNFcuLhi5Il9I02Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750844134; c=relaxed/simple;
	bh=pgkcVtG1l+xOv9+JDpgmG4nNlMdLwNJWYz3go6cAgrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSgNRaxJgVQVA8P3LwHgdeNpo5PzjxggIiRwYuMf1DaVddTaRDMUnGiUXVXJVEXqvfC0HCDdYyh4xpcMIaonUnua3Avnt7n7AVXA7mfFtib3TaHnEQIJsBXedgOuIE2o0UY5cEz7gqRbcOWUUrUjUzSualR8Rpb7ab7IEJsq7uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g4aVtd/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g4aVtd/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB38C4CEF2;
	Wed, 25 Jun 2025 09:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750844134;
	bh=pgkcVtG1l+xOv9+JDpgmG4nNlMdLwNJWYz3go6cAgrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4aVtd/ZvJ0AqnLzAiRpoqAXj92x4pDfb8NLa3H5aM9bL9mwDzHM9aFIaDkI8mK63
	 PzT+rh1xsGvn059ChkazLkm1thvelzzIV5Kqi0gWL4BDawfeghVTyHFCuMETpPxOXc
	 FAtVsmvrU0dYvHShmnRNjtGC74J0uArRFxzRubl9LkvJ5eDPKlIQP3J5oOrCcfY2zW
	 L5APXqB663ZgGR992hVYp4tq2ve/1LNlMnDovaI9K2Wpvag4BXBGj2oObQ45I4b7xv
	 0tBO1j/eUBdWZs2f2nHC9q3L39SS9LiIvn80/lyEAc1q7gYUPUah4jj876fcDedfy3
	 /nhoLx90+3YeA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 2/5] block: Introduce bio_needs_zone_write_plugging()
Date: Wed, 25 Jun 2025 18:33:24 +0900
Message-ID: <20250625093327.548866-3-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250625093327.548866-1-dlemoal@kernel.org>
References: <20250625093327.548866-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for fixing device mapper zone write handling, introduce
the inline helper function bio_needs_zone_write_plugging() to test if a
BIO requires handling through zone write plugging using the function
blk_zone_plug_bio(). This function returns true for any write
(op_is_write(bio) == true) operation directed at a zoned block device
using zone write plugging, that is, a block device with a disk that has
a zone write plug hash table.

This helper allows simplifying the check on entry to blk_zone_plug_bio()
and used in to protect calls to it for blk-mq devices and DM devices.

Fixes: f211268ed1f9 ("dm: Use the block layer zone append emulation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-mq.c         |  6 +++--
 block/blk-zoned.c      | 20 +--------------
 drivers/md/dm.c        |  4 ++-
 include/linux/blkdev.h | 55 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 63 insertions(+), 22 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4806b867e37d..0c61492724d2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3169,8 +3169,10 @@ void blk_mq_submit_bio(struct bio *bio)
 	if (blk_mq_attempt_bio_merge(q, bio, nr_segs))
 		goto queue_exit;
 
-	if (blk_queue_is_zoned(q) && blk_zone_plug_bio(bio, nr_segs))
-		goto queue_exit;
+	if (bio_needs_zone_write_plugging(bio)) {
+		if (blk_zone_plug_bio(bio, nr_segs))
+			goto queue_exit;
+	}
 
 new_request:
 	if (rq) {
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 55e64ca869d7..16b08bf8f82a 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1145,25 +1145,7 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
 {
 	struct block_device *bdev = bio->bi_bdev;
 
-	if (!bdev->bd_disk->zone_wplugs_hash)
-		return false;
-
-	/*
-	 * If the BIO already has the plugging flag set, then it was already
-	 * handled through this path and this is a submission from the zone
-	 * plug bio submit work.
-	 */
-	if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
-		return false;
-
-	/*
-	 * We do not need to do anything special for empty flush BIOs, e.g
-	 * BIOs such as issued by blkdev_issue_flush(). The is because it is
-	 * the responsibility of the user to first wait for the completion of
-	 * write operations for flush to have any effect on the persistence of
-	 * the written data.
-	 */
-	if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
+	if (WARN_ON_ONCE(!bdev->bd_disk->zone_wplugs_hash))
 		return false;
 
 	/*
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 55579adbeb3f..e477765cdd27 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1781,7 +1781,9 @@ static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
 }
 static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio *bio)
 {
-	return dm_emulate_zone_append(md) && blk_zone_plug_bio(bio, 0);
+	if (!bio_needs_zone_write_plugging(bio))
+		return false;
+	return blk_zone_plug_bio(bio, 0);
 }
 
 static blk_status_t __send_zone_reset_all_emulated(struct clone_info *ci,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c2b3ddea8b6d..a7d09ef4f448 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -848,6 +848,55 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
 {
 	return disk->nr_zones;
 }
+
+/**
+ * bio_needs_zone_write_plugging - Check if a BIO needs to be handled with zone
+ *				   write plugging
+ * @bio: The BIO being submitted
+ *
+ * Return true whenever @bio execution needs to be handled through zone
+ * write plugging (using blk_zone_plug_bio()). Return false otherwise.
+ */
+static inline bool bio_needs_zone_write_plugging(struct bio *bio)
+{
+	enum req_op op = bio_op(bio);
+
+	/*
+	 * Only zoned block devices have a zone write plug hash table. But not
+	 * all of them have one (e.g. DM devices may not need one).
+	 */
+	if (!bio->bi_bdev->bd_disk->zone_wplugs_hash)
+		return false;
+
+	/* Only write operations need zone write plugging. */
+	if (!op_is_write(op))
+		return false;
+
+	/* Ignore empty flush */
+	if (op_is_flush(bio->bi_opf) && !bio_sectors(bio))
+		return false;
+
+	/* Ignore BIOs that already have been handled by zone write plugging. */
+	if (bio_flagged(bio, BIO_ZONE_WRITE_PLUGGING))
+		return false;
+
+	/*
+	 * All zone write operations must be handled through zone write plugging
+	 * using blk_zone_plug_bio().
+	 */
+	switch (op) {
+	case REQ_OP_ZONE_APPEND:
+	case REQ_OP_WRITE:
+	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_ZONE_FINISH:
+	case REQ_OP_ZONE_RESET:
+	case REQ_OP_ZONE_RESET_ALL:
+		return true;
+	default:
+		return false;
+	}
+}
+
 bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs);
 
 /**
@@ -877,6 +926,12 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
 {
 	return 0;
 }
+
+static inline bool bio_needs_zone_write_plugging(struct bio *bio)
+{
+	return false;
+}
+
 static inline bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
 {
 	return false;
-- 
2.49.0

