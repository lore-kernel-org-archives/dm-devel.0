From: Stefan Bader <stefan.bader@canonical.com>
Subject: bcache super block corruption with non 4k pages
Date: Thu, 21 Jul 2016 10:58:33 +0200
Message-ID: <1469091513-11233-1-git-send-email-stefan.bader@canonical.com>
Return-path: <linux-bcache-owner@vger.kernel.org>
Sender: linux-bcache-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, dm-devel@redhat.com
Cc: liuzhengyuang521@gmail.com, kent.overstreet@gmail.com, bcache@linux.ewheeler.net, apw@canonical.com, stefan.bader@canonical.com
List-Id: dm-devel.ids

I was pointed at the thread which seems to address the same after
I wrote most of below text. Did not want to re-write this so please
bear with the odd layout.

https://www.redhat.com/archives/dm-devel/2016-June/msg00015.html

Zhengyuan tries to fix the problem by relocating the superblock on
disk. But I am not sure whether there is really any guarantee about
how __bread fills data into the buffer_head. What if there is the next
odd arch with 128K pages?

So below is an attempt to be more generic. Still I don't feel completely
happy with the way that a page moves (or is shared) between buffer_head
and biovec. What I tried to outline below is to let the register functions
allocate bio+biovec memory and use the in-memory sb_cache data to initialize
the biovec buffer.

-Stefan


---

This was seen on ppc64le with 64k page size. The problem is that
in that case __bread returns a page where b_data is not at the
start of the page. And I am not really sure that the way bcache
re-purposes the page returned by __bread to be used as biovec 
element is really a good idea.

The way it is now, I saw __bread return a 64k page where b_data
was starting at 4k offset. Then __write_super was modifying some
data at offset 0 but for example not writing the magic number again.

Not sure why (maybe this messes up flushes, too) but the bad data was not
immediately written back when the devices were registered. So at that time
bcache-super-show would report data as it was written by user-space (like
the cache type still 0 and not 3, and claiming the cache to still bei
detached).

But when stopping the cache and unregistering the cache set this changed
and bcache-super-show was reporting a bad magic number (as expected).

The patch below works around this (tested with 64k and 4k pages) but I
am not really sure this is a clean approach. My gut feeling would be that
the bio structures should be allocated speperately (I think there is a way
of allocating a bioset without using a pool). Then that separate page could
be pre-initialized from the super block structure without passing around
a page the feels more private to __bread usage...

-Stefan



From 3652e98359b876f3c1e6d7b9b7305e3411178296 Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Wed, 20 Jul 2016 12:06:27 +0200
Subject: [PATCH] bcache: handle non 4k pages returned by __bread

On non-x86 arches pages can be bigger than 4k. Currently read_super
returns a reference to the page used as buffer in the buffer_head
that is returned by __bread().
With 4k page size and a requested read this normally ends up with 
the super block data starting at offset 0. But as seen on ppc64le
with 64k page size, the data can start at an offset (from what I
saw the offset was 4k).
This causes harm later on when __write_super() maps the super
block data at the start of the page acquired before and also
not writes back all fields (particularly the super block magic).

Try to avoid this by also returning the potential offset within the
sb_page from read_super() and fully initiallize the single bvec of
the bio used for __write_super() calls. Doing that is the same as
would have been done in bch_bio_map() which now must not be used in
__write_super().

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>

removedebug

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/md/bcache/super.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index e169739..3e0d2de 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -62,7 +62,7 @@ struct workqueue_struct *bcache_wq;
 /* Superblock */
 
 static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
