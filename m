From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 01/12] block: Move integrity kobject to struct gendisk
Date: Thu, 15 Oct 2015 15:59:45 -0400
Message-ID: <20151015195945.20721.41097.stgit@dwillia2-desk3.jf.intel.com>
References: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151015195939.20721.23101.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: axboe@fb.com, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, Sagi Grimberg <sagig@mellanox.com>, dm-devel@redhat.com, Ross Zwisler <ross.zwisler@linux.intel.com>, hch@lst.de
List-Id: dm-devel.ids

From: Martin K. Petersen <martin.petersen@oracle.com>

The integrity kobject purely exists to support the integrity
subdirectory in sysfs and doesn't really have anything to do with the
blk_integrity data structure. Move the kobject to struct gendisk where
it belongs.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/blk-integrity.c  |   22 +++++++++++-----------
 include/linux/blkdev.h |    2 --
 include/linux/genhd.h  |    1 +
 3 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 75f29cf70188..182bfd2383ea 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -249,8 +249,8 @@ struct integrity_sysfs_entry {
 static ssize_t integrity_attr_show(struct kobject *kobj, struct attribute *attr,
 				   char *page)
 {
-	struct blk_integrity *bi =
-		container_of(kobj, struct blk_integrity, kobj);
+	struct gendisk *disk = container_of(kobj, struct gendisk, integrity_kobj);
+	struct blk_integrity *bi = blk_get_integrity(disk);
 	struct integrity_sysfs_entry *entry =
 		container_of(attr, struct integrity_sysfs_entry, attr);
 
@@ -261,8 +261,8 @@ static ssize_t integrity_attr_store(struct kobject *kobj,
 				    struct attribute *attr, const char *page,
 				    size_t count)
 {
-	struct blk_integrity *bi =
-		container_of(kobj, struct blk_integrity, kobj);
+	struct gendisk *disk = container_of(kobj, struct gendisk, integrity_kobj);
+	struct blk_integrity *bi = blk_get_integrity(disk);
 	struct integrity_sysfs_entry *entry =
 		container_of(attr, struct integrity_sysfs_entry, attr);
 	ssize_t ret = 0;
@@ -385,8 +385,8 @@ subsys_initcall(blk_dev_integrity_init);
 
 static void blk_integrity_release(struct kobject *kobj)
 {
-	struct blk_integrity *bi =
-		container_of(kobj, struct blk_integrity, kobj);
+	struct gendisk *disk = container_of(kobj, struct gendisk, integrity_kobj);
+	struct blk_integrity *bi = blk_get_integrity(disk);
 
 	kmem_cache_free(integrity_cachep, bi);
 }
@@ -429,14 +429,14 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 		if (!bi)
 			return -1;
 
-		if (kobject_init_and_add(&bi->kobj, &integrity_ktype,
+		if (kobject_init_and_add(&disk->integrity_kobj, &integrity_ktype,
 					 &disk_to_dev(disk)->kobj,
 					 "%s", "integrity")) {
 			kmem_cache_free(integrity_cachep, bi);
 			return -1;
 		}
 
-		kobject_uevent(&bi->kobj, KOBJ_ADD);
+		kobject_uevent(&disk->integrity_kobj, KOBJ_ADD);
 
 		bi->flags |= BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE;
 		bi->interval = queue_logical_block_size(disk->queue);
@@ -479,9 +479,9 @@ void blk_integrity_unregister(struct gendisk *disk)
 
 	bi = disk->integrity;
 
-	kobject_uevent(&bi->kobj, KOBJ_REMOVE);
-	kobject_del(&bi->kobj);
-	kobject_put(&bi->kobj);
+	kobject_uevent(&disk->integrity_kobj, KOBJ_REMOVE);
+	kobject_del(&disk->integrity_kobj);
+	kobject_put(&disk->integrity_kobj);
 	disk->integrity = NULL;
 }
 EXPORT_SYMBOL(blk_integrity_unregister);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 19c2e947d4d1..830f9c07d4bb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1472,8 +1472,6 @@ struct blk_integrity {
 	unsigned short		tag_size;
 
 	const char		*name;
-
-	struct kobject		kobj;
 };
 
 extern bool blk_integrity_is_initialized(struct gendisk *);
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 2adbfa6d02bc..9e6e0dfa97ad 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -199,6 +199,7 @@ struct gendisk {
 	struct disk_events *ev;
 #ifdef  CONFIG_BLK_DEV_INTEGRITY
 	struct blk_integrity *integrity;
+	struct kobject integrity_kobj;
 #endif
 	int node_id;
 };

