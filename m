Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C806F6FC6;
	Wed,  1 May 2024 00:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522182; cv=none; b=DcBULIsy6K9xkWNsJIZx68zm9g7FWbMm6qNpg4cdYslY0RnoJtT4uw/OkZNbyEDNSSyERjrnt9MLcUxm6FFkzaTnln2sr+MqfNZ5e0PLe4XRRaHjafZVgS0wQsf3BBVN/t0c2XXPaOeCZt+tREMr2/qozipwUgF4E+umCzljgv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522182; c=relaxed/simple;
	bh=5cwhLXMz8QrTZmJ2aIUIscsxFcBNRSCdVudZVldb9z4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzNhjTkYP4qmPbn2N6gtxfB4lnqDoAkvVyCMMje3j95u/89Ec0GC1B2ZhpgtHUDQ34R/ZkPw7Wc9h3Jt3CJPblRZ1k3DXsRUWW/z+8SvmrnLUL+gbJTKAcOf6bmDOe8alSu9kFUOzrWTHx8lFtFYijLcb85z4DY3ysLKM3Y8u24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DuaXJIk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DuaXJIk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB019C4AF19;
	Wed,  1 May 2024 00:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522182;
	bh=5cwhLXMz8QrTZmJ2aIUIscsxFcBNRSCdVudZVldb9z4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=DuaXJIk7hwz2EIdcXIWgHPmDx4UEd/zPGPLdyQ/G5q8nfvS0Q5FOtcZ7tfHG/eW6E
	 3/tPcwG+vUEII+i2oqDmEDMXb+kiJ9tckQBQs6DoicC5MR7dsRVBUcoNFRnkycSRBE
	 /zdnyk1OBMV28EDh7dEsWm6EYtnXSr2MYti67mjILIEqmPanJ3VuMgTW4+AgvK3V3M
	 6x4SZpSDr5S+CY+aitcVFQj6Uy63rDjMQ/rBX7q6RoY94DtELbgi+XszyvVM6/z4vw
	 5rzuX8zKVSxWb/iYQcbmwEfpdufErQsYKRvYdxCLTitym184Y1pHkqxu0wl+iwNYc4
	 z6vGFbOQaFzIg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 05/14] block: Hold a reference on zone write plugs to schedule submission
Date: Wed,  1 May 2024 09:09:26 +0900
Message-ID: <20240501000935.100534-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240501000935.100534-1-dlemoal@kernel.org>
References: <20240501000935.100534-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since a zone write plug BIO work is a field of struct blk_zone_wplug, we
must ensure that a zone write plug is never freed when its BIO
submission work is queued or running. Do this by holding a reference on
the zone write plug when the submission work is scheduled for execution
with queue_work() and releasing the reference at the end of the
execution of the work function blk_zone_wplug_bio_work().
The helper function disk_zone_wplug_schedule_bio_work() is introduced to
get a reference on a zone write plug and queue its work. This helper is
used in disk_zone_wplug_unplug_bio() and disk_zone_wplug_handle_error().

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 0f2ab448ab48..e28a3e6342f9 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1132,6 +1132,19 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
 }
 EXPORT_SYMBOL_GPL(blk_zone_plug_bio);
 
+static void disk_zone_wplug_schedule_bio_work(struct gendisk *disk,
+					      struct blk_zone_wplug *zwplug)
+{
+	/*
+	 * Take a reference on the zone write plug and schedule the submission
+	 * of the next plugged BIO. blk_zone_wplug_bio_work() will release the
+	 * reference we take here.
+	 */
+	WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
+	atomic_inc(&zwplug->ref);
+	queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
+}
+
 static void disk_zone_wplug_unplug_bio(struct gendisk *disk,
 				       struct blk_zone_wplug *zwplug)
 {
@@ -1151,8 +1164,8 @@ static void disk_zone_wplug_unplug_bio(struct gendisk *disk,
 
 	/* Schedule submission of the next plugged BIO if we have one. */
 	if (!bio_list_empty(&zwplug->bio_list)) {
+		disk_zone_wplug_schedule_bio_work(disk, zwplug);
 		spin_unlock_irqrestore(&zwplug->lock, flags);
-		queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
 		return;
 	}
 
@@ -1252,14 +1265,14 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
 	if (!bio) {
 		zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
 		spin_unlock_irqrestore(&zwplug->lock, flags);
-		return;
+		goto put_zwplug;
 	}
 
 	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
 		/* Error recovery will decide what to do with the BIO. */
 		bio_list_add_head(&zwplug->bio_list, bio);
 		spin_unlock_irqrestore(&zwplug->lock, flags);
-		return;
+		goto put_zwplug;
 	}
 
 	spin_unlock_irqrestore(&zwplug->lock, flags);
@@ -1275,6 +1288,10 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
 	 */
 	if (bdev->bd_has_submit_bio)
 		blk_queue_exit(bdev->bd_disk->queue);
+
+put_zwplug:
+	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). */
+	disk_put_zone_wplug(zwplug);
 }
 
 static unsigned int blk_zone_wp_offset(struct blk_zone *zone)
@@ -1354,8 +1371,7 @@ static void disk_zone_wplug_handle_error(struct gendisk *disk,
 
 	/* Restart BIO submission if we still have any BIO left. */
 	if (!bio_list_empty(&zwplug->bio_list)) {
-		WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
-		queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
+		disk_zone_wplug_schedule_bio_work(disk, zwplug);
 		goto unlock;
 	}
 
-- 
2.44.0

