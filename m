From: NeilBrown <neilb@suse.de>
Subject: [PATCH 22/24] md/bitmap: prepare for storing write-intent-bitmap via
	dm-dirty-log.
Date: Tue, 01 Jun 2010 19:56:20 +1000
Message-ID: <20100601095620.565.91552.stgit@notabene.brown>
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

This allows md/raid5 to fully work as a dm target.

Normally md uses a 'filemap' which contains a list of pages of bits
each of which may be written separately.
dm-log uses and all-or-nothing approach to writing the log, so
when using a dm-log, ->filemap is NULL and the flags normally stored
in filemap_attr are stored in ->logattrs instead.



Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/bitmap.c |  128 +++++++++++++++++++++++++++++++++++----------------
 drivers/md/bitmap.h |    5 ++
 drivers/md/md.h     |    5 ++
 3 files changed, 99 insertions(+), 39 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 29a3c86..9376526 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -29,6 +29,7 @@
 #include "md.h"
 #include "bitmap.h"
 
+#include <linux/dm-dirty-log.h>
 /* debug macros */
 
 #define DEBUG 0
@@ -694,6 +695,8 @@ static inline unsigned long file_page_offset(struct bitmap *bitmap, unsigned lon
 static inline struct page *filemap_get_page(struct bitmap *bitmap,
 					unsigned long chunk)
 {
+	if (bitmap->filemap == NULL)
+		return NULL;
 	if (file_page_index(bitmap, chunk) >= bitmap->file_pages)
 		return NULL;
 	return bitmap->filemap[file_page_index(bitmap, chunk)
@@ -793,19 +796,28 @@ enum bitmap_page_attr {
 static inline void set_page_attr(struct bitmap *bitmap, struct page *page,
 				enum bitmap_page_attr attr)
 {
-	__set_bit((page->index<<2) + attr, bitmap->filemap_attr);
+	if (page)
+		__set_bit((page->index<<2) + attr, bitmap->filemap_attr);
+	else
+		__set_bit(attr, &bitmap->logattrs);
 }
 
 static inline void clear_page_attr(struct bitmap *bitmap, struct page *page,
 				enum bitmap_page_attr attr)
 {
-	__clear_bit((page->index<<2) + attr, bitmap->filemap_attr);
+	if (page)
+		__clear_bit((page->index<<2) + attr, bitmap->filemap_attr);
+	else
+		__clear_bit(attr, &bitmap->logattrs);
 }
 
 static inline unsigned long test_page_attr(struct bitmap *bitmap, struct page *page,
 					   enum bitmap_page_attr attr)
 {
-	return test_bit((page->index<<2) + attr, bitmap->filemap_attr);
+	if (page)
+		return test_bit((page->index<<2) + attr, bitmap->filemap_attr);
+	else
+		return test_bit(attr, &bitmap->logattrs);
 }
 
 /*
@@ -818,27 +830,30 @@ static inline unsigned long test_page_attr(struct bitmap *bitmap, struct page *p
 static void bitmap_file_set_bit(struct bitmap *bitmap, sector_t block)
 {
 	unsigned long bit;
-	struct page *page;
+	struct page *page = NULL;
 	void *kaddr;
 	unsigned long chunk = block >> CHUNK_BLOCK_SHIFT(bitmap);
 
-	if (!bitmap->filemap)
-		return;
-
-	page = filemap_get_page(bitmap, chunk);
-	if (!page)
-		return;
-	bit = file_page_offset(bitmap, chunk);
+	if (!bitmap->filemap) {
+		struct dm_dirty_log *log = bitmap->mddev->bitmap_info.log;
+		if (log)
+			log->type->mark_region(log, chunk);
+	} else {
 
-	/* set the bit */
-	kaddr = kmap_atomic(page, KM_USER0);
-	if (bitmap->flags & BITMAP_HOSTENDIAN)
-		set_bit(bit, kaddr);
-	else
-		ext2_set_bit(bit, kaddr);
-	kunmap_atomic(kaddr, KM_USER0);
-	PRINTK("set file bit %lu page %lu\n", bit, page->index);
+		page = filemap_get_page(bitmap, chunk);
+		if (!page)
+			return;
+		bit = file_page_offset(bitmap, chunk);
 
+		/* set the bit */
+		kaddr = kmap_atomic(page, KM_USER0);
+		if (bitmap->flags & BITMAP_HOSTENDIAN)
+			set_bit(bit, kaddr);
+		else
+			ext2_set_bit(bit, kaddr);
+		kunmap_atomic(kaddr, KM_USER0);
+		PRINTK("set file bit %lu page %lu\n", bit, page->index);
+	}
 	/* record page number so it gets flushed to disk when unplug occurs */
 	set_page_attr(bitmap, page, BITMAP_PAGE_DIRTY);
 }
@@ -855,6 +870,16 @@ void bitmap_unplug(struct bitmap *bitmap)
 
 	if (!bitmap)
 		return;
+	if (!bitmap->filemap) {
+		/* Must be using a dirty_log */
+		struct dm_dirty_log *log = bitmap->mddev->bitmap_info.log;
+		dirty = test_and_clear_bit(BITMAP_PAGE_DIRTY, &bitmap->logattrs);
+		need_write = test_and_clear_bit(BITMAP_PAGE_NEEDWRITE, &bitmap->logattrs);
+		if (dirty || need_write)
+			if (log->type->flush(log))
+				bitmap->flags |= BITMAP_WRITE_ERROR;
+		goto out;
+	}
 
 	/* look at each page to see if there are any set bits that need to be
 	 * flushed out to disk */
@@ -883,6 +908,7 @@ void bitmap_unplug(struct bitmap *bitmap)
 		else
 			md_super_wait(bitmap->mddev);
 	}
+out:
 	if (bitmap->flags & BITMAP_WRITE_ERROR)
 		bitmap_file_kick(bitmap);
 }
