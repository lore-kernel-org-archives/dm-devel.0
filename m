Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D20198E75;
	Sun,  8 Dec 2024 22:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733698709; cv=none; b=hN78hdru0J4A54heWP0jjQ3IXpwbgrgJdkYQMCUwxASe7qnSUU7+b9X1j++TTgnt5bioWpIfh5cflmIWOar19DgU2aSpqZ6slKaNJd7w8Gj5eFVgrMXl+r/OC3njGMeo1kEldeVfQpbE50Ir1q8EIaNSOxpqY5XjwsznmNjYEek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733698709; c=relaxed/simple;
	bh=naaHmVa1xXF1w9vzqh7Bb52GrZQLJ2MlhUpqffZX1As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqp1Uxm4COfjrOSxqswDgLQGsCFB0IupVk/MtgNfsJ0dHLjFmzUn6vfoZqy4JQDamLhc1jiOiVqFV4LeYf3sg2KQsqdF8+RWfGhTuaWs459gm24wIs0pP1UlxGjPiLBfM2+busZLqGQcrFz3sGFAgWo9fJBTbtStjgtIPHlxnq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=unpkp3qV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="unpkp3qV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA4EC4CEE0;
	Sun,  8 Dec 2024 22:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733698708;
	bh=naaHmVa1xXF1w9vzqh7Bb52GrZQLJ2MlhUpqffZX1As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=unpkp3qVh9ZE00vnt8vFgDiZyIHtgGkOSdZZf5oR4BkQqLXIAEMB9IyD2d3ul22fe
	 MJJ83no1vXIo7pnYzf+zjXA3ZkOUTIxNhov7ieATJwT5a6KgPh6PDIGqnrGLND8iEH
	 EgLgLRa9xKgRAcyEwtgDtpJQNMf1T0oV/bXezqHp0ZNosj0H2jAejWDk33lRsXMECs
	 c4iNcqw6pDe75tIC5CHB6QaJkwvaNhLBAFN7DzMXf9E+oXpMig9GTYoG2cuUarz139
	 So5G2PwN/m8nPCbjTOZmyArMCgvluFvu2EkK1rdlPjsjpLoq1Cf2ruugfWBPMiMS/z
	 tr0EhH467D2Hw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	dm-devel@lists.linux.dev
Cc: Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 4/4] dm: Fix dm-zoned-reclaim zone write pointer alignment
Date: Mon,  9 Dec 2024 07:57:58 +0900
Message-ID: <20241208225758.219228-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241208225758.219228-1-dlemoal@kernel.org>
References: <20241208225758.219228-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The zone reclaim processing of the dm-zoned device mapper uses
blkdev_issue_zeroout() to align the write pointer of a zone being used
for reclaiming zones, to write valid data blocks at the correct zone
start relative offset. However, the first call to blkdev_issue_zeroout()
will try to use hardware offload through a REQ_OP_WRITE_ZEROES
operation, if the device reports a non-zero max zero sectors limit. If
this operation fails, blkdev_issue_zeroout() falls back to using a
regular write operation with zeror-pages.

With the removal of the zone write plug automatic write pointer recovery
after a write error, the first attempt using a REQ_OP_WRITE_ZEROES
leaves the target zone write pointer out of sync with the drive current
value as the zone writ eplugging code advanced the zone write plug write
pointer offset on submission of the REQ_OP_WRITE_ZEROES operation. The
target zone is marked with BLK_ZONE_WPLUG_NEED_WP_UPDATE, which causes
the fallback regular write operation to also fail.

blkdev_issue_zeroout() callers such as dmz_reclaim_align_wp() can
recover from such situation by executing a report zones and retrying the
call to blkdev_issue_zeroout() to handle this recoverable error
situation. Given that such pattern will be common to all users of
blkdev_issue_zeroout(), introduce the function
blkdev_issue_zone_zeroout() to automatically handle such recovery. This
function calls blkdev_issue_zeroout() with the BLKDEV_ZERO_NOFALLBACK
flag to intercept failures on the first execution which attempt to use
the device hardware offload with a REQ_OP_WRITE_ZEROES. If this attempt
fails, blkdev_report_zones() is executed to recover the target zone to a
good state and execute again blkdev_issue_zeroout() without the
BLKDEV_ZERO_NOFALLBACK flag.

