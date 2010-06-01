From: NeilBrown <neilb@suse.de>
Subject: [PATCH 17/24] md/bitmap: white space clean up and similar.
Date: Tue, 01 Jun 2010 19:56:20 +1000
Message-ID: <20100601095620.565.52947.stgit@notabene.brown>
References: <20100601094414.565.3638.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100601094414.565.3638.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: linux-raid@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Fixes some whitespace problems
Fixed some checkpatch.pl complaints.
Replaced kmalloc ... memset(0), with kzalloc
Fixed an unlikely memory leak on an error path.
Reformatted a number of 'if/else' sets, sometimes
replacing goto with an else clause.
Removed some old comments and commented-out code.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |  301 +++++++++++++++++++++++----------------------------
 1 files changed, 135 insertions(+), 166 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 4518994..67fb32d 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -13,7 +13,6 @@
  * Still to do:
  *
  * flush after percent set rather than just time based. (maybe both).
- * wait if count gets too high, wake when it drops to half.
  */
 
 #include <linux/blkdev.h>
@@ -51,9 +50,6 @@
 #define INJECT_FATAL_FAULT_3 0 /* undef */
 #endif
 
-//#define DPRINTK PRINTK /* set this NULL to avoid verbose debug output */
-#define DPRINTK(x...) do { } while(0)
-
 #ifndef PRINTK
 #  if DEBUG > 0
 #    define PRINTK(x...) printk(KERN_DEBUG x)
@@ -62,12 +58,11 @@
 #  endif
 #endif
 
-static inline char * bmname(struct bitmap *bitmap)
+static inline char *bmname(struct bitmap *bitmap)
 {
 	return bitmap->mddev ? mdname(bitmap->mddev) : "mdX";
 }
 
-
 /*
  * just a placeholder - calls kmalloc for bitmap pages
  */
@@ -78,7 +73,7 @@ static unsigned char *bitmap_alloc_page(struct bitmap *bitmap)
 #ifdef INJECT_FAULTS_1
 	page = NULL;
 #else
-	page = kmalloc(PAGE_SIZE, GFP_NOIO);
+	page = kzalloc(PAGE_SIZE, GFP_NOIO);
 #endif
 	if (!page)
 		printk("%s: bitmap_alloc_page FAILED\n", bmname(bitmap));
@@ -107,7 +102,8 @@ static void bitmap_free_page(struct bitmap *bitmap, unsigned char *page)
  * if we find our page, we increment the page's refcount so that it stays
  * allocated while we're using it
  */
-static int bitmap_checkpage(struct bitmap *bitmap, unsigned long page, int create)
+static int bitmap_checkpage(struct bitmap *bitmap,
+			    unsigned long page, int create)
 __releases(bitmap->lock)
 __acquires(bitmap->lock)
 {
@@ -121,7 +117,6 @@ __acquires(bitmap->lock)
 		return -EINVAL;
 	}
 
-
 	if (bitmap->bp[page].hijacked) /* it's hijacked, don't try to alloc */
 		return 0;
 
@@ -131,43 +126,34 @@ __acquires(bitmap->lock)
 	if (!create)
 		return -ENOENT;
 
-	spin_unlock_irq(&bitmap->lock);
-
 	/* this page has not been allocated yet */
 
-	if ((mappage = bitmap_alloc_page(bitmap)) == NULL) {
+	spin_unlock_irq(&bitmap->lock);
+	mappage = bitmap_alloc_page(bitmap);
+	spin_lock_irq(&bitmap->lock);
+
+	if (mappage == NULL) {
 		PRINTK("%s: bitmap map page allocation failed, hijacking\n",
 			bmname(bitmap));
 		/* failed - set the hijacked flag so that we can use the
 		 * pointer as a counter */
-		spin_lock_irq(&bitmap->lock);
 		if (!bitmap->bp[page].map)
 			bitmap->bp[page].hijacked = 1;
-		goto out;
-	}
-
-	/* got a page */
-
-	spin_lock_irq(&bitmap->lock);
-
-	/* recheck the page */
-
-	if (bitmap->bp[page].map || bitmap->bp[page].hijacked) {
+	} else if (bitmap->bp[page].map ||
+		   bitmap->bp[page].hijacked) {
 		/* somebody beat us to getting the page */
 		bitmap_free_page(bitmap, mappage);
 		return 0;
-	}
+	} else {
 
-	/* no page was in place and we have one, so install it */
+		/* no page was in place and we have one, so install it */
 
-	memset(mappage, 0, PAGE_SIZE);
-	bitmap->bp[page].map = mappage;
-	bitmap->missing_pages--;
-out:
+		bitmap->bp[page].map = mappage;
+		bitmap->missing_pages--;
+	}
 	return 0;
 }
 
