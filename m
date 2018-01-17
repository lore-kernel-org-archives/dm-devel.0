From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: [PATCH 1/2] dm loop: new target redirecting io to
	backing file(s)
Date: Wed, 17 Jan 2018 20:34:00 +0100
Message-ID: <1b84af841912065fc57cfe395d5214f4eee0f0fc.1516124587.git.heinzm@redhat.com>
References: <cover.1516124587.git.heinzm@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1516124587.git.heinzm@redhat.com>
In-Reply-To: <cover.1516124587.git.heinzm@redhat.com>
References: <cover.1516124587.git.heinzm@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: heinzm@redhat.com, dm-devel@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 Documentation/device-mapper/loop.txt |  20 ++
 drivers/md/Kconfig                   |   7 +
 drivers/md/Makefile                  |   1 +
 drivers/md/dm-loop.c                 | 352 +++++++++++++++++++++++++++++++++++
 4 files changed, 380 insertions(+)
 create mode 100644 Documentation/device-mapper/loop.txt
 create mode 100644 drivers/md/dm-loop.c

diff --git a/Documentation/device-mapper/loop.txt b/Documentation/device-mapper/loop.txt
new file mode 100644
index 000000000000..a8c1e0cae62e
--- /dev/null
+++ b/Documentation/device-mapper/loop.txt
@@ -0,0 +1,20 @@
+dm-loop
+=======
+
+Device-Mapper's "loop" target provides a mapping to a
+backing file. This is similar to a loop device created
+by losetup with less overhead, hence higher iops and bandwidth.
+
+
+Parameters: <path_name>
+
+<path_name> path to existing file to map block io to
+
+
+Example:
+
+dmsetup create loop --table "0 $TWO_GiB loop /tmp/loopfile"
+
+This will create a 2GiB loop device /dev/mapper/loop mapped
+to existing /tmp/loopfile which has to be 2GiB in size or
+bigger for the creation to succeed.
diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 83b9362be09c..1d80783b9ee8 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -390,6 +390,13 @@ config DM_ZERO
 	  A target that discards writes, and returns all zeroes for
 	  reads.  Useful in some recovery situations.
 
+config DM_LOOP
+	tristate "Loop target (EXPERIMENTAL)"
+	depends on BLK_DEV_DM
+	---help---
+	  A target that redirects IOs to a backing file.
+	  E.g. useful in testing.
+
 config DM_MULTIPATH
 	tristate "Multipath target"
 	depends on BLK_DEV_DM
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index f701bb211783..68baf79c5536 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -57,6 +57,7 @@ obj-$(CONFIG_DM_PERSISTENT_DATA)	+= persistent-data/
 obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-region-hash.o
 obj-$(CONFIG_DM_LOG_USERSPACE)	+= dm-log-userspace.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
+obj-$(CONFIG_DM_LOOP)		+= dm-loop.o
 obj-$(CONFIG_DM_RAID)	+= dm-raid.o
 obj-$(CONFIG_DM_THIN_PROVISIONING)	+= dm-thin-pool.o
 obj-$(CONFIG_DM_VERITY)		+= dm-verity.o