-			      struct page **res)
+			      struct page **res, unsigned int *off)
 {
 	const char *err;
 	struct cache_sb *s;
@@ -192,6 +192,7 @@ static const char *read_super(struct cache_sb *sb, struct block_device *bdev,
 	err = NULL;
 
 	get_page(bh->b_page);
+	*off = (unsigned int) (bh->b_data - ((char *) page_address(bh->b_page)));
 	*res = bh->b_page;
 err:
 	put_bh(bh);
@@ -202,19 +203,19 @@ static void write_bdev_super_endio(struct bio *bio)
 {
 	struct cached_dev *dc = bio->bi_private;
 	/* XXX: error checking */
-
 	closure_put(&dc->sb_write);
 }
 
 static void __write_super(struct cache_sb *sb, struct bio *bio)
 {
-	struct cache_sb *out = page_address(bio->bi_io_vec[0].bv_page);
+	struct cache_sb *out = page_address(bio->bi_io_vec[0].bv_page) +
+			       bio->bi_io_vec[0].bv_offset;
 	unsigned i;
 
 	bio->bi_iter.bi_sector	= SB_SECTOR;
 	bio->bi_rw		= REQ_SYNC|REQ_META;
 	bio->bi_iter.bi_size	= SB_SIZE;
-	bch_bio_map(bio, NULL);
+	// bch_bio_map(bio, NULL);
 
 	out->offset		= cpu_to_le64(sb->offset);
 	out->version		= cpu_to_le64(sb->version);
@@ -1139,6 +1140,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned block_size)
 /* Cached device - bcache superblock */
 
 static void register_bdev(struct cache_sb *sb, struct page *sb_page,
+				 unsigned int sb_off,
 				 struct block_device *bdev,
 				 struct cached_dev *dc)
 {
@@ -1154,6 +1156,8 @@ static void register_bdev(struct cache_sb *sb, struct page *sb_page,
 	dc->sb_bio.bi_max_vecs	= 1;
 	dc->sb_bio.bi_io_vec	= dc->sb_bio.bi_inline_vecs;
 	dc->sb_bio.bi_io_vec[0].bv_page = sb_page;
+	dc->sb_bio.bi_io_vec[0].bv_len = SB_SIZE;
+	dc->sb_bio.bi_io_vec[0].bv_offset = sb_off;
 	get_page(sb_page);
 
 	if (cached_dev_init(dc, sb->block_size << 9))
@@ -1839,6 +1843,7 @@ static int cache_alloc(struct cache_sb *sb, struct cache *ca)
 }
 
 static int register_cache(struct cache_sb *sb, struct page *sb_page,
+				unsigned int sb_off,
 				struct block_device *bdev, struct cache *ca)
 {
 	char name[BDEVNAME_SIZE];
@@ -1853,6 +1858,8 @@ static int register_cache(struct cache_sb *sb, struct page *sb_page,
 	ca->sb_bio.bi_max_vecs	= 1;
 	ca->sb_bio.bi_io_vec	= ca->sb_bio.bi_inline_vecs;
 	ca->sb_bio.bi_io_vec[0].bv_page = sb_page;
+	ca->sb_bio.bi_io_vec[0].bv_len  = SB_SIZE;
+	ca->sb_bio.bi_io_vec[0].bv_offset = sb_off;
 	get_page(sb_page);
 
 	if (blk_queue_discard(bdev_get_queue(ca->bdev)))
@@ -1936,6 +1943,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	struct cache_sb *sb = NULL;
 	struct block_device *bdev = NULL;
 	struct page *sb_page = NULL;
+	unsigned int sb_off;
 
 	if (!try_module_get(THIS_MODULE))
 		return -EBUSY;
@@ -1967,7 +1975,7 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 	if (set_blocksize(bdev, 4096))
 		goto err_close;
 
-	err = read_super(sb, bdev, &sb_page);
+	err = read_super(sb, bdev, &sb_page, &sb_off);
 	if (err)
 		goto err_close;
 
@@ -1977,14 +1985,14 @@ static ssize_t register_bcache(struct kobject *k, struct kobj_attribute *attr,
 			goto err_close;
 
 		mutex_lock(&bch_register_lock);
-		register_bdev(sb, sb_page, bdev, dc);
+		register_bdev(sb, sb_page, sb_off, bdev, dc);
 		mutex_unlock(&bch_register_lock);
 	} else {
 		struct cache *ca = kzalloc(sizeof(*ca), GFP_KERNEL);
 		if (!ca)
 			goto err_close;
 
-		if (register_cache(sb, sb_page, bdev, ca) != 0)
+		if (register_cache(sb, sb_page, sb_off, bdev, ca) != 0)
 			goto err_close;
 	}
 out:
-- 
1.9.1