-
 /* if page is completely empty, put it back on the free list, or dealloc it */
 /* if page was hijacked, unmark the flag so it might get alloced next time */
 /* Note: lock should be held when calling this */
@@ -183,26 +169,15 @@ static void bitmap_checkfree(struct bitmap *bitmap, unsigned long page)
 	if (bitmap->bp[page].hijacked) { /* page was hijacked, undo this now */
 		bitmap->bp[page].hijacked = 0;
 		bitmap->bp[page].map = NULL;
-		return;
+	} else {
+		/* normal case, free the page */
+		ptr = bitmap->bp[page].map;
+		bitmap->bp[page].map = NULL;
+		bitmap->missing_pages++;
+		bitmap_free_page(bitmap, ptr);
 	}
-
-	/* normal case, free the page */
-
-#if 0
-/* actually ... let's not.  We will probably need the page again exactly when
- * memory is tight and we are flusing to disk
- */
-	return;
-#else
-	ptr = bitmap->bp[page].map;
-	bitmap->bp[page].map = NULL;
-	bitmap->missing_pages++;
-	bitmap_free_page(bitmap, ptr);
-	return;
-#endif
 }
 
-
 /*
  * bitmap file handling - read and write the bitmap file and its superblock
  */
@@ -220,11 +195,14 @@ static struct page *read_sb_page(mddev_t *mddev, loff_t offset,
 
 	mdk_rdev_t *rdev;
 	sector_t target;
+	int did_alloc = 0;
 
-	if (!page)
+	if (!page) {
 		page = alloc_page(GFP_KERNEL);
-	if (!page)
-		return ERR_PTR(-ENOMEM);
+		if (!page)
+			return ERR_PTR(-ENOMEM);
+		did_alloc = 1;
+	}
 
 	list_for_each_entry(rdev, &mddev->disks, same_set) {
 		if (! test_bit(In_sync, &rdev->flags)
@@ -242,6 +220,8 @@ static struct page *read_sb_page(mddev_t *mddev, loff_t offset,
 			return page;
 		}
 	}
+	if (did_alloc)
+		put_page(page);
 	return ERR_PTR(-EIO);
 
 }
@@ -286,49 +266,51 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 	mddev_t *mddev = bitmap->mddev;
 
 	while ((rdev = next_active_rdev(rdev, mddev)) != NULL) {
-			int size = PAGE_SIZE;
-			loff_t offset = mddev->bitmap_info.offset;
-			if (page->index == bitmap->file_pages-1)
-				size = roundup(bitmap->last_page_size,
-					       bdev_logical_block_size(rdev->bdev));
-			/* Just make sure we aren't corrupting data or
-			 * metadata
-			 */
-			if (mddev->external) {
-				/* Bitmap could be anywhere. */
-				if (rdev->sb_start + offset + (page->index *(PAGE_SIZE/512)) >
-				    rdev->data_offset &&
-				    rdev->sb_start + offset < 
-				    rdev->data_offset + mddev->dev_sectors +
-				    (PAGE_SIZE/512))
-					goto bad_alignment;
-			} else if (offset < 0) {
-				/* DATA  BITMAP METADATA  */
-				if (offset
-				    + (long)(page->index * (PAGE_SIZE/512))
-				    + size/512 > 0)
-					/* bitmap runs in to metadata */
-					goto bad_alignment;
-				if (rdev->data_offset + mddev->dev_sectors
-				    > rdev->sb_start + offset)
-					/* data runs in to bitmap */
-					goto bad_alignment;
-			} else if (rdev->sb_start < rdev->data_offset) {
-				/* METADATA BITMAP DATA */
-				if (rdev->sb_start
-				    + offset
-				    + page->index*(PAGE_SIZE/512) + size/512
-				    > rdev->data_offset)
-					/* bitmap runs in to data */
-					goto bad_alignment;
-			} else {
-				/* DATA METADATA BITMAP - no problems */
-			}
-			md_super_write(mddev, rdev,
-				       rdev->sb_start + offset
-				       + page->index * (PAGE_SIZE/512),
-				       size,
-				       page);
+		int size = PAGE_SIZE;
+		loff_t offset = mddev->bitmap_info.offset;
+		if (page->index == bitmap->file_pages-1)
+			size = roundup(bitmap->last_page_size,
+				       bdev_logical_block_size(rdev->bdev));
+		/* Just make sure we aren't corrupting data or
+		 * metadata
+		 */
+		if (mddev->external) {
+			/* Bitmap could be anywhere. */
+			if (rdev->sb_start + offset + (page->index
+						       * (PAGE_SIZE/512))
+			    > rdev->data_offset
+			    &&
+			    rdev->sb_start + offset
+			    < (rdev->data_offset + mddev->dev_sectors
+			     + (PAGE_SIZE/512)))
+				goto bad_alignment;
+		} else if (offset < 0) {
+			/* DATA  BITMAP METADATA  */
+			if (offset
+			    + (long)(page->index * (PAGE_SIZE/512))
+			    + size/512 > 0)
+				/* bitmap runs in to metadata */
+				goto bad_alignment;
+			if (rdev->data_offset + mddev->dev_sectors
+			    > rdev->sb_start + offset)
+				/* data runs in to bitmap */
+				goto bad_alignment;
+		} else if (rdev->sb_start < rdev->data_offset) {
+			/* METADATA BITMAP DATA */
+			if (rdev->sb_start
+			    + offset
+			    + page->index*(PAGE_SIZE/512) + size/512
+			    > rdev->data_offset)
+				/* bitmap runs in to data */
+				goto bad_alignment;
+		} else {
+			/* DATA METADATA BITMAP - no problems */
+		}
+		md_super_write(mddev, rdev,
+			       rdev->sb_start + offset
+			       + page->index * (PAGE_SIZE/512),
+			       size,
+			       page);
 	}
 
 	if (wait)
@@ -364,10 +346,9 @@ static void write_page(struct bitmap *bitmap, struct page *page, int wait)
 			bh = bh->b_this_page;
 		}
 
