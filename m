Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547E5171E40;
	Tue, 30 Apr 2024 12:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481499; cv=none; b=F+/jXV8SdCxTpYeaslWiGS1+Btfa7fw9QAYTS4DlsTTsCgy1nFc1uVwCEpeLAKlTrNKuJFymE70QdsO2kgVGRaEDQKPp2nZBz+zVkeBzTI2Rts9yvCz3vhYMFHBlrAhli+htyR/NW3EamCv7J7hhOdZjLgkBrnFkoSmFqGeKuT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481499; c=relaxed/simple;
	bh=Lcxo+nJbtOj+dBCmtGlyawY7aPkYfCV2KhusyQ8HWSA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmcDslyhvnwiPX+EAmEnjMUwUButUSRKou1VPb22fyMW3pu6kjraNd3bxRPh3tzuhOS93x/pIokLUgqWvwUqEXlApkpQ2h5mAuXHZxo2/A6wMEWITg/F2XjZzuJZqgIrnP7BYJhPF3kKjZmUjDw+d6p3HBFHeufqMGcAGtwSdSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tMDxgtF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tMDxgtF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7350BC4AF1A;
	Tue, 30 Apr 2024 12:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481499;
	bh=Lcxo+nJbtOj+dBCmtGlyawY7aPkYfCV2KhusyQ8HWSA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=tMDxgtF6V0cjqUvLRt4LpFVQ6nyk8THAKQm65pr7qEJyQO0kPIRcS6137aIYnEvwY
	 YLW5kWFzqMloSNSj5rYKjtl9dg4r7nKJCWJO07g5OduWjPpAgJFLcNRje9g4LQEBZB
	 YWvekfTFshder6QIWclK0CnddZT9qfRkE/sGBG3gaej7IDbaAbNEItQgF4I0fcUAei
	 DquoEjEYCk7ZOOM37AyhmiF0aUmYdt0mx5jUiPDDzgnJztdJedcCu4rgRgXdeYZ+ZG
	 1w9rMS3IfeSEjgiHVo8qsEBXghyU3gvLBCJOTBxJMM9IlAZG6iiA/1PifPa4h5VEvM
	 DJlpKlAI6W6UA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 05/13] block: Hold a reference on zone write plugs to schedule submission
Date: Tue, 30 Apr 2024 21:51:23 +0900
Message-ID: <20240430125131.668482-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430125131.668482-1-dlemoal@kernel.org>
References: <20240430125131.668482-1-dlemoal@kernel.org>
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
---
 block/blk-zoned.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 9bded29592e0..03555ea64774 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1131,6 +1131,19 @@ bool blk_zone_plug_bio(struct bio *bio, unsigned int nr_segs)
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
@@ -1150,8 +1163,8 @@ static void disk_zone_wplug_unplug_bio(struct gendisk *disk,
 
 	/* Schedule submission of the next plugged BIO if we have one. */
 	if (!bio_list_empty(&zwplug->bio_list)) {
+		disk_zone_wplug_schedule_bio_work(disk, zwplug);
 		spin_unlock_irqrestore(&zwplug->lock, flags);
-		queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
 		return;
 	}
 
@@ -1251,14 +1264,14 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
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
@@ -1274,6 +1287,10 @@ static void blk_zone_wplug_bio_work(struct work_struct *work)
 	 */
 	if (bdev->bd_has_submit_bio)
 		blk_queue_exit(bdev->bd_disk->queue);
+
+put_zwplug:
+	/* Drop the reference we took in disk_zone_wplug_schedule_bio_work(). */
+	disk_put_zone_wplug(zwplug);
 }
 
 static unsigned int blk_zone_wp_offset(struct blk_zone *zone)
@@ -1353,8 +1370,7 @@ static void disk_zone_wplug_handle_error(struct gendisk *disk,
 
 	/* Restart BIO submission if we still have any BIO left. */
 	if (!bio_list_empty(&zwplug->bio_list)) {
-		WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_PLUGGED));
-		queue_work(disk->zone_wplugs_wq, &zwplug->bio_work);
+		disk_zone_wplug_schedule_bio_work(disk, zwplug);
 		goto unlock;
 	}
 
-- 
2.44.0

