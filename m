Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777C1171096;
	Tue, 30 Apr 2024 12:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481498; cv=none; b=bSwjigDKomAGodhsEFneHZkxka3raYeiY2a/54BGxEC9qknv3VVReC/g4SA32wLSzCdj6lPwVlQHiIDp6MQMQwHFFxKoBGAGbRMhbaiJgKBJLcGp6mIV4S73mGlIUnCpdxgtaYAfGxz3Knh+6Nd2MUpI3YSPQpSat8hpRazz6MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481498; c=relaxed/simple;
	bh=cYF0XCVNaKjlif5lITJ69C3QuZHOBKVEAIwcOsZ0T2c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZrUjlCH6QDzsB6OIdVXFjQjvpCMnISsGIlPp+0FXdKTjBrTx4e/4HTN+dUqYPmnLRSsLwrEomRX7Y16ZSRRHfInYDE9mSuIOwxFUs8o1ATk1dupSH3Jmx9bTiue1x1xwLg5zdcRW8UMHb1TWXkzvnI/VqvOeU3dXZjxG3uWpqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iK8rjibE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iK8rjibE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F44BC2BBFC;
	Tue, 30 Apr 2024 12:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481498;
	bh=cYF0XCVNaKjlif5lITJ69C3QuZHOBKVEAIwcOsZ0T2c=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=iK8rjibEgR+MpHYsDzLnIPZAbGundvGWASxah1oyyy22S9lQ2uK2zBk1AoeG9NnIr
	 K1AIwpoJOlV+33Mx5D/mANSbwWAEwk2BHbnp6AHaDsI6dmo4WWKqFoWNKtFXI6sd24
	 TvjUT4AwXKOhK0pBm39/fGYTLz8Lp9orSNVm52Z4c51VMUy4IFKGKuGjSjU7sBicdd
	 Xu5g17D4wUcICV3whFqOiQfa7BZVs1GtONKy1wE5hB5lCuTBZZCfhNP6xLp4VKsgHr
	 p/Hq/x71AguKRaQJixFrG/DPSNRiCEepQHjt9nWPG0i1SpWBBBYZKf7utc2fYnnjcP
	 e0Yw44MNz5k6A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 04/13] block: Fix reference counting for zone write plugs in error state
Date: Tue, 30 Apr 2024 21:51:22 +0900
Message-ID: <20240430125131.668482-5-dlemoal@kernel.org>
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

When zone is reset or finished, disk_zone_wplug_set_wp_offset() is
called to update the zone write plug write pointer offset and to clear
the zone error state (BLK_ZONE_WPLUG_ERROR flag) if it is set.
However, this processing is missing dropping the reference to the zone
write plug that was taken in disk_zone_wplug_set_error() when the error
flag was first set. Furthermore, the error state handling must release
the zone write plug lock to first execute a report zones command. When
the report zone races with a reset or finish operation that clears the
error, we can end up decrementing the zone write plug reference count
twice: once in disk_zone_wplug_set_wp_offset() for the reset/finish
operation and one more time in disk_zone_wplugs_work() once
disk_zone_wplug_handle_error() completes.

Fix this by introducing disk_zone_wplug_clear_error() as the symmetric
function of disk_zone_wplug_set_error(). disk_zone_wplug_clear_error()
decrements the zone write plug reference count obtained in
disk_zone_wplug_set_error() only if the error handling has not started
yet, that is, only if disk_zone_wplugs_work() has not yet taken the zone
write plug off the error list. This ensure that either
disk_zone_wplug_clear_error() or disk_zone_wplugs_work() drop the zone
write plug reference count.

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 74 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 48 insertions(+), 26 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index e92ae0729cf8..9bded29592e0 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -658,6 +658,53 @@ static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
 	bio_list_merge(&zwplug->bio_list, &bl);
 }
 
+static inline void disk_zone_wplug_set_error(struct gendisk *disk,
+					     struct blk_zone_wplug *zwplug)
+{
+	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR)) {
+		unsigned long flags;
+
+		/*
+		 * At this point, we already have a reference on the zone write
+		 * plug. However, since we are going to add the plug to the disk
+		 * zone write plugs work list, increase its reference count.
+		 * This reference will be dropped in disk_zone_wplugs_work()
+		 * once the error state is handled, or
+		 * in disk_zone_wplug_clear_error() if the zone is reset or
+		 * finished.
+		 */
+		zwplug->flags |= BLK_ZONE_WPLUG_ERROR;
+		atomic_inc(&zwplug->ref);
+
+		spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+		list_add_tail(&zwplug->link, &disk->zone_wplugs_err_list);
+		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+	}
+}
+
+static inline void disk_zone_wplug_clear_error(struct gendisk *disk,
+					       struct blk_zone_wplug *zwplug)
+{
+	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR) {
+		unsigned long flags;
+
+		/*
+		 * We are racing with the error handling work which drops
+		 * the reference on the zone write plug after handling the error
+		 * state. So remove the plug from the error list and drop its
+		 * reference count only if the error handling has not yet
+		 * started, that is, if the zone write plug is still listed.
+		 */
+		spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+		if (!list_empty(&zwplug->link)) {
+			list_del_init(&zwplug->link);
+			zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
+			disk_put_zone_wplug(zwplug);
+		}
+		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+	}
+}
+
 /*
  * Set a zone write plug write pointer offset to either 0 (zone reset case)
  * or to the zone size (zone finish case). This aborts all plugged BIOs, which
@@ -691,12 +738,7 @@ static void disk_zone_wplug_set_wp_offset(struct gendisk *disk,
 	 * in a good state. So clear the error flag and decrement the
 	 * error count if we were in error state.
 	 */
-	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR) {
-		zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
-		spin_lock(&disk->zone_wplugs_lock);
-		list_del_init(&zwplug->link);
-		spin_unlock(&disk->zone_wplugs_lock);
-	}
+	disk_zone_wplug_clear_error(disk, zwplug);
 
 	/*
 	 * The zone write plug now has no BIO plugged: remove it from the
@@ -885,26 +927,6 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
 	spin_unlock_irqrestore(&zwplug->lock, flags);
 }
 
-static inline void disk_zone_wplug_set_error(struct gendisk *disk,
-					     struct blk_zone_wplug *zwplug)
-{
-	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR)) {
-		unsigned long flags;
-
-		/*
-		 * Increase the plug reference count. The reference will be
-		 * dropped in disk_zone_wplugs_work() once the error state
-		 * is handled.
-		 */
-		zwplug->flags |= BLK_ZONE_WPLUG_ERROR;
-		atomic_inc(&zwplug->ref);
-
-		spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
-		list_add_tail(&zwplug->link, &disk->zone_wplugs_err_list);
-		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
-	}
-}
-
 /*
  * Check and prepare a BIO for submission by incrementing the write pointer
  * offset of its zone write plug and changing zone append operations into
-- 
2.44.0

