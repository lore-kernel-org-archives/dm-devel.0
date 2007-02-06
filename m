From: "Bryn M. Reeves" <breeves@redhat.com>
Subject: [PATCH 2.6.20] updated dm-loop patch
Date: Tue, 06 Feb 2007 11:35:43 +0000
Message-ID: <45C8680F.8080303@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080102070604080604050001"
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080102070604080604050001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

This is a revised version of the device mapper loop target. The patch
applies to 2.6.20, but you'll also need the dm-bio-list-helpers patch
posted earlier.

This release  adds a number of features and removes some of the
limitations of the previous patch:

- - merge Heinz's lookup work & fs I/O support
- - rework allocation for the extent map & extents
- - reorganise context data structures
- - fallback from sparse file detection

* dm-loop can now support files with an arbitrary number of extents
(limited only by available memory) as well as networked file systems and
device-backed files containing holes (sparse files).

* Performance should be much better for large/fragmented backing files.
The old linear code has been replaced with a binary search and we no
longer allocate huge chunks of kernel memory for the extent table.

* Table format is unchanged: <loop path> <offset>, for e.g:

	0 2048 loop /data/img0 0

If you are using a recent version of dmsetup you can symlink it to
either 'dmlosetup' or 'losetup' and use it in much the same way as the
regular losetup.

This version has been tested on ext2/3, NFS and SAMBA. Earlier versions
of the block mapping code have also been tested with XFS, JFS & reiserfs
- - there shouldn't be any problems here, but please report any unexpected
behavior.

Please give the new patch a try and post any problem reports / feedback.

Thanks!

Bryn.
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFyGgP6YSQoMYUY94RAjuYAJ9ieZecyKs6HnhBtvnMfQqaAoXsJACfX+cW
z839Ouwlw4XLHm8SQiugAJs=
=u3wY
-----END PGP SIGNATURE-----

--------------080102070604080604050001
Content-Type: text/x-patch;
 name="dm-loop.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-loop.patch"

This implements a loopback target for device mapper, allowing a regular
file to be treated as a block device.

Signed-off-by: Bryn Reeves <breeves@redhat.com>

