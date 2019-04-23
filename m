From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH] dm mpath: fix miss calling of path selector
	type->end_io
Date: Tue, 23 Apr 2019 22:46:01 +0800
Message-ID: <20190423144601.51453-1-yuyufen@huawei.com>
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
To: snitzer@redhat.com, dm-devel@redhat.com
Cc: yi.zhang@huawei.com, houtao1@huawei.com, yuyufen@huawei.com, ming.lei@redhat.com
List-Id: dm-devel.ids

After commit 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via
blk_insert_cloned_request feedback"), map_request() will requeue the tio
when issued clone request return BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE.

Thus, if device drive status is error, a tio may be requeued multiple times
until the return value is not DM_MAPIO_REQUEUE. That means type->start_io
may be called multiple tims, while type->end_io just be called when IO complete.

In fact, even without the commit, setup_clone() error also can make the
tio requeue and miss call type->end_io.

For service time path selector, it selects path based on in_flight_size,
which is increased by st_start_io() and decreased by st_end_io().
Missing call of end_io can lead to in_flight_size error and let the
selector make the wrong choice, even it will not choose one path forever.

This patch fixes the bug by adding a new interface end_stat() in target_type.
When map_request() return DM_MAPIO_REQUEUE, we call dm_end_stat() to
decrease the counter.

Initially, we attempt to avoid repeated calling for ->start_io by adding
a flag 'started' in mpio. We just call ->start_io when the flag is not
set and then set the flag after the call. It will be cleared after calling
->end_io. However, we have not find a suitable location to initialize mpio
(map_info->ptr) and clear the flag. dm_mq_init_request() looks like a
reasonable location to clear the flag by memset 0 for the region of
struct dm_mpath_io. But, we can not get the size of the region at that localtion.

Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hou Tao <houtao1@huawei.com>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/dm-mpath.c         | 14 ++++++++++++++
 drivers/md/dm-rq.c            |  8 ++++++++
 include/linux/device-mapper.h |  3 +++
 3 files changed, 25 insertions(+)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 2ee5e357a0a7..f1da094a1fa9 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -2006,6 +2006,19 @@ static int multipath_busy(struct dm_target *ti)
 	return busy;
 }
 
+static void multipath_end_stat(union map_info *map_context)
+{
+	struct dm_mpath_io *mpio = get_mpio(map_context);
+	struct pgpath *pgpath = mpio->pgpath;
+
+	if (pgpath) {
+		struct path_selector *ps = &pgpath->pg->ps;
+
+		if (ps->type->end_io)
+			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+	}
+}
+
 /*-----------------------------------------------------------------
  * Module setup
  *---------------------------------------------------------------*/
@@ -2030,6 +2043,7 @@ static struct target_type multipath_target = {
 	.prepare_ioctl = multipath_prepare_ioctl,
 	.iterate_devices = multipath_iterate_devices,
 	.busy = multipath_busy,
+	.end_stat = multipath_end_stat,
 };
 
 static int __init dm_multipath_init(void)
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index b66745bd08bb..fe8fd9af5de8 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -487,6 +487,13 @@ static int dm_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
 	return 0;
 }
 
+static void dm_end_stat(struct dm_rq_target_io *tio)
+{
+	if (tio->ti && tio->ti->type->end_stat) {
+		tio->ti->type->end_stat(&tio->info);
+	}
+}
+
 static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 			  const struct blk_mq_queue_data *bd)
 {
@@ -520,6 +527,7 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (map_request(tio) == DM_MAPIO_REQUEUE) {
 		/* Undo dm_start_request() before requeuing */
 		rq_end_stats(md, rq);
+		dm_end_stat(tio);
 		rq_completed(md);
 		return BLK_STS_RESOURCE;
 	}
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index b0672756d056..0a61a5769fbb 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -97,6 +97,8 @@ typedef int (*dm_report_zones_fn) (struct dm_target *ti, sector_t sector,
 				   unsigned int *nr_zones,
 				   gfp_t gfp_mask);
 
+typedef void (*dm_end_stat_fn) (union map_info *map_context);
+
 /*
  * These iteration functions are typically used to check (and combine)
  * properties of underlying devices.
@@ -194,6 +196,7 @@ struct target_type {
 	dm_dax_direct_access_fn direct_access;
 	dm_dax_copy_iter_fn dax_copy_from_iter;
 	dm_dax_copy_iter_fn dax_copy_to_iter;
+	dm_end_stat_fn end_stat;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
-- 
2.16.2.dirty
