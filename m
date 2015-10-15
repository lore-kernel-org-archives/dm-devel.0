From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 02/12] block: Consolidate static integrity profile
 properties
Date: Thu, 15 Oct 2015 15:59:50 -0400
Message-ID: <20151015195950.20721.49373.stgit@dwillia2-desk3.jf.intel.com>
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

We previously made a complete copy of a device's data integrity profile
even though several of the fields inside the blk_integrity struct are
pointers to fixed template entries in t10-pi.c.

Split the static and per-device portions so that we can reference the
template directly.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Reported-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
[djbw: make nvdimm profile static]
Tested-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 block/bio-integrity.c               |    8 ++++----
 block/blk-integrity.c               |   17 ++++++++---------
 block/t10-pi.c                      |   16 ++++------------
 drivers/nvdimm/core.c               |   11 +++++++----
 drivers/nvme/host/pci.c             |    8 ++++----
 drivers/scsi/sd_dif.c               |   29 ++++++++++++++++-------------
 drivers/target/target_core_iblock.c |   10 +++++-----
 include/linux/blkdev.h              |   20 +++++++++++---------
 include/linux/t10-pi.h              |    8 ++++----
 9 files changed, 63 insertions(+), 64 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 14b8faf8b09d..a10ffe19a8dd 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -177,11 +177,11 @@ bool bio_integrity_enabled(struct bio *bio)
 	if (bi == NULL)
 		return false;
 
-	if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
+	if (bio_data_dir(bio) == READ && bi->profile->verify_fn != NULL &&
 	    (bi->flags & BLK_INTEGRITY_VERIFY))
 		return true;
 
-	if (bio_data_dir(bio) == WRITE && bi->generate_fn != NULL &&
+	if (bio_data_dir(bio) == WRITE && bi->profile->generate_fn != NULL &&
 	    (bi->flags & BLK_INTEGRITY_GENERATE))
 		return true;
 
@@ -340,7 +340,7 @@ int bio_integrity_prep(struct bio *bio)
 
 	/* Auto-generate integrity metadata if this is a write */
 	if (bio_data_dir(bio) == WRITE)
-		bio_integrity_process(bio, bi->generate_fn);
+		bio_integrity_process(bio, bi->profile->generate_fn);
 
 	return 0;
 }
@@ -361,7 +361,7 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 	struct bio *bio = bip->bip_bio;
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
 
-	bio->bi_error = bio_integrity_process(bio, bi->verify_fn);
+	bio->bi_error = bio_integrity_process(bio, bi->profile->verify_fn);
 
 	/* Restore original bio completion handler */
 	bio->bi_end_io = bip->bip_end_io;
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 182bfd2383ea..daf590ab3b46 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -176,10 +176,10 @@ int blk_integrity_compare(struct gendisk *gd1, struct gendisk *gd2)
 		return -1;
 	}
 
-	if (strcmp(b1->name, b2->name)) {
+	if (b1->profile != b2->profile) {
 		printk(KERN_ERR "%s: %s/%s type %s != %s\n", __func__,
 		       gd1->disk_name, gd2->disk_name,
-		       b1->name, b2->name);
+		       b1->profile->name, b2->profile->name);
 		return -1;
 	}
 
@@ -275,8 +275,8 @@ static ssize_t integrity_attr_store(struct kobject *kobj,
 
 static ssize_t integrity_format_show(struct blk_integrity *bi, char *page)
 {
-	if (bi != NULL && bi->name != NULL)
-		return sprintf(page, "%s\n", bi->name);
+	if (bi != NULL && bi->profile->name != NULL)
+		return sprintf(page, "%s\n", bi->profile->name);
 	else
 		return sprintf(page, "none\n");
 }
@@ -401,7 +401,8 @@ bool blk_integrity_is_initialized(struct gendisk *disk)
 {
 	struct blk_integrity *bi = blk_get_integrity(disk);
 
-	return (bi && bi->name && strcmp(bi->name, bi_unsupported_name) != 0);
+	return (bi && bi->profile->name && strcmp(bi->profile->name,
+						  bi_unsupported_name) != 0);
 }
 EXPORT_SYMBOL(blk_integrity_is_initialized);
 
@@ -446,14 +447,12 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 
 	/* Use the provided profile as template */
 	if (template != NULL) {
-		bi->name = template->name;
-		bi->generate_fn = template->generate_fn;
-		bi->verify_fn = template->verify_fn;
+		bi->profile = template->profile;
 		bi->tuple_size = template->tuple_size;
 		bi->tag_size = template->tag_size;
 		bi->flags |= template->flags;
 	} else
-		bi->name = bi_unsupported_name;
+		bi->profile->name = bi_unsupported_name;
 
 	disk->queue->backing_dev_info.capabilities |= BDI_CAP_STABLE_WRITES;
 
diff --git a/block/t10-pi.c b/block/t10-pi.c
index 24d6e9715318..2c97912335a9 100644
--- a/block/t10-pi.c
+++ b/block/t10-pi.c
@@ -160,38 +160,30 @@ static int t10_pi_type3_verify_ip(struct blk_integrity_iter *iter)
 	return t10_pi_verify(iter, t10_pi_ip_fn, 3);
 }
 