diff --git a/drivers/md/dm-loop.c b/drivers/md/dm-loop.c
new file mode 100644
index 000000000000..35adde3f64e0
--- /dev/null
+++ b/drivers/md/dm-loop.c
@@ -0,0 +1,352 @@
+/*
+ * Copyright (C) 2018 Red Hat GmbH
+ *
+ * Simple loop target which redirects
+ * io in parallel to a backing file.
+ *
+ * This file is released under the GPL.
+ */
+
+#include <linux/device-mapper.h>
+#include <linux/falloc.h>
+#include <linux/uio.h>
+#include <linux/module.h>
+
+#define DM_MSG_PREFIX "loop"
+#define	WORKQUEUE_NAME	"dm-kloopd"
+
+/* Global workqueue shared by all loop mappings */
+static struct workqueue_struct *kloopd_wq = NULL;
+static atomic_t kloopd_wq_users = ATOMIC_INIT(0);
+
+/* Registry of all loop devices to prevent using the same files multiple times */
+static LIST_HEAD(loop_devs);
+
+/* loop context */
+struct loop_c {
+	struct file *file; /* Backing file */
+
+	/* Workqueue */
+	spinlock_t lock;
+	struct bio_list bios;
+	struct work_struct bios_ws;
+
+	struct dm_target *ti;
+	char *path; /* Status table output */
+	struct list_head list;
+};
+
+/* bio context for wrokqueue */
+struct bio_c {
+	struct work_struct bio_ws;
+	struct bio *bio;
+	struct loop_c *lc;
+};
+
+/* Is file of @lc already in use? */
+static int __file_in_use(struct loop_c *lc)
+{
+	struct loop_c *cur;
+
+	list_for_each_entry(cur, &loop_devs, list)
+		if (cur != lc && cur->file->f_inode == lc->file->f_inode)
+			return -EPERM;
+	return 0;
+}
+
+/* Use punch hole to discard bio_sectors(@bio) in backing file starting at @pos */
+static void loop_discard(struct loop_c *lc, struct bio *bio)
+{
+	if (lc->file->f_op->fallocate) {
+		int r = lc->file->f_op->fallocate(lc->file,
+						  FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+						  to_bytes(bio->bi_iter.bi_sector),
+						  to_bytes(bio_sectors(bio)));
+		if (unlikely(r && r != -EOPNOTSUPP && r != -EINVAL))
+			bio->bi_status = errno_to_blk_status(-EIO);
+	}
+}
+
+/* Sync a backing file range @pos - @end (FUA, PREFLUSH) */
+static void loop_fsync_range(struct loop_c *lc, loff_t pos, loff_t end)
+{
+	int r = vfs_fsync_range(lc->file, pos, end, 0);
+
+	if (unlikely(r && r != -EINVAL))
+		DMERR("Error fsync range");
+	else
+		cond_resched();
+}
+
+/* Check for any IO error after reading or writing a bio_vec */
+static int loop_check_io_error(ssize_t bytes, loff_t pos,
+			       struct bio_vec *bvec, const char *what)
+{
+	if (likely(bytes == bvec->bv_len))
+		return 0;
+
+	DMERR_LIMIT("%s error[%lld] at byte offset %llu, length %u",
+		    what, (long long) bytes, (unsigned long long) pos, bvec->bv_len);
+	return (bytes < 0) ? (int) bytes : -EIO;
+}
+
+/*
+ * Read/write @bio payload from/to backing file at @pos.
+ *
+ * Returns 0 on success and < 0 on error (e.g. -EIO).
+ */
+static void loop_rw_bio(struct loop_c *lc, struct bio *bio)
+{
+	int r = 0;
+	bool write = op_is_write(bio_op(bio));
+	ssize_t bytes;
+	loff_t bio_begin, bio_end = 0, pos = to_bytes(bio->bi_iter.bi_sector);
+	struct bio_vec bvec;
+	struct iov_iter io_iter;
+
+	if (unlikely(write && (bio->bi_opf & (REQ_FUA | REQ_PREFLUSH)))) {
+		bio_begin = pos;
+		bio_end = pos + bio_cur_bytes(bio);
+	}
+
+	bio_for_each_segment(bvec, bio, bio->bi_iter) {
+		iov_iter_bvec(&io_iter, ITER_BVEC, &bvec, 1, bvec.bv_len);
+
+		if (write) {
+			file_start_write(lc->file);
+			bytes = vfs_iter_write(lc->file, &io_iter, &pos, 0);
+			file_end_write(lc->file);
+			r = loop_check_io_error(bytes, pos, &bvec, "write");
+			if (r)
+				break;
+		} else {
+			bytes = vfs_iter_read(lc->file, &io_iter, &pos, 0);
+			r = loop_check_io_error(bytes, pos, &bvec, "read");
+			if (r) {
+				zero_fill_bio(bio);
+				break;
+			}
+
+			flush_dcache_page(bvec.bv_page);
+		}
+
+		cond_resched();
+	}
+
+	if (unlikely(r < 0))
+		bio->bi_status = errno_to_blk_status(r);
+
+	if (unlikely(bio_end))
+		/* FUA, ... requested -> flush the bio defined range */
+		loop_fsync_range(lc, bio_begin, bio_end);
+}
+
+/* Worker thread function to process file IO for single bio */
+static void loop_process_bio(struct work_struct *work)
+{
+	struct bio_c *bio_c = container_of(work, struct bio_c, bio_ws);
+	struct bio *bio = bio_c->bio;
+
+	current->flags |= PF_LESS_THROTTLE;
+
+	switch (bio_op(bio)) {
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
+		loop_rw_bio(bio_c->lc, bio);
+		break;
+	case REQ_OP_FLUSH:
+		loop_fsync_range(bio_c->lc, 0, LLONG_MAX);
+		break;
+	case REQ_OP_DISCARD:
+		loop_discard(bio_c->lc, bio);
+		break;
+	default:
+		bio->bi_status = errno_to_blk_status(-EIO);
+	}
+
+	bio_endio(bio);
+}
+
+/* Worker thread function to process all bios */
+static void loop_process_bios(struct work_struct *work)
+{
+	struct loop_c *lc = container_of(work, struct loop_c, bios_ws);
+	struct bio_list bl;
+	struct bio *bio;
+	struct bio_c *bio_c;
+
+	current->flags |= PF_LESS_THROTTLE;
+
+	/* Take out input bios to process... */
+	bio_list_init(&bl);
+	spin_lock_irq(&lc->lock);
+	bio_list_merge(&bl, &lc->bios);
+	bio_list_init(&lc->bios);
+	spin_unlock_irq(&lc->lock);
+
+	while ((bio = bio_list_pop(&bl))) {
+		bio_c = dm_per_bio_data(bio, lc->ti->per_io_data_size);
+		INIT_WORK(&bio_c->bio_ws, loop_process_bio);
+		bio_c->bio = bio;
+		bio_c->lc = lc;
+		queue_work(kloopd_wq, &bio_c->bio_ws);
+	}
+}
+
+/* Release loop context resources of @lc */
+static void destroy_loop(struct loop_c *lc)
+{
+	if (lc) {
+		list_del(&lc->list);
+		if (kloopd_wq && atomic_dec_and_test(&kloopd_wq_users)) {
+			destroy_workqueue(kloopd_wq);
+			kloopd_wq = NULL;
+		}
+		if (lc->file)
+			filp_close(lc->file, NULL);
+		if (lc->path)
+			kfree(lc->path);
+		kfree(lc);
+	}
+}
+
+/*
+ * Construct a loop mapping on a (sparse) file.
+ *
+ * Argument:
+ *    <file_path>: path to backing file
+ */
+static int loop_ctr(struct dm_target *ti, unsigned int argc, char **argv)
+{
+	int r = -ENOMEM;
+	struct loop_c *lc;
+
+	if (argc != 1) {
+		ti->error = "Invalid argument count";
+		return -EINVAL;
+	}
+
+	lc = ti->private = kzalloc(sizeof(*lc), GFP_KERNEL);
+	if (!lc) {
+		ti->error = "Cannot allocate context";
+		goto err;
+	}
+
+	spin_lock_init(&lc->lock);
+	bio_list_init(&lc->bios);
+	INIT_WORK(&lc->bios_ws, loop_process_bios);
+	list_add(&lc->list, &loop_devs);
+
+	ti->num_discard_bios = 1;
+	ti->discards_supported = true;
+	ti->flush_supported = true;
+	ti->per_io_data_size = sizeof(struct bio_c);
+	lc->ti = ti;
+
+	lc->path = kstrdup(argv[0], GFP_KERNEL);
+	if (!lc->path) {
+		ti->error = "Cannot allocate path";
+		goto err;
+	}
+
+	/* Open existing backing file */
+	lc->file = filp_open(lc->path, O_EXCL | O_LARGEFILE | O_RDWR, 0);
+	if (IS_ERR(lc->file)) {
+		ti->error = "Cannot open backing file";
+		r = PTR_ERR(lc->file);
+		lc->file = NULL;
+		goto err;
+	}
+
+	r = __file_in_use(lc);
+	if (r) {
+		ti->error = "Cannot use same file multiple times";
+		goto err;
+	}
+
+	if (ti->len > to_sector(i_size_read(lc->file->f_mapping->host))) {
+		ti->error = "Backing file too small";
+		r = -ENOSPC;
+		goto err;
+	}
+
+	r = dm_set_target_max_io_len(ti, min(ti->len, (sector_t) UINT_MAX));
+	if (r)
+		goto err;
+
+	/* Alloc global workqueue with first loop mapping construction */
+	if (atomic_inc_return(&kloopd_wq_users) == 1) {
+		kloopd_wq = alloc_workqueue(WORKQUEUE_NAME, WQ_MEM_RECLAIM | WQ_UNBOUND, 0);
+		if (!kloopd_wq) {
+			DMERR("Cannot start workqueue %s", WORKQUEUE_NAME);
+			atomic_set(&kloopd_wq_users, 0);
+			r = -ENOMEM;
+			goto err;
+		}
+	}
+
+	return 0;
+err:
+	destroy_loop(lc);
+	return r;
+}
+
+static void loop_dtr(struct dm_target *ti)
+{
+	destroy_loop(ti->private);
+}
+
+static int loop_map(struct dm_target *ti, struct bio *bio)
+{
+	struct loop_c *lc = ti->private;
+
+	/* Not a singleton target... */
+	bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
+
+	spin_lock_irq(&lc->lock);
+	bio_list_add(&lc->bios, bio);
+	spin_unlock_irq(&lc->lock);
+
+	queue_work(kloopd_wq, &lc->bios_ws);
+
+	return DM_MAPIO_SUBMITTED;
+}
+
+static void loop_status(struct dm_target *ti, status_type_t type,
+			unsigned status_flags, char *result, unsigned maxlen)
+{
+	if (type == STATUSTYPE_TABLE) {
+		struct loop_c *lc = ti->private;
+		int sz = 0;
+
+		DMEMIT("%s", lc->path);
+	}
+}
+
+static struct target_type loop_target = {
+	.name	     = "loop",
+	.version     = {1, 0, 0},
+	.module      = THIS_MODULE,
+	.ctr	     = loop_ctr,
+	.dtr	     = loop_dtr,
+	.map	     = loop_map,
+	.status	     = loop_status,
+};
+
+static int __init dm_loop_init(void)
+{
+	return dm_register_target(&loop_target);
+}
+
+static void __exit dm_loop_exit(void)
+{
+	dm_unregister_target(&loop_target);
+}
+
+/* Module hooks */
+module_init(dm_loop_init);
+module_exit(dm_loop_exit);
+
+MODULE_DESCRIPTION(DM_NAME " loop target");
+MODULE_AUTHOR("Heinz Mauelshagen <dm-devel@redhat.com>");
+MODULE_LICENSE("GPL");
-- 
2.14.3
