Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F181C1F1932
	for <dm-devel@lists.linux.dev>; Thu, 10 Apr 2025 08:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.23.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744273895; cv=none; b=QMIzNKoLRAEwRmKsqQ8YFF+QEQsMaNyCsrJSRPsmqTRwWYs6fLq9aUQhPUNoIk399HSPp95/cFgAmcuvylJjzbRT/4AQ6rV/vxruqE+f0AVWPJ0Pmli8g6bhBA8L2wqi3TAKXA/VhB098mLqu89sVs+oaqW2+aMsNN+xwBf+o/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744273895; c=relaxed/simple;
	bh=MH9inepon/NwBHx7CSMIuKgmZl41UPCwzOKE9quAemE=;
	h=From:To:Cc:Subject:Date:Message-Id; b=FaIUm8FyfnUO0KqbyFE8GMTd4SzyBw/lGnoUmxrZS/EBmTyHMvVPmLw3jtqa6i8gFQH7rAuboE60GAHdTdnBfH07yT1T2EmbTj/yAWqy1aDy1zDGm/shB/Xx6AQo7Qr7lmS3Ko5DLN1ZhL/9itga4nmqKrBOrrNJ7shyBhKyJ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.23.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO lgeamrelo01.lge.com) (156.147.1.125)
	by 156.147.23.51 with ESMTP; 10 Apr 2025 17:01:30 +0900
X-Original-SENDERIP: 156.147.1.125
X-Original-MAILFROM: chanho.min@lge.com
Received: from unknown (HELO localhost.localdomain) (10.178.31.96)
	by 156.147.1.125 with ESMTP; 10 Apr 2025 17:01:30 +0900
X-Original-SENDERIP: 10.178.31.96
X-Original-MAILFROM: chanho.min@lge.com
From: Chanho Min <chanho.min@lge.com>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Alasdair Kergon <agk@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	gunho.lee@lge.com,
	Chanho Min <chanho.min@lge.com>
Subject: [PATCH] block/dm: add early_lookup_ready_bdev to ensure ready device lookup
Date: Thu, 10 Apr 2025 17:00:56 +0900
Message-Id: <20250410080056.43247-1-chanho.min@lge.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

The dm-init code, waiting for devices specified by dm-mod.waitfor (e.g.,
root=/dev/dm-0, dm-mod.waitfor=/dev/mmcblk0p23), fails sporadically with
dm-verity setups, as reported in:
https://lore.kernel.org/all/e746b8b5-c04c-4982-b4bc-0fa240742755@schwermer.no/T/

This occurs because early_lookup_bdev() uses blk_lookup_devt(), which, since
commit 41b8c853a4954 ("block: fix booting from partitioned md array"),
returns a dev_t for non-existent partitions to support MD RAID booting. This
leads dm-init to proceed with invalid dev_t values, causing "Data device
lookup failed (-ENXIO)". The issue became more noticeable after commit
238d991f054a6e2d ("dm: use fsleep() instead of msleep() for deterministic
sleep duration").

This patch introduces early_lookup_ready_bdev(), a variant of
early_lookup_bdev() that only returns dev_t for devices with ready partitions,
by adding a 'ready' flag to blk_lookup_devt(). The original early_lookup_bdev()
is preserved for MD RAID compatibility, while dm-init switches to the new
function to wait for actual device availability. This resolves dm-verity boot
failures cleanly at the block layer, avoiding DM-specific workarounds.

Tested with dm-verity (root=/dev/dm-0, dm-mod.waitfor=/dev/mmcblk0p23), this
eliminates boot issues without impacting MD RAID.

Signed-off-by: Chanho Min <chanho.min@lge.com>
---
 block/early-lookup.c   | 26 ++++++++++++++++++--------
 drivers/md/dm-init.c   |  2 +-
 include/linux/blkdev.h |  2 ++
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/block/early-lookup.c b/block/early-lookup.c
index 3fb57f7d2b127..011cfda5e4843 100644
--- a/block/early-lookup.c
+++ b/block/early-lookup.c
@@ -121,7 +121,7 @@ static int __init devt_from_partlabel(const char *label, dev_t *devt)
 	return 0;
 }
 