-struct blk_integrity t10_pi_type1_crc = {
+struct blk_integrity_profile t10_pi_type1_crc = {
 	.name			= "T10-DIF-TYPE1-CRC",
 	.generate_fn		= t10_pi_type1_generate_crc,
 	.verify_fn		= t10_pi_type1_verify_crc,
-	.tuple_size		= sizeof(struct t10_pi_tuple),
-	.tag_size		= 0,
 };
 EXPORT_SYMBOL(t10_pi_type1_crc);
 
-struct blk_integrity t10_pi_type1_ip = {
+struct blk_integrity_profile t10_pi_type1_ip = {
 	.name			= "T10-DIF-TYPE1-IP",
 	.generate_fn		= t10_pi_type1_generate_ip,
 	.verify_fn		= t10_pi_type1_verify_ip,
-	.tuple_size		= sizeof(struct t10_pi_tuple),
-	.tag_size		= 0,
 };
 EXPORT_SYMBOL(t10_pi_type1_ip);
 
-struct blk_integrity t10_pi_type3_crc = {
+struct blk_integrity_profile t10_pi_type3_crc = {
 	.name			= "T10-DIF-TYPE3-CRC",
 	.generate_fn		= t10_pi_type3_generate_crc,
 	.verify_fn		= t10_pi_type3_verify_crc,
-	.tuple_size		= sizeof(struct t10_pi_tuple),
-	.tag_size		= 0,
 };
 EXPORT_SYMBOL(t10_pi_type3_crc);
 
-struct blk_integrity t10_pi_type3_ip = {
+struct blk_integrity_profile t10_pi_type3_ip = {
 	.name			= "T10-DIF-TYPE3-IP",
 	.generate_fn		= t10_pi_type3_generate_ip,
 	.verify_fn		= t10_pi_type3_verify_ip,
-	.tuple_size		= sizeof(struct t10_pi_tuple),
-	.tag_size		= 0,
 };
 EXPORT_SYMBOL(t10_pi_type3_ip);
diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
index cb62ec6a12d0..7df89b547ae1 100644
--- a/drivers/nvdimm/core.c
+++ b/drivers/nvdimm/core.c
@@ -399,19 +399,22 @@ static int nd_pi_nop_generate_verify(struct blk_integrity_iter *iter)
 
 int nd_integrity_init(struct gendisk *disk, unsigned long meta_size)
 {
-	struct blk_integrity integrity = {
+	struct blk_integrity bi;
+	static struct blk_integrity_profile profile = {
 		.name = "ND-PI-NOP",
 		.generate_fn = nd_pi_nop_generate_verify,
 		.verify_fn = nd_pi_nop_generate_verify,
-		.tuple_size = meta_size,
-		.tag_size = meta_size,
 	};
 	int ret;
 
 	if (meta_size == 0)
 		return 0;
 
-	ret = blk_integrity_register(disk, &integrity);
+	bi.profile = &profile;
+	bi.tuple_size = meta_size;
+	bi.tag_size = meta_size;
+
+	ret = blk_integrity_register(disk, &bi);
 	if (ret)
 		return ret;
 
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index ad58ee3c3b57..5dba51d4bae6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -558,7 +558,7 @@ static int nvme_noop_generate(struct blk_integrity_iter *iter)
 	return 0;
 }
 
-struct blk_integrity nvme_meta_noop = {
+struct blk_integrity_profile nvme_meta_noop = {
 	.name			= "NVME_META_NOOP",
 	.generate_fn		= nvme_noop_generate,
 	.verify_fn		= nvme_noop_verify,
@@ -570,14 +570,14 @@ static void nvme_init_integrity(struct nvme_ns *ns)
 
 	switch (ns->pi_type) {
 	case NVME_NS_DPS_PI_TYPE3:
-		integrity = t10_pi_type3_crc;
+		integrity.profile = &t10_pi_type3_crc;
 		break;
 	case NVME_NS_DPS_PI_TYPE1:
 	case NVME_NS_DPS_PI_TYPE2:
-		integrity = t10_pi_type1_crc;
+		integrity.profile = &t10_pi_type1_crc;
 		break;
 	default:
-		integrity = nvme_meta_noop;
+		integrity.profile = &nvme_meta_noop;
 		break;
 	}
 	integrity.tuple_size = ns->ms;
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 5c06d292b94c..5a5ec9aa26b3 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -43,6 +43,7 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 	struct scsi_device *sdp = sdkp->device;
 	struct gendisk *disk = sdkp->disk;
 	u8 type = sdkp->protection_type;
+	struct blk_integrity bi;
 	int dif, dix;
 
 	dif = scsi_host_dif_capable(sdp->host, type);
@@ -58,36 +59,38 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 	/* Enable DMA of protection information */
 	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP) {
 		if (type == SD_DIF_TYPE3_PROTECTION)
-			blk_integrity_register(disk, &t10_pi_type3_ip);
+			bi.profile = &t10_pi_type3_ip;
 		else
-			blk_integrity_register(disk, &t10_pi_type1_ip);
+			bi.profile = &t10_pi_type1_ip;
 
-		disk->integrity->flags |= BLK_INTEGRITY_IP_CHECKSUM;
+		bi.flags |= BLK_INTEGRITY_IP_CHECKSUM;
 	} else
 		if (type == SD_DIF_TYPE3_PROTECTION)
-			blk_integrity_register(disk, &t10_pi_type3_crc);
+			bi.profile = &t10_pi_type3_crc;
 		else
-			blk_integrity_register(disk, &t10_pi_type1_crc);
+			bi.profile = &t10_pi_type1_crc;
 
+	bi.tuple_size = sizeof(struct t10_pi_tuple);
 	sd_printk(KERN_NOTICE, sdkp,
-		  "Enabling DIX %s protection\n", disk->integrity->name);
+		  "Enabling DIX %s protection\n", bi.profile->name);
 
-	/* Signal to block layer that we support sector tagging */
 	if (dif && type) {
-
-		disk->integrity->flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
+		bi.flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
 
 		if (!sdkp->ATO)
-			return;
+			goto out;
 
 		if (type == SD_DIF_TYPE3_PROTECTION)
-			disk->integrity->tag_size = sizeof(u16) + sizeof(u32);
+			bi.tag_size = sizeof(u16) + sizeof(u32);
 		else
-			disk->integrity->tag_size = sizeof(u16);
+			bi.tag_size = sizeof(u16);
 
 		sd_printk(KERN_NOTICE, sdkp, "DIF application tag size %u\n",
-			  disk->integrity->tag_size);
+			  bi.tag_size);
 	}
+
+out:
+	blk_integrity_register(disk, &bi);
 }
 
 /*
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 0f19e11acac2..f29c69120054 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -155,17 +155,17 @@ static int iblock_configure_device(struct se_device *dev)
 	if (bi) {
 		struct bio_set *bs = ib_dev->ibd_bio_set;
 
-		if (!strcmp(bi->name, "T10-DIF-TYPE3-IP") ||
-		    !strcmp(bi->name, "T10-DIF-TYPE1-IP")) {
+		if (!strcmp(bi->profile->name, "T10-DIF-TYPE3-IP") ||
+		    !strcmp(bi->profile->name, "T10-DIF-TYPE1-IP")) {
 			pr_err("IBLOCK export of blk_integrity: %s not"
-			       " supported\n", bi->name);
+			       " supported\n", bi->profile->name);
 			ret = -ENOSYS;
 			goto out_blkdev_put;
 		}
 
-		if (!strcmp(bi->name, "T10-DIF-TYPE3-CRC")) {
+		if (!strcmp(bi->profile->name, "T10-DIF-TYPE3-CRC")) {
 			dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE3_PROT;
-		} else if (!strcmp(bi->name, "T10-DIF-TYPE1-CRC")) {
+		} else if (!strcmp(bi->profile->name, "T10-DIF-TYPE1-CRC")) {
 			dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE1_PROT;
 		}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 830f9c07d4bb..f36c6476f1c7 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1462,16 +1462,18 @@ struct blk_integrity_iter {
 
 typedef int (integrity_processing_fn) (struct blk_integrity_iter *);
 
-struct blk_integrity {
-	integrity_processing_fn	*generate_fn;
-	integrity_processing_fn	*verify_fn;
-
-	unsigned short		flags;
-	unsigned short		tuple_size;
-	unsigned short		interval;
-	unsigned short		tag_size;
+struct blk_integrity_profile {
+	integrity_processing_fn		*generate_fn;
+	integrity_processing_fn		*verify_fn;
+	const char			*name;
+};
 
-	const char		*name;
+struct blk_integrity {
+	struct blk_integrity_profile	*profile;
+	unsigned short			flags;
+	unsigned short			tuple_size;
+	unsigned short			interval;
+	unsigned short			tag_size;
 };
 
 extern bool blk_integrity_is_initialized(struct gendisk *);
diff --git a/include/linux/t10-pi.h b/include/linux/t10-pi.h
index 6a8b9942632d..dd8de82cf5b5 100644
--- a/include/linux/t10-pi.h
+++ b/include/linux/t10-pi.h
@@ -14,9 +14,9 @@ struct t10_pi_tuple {
 };
 
 
-extern struct blk_integrity t10_pi_type1_crc;
-extern struct blk_integrity t10_pi_type1_ip;
-extern struct blk_integrity t10_pi_type3_crc;
-extern struct blk_integrity t10_pi_type3_ip;
+extern struct blk_integrity_profile t10_pi_type1_crc;
+extern struct blk_integrity_profile t10_pi_type1_ip;
+extern struct blk_integrity_profile t10_pi_type3_crc;
+extern struct blk_integrity_profile t10_pi_type3_ip;
 
 #endif