-		if (wait) {
+		if (wait)
 			wait_event(bitmap->write_wait,
 				   atomic_read(&bitmap->pending_writes)==0);
-		}
 	}
 	if (bitmap->flags & BITMAP_WRITE_ERROR)
 		bitmap_file_kick(bitmap);
@@ -424,7 +405,7 @@ static struct page *read_page(struct file *file, unsigned long index,
 	struct buffer_head *bh;
 	sector_t block;
 
-	PRINTK("read bitmap file (%dB @ %Lu)\n", (int)PAGE_SIZE,
+	PRINTK("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
 			(unsigned long long)index << PAGE_SHIFT);
 
 	page = alloc_page(GFP_KERNEL);
@@ -478,7 +459,7 @@ static struct page *read_page(struct file *file, unsigned long index,
 	}
 out:
 	if (IS_ERR(page))
-		printk(KERN_ALERT "md: bitmap read error: (%dB @ %Lu): %ld\n",
+		printk(KERN_ALERT "md: bitmap read error: (%dB @ %llu): %ld\n",
 			(int)PAGE_SIZE,
 			(unsigned long long)index << PAGE_SHIFT,
 			PTR_ERR(page));
@@ -664,11 +645,14 @@ static int bitmap_mask_state(struct bitmap *bitmap, enum bitmap_state bits,
 	sb = kmap_atomic(bitmap->sb_page, KM_USER0);
 	old = le32_to_cpu(sb->state) & bits;
 	switch (op) {
-		case MASK_SET: sb->state |= cpu_to_le32(bits);
-				break;
-		case MASK_UNSET: sb->state &= cpu_to_le32(~bits);
-				break;
-		default: BUG();
+	case MASK_SET:
+		sb->state |= cpu_to_le32(bits);
+		break;
+	case MASK_UNSET:
+		sb->state &= cpu_to_le32(~bits);
+		break;
+	default:
+		BUG();
 	}
 	kunmap_atomic(sb, KM_USER0);
 	return old;
@@ -710,12 +694,12 @@ static inline unsigned long file_page_offset(struct bitmap *bitmap, unsigned lon
 static inline struct page *filemap_get_page(struct bitmap *bitmap,
 					unsigned long chunk)
 {
-	if (file_page_index(bitmap, chunk) >= bitmap->file_pages) return NULL;
+	if (file_page_index(bitmap, chunk) >= bitmap->file_pages)
+		return NULL;
 	return bitmap->filemap[file_page_index(bitmap, chunk)
 			       - file_page_index(bitmap, 0)];
 }
 
-
 static void bitmap_file_unmap(struct bitmap *bitmap)
 {
 	struct page **map, *sb_page;
@@ -766,7 +750,6 @@ static void bitmap_file_put(struct bitmap *bitmap)
 	}
 }
 
-
 /*
  * bitmap_file_kick - if an error occurs while manipulating the bitmap file
  * then it is no longer reliable, so we stop using it and we mark the file
@@ -785,7 +768,6 @@ static void bitmap_file_kick(struct bitmap *bitmap)
 				ptr = d_path(&bitmap->file->f_path, path,
 					     PAGE_SIZE);
 
-
 			printk(KERN_ALERT
 			      "%s: kicking failed bitmap file %s from array!\n",
 			      bmname(bitmap), IS_ERR(ptr) ? "" : ptr);
@@ -803,9 +785,9 @@ static void bitmap_file_kick(struct bitmap *bitmap)
 }
 
 enum bitmap_page_attr {
-	BITMAP_PAGE_DIRTY = 0, // there are set bits that need to be synced
-	BITMAP_PAGE_CLEAN = 1, // there are bits that might need to be cleared
-	BITMAP_PAGE_NEEDWRITE=2, // there are cleared bits that need to be synced
+	BITMAP_PAGE_DIRTY = 0,     /* there are set bits that need to be synced */
+	BITMAP_PAGE_CLEAN = 1,     /* there are bits that might need to be cleared */
+	BITMAP_PAGE_NEEDWRITE = 2, /* there are cleared bits that need to be synced */
 };
 
 static inline void set_page_attr(struct bitmap *bitmap, struct page *page,
@@ -840,15 +822,15 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 	void *kaddr;
 	unsigned long chunk = block >> CHUNK_BLOCK_SHIFT(bitmap);
 
-	if (!bitmap->filemap) {
+	if (!bitmap->filemap)
 		return;
-	}
 
 	page = filemap_get_page(bitmap, chunk);
-	if (!page) return;
+	if (!page)
+		return;
 	bit = file_page_offset(bitmap, chunk);
 
- 	/* set the bit */
+	/* set the bit */
 	kaddr = kmap_atomic(page, KM_USER0);
 	if (bitmap->flags & BITMAP_HOSTENDIAN)
 		set_bit(bit, kaddr);
@@ -859,7 +841,6 @@ static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 
 	/* record page number so it gets flushed to disk when unplug occurs */
 	set_page_attr(bitmap, page, BITMAP_PAGE_DIRTY);
-
 }
 
 /* this gets called when the md device is ready to unplug its underlying
@@ -892,7 +873,7 @@ void bitmap_unplug(struct bitmap *bitmap)
 			wait = 1;
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 
-		if (dirty | need_write)
+		if (dirty || need_write)
 			write_page(bitmap, page, 0);
 	}
 	if (wait) { /* if any writes were performed, we need to wait on them */
@@ -905,6 +886,7 @@ void bitmap_unplug(struct bitmap *bitmap)
 	if (bitmap->flags & BITMAP_WRITE_ERROR)
 		bitmap_file_kick(bitmap);
 }
+EXPORT_SYMBOL(bitmap_unplug);
 
 static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed);
 /* * bitmap_init_from_disk -- called at bitmap_create time to initialize
@@ -947,7 +929,6 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 	if (!bitmap->mddev->bitmap_info.external)
 		bytes += sizeof(bitmap_super_t);
 
-	
 	num_pages = (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
 
 	if (file && i_size_read(file->f_mapping->host) < bytes) {
@@ -966,7 +947,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 
 	/* We need 4 bits per page, rounded up to a multiple of sizeof(unsigned long) */
 	bitmap->filemap_attr = kzalloc(
-		roundup( DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
+		roundup(DIV_ROUND_UP(num_pages*4, 8), sizeof(unsigned long)),
 		GFP_KERNEL);
 	if (!bitmap->filemap_attr)
 		goto err;
@@ -1021,7 +1002,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 			if (outofdate) {
 				/*
 				 * if bitmap is out of date, dirty the
-			 	 * whole page and write it out
+				 * whole page and write it out
 				 */
 				paddr = kmap_atomic(page, KM_USER0);
 				memset(paddr + offset, 0xff,
@@ -1052,7 +1033,7 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		}
 	}
 
- 	/* everything went OK */
+	/* everything went OK */
 	ret = 0;
 	bitmap_mask_state(bitmap, BITMAP_STALE, MASK_UNSET);
 
@@ -1080,21 +1061,16 @@ void bitmap_write_all(struct bitmap *bitmap)
 	 */
 	int i;
 
-	for (i=0; i < bitmap->file_pages; i++)
+	for (i = 0; i < bitmap->file_pages; i++)
 		set_page_attr(bitmap, bitmap->filemap[i],
 			      BITMAP_PAGE_NEEDWRITE);
 }
 
-
 static void bitmap_count_page(struct bitmap *bitmap, sector_t offset, int inc)
 {
 	sector_t chunk = offset >> CHUNK_BLOCK_SHIFT(bitmap);
 	unsigned long page = chunk >> PAGE_COUNTER_SHIFT;
 	bitmap->bp[page].count += inc;
-/*
-	if (page == 0) printk("count page 0, offset %llu: %d gives %d\n",
-			      (unsigned long long)offset, inc, bitmap->bp[page].count);
-*/
 	bitmap_checkfree(bitmap, page);
 }
 static bitmap_counter_t *bitmap_get_counter(struct bitmap *bitmap,
@@ -1197,14 +1173,11 @@ void bitmap_daemon_work(mddev_t *mddev)
 					 (sector_t)j << CHUNK_BLOCK_SHIFT(bitmap),
 					 &blocks, 0);
 		if (bmc) {
-/*
-  if (j < 100) printk("bitmap: j=%lu, *bmc = 0x%x\n", j, *bmc);
-*/
 			if (*bmc)
 				bitmap->allclean = 0;
 
 			if (*bmc == 2) {
-				*bmc=1; /* maybe clear the bit next time */
+				*bmc = 1; /* maybe clear the bit next time */
 				set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
 			} else if (*bmc == 1 && !bitmap->need_sync) {
 				/* we can clear the bit */
@@ -1243,7 +1216,7 @@ void bitmap_daemon_work(mddev_t *mddev)
 
  done:
 	if (bitmap->allclean == 0)
-		bitmap->mddev->thread->timeout = 
+		bitmap->mddev->thread->timeout =
 			bitmap->mddev->bitmap_info.daemon_sleep;
 	mutex_unlock(&mddev->bitmap_info.mutex);
 }
@@ -1265,7 +1238,7 @@ __acquires(bitmap->lock)
 
 	if (bitmap_checkpage(bitmap, page, create) < 0) {
 		csize = ((sector_t)1) << (CHUNK_BLOCK_SHIFT(bitmap));
-		*blocks = csize - (offset & (csize- 1));
+		*blocks = csize - (offset & (csize - 1));
 		return NULL;
 	}
 	/* now locked ... */
@@ -1276,12 +1249,12 @@ __acquires(bitmap->lock)
 		int hi = (pageoff > PAGE_COUNTER_MASK);
 		csize = ((sector_t)1) << (CHUNK_BLOCK_SHIFT(bitmap) +
 					  PAGE_COUNTER_SHIFT - 1);
-		*blocks = csize - (offset & (csize- 1));
+		*blocks = csize - (offset & (csize - 1));
 		return  &((bitmap_counter_t *)
 			  &bitmap->bp[page].map)[hi];
 	} else { /* page is allocated */
 		csize = ((sector_t)1) << (CHUNK_BLOCK_SHIFT(bitmap));
-		*blocks = csize - (offset & (csize- 1));
+		*blocks = csize - (offset & (csize - 1));
 		return (bitmap_counter_t *)
 			&(bitmap->bp[page].map[pageoff]);
 	}
@@ -1289,7 +1262,8 @@ __acquires(bitmap->lock)
 
 int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors, int behind)
 {
-	if (!bitmap) return 0;
+	if (!bitmap)
+		return 0;
 
 	if (behind) {
 		int bw;
@@ -1328,10 +1302,10 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 			continue;
 		}
 
-		switch(*bmc) {
+		switch (*bmc) {
 		case 0:
 			bitmap_file_set_bit(bitmap, offset);
-			bitmap_count_page(bitmap,offset, 1);
+			bitmap_count_page(bitmap, offset, 1);
 			blk_plug_device_unlocked(bitmap->mddev->queue);
 			/* fall through */
 		case 1:
@@ -1345,16 +1319,19 @@ int bitmap_startwrite(struct bitmap *bitmap, sector_t offset, unsigned long sect
 		offset += blocks;
 		if (sectors > blocks)
 			sectors -= blocks;
-		else sectors = 0;
+		else
+			sectors = 0;
 	}
 	bitmap->allclean = 0;
 	return 0;
 }
+EXPORT_SYMBOL(bitmap_startwrite);
 
 void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long sectors,
 		     int success, int behind)
 {
-	if (!bitmap) return;
+	if (!bitmap)
+		return;
 	if (behind) {
 		if (atomic_dec_and_test(&bitmap->behind_writes))
 			wake_up(&bitmap->behind_wait);
@@ -1391,18 +1368,20 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 			wake_up(&bitmap->overflow_wait);
 
 		(*bmc)--;
-		if (*bmc <= 2) {
+		if (*bmc <= 2)
 			set_page_attr(bitmap,
 				      filemap_get_page(bitmap, offset >> CHUNK_BLOCK_SHIFT(bitmap)),
 				      BITMAP_PAGE_CLEAN);
-		}
+
 		spin_unlock_irqrestore(&bitmap->lock, flags);
 		offset += blocks;
 		if (sectors > blocks)
 			sectors -= blocks;
-		else sectors = 0;
+		else
+			sectors = 0;
 	}
 }
+EXPORT_SYMBOL(bitmap_endwrite);
 
 static int __bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks,
 			       int degraded)
