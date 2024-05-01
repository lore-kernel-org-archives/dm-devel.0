Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D4848BFF;
	Wed,  1 May 2024 00:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714522184; cv=none; b=qaq7G19xft4fqU9j17yZRDdx1BG1xt0x1F6sPUrITkPa2x3Ph7s9bmIl/QgDlJXBI9VbBOEJrfxJisnEi7B58bK/aZY8sP13ZLIa59u2GkaaVl9RTygrjSctP+3h/arYkT09vt1EcdFqaKhwl1A9PvKTcTrvF2PQcP4+bVtdBjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714522184; c=relaxed/simple;
	bh=1SA+Z7DPXTFODGai/jtytIByOfxLxTJLEng9yLpKoQY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSk1rxNnN9nzznBgGUNf8Hj7+mUdSgpoLftpaqouJIfUsGcI2AhL5KhT2H9k3G9EL8u9K97sXLQCYCKLyhnRs7xCH9v2CIqKJ32mzokbGle45zA9LGPSFi90vSeUsyC9zv8r47bcNR8JaqhCWMj+a/BkaurqeXECNhAaiMEsyWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kpf8Q0wH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kpf8Q0wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B04FC4AF1C;
	Wed,  1 May 2024 00:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714522183;
	bh=1SA+Z7DPXTFODGai/jtytIByOfxLxTJLEng9yLpKoQY=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Kpf8Q0wHgVgvTIwhcqPKfHkK3IzNStk4JUWBDS5z3tz8nqCIu7EX3QBzi8W30P94O
	 cYSVcrmUD6H0GVoLVlnJCclM5tzxsc32YtT3ilrMiq3C/CG2veX6rgiyb814CcaMIi
	 NVAqJrnHZ3O+pNOEsWHkIlABD8LhwXhI/KsTMBytVZU863wxlXDzHQhXilvHI6gqX4
	 9Y6XznoFAmsmj4wVVK7uSmBUJCS9zDblHFKNZxPlTl2qtgv/DhtUs/qKYvGzJCdUV/
	 /8bNRksUNjSfTd9avRR/Q+DRZbDifNB47B5zSo4G84EJb3NgbWPm0FXEhjcRAd5/0v
	 hETDgFfi8bo/Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 06/14] block: Unhash a zone write plug only if needed
Date: Wed,  1 May 2024 09:09:27 +0900
Message-ID: <20240501000935.100534-7-dlemoal@kernel.org>
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

Fix disk_remove_zone_wplug() to ensure that a zone write plug already
removed from a disk hash table of zone write plugs is not removed
again. Do this by checking the BLK_ZONE_WPLUG_UNHASHED flag of the plug
and calling hlist_del_init_rcu() only if the flag is not set.

Furthermore, since BIO completions can happen at any time, that is,
decrementing of the zone write plug reference count can happen at any
time, make sure to use disk_put_zone_wplug() instead of atomic_dec() to
ensure that the zone write plug is freed when its last reference is
dropped. In order to do this, disk_remove_zone_wplug() is moved after
the definition of disk_put_zone_wplug(). disk_should_remove_zone_wplug()
is moved as well to keep it together with disk_remove_zone_wplug().

To be consistent with this change, add a check in disk_put_zone_wplug()
to ensure that a zone write plug being freed was already removed from
the disk hash table.

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c | 55 +++++++++++++++++++++++++++--------------------
 1 file changed, 32 insertions(+), 23 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index e28a3e6342f9..68a4264aded5 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -476,29 +476,6 @@ static bool disk_insert_zone_wplug(struct gendisk *disk,
 	return true;
 }
 
-static void disk_remove_zone_wplug(struct gendisk *disk,
-				   struct blk_zone_wplug *zwplug)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
-	zwplug->flags |= BLK_ZONE_WPLUG_UNHASHED;
-	atomic_dec(&zwplug->ref);
-	hlist_del_init_rcu(&zwplug->node);
-	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
-}
-
-static inline bool disk_should_remove_zone_wplug(struct gendisk *disk,
-						 struct blk_zone_wplug *zwplug)
-{
-	/* If the zone is still busy, the plug cannot be removed. */
-	if (zwplug->flags & BLK_ZONE_WPLUG_BUSY)
-		return false;
-
-	/* We can remove zone write plugs for zones that are empty or full. */
-	return !zwplug->wp_offset || zwplug->wp_offset >= disk->zone_capacity;
-}
-
 static struct blk_zone_wplug *disk_get_zone_wplug(struct gendisk *disk,
 						  sector_t sector)
 {
@@ -534,11 +511,43 @@ static inline void disk_put_zone_wplug(struct blk_zone_wplug *zwplug)
 	if (atomic_dec_and_test(&zwplug->ref)) {
 		WARN_ON_ONCE(!bio_list_empty(&zwplug->bio_list));
 		WARN_ON_ONCE(!list_empty(&zwplug->link));
+		WARN_ON_ONCE(!(zwplug->flags & BLK_ZONE_WPLUG_UNHASHED));
 
 		call_rcu(&zwplug->rcu_head, disk_free_zone_wplug_rcu);
 	}
 }
 
+static inline bool disk_should_remove_zone_wplug(struct gendisk *disk,
+						 struct blk_zone_wplug *zwplug)
+{
+	/* If the zone is still busy, the plug cannot be removed. */
+	if (zwplug->flags & BLK_ZONE_WPLUG_BUSY)
+		return false;
+
+	/* We can remove zone write plugs for zones that are empty or full. */
+	return !zwplug->wp_offset || zwplug->wp_offset >= disk->zone_capacity;
+}
+
+static void disk_remove_zone_wplug(struct gendisk *disk,
+				   struct blk_zone_wplug *zwplug)
+{
+	unsigned long flags;
+
+	/* If the zone write plug was already removed, we have nothing to do. */
+	if (zwplug->flags & BLK_ZONE_WPLUG_UNHASHED)
+		return;
+
+	/*
+	 * Mark the zone write plug as unhashed and drop the extra reference we
+	 * took when the plug was inserted in the hash table.
+	 */
+	zwplug->flags |= BLK_ZONE_WPLUG_UNHASHED;
+	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	hlist_del_init_rcu(&zwplug->node);
+	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+	disk_put_zone_wplug(zwplug);
+}
+
 static void blk_zone_wplug_bio_work(struct work_struct *work);
 
 /*
-- 
2.44.0

