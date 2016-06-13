From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 3/6] dm: Add dm_blk_direct_access() for mapped device
Date: Mon, 13 Jun 2016 16:21:34 -0600
Message-ID: <1465856497-19698-4-git-send-email-toshi.kani@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-raid-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, viro@zeniv.linux.org.uk, axboe@kernel.dk, toshi.kani@hpe.com, linux-nvdimm@lists.01.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Change mapped device to implement direct_access function,
dm_blk_direct_access(), which calls a target direct_access
function.  'struct target_type' is extended to have target
direct_access interface.  This function limits direct
accessible size to the dm_target's limit with max_io_len().

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm.c               |   29 +++++++++++++++++++++++++++++
 include/linux/device-mapper.h |   10 ++++++++++
 2 files changed, 39 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1b2f962..6e9f958 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1473,6 +1473,34 @@ int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
 }
 EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
 
+static long dm_blk_direct_access(struct block_device *bdev, sector_t sector,
+	void __pmem **kaddr, pfn_t *pfn, long size)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	struct dm_table *map;
+	struct dm_target *ti;
+	int srcu_idx;
+	long len, ret = -EIO;
+
+	map = dm_get_live_table(md, &srcu_idx);
+	if (!map)
+		return ret;
+
+	ti = dm_table_find_target(map, sector);
+	if (!dm_target_is_valid(ti))
+		goto out;
+
+	len = max_io_len(sector, ti) << SECTOR_SHIFT;
+	size = min(len, size);
+
+	if (ti->type->direct_access)
+		ret = ti->type->direct_access(ti, sector, kaddr, pfn, size);
+
+out:
+	dm_put_live_table(md, srcu_idx);
+	return min(ret, size);
+}
+
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
  * allowed for all bio types except REQ_FLUSH.
@@ -3721,6 +3749,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
 	.ioctl = dm_blk_ioctl,
+	.direct_access = dm_blk_direct_access,
 	.getgeo = dm_blk_getgeo,
 	.pr_ops = &dm_pr_ops,
 	.owner = THIS_MODULE
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 0830c9e..16e6c8c 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -116,6 +116,15 @@ typedef void (*dm_io_hints_fn) (struct dm_target *ti,
  */
 typedef int (*dm_busy_fn) (struct dm_target *ti);
 
+/*
+ * Returns:
+ *  < 0 : error
+ * >= 0 : the number of bytes accessible at the address
+ */
+typedef long (*dm_direct_access_fn) (struct dm_target *ti, sector_t sector,
+				     void __pmem **kaddr, pfn_t *pfn,
+				     long size);
+
 void dm_error(const char *message);
 
 struct dm_dev {
@@ -162,6 +171,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_direct_access_fn direct_access;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