@@ -1455,14 +1434,14 @@ int bitmap_start_sync(struct bitmap *bitmap, sector_t offset, int *blocks,
 	}
 	return rv;
 }
+EXPORT_SYMBOL(bitmap_start_sync);
 
 void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int aborted)
 {
 	bitmap_counter_t *bmc;
 	unsigned long flags;
-/*
-	if (offset == 0) printk("bitmap_end_sync 0 (%d)\n", aborted);
-*/	if (bitmap == NULL) {
+
+	if (bitmap == NULL) {
 		*blocks = 1024;
 		return;
 	}
@@ -1471,26 +1450,23 @@ void bitmap_end_sync(struct bitmap *bitmap, sector_t offset, int *blocks, int ab
 	if (bmc == NULL)
 		goto unlock;
 	/* locked */
-/*
-	if (offset == 0) printk("bitmap_end sync found 0x%x, blocks %d\n", *bmc, *blocks);
-*/
 	if (RESYNC(*bmc)) {
 		*bmc &= ~RESYNC_MASK;
 
 		if (!NEEDED(*bmc) && aborted)
 			*bmc |= NEEDED_MASK;
 		else {
-			if (*bmc <= 2) {
+			if (*bmc <= 2)
 				set_page_attr(bitmap,
 					      filemap_get_page(bitmap, offset >> CHUNK_BLOCK_SHIFT(bitmap)),
 					      BITMAP_PAGE_CLEAN);
-			}
 		}
 	}
  unlock:
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	bitmap->allclean = 0;
 }
+EXPORT_SYMBOL(bitmap_end_sync);
 
 void bitmap_close_sync(struct bitmap *bitmap)
 {
@@ -1507,6 +1483,7 @@ void bitmap_close_sync(struct bitmap *bitmap)
 		sector += blocks;
 	}
 }
+EXPORT_SYMBOL(bitmap_close_sync);
 
 void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
 {
@@ -1537,6 +1514,7 @@ void bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector)
 	bitmap->last_end_sync = jiffies;
 	sysfs_notify(&bitmap->mddev->kobj, NULL, "sync_completed");
 }