===================================================================
diff --git a/drivers/md/dm-loop.c b/drivers/md/dm-loop.c
new file mode 100644
index 0000000..e684402
--- /dev/null
+++ b/drivers/md/dm-loop.c
@@ -0,0 +1,1018 @@
+/*
+ * Copyright (C) 2006 Red Hat, Inc. All rights reserved.
+ *
+ * This file is part of device-mapper.
+ *
+ * drivers/md/dm-loop.c
+ *
+ * Extent mapping implementation heavily influenced by mm/swapfile.c
+ * Bryn Reeves <breeves@redhat.com>
+ *
+ * File mapping and block lookup algorithms support by
+ * Heinz Mauelshagen <hjm@redhat.com>.
+ * 
+ * This file is released under the GPL.
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
+#include <linux/module.h>
+#include <linux/pagemap.h>
+#include <linux/vmalloc.h>
+#include <linux/syscalls.h>
+#include <linux/workqueue.h>
+#include <linux/file.h>
+#include <linux/bio.h>
+
+#include "dm.h"
+#include "dm-bio-list.h"
+#include "dm-bio-record.h"
+
+static const char *version = "v0.412";
+#define DAEMON "kloopd"
+
+#define DM_MSG_PREFIX "loop"
+
+enum flags { BLOCK_TYPE, FILE_TYPE, VMALLOC };
+
+/*--------------------------------------------------------------------
+ * Loop context
+ *--------------------------------------------------------------------*/
+
+struct loop_c {
+	unsigned long flags;
+
+	/* information describing the backing store */
+	struct file *filp;		/* loop file handle */
+	char *path;			/* path argument */
+	loff_t offset;			/* offset argument */
+	struct block_device *bdev;	/* block device */
+	unsigned blkbits;		/* file system block size shift bits */
+
+	loff_t size;			/* size of entire file in bytes */
+	loff_t blocks;			/* blocks allocated to loop file */
+	sector_t mapped_sectors;	/* size of mapped area in sectors*/
+
+	/* mapping */
+	int (*map_fn)(struct dm_target*, struct bio*);
+	/* mapping function private data */
+	void *map_data;
+};
+
+/*
+ * block map extents
+ */
+struct extent {
+	sector_t start;
+	sector_t to;
+	sector_t len;
+};
+
+struct extent_list {
+	struct extent * extent;
+	struct list_head list;
+};
+
+struct kmem_cache *extent_cache;
+
+/* 
+ * block map private context
+ */
+struct block_map_c {
+	int nr_extents;			/* number of extents in map */
+	struct extent **map;		/* linear map of extent pointers */
+	struct extent **mru;		/* pointer to meu entry */
+	spinlock_t mru_lock;		/* protects mru */
+};
+
+/* 
+ * file map private context
+ */
+struct file_map_c {
+	spinlock_t lock;		/* protects in */
+	struct bio_list in;		/* new bios for processing */
+	struct bio_list work;		/* bios queued for processing */
+	struct workqueue_struct *wq;	/* workqueue MOVEME */
+	struct work_struct ws;		/* loop work */
+	struct loop_c *loop;		/* for filp & offset.. ych y fi. */
+};
+
+/*--------------------------------------------------------------------
+ * Generic helper routines						    
+ *--------------------------------------------------------------------*/
+
+static inline sector_t blk2sec(struct loop_c *lc, blkcnt_t block)
+{
+	return block << (lc->blkbits - SECTOR_SHIFT);
+}
+
+static inline blkcnt_t sec2blk(struct loop_c *lc, sector_t sector)
+{
+	return sector >> (lc->blkbits - SECTOR_SHIFT);
+}
+
+/*--------------------------------------------------------------------
+ * File I/O helper routines						   
+ *--------------------------------------------------------------------*/
+
+/*
+ * transfer data to/from file. 
+ */
+static int fs_io(int rw, struct file *filp, loff_t *pos,
+		     struct bio_vec *bv)
+{
+	ssize_t r;
+	void *ptr = kmap(bv->bv_page) + bv->bv_offset;
+	mm_segment_t old_fs = get_fs();
+
+	set_fs(get_ds());
+	r = (rw == READ) ? filp->f_op->read(filp, ptr, bv->bv_len, pos) :
+			   filp->f_op->write(filp, ptr, bv->bv_len, pos);
+	set_fs(old_fs);
+	kunmap(bv->bv_page);
+	return r == bv->bv_len ? 0 : -EIO;
+}
+
+/*
+ * Handle IO for one bio
+ */
+static void do_one_bio(struct file_map_c *fc, struct bio *bio)
+{
+	int r = 0, rw = bio_data_dir(bio);
+	loff_t start = to_bytes(bio->bi_sector) + fc->loop->offset,
+		pos = start;
+	struct bio_vec *bv, *bv_end = bio->bi_io_vec + bio->bi_vcnt;
+
+	for (bv = bio->bi_io_vec; bv < bv_end; bv++) {
+		r = fs_io(rw, fc->loop->filp, &pos, bv);
+		if (r) {
+			DMWARN("%s error %d", rw ? "write":"read" , r);
+			break;
+		}
+	}
+
+	bio_endio(bio, pos - start, r);
+}
+
+/*
+ * Worker thread for a 'file' type loop device
+ */
+static void do_loop_work(struct work_struct *ws)
+{
+	struct file_map_c *fc = container_of(ws, struct file_map_c, ws);
+	struct bio *bio;
+
+	/* quickly grab all new ios queued and add them to the work list */
+	spin_lock_irq(&fc->lock);
+	bio_list_merge_init(&fc->work, &fc->in);
+	spin_unlock_irq(&fc->lock);
+
+	/* work the list and do file IO on all bios */
+	while ((bio = bio_list_pop(&fc->work)))
+		do_one_bio(fc, bio);
+}
+
+/*
+ * Create work queue and initialize work
+ */
+static int loop_work_init(struct loop_c *lc)
+{
+	struct file_map_c *fc = lc->map_data;
+
+	fc->wq = create_singlethread_workqueue(DAEMON);
+	if (!fc->wq)
+		return -ENOMEM;
+
+	INIT_WORK(&fc->ws, do_loop_work);
+	return 0;
+}
+
+/*
+ * Destroy work queue
+ */
+static void loop_work_exit(struct file_map_c *fc)
+{
+	if (fc->wq)
+		destroy_workqueue(fc->wq);
+}
+
+/*
+ * FILE_TYPE map_fn. Mapping just queues ios to the file map
+ * context and lets the daemon deal with them.
+ */
+static int loop_file_map(struct dm_target *ti, struct bio *bio)
+{
+	int wake;
+	struct loop_c *lc = ti->private;
+	struct file_map_c *fc = lc->map_data;
+
+	spin_lock_irq(&fc->lock);
+	wake = bio_list_empty(&fc->in);
+	bio_list_add(&fc->in, bio);
+	spin_unlock_irq(&fc->lock);
+
+	/*
+	 * only call queue_work() if necessary to avoid
+	 * superfluous preempt_{disable/enable}() overhead.
+	 */
+	if (wake)
+		queue_work(fc->wq, &fc->ws);
+
+	/* handling bio -> will submit later */
+	return 0;
+}
+
+static void destroy_file_map(struct loop_c *lc)
+{
+	loop_work_exit(lc->map_data);
+	kfree(lc->map_data);
+}
+
+/* 
+ * Set up a file map context and workqueue
+ */
+static int setup_file_map(struct loop_c *lc)
+{
+	struct file_map_c *fc = kzalloc(sizeof(*fc), GFP_KERNEL);
+	if (!fc)
+		return -ENOMEM;
+	lc->map_data = fc;
+	spin_lock_init(&fc->lock);
+	bio_list_init(&fc->in);
+	bio_list_init(&fc->work);
+	fc->loop = lc;
+
+	lc->map_fn = loop_file_map;
+	return loop_work_init(lc);
+}
+
+/*--------------------------------------------------------------------
+ * Block I/O helper routines
+ *--------------------------------------------------------------------*/
+
+static int contains_sector(struct extent *e, sector_t s)
+{
+	if (likely(e))
+		return s < (e->start + (e->len)) &&
+			s >= e->start;
+	BUG();
+	return 0;
+}
+
+/*
+ * Return an extent range (i.e. beginning+ending physical block numbers). 
+ */
+static int extent_range(struct loop_c * lc, struct inode * inode, blkcnt_t logical_blk,
+			blkcnt_t last_blk, blkcnt_t *begin_blk, blkcnt_t *end_blk)
+{
+	sector_t dist = 0, phys_blk, probe_blk = logical_blk;
+
+	/* Find beginning physical block of extent starting at logical_blk. */
+	*begin_blk = phys_blk = bmap(inode, probe_blk);
+	if (!phys_blk)
+		return -ENXIO;
+
+	for (; phys_blk == *begin_blk + dist; dist++) {
+		*end_blk = phys_blk;
+		if (++probe_blk > last_blk)
+			break;
+
+		phys_blk = bmap(inode, probe_blk);
+		if (unlikely(!phys_blk))
+			return -ENXIO;
+	}
+
+	return 0;
+
+}
+
+/*
+ * Walk over a linked list of extent_list structures, freeing them as
+ * we go. Does not free el->extent.
+ */
+static void destroy_extent_list(struct list_head *head)
+{
+	struct list_head *curr, *n;
+
+	if (list_empty(head))
+		return;
+
+	list_for_each_safe(curr, n, head) {
+		struct extent_list *el;
+		el = list_entry(curr, struct extent_list, list);
+		list_del(curr);
+		kfree(el);
+	}
+}
+
+/*
+ * Add a new extent to the tail of the list at *head with 
+ * start/to/len parameters. Allocates from the extent cache.
+ */
+static int list_add_extent(struct list_head *head, 
+		sector_t start, sector_t to, sector_t len)
+{
+	struct extent *extent;
+	struct extent_list *list;
+	
+	if (!(extent = kmem_cache_alloc(extent_cache, GFP_KERNEL)))
+		goto out;
+	
+	if (!(list = kmalloc(sizeof(*list), GFP_KERNEL)))
+		goto out;
+
+	extent->start = start;
+	extent->to = to;
+	extent->len = len;
+
+	list->extent = extent;
+
+	list_add_tail(&list->list, head);
+
+	return 0;
+out:
+	if (extent)
+		kmem_cache_free(extent_cache, extent);
+	return -ENOMEM;
+}
+
+/* 
+ * Create a sequential list of extents from an inode and return 
+ * it in *head. On success the number of extents found is returned,
+ * or -ERRNO on error 
+ */
+static int loop_extents(struct loop_c *lc, struct inode *inode, 
+			struct list_head *head)
+{
+	sector_t start = 0;
+	int r, nr_extents = 0;
+	blkcnt_t nr_blks = 0, begin_blk = 0, end_blk = 0;
+	blkcnt_t last_blk = sec2blk(lc, lc->mapped_sectors) - 1;
+	blkcnt_t logical_blk = sec2blk(lc, lc->offset);
+
+	while (logical_blk <= last_blk) {
+		r = extent_range(lc, inode, logical_blk, last_blk,
+				&begin_blk, &end_blk);
+		if (unlikely(r)) {
+			DMERR("%s has a hole; sparse file detected - "
+				"switching to filesystem I/O", lc->path);
+			clear_bit(BLOCK_TYPE, &lc->flags);
+			set_bit(FILE_TYPE, &lc->flags);
+			return r;
+		}
+
+		nr_blks = 1 + end_blk - begin_blk;
+
+		if (likely(nr_blks)) {
+			r = list_add_extent(head, start,
+				blk2sec(lc, begin_blk), 
+				blk2sec(lc, nr_blks));
+
+			if (unlikely(r))
+				return r;
+
+			nr_extents++;
+			start += blk2sec(lc, nr_blks);
+			begin_blk += nr_blks;
+			logical_blk += nr_blks;
+		}
+	}
+
+	return nr_extents;
+}
+
+/*
+ * Walk over the extents in a block_map_c, returning them to the cache and
+ * freeing bc via kfree or vfree as appropriate.
+ */
+static void destroy_block_map(struct block_map_c *bc, int v)
+{
+	int i;
+
+	if (!bc)
+		return;
+
+	for (i = 0; i < bc->nr_extents ; i++) {
+		kmem_cache_free(extent_cache, bc->map[i]);
+	}
+	DMDEBUG("%cfreeing block map of %d entries", (v)?'v':'k', i);
+	if (v)
+		vfree(bc->map);
+	else
+		kfree(bc->map);
+	kfree(bc);
+}
+
+/*
+ * Find an extent in *bc using binary search. Returns a pointer into the
+ * map of linear extent pointers. Calculate index as (extent - bc->map).
+ */
+static struct extent **extent_binary_lookup(struct block_map_c *bc,
+					   struct extent **extent_mru,
+					   sector_t sector)
+{
+	unsigned nr_extents = bc->nr_extents;
+	unsigned delta, dist, prev_dist = 0;
+	struct extent **eptr;
+
+	/* Optimize lookup range based on MRU extent. */
+	dist = extent_mru - bc->map;
+	if ((*extent_mru)->start < sector) {
+		delta = (nr_extents - dist) / 2;
+		dist += delta;
+	} else
+		delta = dist = dist / 2;
+
+	eptr = bc->map + dist;
+	while(*eptr && !contains_sector(*eptr, sector)) {
+		if (sector >= (*eptr)->start + (*eptr)->len) {
+			prev_dist = dist;
+			if (delta > 1)
+				delta /= 2;
+
+			dist += delta;
+		} else {
+			delta = (dist - prev_dist) / 2;
+			if (!delta)
+				delta = 1;
+
+			dist -= delta;
+		}
+		eptr = bc->map + dist;
+	}
+	return eptr;
+}
+
+/*
+ * Lookup an extent for a sector using the mru cache and binary search.
+ */
+static struct extent *extent_lookup(struct block_map_c *bc, sector_t sector)
+{
+	struct extent **eptr;
+
+	spin_lock_irq(&bc->mru_lock);
+	eptr = bc->mru;
+	spin_unlock_irq(&bc->mru_lock);
+
+	if (contains_sector(*eptr, sector))
+		return *eptr;
+
+	eptr = extent_binary_lookup(bc, eptr, sector);
+	if (!eptr)
+		return NULL;
+
+	spin_lock_irq(&bc->mru_lock);
+	bc->mru = eptr;
+	spin_unlock_irq(&bc->mru_lock);
+	return *eptr;
+}
+
+/*
+ * BLOCK_TYPE map_fn. Looks up the sector in the extent map and 
+ * rewrites the bio device and bi_sector fields.
+ */
+static int loop_block_map(struct dm_target *ti, struct bio *bio)
+{
+	struct loop_c *lc = ti->private;
+	struct extent *extent = extent_lookup(lc->map_data, bio->bi_sector);
+
+	if (likely(extent)) {
+		bio->bi_bdev = lc->bdev;
+		bio->bi_sector = extent->to +
+				 (bio->bi_sector - extent->start);
+		return 1;       /* Done with bio -> submit */
+	}
+
+	DMERR("no matching extent in map for sector %llu!",
+	      (unsigned long long) bio->bi_sector + ti->begin);
+	//BUG();
+	return -EIO;
+
+}
+
+/*
+ * Turn an extent_list into a linear pointer map of nr_extents + 1 entries
+ * and set the final entry to NULL.
+ */
+static struct extent **build_extent_map(struct list_head *head, 
+				int nr_extents, unsigned long *flags)
+{
+	unsigned map_size, cache_size;
+	struct extent **map, **curr;
+	struct list_head *pos;
+
+	map_size = 1 +(sizeof(**map) * nr_extents);
+	cache_size = kmem_cache_size(extent_cache) * nr_extents;
+
+	/* FIXME: arbitrary limit (arch sensitive?)*/
+	if (map_size > (4 * PAGE_SIZE)) {
+		set_bit(VMALLOC, flags);
+		DMDEBUG("using vmalloc for extent map");
+		map = vmalloc(map_size);
+	} else
+		map = kmalloc(map_size, GFP_KERNEL);
+	if (!map)
+		return ERR_PTR(-ENOMEM);
+
+	curr = map;
+
+	DMDEBUG("allocated linear extent map of %u %s for %d extents (%u %s)", 
+		(map_size < 8192 ) ? map_size : map_size >> 10,	
+		(map_size < 8192 ) ? "bytes" : "kilobytes", nr_extents,
+		(cache_size < 8192) ? cache_size : cache_size >> 10,
+		(cache_size < 8192) ? "bytes" : "kilobytes");
+
+	list_for_each(pos, head) {
+		struct extent_list *el;
+		el = list_entry(pos, struct extent_list, list);
+		*(curr++) = el->extent;
+	}
+	*curr = NULL;
+	return map;
+}
+
+/* 
+ * Set up a block map context and extent map 
+ */
+static int setup_block_map(struct loop_c *lc, struct inode *inode)
+{
+	int r, nr_extents;
+	struct block_map_c *bc;
+	LIST_HEAD(head);
+
+	if (!inode || !inode->i_sb || !inode->i_sb->s_bdev) {
+		return -ENXIO;
+	}
+
+	/* build a linked list of extents in linear order */
+	r = loop_extents(lc, inode, &head);
+
+	if (r<0)
+		goto out;
+
+	nr_extents = r;
+	r = -ENOMEM;
+	
+	if (!(bc = kzalloc(sizeof(*bc), GFP_KERNEL)))
+		goto out;
+
+	/* create a linear map of pointers into the extent cache */
+	bc->map = build_extent_map(&head, nr_extents, &lc->flags);
+
+	if (IS_ERR(bc->map)) {
+		r = PTR_ERR(bc->map);
+		goto out;
+	}
+
+	destroy_extent_list(&head);
+
+	spin_lock_init(&bc->mru_lock);
+	bc->mru = bc->map;
+	bc->nr_extents = nr_extents;
+
+	lc->bdev = inode->i_sb->s_bdev;
+	lc->map_data = bc;
+	lc->map_fn = loop_block_map ;
+	return 0;
+
+out:
+	destroy_extent_list(&head);
+	return r;
+}
+
+/*--------------------------------------------------------------------
+ * Generic helper routines
+ *--------------------------------------------------------------------*/
+
+/*
+ * Invalidate all unlocked loop file pages
+ */
+static int loop_invalidate_file(struct file *filp)
+{
+	return invalidate_inode_pages(filp->f_mapping);
+}
+
+/*
+ * acquire or release a "no-truncate" lock on *filp.
+ * We overload the S_SWAPFILE flag for loop targets because
+ * it provides the same no-truncate semantics we require, and
+ * holding onto i_sem is no longer an option.
+ */
+static void file_truncate_lock(struct file *filp)
+{
+	struct inode *inode = filp->f_mapping->host;
+
+	mutex_lock(&inode->i_mutex);
+	inode->i_flags |= S_SWAPFILE;
+	mutex_unlock(&inode->i_mutex);
+}
+
+static void file_truncate_unlock(struct file *filp)
+{
+	struct inode *inode = filp->f_mapping->host;
+
+	mutex_lock(&inode->i_mutex);
+	inode->i_flags &= ~S_SWAPFILE;
+	mutex_unlock(&inode->i_mutex);
+}
+
+/*
+ * Fill out split_io for taget backing store
+ */
+static void set_split_io(struct dm_target *ti)
+{
+	struct loop_c *lc = ti->private;
+	if(test_bit(BLOCK_TYPE,&lc->flags))
+		/* Split I/O at block boundaries */
+		ti->split_io = 1 << (lc->blkbits - SECTOR_SHIFT);
+	else
+		ti->split_io = 64;
+	DMDEBUG("splitting io at %llu sector boundaries", 
+			(unsigned long long) ti->split_io);
+}
+
+/* 
+ * Check that the loop file is regular and available.
+ */
+static int loop_check_file(struct dm_target *ti)
+{
+	struct loop_c *lc = ti->private;
+	struct file *filp = lc->filp;
+	struct inode *inode = filp->f_mapping->host;
+
+	if (!inode) {
+		return -ENXIO;
+	}
+
+	if (!S_ISREG(inode->i_mode)) {
+		DMERR("%s is not a regular file", lc->path);
+		return -EINVAL;
+	}
+
+	if (mapping_writably_mapped(filp->f_mapping)) {
+		DMERR("%s is mapped into userspace for writing", lc->path);
+		return -EBUSY;
+	}
+
+	if (mapping_mapped(filp->f_mapping))
+		DMWARN("%s is mapped into userspace", lc->path);
+
+	if (!inode->i_sb || !inode->i_sb->s_bdev) {
+		DMWARN("%s has no blockdevice - switching to filesystem I/O", lc->path);
+		clear_bit(BLOCK_TYPE, &lc->flags);
+		set_bit(FILE_TYPE, &lc->flags);
+	}
+
+	if (IS_SWAPFILE(inode)) {
+		DMERR("%s is already in use", lc->path);
+		return -EBUSY;
+	}
+
+	return 0;
+}
+
+/*
+ * Check loop file size and store it in the loop context
+ */
+static int loop_setup_size(struct dm_target *ti)
+{
+	struct loop_c *lc = ti->private;
+	struct inode *inode = lc->filp->f_mapping->host;
+	int r = -EINVAL;
+
+	lc->size = i_size_read(inode);
+	lc->blkbits = inode->i_blkbits;
+
+	if (!lc->size){
+		ti->error = "backing file is empty";
+		goto out;
+	}
+
+	if (lc->size < to_bytes(blk2sec(lc,1))) {
+		ti->error = "backing file cannot be less than one block in size";
+		goto out;
+	}
+
+	if (lc->offset & ((1 << lc->blkbits) - 1)) {
+		ti->error = "loop file offset must be a multiple of fs blocksize";
+		goto out;
+	} 
+	if (lc->offset > to_sector(lc->size) - blk2sec(lc, 1)) {
+		ti->error = "loop file offset too large";
+		goto out;
+	}
+
+	lc->mapped_sectors = to_sector(inode->i_size) - lc->offset;
+
+	if (to_bytes(lc->mapped_sectors) < lc->size)
+		DMWARN("not using %llu bytes in incomplete block at EOF",
+		       lc->size - to_bytes(lc->mapped_sectors));
+
+	if (lc->size - lc->offset < to_bytes(ti->len)) {
+		ti->error = "mapped region cannot be smaller than target size";
+		goto out;
+	}
+
+	return 0;
+out:
+	return r;
+}
+
+/*
+ * release a loop file
+ */
+static void loop_put_file(struct file *filp)
+{
+	if (!filp)
+		return;
+
+	file_truncate_unlock(filp);
+	filp_close(filp, NULL);
+}
+
+/*
+ * open loop file and perform type, availability and size checks.
+ */
+static int loop_get_file(struct dm_target *ti)
+{
+	int flags = ((dm_table_get_mode(ti->table) & FMODE_WRITE) ?
+		    O_RDWR : O_RDONLY) | O_LARGEFILE;
+	struct loop_c *lc = ti->private;
+	struct file *filp;
+	int r = 0;
+
+	filp = filp_open(lc->path, flags, 0);
+
+	if (IS_ERR(filp))
+		return PTR_ERR(filp);
+
+	lc->filp = filp;
+
+	r = loop_check_file(ti);
+	if (r)
+		goto out_put;
+
+	r = loop_setup_size(ti);
+	if (r)
+		goto out_put;
+
+	file_truncate_lock(filp);
+	return 0;
+
+out_put:
+	fput(filp);
+	return r;
+	
+}
+
+/*
+ * invalidate mapped pages belonging to the loop file
+ */
+void loop_flush(struct dm_target *ti)
+{
+	struct loop_c *lc = ti->private;
+
+	loop_invalidate_file(lc->filp);
+}
+
+/*--------------------------------------------------------------------
+ * Device-mapper target methods
+ *--------------------------------------------------------------------*/
+/*
+ * Generic loop map function. Re-base I/O to target begin and submit
+ * mapping request to ((struct loop_c *)ti->private)->map_fn.
+ */
+static int loop_map(struct dm_target *ti, struct bio *bio,
+					union map_info *context)
+{
+	struct loop_c *lc = ti->private;
+
+	if (unlikely(bio_barrier(bio)))
+		return -EOPNOTSUPP;
+	/* rebase bio to target begin */
+	bio->bi_sector -= ti->begin;
+	if (lc->map_fn)
+		return lc->map_fn(ti, bio);
+	BUG();
+	return -EIO;
+}
+
+/*
+ * Block status helper.
+ */
+static ssize_t loop_file_status(struct loop_c *lc, char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+	struct file_map_c *fc = lc->map_data;
+	int qlen;
+
+	spin_lock_irq(&fc->lock);
+	qlen = bio_list_nr(&fc->work);
+	qlen += bio_list_nr(&fc->in);
+	spin_unlock_irq(&fc->lock);
+	DMEMIT("%d", qlen);
+	return sz;
+}
+
+/*
+ * File status helper.
+ */
+static ssize_t loop_block_status(struct loop_c *lc, char *result, unsigned maxlen)
+{
+	ssize_t sz = 0;
+	struct block_map_c *bc = lc->map_data;
+	int mru;
+	spin_lock_irq(&bc->mru_lock);
+	mru = bc->mru - bc->map;
+	spin_unlock_irq(&bc->mru_lock);
+	DMEMIT("%d %d", bc->nr_extents, mru);
+	return sz;
+}
+
+/*
+ * This needs some thought on handling unlinked backing files. some parts of
+ * the kernel return a cached name (now invalid), while others return a dcache
+ * "/path/to/foo (deleted)" name (never was/is valid). Which is better is
+ * debatable.
+ *
+ * On the one hand, using a cached name gives table output which is directly
+ * usable assuming the user re-creates the unlinked image file, on the other
+ * it is more consistent with e.g. swap to use the dcache name.
+*/
+static int loop_status(struct dm_target *ti, status_type_t type,
+				char *result, unsigned maxlen)
+{
+	struct loop_c *lc = (struct loop_c *) ti->private;
+	ssize_t sz = 0;
+
+	switch (type) {
+	case STATUSTYPE_INFO:
+		if (test_bit(BLOCK_TYPE, &lc->flags))
+			sz += loop_block_status(lc, result, maxlen - sz);
+		else if (test_bit(FILE_TYPE, &lc->flags))
+			sz += loop_file_status(lc, result, maxlen - sz);
+		break;
+
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s %llu", lc->path, lc->offset);
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Destroy a loopback mapping
+ */
+static void loop_dtr(struct dm_target *ti)
+{
+	struct loop_c *lc = ti->private;
+
+	
+	if ((dm_table_get_mode(ti->table) & FMODE_WRITE))
+		loop_invalidate_file(lc->filp);
+
+	if (test_bit(BLOCK_TYPE, &lc->flags) && lc->map_data)
+		destroy_block_map((struct block_map_c *)lc->map_data,
+				test_bit(VMALLOC, &lc->flags));
+	if (test_bit(FILE_TYPE, &lc->flags) && lc->map_data)
+		destroy_file_map(lc);
+
+	loop_put_file(lc->filp);
+	DMINFO("released file %s", lc->path);
+
+		
+	kfree(lc);
+}
+
+/*
+ * Construct a loopback mapping: <path> <offset>
+ */
+static int loop_ctr(struct dm_target *ti, unsigned argc, char **argv)
+{
+	struct loop_c *lc = NULL;
+	int r = -EINVAL;
+
+	if (argc != 2) {
+		ti->error = "invalid argument count";
+		goto out;
+	}
+
+	r = -ENOMEM;
+	lc = kzalloc(sizeof(*lc), GFP_KERNEL);
+	if (!lc) {
+		ti->error = "cannot allocate loop context";
+		goto out;
+	}
+	lc->path = kstrdup(argv[0], GFP_KERNEL);
+	if (!lc->path) {
+		ti->error = "cannot allocate loop path", -ENOMEM;
+		goto out;
+	}
+
+	ti->private = lc;
+
+	r = -EINVAL;
+	if (sscanf(argv[1], "%lld", &lc->offset) != 1) {
+		ti->error = "invalid file offset";
+		goto out;
+	}
+
+	/* defaults */
+	set_bit(BLOCK_TYPE, &lc->flags);
+	/* open & check file and set size parameters */
+	r = loop_get_file(ti);
+	if (r) {
+		ti->error = "could not open loop backing file";
+		goto out;
+	}
+
+	if (test_bit(BLOCK_TYPE, &lc->flags))
+		r = setup_block_map(lc, lc->filp->f_mapping->host);
+	if (test_bit(FILE_TYPE, &lc->flags))
+		r = setup_file_map(lc);
+	set_split_io(ti);
+
+	if (r) {
+		ti->error = "could not create extent map";
+		goto out_putf;
+	}
+
+	if (lc->bdev)
+		dm_set_device_limits(ti, lc->bdev);
+
+	DMDEBUG("constructed loop target on %s "
+		"(%lldk, %llu sectors)", lc->path,
+		(lc->size >> 10), lc->mapped_sectors);
+
+	return 0;
+
+out_putf:
+	loop_put_file(lc->filp);
+out:
+	if(lc)
+		kfree(lc);
+	return r;
+}
+
+static struct target_type loop_target = {
+	.name = "loop",
+	.version = {0, 0, 1},
+	.module = THIS_MODULE,
+	.ctr = loop_ctr,
+	.dtr = loop_dtr,
+	.map = loop_map,
+	.presuspend = loop_flush,
+	.flush = loop_flush,
+	.status = loop_status,
+};
+
+/*--------------------------------------------------------------------
+ * Module bits
+ *--------------------------------------------------------------------*/
+int __init dm_loop_init(void)
+{
+	int r;
+
+	r = dm_register_target(&loop_target);
+	if (r < 0) {
+		DMERR("register failed %d", r);
+		goto out;
+	}
+
+	r = -ENOMEM;
+
+	extent_cache = kmem_cache_create("extent_cache", sizeof(struct extent), 
+					0, SLAB_HWCACHE_ALIGN, NULL, NULL);
+	if (!extent_cache)
+		goto out;
+
+	DMINFO("registered %s", version);
+	return 0;
+
+out:
+	if (extent_cache)
+		kmem_cache_destroy(extent_cache);
+	return r;
+}
+
+void dm_loop_exit(void)
+{
+	int r;
+
+	r = dm_unregister_target(&loop_target);
+	kmem_cache_destroy(extent_cache);
+
+	if (r < 0)
+		DMERR("target unregister failed %d", r);
+	else
+		DMINFO("unregistered %s", version);
+}
+
+module_init(dm_loop_init);
+module_exit(dm_loop_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Bryn Reeves <breeves@redhat.com>");
+MODULE_DESCRIPTION("device-mapper loop target");

--------------080102070604080604050001
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080102070604080604050001--
