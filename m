Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A2B1EA91
	for <dm-devel@lists.linux.dev>; Thu,  3 Apr 2025 01:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743642372; cv=none; b=IR/bD9iIMbmL1fzue5Pc46L4EWVvW3p7ydrAMoBAcXWd/Bo/E7uSJj2YepBf+oMM/gAUiGLyaQmcM4lKi1X6/Xym8snrAoomeyUf+KqgDM2NBp8pWkHJZbiLamphxpiEbdayAb+z2gSW301+sHoZOpS8DQiYMQkF8AzRzrAjv7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743642372; c=relaxed/simple;
	bh=DPjNaJwGYIut3lVEtU1MEzbkoWxtgz7SV3Az7K0Q3eU=;
	h=From:To:Cc:Subject:Date:Message-Id; b=tbVwOOySi75cKqCKqORAoqt8RoE5SpUKeOtaEZ8Cxpw7WENLjPRGLqcPqeLFy2jh9qSA212LM/4IPVCxMBfvh1QwbwPgsoVekvAYMujE8tLwRCgxScjwsntXMfcWbPeZw1PxhvPcGz+DfAbDOVpk4sNZVLxQ0eqAqxes+xp8dZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.51 with ESMTP; 3 Apr 2025 09:36:07 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: chanho.min@lge.com
Received: from unknown (HELO localhost.localdomain) (10.178.31.96)
	by 156.147.1.125 with ESMTP; 3 Apr 2025 09:36:07 +0900
X-Original-SENDERIP: 10.178.31.96
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Sven <dm-devel@schwermer.no>,
	Neil Brown <neilb@suse.de>,
	hch@lst.de,
	dm-devel@lists.linux.dev,
	Gunho Lee <gunho.lee@lge.com>,
	Chanho Min <chanho.min@lge.com>
Subject: [PATCH] block: remove non-existent partition dev_t return from blk_lookup_devt
Date: Thu,  3 Apr 2025 09:35:32 +0900
Message-Id: <20250403003532.412-1-chanho.min@lge.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

We encountered frequent boot failures while setting up a dm-verity rootfs with
the following configuration, and found that this issue had been reported
previously:

  root=/dev/dm-0
  dm-mod.waitfor=/dev/mmcblk0p23

The error observed was:

  device-mapper: table: 254:0: verity: Data device lookup failed (-ENXIO)
  device-mapper: ioctl: error adding target to table

Bisecting the issue revealed that this was a latent problem exacerbated by
commit 238d991f054a ("dm: use fsleep() instead of msleep() for deterministic
sleep duration"), after which the failures became more frequent. Further
investigation pinpointed the root cause to a special case added in
blk_lookup_devt() by commit 41b8c853a495 ("block: fix booting from partitioned
md array")

This commit modified blk_lookup_devt() to return a dev_t for non-existent
partitions to support MD RAID booting when partitions are not yet available,
e.g., for root=/dev/md_d0p1. While this addressed the MD issue, it deviates
from the expected role of blk_lookup_devt(), which should return a dev_t only
for existing block devices. Adding MD-specific logic to a common block layer
function was a suboptimal approach, as it compromises the function's clarity
and causes side effects, such as the dm-init failures seen with dm-verity.

The MD RAID booting issue should ideally have been handled within the MD
driver or boot logic (e.g., via a dedicated md_lookup_devt() function) rather
than modifying a generic lookup function. This patch removes the non-existent
partition dev_t return logic, restoring blk_lookup_devt() to its intended
purpose. This resolves the dm-verity boot failures by ensuring accurate dev_t
returns.

If MD RAID booting still depends on this behavior in some setups, a regression
may occur. In that case, the MD subsystem should implement a proper solution
(e.g., specific lookup function) rather than relying on this workaround.
Testers are encouraged to verify MD RAID booting with partitioned root devices
(e.g., root=/dev/md_d0p1) to confirm.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 block/early-lookup.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/block/early-lookup.c b/block/early-lookup.c
index 3fb57f7d2b127..3764dfb429c54 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -134,17 +134,9 @@ static dev_t __init blk_lookup_devt(const char *name, int partno)
 		if (strcmp(dev_name(dev), name))
 			continue;
 
-		if (partno < disk->minors) {
-			/* We need to return the right devno, even
-			 * if the partition doesn't exist yet.
-			 */
-			devt = MKDEV(MAJOR(dev->devt),
-				     MINOR(dev->devt) + partno);
-		} else {
-			devt = part_devt(disk, partno);
-			if (devt)
-				break;
-		}
+		devt = part_devt(disk, partno);
+		if (devt)
+			break;
 	}
 	class_dev_iter_exit(&iter);
 	return devt;
-- 
2.17.1

