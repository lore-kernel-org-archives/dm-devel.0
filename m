From: Vitaly Chikunov <vt@altlinux.org>
Subject: [PATCH] dm: add secdel target
Date: Sun, 14 Oct 2018 14:24:37 +0300
Message-ID: <20181014112439.8119-1-vt@altlinux.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Jonathan Corbet <corbet@lwn.net>, Shaohua Li <shli@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Vitaly Chikunov <vt@altlinux.org>
List-Id: dm-devel.ids

Report to the upper level ability to discard, and translate arriving
discards to the writes of random or zero data to the underlying level.

Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
---
  This target is the same as the linear target except that is reports ability to
  discard to the upper level and translates arriving discards into sector
  overwrites with random (or zero) data.

  The target does not try to determine if the underlying drive reliably supports
  data overwrites, this decision is solely on the discretion of a user.

  It may be useful to create a secure deletion setup when filesystem when
  unlinking a file sends discards to its sectors, in this target they are
  translated to writes that wipe deleted data on the underlying drive.

  Tested on x86.

 Documentation/device-mapper/dm-secdel.txt |  24 ++
 drivers/md/Kconfig                        |  14 ++
 drivers/md/Makefile                       |   2 +
 drivers/md/dm-secdel.c                    | 399 ++++++++++++++++++++++++++++++
 4 files changed, 439 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-secdel.txt
 create mode 100644 drivers/md/dm-secdel.c

diff --git a/Documentation/device-mapper/dm-secdel.txt b/Documentation/device-mapper/dm-secdel.txt
new file mode 100644
index 000000000000..7a10a6273c6e
--- /dev/null
+++ b/Documentation/device-mapper/dm-secdel.txt
@@ -0,0 +1,24 @@
+dm-secdel
+=========
+
+This target is the same as the linear target except that is reports ability to
+discard to the upper level and translates arriving discards into sector
+overwrites with random (or zero) data.
+
+The target does not try to determine if the underlying drive reliably supports
+data overwrites, this decision is solely on the discretion of a user. Please
+note that not all drivers support this ability.
+
+It may be useful to create a secure deletion setup when filesystem (which
+supports discards, such as ext4, and mounted in discard mode) when unlinking a
+file sends discards to its sectors, in this target they are translated to
+writes that wipe deleted data on the underlying drive.
+
+
+Parameters: <dev path> <offset> [<mode>]
+    <dev path>: Full pathname to the underlying block-device, or a
+                "major:minor" device-number.
+    <offset>: Starting sector within the device.
+    <mode>: Optional overwriting mode specifier:
+            "rand" to overwrite with random data,
+            "zero" to overwrite with zeros (default).
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 8b8c123cae66..8ec98ef53965 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -559,4 +559,18 @@ config DM_ZONED
 
 	  If unsure, say N.
 
+config DM_SECDEL
+	tristate "Secdel target"
+	depends on BLK_DEV_DM
+	help
+
+	  A target that transforms discards into overwrites with random data or
+	  zeros. It may be useful if your underlying device supports data
+	  overwriting to wipe deleted data (if the filesystem supports
+	  discards). This device does not attempt to detect if the underlying
+	  drive supports data overwriting reliably, this decision is solely on
+	  the discretion of an end user.
+
+	  If unsure, say N.
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 822f4e8753bc..f6a95031904b 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -25,6 +25,7 @@ dm-zoned-y	+= dm-zoned-target.o dm-zoned-metadata.o dm-zoned-reclaim.o
 linear-y	+= md-linear.o
 multipath-y	+= md-multipath.o
 faulty-y	+= md-faulty.o
+secdel-y	+= md-secdel.o
 
 # Note: link order is important.  All raid personalities
 # and must come before md.o, as they each initialise 
@@ -68,6 +69,7 @@ obj-$(CONFIG_DM_LOG_WRITES)	+= dm-log-writes.o
 obj-$(CONFIG_DM_INTEGRITY)	+= dm-integrity.o
 obj-$(CONFIG_DM_ZONED)		+= dm-zoned.o
 obj-$(CONFIG_DM_WRITECACHE)	+= dm-writecache.o
