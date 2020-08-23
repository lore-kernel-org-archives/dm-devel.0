From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/3] nvme: don't call revalidate_disk from nvme_set_queue_dying
Date: Sun, 23 Aug 2020 11:10:43 +0200
Message-ID: <20200823091043.2600261-4-hch@lst.de>
References: <20200823091043.2600261-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200823091043.2600261-1-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Justin Sanders <justin@coraid.com>, Josef Bacik <josef@toxicpanda.com>, Xianting Tian <xianting_tian@126.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Stefan Haberland <sth@linux.ibm.com>, Jan Hoeppner <hoeppner@linux.ibm.com>, linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

In nvme_set_queue_dying we really just want to ensure the disk and bdev
sizes are set to zero.  Going through revalidate_disk leads to a somewhat
arcance and complex callchain relying on special behavior in a few
places.  Instead just lift the set_capacity directly to
nvme_set_queue_dying, and rename and move the nvme_mpath_update_disk_size
helper so that we can use it in nvme_set_queue_dying to propagate the
size to the bdev without detours.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/core.c | 33 +++++++++++++++++++++++----------
 drivers/nvme/host/nvme.h | 13 -------------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 88cff309d8e4f0..12dea15527f61a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -94,21 +94,34 @@ static void nvme_put_subsystem(struct nvme_subsystem *subsys);
 static void nvme_remove_invalid_namespaces(struct nvme_ctrl *ctrl,
 					   unsigned nsid);
 
+static void nvme_update_bdev_size(struct gendisk *disk)
+{
+	struct block_device *bdev = bdget_disk(disk, 0);
+
+	if (bdev) {
+		bd_set_nr_sectors(bdev, get_capacity(disk));
+		bdput(bdev);
+	}
+}
+
+/*
+ * Prepare a queue for teardown.
+ *
+ * This must forcibly unquiesce queues to avoid blocking dispatch, and only set
+ * the capacity to 0 after that to avoid blocking dispatchers that may be
+ * holding bd_butex.  This will end buffered writers dirtying pages that can't
+ * be synced.
+ */
 static void nvme_set_queue_dying(struct nvme_ns *ns)
 {
-	/*
-	 * Revalidating a dead namespace sets capacity to 0. This will end
-	 * buffered writers dirtying pages that can't be synced.
-	 */
 	if (test_and_set_bit(NVME_NS_DEAD, &ns->flags))
 		return;
+
 	blk_set_queue_dying(ns->queue);
-	/* Forcibly unquiesce queues to avoid blocking dispatch */
 	blk_mq_unquiesce_queue(ns->queue);
-	/*
-	 * Revalidate after unblocking dispatchers that may be holding bd_butex
-	 */
-	revalidate_disk(ns->disk);
+
+	set_capacity(ns->disk, 0);
+	nvme_update_bdev_size(ns->disk);
 }
 
 static void nvme_queue_scan(struct nvme_ctrl *ctrl)
@@ -2083,7 +2096,7 @@ static int __nvme_revalidate_disk(struct gendisk *disk, struct nvme_id_ns *id)
 		nvme_update_disk_info(ns->head->disk, ns, id);
 		blk_stack_limits(&ns->head->disk->queue->limits,
 				 &ns->queue->limits, 0);
-		nvme_mpath_update_disk_size(ns->head->disk);
+		nvme_update_bdev_size(ns->head->disk);
 	}
 #endif
 	return 0;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ae5cad5a08f411..4cadaea9034ae4 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -659,16 +659,6 @@ static inline void nvme_trace_bio_complete(struct request *req,
 		trace_block_bio_complete(ns->head->disk->queue, req->bio);
 }
 
-static inline void nvme_mpath_update_disk_size(struct gendisk *disk)
-{
-	struct block_device *bdev = bdget_disk(disk, 0);
-
-	if (bdev) {
-		bd_set_nr_sectors(bdev, get_capacity(disk));
-		bdput(bdev);
-	}
-}
-
 extern struct device_attribute dev_attr_ana_grpid;
 extern struct device_attribute dev_attr_ana_state;
 extern struct device_attribute subsys_attr_iopolicy;
@@ -744,9 +734,6 @@ static inline void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys)
 static inline void nvme_mpath_start_freeze(struct nvme_subsystem *subsys)
 {
 }
-static inline void nvme_mpath_update_disk_size(struct gendisk *disk)
-{
-}
 #endif /* CONFIG_NVME_MULTIPATH */
 
 #ifdef CONFIG_BLK_DEV_ZONED
-- 
2.28.0
