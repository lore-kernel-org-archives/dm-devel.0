From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/2] dm thin: use slab_pool for caches
Date: Thu, 12 Apr 2012 18:34:35 -0400
Message-ID: <1334270075-11699-2-git-send-email-snitzer@redhat.com>
References: <1334270075-11699-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1334270075-11699-1-git-send-email-snitzer@redhat.com>
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

Use dedicated caches prefixed with a "dm_" name rather than rely on
generic slab caches.

This will aid in debugging thinp memory leaks should they occur.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |   52 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 47 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/md/dm-thin.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin.c
+++ linux-2.6/drivers/md/dm-thin.c
@@ -141,6 +141,8 @@ static uint32_t calc_nr_buckets(unsigned
 	return n;
 }
 
+struct kmem_cache *_cell_cache;
+
 /*
  * @nr_cells should be the number of cells you want in use _concurrently_.
  * Don't confuse it with the number of distinct keys.
@@ -157,8 +159,7 @@ static struct bio_prison *prison_create(
 		return NULL;
 
 	spin_lock_init(&prison->lock);
-	prison->cell_pool = mempool_create_kmalloc_pool(nr_cells,
-							sizeof(struct cell));
+	prison->cell_pool = mempool_create_slab_pool(nr_cells, _cell_cache);
 	if (!prison->cell_pool) {
 		kfree(prison);
 		return NULL;
@@ -1649,6 +1650,9 @@ static void pool_features_init(struct po
 	pf->discard_passdown = 1;
 }
 
+struct kmem_cache *_new_mapping_cache;
+struct kmem_cache *_endio_hook_cache;
+
 static void __pool_destroy(struct pool *pool)
 {
 	__pool_table_remove(pool);
@@ -1738,7 +1742,7 @@ static struct pool *pool_create(struct m
 
 	pool->next_mapping = NULL;
 	pool->mapping_pool =
-		mempool_create_kmalloc_pool(MAPPING_POOL_SIZE, sizeof(struct new_mapping));
+		mempool_create_slab_pool(MAPPING_POOL_SIZE, _new_mapping_cache);
 	if (!pool->mapping_pool) {
 		*error = "Error creating pool's mapping mempool";
 		err_p = ERR_PTR(-ENOMEM);
@@ -1746,7 +1750,7 @@ static struct pool *pool_create(struct m
 	}
 
 	pool->endio_hook_pool =
-		mempool_create_kmalloc_pool(ENDIO_HOOK_POOL_SIZE, sizeof(struct endio_hook));
+		mempool_create_slab_pool(ENDIO_HOOK_POOL_SIZE, _endio_hook_cache);
 	if (!pool->endio_hook_pool) {
 		*error = "Error creating pool's endio_hook mempool";
 		err_p = ERR_PTR(-ENOMEM);
@@ -2748,7 +2752,42 @@ static int __init dm_thin_init(void)
 
 	r = dm_register_target(&pool_target);
 	if (r)
-		dm_unregister_target(&thin_target);
+		goto bad_pool_target;
+
+	_cell_cache = kmem_cache_create("dm_bio_prison_cell",
+					sizeof(struct cell),
+					__alignof__(struct cell), 0, NULL);
+	if (!_cell_cache) {
+		r = -ENOMEM;
+		goto bad_cell_cache;
+	}
+
+	_new_mapping_cache = kmem_cache_create("dm_thin_new_mapping",
+					       sizeof(struct new_mapping),
+					       __alignof__(struct new_mapping), 0, NULL);
+	if (!_new_mapping_cache) {
+		r = -ENOMEM;
+		goto bad_new_mapping_cache;
+	}
+
+	_endio_hook_cache = kmem_cache_create("dm_thin_endio_hook",
+					      sizeof(struct endio_hook),
+					      __alignof__(struct endio_hook), 0, NULL);
+	if (!_endio_hook_cache) {
+		r = -ENOMEM;
+		goto bad_endio_hook_cache;
+	}
+
+	return 0;
+
+bad_endio_hook_cache:
+	kmem_cache_destroy(_new_mapping_cache);
+bad_new_mapping_cache:
+	kmem_cache_destroy(_cell_cache);
+bad_cell_cache:
+	dm_unregister_target(&pool_target);
+bad_pool_target:
+	dm_unregister_target(&thin_target);
 
 	return r;
 }
@@ -2757,6 +2796,9 @@ static void dm_thin_exit(void)
 {
 	dm_unregister_target(&thin_target);
 	dm_unregister_target(&pool_target);
+	kmem_cache_destroy(_cell_cache);
+	kmem_cache_destroy(_new_mapping_cache);
+	kmem_cache_destroy(_endio_hook_cache);
 }
 
 module_init(dm_thin_init);
