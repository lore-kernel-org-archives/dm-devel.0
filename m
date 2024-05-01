Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2881B4C97;
	Wed,  1 May 2024 00:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522182; cv=none; b=KZGMFhS/Qujx0AN3aklAHLxb3Rg/VCNnKfiieXK3MhgZyzOC1PefcGjp05yFVyLzMVilvMeNkV54xfiK2mp21VFDec+G2Bf4lwri3wPJDnqZg70klc0vbQJaMh8ia3WGLOIUFhN4H30ID7MMifRifMWoSWLFytYsgSu5WYeL+PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522182; c=relaxed/simple;
	bh=UYbDBB4mkhgIbm/O5DApC2B+iCtz2RxHZIN2xmykWVA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtrGKN9B6hYBkEJWj7ELhUbrpNXOX/1LzPQhXZDQXkN44Bdk2dFcbKLHr5ID+Ac1m5RXoVGZ8Xg7QP3HBJD8NQ96SQskhD/Q81e3TGnvAkAgZTGhjL/XV98j/GHIZNmWfWwyJ2GwDZ0/HiGNQRUWG5200hSAu9ClSdGP44ZixVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hcNBcUEC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hcNBcUEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6775C2BBFC;
	Wed,  1 May 2024 00:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522181;
	bh=UYbDBB4mkhgIbm/O5DApC2B+iCtz2RxHZIN2xmykWVA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hcNBcUECZNdajHr9utKxGMpz2Hj8ytwc0WsD2+GamcTTyYGRefBktAOVzfxHzfOI/
	 8ABYfcSRMdmNI0V4eudVxnG8GR0x6/TA6WB6vvmrz2sNx3LR2L1illhb5CWnvHwuYo
	 hpThRxQc3NWuldbNSf5L8ZGQUqizGG0mdjYeuBpWddXXTf7G1/s7tUvibNRpKm8S3J
	 9TtUr/DeGZtmEYC26Hg/1kCA2b/yQtQ0xpTnPISRlgTy9TtrmMPCqI80cV4kCgXPCs
	 uzk+mPZ6+049x65Rn9NCTpWLBQ4IWP4/F8ViXhMRJuDoIXoiFHLU7hvJJaQ5g4ONr8
	 KQZXdtP1WF9Ew==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 04/14] block: Fix reference counting for zone write plugs in error state
Date: Wed,  1 May 2024 09:09:25 +0900
Message-ID: <20240501000935.100534-5-dlemoal@kernel.org>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c | 75 +++++++++++++++++++++++++++++++----------------
 1 file changed, 49 insertions(+), 26 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index e92ae0729cf8..0f2ab448ab48 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -658,6 +658,54 @@ static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
 	bio_list_merge(&zwplug->bio_list, &bl);
 }
 
+static inline void disk_zone_wplug_set_error(struct gendisk *disk,
+					     struct blk_zone_wplug *zwplug)
+{
+	unsigned long flags;
+
+	if (zwplug->flags & BLK_ZONE_WPLUG_ERROR)
+		return;
+
+	/*
+	 * At this point, we already have a reference on the zone write plug.
+	 * However, since we are going to add the plug to the disk zone write
+	 * plugs work list, increase its reference count. This reference will
+	 * be dropped in disk_zone_wplugs_work() once the error state is
+	 * handled, or in disk_zone_wplug_clear_error() if the zone is reset or
+	 * finished.
+	 */
+	zwplug->flags |= BLK_ZONE_WPLUG_ERROR;
+	atomic_inc(&zwplug->ref);
+
+	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	list_add_tail(&zwplug->link, &disk->zone_wplugs_err_list);
+	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+}
+
+static inline void disk_zone_wplug_clear_error(struct gendisk *disk,
+					       struct blk_zone_wplug *zwplug)
+{
+	unsigned long flags;
+
+	if (!(zwplug->flags & BLK_ZONE_WPLUG_ERROR))
+		return;
+
+	/*
+	 * We are racing with the error handling work which drops the reference
+	 * on the zone write plug after handling the error state. So remove the
+	 * plug from the error list and drop its reference count only if the
+	 * error handling has not yet started, that is, if the zone write plug
+	 * is still listed.
+	 */
+	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	if (!list_empty(&zwplug->link)) {
+		list_del_init(&zwplug->link);
+		zwplug->flags &= ~BLK_ZONE_WPLUG_ERROR;
+		disk_put_zone_wplug(zwplug);
+	}
+	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+}
+
 /*
  * Set a zone write plug write pointer offset to either 0 (zone reset case)
  * or to the zone size (zone finish case). This aborts all plugged BIOs, which
@@ -691,12 +739,7 @@ static void disk_zone_wplug_set_wp_offset(struct gendisk *disk,
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
@@ -885,26 +928,6 @@ void blk_zone_write_plug_attempt_merge(struct request *req)
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