@@ -925,11 +951,11 @@ static int bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
 		printk(KERN_INFO "%s: bitmap file is out of date, doing full "
 			"recovery\n", bmname(bitmap));
 
-	bytes = (chunks + 7) / 8;
+	bytes = DIV_ROUND_UP(bitmap->chunks, 8);
 	if (!bitmap->mddev->bitmap_info.external)
 		bytes += sizeof(bitmap_super_t);
 
-	num_pages = (bytes + PAGE_SIZE - 1) / PAGE_SIZE;
+	num_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
 
 	if (file && i_size_read(file->f_mapping->host) < bytes) {
 		printk(KERN_INFO "%s: bitmap file too short %lu < %lu\n",
@@ -1090,6 +1116,7 @@ void bitmap_daemon_work(mddev_t *mddev)
 	struct page *page = NULL, *lastpage = NULL;
 	int blocks;
 	void *paddr;
+	struct dm_dirty_log *log = mddev->bitmap_info.log;
 
 	/* Use a mutex to guard daemon_work against
 	 * bitmap_destroy.
@@ -1114,11 +1141,12 @@ void bitmap_daemon_work(mddev_t *mddev)
 	spin_lock_irqsave(&bitmap->lock, flags);
 	for (j = 0; j < bitmap->chunks; j++) {
 		bitmap_counter_t *bmc;
-		if (!bitmap->filemap)
-			/* error or shutdown */
-			break;
-
-		page = filemap_get_page(bitmap, j);
+		if (!bitmap->filemap) {
+			if (!log)
+				/* error or shutdown */
+				break;
+		} else
+			page = filemap_get_page(bitmap, j);
 
 		if (page != lastpage) {
 			/* skip this page unless it's marked as needing cleaning */
@@ -1187,14 +1215,17 @@ void bitmap_daemon_work(mddev_t *mddev)
 						  -1);
 
 				/* clear the bit */
-				paddr = kmap_atomic(page, KM_USER0);
-				if (bitmap->flags & BITMAP_HOSTENDIAN)
-					clear_bit(file_page_offset(bitmap, j),
-						  paddr);
-				else
-					ext2_clear_bit(file_page_offset(bitmap, j),
-						       paddr);
-				kunmap_atomic(paddr, KM_USER0);
+				if (page) {
+					paddr = kmap_atomic(page, KM_USER0);
+					if (bitmap->flags & BITMAP_HOSTENDIAN)
+						clear_bit(file_page_offset(bitmap, j),
+							  paddr);
+					else
+						ext2_clear_bit(file_page_offset(bitmap, j),
+							       paddr);
+					kunmap_atomic(paddr, KM_USER0);
+				} else
+					log->type->clear_region(log, j);
 			}
 		} else
 			j |= PAGE_COUNTER_MASK;
