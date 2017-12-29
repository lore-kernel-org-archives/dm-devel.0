From: liuchaowei110@gmail.com
Subject: [PATCH 1/2] dm: add asymmetric stripe target device dirver
Date: Fri, 29 Dec 2017 20:33:59 +0800
Message-ID: <5a4636e3.5465650a.6d7db.95fa@mx.google.com>
References: <20171229123400.20127-1-liuchaowei>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171229123400.20127-1-liuchaowei>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com
Cc: snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, liuchaowei <liuchaowei@smartisan.com>
List-Id: dm-devel.ids

From: liuchaowei <liuchaowei@smartisan.com>

This asymmetric stripe target device driver can achieve better io
performance between those devices which possess different io performance

There are 2 storage device or flash devices: A and B, their sequential
read performance are 220M/s and 315M/s respectively, so their sequential
read speed ratio could be approximately equal to 2:3, if we use stripe
type to combine these two devices, their layout could be showed below:
--------------------------------------------------------
|    A1    |    A2    |    B1    |    B2    |    B3    |
--------------------------------------------------------

If we select asymmetric stripe type, their layout could be illustrated
follow:
--------------------------------------------------------
|         A1          |               B1               |
--------------------------------------------------------

The former has 5 stripe devices and each stripe device has also equal
chunk size, e.g.: 256secs. If there is a data block which size is
1280secs, so transfer the data to this stripe device will be split
to 5 ios which io size is 256secs. But if we use the asymmetric
stripe device, it only has two stripe devices and each one has be
setting in optimal chunk size, e.g.: ratio is 2:3, the first one
optimal chunk size is 512secs, the second is 768secs.  And same
1280secs data block just only be split into two ios, this can be
achieved perfect io performance.

Change-Id: Ib188996fc844098322a6bf13ebef1ef0de38ca47
Signed-off-by: liuchaowei <liuchaowei@smartisan.com>
---
 Documentation/device-mapper/asymmetric-striped.txt |  85 ++++
 drivers/md/Kconfig                                 |  11 +
 drivers/md/Makefile                                |   1 +
 drivers/md/dm-asymmetric-stripe.c                  | 526 +++++++++++++++++++++
 drivers/md/dm.c                                    |   5 +
 include/linux/device-mapper.h                      |  15 +
 6 files changed, 643 insertions(+)
 create mode 100644 Documentation/device-mapper/asymmetric-striped.txt
 create mode 100644 drivers/md/dm-asymmetric-stripe.c

diff --git a/Documentation/device-mapper/asymmetric-striped.txt b/Documentation/device-mapper/asymmetric-striped.txt
new file mode 100644
index 000000000000..fb588535c49b
--- /dev/null
+++ b/Documentation/device-mapper/asymmetric-striped.txt
@@ -0,0 +1,85 @@
+dm-asymmetric-stripe
+=========
+
+Device-Mapper's "asm-striped" target is used to create a striped (i.e. RAID-0)
+device across one or more underlying devices. Data is written in "chunks",
+with consecutive chunks rotating among the underlying devices. This can
+potentially provide improved I/O throughput by utilizing several physical
+devices in parallel. However, in order to gain maximum I/O performance
+between slow and fast device, there is a ratio to set up the chunk size
+among these device.
+
+Parameters: <num devs> <chunk size> <ratio> [<dev path> <offset>]+
+<num devs>: Number of underlying devices.
+<chunk size>: Size of each chunk of data. Must be at least as
+large as the system's PAGE_SIZE.
+<ratio>: The proportion of per io size, it is the times as much
+as 1 chunk size
+<dev path>: Full pathname to the underlying block-device, or a
+"major:minor" device-number.
+<offset>: Starting sector within the device.
+
+One or more underlying devices can be specified. The striped device
+size must be a multiple of the chunk size multiplied by the number of
+underlying devices. However, there is a ratio that can be set, e.g.: 2:3
+means the first one striped device optimal width size is 2 times as
+much as 1 chunk size, the second striped device is 3.
+
+
+Example scripts
+===============
+
+[[
+#!/usr/bin/perl -w
+# Create a striped device across any number of underlying devices. The device
+# will be called "stripe_dev" and have a chunk-size of 128k.
+
+my $chunk_size = 128 * 2;
+my $ratio = "2:3";
+my $dev_name = "stripe_dev";
+my $num_devs = @ARGV;
+my @devs = @ARGV;
+
+if ($num_devs < 2) {
+die("Specify at least two devices\n");
+}
+
+
+$stripe_average_size = 1073741824
+$stripe_dev_size = $stripe_average_size * 5;
+
+$table = "0 $stripe_dev_size asm-striped $num_devs $chunk_size $ratio";
+for ($i = 0; $i < $num_devs; $i++) {
+$table .= " $devs[$i] 0";
+}
+
+`echo $table | dmsetup create $dev_name`;
+]]
+
+
+Why asymmetric striped
+=======================
+Considering one case:
+There are 2 storage device or flash devices: A and B, their sequential
+read performance are 220M/s and 315M/s respectively, so their sequential
+read speed could be approximately equal to 2:3, if we use stripe type
+to combine these two devices, their layout could be showed below:
+--------------------------------------------------------
+|    A1    |    A2    |    B1    |    B2    |    B3    |
+--------------------------------------------------------
+
+If we select asymmetric stripe type, their layout could be illustrated
+follow:
+--------------------------------------------------------
+|         A1          |               B1               |
+--------------------------------------------------------
+
+The former has 5 stripe devices and each stripe device has also equal
+chunk size, e.g.: 256secs. If there is a data block which size is 1280secs,
+so transfer the data to this stripe device will be split into 5 ios which io
+size is 256secs. But if we use the asymmetric stripe device, it only has two
+stripe devices and each one has be setting in optimal chunk size, e.g.: ratio
+is 2:3, the first one optimal chunk size is 512secs, the second is 768secs.
+And same 1280secs data block just only be split into two ios, this can be
+achieved perfect io performance.
+
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 7d5aa2c5c81d..0f243a58144d 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -455,6 +455,17 @@ config DM_FLAKEY
        ---help---
          A target that intermittently fails I/O for debugging purposes.
 
