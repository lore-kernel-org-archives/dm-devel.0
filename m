From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-thin: fix use-after-free in
 metadata_pre_commit_callback
Date: Mon, 13 Jan 2020 15:15:25 -0500 (EST)
Message-ID: <alpine.LRH.2.02.2001131515010.15900@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>, Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

dm-thin uses struct pool to hold the state of the pool. There may be
multiple pool_c's pointing to a given pool, each pool_c represents a
loaded target. pool_c's may be created and destroyed arbitrarily and the
pool contains a reference count of pool_c's pointing to it.

A pointer to pool_c is passed to dm_pool_register_pre_commit_callback and
this function stores it in pmd->pre_commit_context. If this pool_c is
freed, but pool is not (because there is another pool_c referencing it),
we end up in a situation where pmd->pre_commit_context structure points to
freed pool_c. It causes a crash in metadata_pre_commit_callback.

This patch fixes the bug by passing pool instead of pool_c to
dm_pool_register_pre_commit_callback.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 694cfe7f31db ("dm thin: Flush data device before committing metadata")

---
 drivers/md/dm-thin.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/md/dm-thin.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin.c	2020-01-13 18:56:55.000000000 +0100
+++ linux-2.6/drivers/md/dm-thin.c	2020-01-13 18:56:55.000000000 +0100
@@ -282,6 +282,8 @@ struct pool {
 	struct dm_bio_prison_cell **cell_sort_array;
 
 	mempool_t mapping_pool;
+
+	struct bio flush_bio;
 };
 
 static void metadata_operation_failed(struct pool *pool, const char *op, int r);
@@ -329,7 +331,6 @@ struct pool_c {
 	dm_block_t low_water_blocks;
 	struct pool_features requested_pf; /* Features requested during table load */
 	struct pool_features adjusted_pf;  /* Features used after adjusting for constituent devices */
-	struct bio flush_bio;
 };
 
 /*
@@ -2925,6 +2926,7 @@ static void __pool_destroy(struct pool *
 	if (pool->next_mapping)
 		mempool_free(pool->next_mapping, &pool->mapping_pool);
 	mempool_exit(&pool->mapping_pool);
+	bio_uninit(&pool->flush_bio);
 	dm_deferred_set_destroy(pool->shared_read_ds);
 	dm_deferred_set_destroy(pool->all_io_ds);
 	kfree(pool);
@@ -3005,6 +3007,7 @@ static struct pool *pool_create(struct m
 	pool->low_water_triggered = false;
 	pool->suspended = true;
 	pool->out_of_data_space = false;
+	bio_init(&pool->flush_bio, NULL, 0);
 
 	pool->shared_read_ds = dm_deferred_set_create();
 	if (!pool->shared_read_ds) {
@@ -3136,7 +3139,6 @@ static void pool_dtr(struct dm_target *t
 	__pool_dec(pt->pool);
 	dm_put_device(ti, pt->metadata_dev);
 	dm_put_device(ti, pt->data_dev);
-	bio_uninit(&pt->flush_bio);
 	kfree(pt);
 
 	mutex_unlock(&dm_thin_pool_table.mutex);
@@ -3215,11 +3217,11 @@ static void metadata_low_callback(void *
  */
 static int metadata_pre_commit_callback(void *context)
 {
-	struct pool_c *pt = context;
-	struct bio *flush_bio = &pt->flush_bio;
+	struct pool *pool = context;
+	struct bio *flush_bio = &pool->flush_bio;
 
 	bio_reset(flush_bio);
-	bio_set_dev(flush_bio, pt->data_dev->bdev);
+	bio_set_dev(flush_bio, pool->data_dev);
 	flush_bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH;
 
 	return submit_bio_wait(flush_bio);
@@ -3393,7 +3395,6 @@ static int pool_ctr(struct dm_target *ti
 	pt->data_dev = data_dev;
 	pt->low_water_blocks = low_water_blocks;
 	pt->adjusted_pf = pt->requested_pf = pf;
-	bio_init(&pt->flush_bio, NULL, 0);
 	ti->num_flush_bios = 1;
 
 	/*
@@ -3422,7 +3423,7 @@ static int pool_ctr(struct dm_target *ti
 
 	dm_pool_register_pre_commit_callback(pt->pool->pmd,
 					     metadata_pre_commit_callback,
-					     pt);
+					     pt->pool);
 
 	pt->callbacks.congested_fn = pool_is_congested;
 	dm_table_add_target_callbacks(ti->table, &pt->callbacks);