+EXPORT_SYMBOL(bitmap_cond_end_sync);
 
 static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int needed)
 {
@@ -1553,9 +1531,9 @@ static void bitmap_set_memory_bits(struct bitmap *bitmap, sector_t offset, int n
 		spin_unlock_irq(&bitmap->lock);
 		return;
 	}
-	if (! *bmc) {
+	if (!*bmc) {
 		struct page *page;
-		*bmc = 1 | (needed?NEEDED_MASK:0);
+		*bmc = 1 | (needed ? NEEDED_MASK : 0);
 		bitmap_count_page(bitmap, offset, 1);
 		page = filemap_get_page(bitmap, offset >> CHUNK_BLOCK_SHIFT(bitmap));
 		set_page_attr(bitmap, page, BITMAP_PAGE_CLEAN);
@@ -1720,9 +1698,9 @@ int bitmap_create(mddev_t *mddev)
 	bitmap->chunkshift = ffz(~mddev->bitmap_info.chunksize);
 
 	/* now that chunksize and chunkshift are set, we can use these macros */
- 	chunks = (blocks + CHUNK_BLOCK_RATIO(bitmap) - 1) >>
+	chunks = (blocks + CHUNK_BLOCK_RATIO(bitmap) - 1) >>
 			CHUNK_BLOCK_SHIFT(bitmap);
- 	pages = (chunks + PAGE_COUNTER_RATIO - 1) / PAGE_COUNTER_RATIO;
+	pages = (chunks + PAGE_COUNTER_RATIO - 1) / PAGE_COUNTER_RATIO;
 
 	BUG_ON(!pages);
 
@@ -1775,11 +1753,11 @@ static ssize_t
 location_show(mddev_t *mddev, char *page)
 {
 	ssize_t len;
-	if (mddev->bitmap_info.file) {
+	if (mddev->bitmap_info.file)
 		len = sprintf(page, "file");
-	} else if (mddev->bitmap_info.offset) {
+	else if (mddev->bitmap_info.offset)
 		len = sprintf(page, "%+lld", (long long)mddev->bitmap_info.offset);
-	} else
+	else
 		len = sprintf(page, "none");
 	len += sprintf(page+len, "\n");
 	return len;
@@ -1868,7 +1846,7 @@ timeout_show(mddev_t *mddev, char *page)
 	ssize_t len;
 	unsigned long secs = mddev->bitmap_info.daemon_sleep / HZ;
 	unsigned long jifs = mddev->bitmap_info.daemon_sleep % HZ;
-	
+
 	len = sprintf(page, "%lu", secs);
 	if (jifs)
 		len += sprintf(page+len, ".%03u", jiffies_to_msecs(jifs));
@@ -2050,12 +2028,3 @@ struct attribute_group md_bitmap_group = {
 	.attrs = md_bitmap_attrs,
 };
 
-
-/* the bitmap API -- for raid personalities */
-EXPORT_SYMBOL(bitmap_startwrite);
-EXPORT_SYMBOL(bitmap_endwrite);
-EXPORT_SYMBOL(bitmap_start_sync);
-EXPORT_SYMBOL(bitmap_end_sync);
-EXPORT_SYMBOL(bitmap_unplug);
-EXPORT_SYMBOL(bitmap_close_sync);
-EXPORT_SYMBOL(bitmap_cond_end_sync);


