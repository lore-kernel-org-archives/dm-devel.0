Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606DB171096;
	Tue, 30 Apr 2024 12:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481497; cv=none; b=FMVHtKCdDpprLqbQlwd6eqkhgNKJQMALfJjd2VU4EmSxDgg3tSqKwtnd9tck76cjUBusSKNpjuL0GN0qz55X2x8xPEaswOhser3V8uBgprk9Quc4oa+QOqW1Vw4NYXCi2q6ZN7BpRjFMJVMnQcFVWNwfNFWNWrjqct2Jv/Iu0NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481497; c=relaxed/simple;
	bh=3ybx/BNEekLRwwpxdz12dy3oj1tDPE+cNVEDl1YepSg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0aRrtsPxsTIzzGIDr7gGyoanj2+ccduVp/X0cVKt8AXuZnfrDPH8Yr06DVlOnl2VzphqkCom0ScuiXMzHTVZMMCgc3oLKBor0+vx7e3KXvmNPCyn+mB6f7G5++xinITkPD//w9c/uugsYDNH1M1XoLu2qBMRwB5btbkS06EcSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJLhoOgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJLhoOgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D005C4AF18;
	Tue, 30 Apr 2024 12:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714481496;
	bh=3ybx/BNEekLRwwpxdz12dy3oj1tDPE+cNVEDl1YepSg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=BJLhoOgFpLQEgLa0Lisd5HhjsI+qPVi2F097UtJT9u0F8ADj6BZaccVuf6sabGp9s
	 7ZIQ3FZzFTn2/dbIpDqLfjYVfgRCxw5bpxh1XRDAJZ9wo6Nlz4Dr7FJvGoO6UryT9K
	 liiCSVUWorumoaBxKpwUwFthLfd2xOkU3kzCvjPnaU2nKqEYdcNfM2GpZLDnVVM62x
	 tXjM7sA3ciuT8ft78IvZ+QZ3E6gZAiF7+h2+mX5ylU9he6tphyEcoeHEO8bV/4n7S+
	 llcW63ZSxKy9liPxT8BUvXl4EF4/YOw2L9yNLvM7rjh+mPbxyKfY0IXPzi9kL7Xjs6
	 C+QLUaJXB+wpA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 03/13] block: Fix zone write plug initialization from blk_revalidate_zone_cb()
Date: Tue, 30 Apr 2024 21:51:21 +0900
Message-ID: <20240430125131.668482-4-dlemoal@kernel.org>
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
---
 block/blk-zoned.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 6cf3e319513c..e92ae0729cf8 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1666,10 +1666,11 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
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