@@ -1202,12 +1233,16 @@ void bitmap_daemon_work(mddev_t *mddev)
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 
 	/* now sync the final page */
-	if (lastpage != NULL) {
+	if (lastpage != NULL || log != NULL) {
 		spin_lock_irqsave(&bitmap->lock, flags);
 		if (test_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE)) {
 			clear_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
-			write_page(bitmap, lastpage, 0);
+			if (lastpage)
+				write_page(bitmap, lastpage, 0);
+			else
+				if (log->type->flush(log))
+					bitmap->flags |= BITMAP_WRITE_ERROR;
 		} else {
 			set_page_attr(bitmap, lastpage, BITMAP_PAGE_NEEDWRITE);
 			spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1372,7 +1407,9 @@ void bitmap_endwrite(struct bitmap *bitmap, sector_t offset, unsigned long secto
 		(*bmc)--;
 		if (*bmc <= 2)
 			set_page_attr(bitmap,
-				      filemap_get_page(bitmap, offset >> CHUNK_BLOCK_SHIFT(bitmap)),
+				      filemap_get_page(
+					      bitmap,
+					      offset >> CHUNK_BLOCK_SHIFT(bitmap)),
 				      BITMAP_PAGE_CLEAN);
 
 		spin_unlock_irqrestore(&bitmap->lock, flags);
@@ -1649,10 +1686,13 @@ int bitmap_create(mddev_t *mddev)
 
 	BUILD_BUG_ON(sizeof(bitmap_super_t) != 256);
 
-	if (!file && !mddev->bitmap_info.offset) /* bitmap disabled, nothing to do */
+	if (!file
+	    && !mddev->bitmap_info.offset
+	    && !mddev->bitmap_info.log) /* bitmap disabled, nothing to do */
 		return 0;
 
 	BUG_ON(file && mddev->bitmap_info.offset);
+	BUG_ON(mddev->bitmap_info.offset && mddev->bitmap_info.log);
 
 	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
 	if (!bitmap)
@@ -1730,7 +1770,17 @@ int bitmap_create(mddev_t *mddev)
 	    || bitmap->events_cleared == mddev->events)
 		/* no need to keep dirty bits to optimise a re-add of a missing device */
 		start = mddev->recovery_cp;
-	err = bitmap_init_from_disk(bitmap, start);
+	if (mddev->bitmap_info.log) {
+		unsigned long i;
+		struct dm_dirty_log *log = mddev->bitmap_info.log;
+		for (i = 0; i < bitmap->chunks; i++)
+			if (!log->type->in_sync(log, i, 1))
+				bitmap_set_memory_bits(bitmap,
+						       (sector_t)i << CHUNK_BLOCK_SHIFT(bitmap),
+						       1);
+		err = 0;
+	} else
+		err = bitmap_init_from_disk(bitmap, start);
 
 	if (err)
 		goto error;
diff --git a/drivers/md/bitmap.h b/drivers/md/bitmap.h
index 3797dea..a7a1113 100644
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -222,6 +222,10 @@ struct bitmap {
 	unsigned long file_pages; /* number of pages in the file */
 	int last_page_size; /* bytes in the last page */
 
+	unsigned long logattrs; /* used when filemap_attr doesn't exist
+				 * because we are working with a dirty_log
+				 */
+
 	unsigned long flags;
 
 	int allclean;
@@ -243,6 +247,7 @@ struct bitmap {
 	wait_queue_head_t behind_wait;
 
 	struct sysfs_dirent *sysfs_can_clear;
+
 };
 
 /* the bitmap API */
diff --git a/drivers/md/md.h b/drivers/md/md.h
index a97e4b0..e97466f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -314,6 +314,11 @@ struct mddev_s
 							 * hot-adding a bitmap.  It should
 							 * eventually be settable by sysfs.
 							 */
+		/* When md is serving under dm, it might use a
+		 * dirty_log to store the bits.
+		 */
+		struct dm_dirty_log *log;
+
 		struct mutex		mutex;
 		unsigned long		chunksize;
 		unsigned long		daemon_sleep; /* how many seconds between updates? */