+config DM_ASYMMETRIC_STRIPE
+	tristate "DM asymmetric stripe(asymmetric raid0)"
+	depends on BLK_DEV_DM
+	---help---
+	  This device-mapper target creates a asymmetric raid0/stripe device that
+	  support asymmetric stripe chunk size and can gain same performance as
+	  raid0 device.
+
+	  You must configure the accurate ratio between different physical storage
+	  device respectively.
+
 config DM_VERITY
 	tristate "Verity target support"
 	depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 2b2ba36638cd..0f0ea7bd7737 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -62,6 +62,7 @@ obj-$(CONFIG_DM_ERA)		+= dm-era.o
 obj-$(CONFIG_DM_LOG_WRITES)	+= dm-log-writes.o
 obj-$(CONFIG_DM_REQ_CRYPT)	+= dm-req-crypt.o
 obj-$(CONFIG_DM_ANDROID_VERITY) += dm-android-verity.o
+obj-$(CONFIG_DM_ASYMMETRIC_STRIPE) += dm-asymmetric-stripe.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
diff --git a/drivers/md/dm-asymmetric-stripe.c b/drivers/md/dm-asymmetric-stripe.c
new file mode 100644
index 000000000000..ead77ff25c6b
--- /dev/null
+++ b/drivers/md/dm-asymmetric-stripe.c
@@ -0,0 +1,526 @@
+/*
+ * Copyright (C) 2018 Smartisan, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * Author: <tgvlcw@gmail.com>
+ * Name: Henry Liu
+ *
+ */
+
+
+#include "dm.h"
+#include <linux/device-mapper.h>
+#include <linux/atomic.h>
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/blkdev.h>
+#include <linux/bio.h>
+#include <linux/bitops.h>
+#include <linux/slab.h>
+#include <linux/log2.h>
+#include <linux/workqueue.h>
+
+#define DM_MSG_PREFIX "asm-striped"
+#define DM_IO_ERROR_THRESHOLD 15
+
+typedef struct asymmetric_stripe asm_stripe;
+typedef struct asymmetric_stripe_c asm_stripe_c;
+
+struct asymmetric_stripe {
+	struct dm_dev *dev;
+
+	/* The size of this target / num. stripes */
+	sector_t physical_start;
+	sector_t stripe_width;
+	sector_t opt_io_size;
+	uint32_t ratio;
+
+	atomic_t error_count;
+};
+
+struct asymmetric_stripe_c {
+	uint32_t stripes;
+
+	uint32_t chunk_size;
+	uint32_t total_ratio;
+	sector_t avg_width;
+	sector_t stripe_size;
+	int stripe_size_shift;
+	char ratio_str[128];
+
+	/* Needed for handling events */
+	struct dm_target *ti;
+
+	/* Work struct used for triggering events*/
+	struct work_struct trigger_event;
+
+	asm_stripe stripe[0];
+};
+
+/*
+ * An event is triggered whenever a drive
+ * drops out of a stripe volume.
+ */
+static void trigger_event(struct work_struct *work)
+{
+	asm_stripe_c *sc = container_of(work, asm_stripe_c, trigger_event);
+
+	dm_table_event(sc->ti->table);
+}
+
+static inline asm_stripe_c *alloc_context(unsigned int stripes)
+{
+	size_t len;
+
+	if (dm_array_too_big(sizeof(asm_stripe_c),
+				sizeof(asm_stripe),
+				stripes))
+		return NULL;
+
+	len = sizeof(asm_stripe_c) + (sizeof(asm_stripe) * stripes);
+
+	return kmalloc(len, GFP_KERNEL);
+}
+
+/*
+ * Parse a single <dev> <sector> pair
+ */
+static int get_stripe(struct dm_target *ti,
+		asm_stripe_c *sc,
+		unsigned int stripe,
+		char **argv)
+{
+	unsigned long long start;
+	char dummy;
+	int ret;
+	unsigned int id = stripe;
+
+	if (sscanf(argv[1], "%llu%c", &start, &dummy) != 1)
+		return -EINVAL;
+
+	ret = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table),
+			&sc->stripe[stripe].dev);
+	if (ret)
+		return ret;
+
+	sc->stripe[id].physical_start = start;
+	sc->stripe[id].stripe_width = sc->avg_width * sc->stripe[id].ratio;
+	sc->stripe[id].opt_io_size = sc->chunk_size * sc->stripe[id].ratio;
+
+	return 0;
+}
+
+static int set_stripe_ratio(struct dm_target *ti,
+		asm_stripe_c *sc,
+		char *ratio_str)
+{
+	char *p;
+	unsigned int i;
+	uint32_t r = 0, ratio;
+	char *tmp_ratio = ratio_str;
+
+	if (sizeof(sc->ratio_str) < strlen(ratio_str)) {
+		ti->error = "Too big stripe ratio string";
+		return -ENOMEM;
+	}
+
+	strlcpy(sc->ratio_str, ratio_str, strlen(ratio_str) + 1);
+	for (i = 0; i < sc->stripes; i++) {
+		p  = strsep(&tmp_ratio, ":");
+		if (p == NULL)
+			return -EINVAL;
+
+		if (kstrtouint(p, 10, &ratio) || !ratio)
+			return -EINVAL;
+
+		sc->stripe[i].ratio = ratio;
+		r += ratio;
+	}
+
+	sc->total_ratio = r;
+	sc->avg_width = ti->len / r;
+	sc->stripe_size = r * sc->chunk_size;
+
+	return 0;
+}
+
+/*
+ * Construct a striped mapping.
+ * <number of stripes> <chunk size> <ratio> [<dev_path> <offset>]+
+ */
+static int asymmetric_stripe_ctr(struct dm_target *ti,
+		unsigned int argc,
+		char **argv)
+{
+	asm_stripe_c *sc;
+	sector_t width;
+	uint32_t stripes;
+	uint32_t chunk_size;
+	int r;
+	unsigned int i;
+
+	if (argc < 2) {
+		ti->error = "Not enough arguments";
+		return -EINVAL;
+	}
+
+	if (kstrtouint(argv[0], 10, &stripes) || !stripes) {
+		ti->error = "Invalid stripe count";
+		return -EINVAL;
+	}
+
+	if (kstrtouint(argv[1], 10, &chunk_size) || !chunk_size) {
+		ti->error = "Invalid chunk_size";
+		return -EINVAL;
+	}
+
+	/*
+	 * Do we have enough arguments for that many stripes ?
+	 */
+	if (argc != (3 + 2 * stripes)) {
+		ti->error = "Not enough destinations specified";
+		return -EINVAL;
+	}
+
+	sc = alloc_context(stripes);
+	if (!sc) {
+		ti->error = "Memory allocation for striped context failed";
+		return -ENOMEM;
+	}
+
+	INIT_WORK(&sc->trigger_event, trigger_event);
+
+	/* Set pointer to dm target; used in trigger_event */
+	sc->ti = ti;
+	sc->stripes = stripes;
+
+	ti->asymmetric_chunk_supported = true;
+	ti->num_flush_bios = stripes;
+	ti->num_discard_bios = stripes;
+	ti->num_write_same_bios = stripes;
+	sc->chunk_size = chunk_size;
+
+	if (set_stripe_ratio(ti, sc, argv[2]) < 0)
+		return -EINVAL;
+
+	if (sc->stripe_size & (sc->stripe_size - 1))
+		sc->stripe_size_shift = -1;
+	else
+		sc->stripe_size_shift = __ffs(sc->stripe_size);
+
+	width = ti->len;
+	if (sector_div(width, sc->total_ratio * chunk_size)) {
+		ti->error = "Target length not divisible by number of stripes";
+		return -EINVAL;
+	}
+
+	argv++;
+	/*
+	 * Get the stripe destinations.
+	 */
+	for (i = 0; i < stripes; i++) {
+		argv += 2;
+
+		r = get_stripe(ti, sc, i, argv);
+		if (r < 0) {
+			ti->error = "Couldn't parse stripe destination";
+			goto parse_error;
+		}
+		atomic_set(&(sc->stripe[i].error_count), 0);
+	}
+
+	ti->private = sc;
+
+	return 0;
+
+parse_error:
+	while (i--)
+		dm_put_device(ti, sc->stripe[i].dev);
+	kfree(sc);
+	return -EINVAL;
+}
+
+static inline sector_t stripe_index_fetch(asm_stripe_c *sc,
+		sector_t *sector,
+		uint32_t *stripe)
+{
+	sector_t width_offset;
+
+	if (sc->stripe_size_shift < 0)
+		width_offset = sector_div(*sector, sc->stripe_size);
+	else {
+		width_offset = *sector & (sc->stripe_size - 1);
+		*sector >>= sc->stripe_size_shift;
+	}
+
+	for (*stripe = 0; *stripe < sc->stripes; (*stripe)++) {
+		if (width_offset < sc->stripe[*stripe].opt_io_size)
+			break;
+		width_offset -= sc->stripe[*stripe].opt_io_size;
+	}
+
+	return width_offset;
+}
+
+static void asymmetric_stripe_dtr(struct dm_target *ti)
+{
+	unsigned int i;
+	asm_stripe_c *sc = (asm_stripe_c *)ti->private;
+
+	for (i = 0; i < sc->stripes; i++)
+		dm_put_device(ti, sc->stripe[i].dev);
+
+	flush_work(&sc->trigger_event);
+	kfree(sc);
+}
+
+static void asymmetric_stripe_map_sector(asm_stripe_c *sc,
+		sector_t sector,
+		uint32_t *stripe,
+		sector_t *result)
+{
+	sector_t width_offset;
+
+	width_offset = stripe_index_fetch(sc, &sector, stripe);
+
+	*result = sector * sc->stripe[*stripe].opt_io_size + width_offset;
+}
+
+static void asymmetric_stripe_map_range_sector(asm_stripe_c *sc,
+		sector_t sector,
+		uint32_t target_stripe,
+		sector_t *result)
+{
+	sector_t width_offset;
+	uint32_t stripe;
+
+	width_offset = stripe_index_fetch(sc, &sector, &stripe);
+
+	*result = sector * sc->stripe[target_stripe].opt_io_size;
+
+	if (target_stripe < stripe)
+		*result += sc->stripe[target_stripe].opt_io_size;
+	else if (target_stripe == stripe)
+		*result += width_offset;
+}
+
+static int asymmetric_stripe_map_range(asm_stripe_c *sc,
+		struct bio *bio,
+		uint32_t target_stripe)
+{
+	sector_t begin, end;
+
+	asymmetric_stripe_map_range_sector(sc, bio->bi_iter.bi_sector,
+			target_stripe, &begin);
+	asymmetric_stripe_map_range_sector(sc, bio_end_sector(bio),
+			target_stripe, &end);
+	if (begin < end) {
+		bio->bi_bdev = sc->stripe[target_stripe].dev->bdev;
+		bio->bi_iter.bi_sector = begin +
+			sc->stripe[target_stripe].physical_start;
+		bio->bi_iter.bi_size = to_bytes(end - begin);
+		return DM_MAPIO_REMAPPED;
+	}
+
+	/* The range doesn't map to the target stripe */
+	bio_endio(bio);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+static int asymmetric_stripe_map(struct dm_target *ti, struct bio *bio)
+{
+	asm_stripe_c *sc = ti->private;
+	uint32_t stripe;
+	unsigned target_bio_nr;
+
+	if (bio->bi_rw & REQ_FLUSH) {
+		target_bio_nr = dm_bio_get_target_bio_nr(bio);
+		BUG_ON(target_bio_nr >= sc->stripes);
+		bio->bi_bdev = sc->stripe[target_bio_nr].dev->bdev;
+		return DM_MAPIO_REMAPPED;
+	}
+	if (unlikely(bio->bi_rw & REQ_DISCARD) ||
+			unlikely(bio->bi_rw & REQ_WRITE_SAME)) {
+		target_bio_nr = dm_bio_get_target_bio_nr(bio);
+		BUG_ON(target_bio_nr >= sc->stripes);
+		return asymmetric_stripe_map_range(sc, bio, target_bio_nr);
+	}
+
+	asymmetric_stripe_map_sector(sc, bio->bi_iter.bi_sector,
+			&stripe, &bio->bi_iter.bi_sector);
+
+	bio->bi_iter.bi_sector += sc->stripe[stripe].physical_start;
+	bio->bi_bdev = sc->stripe[stripe].dev->bdev;
+
+	return DM_MAPIO_REMAPPED;
+}
+
+/*
+ * Stripe status:
+ *
+ * INFO
+ * #stripes [stripe_name <stripe_name>] [group word count]
+ * [error count 'A|D' <error count 'A|D'>]
+ *
+ * TABLE
+ * #stripes [stripe chunk size] [ratio]
+ * [stripe_name physical_start <stripe_name physical_start>]
+ *
+ */
+
+static void asymmetric_stripe_status(struct dm_target *ti,
+		status_type_t type,
+		unsigned status_flags,
+		char *result,
+		unsigned maxlen)
+{
+	asm_stripe_c *sc = (asm_stripe_c *) ti->private;
+	char buffer[sc->stripes + 1];
+	unsigned int sz = 0;
+	unsigned int i;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%d ", sc->stripes);
+		for (i = 0; i < sc->stripes; i++)  {
+			DMEMIT("%s ", sc->stripe[i].dev->name);
+			buffer[i] = atomic_read(&(sc->stripe[i].error_count))
+				    ? 'D' : 'A';
+		}
+		buffer[i] = '\0';
+		DMEMIT("1 %s", buffer);
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%u %u %s", sc->stripes,
+			sc->chunk_size, sc->ratio_str);
+		for (i = 0; i < sc->stripes; i++)
+			DMEMIT(" %s %lu", sc->stripe[i].dev->name,
+				sc->stripe[i].physical_start);
+		break;
+	}
+}
+
+static int asymmetric_stripe_end_io(struct dm_target *ti,
+		struct bio *bio,
+		int error)
+{
+	unsigned i;
+	char major_minor[16];
+	asm_stripe_c *sc = ti->private;
+
+	if (!error)
+		return 0; /* I/O complete */
+
+	if ((error == -EWOULDBLOCK) && (bio->bi_rw & REQ_RAHEAD))
+		return error;
+
+	if (error == -EOPNOTSUPP)
+		return error;
+
+	memset(major_minor, 0, sizeof(major_minor));
+	snprintf(major_minor, sizeof(major_minor), "%d:%d",
+			MAJOR(disk_devt(bio->bi_bdev->bd_disk)),
+			MINOR(disk_devt(bio->bi_bdev->bd_disk)));
+
+	/*
+	 * Test to see which stripe drive triggered the event
+	 * and increment error count for all stripes on that device.
+	 * If the error count for a given device exceeds the threshold
+	 * value we will no longer trigger any further events.
+	 */
+	for (i = 0; i < sc->stripes; i++)
+		if (!strcmp(sc->stripe[i].dev->name, major_minor)) {
+			atomic_inc(&(sc->stripe[i].error_count));
+			if (atomic_read(&(sc->stripe[i].error_count)) <
+					DM_IO_ERROR_THRESHOLD)
+				schedule_work(&sc->trigger_event);
+		}
+
+	return error;
+}
+
+static int asymmetric_stripe_iterate_devices(struct dm_target *ti,
+		iterate_devices_callout_fn fn,
+		void *data)
+{
+	asm_stripe_c *sc = ti->private;
+	int ret = 0;
+	unsigned i = 0;
+
+	do {
+		ret = fn(ti, sc->stripe[i].dev,
+				sc->stripe[i].physical_start,
+				sc->stripe[i].stripe_width, data);
+	} while (!ret && ++i < sc->stripes);
+
+	return ret;
+}
+
+static void asymmetric_stripe_io_hints(struct dm_target *ti,
+		struct queue_limits *limits)
+{
+	asm_stripe_c *sc = ti->private;
+	unsigned chunk_size = sc->chunk_size << SECTOR_SHIFT;
+
+	blk_limits_io_min(limits, chunk_size);
+	blk_limits_io_opt(limits, chunk_size * sc->total_ratio);
+}
+
+static void asymmetric_stripe_io_len_calculate(struct dm_target *ti,
+		sector_t offset,
+		sector_t *optimal_len)
+{
+	asm_stripe_c *sc = ti->private;
+	sector_t width_offset;
+	uint32_t stripe;
+
+	width_offset = stripe_index_fetch(sc, &offset, &stripe);
+	*optimal_len = sc->stripe[stripe].opt_io_size - width_offset;
+}
+
+static struct target_type asymmetric_stripe_target = {
+	.name	= "asm-striped",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.ctr	= asymmetric_stripe_ctr,
+	.dtr	= asymmetric_stripe_dtr,
+	.map	= asymmetric_stripe_map,
+	.end_io = asymmetric_stripe_end_io,
+	.status = asymmetric_stripe_status,
+	.iterate_devices = asymmetric_stripe_iterate_devices,
+	.io_hints = asymmetric_stripe_io_hints,
+	.io_calculate = asymmetric_stripe_io_len_calculate,
+};
+
+static int __init dm_stripe_asymmetric_init(void)
+{
+	int r;
+
+	r = dm_register_target(&asymmetric_stripe_target);
+	if (r < 0)
+		DMWARN("target registration failed");
+
+	return r;
+}
+
+static void __exit dm_stripe_asymmetric_exit(void)
+{
+	dm_unregister_target(&asymmetric_stripe_target);
+}
+
+module_init(dm_stripe_asymmetric_init);
+module_exit(dm_stripe_asymmetric_exit);
+
+MODULE_AUTHOR("Henry <liuchaowei@smartisan.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 36a20ff5d195..9c5b05db3180 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1393,6 +1393,7 @@ static sector_t max_io_len(sector_t sector, struct dm_target *ti)
 {
 	sector_t len = max_io_len_target_boundary(sector, ti);
 	sector_t offset, max_len;
+	sector_t optimal_len;
 
 	/*
 	 * Does the target need to split even further?
@@ -1407,6 +1408,10 @@ static sector_t max_io_len(sector_t sector, struct dm_target *ti)
 
 		if (len > max_len)
 			len = max_len;
+	} else if (ti->asymmetric_chunk_supported) {
+		offset = dm_target_offset(ti, sector);
+		ti->type->io_calculate(ti, offset, &optimal_len);
+		len = optimal_len;
 	}
 
 	return len;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 5c720864db89..ec6fc5e6b884 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -109,6 +109,14 @@ typedef int (*dm_iterate_devices_fn) (struct dm_target *ti,
 typedef void (*dm_io_hints_fn) (struct dm_target *ti,
 				struct queue_limits *limits);
 
+/*
+ * This function will recalculate io size per bio if this target support
+ * asymmetric chunk size
+ */
+typedef void (*dm_io_len_calculate_fn) (struct dm_target *ti,
+				sector_t offset,
+				sector_t *optimal_len);
+
 /*
  * Returns:
  *    0: The target can handle the next I/O immediately.
@@ -162,6 +170,7 @@ struct target_type {
 	dm_busy_fn busy;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
+	dm_io_len_calculate_fn io_calculate;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
@@ -273,6 +282,12 @@ struct dm_target {
 	 * Set if this target does not return zeroes on discarded blocks.
 	 */
 	bool discard_zeroes_data_unsupported:1;
+
+	/*
+	 * Set if this target supported asymmetric chunk size.
+	 */
+	bool asymmetric_chunk_supported:1;
+
 };
 
 /* Each target can link one of these into the table */
-- 
2.15.1
