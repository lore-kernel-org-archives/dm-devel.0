Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62282F9D98;
	Tue, 18 Nov 2025 07:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763449419; cv=none; b=r+QkJwn/ise+zGKYo7xxCoso0YGWAKC51A58xIm6qTxP8/YunFdcGMiG4vVTi7EwIaC1oQrt3jC1S1pXdohhYE7WI0wMm2oXpaXf+1KXX40h3YzaQZLDA+/3D99YeUOVcwqkgTL9I8ZfE3KNzorPCPr+L/o/gNE4vYjuEbTQHe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763449419; c=relaxed/simple;
	bh=Jjy+0dBTiCdac7lFJ7Sq8+cVuRs3oGJ2t+Y4zzO+dmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WG/O3yz68rPum/da/cZKAQkZC4b8JaOGp8P5egC4baDsmDLdOPd0QhQC7D8OLeLJDvRTrcFnDQdPzPmpBK5gtRinGeaYGVepoccyhrWCPIJ/D/hffaphpmCKBe2PeNknHY6cyysQd1a6CYuPtq8ohoL9SWTUfLK1FsZt1nqH/mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OH6lciAA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OH6lciAA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=R83qSjkGH1HcSu10z+np7S93zfELtxFiAfcuCBF3IVU=; b=OH6lciAAmBAa1MDjb/8nzkFTCg
	lo3G4nCyT1XYgPdS73csyAzzZHR70nj0JApp9bR9Vs3BAC8iBAe1p7mGHN/r4IAYUYFyv5Pqxo9ro
	O7zMhqbD7fbOJfCkgcKTA3QLI/8ykiWfh/pDZDCLxprT1UhPpCw9xvVtQQda1ZhSakdRXQra+OL5L
	7J9OlhumRxCehC2DNs0ehbWbsJkmLPylKSyi4PY1Ti0SH6EAC7miW21tHuMpgEV/zzKxlTQigd7NK
	+KBlwEuX3lFI5iuSe9w7PmS4X8lmMGRYUyYvSjwIa5nOPEwKK+ODJ3dpSN5Vf7xE3rRHbKhS7ZcIG
	kE0Gwy4w==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLFkU-0000000HWzT-2NzO;
	Tue, 18 Nov 2025 07:03:37 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: [PATCH 2/3] block: add a REQ_ZWPLUG_UNORDERED flag
Date: Tue, 18 Nov 2025 08:03:09 +0100
Message-ID: <20251118070321.2367097-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251118070321.2367097-1-hch@lst.de>
References: <20251118070321.2367097-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This instructs the zone write plugging code to queue up any bio not
at the write pointer, and includes an implicit guarantee that the caller
will fill any sector gaps.  I.e., this can be used by file systems and
stacking block drivers, but not for untrusted user block device writes.

