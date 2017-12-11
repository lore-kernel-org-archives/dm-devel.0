From: Scott Bauer <scott.bauer@intel.com>
Subject: [PATCH v2 1/2] dm-unstripe: unstripe of IO across RAID 0
Date: Mon, 11 Dec 2017 09:00:18 -0700
Message-ID: <20171211160019.20518-2-scott.bauer@intel.com>
References: <20171211160019.20518-1-scott.bauer@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171211160019.20518-1-scott.bauer@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: snitzer@redhat.com, agk@redhat.com, linux-kernel@vger.kernel.org, keith.busch@intel.com, jonathan.derrick@intel.com, Scott Bauer <scott.bauer@intel.com>
List-Id: dm-devel.ids

This device mapper module remaps and unstripes IO so it lands
solely on a single drive in a RAID 0. In a 4 drive RAID 0 the
mapper exposes 1/4th of the LBA range as a virtual drive.
Each IO to that virtual drive will land on only one of the 4
drives, selected by the user.

As an example:

Intel NVMe drives contain two cores on the physical device.
Each core of the drive has segregated access to its LBA range.
The current LBA model has a RAID 0 128k stripe across the two cores:

   Core 0:                Core 1:
  __________            __________
  | LBA 511|            | LBA 768|
  | LBA 0  |            | LBA 256|

The purpose of this unstriping is to provide better QoS in noisy
neighbor environments. When two partitions are created on the
aggregate drive without this unstriping, reads on one partition
can affect writes on another partition. With the striping concurrent
reads and writes and I/O on opposite cores have lower completion times,
and better tail latencies.

Signed-off-by: Scott Bauer <scott.bauer@intel.com>
---
 drivers/md/Kconfig       |  10 +++
 drivers/md/Makefile      |   1 +
 drivers/md/dm-unstripe.c | 197 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 208 insertions(+)
 create mode 100644 drivers/md/dm-unstripe.c

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 83b9362be09c..948874fcc67c 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -269,6 +269,16 @@ config DM_BIO_PRISON
 
 source "drivers/md/persistent-data/Kconfig"
 
+config DM_UN_STRIPE
+       tristate "Transpose IO to individual drives on a raid device"
+       depends on BLK_DEV_DM
+       ---help---
+         Enable this feature if you with to unstripe I/O on a RAID 0
+	 device to the respective drive. If your hardware has physical
+	 RAID 0 this module can unstripe the I/O to respective sides.
+
+	 If unsure say N.
+
 config DM_CRYPT
 	tristate "Crypt target support"
 	depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index f701bb211783..2cc380b71319 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -43,6 +43,7 @@ obj-$(CONFIG_BCACHE)		+= bcache/
 obj-$(CONFIG_BLK_DEV_MD)	+= md-mod.o
 obj-$(CONFIG_BLK_DEV_DM)	+= dm-mod.o
 obj-$(CONFIG_BLK_DEV_DM_BUILTIN) += dm-builtin.o
+obj-$(CONFIG_DM_UN_STRIPE)   += dm-unstripe.o
 obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
 obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
