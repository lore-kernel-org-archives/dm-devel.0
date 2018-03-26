From: mpatocka@redhat.com
Subject: [patch 7/8] dm-bufio: support non-power-of-two block
	sizes
Date: Mon, 26 Mar 2018 20:29:46 +0200
Message-ID: <20180326183100.004252446@debian.vm>
References: <20180326182939.169591126@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-bufio-non-power-of-two-size.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: mpatocka@redhat.com, msnitzer@redhat.com, agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Support sector sizes that are not a power of two. Slab cache is used for
allocations.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   64 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 39 insertions(+), 25 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2018-03-26 15:34:20.577250000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2018-03-26 15:34:20.577250000 +0200
@@ -57,12 +57,6 @@
 #define DM_BUFIO_INLINE_VECS		16
 
 /*
- * Don't try to use alloc_pages for blocks larger than this.
- * For explanation, see alloc_buffer_data below.
- */
-#define DM_BUFIO_BLOCK_SIZE_GFP_LIMIT	(PAGE_SIZE << (MAX_ORDER - 1))
-
-/*
  * Align buffer writes to this boundary.
  * Tests show that SSDs have the highest IOPS when using 4k writes.
  */
@@ -98,8 +92,7 @@ struct dm_bufio_client {
 
 	struct block_device *bdev;
 	unsigned block_size;
-	unsigned char sectors_per_block_bits;
-	unsigned char pages_per_block_bits;
+	s8 sectors_per_block_bits;
 	void (*alloc_callback)(struct dm_buffer *);
 	void (*write_callback)(struct dm_buffer *);
 
@@ -375,11 +368,11 @@ static void *alloc_buffer_data(struct dm
 		return kmem_cache_alloc(c->slab_cache, gfp_mask);
 	}
 
-	if (c->block_size <= DM_BUFIO_BLOCK_SIZE_GFP_LIMIT &&
+	if (c->block_size <= KMALLOC_MAX_SIZE &&
 	    gfp_mask & __GFP_NORETRY) {
 		*data_mode = DATA_MODE_GET_FREE_PAGES;
 		return (void *)__get_free_pages(gfp_mask,
-						c->pages_per_block_bits);
+						c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
 	}
 
 	*data_mode = DATA_MODE_VMALLOC;
@@ -416,7 +409,8 @@ static void free_buffer_data(struct dm_b
 		break;
 
 	case DATA_MODE_GET_FREE_PAGES:
-		free_pages((unsigned long)data, c->pages_per_block_bits);
+		free_pages((unsigned long)data,
+			   c->sectors_per_block_bits - (PAGE_SHIFT - SECTOR_SHIFT));
 		break;
 
 	case DATA_MODE_VMALLOC:
@@ -634,10 +628,14 @@ static void submit_io(struct dm_buffer *
 	sector_t sector;
 	unsigned offset, end;
 
-	sector = (b->block << b->c->sectors_per_block_bits) + b->c->start;
+	if (likely(b->c->sectors_per_block_bits >= 0))
+		sector = b->block << b->c->sectors_per_block_bits;
+	else
+		sector = b->block * (b->c->block_size >> SECTOR_SHIFT);
+	sector += b->c->start;
 
 	if (rw != REQ_OP_WRITE) {
-		n_sectors = 1 << b->c->sectors_per_block_bits;
+		n_sectors = b->c->block_size >> SECTOR_SHIFT;
 		offset = 0;
 	} else {
 		if (b->c->write_callback)
@@ -941,8 +939,11 @@ static void __get_memory_limit(struct dm
 		}
 	}
 
-	buffers = dm_bufio_cache_size_per_client >>
-		  (c->sectors_per_block_bits + SECTOR_SHIFT);
+	buffers = dm_bufio_cache_size_per_client;
+	if (likely(c->sectors_per_block_bits >= 0))
+		buffers >>= c->sectors_per_block_bits + SECTOR_SHIFT;
+	else
+		buffers /= c->block_size;
 
 	if (buffers < c->minimum_buffers)
 		buffers = c->minimum_buffers;
@@ -1476,8 +1477,12 @@ EXPORT_SYMBOL_GPL(dm_bufio_get_block_siz
 
 sector_t dm_bufio_get_device_size(struct dm_bufio_client *c)
 {
-	return i_size_read(c->bdev->bd_inode) >>
-			   (SECTOR_SHIFT + c->sectors_per_block_bits);
+	sector_t s = i_size_read(c->bdev->bd_inode) >> SECTOR_SHIFT;
+	if (likely(c->sectors_per_block_bits >= 0))
+		s >>= c->sectors_per_block_bits;
+	else
+		sector_div(s, c->block_size >> SECTOR_SHIFT);
+	return s;
 }
 EXPORT_SYMBOL_GPL(dm_bufio_get_device_size);
 
@@ -1575,8 +1580,12 @@ static bool __try_evict_buffer(struct dm
 
 static unsigned long get_retain_buffers(struct dm_bufio_client *c)
 {
-        unsigned long retain_bytes = READ_ONCE(dm_bufio_retain_bytes);
-        return retain_bytes >> (c->sectors_per_block_bits + SECTOR_SHIFT);
+	unsigned long retain_bytes = READ_ONCE(dm_bufio_retain_bytes);
+	if (likely(c->sectors_per_block_bits >= 0))
+		retain_bytes >>= c->sectors_per_block_bits + SECTOR_SHIFT;
+	else
+		retain_bytes /= c->block_size;
+	return retain_bytes;
 }
 
 static unsigned long __scan(struct dm_bufio_client *c, unsigned long nr_to_scan,
@@ -1642,8 +1651,11 @@ struct dm_bufio_client *dm_bufio_client_
 	unsigned i;
 	char slab_name[27];
 
-	BUG_ON(block_size < 1 << SECTOR_SHIFT ||
-	       (block_size & (block_size - 1)));
+	if (!block_size || block_size & ((1 << SECTOR_SHIFT) - 1)) {
+		WARN_ON(1);
+		r = -EINVAL;
+		goto bad_client;
+	}
 
 	c = kzalloc(sizeof(*c), GFP_KERNEL);
 	if (!c) {
@@ -1654,9 +1666,10 @@ struct dm_bufio_client *dm_bufio_client_
 
 	c->bdev = bdev;
 	c->block_size = block_size;
-	c->sectors_per_block_bits = __ffs(block_size) - SECTOR_SHIFT;
-	c->pages_per_block_bits = (__ffs(block_size) >= PAGE_SHIFT) ?
-				  __ffs(block_size) - PAGE_SHIFT : 0;
+	if (is_power_of_2(block_size))
+		c->sectors_per_block_bits = __ffs(block_size) - SECTOR_SHIFT;
+	else
+		c->sectors_per_block_bits = -1;
 
 	c->alloc_callback = alloc_callback;
 	c->write_callback = write_callback;
@@ -1681,7 +1694,8 @@ struct dm_bufio_client *dm_bufio_client_
 		goto bad_dm_io;
 	}
 
-	if (block_size < PAGE_SIZE) {
+	if (block_size <= KMALLOC_MAX_SIZE &&
+	    (block_size < PAGE_SIZE || !is_power_of_2(block_size))) {
 		snprintf(slab_name, sizeof slab_name, "dm_bufio_cache-%u", c->block_size);
 		c->slab_cache = kmem_cache_create(slab_name, c->block_size, ARCH_KMALLOC_MINALIGN, SLAB_RECLAIM_ACCOUNT, NULL);
 		if (!c->slab_cache) {