Because all writes through the write plug cancel all outstanding writes
for the plug there is no risk that queue up writes for higher sectors are
stuck in the zone write plug even on error.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq-debugfs.c    |  1 +
 block/blk-zoned.c         | 61 +++++++++++++++++++++++++++++++--------
 include/linux/blk_types.h |  2 ++
 3 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 4896525b1c05..3b0e3ebf35b2 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -222,6 +222,7 @@ static const char *const cmd_flag_name[] = {
 	CMD_FLAG_NAME(FS_PRIVATE),
 	CMD_FLAG_NAME(ATOMIC),
 	CMD_FLAG_NAME(NOUNMAP),
+	CMD_FLAG_NAME(ZWPLUG_UNORDERED),
 };
 #undef CMD_FLAG_NAME
 
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index dcc295721c2c..5bed52d28ed8 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -607,8 +607,12 @@ static inline bool disk_should_remove_zone_wplug(struct gendisk *disk,
 	if (zwplug->flags & BLK_ZONE_WPLUG_UNHASHED)
 		return false;
 
-	/* If the zone write plug is still plugged, it cannot be removed. */
-	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
+	/*
+	 * The zone write plug can't be removed if it is still plugged or there
+	 * are bios queued up behind the write pointer.
+	 */
+	if ((zwplug->flags & BLK_ZONE_WPLUG_PLUGGED) ||
+	    !bio_list_empty(&zwplug->bio_list))
 		return false;
 
 	/*
@@ -1188,6 +1192,15 @@ void blk_zone_mgmt_bio_endio(struct bio *bio)
 	}
 }
 
+static bool blk_zwplug_has_bio_at_write_pointer(struct blk_zone_wplug *zwplug)
+{
+	struct bio *bio = bio_list_peek(&zwplug->bio_list);
+
+	return bio &&
+		(bio_op(bio) == REQ_OP_ZONE_APPEND ||
+		 bio_offset_from_zone_start(bio) == zwplug->wp_offset);
+}
+
 static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
 					      struct blk_zone_wplug *zwplug)
 {
@@ -1231,10 +1244,15 @@ static inline void disk_zone_wplug_add_bio(struct gendisk *disk,
 	/*
 	 * We always receive BIOs after they are split and ready to be issued.
 	 * The block layer passes the parts of a split BIO in order, and the
-	 * user must also issue write sequentially. So simply add the new BIO
-	 * at the tail of the list to preserve the sequential write order.
+	 * user must also issue write sequentially unless REQ_ZWPLUG_UNORDERED
+	 * is set. So simply add the new BIO at the tail of the list to preserve
+	 * the sequential write order.
 	 */
-	bio_list_add(&zwplug->bio_list, bio);
+	if (bio->bi_opf & REQ_ZWPLUG_UNORDERED)
+		bio_list_add_sorted(&zwplug->bio_list, bio);
+	else
+		bio_list_add(&zwplug->bio_list, bio);
+
 	trace_disk_zone_wplug_add_bio(zwplug->disk->queue, zwplug->zone_no,
 				      bio->bi_iter.bi_sector, bio_sectors(bio));
 }
