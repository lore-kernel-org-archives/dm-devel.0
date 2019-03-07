From: Bryan Gurney <bgurney@redhat.com>
Subject: [RFC PATCH v2] dm: add dust target
Date: Thu,  7 Mar 2019 15:42:39 -0500
Message-ID: <1551991359-19436-1-git-send-email-bgurney@redhat.com>
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
To: snitzer@redhat.com, agk@redhat.com, dm-devel@redhat.com
Cc: jdorminy@redhat.com, jshimkus@redhat.com, tjaskiew@redhat.com, jpittman@redhat.com, Bryan Gurney <bgurney@redhat.com>
List-Id: dm-devel.ids

Add the dm-dust target, which simulates the behavior of bad sectors
at arbitrary locations, and the ability to enable the emulation of
the read failures at an arbitrary time.

This target behaves similarly to a linear target.  At a given time,
the user can send a message to the target to start failing read
requests on specific blocks.  When the failure behavior is enabled,
reads of blocks configured "bad" will fail with EIO.

Writes of blocks configured "bad" will result in the following:

1. Remove the block from the "bad block list".
2. Successfully complete the write.

After this point, the block will successfully contain the written
data, and will service reads and writes normally.  This emulates the
behavior of a "remapped sector" on a hard disk drive.

dm-dust provides logging of which blocks have been added or removed
to the "bad block list", as well as logging when a block has been
removed from the bad block list.  These messages can be used
alongside the messages from the driver using a dm-dust device to
analyze the driver's behavior when a read fails at a given time.

(This logging can be reduced via a "quiet" mode, if desired.)

Changes since v1:
- move dust_add_block kmalloc before lock
- document the queryblock message function
- only search badblocklist when failing bad blocks
- Remove io_hints function to remove limiting
- Add power-of-2 block size from 512 to 1073741824 bytes

NOTE: As a result of removing the limiting, only the first sector
of each "dust block" is detected, if the block size is larger than
512 bytes.  Placing a limiting layer above a dust target to limit the
minimum I/O size to the dust block size will ensure proper emulation
of the given large block size.

Signed-off-by: Joe Shimkus <jshimkus@redhat.com>
Signed-off-by: John Dorminy <jdorminy@redhat.com>
Signed-off-by: John Pittman <jpittman@redhat.com>
Signed-off-by: Thomas Jaskiewicz <tjaskiew@redhat.com>
Signed-off-by: Bryan Gurney <bgurney@redhat.com>
---
 Documentation/device-mapper/dm-dust.txt | 271 +++++++++++++
 drivers/md/Kconfig                      |   9 +
 drivers/md/Makefile                     |   1 +
 drivers/md/dm-dust.c                    | 516 ++++++++++++++++++++++++
 4 files changed, 797 insertions(+)
 create mode 100644 Documentation/device-mapper/dm-dust.txt
 create mode 100644 drivers/md/dm-dust.c

