From: mpatocka@redhat.com
Subject: [patch 6/8] dm-bufio: use slab cache for dm_buffer
Date: Mon, 26 Mar 2018 20:29:45 +0200
Message-ID: <20180326183058.737381513@debian.vm>
References: <20180326182939.169591126@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-bufio-buffer-cache.patch
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

Use the slab cache for the structure dm_buffer, so that the size is not
padded up to the next power of two.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bufio.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/md/dm-bufio.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bufio.c	2018-03-26 15:33:50.987250000 +0200
+++ linux-2.6/drivers/md/dm-bufio.c	2018-03-26 15:34:12.907250000 +0200
@@ -100,10 +100,10 @@ struct dm_bufio_client {
 	unsigned block_size;
 	unsigned char sectors_per_block_bits;
 	unsigned char pages_per_block_bits;
-	unsigned aux_size;
 	void (*alloc_callback)(struct dm_buffer *);
 	void (*write_callback)(struct dm_buffer *);
 
+	struct kmem_cache *slab_buffer;
 	struct kmem_cache *slab_cache;
 	struct dm_io_client *dm_io;
 
@@ -435,8 +435,7 @@ static void free_buffer_data(struct dm_b
  */
 static struct dm_buffer *alloc_buffer(struct dm_bufio_client *c, gfp_t gfp_mask)
 {
-	struct dm_buffer *b = kmalloc(sizeof(struct dm_buffer) + c->aux_size,
-				      gfp_mask);
+	struct dm_buffer *b = kmem_cache_alloc(c->slab_buffer, gfp_mask);
 
 	if (!b)
 		return NULL;
@@ -445,7 +444,7 @@ static struct dm_buffer *alloc_buffer(st
 
 	b->data = alloc_buffer_data(c, gfp_mask, &b->data_mode);
 	if (!b->data) {
-		kfree(b);
+		kmem_cache_free(c->slab_buffer, b);
 		return NULL;
 	}
 
@@ -467,7 +466,7 @@ static void free_buffer(struct dm_buffer
 	adjust_total_allocated(b->data_mode, -(long)c->block_size);
 
 	free_buffer_data(c, b->data, b->data_mode);
-	kfree(b);
+	kmem_cache_free(c->slab_buffer, b);
 }
 
 /*
@@ -1641,6 +1640,7 @@ struct dm_bufio_client *dm_bufio_client_
 	int r;
 	struct dm_bufio_client *c;
 	unsigned i;
+	char slab_name[27];
 
 	BUG_ON(block_size < 1 << SECTOR_SHIFT ||
 	       (block_size & (block_size - 1)));
@@ -1658,7 +1658,6 @@ struct dm_bufio_client *dm_bufio_client_
 	c->pages_per_block_bits = (__ffs(block_size) >= PAGE_SHIFT) ?
 				  __ffs(block_size) - PAGE_SHIFT : 0;
 
-	c->aux_size = aux_size;
 	c->alloc_callback = alloc_callback;
 	c->write_callback = write_callback;
 
@@ -1683,14 +1682,22 @@ struct dm_bufio_client *dm_bufio_client_
 	}
 
 	if (block_size < PAGE_SIZE) {
-		char name[26];
-		snprintf(name, sizeof name, "dm_bufio_cache-%u", c->block_size);
-		c->slab_cache = kmem_cache_create(name, c->block_size, ARCH_KMALLOC_MINALIGN, SLAB_RECLAIM_ACCOUNT, NULL);
+		snprintf(slab_name, sizeof slab_name, "dm_bufio_cache-%u", c->block_size);
+		c->slab_cache = kmem_cache_create(slab_name, c->block_size, ARCH_KMALLOC_MINALIGN, SLAB_RECLAIM_ACCOUNT, NULL);
 		if (!c->slab_cache) {
 			r = -ENOMEM;
 			goto bad;
 		}
 	}
+	if (aux_size)
+		snprintf(slab_name, sizeof slab_name, "dm_bufio_buffer-%u", aux_size);
+	else
+		snprintf(slab_name, sizeof slab_name, "dm_bufio_buffer");
+	c->slab_buffer = kmem_cache_create(slab_name, sizeof(struct dm_buffer) + aux_size, 0, SLAB_RECLAIM_ACCOUNT, NULL);
+	if (!c->slab_buffer) {
+		r = -ENOMEM;
+		goto bad;
+	}
 
 	while (c->need_reserved_buffers) {
 		struct dm_buffer *b = alloc_buffer(c, GFP_KERNEL);
@@ -1726,6 +1733,7 @@ bad:
 		free_buffer(b);
 	}
 	kmem_cache_destroy(c->slab_cache);
+	kmem_cache_destroy(c->slab_buffer);
 	dm_io_client_destroy(c->dm_io);
 bad_dm_io:
 	mutex_destroy(&c->lock);
@@ -1773,6 +1781,7 @@ void dm_bufio_client_destroy(struct dm_b
 		BUG_ON(c->n_buffers[i]);
 
 	kmem_cache_destroy(c->slab_cache);
+	kmem_cache_destroy(c->slab_buffer);
 	dm_io_client_destroy(c->dm_io);
 	mutex_destroy(&c->lock);
 	kfree(c);
