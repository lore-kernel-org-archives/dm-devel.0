From: Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH] block: get rid of blk_integrity_revalidate()
Date: Tue, 18 Apr 2017 18:43:20 +0200
Message-ID: <1492533800-30627-1-git-send-email-idryomov@gmail.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
Sender: ceph-devel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com, ceph-devel@vger.kernel.org
List-Id: dm-devel.ids

Commit 25520d55cdb6 ("block: Inline blk_integrity in struct gendisk")
introduced blk_integrity_revalidate(), which seems to assume ownership
of the stable pages flag and unilaterally clears it if no blk_integrity
profile is registered:

    if (bi->profile)
            disk->queue->backing_dev_info->capabilities |=
                    BDI_CAP_STABLE_WRITES;
    else
            disk->queue->backing_dev_info->capabilities &=
                    ~BDI_CAP_STABLE_WRITES;

It's called from revalidate_disk() and rescan_partitions(), making it
impossible to enable stable pages for drivers that support partitions
and don't use blk_integrity: while the call in revalidate_disk() can be
trivially worked around (see zram, which doesn't support partitions and
hence gets away with zram_revalidate_disk()), rescan_partitions() can
be triggered from userspace at any time.  This breaks rbd, where the
ceph messenger is responsible for generating/verifying CRCs.

Since blk_integrity_{un,}register() "must" be used for (un)registering
the integrity profile with the block layer, move BDI_CAP_STABLE_WRITES
setting there.  This way drivers that call blk_integrity_register() and
use integrity infrastructure won't interfere with drivers that don't
but still want stable pages.

Fixes: 25520d55cdb6 ("block: Inline blk_integrity in struct gendisk")
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org # 4.4+, needs backporting
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
I don't have any integrity-capable disks or nvme separate-metadata
cards, so I couldn't test this as well as I wanted to.  25520d55cdb6
went in with some nvme work, but Martin recalls that it may have had
something to do with integrity-capable dm arrays losing the integrity
capability at runtime.  Previous discussion at

    http://www.spinics.net/lists/ceph-devel/msg35413.html

---
 block/blk-integrity.c     | 19 ++-----------------
 block/partition-generic.c |  1 -
 fs/block_dev.c            |  1 -
 include/linux/genhd.h     |  2 --
 4 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 9f0ff5ba4f84..35c5af1ea068 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -417,7 +417,7 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 	bi->tuple_size = template->tuple_size;
 	bi->tag_size = template->tag_size;
 
-	blk_integrity_revalidate(disk);
+	disk->queue->backing_dev_info->capabilities |= BDI_CAP_STABLE_WRITES;
 }
 EXPORT_SYMBOL(blk_integrity_register);
 
@@ -430,26 +430,11 @@ EXPORT_SYMBOL(blk_integrity_register);
  */
 void blk_integrity_unregister(struct gendisk *disk)
 {
-	blk_integrity_revalidate(disk);
+	disk->queue->backing_dev_info->capabilities &= ~BDI_CAP_STABLE_WRITES;
 	memset(&disk->queue->integrity, 0, sizeof(struct blk_integrity));
 }
 EXPORT_SYMBOL(blk_integrity_unregister);
 
-void blk_integrity_revalidate(struct gendisk *disk)
-{
-	struct blk_integrity *bi = &disk->queue->integrity;
-
-	if (!(disk->flags & GENHD_FL_UP))
-		return;
-
-	if (bi->profile)
-		disk->queue->backing_dev_info->capabilities |=
-			BDI_CAP_STABLE_WRITES;
-	else
-		disk->queue->backing_dev_info->capabilities &=
-			~BDI_CAP_STABLE_WRITES;
-}
-
 void blk_integrity_add(struct gendisk *disk)
 {
 	if (kobject_init_and_add(&disk->integrity_kobj, &integrity_ktype,
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 7afb9907821f..0171a2faad68 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -497,7 +497,6 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
 
 	if (disk->fops->revalidate_disk)
 		disk->fops->revalidate_disk(disk);
-	blk_integrity_revalidate(disk);
 	check_disk_size_change(disk, bdev);
 	bdev->bd_invalidated = 0;
 	if (!get_capacity(disk) || !(state = check_partition(disk, bdev)))
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2eca00ec4370..56039dfbc674 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1451,7 +1451,6 @@ int revalidate_disk(struct gendisk *disk)
 
 	if (disk->fops->revalidate_disk)
 		ret = disk->fops->revalidate_disk(disk);
-	blk_integrity_revalidate(disk);
 	bdev = bdget_disk(disk, 0);
 	if (!bdev)
 		return ret;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 76f39754e7b0..76d6a1cd4153 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -722,11 +722,9 @@ static inline void part_nr_sects_write(struct hd_struct *part, sector_t size)
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 extern void blk_integrity_add(struct gendisk *);
 extern void blk_integrity_del(struct gendisk *);
-extern void blk_integrity_revalidate(struct gendisk *);
 #else	/* CONFIG_BLK_DEV_INTEGRITY */
 static inline void blk_integrity_add(struct gendisk *disk) { }
 static inline void blk_integrity_del(struct gendisk *disk) { }
-static inline void blk_integrity_revalidate(struct gendisk *disk) { }
 #endif	/* CONFIG_BLK_DEV_INTEGRITY */
 
 #else /* CONFIG_BLOCK */
-- 
2.4.3

