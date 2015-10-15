From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 10/12] block: move blk_integrity to request_queue
Date: Thu, 15 Oct 2015 16:00:34 -0400
Message-ID: <20151015200034.20721.23425.stgit@dwillia2-desk3.jf.intel.com>
References: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, axboe@fb.com, dm-devel@redhat.com, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de
List-Id: dm-devel.ids

A trace like the following proceeds a crash in bio_integrity_process()
when it goes to use an already freed blk_integrity profile.

 BUG: unable to handle kernel paging request at ffff8800d31b10d8
 IP: [<ffff8800d31b10d8>] 0xffff8800d31b10d8
 PGD 2f65067 PUD 21fffd067 PMD 80000000d30001e3
 Oops: 0011 [#1] SMP
 Dumping ftrace buffer:
 ---------------------------------
    ndctl-2222    2.... 44526245us : disk_release: pmem1s
 systemd--2223    4.... 44573945us : bio_integrity_endio: pmem1s
    <...>-409     4.... 44574005us : bio_integrity_process: pmem1s
 ---------------------------------
[..]
  Call Trace:
  [<ffffffff8144e0f9>] ? bio_integrity_process+0x159/0x2d0
  [<ffffffff8144e4f6>] bio_integrity_verify_fn+0x36/0x60
  [<ffffffff810bd2dc>] process_one_work+0x1cc/0x4e0

Given that a request_queue is pinned while i/o is in flight and that a
gendisk is allowed to have a shorter lifetime, move blk_integrity to
request_queue to satisfy requests arriving after the gendisk has been
torn down.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
[martin: fix the CONFIG_BLK_DEV_INTEGRITY=n case]
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ABI/testing/sysfs-block |   12 +++---
 block/blk-integrity.c                 |   63 +++++++++++++++++----------------
 block/blk-sysfs.c                     |    4 ++
 block/genhd.c                         |    2 -
 block/partition-generic.c             |    2 +
 drivers/md/dm-table.c                 |    4 +-
 drivers/md/md.c                       |    4 +-
 drivers/nvdimm/core.c                 |    2 +
 drivers/nvme/host/pci.c               |    8 +++-
 drivers/scsi/sd_dif.c                 |    2 +
 fs/block_dev.c                        |    2 +
 include/linux/blkdev.h                |   16 ++++++--
 include/linux/genhd.h                 |   16 +++-----
 13 files changed, 72 insertions(+), 65 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 71d184dbb70d..9d3c9aa67d67 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -28,7 +28,7 @@ Description:
 		format.
 
 
-What:		/sys/block/<disk>/integrity/format
+What:		/sys/block/<disk>/queue/integrity/format
 Date:		June 2008
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
 Description:
@@ -36,7 +36,7 @@ Description:
 		E.g. T10-DIF-TYPE1-CRC.
 
 
-What:		/sys/block/<disk>/integrity/read_verify
+What:		/sys/block/<disk>/queue/integrity/read_verify
 Date:		June 2008
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
 Description:
@@ -45,7 +45,7 @@ Description:
 		support sending integrity metadata.
 
 
-What:		/sys/block/<disk>/integrity/tag_size
+What:		/sys/block/<disk>/queue/integrity/tag_size
 Date:		June 2008
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
 Description:
@@ -53,14 +53,14 @@ Description:
 		512 bytes of data.
 
 
-What:		/sys/block/<disk>/integrity/device_is_integrity_capable
+What:		/sys/block/<disk>/queue/integrity/device_is_integrity_capable
 Date:		July 2014
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
 Description:
 		Indicates whether a storage device is capable of storing
 		integrity metadata. Set if the device is T10 PI-capable.
 
-What:		/sys/block/<disk>/integrity/protection_interval_bytes
+What:		/sys/block/<disk>/queue/integrity/protection_interval_bytes
 Date:		July 2015
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
 Description:
@@ -68,7 +68,7 @@ Description:
 		by one integrity tuple. Typically the device's logical
 		block size.
 
-What:		/sys/block/<disk>/integrity/write_generate
+What:		/sys/block/<disk>/queue/integrity/write_generate
 Date:		June 2008
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
 Description:
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 4615a3386798..dc4dea7b8a93 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -142,8 +142,8 @@ EXPORT_SYMBOL(blk_rq_map_integrity_sg);
  */
 int blk_integrity_compare(struct gendisk *gd1, struct gendisk *gd2)
 {
-	struct blk_integrity *b1 = &gd1->integrity;
-	struct blk_integrity *b2 = &gd2->integrity;
+	struct blk_integrity *b1 = blk_get_integrity(gd1);
+	struct blk_integrity *b2 = blk_get_integrity(gd2);
 
 	if (!b1->profile && !b2->profile)
 		return 0;
@@ -245,8 +245,8 @@ struct integrity_sysfs_entry {
 static ssize_t integrity_attr_show(struct kobject *kobj, struct attribute *attr,
 				   char *page)
 {
-	struct gendisk *disk = container_of(kobj, struct gendisk, integrity_kobj);
-	struct blk_integrity *bi = &disk->integrity;
+	struct request_queue *q = container_of(kobj, struct request_queue, integrity_kobj);
+	struct blk_integrity *bi = &q->integrity;
 	struct integrity_sysfs_entry *entry =
 		container_of(attr, struct integrity_sysfs_entry, attr);
 
@@ -257,8 +257,8 @@ static ssize_t integrity_attr_store(struct kobject *kobj,
 				    struct attribute *attr, const char *page,
 				    size_t count)
 {
-	struct gendisk *disk = container_of(kobj, struct gendisk, integrity_kobj);
-	struct blk_integrity *bi = &disk->integrity;
+	struct request_queue *q = container_of(kobj, struct request_queue, integrity_kobj);
+	struct blk_integrity *bi = &q->integrity;
 	struct integrity_sysfs_entry *entry =
 		container_of(attr, struct integrity_sysfs_entry, attr);
 	ssize_t ret = 0;
@@ -385,8 +385,8 @@ static struct kobj_type integrity_ktype = {
 };
 
 /**
- * blk_integrity_register - Register a gendisk as being integrity-capable
- * @disk:	struct gendisk pointer to make integrity-aware
+ * blk_integrity_register - Register a request_queue as being integrity-capable
+ * @disk:	struct request_queue pointer to make integrity-aware
  * @template:	block integrity profile to register
  *
  * Description: When a device needs to advertise itself as being able to
@@ -395,62 +395,63 @@ static struct kobj_type integrity_ktype = {
  * struct with values appropriate for the underlying hardware. See
  * Documentation/block/data-integrity.txt.
  */
-void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
+void blk_integrity_register(struct request_queue *q, struct blk_integrity *template)
 {
-	struct blk_integrity *bi = &disk->integrity;
+	struct blk_integrity *bi = &q->integrity;
 
 	bi->flags = BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE |
 		template->flags;
-	bi->interval_exp = ilog2(queue_logical_block_size(disk->queue));
+	bi->interval_exp = ilog2(queue_logical_block_size(q));
 	bi->profile = template->profile;
 	bi->tuple_size = template->tuple_size;
 	bi->tag_size = template->tag_size;
 
-	blk_integrity_revalidate(disk);
+	blk_integrity_revalidate(q);
 }
 EXPORT_SYMBOL(blk_integrity_register);
 
 /**
  * blk_integrity_unregister - Unregister block integrity profile
- * @disk:	disk whose integrity profile to unregister
+ * @disk:	queue whose integrity profile to unregister
  *
  * Description: This function unregisters the integrity capability from
  * a block device.
  */
-void blk_integrity_unregister(struct gendisk *disk)
+void blk_integrity_unregister(struct request_queue *q)
 {
-	blk_integrity_revalidate(disk);
-	memset(&disk->integrity, 0, sizeof(struct blk_integrity));
+	blk_integrity_revalidate(q);
+	memset(&q->integrity, 0, sizeof(struct blk_integrity));
 }
 EXPORT_SYMBOL(blk_integrity_unregister);
 
-void blk_integrity_revalidate(struct gendisk *disk)
+void blk_integrity_revalidate(struct request_queue *q)
 {
-	struct blk_integrity *bi = &disk->integrity;
+	struct blk_integrity *bi = &q->integrity;
+	int rc;
 
-	if (!(disk->flags & GENHD_FL_UP))
+	rc = blk_queue_enter(q, GFP_NOWAIT);
+	if (rc)
 		return;
 
 	if (bi->profile)
-		disk->queue->backing_dev_info.capabilities |=
-			BDI_CAP_STABLE_WRITES;
+		q->backing_dev_info.capabilities |= BDI_CAP_STABLE_WRITES;
 	else
-		disk->queue->backing_dev_info.capabilities &=
-			~BDI_CAP_STABLE_WRITES;
+		q->backing_dev_info.capabilities &= ~BDI_CAP_STABLE_WRITES;
+	blk_queue_exit(q);
 }
 
-void blk_integrity_add(struct gendisk *disk)
+void blk_integrity_add(struct request_queue *q)
 {
-	if (kobject_init_and_add(&disk->integrity_kobj, &integrity_ktype,
-				 &disk_to_dev(disk)->kobj, "%s", "integrity"))
+	if (kobject_init_and_add(&q->integrity_kobj, &integrity_ktype,
+				&q->kobj, "%s", "integrity"))
 		return;
 
-	kobject_uevent(&disk->integrity_kobj, KOBJ_ADD);
+	kobject_uevent(&q->integrity_kobj, KOBJ_ADD);
 }
 
-void blk_integrity_del(struct gendisk *disk)
+void blk_integrity_del(struct request_queue *q)
 {
-	kobject_uevent(&disk->integrity_kobj, KOBJ_REMOVE);
-	kobject_del(&disk->integrity_kobj);
-	kobject_put(&disk->integrity_kobj);
+	kobject_uevent(&q->integrity_kobj, KOBJ_REMOVE);
+	kobject_del(&q->integrity_kobj);
+	kobject_put(&q->integrity_kobj);
 }
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 61fc2633bbea..ea8b84d35a53 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -613,6 +613,8 @@ int blk_register_queue(struct gendisk *disk)
 		return ret;
 	}
 
+	blk_integrity_add(q);
+
 	kobject_uevent(&q->kobj, KOBJ_ADD);
 
 	if (q->mq_ops)
@@ -623,6 +625,7 @@ int blk_register_queue(struct gendisk *disk)
 
 	ret = elv_register_queue(q);
 	if (ret) {
+		blk_integrity_del(q);
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
 		kobject_del(&q->kobj);
 		blk_trace_remove_sysfs(dev);
@@ -646,6 +649,7 @@ void blk_unregister_queue(struct gendisk *disk)
 	if (q->request_fn)
 		elv_unregister_queue(q);
 
+	blk_integrity_del(q);
 	kobject_uevent(&q->kobj, KOBJ_REMOVE);
 	kobject_del(&q->kobj);
 	blk_trace_remove_sysfs(disk_to_dev(disk));
diff --git a/block/genhd.c b/block/genhd.c
index e5cafa51567c..0c706f33a599 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -630,7 +630,6 @@ void add_disk(struct gendisk *disk)
 	WARN_ON(retval);
 
 	disk_add_events(disk);
-	blk_integrity_add(disk);
 }
 EXPORT_SYMBOL(add_disk);
 
@@ -639,7 +638,6 @@ void del_gendisk(struct gendisk *disk)
 	struct disk_part_iter piter;
 	struct hd_struct *part;
 
-	blk_integrity_del(disk);
 	disk_del_events(disk);
 
 	/* invalidate stuff */
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 3b030157ec85..47ad1953e365 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -428,7 +428,7 @@ rescan:
 
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
-	blk_integrity_revalidate(disk);
+	blk_integrity_revalidate(disk->queue);
 	check_disk_size_change(disk, bdev);
 	bdev->bd_invalidated = 0;
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 061152a43730..cd074c4df85e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1075,7 +1075,7 @@ static int dm_table_register_integrity(struct dm_table *t)
 		 * Register integrity profile during table load; we can do
 		 * this because the final profile must match during resume.
 		 */
-		blk_integrity_register(dm_disk(md),
+		blk_integrity_register(dm_disk(md)->queue,
 				       blk_get_integrity(template_disk));
 		return 0;
 	}
@@ -1305,7 +1305,7 @@ static void dm_table_verify_integrity(struct dm_table *t)
 	if (integrity_profile_exists(dm_disk(t->md))) {
 		DMWARN("%s: unable to establish an integrity profile",
 		       dm_device_name(t->md));
-		blk_integrity_unregister(dm_disk(t->md));
+		blk_integrity_unregister(dm_disk(t->md)->queue);
 	}
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 714aa92db174..4feff233d453 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1962,7 +1962,7 @@ int md_integrity_register(struct mddev *mddev)
 	 * All component devices are integrity capable and have matching
 	 * profiles, register the common profile for the md device.
 	 */
-	blk_integrity_register(mddev->gendisk,
+	blk_integrity_register(mddev->gendisk->queue,
 			       bdev_get_integrity(reference->bdev));
 
 	printk(KERN_NOTICE "md: data integrity enabled on %s\n", mdname(mddev));
@@ -1996,7 +1996,7 @@ void md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
 		return;
 	WARN_ON_ONCE(!mddev->suspended);
 	printk(KERN_NOTICE "disabling data integrity on %s\n", mdname(mddev));
-	blk_integrity_unregister(mddev->gendisk);
+	blk_integrity_unregister(mddev->gendisk->queue);
 }
 EXPORT_SYMBOL(md_integrity_add_rdev);
 
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index e85848caf8d2..eeedd58bbcad 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -413,7 +413,7 @@ int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
 	bi.tuple_size = meta_size;
 	bi.tag_size = meta_size;
 
-	blk_integrity_register(disk, &bi);
+	blk_integrity_register(disk->queue, &bi);
 	blk_queue_max_integrity_segments(disk->queue, 1);
 
 	return 0;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5578de67f406..e4a0cc7fb421 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -521,6 +521,7 @@ static void nvme_dif_remap(struct request *req,
 {
 	struct nvme_ns *ns = req->rq_disk->private_data;
 	struct bio_integrity_payload *bip;
+	struct blk_integrity *bi;
 	struct t10_pi_tuple *pi;
 	void *p, *pmap;
 	u32 i, nlb, ts, phys, virt;
@@ -538,7 +539,8 @@ static void nvme_dif_remap(struct request *req,
 	virt = bip_get_seed(bip);
 	phys = nvme_block_nr(ns, blk_rq_pos(req));
 	nlb = (blk_rq_bytes(req) >> ns->lba_shift);
-	ts = ns->disk->integrity.tuple_size;
+	bi = blk_get_integrity(ns->disk);
+	ts = bi->tuple_size;
 
 	for (i = 0; i < nlb; i++, virt++, phys++) {
 		pi = (struct t10_pi_tuple *)p;
@@ -581,7 +583,7 @@ static void nvme_init_integrity(struct nvme_ns *ns)
 		break;
 	}
 	integrity.tuple_size = ns->ms;
-	blk_integrity_register(ns->disk, &integrity);
+	blk_integrity_register(ns->disk->queue, &integrity);
 	blk_queue_max_integrity_segments(ns->queue, 1);
 }
 #else /* CONFIG_BLK_DEV_INTEGRITY */
@@ -2038,7 +2040,7 @@ static int nvme_revalidate_disk(struct gendisk *disk)
 				ns->ms != old_ms ||
 				bs != queue_logical_block_size(disk->queue) ||
 				(ns->ms && ns->ext)))
-		blk_integrity_unregister(disk);
+		blk_integrity_unregister(disk->queue);
 
 	ns->pi_type = pi_type;
 	blk_queue_logical_block_size(ns->queue, bs);
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 5a5ec9aa26b3..60ba4d9def6c 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -90,7 +90,7 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 	}
 
 out:
-	blk_integrity_register(disk, &bi);
+	blk_integrity_register(disk->queue, &bi);
 }
 
 /*
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 0a793c7930eb..e3528c8c48ae 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1075,7 +1075,7 @@ int revalidate_disk(struct gendisk *disk)
 
 	if (disk->fops->revalidate_disk)
 		ret = disk->fops->revalidate_disk(disk);
-	blk_integrity_revalidate(disk);
+	blk_integrity_revalidate(disk->queue);
 	bdev = bdget_disk(disk, 0);
 	if (!bdev)
 		return ret;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3e0465257d68..5f55b1f4215e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -369,6 +369,11 @@ struct request_queue {
 	 */
 	struct kobject mq_kobj;
 
+#ifdef  CONFIG_BLK_DEV_INTEGRITY
+	struct blk_integrity integrity;
+	struct kobject integrity_kobj;
+#endif	/* CONFIG_BLK_DEV_INTEGRITY */
+
 #ifdef CONFIG_PM
 	struct device		*dev;
 	int			rpm_status;
@@ -1468,8 +1473,8 @@ struct blk_integrity_profile {
 	const char			*name;
 };
 
-extern void blk_integrity_register(struct gendisk *, struct blk_integrity *);
-extern void blk_integrity_unregister(struct gendisk *);
+extern void blk_integrity_register(struct request_queue *, struct blk_integrity *);
+extern void blk_integrity_unregister(struct request_queue *);
 extern int blk_integrity_compare(struct gendisk *, struct gendisk *);
 extern int blk_rq_map_integrity_sg(struct request_queue *, struct bio *,
 				   struct scatterlist *);
@@ -1481,7 +1486,7 @@ extern bool blk_integrity_merge_bio(struct request_queue *, struct request *,
 
 static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
 {
-	struct blk_integrity *bi = &disk->integrity;
+	struct blk_integrity *bi = &disk->queue->integrity;
 
 	if (!bi->profile)
 		return NULL;
@@ -1537,6 +1542,7 @@ static inline bool integrity_req_gap_front_merge(struct request *req,
 struct bio;
 struct block_device;
 struct gendisk;
+struct request_queue;
 struct blk_integrity;
 
 static inline int blk_integrity_rq(struct request *rq)
@@ -1566,11 +1572,11 @@ static inline int blk_integrity_compare(struct gendisk *a, struct gendisk *b)
 {
 	return 0;
 }
-static inline void blk_integrity_register(struct gendisk *d,
+static inline void blk_integrity_register(struct request_queue *q,
 					 struct blk_integrity *b)
 {
 }
-static inline void blk_integrity_unregister(struct gendisk *d)
+static inline void blk_integrity_unregister(struct request_queue *q)
 {
 }
 static inline void blk_queue_max_integrity_segments(struct request_queue *q,
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 82f4911e0ad8..f842a85c71a0 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -209,10 +209,6 @@ struct gendisk {
 	struct timer_rand_state *random;
 	atomic_t sync_io;		/* RAID */
 	struct disk_events *ev;
-#ifdef  CONFIG_BLK_DEV_INTEGRITY
-	struct blk_integrity integrity;
-	struct kobject integrity_kobj;
-#endif	/* CONFIG_BLK_DEV_INTEGRITY */
 	int node_id;
 };
 
@@ -741,13 +737,13 @@ static inline void part_nr_sects_write(struct hd_struct *part, sector_t size)
 }
 
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
-extern void blk_integrity_add(struct gendisk *);
-extern void blk_integrity_del(struct gendisk *);
-extern void blk_integrity_revalidate(struct gendisk *);
+extern void blk_integrity_add(struct request_queue *);
+extern void blk_integrity_del(struct request_queue *);
+extern void blk_integrity_revalidate(struct request_queue *);
 #else	/* CONFIG_BLK_DEV_INTEGRITY */
-static inline void blk_integrity_add(struct gendisk *disk) { }
-static inline void blk_integrity_del(struct gendisk *disk) { }
-static inline void blk_integrity_revalidate(struct gendisk *disk) { }
+static inline void blk_integrity_add(struct request_queue *q) { }
+static inline void blk_integrity_del(struct request_queue *q) { }
+static inline void blk_integrity_revalidate(struct request_queue *q) { }
 #endif	/* CONFIG_BLK_DEV_INTEGRITY */
 
 #else /* CONFIG_BLOCK */