diff --git a/Documentation/device-mapper/dm-dust.txt b/Documentation/device-mapper/dm-dust.txt
new file mode 100644
index 000000000000..e0b6fa0b9f25
--- /dev/null
+++ b/Documentation/device-mapper/dm-dust.txt
@@ -0,0 +1,271 @@
+dm-dust
+=======
+
+This target emulates the behavior of bad sectors at arbitrary
+locations, and the ability to enable the emulation of the failures
+at an arbitrary time.
+
+This target behaves similarly to a linear target.  At a given time,
+the user can send a message to the target to start failing read
+requests on specific blocks (to emulate the behavior of a hard disk
+drive with bad sectors).
+
+When the failure behavior is enabled (i.e.: when the output of
+"dmsetup status" displays "fail_read_on_bad_block"), reads of blocks
+in the "bad block list" will fail with EIO ("Input/output error").
+
+Writes of blocks in the "bad block list will result in the following:
+
+1. Remove the block from the "bad block list".
+2. Successfully complete the write.
+
+This emulates the "remapped sector" behavior of a drive with bad
+sectors.
+
+Normally, a drive that is encountering bad sectors will most likely
+encounter more bad sectors, at an unknown time or location.
+With dm-dust, the user can use the "addbadblock" and "removebadblock"
+messages to add arbitrary bad blocks at new locations, and the
+"enable" and "disable" messages to modulate the state of whether the
+configured "bad blocks" will be treated as bad, or bypassed.
+This allows the pre-writing of test data and metadata prior to
+simulating a "failure" event where bad sectors start to appear.
+
+Table parameters:
+-----------------
+<device_path> <blksz>
+
+Mandatory parameters:
+    <device_path>: path to the block device.
+    <blksz>: block size in bytes
+	     (minimum 512, maximum 1073741824, must be a power of 2)
+
+Usage instructions:
+-------------------
+
+First, find the size (in 512-byte sectors) of the device to be used:
+
+$ sudo blockdev --getsz /dev/vdb1
+33552384
+
+Create the dm-dust device:
+(For a device with a block size of 512 bytes)
+$ sudo dmsetup create dust1 --table '0 33552384 dust /dev/vdb1 512'
+
+(For a device with a block size of 4096 bytes)
+$ sudo dmsetup create dust1 --table '0 33552384 dust /dev/vdb1 4096'
+
+Check the status of the read behavior ("bypass" indicates that all I/O
+will be passed through to the underlying device):
+$ sudo dmsetup status dust1
+0 33552384 dust 252:17 bypass
+
+$ sudo dd if=/dev/mapper/dust1 of=/dev/null bs=512 count=128 iflag=direct
+128+0 records in
+128+0 records out
+
+$ sudo dd if=/dev/zero of=/dev/mapper/dust1 bs=512 count=128 oflag=direct
+128+0 records in
+128+0 records out
+
+Adding and removing bad blocks:
+-------------------------------
+
+At any time (i.e.: whether the device has the "bad block" emulation
+enabled or disabled), bad blocks may be added or removed from the
+device via the "addbadblock" and "removebadblock" messages:
+
+$ sudo dmsetup message dust1 0 addbadblock 60
+kernel: device-mapper: dust: badblock added at block 60
+
+$ sudo dmsetup message dust1 0 addbadblock 67
+kernel: device-mapper: dust: badblock added at block 67
+
+$ sudo dmsetup message dust1 0 addbadblock 72
+kernel: device-mapper: dust: badblock added at block 72
+
+These bad blocks will be stored in the "bad block list".
+While the device is in "bypass" mode, reads and writes will succeed:
+
+$ sudo dmsetup status dust1
+0 33552384 dust 252:17 bypass
+
+Enabling block read failures:
+-----------------------------
+
+To enable the "fail read on bad block" behavior, send the "enable" message:
+
+$ sudo dmsetup message dust1 0 enable
+kernel: device-mapper: dust: enabling read failures on bad sectors
+
+$ sudo dmsetup status dust1
+0 33552384 dust 252:17 fail_read_on_bad_block
+
+With the device in "fail read on bad block" mode, attempting to read a
+block will encounter an "Input/output error":
+
+$ sudo dd if=/dev/mapper/dust1 of=/dev/null bs=512 count=1 skip=67 iflag=direct
+dd: error reading '/dev/mapper/dust1': Input/output error
+0+0 records in
+0+0 records out
+0 bytes copied, 0.00040651 s, 0.0 kB/s
+
+...and writing to the bad blocks will remove the blocks from the list,
+therefore emulating the "remap" behavior of hard disk drives:
+
+$ sudo dd if=/dev/zero of=/dev/mapper/dust1 bs=512 count=128 oflag=direct
+128+0 records in
+128+0 records out
+
+kernel: device-mapper: dust: block 60 removed from badblocklist by write
+kernel: device-mapper: dust: block 67 removed from badblocklist by write
+kernel: device-mapper: dust: block 72 removed from badblocklist by write
+kernel: device-mapper: dust: block 87 removed from badblocklist by write
+
+Bad block add/remove error handling:
+------------------------------------
+
+Attempting to add a bad block that already exists in the list will
+result in an "Invalid argument" error, as well as a helpful message:
+
+$ sudo dmsetup message dust1 0 addbadblock 88
+device-mapper: message ioctl on dust1  failed: Invalid argument
+kernel: device-mapper: dust: block 88 already in badblocklist
+
+Attempting to remove a bad block that doesn't exist in the list will
+result in an "Invalid argument" error, as well as a helpful message:
+
+$ sudo dmsetup message dust1 0 removebadblock 87
+device-mapper: message ioctl on dust1  failed: Invalid argument
+kernel: device-mapper: dust: block 87 not found in badblocklist
+
+Counting the number of bad blocks in the bad block list:
+--------------------------------------------------------
+
+To count the number of bad blocks configured in the device, run the
+following message command:
+
+$ sudo dmsetup message dust1 0 countbadblocks
+
+A message will print with the number of bad blocks currently
+configured on the device:
+
+kernel: device-mapper: dust: countbadblocks: 895 badblock(s) found
+
+Querying for specific bad blocks:
+---------------------------------
+
+To find out if a specific block is in the bad block list, run the
+following message command:
+
+$ sudo dmsetup message dust1 0 queryblock 72
+
+The following message will print if the block is in the list:
+device-mapper: dust: queryblock: block 72 found in badblocklist
+
+The following message will print if the block is in the list:
+device-mapper: dust: queryblock: block 72 not found in badblocklist
+
+The "queryblock" message command will work in both the "enabled"
+and "disabled" modes, allowing the verification of whether a block
+will be treated as "bad" without having to issue I/O to the device,
+or having to "enable" the bad block emulation.
+
+Clearing the bad block list:
+----------------------------
+
+To clear the bad block list (without needing to individually run
+a "removebadblock" message command for every block), run the
+following message command:
+
+$ sudo dmsetup message dust1 0 clearbadblocks
+
+After clearing the bad block list, the following message will appear:
+
+kernel: device-mapper: dust: clearbadblocks: badblocks cleared
+
+If there were no bad blocks to clear, the following message will
+appear:
+
+kernel: device-mapper: dust: clearbadblocks: no badblocks found
+
+Message commands list:
+----------------------
+
+Below is a list of the messages that can be sent to a dust device:
+
+Operations on blocks (requires a <blknum> argument):
+
+addbadblock <blknum>
+queryblock <blknum>
+removebadblock <blknum>
+
+...where <blknum> is a block number within range of the device
+  (corresponding to the block size of the device.)
+
+Single argument message commands:
+
+countbadblocks
+clearbadblocks
+disable
+enable
+quiet
+
+Device removal:
+---------------
+
+When finished, remove the device via the "dmsetup remove" command:
+
+$ sudo dmsetup remove dust1
+
+Quiet mode:
+-----------
+
+On test runs with many bad blocks, it may be desirable to avoid
+excessive logging (from bad blocks added, removed, or "remapped").
+This can be done by enabling "quiet mode" via the following message:
+
+$ sudo dmsetup message dust1 0 quiet
+
+This will suppress log messages from add / remove / removed by write
+operations.  Log messages from "countbadblocks" or "queryblock"
+message commands will still print in quiet mode.
+
+The status of quiet mode can be seen by running "dmsetup status":
+
+$ sudo dmsetup status dust1
+0 33552384 dust 252:17 fail_read_on_bad_block quiet
+
+To disable quiet mode, send the "quiet" message again:
+
+$ sudo dmsetup message dust1 0 quiet
+
+$ sudo dmsetup status dust1
+0 33552384 dust 252:17 fail_read_on_bad_block verbose
+
+(The presence of "verbose" indicates normal logging.)
+
+"Why not...?"
+-------------
+
+scsi_debug has a "medium error" mode that can fail reads on one
+specified sector (sector 0x1234, hardcoded in the source code), but
+it uses RAM for the persistent storage, which drastically decreases
+the potential device size.
+
+dm-flakey fails all I/O from all block locations at a specified time
+frequency, and not a given point in time.
+
+When a bad sector occurs on a hard disk drive, reads to that sector
+are failed by the device, usually resulting in an error code of EIO
+("I/O error") or ENODATA ("No data available").  However, a write to
+the sector may succeed, and result in the sector becoming readable
+after the device controller no longer experiences errors reading the
+sector (or after a reallocation of the sector).  However, there may
+be bad sectors that occur on the device in the future, in a different,
+unpredictable location.
+
+This target seeks to provide a device that can exhibit the behavior
+of a bad sector at a known sector location, at a known time, based
+on a large storage device (at least tens of gigabytes, not occupying
+system memory).
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 2557f198e175..db269a348b20 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -436,6 +436,15 @@ config DM_DELAY
 
 	If unsure, say N.
 