Replacing the call to blkdev_issue_zeroout() with a call to
blkdev_issue_zone_zeroout() in dmz_reclaim_align_wp() thus solves
irrecoverable write errors triggered by the removal of the zone write
plugging automatic recovery (commit "block: Prevent potential deadlocks
in zone write plug error recovery").

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c             | 55 +++++++++++++++++++++++++++++++++++
 drivers/md/dm-zoned-reclaim.c |  4 +--
 include/linux/blkdev.h        |  3 ++
 3 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index d709f12d5935..c5400792de13 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -129,6 +129,9 @@ static int disk_report_zones_cb(struct blk_zone *zone, unsigned int idx,
 	if (disk->zone_wplugs_hash)
 		disk_zone_wplug_sync_wp_offset(disk, zone);
 
+	if (!args->user_cb)
+		return 0;
+
 	return args->user_cb(zone, idx, args->user_data);
 }
 
@@ -663,6 +666,16 @@ static void disk_zone_wplug_sync_wp_offset(struct gendisk *disk,
 	disk_put_zone_wplug(zwplug);
 }
 
+static int disk_zone_sync_wp_offset(struct gendisk *disk, sector_t sector)
+{
+	struct disk_report_zones_cb_args args = {
+		.disk = disk,
+	};
+
+	return disk->fops->report_zones(disk, sector, 1,
+					disk_report_zones_cb, &args);
+}
+
 static bool blk_zone_wplug_handle_reset_or_finish(struct bio *bio,
 						  unsigned int wp_offset)
 {
@@ -1720,6 +1733,48 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 }
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
 
+/**
+ * blkdev_issue_zone_zeroout - zero-fill a block range in a zone
+ * @bdev:	blockdev to write
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to write
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *  Zero-fill a block range in a zone (@sector must be equal to the zone write
+ *  pointer), handling potential errors due to the (initially unknown) lack of
+ *  hardware offload (See blkdev_issue_zeroout()).
+ */
+int blkdev_issue_zone_zeroout(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, gfp_t gfp_mask)
+{
+	int ret;
+
+	if (WARN_ON_ONCE(!bdev_is_zoned(bdev)))
+		return -EIO;
+
+	ret = blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask,
+				   BLKDEV_ZERO_NOFALLBACK);
+	if (ret != -EOPNOTSUPP)
+		return ret;
+
+	/*
+	 * The failed call to blkdev_issue_zeroout() advanced the zone write
+	 * pointer. Undo this using a report zone to update the zone write
+	 * pointer to the correct current value.
+	 */
+	ret = disk_zone_sync_wp_offset(bdev->bd_disk, sector);
+	if (ret != 1)
+		return ret < 0 ? ret : -EIO;
+
+	/*
+	 * Retry without BLKDEV_ZERO_NOFALLBACK to force the fallback to a
+	 * regular write with zero-pages.
+	 */
+	return blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask, 0);
+}
+EXPORT_SYMBOL(blkdev_issue_zone_zeroout);
+
 #ifdef CONFIG_BLK_DEBUG_FS
 
 int queue_zone_wplugs_show(void *data, struct seq_file *m)
diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
index d58db9a27e6c..b085a929e64e 100644
--- a/drivers/md/dm-zoned-reclaim.c
+++ b/drivers/md/dm-zoned-reclaim.c
@@ -76,9 +76,9 @@ static int dmz_reclaim_align_wp(struct dmz_reclaim *zrc, struct dm_zone *zone,
 	 * pointer and the requested position.
 	 */
 	nr_blocks = block - wp_block;
-	ret = blkdev_issue_zeroout(dev->bdev,
+	ret = blkdev_issue_zone_zeroout(dev->bdev,
 				   dmz_start_sect(zmd, zone) + dmz_blk2sect(wp_block),
-				   dmz_blk2sect(nr_blocks), GFP_NOIO, 0);
+				   dmz_blk2sect(nr_blocks), GFP_NOIO);
 	if (ret) {
 		dmz_dev_err(dev,
 			    "Align zone %u wp %llu to %llu (wp+%u) blocks failed %d",
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 15e7dfc013b7..696fdafcfe91 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1419,6 +1419,9 @@ static inline bool bdev_zone_is_seq(struct block_device *bdev, sector_t sector)
 	return is_seq;
 }
 
+int blkdev_issue_zone_zeroout(struct block_device *bdev, sector_t sector,
+			      sector_t nr_sects, gfp_t gfp_mask);
+
 static inline unsigned int queue_dma_alignment(const struct request_queue *q)
 {
 	return q->limits.dma_alignment;
-- 
2.47.1

