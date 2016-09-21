From: Wonhong Kwon <wonhong.kwon@lge.com>
Subject: [PATCH] dm: add swap_slot_free_notify handler
Date: Thu, 22 Sep 2016 08:09:46 +0900
Message-ID: <1474499386-27436-1-git-send-email-wonhong.kwon@lge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: wonhong.kwon@lge.com, gunho.lee@lge.com
List-Id: dm-devel.ids

swap_slot_free_notify callback has been added to block_device_operations to
allow freeing memory allocated by RAM-based swap device like zram or zswap
more aggressively.

In case of device mapper, it is also required if mapped target is being
used as swap device and it uses some in-memory metadata for swap entries.
This patch introduces swap_slot_free_notify callback into dm_blk_ops and
target device can implement its own handler to handle this via
slot_free_notify in target_type.

Signed-off-by: Wonhong Kwon <wonhong.kwon@lge.com>
---
 drivers/md/dm.c               | 19 +++++++++++++++++++
 include/linux/device-mapper.h |  3 +++
 2 files changed, 22 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index fa9b1cb..2749f95 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2720,6 +2720,24 @@ static const struct pr_ops dm_pr_ops = {
 	.pr_clear	= dm_pr_clear,
 };
 
+static void dm_blk_slot_free_notify(struct block_device *bdev,
+				    unsigned long index)
+{
+	int srcu_idx;
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	struct dm_table *map = dm_get_live_table(md, &srcu_idx);
+	struct dm_target *ti = dm_table_find_target(map, index);
+
+	if (!dm_target_is_valid(ti))
+		goto out;
+
+	if (ti->type->slot_free_notify)
+		ti->type->slot_free_notify(index);
+
+out:
+	dm_put_live_table(md, srcu_idx);
+}
+
 static const struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
@@ -2727,6 +2745,7 @@ static const struct block_device_operations dm_blk_dops = {
 	.direct_access = dm_blk_direct_access,
 	.getgeo = dm_blk_getgeo,
 	.pr_ops = &dm_pr_ops,
+	.swap_slot_free_notify = dm_blk_slot_free_notify,
 	.owner = THIS_MODULE
 };
 
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 91acfce..589fd9a 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -133,6 +133,8 @@ typedef int (*dm_busy_fn) (struct dm_target *ti);
 typedef long (*dm_direct_access_fn) (struct dm_target *ti, sector_t sector,
 				     void **kaddr, pfn_t *pfn, long size);
 
+typedef void (*dm_slot_free_notify_fn) (unsigned long index);
+
 void dm_error(const char *message);
 
 struct dm_dev {
@@ -180,6 +182,7 @@ struct target_type {
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
 	dm_direct_access_fn direct_access;
+	dm_slot_free_notify_fn slot_free_notify;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
-- 
1.9.1