+config DM_DUST
+	tristate "Bad sector simulation target"
+	depends on BLK_DEV_DM
+	---help---
+	A target that simulates bad sector behavior.
+	Useful for testing.
+
+	If unsure, say N.
+
 config DM_INIT
 	bool "DM \"dm-mod.create=\" parameter support"
 	depends on BLK_DEV_DM=y
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index a52b703e588e..be7a6eb92abc 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -48,6 +48,7 @@ obj-$(CONFIG_DM_BUFIO)		+= dm-bufio.o
 obj-$(CONFIG_DM_BIO_PRISON)	+= dm-bio-prison.o
 obj-$(CONFIG_DM_CRYPT)		+= dm-crypt.o
 obj-$(CONFIG_DM_DELAY)		+= dm-delay.o
+obj-$(CONFIG_DM_DUST)		+= dm-dust.o
 obj-$(CONFIG_DM_FLAKEY)		+= dm-flakey.o
 obj-$(CONFIG_DM_MULTIPATH)	+= dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_QL)	+= dm-queue-length.o
diff --git a/drivers/md/dm-dust.c b/drivers/md/dm-dust.c
new file mode 100644
index 000000000000..662406aae660
--- /dev/null
+++ b/drivers/md/dm-dust.c
@@ -0,0 +1,516 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2018 Red Hat, Inc.
+ *
+ * This is a test "dust" device, which fails reads on specified
+ * sectors, emulating the behavior of a hard disk drive sending
+ * a "Read Medium Error" sense.
+ *
+ */
+
+#include <linux/device-mapper.h>
+#include <linux/module.h>
+#include <linux/version.h>
+#include <linux/rbtree.h>
+
+#define DM_MSG_PREFIX "dust"
+
+struct badblock {
+	struct rb_node node;
+	sector_t bb;
+};
+
+struct dust_device {
+	struct dm_dev *dev;
+	bool fail_read_on_bb;
+	struct rb_root badblocklist;
+	unsigned long long badblock_count;
+	spinlock_t dust_lock;
+	unsigned int blksz;
+	unsigned int sect_per_block;
+	bool quiet_mode;
+};
+
+struct badblock *dust_rb_search(struct rb_root *root, sector_t blk)
+{
+	struct rb_node *node = root->rb_node;
+
+	while (node) {
+		struct badblock *bblk = rb_entry(node, struct badblock, node);
+
+		if (bblk->bb > blk)
+			node = node->rb_left;
+		else if (bblk->bb < blk)
+			node = node->rb_right;
+		else
+			return bblk;
+	}
+	return NULL;
+}
+
+bool dust_rb_insert(struct rb_root *root, struct badblock *new)
+{
+	struct badblock *bblk;
+	struct rb_node **link = &root->rb_node, *parent = NULL;
+	sector_t value = new->bb;
+
+	while (*link) {
+		parent = *link;
+		bblk = rb_entry(parent, struct badblock, node);
+
+		if (bblk->bb > value)
+			link = &(*link)->rb_left;
+		else if (bblk->bb < value)
+			link = &(*link)->rb_right;
+		else
+			return false;
+	}
+
+	rb_link_node(&new->node, parent, link);
+	rb_insert_color(&new->node, root);
+	return true;
+}
+
+static int dust_remove_block(struct dust_device *dd, unsigned long long block)
+{
+	struct badblock *bblock;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dd->dust_lock, flags);
+	bblock = dust_rb_search(&dd->badblocklist, block * dd->sect_per_block);
+
+	if (bblock == NULL) {
+		if (!dd->quiet_mode)
+			DMERR("removebadblock: block %llu not found in badblocklist",
+			      block);
+		spin_unlock_irqrestore(&dd->dust_lock, flags);
+		return -EINVAL;
+	}
+
+	rb_erase(&bblock->node, &dd->badblocklist);
+	dd->badblock_count--;
+	if (!dd->quiet_mode)
+		DMINFO("removebadblock: badblock removed at block %llu", block);
+	kfree(bblock);
+	spin_unlock_irqrestore(&dd->dust_lock, flags);
+	return 0;
+}
+
+static int dust_add_block(struct dust_device *dd, unsigned long long block)
+{
+	struct badblock *bblock;
+	unsigned long flags;
+
+	bblock = kmalloc(sizeof(*bblock), GFP_KERNEL);
+	if (bblock == NULL) {
+		if (!dd->quiet_mode)
+			DMERR("addbadblock: badblock allocation failed");
+		return -ENOMEM;
+	}
+
+	spin_lock_irqsave(&dd->dust_lock, flags);
+	bblock->bb = block * dd->sect_per_block;
+	if (!dust_rb_insert(&dd->badblocklist, bblock)) {
+		if (!dd->quiet_mode)
+			DMERR("addbadblock: block %llu already in badblocklist",
+			      block);
+		spin_unlock_irqrestore(&dd->dust_lock, flags);
+		kfree(bblock);
+		return -EINVAL;
+	}
+
+	dd->badblock_count++;
+	if (!dd->quiet_mode)
+		DMINFO("addbadblock: badblock added at block %llu", block);
+	spin_unlock_irqrestore(&dd->dust_lock, flags);
+	return 0;
+}
+
+static int dust_query_block(struct dust_device *dd, unsigned long long block)
+{
+	struct badblock *bblock;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dd->dust_lock, flags);
+	bblock = dust_rb_search(&dd->badblocklist, block * dd->sect_per_block);
+
+	if (bblock != NULL)
+		DMINFO("queryblock: block %llu found in badblocklist", block);
+	else
+		DMINFO("queryblock: block %llu not found in badblocklist",
+		       block);
+
+	spin_unlock_irqrestore(&dd->dust_lock, flags);
+	return 0;
+}
+
+static int dust_mod_r_failbad(struct dust_device *dd, sector_t thisblock)
+{
+	unsigned long flags;
+	struct badblock *bblk;
+
+	spin_lock_irqsave(&dd->dust_lock, flags);
+	bblk = dust_rb_search(&dd->badblocklist, thisblock);
+
+	if (bblk) {
+		spin_unlock_irqrestore(&dd->dust_lock, flags);
+		return DM_MAPIO_KILL;
+	}
+
+	spin_unlock_irqrestore(&dd->dust_lock, flags);
+	return DM_MAPIO_REMAPPED;
+}
+
+static int dust_map_read(struct dust_device *dd, sector_t thisblock,
+			 bool fail_read_on_bb)
+{
+	int ret;
+
+	if (fail_read_on_bb) {
+		ret = dust_mod_r_failbad(dd, thisblock);
+		return ret;
+	}
+
+	return DM_MAPIO_REMAPPED;
+}
+
+static void dust_mod_w_remapbad(struct dust_device *dd, sector_t thisblock)
+{
+	unsigned long flags;
+	struct badblock *bblk;
+
+	spin_lock_irqsave(&dd->dust_lock, flags);
+	bblk = dust_rb_search(&dd->badblocklist, thisblock);
+
+	if (bblk) {
+		rb_erase(&bblk->node, &dd->badblocklist);
+		dd->badblock_count--;
+		kfree(bblk);
+		if (!dd->quiet_mode)
+			DMINFO("block %llu removed from badblocklist by write",
+				(unsigned long long)thisblock / dd->sect_per_block);
+}
+
+	spin_unlock_irqrestore(&dd->dust_lock, flags);
+}
+
+static int dust_map_write(struct dust_device *dd, sector_t thisblock,
+			  bool fail_read_on_bb)
+{
+	if (fail_read_on_bb)
+		dust_mod_w_remapbad(dd, thisblock);
+
+	return DM_MAPIO_REMAPPED;
+}
+
+static inline void dust_set_biosector(struct bio *bio, sector_t sector)
+{
+	bio->bi_iter.bi_sector = sector;
+}
+
+static inline sector_t dust_get_biosector(struct bio *bio)
+{
+	return bio->bi_iter.bi_sector;
+}
+
+static int __dust_clear_badblocks(struct rb_root *tree,
+				  unsigned long long count)
+{
+	struct rb_node *node = NULL, *nnode = NULL;
+
+	nnode = rb_first(tree);
+	if (nnode == NULL) {
+		BUG_ON(count != 0);
+		return 0;
+	}
+
+	while (nnode) {
+		node = nnode;
+		nnode = rb_next(node);
+		rb_erase(node, tree);
+		count--;
+		kfree(node);
+	}
+	BUG_ON(count != 0);
+	BUG_ON(tree->rb_node != NULL);
+	return 1;
+}
+
+static int dust_clear_badblocks(struct dust_device *dd)
+{
+	unsigned long flags;
+	struct rb_root badblocklist;
+	unsigned long long badblock_count;
+
+	spin_lock_irqsave(&dd->dust_lock, flags);
+	badblocklist = dd->badblocklist;
+	badblock_count = dd->badblock_count;
+	dd->badblocklist = RB_ROOT;
+	dd->badblock_count = 0;
+	spin_unlock_irqrestore(&dd->dust_lock, flags);
+
+	if (__dust_clear_badblocks(&badblocklist, badblock_count) == 0)
+		DMINFO("clearbadblocks: no badblocks found");
+	else
+		DMINFO("clearbadblocks: badblocks cleared");
+	return 0;
+}
+
+/*
+ * Target parameters:
+ *
+ * <device_path> <blksz>
+ *
+ * device_path: path to the block device
+ * blksz: block size
+ * 	  (minimum 512, maximum 1073741824, must be a power of 2)
+ */
+static int dust_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	struct dust_device *dd;
+	const char *device_path = argv[0];
+	unsigned int blksz;
+	unsigned int sect_per_block;
+	sector_t DUST_MAX_BLKSZ_SECTORS = 2097152;
+	sector_t max_block_sectors = min(ti->len, DUST_MAX_BLKSZ_SECTORS);
+
+	if (argc != 2) {
+		ti->error = "requires exactly 2 arguments";
+		return -EINVAL;
+	}
+
+	if (kstrtouint(argv[1], 10, &blksz) || !blksz) {
+		ti->error =
+			"Invalid block size parameter";
+		return -EINVAL;
+	}
+
+	if (blksz < 512) {
+		ti->error = "Block size must be at least 512";
+		return -EINVAL;
+	}
+
+	if (!is_power_of_2(blksz)) {
+		ti->error = "Block size must be a power of 2";
+		return -EINVAL;
+	}
+
+	if (to_sector(blksz) > max_block_sectors) {
+		ti->error = "Block size is too large";
+		return -EINVAL;
+	}
+
+	sect_per_block = (blksz >> SECTOR_SHIFT);
+
+	dd = kzalloc(sizeof(struct dust_device), GFP_KERNEL);
+
+	if (dd == NULL) {
+		ti->error = "Cannot allocate context";
+		return -ENOMEM;
+	}
+
+	if (dm_get_device(ti, device_path, dm_table_get_mode(ti->table),
+			  &dd->dev)) {
+		ti->error = "Device lookup failed";
+		kfree(dd);
+		return -EINVAL;
+	}
+
+	dd->sect_per_block = sect_per_block;
+	dd->blksz = blksz;
+
+	// Whether to fail a read on a "bad" block.
+	// Defaults to false; enabled later by message.
+	dd->fail_read_on_bb = false;
+
+	// Bad block list rbtree.
+	// Just initialize for now.
+	dd->badblocklist = RB_ROOT;
+	dd->badblock_count = 0;
+	spin_lock_init(&dd->dust_lock);
+
+	dd->quiet_mode = false;
+
+	BUG_ON(dm_set_target_max_io_len(ti, dd->sect_per_block) != 0);
+
+	ti->num_discard_bios = 1;
+	ti->num_flush_bios = 1;
+	ti->private = dd;
+	return 0;
+}
+
+static void dust_dtr(struct dm_target *ti)
+{
+	struct dust_device *dd = ti->private;
+
+	__dust_clear_badblocks(&dd->badblocklist, dd->badblock_count);
+	dm_put_device(ti, dd->dev);
+	kfree(dd);
+}
+
+static int dust_map(struct dm_target *ti, struct bio *bio)
+{
+	struct dust_device *dd;
+	sector_t thisblock;
+	int ret;
+
+	dd = ti->private;
+	bio_set_dev(bio, dd->dev->bdev);
+	dust_set_biosector(bio, dm_target_offset(ti, dust_get_biosector(bio)));
+	thisblock = dust_get_biosector(bio);
+
+	if (bio_data_dir(bio) == READ)
+		ret = dust_map_read(dd, thisblock, dd->fail_read_on_bb);
+	if (bio_data_dir(bio) == WRITE)
+		ret = dust_map_write(dd, thisblock, dd->fail_read_on_bb);
+
+	return ret;
+}
+
+static int dust_message(struct dm_target *ti, unsigned int argc, char **argv,
+		   char *result_buf, unsigned int maxlen)
+{
+	struct dust_device *dd = ti->private;
+	sector_t size = i_size_read(dd->dev->bdev->bd_inode) >> SECTOR_SHIFT;
+	bool invalid_msg = false;
+	int result = -EINVAL;
+	unsigned long long tmp, block;
+	unsigned long flags;
+	char dummy;
+
+	if (argc == 1) {
+		if (!strcasecmp(argv[0], "addbadblock") ||
+		    !strcasecmp(argv[0], "removebadblock") ||
+		    !strcasecmp(argv[0], "queryblock")) {
+			DMERR("%s requires an additional argument", argv[0]);
+		} else if (!strcasecmp(argv[0], "disable")) {
+			DMINFO("disabling read failures on bad sectors");
+			dd->fail_read_on_bb = false;
+			result = 0;
+		} else if (!strcasecmp(argv[0], "enable")) {
+			DMINFO("enabling read failures on bad sectors");
+			dd->fail_read_on_bb = true;
+			result = 0;
+		} else if (!strcasecmp(argv[0], "countbadblocks")) {
+			spin_lock_irqsave(&dd->dust_lock, flags);
+			DMINFO("countbadblocks: %llu badblock(s) found",
+			       dd->badblock_count);
+			spin_unlock_irqrestore(&dd->dust_lock, flags);
+			result = 0;
+		} else if (!strcasecmp(argv[0], "clearbadblocks")) {
+			result = dust_clear_badblocks(dd);
+		} else if (!strcasecmp(argv[0], "quiet")) {
+			if (!dd->quiet_mode)
+				dd->quiet_mode = true;
+			else
+				dd->quiet_mode = false;
+			result = 0;
+		} else {
+			invalid_msg = true;
+		}
+	} else if (argc == 2) {
+		if (sscanf(argv[1], "%llu%c", &tmp, &dummy) != 1)
+			return result;
+
+		block = tmp;
+
+		if (block > size / dd->sect_per_block || block < 0) {
+			DMERR("selected block value out of range");
+			return result;
+		}
+
+		if (!strcasecmp(argv[0], "addbadblock"))
+			result = dust_add_block(dd, block);
+		else if (!strcasecmp(argv[0], "removebadblock"))
+			result = dust_remove_block(dd, block);
+		else if (!strcasecmp(argv[0], "queryblock"))
+			result = dust_query_block(dd, block);
+		else
+			invalid_msg = true;
+
+	} else {
+		DMERR("invalid number of arguments '%d'", argc);
+	}
+
+	if (invalid_msg)
+		DMERR("unrecognized dmsetup message '%s' received", argv[0]);
+
+	return result;
+}
+
+static void dust_status(struct dm_target *ti, status_type_t type,
+		   unsigned int status_flags, char *result, unsigned int maxlen)
+{
+	struct dust_device *dd = ti->private;
+	unsigned int sz = 0; // used by the DMEMIT macro
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		DMEMIT("%s %s %s", dd->dev->name,
+		       dd->fail_read_on_bb ? "fail_read_on_bad_block" :
+					     "bypass",
+		       dd->quiet_mode ? "quiet" : "verbose");
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s %u", dd->dev->name, dd->blksz);
+		break;
+	}
+}
+
+static int dust_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
+{
+	struct dust_device *dd = ti->private;
+	struct dm_dev *dev = dd->dev;
+
+	*bdev = dev->bdev;
+
+	// Only pass ioctls through if the device sizes match exactly.
+	if (ti->len != i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT)
+		return 1;
+
+	return 0;
+}
+
+static int dust_iterate_devices(struct dm_target *ti, iterate_devices_callout_fn fn,
+			   void *data)
+{
+	struct dust_device *dd = ti->private;
+
+	return fn(ti, dd->dev, 0, ti->len, data);
+}
+
+static struct target_type dust_target = {
+	.name = "dust",
+	.version = { 1, 0, 0 },
+	.module = THIS_MODULE,
+	.ctr = dust_ctr,
+	.dtr = dust_dtr,
+	.iterate_devices = dust_iterate_devices,
+	.map = dust_map,
+	.message = dust_message,
+	.status = dust_status,
+	.prepare_ioctl = dust_prepare_ioctl,
+};
+
+int __init dm_dust_init(void)
+{
+	int result = dm_register_target(&dust_target);
+
+	if (result < 0)
+		DMERR("dm_register_target failed %d", result);
+
+	return result;
+}
+
+void __exit dm_dust_exit(void)
+{
+	dm_unregister_target(&dust_target);
+}
+
+module_init(dm_dust_init);
+module_exit(dm_dust_exit);
+
+MODULE_DESCRIPTION(DM_NAME " dust testing device");
+MODULE_AUTHOR("Red Hat, Inc.");
+MODULE_LICENSE("GPL");
-- 
2.17.2
