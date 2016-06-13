From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 4/6] dm-linear: Add linear_direct_access()
Date: Mon, 13 Jun 2016 16:21:35 -0600
Message-ID: <1465856497-19698-5-git-send-email-toshi.kani@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, viro@zeniv.linux.org.uk, axboe@kernel.dk, toshi.kani@hpe.com, linux-nvdimm@lists.01.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Change dm-linear to implement direct_access function,
linear_direct_access(), which maps sector and calls
direct_access function of its target device.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-linear.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 05c35aa..49bd7d2 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -141,6 +141,22 @@ static int linear_iterate_devices(struct dm_target *ti,
 	return fn(ti, lc->dev, lc->start, ti->len, data);
 }
 
+static long linear_direct_access(struct dm_target *ti, sector_t sector,
+		void __pmem **kaddr, pfn_t *pfn, long size)
+{
+	struct linear_c *lc;
+	struct block_device *tbdev;
+	const struct block_device_operations *tops;
+	sector_t tsector;
+
+	lc = ti->private;
+	tbdev = lc->dev->bdev;
+	tops = tbdev->bd_disk->fops;
+	tsector = linear_map_sector(ti, sector);
+
+	return tops->direct_access(tbdev, tsector, kaddr, pfn, size);
+}
+
 static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 2, 1},
@@ -151,6 +167,7 @@ static struct target_type linear_target = {
 	.status = linear_status,
 	.prepare_ioctl = linear_prepare_ioctl,
 	.iterate_devices = linear_iterate_devices,
+	.direct_access = linear_direct_access,
 };
 
 int __init dm_linear_init(void)
