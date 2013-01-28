From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: zeroed target
Date: Mon, 28 Jan 2013 16:56:56 -0500 (EST)
Message-ID: <Pine.LNX.4.64.1301281654150.28270@file.rdu.redhat.com>
References: <20130125135311.GH3122@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130125135311.GH3122@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, linux-lvm@redhat.com
List-Id: dm-devel.ids

Hi

Here I'm sending updated dm-zeroed target.

Mikulas

---

dm-zeroed target

Dm-zeroed target provides a device that returns zeroed in areas that have not
yet been written. It maintains a log containing bitmap of written areas.

Use:
the target accepts four arguments:
sectors_per_data_block sectors_per_metadata_block data_device metadata_device

On first use, zero the first 512 bytes of the metadata device. The target will
then auto-initialize the metadata device.

We may resize data or metadata device, if we are resizing, the target must be
suspended and resumed. It detects new sizes on resume.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 Documentation/device-mapper/zeroed.txt |   47 +
 drivers/md/Kconfig                     |    7 
 drivers/md/Makefile                    |    1 
 drivers/md/dm-zeroed.c                 | 1153 +++++++++++++++++++++++++++++++++
 4 files changed, 1208 insertions(+)

Index: linux-3.8-rc5-fast/drivers/md/Kconfig
===================================================================
--- linux-3.8-rc5-fast.orig/drivers/md/Kconfig	2013-01-25 23:47:23.000000000 +0100
+++ linux-3.8-rc5-fast/drivers/md/Kconfig	2013-01-28 20:32:03.000000000 +0100
@@ -369,6 +369,13 @@ config DM_DELAY
 
 	If unsure, say N.
 
+config DM_ZEROED
+	tristate "Zeroed target"
+	depends on BLK_DEV_DM
+	select DM_BUFIO
+	---help---
+	  This target initializes all blocks with zeros.
+
 config DM_UEVENT
 	bool "DM uevents"
 	depends on BLK_DEV_DM
Index: linux-3.8-rc5-fast/drivers/md/Makefile
===================================================================
--- linux-3.8-rc5-fast.orig/drivers/md/Makefile	2013-01-25 23:47:23.000000000 +0100
+++ linux-3.8-rc5-fast/drivers/md/Makefile	2013-01-28 20:32:03.000000000 +0100
@@ -46,6 +46,7 @@ obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 obj-$(CONFIG_DM_RAID)	+= dm-raid.o
 obj-$(CONFIG_DM_THIN_PROVISIONING)	+= dm-thin-pool.o
 obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
+obj-$(CONFIG_DM_ZEROED)		+= dm-zeroed.o
 
 ifeq ($(CONFIG_DM_UEVENT),y)
 dm-mod-objs			+= dm-uevent.o
