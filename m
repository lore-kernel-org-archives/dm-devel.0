Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF0F57318;
	Wed,  1 May 2024 11:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714561754; cv=none; b=MbJVxsLvmekIAlsw0Fn6H7NeRin91LlkNSjhIoIlTZA5KjbFjiJ24Txhd/YGG0MpKLGjW8gKrmIZYw6ObwWqAFHtfmOPDxii8vsQC989DhjOmQZoZ4T4bpAm9G0CdSKiLp/S0WwntKGQPg0XqmtIR1Zj9MUGydAb45bwxtlcyLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714561754; c=relaxed/simple;
	bh=+2ygrDEnmy5glAG0PyJ/eBX4/XIgEBKdkLBYV5DxdRc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HuU/P4xELqR1EL7OODbvd8eaD1VXyIso03TMKAPZ5O0GJ3mVoN4RNLLH4IUgnA9d1OSWAf3aIjX49LWHUbj3KddD4m2ZWSHOo8FNmEPGWPTTLQqcAJOEUpvNZT5eoD0BTrsGkBTfndbcTxhxpnEl5ISkcte7zs029Q7T8zG6D5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqXjmEbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqXjmEbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656A7C32789;
	Wed,  1 May 2024 11:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714561754;
	bh=+2ygrDEnmy5glAG0PyJ/eBX4/XIgEBKdkLBYV5DxdRc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=oqXjmEbozAuHc5lL4dGVhYVLHKXlOyKgcmiKwkI9MlP3Ls2lK+QjGphogDrcp8lmw
	 hRbI2gCHzd6Wq9Tfw9NGDCQBng8qYFIQMclt9xlHkWvA6WARtkCPvQD3m9vQK/Y3d2
	 OQG2ioA3mYUo1Fl2eECJde6cOTWrulLf+EJP4YjatyyIZ7m34ZaHPWqQ2LRIrG6o2p
	 CWA34rxKNFSTmiPBsWQw0ni5DBtl0QvtS80b30dvWdxWbOZN9FWG1ylb449CGOGqXL
	 VHUhJUIHkJtgyRhjwACKtGB/McjoDfqQimNaUwaWL+xetLtw8LX+egY807exf6WAHo
	 dw7s33FVPUP6g==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 04/14] block: Fix reference counting for zone write plugs in error state
Date: Wed,  1 May 2024 20:08:57 +0900
Message-ID: <20240501110907.96950-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240501110907.96950-1-dlemoal@kernel.org>
References: <20240501110907.96950-1-dlemoal@kernel.org>
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
index 7824bd52c82c..23ad1de0da62 100644
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

