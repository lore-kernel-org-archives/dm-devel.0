Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2B657318;
	Wed,  1 May 2024 11:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714561753; cv=none; b=C+crgPvZBKUjOUcG7s/g+qjJFOxqTt+Mt/RlKtOZALknjNVz6L+310CqCPJ8QxvQnEmjar7ukZCNy7PviBfZHGCJOCSPbjBd+mP9xtRUz+TjHizLBNOtVlu2+0IYN7bN7bQIkCKFqc7V/0VG182evQJopfCHCNUlF9aoUAFu4Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714561753; c=relaxed/simple;
	bh=fdw++zbzog6uHHYzW3IPuUawa8iWP6zVkchCq3dleQw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPXRMkODcrQls4vZ95p3TnFKQcDWaYqhzpkJ14SoCp3/ZdIdF7ukgCMmyHCEfeGnbqPBLEESE78lSQZ1kKgzmvCEU/lfWn0/E9W+BeK0RLxOKG1nXacLJUvVrDkQNT9iHZ2KwbweLLGNyN1Tx7d8eU7dty+QH2ZbOe++1B8nlbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIEgL/oe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIEgL/oe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45476C113CC;
	Wed,  1 May 2024 11:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714561753;
	bh=fdw++zbzog6uHHYzW3IPuUawa8iWP6zVkchCq3dleQw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=KIEgL/oe+gqLFvaB1pVsKvsso5wN+b2/PY8aCwyYTOkbiWcbhV1VlAzifS301gU21
	 MIUqmyraWR5RsorL/0bspuibG91tcWqU5QyjAJSsYhcAwayRmQULmlc61sqgczL+Ou
	 Cjj2y8tGAHe+HCe7iOqUTwX6Lmn4kRBYgofp6+Ue9jF5P4bcJhV/CRnWcSpASaeWLC
	 zam+KGDeoo4vhxFNn9BDmJfRhPL5mRBGa8pCfczQ7a5Thj0DAGSZQNDQkGhF/sX2TS
	 BuyC4TvVboYdeUvSjcVX9Hn5+hmNwJUIdwN7pRIux7hlD4jNDlYagMj7Ob1he4Ygug
	 8Tj5uOXD7S9bQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 03/14] block: Fix zone write plug initialization from blk_revalidate_zone_cb()
Date: Wed,  1 May 2024 20:08:56 +0900
Message-ID: <20240501110907.96950-4-dlemoal@kernel.org>
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

When revalidating the zones of a zoned block device,
blk_revalidate_zone_cb() must allocate a zone write plug for any
sequential write required zone that is not empty nor full. However, the
current code tests the latter case by comparing the zone write pointer
offset to the zone size instead of the zone capacity. Furthermore,
disk_get_and_lock_zone_wplug() is called with a sector argument equal to
the zone start instead of the current zone write pointer position.
This commit fixes both issues by calling disk_get_and_lock_zone_wplug()
for a zone that is not empty and with a write pointer offset lower than
the zone capacity and use the zone capacity sector as the sector
argument for disk_get_and_lock_zone_wplug().

Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 block/blk-zoned.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 731d1abb80f6..7824bd52c82c 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1664,10 +1664,11 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 		 * empty nor full. So make sure we have a zone write plug for
 		 * such zone if the device has a zone write plug hash table.
 		 */
+		if (!disk->zone_wplugs_hash)
+			break;
 		wp_offset = blk_zone_wp_offset(zone);
-		if (disk->zone_wplugs_hash &&
-		    wp_offset && wp_offset < zone_sectors) {
-			zwplug = disk_get_and_lock_zone_wplug(disk, zone->start,
+		if (wp_offset && wp_offset < zone->capacity) {
+			zwplug = disk_get_and_lock_zone_wplug(disk, zone->wp,
 							      GFP_NOIO, &flags);
 			if (!zwplug)
 				return -ENOMEM;
-- 
2.44.0