Index: linux-3.8-rc5-fast/drivers/md/dm-zeroed.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.8-rc5-fast/drivers/md/dm-zeroed.c	2013-01-28 20:51:10.000000000 +0100
@@ -0,0 +1,1153 @@
+/*
+ * Copyright (C) 2011 Red Hat Czech, s.r.o.
+ *
+ * Mikulas Patocka <mpatocka@redhat.com>
+ *
+ * This file is released under the GPL.
+ */
+
+#include <linux/device-mapper.h>
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/bio.h>
+#include <linux/dm-io.h>
+
+#include "dm-bufio.h"
+
+#define DM_MSG_PREFIX "zeroed"
+
+#define DM_ZEROED_SUPERBLOCK_MAGIC	cpu_to_be32(0xF21)
+
+/*
+ * On-disk superblock format
+ */
+struct dm_zeroed_superblock {
+	__be32 magic;
+	__le32 sectors_per_data_chunk;
+	__le32 sectors_per_metadata_chunk;
+	__le32 pad;
+	__le64 device_sectors;
+};
+
+/*
+ * In-memory target structure
+ */
+struct dm_zeroed {
+	struct dm_dev *dev;
+	struct dm_dev *log;
+
+	unsigned sectors_per_data_chunk;
+	unsigned sectors_per_metadata_chunk;
+	unsigned char sectors_per_data_chunk_bits;
+	unsigned char sectors_per_metadata_chunk_bits;
+	sector_t device_sectors;
+
+	struct bio_set *bioset;
+	struct dm_io_client *dm_io;
+	struct workqueue_struct *workqueue;
+	struct dm_bufio_client *bufio;
+
+	/*
+	 * This tree holds all write requests that toggle log bits.
+	 */
+	struct mutex range_tree_lock;
+	struct rb_root range_tree;
+	struct list_head overlaping_requests;
+
+	/*
+	 * The queue of write requests that tohhle bits after their completion.
+	 */
+	spinlock_t flush_request_lock;
+	struct list_head flush_request_list;
+	struct work_struct flush_work;
+};
+
+/*
+ * A structure for one read or write request.
+ */
+struct dm_zeroed_request {
+	struct work_struct work;
+
+	struct dm_zeroed *z;
+
+	bio_end_io_t *original_bi_end_io;
+	void *original_bi_private;
+	sector_t original_sector;
+	unsigned original_n_sectors;
+
+	atomic_t outstanding;
+	int error;
+
+	struct rb_node tree_node;
+	struct list_head list_entry;
+};
+
+static void zeroed_work(struct work_struct *work);
+static void read_end_io(struct bio *new_bio, int error);
+static void read_dec_outstanding(struct dm_zeroed_request *rq);
+static void zero_end_io(unsigned long error, void *context);
+static void write_end_io(struct bio *bio, int error);
+static void write_dec_outstanding(struct dm_zeroed_request *rq);
+static void zeroed_flush(struct work_struct *work);
+static void write_end_request(struct dm_zeroed_request *rq, int r);
+static void resume_overlappnig_requests(struct dm_zeroed *z);
+
+static struct page_list zero_page_list;
+
+/*
+ * Returns a log block number for a given sector number.
+ */
+static sector_t log_block(struct dm_zeroed *z, sector_t sector)
+{
+	sector_t chunk = sector >> z->sectors_per_data_chunk_bits;
+	return (chunk >>
+		(z->sectors_per_metadata_chunk_bits + SECTOR_SHIFT + 3)) + 1;
+}
+
+/*
+ * Returns a bit position in log for a given sector number.
+ */
+static unsigned log_position(struct dm_zeroed *z, sector_t sector)
+{
+	sector_t chunk = sector >> z->sectors_per_data_chunk_bits;
+	return chunk &
+		((z->sectors_per_metadata_chunk << (SECTOR_SHIFT + 3)) - 1);
+}
+
+/*
+ * Read a log block with dm-bufio.
+ */
+static void *read_log_block(struct dm_zeroed *z, sector_t sector, unsigned *pos,
+			    struct dm_buffer **bp)
+{
+	sector_t chunk = log_block(z, sector);
+	*pos = log_position(z, sector);
+
+	return dm_bufio_read(z->bufio, chunk, bp);
+}
+
+/*
+ * Get a log block from cache but don't read it from disk.
+ */
+static void *get_log_block(struct dm_zeroed *z, sector_t sector, unsigned *pos,
+			   struct dm_buffer **bp)
+{
+	void *log;
+	sector_t chunk = log_block(z, sector);
+	*pos = log_position(z, sector);
+
+	log = dm_bufio_get(z->bufio, chunk, bp);
+	if (!log)
+		dm_bufio_prefetch(z->bufio, chunk, 1);
+	return log;
+}
+
+/*
+ * Read the superblock.
+ */
+static struct dm_zeroed_superblock *read_superblock(struct dm_zeroed *z,
+						    bool allow_uninit,
+						    struct dm_buffer **bp)
+{
+	struct dm_zeroed_superblock *s;
+	s = dm_bufio_read(z->bufio, 0, bp);
+	if (IS_ERR(s))
+		return s;
+	if (s->magic != DM_ZEROED_SUPERBLOCK_MAGIC) {
+		if (allow_uninit) {
+			int i;
+			for (i = 0; i < 1 << SECTOR_SHIFT; i++)
+				if (((char *)s)[i] != 0)
+					goto bad_magic;
+			goto return_ok;
+		}
+bad_magic:
+		DMERR("Bad superblock magic %x", be32_to_cpu(s->magic));
+		dm_bufio_release(*bp);
+		return ERR_PTR(-EINVAL);
+	}
+return_ok:
+	return s;
+}
+
+/*
+ * Return the required size of log in sectors.
+ */
+static sector_t minimum_log_sectors(struct dm_zeroed *z,
+				    sector_t device_sectors)
+{
+	sector_t log_blocks =
+		device_sectors ? log_block(z, device_sectors - 1) + 1 : 1;
+	return log_blocks << z->sectors_per_metadata_chunk_bits;
+}
+
+/*
+ * Zero the requested range on the device.
+ *
+ * If fn != NULL, fn(context) is called on completion.
+ * If fn == NULL, the operation is performed synchronously.
+ */
+static int zero_sectors(struct dm_zeroed *z, sector_t start, sector_t count,
+			io_notify_fn fn, void *context)
+{
+	struct dm_io_request req;
+	struct dm_io_region dest;
+
+	req.bi_rw = WRITE;
+	req.mem.type = DM_IO_PAGE_LIST;
+	req.mem.offset = 0;
+	req.mem.ptr.pl = &zero_page_list;
+	req.notify.fn = fn;
+	req.notify.context = context;
+	req.client = z->dm_io;
+
+	dest.bdev = z->dev->bdev;
+	dest.sector = start;
+	dest.count = count;
+
+	return dm_io(&req, 1, &dest, NULL);
+}
+
+/*
+ * Issue cache flush on the device.
+ */
+static int issue_device_flush_sync(struct dm_zeroed *z)
+{
+	struct dm_io_request req;
+	struct dm_io_region dest;
+
+	req.bi_rw = REQ_FLUSH;
+	req.mem.type = DM_IO_KMEM;
+	req.mem.ptr.addr = NULL;
+	req.notify.fn = NULL;
+	req.client = z->dm_io;
+
+	dest.bdev = z->dev->bdev;
+	dest.sector = 0;
+	dest.count = 0;
+
+	return dm_io(&req, 1, &dest, NULL);
+}
+
+/*
+ * Zero the last chunk when extending the device.
+ * If the device size wasn't a multiple of chunk size and we extend the device,
+ * we must zero a part of the last chunk.
+ */
+static int zero_trailing_chunk(struct dm_zeroed *z, sector_t device_sectors)
+{
+	if (z->device_sectors & (z->sectors_per_data_chunk - 1)) {
+		int r;
+		unsigned n_sectors;
+
+		n_sectors = -z->device_sectors &
+					(z->sectors_per_data_chunk - 1);
+		if (n_sectors > device_sectors - z->device_sectors)
+			n_sectors = device_sectors - z->device_sectors;
+
+		r = zero_sectors(z, z->device_sectors, n_sectors,
+				 NULL, NULL);
+		if (unlikely(r))
+			return r;
+		r = issue_device_flush_sync(z);
+		if (unlikely(r))
+			return r;
+	}
+
+	return 0;
+}
+
+/*
+ * Perform device extension.
+ */
+static int extend_device(struct dm_zeroed *z, sector_t device_sectors)
+{
+	int r;
+	sector_t s = z->device_sectors;
+
+	r = zero_trailing_chunk(z, device_sectors);
+	if (r)
+		return r;
+
+	do {
+		void *log;
+		unsigned pos;
+		struct dm_buffer *bp;
+
+		log = read_log_block(z, s, &pos, &bp);
+		if (IS_ERR(log))
+			return PTR_ERR(log);
+
+		if (!pos) {
+			memset(log, 0,
+				z->sectors_per_metadata_chunk << SECTOR_SHIFT);
+			s +=
+			    z->sectors_per_metadata_chunk << (SECTOR_SHIFT + 3);
+		} else while (pos <
+			z->sectors_per_metadata_chunk << (SECTOR_SHIFT + 3)) {
+			__clear_bit_le(pos, log);
+			s++;
+			pos++;
+		}
+
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+	} while (s && s < device_sectors);
+
+	return 0;
+}
+
+/*
+ * A target constructor.
+ */
+static int zeroed_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	int r;
+	struct dm_zeroed *z;
+	unsigned long sectors_per_data_chunk;
+	unsigned long sectors_per_metadata_chunk;
+	char *endstr;
+
+	struct dm_buffer *bp;
+	struct dm_zeroed_superblock *superblock;
+
+	if (argc != 4) {
+		ti->error = "Invalid argument count";
+		r = -EINVAL;
+		goto bad;
+	}
+
+	sectors_per_data_chunk = simple_strtoul(argv[0], &endstr, 10);
+	if (!*argv[0] || *endstr ||
+	    !sectors_per_data_chunk ||
+	    sectors_per_data_chunk & (sectors_per_data_chunk - 1) ||
+	    sectors_per_data_chunk > INT_MAX >> SECTOR_SHIFT) {
+		ti->error = "Invalid chunk size";
+		r = -EINVAL;
+		goto bad;
+	}
+
+	sectors_per_metadata_chunk = simple_strtoul(argv[1], &endstr, 10);
+	if (!*argv[0] || *endstr ||
+	    !sectors_per_metadata_chunk ||
+	    sectors_per_metadata_chunk & (sectors_per_metadata_chunk - 1) ||
+	    sectors_per_metadata_chunk > INT_MAX >> (SECTOR_SHIFT + 3)) {
+		ti->error = "Invalid chunk size";
+		r = -EINVAL;
+		goto bad;
+	}
+
+	z = kmalloc(sizeof(struct dm_zeroed), GFP_KERNEL);
+	if (!z) {
+		ti->error = "Could not allocate memory";
+		r = -ENOMEM;
+		goto bad;
+	}
+	ti->private = z;
+
+	z->sectors_per_data_chunk = sectors_per_data_chunk;
+	z->sectors_per_data_chunk_bits = __ffs(z->sectors_per_data_chunk);
+	z->sectors_per_metadata_chunk = sectors_per_metadata_chunk;
+	z->sectors_per_metadata_chunk_bits = __ffs(z->sectors_per_metadata_chunk);
+
+	mutex_init(&z->range_tree_lock);
+	z->range_tree = RB_ROOT;
+	INIT_LIST_HEAD(&z->overlaping_requests);
+
+	spin_lock_init(&z->flush_request_lock);
+	INIT_LIST_HEAD(&z->flush_request_list);
+	INIT_WORK(&z->flush_work, zeroed_flush);
+
+	z->bioset = bioset_create(1, 0);
+	if (!z->bioset) {
+		ti->error = "Could not create bioset";
+		r = -ENOMEM;
+		goto bad_bioset;
+	}
+
+	z->dm_io = dm_io_client_create();
+	if (IS_ERR(z->dm_io)) {
+		ti->error = "Could not create dm-io client";
+		r = PTR_ERR(z->dm_io);
+		goto bad_dm_io;
+	}
+
+	z->workqueue = alloc_workqueue("dm-zeroed", WQ_MEM_RECLAIM, 2);
+	if (!z->workqueue) {
+		ti->error = "Could not create workqueue";
+		r = -ENOMEM;
+		goto bad_workqueue;
+	}
+
+	r = dm_get_device(ti, argv[2], dm_table_get_mode(ti->table), &z->dev);
+	if (r) {
+		ti->error = "Could not open underlying device";
+		goto bad_dev;
+	}
+
+	r = dm_get_device(ti, argv[3], dm_table_get_mode(ti->table), &z->log);
+	if (r) {
+		ti->error = "Could not open log device";
+		goto bad_log;
+	}
+
+	z->bufio = dm_bufio_client_create(z->log->bdev,
+				z->sectors_per_metadata_chunk << SECTOR_SHIFT,
+				1, 0, NULL, NULL);
+	if (IS_ERR(z->bufio)) {
+		r = PTR_ERR(z->bufio);
+		ti->error = "Unable create bufio";
+		goto bad_bufio;
+	}
+
+	superblock = read_superblock(z, true, &bp);
+	if (IS_ERR(superblock)) {
+		r = PTR_ERR(superblock);
+		ti->error = "Unable to read superblock";
+		goto bad_superblock;
+	}
+
+	if (superblock->magic != DM_ZEROED_SUPERBLOCK_MAGIC) {
+		superblock->magic = DM_ZEROED_SUPERBLOCK_MAGIC;
+		superblock->sectors_per_data_chunk =
+					cpu_to_le32(z->sectors_per_data_chunk);
+		superblock->sectors_per_metadata_chunk =
+				cpu_to_le32(z->sectors_per_metadata_chunk);
+		superblock->device_sectors = cpu_to_le64(0);
+		dm_bufio_mark_buffer_dirty(bp);
+	}
+
+	if (le32_to_cpu(superblock->sectors_per_data_chunk) !=
+	    z->sectors_per_data_chunk) {
+		dm_bufio_release(bp);
+		r = -EINVAL;
+		ti->error = "Invalid chunk size";
+		goto bad_superblock;
+	}
+
+	if (le32_to_cpu(superblock->sectors_per_metadata_chunk) !=
+	    z->sectors_per_metadata_chunk) {
+		dm_bufio_release(bp);
+		r = -EINVAL;
+		ti->error = "Invalid metadata chunk size";
+		goto bad_superblock;
+	}
+
+	z->device_sectors = le64_to_cpu(superblock->device_sectors);
+	dm_bufio_release(bp);
+
+	ti->num_flush_requests = 1;
+	ti->num_discard_requests = 1;
+	ti->per_bio_data_size = sizeof(struct dm_zeroed_request);
+	r = dm_set_target_max_io_len(ti, z->sectors_per_metadata_chunk *
+						8 * z->sectors_per_data_chunk);
+	if (r) {
+		ti->error = "Couldn't set max_io_len";
+		goto bad_superblock;
+	}
+
+	return 0;
+
+bad_superblock:
+	dm_bufio_client_destroy(z->bufio);
+bad_bufio:
+	dm_put_device(ti, z->log);
+bad_log:
+	dm_put_device(ti, z->dev);
+bad_dev:
+	destroy_workqueue(z->workqueue);
+bad_workqueue:
+	dm_io_client_destroy(z->dm_io);
+bad_dm_io:
+	bioset_free(z->bioset);
+bad_bioset:
+	kfree(z);
+bad:
+	return r;
+}
+
+/*
+ * A target destructor.
+ */
+static void zeroed_dtr(struct dm_target *ti)
+{
+	struct dm_zeroed *z = ti->private;
+
+	destroy_workqueue(z->workqueue);
+	dm_bufio_client_destroy(z->bufio);
+	dm_put_device(ti, z->log);
+	dm_put_device(ti, z->dev);
+	dm_io_client_destroy(z->dm_io);
+	bioset_free(z->bioset);
+	kfree(z);
+}
+
+/*
+ * A resume function. Device extending or shrinking is detected at this point.
+ */
+static void zeroed_resume(struct dm_target *ti)
+{
+	struct dm_zeroed *z = ti->private;
+
+	sector_t device_sectors = ti->len;
+	sector_t log_sectors =
+			i_size_read(z->log->bdev->bd_inode) >> SECTOR_SHIFT;
+
+	sector_t needed_log_sectors = minimum_log_sectors(z, device_sectors);
+
+	if (log_sectors < needed_log_sectors) {
+		DMERR("Log is too small: %Lx < %Lx (device sectors %Lx)",
+			(unsigned long long)log_sectors,
+			(unsigned long long)needed_log_sectors,
+			(unsigned long long)device_sectors);
+		goto skip_extend;
+	}
+
+	if (device_sectors != z->device_sectors) {
+		int r;
+		struct dm_zeroed_superblock *s;
+		struct dm_buffer *bp;
+
+		if (device_sectors > z->device_sectors) {
+			if (extend_device(z, device_sectors))
+				goto skip_extend;
+		}
+
+		r = dm_bufio_write_dirty_buffers(z->bufio);
+		if (r) {
+			DMERR("Error writing dirty buffers: %d", r);
+			goto skip_extend;
+		}
+		r = dm_bufio_issue_flush(z->bufio);
+		if (r) {
+			DMERR("Error flushing disk cache: %d", r);
+			goto skip_extend;
+		}
+
+		s = read_superblock(z, false, &bp);
+		if (IS_ERR(s))
+			goto skip_extend;
+		s->device_sectors = cpu_to_le64(device_sectors);
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+		z->device_sectors = device_sectors;
+	}
+skip_extend:
+	return;
+}
+
+/*
+ * Advance a bio by the specified number of bytes.
+ * Increase bi_sector, decrease bi_size and advance the vector.
+ */
+static void advance_bio(struct bio *bio, unsigned n_bytes)
+{
+	unsigned n_sectors;
+
+	BUG_ON(n_bytes & ((1 << SECTOR_SHIFT) - 1));
+
+	n_sectors = n_bytes >> SECTOR_SHIFT;
+
+	bio->bi_sector += n_sectors;
+	bio->bi_size -= n_bytes;
+next_bvec:
+	BUG_ON(bio->bi_idx >= bio->bi_vcnt);
+	if (bio_iovec(bio)->bv_len > n_bytes) {
+		bio_iovec(bio)->bv_len -= n_bytes;
+	} else {
+		n_bytes -= bio_iovec(bio)->bv_len;
+		bio->bi_idx++;
+		if (n_bytes) {
+			cond_resched();
+			goto next_bvec;
+		}
+	}
+}
+
+/*
+ * Test n bits at a specified position in the log.
+ * Return true if all the bits are set.
+ */
+static bool test_log_bits(struct dm_zeroed *z, void *log,
+			  unsigned pos, unsigned n)
+{
+	BUG_ON(pos + n > z->sectors_per_metadata_chunk << (SECTOR_SHIFT + 3));
+	do {
+		if (!(pos & (BITS_PER_LONG - 1)) && n >= BITS_PER_LONG) {
+			long val = ((long *)log)[pos / BITS_PER_LONG];
+			if (unlikely(val != -1L))
+				return false;
+			pos += BITS_PER_LONG;
+			n -= BITS_PER_LONG;
+		} else if (!(pos & 7) && n >= 8) {
+			u8 val = ((u8 *)log)[pos / 8];
+			if (unlikely(val != 0xff))
+				return false;
+			pos += 8;
+			n -= 8;
+		} else {
+			if (unlikely(!test_bit_le(pos, log)))
+				return false;
+			pos++;
+			n--;
+		}
+		cond_resched();
+	} while (n);
+	return true;
+}
+
+/*
+ * Check if a specified range overlaps with an existing range.
+ * If insert != NULL, add this request to the rb-tree, if it is non-overlapping.
+ */
+static bool range_check(struct dm_zeroed *z,
+			sector_t sector, unsigned n_sectors,
+			struct dm_zeroed_request *insert)
+{
+	struct rb_node **p = &z->range_tree.rb_node;
+	struct rb_node *parent = NULL;
+	while (*p) {
+		parent = *p;
+#define node	rb_entry(parent, struct dm_zeroed_request, tree_node)
+		if (sector + n_sectors <= node->original_sector)
+			p = &node->tree_node.rb_left;
+		else if (sector >=
+		     node->original_sector + node->original_n_sectors)
+			p = &node->tree_node.rb_right;
+		else
+			return true;
+#undef node
+	}
+	if (insert) {
+		rb_link_node(&insert->tree_node, parent, p);
+		rb_insert_color(&insert->tree_node, &z->range_tree);
+	}
+	return false;
+}
+
+/*
+ * The map function.
+ *
+ * Note: we can't read device log here, because it would deadlock.
+ * So we only perform get_log_block and if the block is not found in
+ * cache, we queue the request to the workqueue.
+ */
+static int zeroed_map(struct dm_target *ti, struct bio *bio)
+{
+	struct dm_zeroed *z = ti->private;
+	void *log;
+	unsigned pos, pos_end;
+	struct dm_buffer *bp;
+	struct dm_zeroed_request *rq;
+
+	bio->bi_bdev = z->dev->bdev;
+	bio->bi_sector = dm_target_offset(ti, bio->bi_sector);
+	if (unlikely(!bio->bi_size) || unlikely((bio->bi_rw & REQ_DISCARD) != 0))
+		return DM_MAPIO_REMAPPED;
+
+	if (unlikely(bio->bi_sector + bio_sectors(bio) > z->device_sectors)) {
+		DMERR("bio out of device size, bi_sector %Lx, bi_size %x, device_sectors %Lx",
+			(unsigned long long)bio->bi_sector,
+			bio->bi_size,
+			(unsigned long long)z->device_sectors);
+		return -EIO;
+	}
+
+	log = get_log_block(z, bio->bi_sector, &pos, &bp);
+	if (unlikely(!log))
+		goto queue_to_thread;
+	if (unlikely(IS_ERR(log))) {
+		DMERR("unable to access log block for sector %Lx: %d",
+			(unsigned long long)bio->bi_sector,
+			(int)PTR_ERR(log));
+		return PTR_ERR(log);
+	}
+	pos_end = log_position(z, bio->bi_sector + bio_sectors(bio) - 1);
+	if (likely(test_log_bits(z, log, pos, pos_end - pos + 1))) {
+
+		dm_bufio_release(bp);
+
+		if (unlikely((bio->bi_rw & RW_MASK) == WRITE)) {
+			/*
+			 * Make sure that test_log_bits is not reordered with
+			 * z->range_tree.rb_node != NULL
+			 */
+			smp_rmb();
+
+			if (unlikely(z->range_tree.rb_node != NULL)) {
+				mutex_lock(&z->range_tree_lock);
+				if (unlikely(range_check(z, bio->bi_sector,
+							 bio_sectors(bio),
+							 NULL))) {
+					mutex_unlock(&z->range_tree_lock);
+					goto queue_to_thread;
+				}
+				mutex_unlock(&z->range_tree_lock);
+			}
+		}
+
+		return DM_MAPIO_REMAPPED;
+	}
+	dm_bufio_release(bp);
+
+queue_to_thread:
+	rq = dm_per_bio_data(bio, sizeof(struct dm_zeroed_request));
+	rq->z = z;
+	INIT_WORK(&rq->work, zeroed_work);
+	queue_work(z->workqueue, &rq->work);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+/*
+ * A continuation of zeroed_map.
+ */
+static void zeroed_work(struct work_struct *work)
+{
+	struct dm_zeroed_request *rq =
+		container_of(work, struct dm_zeroed_request, work);
+	struct dm_zeroed *z = rq->z;
+	struct bio *bio = dm_bio_from_per_bio_data(rq,
+					sizeof(struct dm_zeroed_request));
+	void *log;
+	unsigned pos, pos_end;
+	struct dm_buffer *bp;
+
+	struct bio *new_bio;
+
+	log = read_log_block(z, bio->bi_sector, &pos, &bp);
+	if (unlikely(IS_ERR(log))) {
+		DMERR("unable to access log block for sector %Lx: %d",
+			(unsigned long long)bio->bi_sector,
+			(int)PTR_ERR(log));
+		bio_endio(bio, PTR_ERR(log));
+		return;
+	}
+	pos_end = log_position(z, bio->bi_sector + bio_sectors(bio) - 1);
+	if (likely(test_log_bits(z, log, pos, pos_end - pos + 1))) {
+
+		dm_bufio_release(bp);
+
+		if (unlikely((bio->bi_rw & RW_MASK) == WRITE)) {
+			/*
+			 * Make sure that test_log_bits is not reordered with
+			 * z->range_tree.rb_node != NULL
+			 */
+			smp_rmb();
+
+			if (unlikely(z->range_tree.rb_node != NULL)) {
+				mutex_lock(&z->range_tree_lock);
+				if (unlikely(range_check(z, bio->bi_sector,
+							 bio_sectors(bio),
+							 NULL))) {
+					list_add_tail(&rq->list_entry,
+						      &z->overlaping_requests);
+					mutex_unlock(&z->range_tree_lock);
+					return;
+				}
+				mutex_unlock(&z->range_tree_lock);
+			}
+		}
+
+		generic_make_request(bio);
+		return;
+	}
+
+	rq->error = 0;
+
+	if ((bio->bi_rw & RW_MASK) == WRITE) {
+		unsigned pre_sectors, post_sectors;
+
+		if (test_bit_le(log_position(z, bio->bi_sector), log))
+			pre_sectors = 0;
+		else
+			pre_sectors = bio->bi_sector &
+						(z->sectors_per_data_chunk - 1);
+
+		if (test_bit_le(log_position(z,
+				bio->bi_sector + bio_sectors(bio) - 1), log))
+			post_sectors = 0;
+		else {
+			post_sectors = -(bio->bi_sector + bio_sectors(bio)) &
+						(z->sectors_per_data_chunk - 1);
+			if (unlikely(bio->bi_sector + bio_sectors(bio) +
+				     (u64)post_sectors > z->device_sectors))
+				post_sectors = z->device_sectors -
+					(bio->bi_sector + bio_sectors(bio));
+		}
+
+		dm_bufio_release(bp);
+
+		rq->original_sector = bio->bi_sector - pre_sectors;
+		rq->original_n_sectors = bio_sectors(bio) +
+						pre_sectors + post_sectors;
+		mutex_lock(&z->range_tree_lock);
+		if (unlikely(range_check(z, rq->original_sector,
+					 rq->original_n_sectors, rq))) {
+			list_add_tail(&rq->list_entry, &z->overlaping_requests);
+			mutex_unlock(&z->range_tree_lock);
+			return;
+		}
+		mutex_unlock(&z->range_tree_lock);
+
+		atomic_set(&rq->outstanding, 2 + !!pre_sectors + !!post_sectors);
+
+		if (unlikely(pre_sectors != 0))
+			zero_sectors(z, bio->bi_sector - pre_sectors,
+				     pre_sectors, zero_end_io, rq);
+
+		rq->original_bi_end_io = bio->bi_end_io;
+		rq->original_bi_private = bio->bi_private;
+		bio->bi_end_io = write_end_io;
+		bio->bi_private = rq;
+		generic_make_request(bio);
+
+		if (unlikely(post_sectors != 0))
+			zero_sectors(z, bio->bi_sector + bio_sectors(bio),
+				     post_sectors, zero_end_io, rq);
+
+		write_dec_outstanding(rq);
+
+		return;
+	}
+
+	atomic_set(&rq->outstanding, 1);
+
+	zero_fill_bio(bio);
+
+	new_bio = NULL;
+	while (bio->bi_size) {
+		unsigned i, n_sectors, n_bytes;
+
+		cond_resched();
+
+		i = log_position(z, bio->bi_sector);
+		n_sectors = z->sectors_per_data_chunk -
+			(bio->bi_sector & (z->sectors_per_data_chunk - 1));
+		n_bytes = n_sectors << SECTOR_SHIFT;
+
+		if (unlikely(n_bytes > bio->bi_size)) {
+			n_sectors = bio->bi_size >> SECTOR_SHIFT;
+			n_bytes = bio->bi_size;
+		}
+
+		if (test_bit_le(i, log)) {
+			unsigned len;
+			if (!new_bio) {
+				new_bio = bio_alloc_bioset(GFP_NOIO,
+					bio->bi_vcnt - bio->bi_idx, z->bioset);
+				new_bio->bi_bdev = bio->bi_bdev;
+				new_bio->bi_sector = bio->bi_sector;
+				new_bio->bi_end_io = read_end_io;
+				new_bio->bi_private = rq;
+			}
+			len = min(n_bytes, bio_iovec(bio)->bv_len);
+			if (!bio_add_page(new_bio, bio_page(bio), len,
+							bio_offset(bio)))
+				goto submit_new_bio;
+			advance_bio(bio, len);
+		} else {
+			advance_bio(bio, n_bytes);
+			if (new_bio) {
+submit_new_bio:
+				atomic_inc(&rq->outstanding);
+				submit_bio(READ, new_bio);
+				new_bio = NULL;
+			}
+		}
+	}
+	if (new_bio)
+		goto submit_new_bio;
+
+	dm_bufio_release(bp);
+
+	read_dec_outstanding(rq);
+}
+
+/*
+ * End of read request.
+ */
+static void read_end_io(struct bio *new_bio, int error)
+{
+	struct dm_zeroed_request *rq = new_bio->bi_private;
+
+	if (unlikely(error))
+		rq->error = error;
+
+	bio_put(new_bio);
+
+	read_dec_outstanding(rq);
+}
+
+/*
+ * Decrease the outstanding counter on read requests.
+ * If it reaches zero, the bio is finished.
+ */
+static void read_dec_outstanding(struct dm_zeroed_request *rq)
+{
+	if (atomic_dec_and_test(&rq->outstanding)) {
+		int error = rq->error;
+		struct bio *bio = dm_bio_from_per_bio_data(rq,
+					sizeof(struct dm_zeroed_request));
+		bio_endio(bio, error);
+	}
+}
+
+/*
+ * The end of zero request performed by dm-io.
+ */
+static void zero_end_io(unsigned long error, void *context)
+{
+	struct dm_zeroed_request *rq = context;
+
+	if (unlikely(error != 0))
+		rq->error = -EIO;
+
+	write_dec_outstanding(rq);
+}
+
+/*
+ * The end of write request.
+ */
+static void write_end_io(struct bio *bio, int error)
+{
+	struct dm_zeroed_request *rq = bio->bi_private;
+
+	bio->bi_end_io = rq->original_bi_end_io;
+	bio->bi_private = rq->original_bi_private;
+
+	if (unlikely(error))
+		rq->error = error;
+
+	write_dec_outstanding(rq);
+}
+
+/*
+ * Decrease the outstanding count on write requests.
+ * If it reaches zero, the request is queued to zeroed_flush.
+ */
+static void write_dec_outstanding(struct dm_zeroed_request *rq)
+{
+	if (atomic_dec_and_test(&rq->outstanding)) {
+		struct dm_zeroed *z = rq->z;
+
+		unsigned long flags;
+
+		spin_lock_irqsave(&z->flush_request_lock, flags);
+		list_add_tail(&rq->list_entry, &z->flush_request_list);
+		spin_unlock_irqrestore(&z->flush_request_lock, flags);
+
+		queue_work(z->workqueue, &z->flush_work);
+	}
+}
+
+/*
+ * This function processes finished write requests.
+ * We sync hardware write cache (to make the requests really finished).
+ * We set bits in the log.
+ * We sync the log.
+ * Finally we return write requests to device mapper as finished.
+ */
+static void zeroed_flush(struct work_struct *work)
+{
+	struct dm_zeroed *z =
+		container_of(work, struct dm_zeroed, flush_work);
+	struct list_head list;
+	struct dm_zeroed_request *rq, *rqn;
+	int r;
+
+	spin_lock_irq(&z->flush_request_lock);
+	if (list_empty(&z->flush_request_list)) {
+		spin_unlock_irq(&z->flush_request_lock);
+		return;
+	}
+	list = z->flush_request_list;
+	INIT_LIST_HEAD(&z->flush_request_list);
+	list.next->prev = &list;
+	list.prev->next = &list;
+	spin_unlock_irq(&z->flush_request_lock);
+
+	r = issue_device_flush_sync(z);
+	if (unlikely(r))
+		goto return_error;
+
+	/*
+	 * Pair with smp_rmb, make sure that other processes see
+	 * z->range_tree.rb_node != NULL before they see __set_bit_le.
+	 * In practice, this smp_wmb is almost useless because
+	 * there were a lot of operations since rb_link_node and
+	 * so z->range_tree.rb_node != NULL is already visible.
+	 */
+	smp_wmb();
+
+	list_for_each_entry_safe(rq, rqn, &list, list_entry) {
+		void *log;
+		unsigned pos, pos_end;
+		struct dm_buffer *bp;
+
+		if (unlikely(rq->error)) {
+			list_del(&rq->list_entry);
+			write_end_request(rq, rq->error);
+			continue;
+		}
+
+		log = read_log_block(z, rq->original_sector, &pos, &bp);
+		if (unlikely(IS_ERR(log))) {
+			list_del(&rq->list_entry);
+			write_end_request(rq, PTR_ERR(log));
+			continue;
+		}
+		pos_end = log_position(z, rq->original_sector +
+						rq->original_n_sectors - 1);
+		for (; pos <= pos_end; pos++)
+			__set_bit_le(pos, log);
+
+		dm_bufio_mark_buffer_dirty(bp);
+		dm_bufio_release(bp);
+	}
+
+	r = dm_bufio_write_dirty_buffers(z->bufio);
+	if (unlikely(r))
+		goto return_error;
+	r = dm_bufio_issue_flush(z->bufio);
+	if (unlikely(r))
+		goto return_error;
+
+	r = 0;
+return_error:
+	list_for_each_entry_safe(rq, rqn, &list, list_entry) {
+		list_del(&rq->list_entry);
+		write_end_request(rq, r);
+	}
+	resume_overlappnig_requests(z);
+}
+
+/*
+ * Finish one write request.
+ * Remove it from the rb-tree, if that enables other held requests to be
+ * resubmitted, resubmit them.
+ * Finally, report the request as finished.
+ */
+static void write_end_request(struct dm_zeroed_request *rq, int r)
+{
+	struct dm_zeroed *z = rq->z;
+	struct bio *bio;
+
+	mutex_lock(&z->range_tree_lock);
+	rb_erase(&rq->tree_node, &z->range_tree);
+	mutex_unlock(&z->range_tree_lock);
+
+	bio = dm_bio_from_per_bio_data(rq, sizeof(struct dm_zeroed_request));
+	bio_endio(bio, r);
+
+	cond_resched();
+}
+
+/*
+ * Check the list of overlapping requests. The requests that are no longer
+ * overlappnig are resubmitted.
+ */
+static void resume_overlappnig_requests(struct dm_zeroed *z)
+{
+	struct dm_zeroed_request *rq, *rqn;
+	mutex_lock(&z->range_tree_lock);
+	list_for_each_entry_safe(rq, rqn, &z->overlaping_requests, list_entry) {
+		struct bio *bio = dm_bio_from_per_bio_data(rq,
+					sizeof(struct dm_zeroed_request));
+		if (!range_check(z, bio->bi_sector, bio_sectors(bio), NULL)) {
+			list_del(&rq->list_entry);
+			queue_work(z->workqueue, &rq->work);
+		}
+		cond_resched();
+	}
+	mutex_unlock(&z->range_tree_lock);
+}
+
+/*
+ * The merge method. Pass the merge request to the device queue.
+ */
+static int zeroed_merge(struct dm_target *ti, struct bvec_merge_data *bvm,
+			struct bio_vec *biovec, int max_size)
+{
+	struct dm_zeroed *z = ti->private;
+	struct request_queue *q = bdev_get_queue(z->dev->bdev);
+
+	if (!q->merge_bvec_fn)
+		return max_size;
+
+	bvm->bi_bdev = z->dev->bdev;
+
+	return min(max_size, q->merge_bvec_fn(q, bvm, biovec));
+}
+
+/*
+ * Iterate devices.
+ * We return only the underlying device, not the log device,
+ * because requests are never routed to the log device.
+ */
+static int zeroed_iterate_devices(struct dm_target *ti,
+				  iterate_devices_callout_fn fn,
+				  void *data)
+{
+	struct dm_zeroed *z = ti->private;
+
+	return fn(ti, z->dev, 0, ti->len, data);
+}
+
+static void zeroed_io_hints(struct dm_target *ti, struct queue_limits *limits)
+{
+	struct dm_zeroed *z = ti->private;
+
+	blk_limits_io_opt(limits, z->sectors_per_data_chunk << SECTOR_SHIFT);
+}
+
+static struct target_type zeroed_target = {
+	.name   = "zeroed",
+	.version = {1, 0, 0},
+	.module = THIS_MODULE,
+	.ctr    = zeroed_ctr,
+	.dtr    = zeroed_dtr,
+	.map    = zeroed_map,
+	.merge	= zeroed_merge,
+	.resume = zeroed_resume,
+	.iterate_devices = zeroed_iterate_devices,
+	.io_hints = zeroed_io_hints,
+};
+
+/*
+ * Module initializetion.
+ */
+static int __init dm_zeroed_init(void)
+{
+	int r;
+
+	zero_page_list.next = &zero_page_list;
+	zero_page_list.page = ZERO_PAGE(0);
+
+	r = dm_register_target(&zeroed_target);
+	if (r < 0) {
+		DMERR("Target register failed %d", r);
+		goto bad_target;
+	}
+
+	return 0;
+
+bad_target:
+	return r;
+}
+
+/*
+ * Module termination.
+ */
+static void __exit dm_zeroed_exit(void)
+{
+	dm_unregister_target(&zeroed_target);
+}
+
+module_init(dm_zeroed_init)
+module_exit(dm_zeroed_exit)
+
+MODULE_AUTHOR("Mikulas Patocka <mpatocka@redhat.com>");
+MODULE_DESCRIPTION(DM_NAME " zeroed target");
+MODULE_LICENSE("GPL");
Index: linux-3.8-rc5-fast/Documentation/device-mapper/zeroed.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-3.8-rc5-fast/Documentation/device-mapper/zeroed.txt	2013-01-28 20:59:21.000000000 +0100
@@ -0,0 +1,47 @@
+dm-zeroed
+=========
+
+The dm-zeroed target provides transparent initialization of a logical
+volume. When a logical volume is created, it is not initialized and it
+contains data that were previously stored in that location. In an
+environment with virtual machines belonging to different customers this
+can cause a security breach. Overwriting the whole logical volume to
+erase previous information can be very slow.
+
+The dm-zeroed target uses a bitmap with the logical volume. Each bit in
+the bitmap corresponds to one chunk - the bit determines if the chunk
+was written to or not. When trying to read the logical volume, the
+dm-zeroed targets returns zeroes for the chunks that were not written
+to. Consequently, there is no security breach from reading uninitialized
+blocks.
+
+Parameters:
+
+<sectors per data chunk> - the size of data chunk in 512-byte sectors.
+For optimum performance it is recommended to set this as a block size
+of the filesystem that will be used, typically 4k (thus the value 8
+should be used).
+
+<sectors per metadata chunk> - the block size of metadata. Metadata
+device is read and written in these units. Increasing this value causes
+that more metadata will be read, but read requests will be submitted
+less often, thus it may or may not improve performance, depending on
+workload.
+
+<data device> - the underlying data device
+
+<metadata device> - the metadata device. The metadata device should
+either have the first 512 bytes cleared (in this case, a new metadata
+is created with all blocks marked as not-written). Or it should contain
+data from the previous dm-zeroed invocation (in this case, the bitmap is
+used as it was left by the previous invocation; in this case, data and
+metadata chunk size must match the previous values).
+
+The required size of the metadata device can be calculated in the
+following way:
+	data_chunks := roundup(data_device_size / data_chunk_size)
+	metadata_chunks := roundup(data_chunks / (metadata_chunk_size * 8))
+	metadata_size := metadata_chunk_size * (1 + metadata_chunks)
+
+The first chunk in the metadata device contains the superblock, the
+remaining chunks contains bits, each bit for one data chunk