+obj-$(CONFIG_DM_SECDEL)		+= dm-secdel.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
diff --git a/drivers/md/dm-secdel.c b/drivers/md/dm-secdel.c
new file mode 100644
index 000000000000..9aeaf3f243c0
--- /dev/null
+++ b/drivers/md/dm-secdel.c
@@ -0,0 +1,399 @@
+// SPDX-License-Identifier: GPL-1.0+
+/*
+ * Delete (wipe) sectors on discard
+ *
+ * This device reports ability to discard sectors to the upper level,
+ * and translates arriving discards into write of random data to the
+ * down level.
+ *
+ * Copyright (C) 2001-2003 Sistina Software (UK) Limited.
+ * Copyright (C) 2018, Vitaly Chikunov <vt@altlinux.org>.
+ *
+ * This file is released under the GPL.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+#include <linux/dax.h>
+#include <linux/slab.h>
+#include <linux/device-mapper.h>
+#include <linux/random.h>
+
+#define DM_MSG_PREFIX "secdel"
+
+enum secdel_mode {
+	SECDEL_MODE_ZERO = 0,
+	SECDEL_MODE_RAND = 1,
+};
+
+struct secdel_c {
+	struct dm_dev *dev;
+	sector_t start;
+	enum secdel_mode mode;
+	u64 requests;
+	u64 discards;
+	u64 errors;
+};
+
+/* Construct a linear mapping: <dev_path> <offset> [mode] */
+static int secdel_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct secdel_c *lc;
+	unsigned long long tmp;
+	char dummy;
+	int ret;
+
+	if (argc < 2 || argc > 3) {
+		ti->error = "Invalid argument count";
+		return -EINVAL;
+	}
+
+	lc = kmalloc(sizeof(*lc), GFP_KERNEL);
+	if (!lc) {
+		ti->error = "Cannot allocate secdel context";
+		return -ENOMEM;
+	}
+
+	ret = -EINVAL;
+	if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1) {
+		ti->error = "Invalid device sector";
+		goto bad;
+	}
+	lc->start = tmp;
+
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &lc->dev);
+	if (ret) {
+		ti->error = "Device lookup failed";
+		goto bad;
+	}
+
+	lc->mode = 0;
+	if (argc > 2 && argv[2][0] == 'r')
+		lc->mode = 1;
+
+	lc->requests = 0;
+	lc->discards = 0;
+	lc->errors = 0;
+
+	ti->discards_supported = 1;
+	ti->num_flush_bios = 1;
+	ti->num_discard_bios = 1;
+	ti->num_secure_erase_bios = 1;
+	ti->num_write_same_bios = 1;
+	ti->num_write_zeroes_bios = 1;
+	ti->private = lc;
+	return 0;
+bad:
+	kfree(lc);
+	return ret;
+}
+
+static void secdel_dtr(struct dm_target *ti)
+{
+	struct secdel_c *lc = ti->private;
+
+	dm_put_device(ti, lc->dev);
+	kfree(lc);
+}
+
+static sector_t secdel_map_sector(struct dm_target *ti, sector_t bi_sector)
+{
+	struct secdel_c *lc = ti->private;
+
+	return lc->start + dm_target_offset(ti, bi_sector);
+}
+
+static void secdel_map_bio(struct dm_target *ti, struct bio *bio)
+{
+	struct secdel_c *lc = ti->private;
+
+	bio_set_dev(bio, lc->dev->bdev);
+	if (bio_sectors(bio) || bio_op(bio) == REQ_OP_ZONE_RESET)
+		bio->bi_iter.bi_sector =
+			secdel_map_sector(ti, bio->bi_iter.bi_sector);
+}
+
+static void bio_end_erase(struct bio *bio)
+{
+	struct bio_vec *bvec;
+	int i;
+
+	if (bio->bi_status)
+		DMERR("%s %lu[%u] error=%d",
+		      __func__,
+		      bio->bi_iter.bi_sector,
+		      bio->bi_iter.bi_size >> 9,
+		      bio->bi_status);
+	bio_for_each_segment_all(bvec, bio, i)
+		if (bvec->bv_page != ZERO_PAGE(0))
+			__free_page(bvec->bv_page);
+	bio_put(bio);
+}
+
+static void secdel_submit_bio(struct bio *bio)
+{
+	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
+	submit_bio(bio);
+}
+
+static int op_discard(struct bio *bio)
+{
+	if (bio_op(bio) == REQ_OP_DISCARD)
+		return true;
+	return false;
+}
+
+/*
+ * Send amount of masking data to the device
+ * @mode: 0 to write zeros, otherwise to write random data
+ */
+static int issue_erase(struct block_device *bdev, sector_t sector,
+		       sector_t nr_sects, gfp_t gfp_mask, enum secdel_mode mode)
+{
+	int ret = 0;
+
+	while (nr_sects) {
+		struct bio *bio;
+		unsigned int nrvecs = min(nr_sects,
+					  (sector_t)BIO_MAX_PAGES >> 3);
+
+		bio = bio_alloc(gfp_mask, nrvecs);
+		if (!bio) {
+			DMERR("%s %lu[%lu]: no memory to allocate bio (%u)",
+			      __func__, sector, nr_sects, nrvecs);
+			ret = -ENOMEM;
+			break;
+		}
+
+		bio->bi_iter.bi_sector = sector;
+		bio_set_dev(bio, bdev);
+		bio->bi_end_io = bio_end_erase;
+
+		while (nr_sects != 0) {
+			unsigned int sn;
+			struct page *page = NULL;
+
+			sn = min((sector_t)PAGE_SIZE >> 9, nr_sects);
+			if (mode == SECDEL_MODE_RAND) {
+				page = alloc_page(gfp_mask);
+				if (!page) {
+					DMERR("%s %lu[%lu]: no memory to allocate page for random data",
+					      __func__, sector, nr_sects);
+					/* will fallback to zero filling */
+				} else {
+					void *ptr;
+
+					ptr = kmap_atomic(page);
+					get_random_bytes(ptr, sn << 9);
+					kunmap_atomic(ptr);
+				}
+			}
+			if (!page)
+				page = ZERO_PAGE(0);
+			ret = bio_add_page(bio, page, sn << 9, 0);
+			if (!ret && page != ZERO_PAGE(0))
+				__free_page(page);
+			nr_sects -= ret >> 9;
+			sector += ret >> 9;
+			if (ret < (sn << 9))
+				break;
+		}
+		ret = 0;
+		secdel_submit_bio(bio);
+		cond_resched();
+	}
+
+	return ret;
+}
+
+/* convert discards into writes */
+static int secdel_map_discard(struct dm_target *ti, struct bio *sbio)
+{
+	struct secdel_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	sector_t sector = sbio->bi_iter.bi_sector;
+	sector_t nr_sects = bio_sectors(sbio);
+
+	lc->requests++;
+	if (!bio_sectors(sbio))
+		return 0;
+	if (!op_discard(sbio))
+		return 0;
+	lc->discards++;
+	if (WARN_ON(sbio->bi_vcnt != 0))
+		return -1;
+	DMDEBUG("DISCARD %lu: %u sectors M%d", sbio->bi_iter.bi_sector,
+		bio_sectors(sbio), lc->mode);
+	bio_endio(sbio);
+
+	if (issue_erase(bdev, sector, nr_sects, GFP_NOFS, lc->mode))
+		lc->errors++;
+	return 1;
+}
+
+static int secdel_map(struct dm_target *ti, struct bio *bio)
+{
+	secdel_map_bio(ti, bio);
+	if (secdel_map_discard(ti, bio))
+		return DM_MAPIO_SUBMITTED;
+	return DM_MAPIO_REMAPPED;
+}
+
+static int secdel_end_io(struct dm_target *ti, struct bio *bio,
+			 blk_status_t *error)
+{
+	struct secdel_c *lc = ti->private;
+
+	if (!*error && bio_op(bio) == REQ_OP_ZONE_REPORT)
+		dm_remap_zone_report(ti, bio, lc->start);
+
+	return DM_ENDIO_DONE;
+}
+
+static void secdel_status(struct dm_target *ti, status_type_t type,
+			  unsigned status_flags, char *result, unsigned maxlen)
+{
+	struct secdel_c *lc = ti->private;
+	unsigned sz = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%llu %llu %llu", lc->requests, lc->discards,
+		       lc->errors);
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s %llu %s", lc->dev->name,
+		       (unsigned long long)lc->start,
+		       lc->mode ? "rand" : "zero");
+		break;
+	}
+}
+
+static int secdel_prepare_ioctl(struct dm_target *ti,
+				struct block_device **bdev)
+{
+	struct secdel_c *lc = ti->private;
+	struct dm_dev *dev = lc->dev;
+
+	*bdev = dev->bdev;
+
+	/*
+	 * Only pass ioctls through if the device sizes match exactly.
+	 */
+	if (lc->start ||
+	    ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
+		return 1;
+	return 0;
+}
+
+static int secdel_iterate_devices(struct dm_target *ti,
+				  iterate_devices_callout_fn fn, void *data)
+{
+	struct secdel_c *lc = ti->private;
+
+	return fn(ti, lc->dev, lc->start, ti->len, data);
+}
+
+static void secdel_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	struct secdel_c *lc = ti->private;
+
+	limits->discard_granularity = bdev_logical_block_size(lc->dev->bdev);
+	limits->max_discard_sectors = PAGE_SIZE >> 9;
+}
+
+#if IS_ENABLED(CONFIG_DAX_DRIVER)
+static long secdel_dax_direct_access(struct dm_target *ti, pgoff_t pgoff,
+				     long nr_pages, void **kaddr, pfn_t *pfn)
+{
+	long ret;
+	struct secdel_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct dax_device *dax_dev = lc->dev->dax_dev;
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+
+	dev_sector = secdel_map_sector(ti, sector);
+	ret = bdev_dax_pgoff(bdev, dev_sector, nr_pages * PAGE_SIZE, &pgoff);
+	if (ret)
+		return ret;
+	return dax_direct_access(dax_dev, pgoff, nr_pages, kaddr, pfn);
+}
+
+static size_t secdel_dax_copy_from_iter(struct dm_target *ti, pgoff_t pgoff,
+					void *addr, size_t bytes,
+					struct iov_iter *i)
+{
+	struct secdel_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct dax_device *dax_dev = lc->dev->dax_dev;
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+
+	dev_sector = secdel_map_sector(ti, sector);
+	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+		return 0;
+	return dax_copy_from_iter(dax_dev, pgoff, addr, bytes, i);
+}
+
+static size_t secdel_dax_copy_to_iter(struct dm_target *ti, pgoff_t pgoff,
+				      void *addr, size_t bytes,
+				      struct iov_iter *i)
+{
+	struct secdel_c *lc = ti->private;
+	struct block_device *bdev = lc->dev->bdev;
+	struct dax_device *dax_dev = lc->dev->dax_dev;
+	sector_t dev_sector, sector = pgoff * PAGE_SECTORS;
+
+	dev_sector = secdel_map_sector(ti, sector);
+	if (bdev_dax_pgoff(bdev, dev_sector, ALIGN(bytes, PAGE_SIZE), &pgoff))
+		return 0;
+	return dax_copy_to_iter(dax_dev, pgoff, addr, bytes, i);
+}
+#else
+# define secdel_dax_direct_access NULL
+# define secdel_dax_copy_from_iter NULL
+# define secdel_dax_copy_to_iter NULL
+#endif
+
+static struct target_type secdel_target = {
+	.name   = "secdel",
+	.version = {1, 1, 0},
+	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
+	.module = THIS_MODULE,
+	.ctr    = secdel_ctr,
+	.dtr    = secdel_dtr,
+	.map    = secdel_map,
+	.end_io = secdel_end_io,
+	.status = secdel_status,
+	.prepare_ioctl = secdel_prepare_ioctl,
+	.io_hints = secdel_io_hints,
+	.iterate_devices = secdel_iterate_devices,
+	.direct_access = secdel_dax_direct_access,
+	.dax_copy_from_iter = secdel_dax_copy_from_iter,
+	.dax_copy_to_iter = secdel_dax_copy_to_iter,
+};
+
+int __init dm_secdel_init(void)
+{
+	int r = dm_register_target(&secdel_target);
+
+	if (r < 0)
+		DMERR("register failed %d", r);
+
+	return r;
+}
+
+void dm_secdel_exit(void)
+{
+	dm_unregister_target(&secdel_target);
+}
+
+module_init(dm_secdel_init);
+module_exit(dm_secdel_exit);
+
+MODULE_AUTHOR("Vitaly Chikunov <vt@altlinux.org>");
+MODULE_DESCRIPTION(DM_NAME " translate discards to writes");
+MODULE_LICENSE("GPL");
-- 
2.11.0