-static dev_t __init blk_lookup_devt(const char *name, int partno)
+static dev_t __init blk_lookup_devt(const char *name, int partno, bool ready)
 {
 	dev_t devt = MKDEV(0, 0);
 	struct class_dev_iter iter;
@@ -134,7 +134,7 @@ static dev_t __init blk_lookup_devt(const char *name, int partno)
 		if (strcmp(dev_name(dev), name))
 			continue;
 
-		if (partno < disk->minors) {
+		if (!ready && partno < disk->minors) {
 			/* We need to return the right devno, even
 			 * if the partition doesn't exist yet.
 			 */
@@ -150,7 +150,7 @@ static dev_t __init blk_lookup_devt(const char *name, int partno)
 	return devt;
 }
 
-static int __init devt_from_devname(const char *name, dev_t *devt)
+static int __init devt_from_devname(const char *name, dev_t *devt, bool ready)
 {
 	int part;
 	char s[32];
@@ -164,7 +164,7 @@ static int __init devt_from_devname(const char *name, dev_t *devt)
 			*p = '!';
 	}
 
-	*devt = blk_lookup_devt(s, 0);
+	*devt = blk_lookup_devt(s, 0, ready);
 	if (*devt)
 		return 0;
 
@@ -180,7 +180,7 @@ static int __init devt_from_devname(const char *name, dev_t *devt)
 	/* try disk name without <part number> */
 	part = simple_strtoul(p, NULL, 10);
 	*p = '\0';
-	*devt = blk_lookup_devt(s, part);
+	*devt = blk_lookup_devt(s, part, ready);
 	if (*devt)
 		return 0;
 
@@ -188,7 +188,7 @@ static int __init devt_from_devname(const char *name, dev_t *devt)
 	if (p < s + 2 || !isdigit(p[-2]) || p[-1] != 'p')
 		return -ENODEV;
 	p[-1] = '\0';
-	*devt = blk_lookup_devt(s, part);
+	*devt = blk_lookup_devt(s, part, ready);
 	if (*devt)
 		return 0;
 	return -ENODEV;
@@ -241,17 +241,27 @@ static int __init devt_from_devnum(const char *name, dev_t *devt)
  *	name contains slashes, the device name has them replaced with
  *	bangs.
  */
-int __init early_lookup_bdev(const char *name, dev_t *devt)
+int __init __early_lookup_bdev(const char *name, dev_t *devt, bool ready)
 {
 	if (strncmp(name, "PARTUUID=", 9) == 0)
 		return devt_from_partuuid(name + 9, devt);
 	if (strncmp(name, "PARTLABEL=", 10) == 0)
 		return devt_from_partlabel(name + 10, devt);
 	if (strncmp(name, "/dev/", 5) == 0)
-		return devt_from_devname(name + 5, devt);
+		return devt_from_devname(name + 5, devt, ready);
 	return devt_from_devnum(name, devt);
 }
 
+int __init early_lookup_bdev(const char *name, dev_t *devt)
+{
+	return __early_lookup_bdev(name, devt, 0);
+}
+
+int __init early_lookup_ready_bdev(const char *name, dev_t *devt)
+{
+	return __early_lookup_bdev(name, devt, 1);
+}
+
 static char __init *bdevt_str(dev_t devt, char *buf)
 {
 	if (MAJOR(devt) <= 0xff && MINOR(devt) <= 0xff) {
diff --git a/drivers/md/dm-init.c b/drivers/md/dm-init.c
index 81b8bbd1b63a8..1adfeb4ff8ce3 100644
--- a/drivers/md/dm-init.c
+++ b/drivers/md/dm-init.c
@@ -301,7 +301,7 @@ static int __init dm_init_init(void)
 			dev_t dev;
 
 			DMINFO("waiting for device %s ...", waitfor[i]);
-			while (early_lookup_bdev(waitfor[i], &dev))
+			while (early_lookup_ready_bdev(waitfor[i], &dev))
 				fsleep(5000);
 		}
 	}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 50c3b959da281..f520540ad6a69 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1614,7 +1614,9 @@ int sync_blockdev_nowait(struct block_device *bdev);
 void sync_bdevs(bool wait);
 void bdev_statx(struct path *, struct kstat *, u32);
 void printk_all_partitions(void);
+int __init __early_lookup_bdev(const char *pathname, dev_t *dev, bool ready);
 int __init early_lookup_bdev(const char *pathname, dev_t *dev);
+int __init early_lookup_ready_bdev(const char *pathname, dev_t *dev);
 #else
 static inline void invalidate_bdev(struct block_device *bdev)
 {
-- 
2.17.1

