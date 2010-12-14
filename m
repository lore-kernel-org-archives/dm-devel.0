From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 8] md backout dm dirty log
Date: Tue, 14 Dec 2010 15:16:08 -0600
Message-ID: <201012142116.oBELG8tL015298@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Patch name: md-backout-dm-dirty-log.patch

Back out commit e384e58549a2e9a83071ad80280c1a9053cfd84c,
as MD should not need to use DM's dirty log.

Next patch will add back some of the small changes that
also went into the above patch that are unrelated to
adding DM dirty log support and should stay.  I could have
put the two patches together, but I have them separate
in-case you'd rather back out the above commit and apply
the next small patch separately.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/bitmap.c
===================================================================
--- linux-2.6.orig/drivers/md/bitmap.c
+++ linux-2.6/drivers/md/bitmap.c
@@ -29,7 +29,6 @@
 #include "md.h"
 #include "bitmap.h"
 
-#include <linux/dm-dirty-log.h>
 /* debug macros */
 
 #define DEBUG 0
@@ -695,8 +694,6 @@ static inline unsigned long file_page_of
 static inline struct page *filemap_get_page(struct bitmap *bitmap,
 					unsigned long chunk)
 {
-	if (bitmap->filemap == NULL)
-		return NULL;
 	if (file_page_index(bitmap, chunk) >= bitmap->file_pages)
 		return NULL;
 	return bitmap->filemap[file_page_index(bitmap, chunk)
@@ -796,28 +793,19 @@ enum bitmap_page_attr {
 static inline void set_page_attr(struct bitmap *bitmap, struct page *page,
 				enum bitmap_page_attr attr)
 {
-	if (page)
-		__set_bit((page->index<<2) + attr, bitmap->filemap_attr);
-	else
-		__set_bit(attr, &bitmap->logattrs);
+	__set_bit((page->index<<2) + attr, bitmap->filemap_attr);
 }
 
 static inline void clear_page_attr(struct bitmap *bitmap, struct page *page,
 				enum bitmap_page_attr attr)
 {
-	if (page)
-		__clear_bit((page->index<<2) + attr, bitmap->filemap_attr);
-	else
-		__clear_bit(attr, &bitmap->logattrs);
+	__clear_bit((page->index<<2) + attr, bitmap->filemap_attr);
 }
 
 static inline unsigned long test_page_attr(struct bitmap *bitmap, struct page *page,
 					   enum bitmap_page_attr attr)
 {
-	if (page)
-		return test_bit((page->index<<2) + attr, bitmap->filemap_attr);
-	else
-		return test_bit(attr, &bitmap->logattrs);
+	return test_bit((page->index<<2) + attr, bitmap->filemap_attr);
 }
 
 /*
@@ -830,30 +818,27 @@ static inline unsigned long test_page_at
 static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 {
 	unsigned long bit;
-	struct page *page = NULL;
+	struct page *page;
 	void *kaddr;
 	unsigned long chunk = block >> CHUNK_BLOCK_SHIFT(bitmap);
 
-	if (!bitmap->filemap) {
-		struct dm_dirty_log *log = bitmap->mddev->bitmap_info.log;
-		if (log)
-			log->type->mark_region(log, chunk);
-	} else {
+	if (!bitmap->filemap)
+		return;
 
-		page = filemap_get_page(bitmap, chunk);
-		if (!page)
-			return;
-		bit = file_page_offset(bitmap, chunk);
+	page = filemap_get_page(bitmap, chunk);
+	if (!page)
+		return;
+	bit = file_page_offset(bitmap, chunk);
+
+	/* set the bit */
+	kaddr = kmap_atomic(page, KM_USER0);
+	if (bitmap->flags & BITMAP_HOSTENDIAN)
+		set_bit(bit, kaddr);
+	else
+		ext2_set_bit(bit, kaddr);
+	kunmap_atomic(kaddr, KM_USER0);
+	PRINTK("set file bit %lu page %lu\n", bit, page->index);
 
-		/* set the bit */
-		kaddr = kmap_atomic(page, KM_USER0);
-		if (bitmap->flags & BITMAP_HOSTENDIAN)
-			set_bit(bit, kaddr);
-		else
-			ext2_set_bit(bit, kaddr);
-		kunmap_atomic(kaddr, KM_USER0);
-		PRINTK("set file bit %lu page %lu\n", bit, page->index);
-	}
 	/* record page number so it gets flushed to disk when unplug occurs */
 	set_page_attr(bitmap, page, BITMAP_PAGE_DIRTY);
 }
@@ -870,16 +855,6 @@ void bitmap_unplug(struct bitmap *bitmap
 
 	if (!bitmap)
 		return;
-	if (!bitmap->filemap) {
-		/* Must be using a dirty_log */
-		struct dm_dirty_log *log = bitmap->mddev->bitmap_info.log;
-		dirty = test_and_clear_bit(BITMAP_PAGE_DIRTY, &bitmap->logattrs);
-		need_write = test_and_clear_bit(BITMAP_PAGE_NEEDWRITE, &bitmap->logattrs);
-		if (dirty || need_write)
-			if (log->type->flush(log))
-				bitmap->flags |= BITMAP_WRITE_ERROR;
-		goto out;
-	}
 
 	/* look at each page to see if there are any set bits that need to be
 	 * flushed out to disk */
@@ -908,7 +883,6 @@ void bitmap_unplug(struct bitmap *bitmap
 		else
 			md_super_wait(bitmap->mddev);
 	}
-out:
 	if (bitmap->flags & BITMAP_WRITE_ERROR)
 		bitmap_file_kick(bitmap);
 }
@@ -951,11 +925,11 @@ static int bitmap_init_from_disk(struct 
 		printk(KERN_INFO "%s: bitmap file is out of date, doing full "
 			"recovery\n", bmname(bitmap));
 
-	bytes = DIV_ROUND_UP(bitmap->chunks, 8);
+	bytes = (chunks + 7) / 8;
 	if (!bitmap->mddev->bitmap_info.external)
 		bytes += sizeof(bitmap_super_t);
 
-	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
+	num_pages = (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
 
 	if (file && i_size_read(file->f_mapping->host) < bytes) {
 		printk(KERN_INFO "%s: bitmap file too short %lu < %lu\n",
@@ -1117,7 +1091,6 @@ void bitmap_daemon_work(mddev_t *mddev)
 	struct page *page = NULL, *lastpage = NULL;
 	sector_t blocks;
 	void *paddr;
-	struct dm_dirty_log *log = mddev->bitmap_info.log;
 
 	/* Use a mutex to guard daemon_work against
 	 * bitmap_destroy.
@@ -1142,12 +1115,11 @@ void bitmap_daemon_work(mddev_t *mddev)
 	spin_lock_irqsave(&bitmap->lock, flags);
 	for (j = 0; j < bitmap->chunks; j++) {
 		bitmap_counter_t *bmc;
-		if (!bitmap->filemap) {
-			if (!log)
-				/* error or shutdown */
-				break;
-		} else
-			page = filemap_get_page(bitmap, j);
+		if (!bitmap->filemap)
+			/* error or shutdown */
+			break;
+
+		page = filemap_get_page(bitmap, j);
 
 		if (page != lastpage) {
 			/* skip this page unless it's marked as needing cleaning */
@@ -1216,17 +1188,14 @@ void bitmap_daemon_work(mddev_t *mddev)
 						  -1);
 
 				/* clear the bit */
-				if (page) {
-					paddr = kmap_atomic(page, KM_USER0);
-					if (bitmap->flags & BITMAP_HOSTENDIAN)
-						clear_bit(file_page_offset(bitmap, j),
-							  paddr);
-					else
-						ext2_clear_bit(file_page_offset(bitmap, j),
-							       paddr);
-					kunmap_atomic(paddr, KM_USER0);
-				} else
-					log->type->clear_region(log, j);
+				paddr = kmap_atomic(page, KM_USER0);
+				if (bitmap->flags & BITMAP_HOSTENDIAN)
+					clear_bit(file_page_offset(bitmap, j),
+						  paddr);
+				else
+					ext2_clear_bit(file_page_offset(bitmap, j),
+						       paddr);
+				kunmap_atomic(paddr, KM_USER0);
 			}
 		} else
 			j |= PAGE_COUNTER_MASK;
@@ -1234,16 +1203,12 @@ void bitmap_daemon_work(mddev_t *mddev)
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 
 	/* now sync the final page */
-	if (lastpage != NULL || log != NULL) {
+	if (lastpage != NULL) {
 		spin_lock_irqsave(&bitmap->lock, flags);
 		if (test_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE)) {
 			clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
-			if (lastpage)
-				write_page(bitmap, lastpage, 0);
-			else
-				if (log->type->flush(log))
-					bitmap->flags |= BITMAP_WRITE_ERROR;
+			write_page(bitmap, lastpage, 0);
 		} else {
 			set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1408,9 +1373,7 @@ void bitmap_endwrite(struct bitmap *bitm
 		(*bmc)--;
 		if (*bmc <= 2)
 			set_page_attr(bitmap,
-				      filemap_get_page(
-					      bitmap,
-					      offset >> CHUNK_BLOCK_SHIFT(bitmap)),
+				      filemap_get_page(bitmap, offset >> CHUNK_BLOCK_SHIFT(bitmap)),
 				      BITMAP_PAGE_CLEAN);
 
 		spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1685,13 +1648,10 @@ int bitmap_create(mddev_t *mddev)
 
 	BUILD_BUG_ON(sizeof(bitmap_super_t) != 256);
 
-	if (!file
-	    && !mddev->bitmap_info.offset
-	    && !mddev->bitmap_info.log) /* bitmap disabled, nothing to do */
+	if (!file && !mddev->bitmap_info.offset) /* bitmap disabled, nothing to do */
 		return 0;
 
 	BUG_ON(file && mddev->bitmap_info.offset);
-	BUG_ON(mddev->bitmap_info.offset && mddev->bitmap_info.log);
 
 	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
 	if (!bitmap)
@@ -1778,6 +1738,7 @@ int bitmap_create(mddev_t *mddev)
 int bitmap_load(mddev_t *mddev)
 {
 	int err = 0;
+	sector_t start = 0;
 	sector_t sector = 0;
 	struct bitmap *bitmap = mddev->bitmap;
 
@@ -1796,24 +1757,14 @@ int bitmap_load(mddev_t *mddev)
 	}
 	bitmap_close_sync(bitmap);
 
-	if (mddev->bitmap_info.log) {
-		unsigned long i;
-		struct dm_dirty_log *log = mddev->bitmap_info.log;
-		for (i = 0; i < bitmap->chunks; i++)
-			if (!log->type->in_sync(log, i, 1))
-				bitmap_set_memory_bits(bitmap,
-						       (sector_t)i << CHUNK_BLOCK_SHIFT(bitmap),
-						       1);
-	} else {
-		sector_t start = 0;
-		if (mddev->degraded == 0
-		    || bitmap->events_cleared == mddev->events)
-			/* no need to keep dirty bits to optimise a
-			 * re-add of a missing device */
-			start = mddev->recovery_cp;
+	if (mddev->degraded == 0
+	    || bitmap->events_cleared == mddev->events)
+		/* no need to keep dirty bits to optimise a
+		 * re-add of a missing device */
+		start = mddev->recovery_cp;
+
+	err = bitmap_init_from_disk(bitmap, start);
 
-		err = bitmap_init_from_disk(bitmap, start);
-	}
 	if (err)
 		goto out;
 
Index: linux-2.6/drivers/md/bitmap.h
===================================================================
--- linux-2.6.orig/drivers/md/bitmap.h
+++ linux-2.6/drivers/md/bitmap.h
@@ -222,10 +222,6 @@ struct bitmap {
 	unsigned long file_pages; /* number of pages in the file */
 	int last_page_size; /* bytes in the last page */
 
-	unsigned long logattrs; /* used when filemap_attr doesn't exist
-				 * because we are working with a dirty_log
-				 */
-
 	unsigned long flags;
 
 	int allclean;
@@ -247,7 +243,6 @@ struct bitmap {
 	wait_queue_head_t behind_wait;
 
 	struct sysfs_dirent *sysfs_can_clear;
-
 };
 
 /* the bitmap API */
Index: linux-2.6/drivers/md/md.h
===================================================================
--- linux-2.6.orig/drivers/md/md.h
+++ linux-2.6/drivers/md/md.h
@@ -313,11 +313,6 @@ struct mddev_s
 							 * hot-adding a bitmap.  It should
 							 * eventually be settable by sysfs.
 							 */
-		/* When md is serving under dm, it might use a
-		 * dirty_log to store the bits.
-		 */
-		struct dm_dirty_log *log;
-
 		struct mutex		mutex;
 		unsigned long		chunksize;
 		unsigned long		daemon_sleep; /* how many jiffies between updates? */
