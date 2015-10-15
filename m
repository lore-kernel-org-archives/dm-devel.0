From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 03/12] block: Reduce the size of struct blk_integrity
Date: Thu, 15 Oct 2015 15:59:56 -0400
Message-ID: <20151015195956.20721.41442.stgit@dwillia2-desk3.jf.intel.com>
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

The per-device properties in the blk_integrity structure were previously
unsigned short. However, most of the values fit inside a char. The only
exception is the data interval size and we can work around that by
storing it as a power of two.

This cuts the size of the dynamic portion of blk_integrity in half.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/bio-integrity.c  |    4 ++--
 block/blk-integrity.c  |    6 +++---
 include/linux/blkdev.h |    8 ++++----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index a10ffe19a8dd..6a90eca9cea1 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -202,7 +202,7 @@ EXPORT_SYMBOL(bio_integrity_enabled);
 static inline unsigned int bio_integrity_intervals(struct blk_integrity *bi,
 						   unsigned int sectors)
 {
-	return sectors >> (ilog2(bi->interval) - 9);
+	return sectors >> (bi->interval_exp - 9);
 }
 
 static inline unsigned int bio_integrity_bytes(struct blk_integrity *bi,
@@ -229,7 +229,7 @@ static int bio_integrity_process(struct bio *bio,
 		bip->bip_vec->bv_offset;
 
 	iter.disk_name = bio->bi_bdev->bd_disk->disk_name;
-	iter.interval = bi->interval;
+	iter.interval = 1 << bi->interval_exp;
 	iter.seed = bip_get_seed(bip);
 	iter.prot_buf = prot_buf;
 
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index daf590ab3b46..c7508654faff 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -155,10 +155,10 @@ int blk_integrity_compare(struct gendisk *gd1, struct gendisk *gd2)
 	if (!b1 || !b2)
 		return -1;
 
-	if (b1->interval != b2->interval) {
+	if (b1->interval_exp != b2->interval_exp) {
 		pr_err("%s: %s/%s protection interval %u != %u\n",
 		       __func__, gd1->disk_name, gd2->disk_name,
-		       b1->interval, b2->interval);
+		       1 << b1->interval_exp, 1 << b2->interval_exp);
 		return -1;
 	}
 
@@ -440,7 +440,7 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 		kobject_uevent(&disk->integrity_kobj, KOBJ_ADD);
 
 		bi->flags |= BLK_INTEGRITY_VERIFY | BLK_INTEGRITY_GENERATE;
-		bi->interval = queue_logical_block_size(disk->queue);
+		bi->interval_exp = ilog2(queue_logical_block_size(disk->queue));
 		disk->integrity = bi;
 	} else
 		bi = disk->integrity;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f36c6476f1c7..4f1968f15e30 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1470,10 +1470,10 @@ struct blk_integrity_profile {
 
 struct blk_integrity {
 	struct blk_integrity_profile	*profile;
-	unsigned short			flags;
-	unsigned short			tuple_size;
-	unsigned short			interval;
-	unsigned short			tag_size;
+	unsigned char			flags;
+	unsigned char			tuple_size;
+	unsigned char			interval_exp;
+	unsigned char			tag_size;
 };
 
 extern bool blk_integrity_is_initialized(struct gendisk *);

