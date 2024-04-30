Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70774171E40;
	Tue, 30 Apr 2024 12:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481500; cv=none; b=hO22bAfZKuKrLiCpJs6KWHTrKQ6WsV8LD47UBzFsI30aSD2KLIxFIAz7Jw0Ytv5WMHJgf+T6LK0cDjrDvuB62kDpuMx/fvClvS0Ia//YbS4WfFXjwa/rzHyw1WMoHJvWf5Oeg5ZDfOxUptZt+qtWueowNfLaMh1gf4iCHW0T25E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481500; c=relaxed/simple;
	bh=57RelSjjutDoHKvK1Hjat/0nCTLphGOX+8KB7rI6lzg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Um/O6g1qw12Xm7fcLNAWjNjaOWnIXO/kHaTd2eXhD95jkTulCh1OdNFZoq7tabDXTG7YrvJPmz29Zy7B5qSP0h6cMDnrW0rftUl40ztNvxxx3Vh/GAxoSan7fQaff/QF/kITpjfTL7kprTKKafzHz/74V8Wzjf4+9ZzBqYQcWNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8jF2N08; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8jF2N08"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B58C4AF19;
	Tue, 30 Apr 2024 12:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481500;
	bh=57RelSjjutDoHKvK1Hjat/0nCTLphGOX+8KB7rI6lzg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Z8jF2N08xG+EWjkEIaAx9i2LsFRMBmkfDNHZ8tE17J/2uirYAeN55121Ap2WVhrJg
	 mcBeDbmYKtOBe2r92x7yOfi7FRUFgd81ztWse2s27NORjg+vK1zoxPJ3bykvuQ3pp1
	 hcQgnr4qrcTtLvXq+Uq0xQMHXTtl8vNrlyIYZWEE38BNKLObHw0wpJHN048pFESg1m
	 5yw1uFZ2tfjYracRcZCV6XyNqu8PWJ9DAb/l12FwdD0LZluOFcTjzyaLctHaFUHM4T
	 K29iNgghYDwViul4xJPDbZJUU/1Q7cNZMcUZEsyY0Jr/TlMIwto10ILAyaWx2hPHZA
	 +uPsVGQkhG5cQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 06/13] block: Unhash a zone write plug only if needed
Date: Tue, 30 Apr 2024 21:51:24 +0900
Message-ID: <20240430125131.668482-7-dlemoal@kernel.org>
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
---
 block/blk-zoned.c | 54 +++++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 03555ea64774..82e540dad900 100644
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
@@ -534,11 +511,42 @@ static inline void disk_put_zone_wplug(struct blk_zone_wplug *zwplug)
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
+	if (!(zwplug->flags & BLK_ZONE_WPLUG_UNHASHED)) {
+		unsigned long flags;
+
+		/*
+		 * Mark the zone write plug as unhashed and drop the extra
+		 * reference we took when the plug was inserted in the hash
+		 * table.
+		 */
+		zwplug->flags |= BLK_ZONE_WPLUG_UNHASHED;
+		spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+		hlist_del_init_rcu(&zwplug->node);
+		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+		disk_put_zone_wplug(zwplug);
+	}
+}
+
 static void blk_zone_wplug_bio_work(struct work_struct *work);
 
 /*
-- 
2.44.0

