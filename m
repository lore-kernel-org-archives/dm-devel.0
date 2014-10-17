From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH 01/17] dm bufio: switch from a huge hash
	table to an rbtree
Date: Fri, 17 Oct 2014 02:06:51 -0400
Message-ID: <1413526027-21630-2-git-send-email-snitzer@redhat.com>
References: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1413526027-21630-1-git-send-email-snitzer@redhat.com>
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
Cc: ejt@redhat.com
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Converting over to using an rbtree eliminates a fixed 8MB allocation
from vmalloc space for the hash table.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-bufio.c | 97 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 54 insertions(+), 43 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 0be200b..dcaa1d9 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -14,6 +14,7 @@
 #include <linux/vmalloc.h>
 #include <linux/shrinker.h>
 #include <linux/module.h>
+#include <linux/rbtree.h>
 
 #define DM_MSG_PREFIX "bufio"
 
@@ -48,14 +49,6 @@
 #define DM_BUFIO_INLINE_VECS		16
 
 /*
- * Buffer hash
- */
-#define DM_BUFIO_HASH_BITS	20
-#define DM_BUFIO_HASH(block) \
-	((((block) >> DM_BUFIO_HASH_BITS) ^ (block)) & \
-	 ((1 << DM_BUFIO_HASH_BITS) - 1))
-
-/*
  * Don't try to use kmem_cache_alloc for blocks larger than this.
  * For explanation, see alloc_buffer_data below.
  */
@@ -106,7 +99,7 @@ struct dm_bufio_client {
 
 	unsigned minimum_buffers;
 
-	struct hlist_head *cache_hash;
+	struct rb_root buffer_tree;
 	wait_queue_head_t free_buffer_wait;
 
 	int async_write_error;
@@ -135,7 +128,7 @@ enum data_mode {
 };
 
 struct dm_buffer {
-	struct hlist_node hash_list;
+	struct rb_node node;
 	struct list_head lru_list;
 	sector_t block;
 	void *data;
@@ -253,6 +246,53 @@ static LIST_HEAD(dm_bufio_all_clients);
  */
 static DEFINE_MUTEX(dm_bufio_clients_lock);
 
+/*----------------------------------------------------------------
+ * A red/black tree acts as an index for all the buffers.
+ *--------------------------------------------------------------*/
+static struct dm_buffer *__find(struct dm_bufio_client *c, sector_t block)
+{
+	struct rb_node *n = c->buffer_tree.rb_node;
+	struct dm_buffer *b;
+
+	while (n) {
+		b = container_of(n, struct dm_buffer, node);
+
+		if (b->block == block)
+			return b;
+
+		n = (b->block < block) ? n->rb_left : n->rb_right;
+	}
+
+	return NULL;
+}
+
+static void __insert(struct dm_bufio_client *c, struct dm_buffer *b)
+{
+	struct rb_node **new = &c->buffer_tree.rb_node, *parent = NULL;
+	struct dm_buffer *found;
+
+	while (*new) {
+		found = container_of(*new, struct dm_buffer, node);
+
+		if (found->block == b->block) {
+			BUG_ON(found != b);
+			return;
+		}
+
+		parent = *new;
+		new = (found->block < b->block) ?
+			&((*new)->rb_left) : &((*new)->rb_right);
+	}
+
+	rb_link_node(&b->node, parent, new);
+	rb_insert_color(&b->node, &c->buffer_tree);
+}
+
+static void __remove(struct dm_bufio_client *c, struct dm_buffer *b)
+{
+	rb_erase(&b->node, &c->buffer_tree);
+}
+
 /*----------------------------------------------------------------*/
 
 static void adjust_total_allocated(enum data_mode data_mode, long diff)
@@ -434,7 +474,7 @@ static void __link_buffer(struct dm_buffer *b, sector_t block, int dirty)
 	b->block = block;
 	b->list_mode = dirty;
 	list_add(&b->lru_list, &c->lru[dirty]);
-	hlist_add_head(&b->hash_list, &c->cache_hash[DM_BUFIO_HASH(block)]);
+	__insert(b->c, b);
 	b->last_accessed = jiffies;
 }
 
@@ -448,7 +488,7 @@ static void __unlink_buffer(struct dm_buffer *b)
 	BUG_ON(!c->n_buffers[b->list_mode]);
 
 	c->n_buffers[b->list_mode]--;
-	hlist_del(&b->hash_list);
+	__remove(b->c, b);
 	list_del(&b->lru_list);
 }
 
@@ -888,23 +928,6 @@ static void __check_watermark(struct dm_bufio_client *c,
 		__write_dirty_buffers_async(c, 1, write_list);
 }
 
-/*
- * Find a buffer in the hash.
- */
-static struct dm_buffer *__find(struct dm_bufio_client *c, sector_t block)
-{
-	struct dm_buffer *b;
-
-	hlist_for_each_entry(b, &c->cache_hash[DM_BUFIO_HASH(block)],
-			     hash_list) {
-		dm_bufio_cond_resched();
-		if (b->block == block)
-			return b;
-	}
-
-	return NULL;
-}
-
 /*----------------------------------------------------------------
  * Getting a buffer
  *--------------------------------------------------------------*/
@@ -1534,11 +1557,7 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 		r = -ENOMEM;
 		goto bad_client;
 	}
-	c->cache_hash = vmalloc(sizeof(struct hlist_head) << DM_BUFIO_HASH_BITS);
-	if (!c->cache_hash) {
-		r = -ENOMEM;
-		goto bad_hash;
-	}
+	c->buffer_tree = RB_ROOT;
 
 	c->bdev = bdev;
 	c->block_size = block_size;
@@ -1557,9 +1576,6 @@ struct dm_bufio_client *dm_bufio_client_create(struct block_device *bdev, unsign
 		c->n_buffers[i] = 0;
 	}
 
-	for (i = 0; i < 1 << DM_BUFIO_HASH_BITS; i++)
-		INIT_HLIST_HEAD(&c->cache_hash[i]);
-
 	mutex_init(&c->lock);
 	INIT_LIST_HEAD(&c->reserved_buffers);
 	c->need_reserved_buffers = reserved_buffers;
@@ -1633,8 +1649,6 @@ bad_cache:
 	}
 	dm_io_client_destroy(c->dm_io);
 bad_dm_io:
-	vfree(c->cache_hash);
-bad_hash:
 	kfree(c);
 bad_client:
 	return ERR_PTR(r);
@@ -1661,9 +1675,7 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 
 	mutex_unlock(&dm_bufio_clients_lock);
 
-	for (i = 0; i < 1 << DM_BUFIO_HASH_BITS; i++)
-		BUG_ON(!hlist_empty(&c->cache_hash[i]));
-
+	BUG_ON(!RB_EMPTY_ROOT(&c->buffer_tree));
 	BUG_ON(c->need_reserved_buffers);
 
 	while (!list_empty(&c->reserved_buffers)) {
@@ -1681,7 +1693,6 @@ void dm_bufio_client_destroy(struct dm_bufio_client *c)
 		BUG_ON(c->n_buffers[i]);
 
 	dm_io_client_destroy(c->dm_io);
-	vfree(c->cache_hash);
 	kfree(c);
 }
 EXPORT_SYMBOL_GPL(dm_bufio_client_destroy);
-- 
1.9.3