new file mode 100644
index 000000000000..cca91108688f
--- /dev/null
+++ b/drivers/md/dm-unstripe.c
@@ -0,0 +1,197 @@
+/*
+ * Copyright © 2017 Intel Corporation
+ *
+ * Authors:
+ *    Scott  Bauer      <scott.bauer@intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+
+#include "dm.h"
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+#include <linux/slab.h>
+#include <linux/bitops.h>
+#include <linux/device-mapper.h>
+
+
+struct unstripe {
+	struct dm_dev *ddisk;
+	unsigned int max_hw_sectors;
+	unsigned int chunk_sector;
+	u64 stripe_shift;
+	u8 cur_stripe;
+};
+
+
+#define DM_MSG_PREFIX "dm-unstripe"
+static const char *parse_err = "Please provide the necessary information:"
+	"<drive> <set (0 indexed)> <total_sets>"
+	" <stripe size in 512B sectors || 0 to use max hw sector size>";
+
+/*
+ * Argument layout:
+ * <drive> <set> <total_sets> <stripe size in KB>
+ */
+static int set_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct block_device *bbdev;
+	struct unstripe *target;
+	unsigned int stripe_size;
+	u64 tot_sec, mod;
+	u8 set, num_sets;
+	char dummy;
+	int ret;
+
+	if (argc != 4) {
+		DMERR("%s", parse_err);
+		return -EINVAL;
+	}
+
+	if (sscanf(argv[1], "%hhu%c", &set, &dummy) != 1 ||
+	    sscanf(argv[2], "%hhu%c", &num_sets, &dummy) != 1 ||
+	    sscanf(argv[3], "%u%c", &stripe_size, &dummy) != 1) {
+		DMERR("%s", parse_err);
+		return -EINVAL;
+	}
+
+	if (num_sets == 0 || (set > num_sets && num_sets > 1)) {
+		DMERR("Please provide a set between [0,%hhu)", num_sets);
+		return -EINVAL;
+	}
+
+	target = kzalloc(sizeof(*target), GFP_KERNEL);
+
+	if (!target) {
+		DMERR("Failed to allocate space for DM unstripe!");
+		return -ENOMEM;
+	}
+
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			    &target->ddisk);
+	if (ret) {
+		kfree(target);
+		DMERR("dm-unstripe dev lookup failure! for drive %s", argv[0]);
+		return ret;
+	}
+
+	bbdev = target->ddisk->bdev;
+
+	target->cur_stripe = set;
+	if (stripe_size)
+		target->max_hw_sectors = stripe_size;
+	else
+		target->max_hw_sectors =
+			queue_max_hw_sectors(bdev_get_queue(bbdev));
+
+	target->chunk_sector = (num_sets - 1) * target->max_hw_sectors;
+	target->stripe_shift = fls(target->max_hw_sectors) - 1;
+
+	dm_set_target_max_io_len(ti, target->max_hw_sectors);
+	ti->private = target;
+
+	tot_sec = i_size_read(bbdev->bd_inode) >> 9;
+	mod = tot_sec % target->max_hw_sectors;
+
+	if (ti->len == 1)
+		ti->len = (tot_sec / num_sets) - mod;
+	ti->begin = 0;
+	return 0;
+}
+
+static void set_dtr(struct dm_target *ti)
+{
+	struct unstripe *target = ti->private;
+
+	dm_put_device(ti, target->ddisk);
+	kfree(target);
+}
+
+
+static sector_t map_to_core(struct dm_target *ti, struct bio *bio)
+{
+	struct unstripe *target = ti->private;
+	unsigned long long sec = bio->bi_iter.bi_sector;
+	unsigned long long group;
+
+	group = (sec >> target->stripe_shift);
+	/* Account for what drive we're operating on */
+	sec += (target->cur_stripe * target->max_hw_sectors);
+	/* Shift us up to the right "row" on the drive*/
+	sec += target->chunk_sector * group;
+	return sec;
+}
+
+static int set_map_bio(struct dm_target *ti, struct bio *bio)
+{
+	struct unstripe *target = ti->private;
+
+	if (bio_sectors(bio))
+		bio->bi_iter.bi_sector = map_to_core(ti, bio);
+
+	bio_set_dev(bio, target->ddisk->bdev);
+	submit_bio(bio);
+	return DM_MAPIO_SUBMITTED;
+}
+
+static void set_iohints(struct dm_target *ti,
+			struct queue_limits *limits)
+{
+	struct unstripe *target = ti->private;
+	struct queue_limits *lim = &bdev_get_queue(target->ddisk->bdev)->limits;
+
+	blk_limits_io_min(limits, lim->io_min);
+	blk_limits_io_opt(limits, lim->io_opt);
+	limits->chunk_sectors = target->max_hw_sectors;
+}
+
+static int set_iterate(struct dm_target *ti, iterate_devices_callout_fn fn,
+		       void *data)
+{
+	struct unstripe *target = ti->private;
+
+	return fn(ti, target->ddisk, 0, ti->len, data);
+}
+
+static struct target_type iset_target = {
+	.name = "dm-unstripe",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.ctr = set_ctr,
+	.dtr = set_dtr,
+	.map = set_map_bio,
+	.iterate_devices = set_iterate,
+	.io_hints = set_iohints,
+};
+
+static int __init dm_unstripe_init(void)
+{
+	int r = dm_register_target(&iset_target);
+
+	if (r < 0)
+		DMERR("register failed %d", r);
+
+	return r;
+}
+
+static void __exit dm_unstripe_exit(void)
+{
+	dm_unregister_target(&iset_target);
+}
+
+module_init(dm_unstripe_init);
+module_exit(dm_unstripe_exit);
+
+MODULE_DESCRIPTION(DM_NAME " DM unstripe");
+MODULE_ALIAS("dm-unstripe");
+MODULE_AUTHOR("Scott Bauer <scott.bauer@intel.com>");
+MODULE_LICENSE("GPL");
-- 
2.11.0