@@ -1403,7 +1421,8 @@ static bool blk_zone_wplug_prepare_bio(struct blk_zone_wplug *zwplug,
 static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
 {
 	struct gendisk *disk = bio->bi_bdev->bd_disk;
-	sector_t sector = bio->bi_iter.bi_sector;
+	sector_t zone_offset = bio_offset_from_zone_start(bio);
+	sector_t zone_start = bio->bi_iter.bi_sector - zone_offset;
 	struct blk_zone_wplug *zwplug;
 	gfp_t gfp_mask = GFP_NOIO;
 	unsigned long flags;
@@ -1422,7 +1441,7 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
 	}
 
 	/* Conventional zones do not need write plugging. */
-	if (!bdev_zone_is_seq(bio->bi_bdev, sector)) {
+	if (!bdev_zone_is_seq(bio->bi_bdev, zone_start)) {
 		/* Zone append to conventional zones is not allowed. */
 		if (bio_op(bio) == REQ_OP_ZONE_APPEND) {
 			bio_io_error(bio);
@@ -1434,7 +1453,8 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
 	if (bio->bi_opf & REQ_NOWAIT)
 		gfp_mask = GFP_NOWAIT;
 
-	zwplug = disk_get_and_lock_zone_wplug(disk, sector, gfp_mask, &flags);
+	zwplug = disk_get_and_lock_zone_wplug(disk, zone_start, gfp_mask,
+			&flags);
 	if (!zwplug) {
 		if (bio->bi_opf & REQ_NOWAIT)
 			bio_wouldblock_error(bio);
@@ -1459,6 +1479,15 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
 	if (zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)
 		goto queue_bio;
 
+	/*
+	 * For REQ_ZWPLUG_UNORDERED, the caller guarantees it will submit all
+	 * bios that fill unordered gaps, so just queue up the bio if it is
+	 * past the write pointer.
+	 */
+	if ((bio->bi_opf & REQ_ZWPLUG_UNORDERED) &&
+	    zone_offset > zwplug->wp_offset)
+		goto queue_bio;
+
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
 		spin_unlock_irqrestore(&zwplug->lock, flags);
 		bio_io_error(bio);
@@ -1475,7 +1504,15 @@ static bool blk_zone_wplug_handle_write(struct bio *bio, unsigned int nr_segs)
 queue_bio:
 	disk_zone_wplug_add_bio(disk, zwplug, bio, nr_segs);
 
-	if (!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED)) {
+	/*
+	 * If this bio is at the write pointer, schedule the work now.  Normally
+	 * bios at the write pointer are immediately submitted unless there is
+	 * another write to the zone in-flight, but for NOWAIT I/O we can end up
+	 * here even for bios at the write pointer, and for REQ_ZWPLUG_UNORDERED
+	 * we might have to queue up bios even when no I/O is in-flight.
+	 */
+	if (!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED) &&
+	    blk_zwplug_has_bio_at_write_pointer(zwplug)) {
 		zwplug->flags |= BLK_ZONE_WPLUG_PLUGGED;
 		disk_zone_wplug_schedule_bio_work(disk, zwplug);
 	}
@@ -1619,7 +1656,7 @@ static void disk_zone_wplug_unplug_bio(struct gendisk *disk,
 	spin_lock_irqsave(&zwplug->lock, flags);
 
 	/* Schedule submission of the next plugged BIO if we have one. */
-	if (!bio_list_empty(&zwplug->bio_list)) {
+	if (blk_zwplug_has_bio_at_write_pointer(zwplug)) {
 		disk_zone_wplug_schedule_bio_work(disk, zwplug);
 		spin_unlock_irqrestore(&zwplug->lock, flags);
 		return;
@@ -1738,13 +1775,13 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
 	 */
 again:
 	spin_lock_irqsave(&zwplug->lock, flags);
-	bio = bio_list_pop(&zwplug->bio_list);
-	if (!bio) {
+	if (!blk_zwplug_has_bio_at_write_pointer(zwplug)) {
 		zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
 		spin_unlock_irqrestore(&zwplug->lock, flags);
 		goto put_zwplug;
 	}
 
+	bio = bio_list_pop(&zwplug->bio_list);
 	trace_blk_zone_wplug_bio(zwplug->disk->queue, zwplug->zone_no,
 				 bio->bi_iter.bi_sector, bio_sectors(bio));
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d884cc1256ec..e41ab9404a74 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -390,6 +390,7 @@ enum req_flag_bits {
 	__REQ_POLLED,		/* caller polls for completion using bio_poll */
 	__REQ_ALLOC_CACHE,	/* allocate IO from cache if available */
 	__REQ_SWAP,		/* swap I/O */
+	__REQ_ZWPLUG_UNORDERED,	/* might not be at write pointer */
 	__REQ_DRV,		/* for driver use */
 	__REQ_FS_PRIVATE,	/* for file system (submitter) use */
 	__REQ_ATOMIC,		/* for atomic write operations */
@@ -422,6 +423,7 @@ enum req_flag_bits {
 #define REQ_POLLED	(__force blk_opf_t)(1ULL << __REQ_POLLED)
 #define REQ_ALLOC_CACHE	(__force blk_opf_t)(1ULL << __REQ_ALLOC_CACHE)
 #define REQ_SWAP	(__force blk_opf_t)(1ULL << __REQ_SWAP)
+#define REQ_ZWPLUG_UNORDERED (__force blk_opf_t)(1ULL << __REQ_ZWPLUG_UNORDERED)
 #define REQ_DRV		(__force blk_opf_t)(1ULL << __REQ_DRV)
 #define REQ_FS_PRIVATE	(__force blk_opf_t)(1ULL << __REQ_FS_PRIVATE)
 #define REQ_ATOMIC	(__force blk_opf_t)(1ULL << __REQ_ATOMIC)
-- 
2.47.3

