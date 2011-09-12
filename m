From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-thin: Fix multiple bugs with reference
	management
Date: Mon, 12 Sep 2011 12:03:31 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1109121125480.10597@hs20-bc2-1.build.redhat.com>
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
To: Edward Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is a major cleanup+bugfix of reference count management. Test it with 
your testsuite.

Mikulas

---

dm-thin: Fix multiple bugs with reference management

This patch changes reference management:
- all constructors and destructors are protected by a global mutex (thus,
  there can be only one executing)
- the list of all active pool structures is maintained
- each pool structure has a reference count.
- the list and reference count do not have to be protected with
  spinlocks, because they are protected with the global mutex

The previous implementation had a coule of bugs:
- There was a race between "pool_table_lookup" and "pool_inc" - if the
  pool is destroyed between these two calls, we are working with already
  released structure.
- a bug in "pool_ctr": "pool = pool_find...; if (!pt) {
  pool_destroy(pool); }" - calling pool_destroy directly without
  checking the reference count.
- pools were previously added to a list in preresume and removed in
  postsuspend - this would allow to create multiple pools for the same
  device - for example suspend (which removes the pool from the list)
  and then call a constructor (which doesn't notice that a device
  already exists).
- if we created two targets for the same "md" device, they would refer
  to the same underlying "pool" and call resume on both, the same
  structure would be added twice to the list.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-thin.c |   92 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 56 insertions(+), 36 deletions(-)

Index: linux-3.1-rc3-fast/drivers/md/dm-thin.c
===================================================================
--- linux-3.1-rc3-fast.orig/drivers/md/dm-thin.c	2011-09-12 16:49:31.000000000 +0200
+++ linux-3.1-rc3-fast/drivers/md/dm-thin.c	2011-09-12 17:24:39.000000000 +0200
@@ -495,7 +495,7 @@ struct pool {
 	mempool_t *mapping_pool;
 	mempool_t *endio_hook_pool;
 
-	atomic_t ref_count;
+	unsigned ref_count;
 };
 
 /*
@@ -567,42 +567,40 @@ static void save_and_set_endio(struct bi
  * A global list that uses a struct mapped_device as a key.
  */
 static struct dm_thin_pool_table {
-	spinlock_t lock;
+	struct mutex mutex;
 	struct list_head pools;
 } dm_thin_pool_table;
 
 static void pool_table_init(void)
 {
-	spin_lock_init(&dm_thin_pool_table.lock);
+	mutex_init(&dm_thin_pool_table.mutex);
 
 	INIT_LIST_HEAD(&dm_thin_pool_table.pools);
 }
 
 static void pool_table_insert(struct pool *pool)
 {
-	spin_lock(&dm_thin_pool_table.lock);
+	BUG_ON(!mutex_is_locked(&dm_thin_pool_table.mutex));
 	list_add(&pool->list, &dm_thin_pool_table.pools);
-	spin_unlock(&dm_thin_pool_table.lock);
 }
 
 static void pool_table_remove(struct pool *pool)
 {
-	spin_lock(&dm_thin_pool_table.lock);
+	BUG_ON(!mutex_is_locked(&dm_thin_pool_table.mutex));
 	list_del(&pool->list);
-	spin_unlock(&dm_thin_pool_table.lock);
 }
 
 static struct pool *pool_table_lookup(struct mapped_device *md)
 {
 	struct pool *pool = NULL, *tmp;
 
-	spin_lock(&dm_thin_pool_table.lock);
+	BUG_ON(!mutex_is_locked(&dm_thin_pool_table.mutex));
+
 	list_for_each_entry(tmp, &dm_thin_pool_table.pools, list)
 		if (tmp->pool_md == md) {
 			pool = tmp;
 			break;
 		}
-	spin_unlock(&dm_thin_pool_table.lock);
 
 	return pool;
 }
@@ -1331,6 +1329,8 @@ static void unbind_control_target(struct
  *--------------------------------------------------------------*/
 static void pool_destroy(struct pool *pool)
 {
+	pool_table_remove(pool);
+
 	if (dm_pool_metadata_close(pool->pmd) < 0)
 		DMWARN("%s: dm_pool_metadata_close() failed.", __func__);
 
@@ -1347,7 +1347,8 @@ static void pool_destroy(struct pool *po
 	kfree(pool);
 }
 
-static struct pool *pool_create(struct block_device *metadata_dev,
+static struct pool *pool_create(struct mapped_device *pool_md,
+				struct block_device *metadata_dev,
 				unsigned long block_size, char **error)
 {
 	int r;
@@ -1426,7 +1427,9 @@ static struct pool *pool_create(struct b
 		err_p = ERR_PTR(-ENOMEM);
 		goto bad_endio_hook_pool;
 	}
-	atomic_set(&pool->ref_count, 1);
+	pool->ref_count = 1;
+	pool->pool_md = pool_md;
+	pool_table_insert(pool);
 
 	return pool;
 
@@ -1449,12 +1452,15 @@ bad_pool:
 
 static void pool_inc(struct pool *pool)
 {
-	atomic_inc(&pool->ref_count);
+	BUG_ON(!mutex_is_locked(&dm_thin_pool_table.mutex));
+	pool->ref_count++;
 }
 
 static void pool_dec(struct pool *pool)
 {
-	if (atomic_dec_and_test(&pool->ref_count))
+	BUG_ON(!mutex_is_locked(&dm_thin_pool_table.mutex));
+	BUG_ON(!pool->ref_count);
+	if (!--pool->ref_count)
 		pool_destroy(pool);
 }
 
@@ -1469,7 +1475,7 @@ static struct pool *pool_find(struct map
 	if (pool)
 		pool_inc(pool);
 	else
-		pool = pool_create(metadata_dev, block_size, error);
+		pool = pool_create(pool_md, metadata_dev, block_size, error);
 
 	return pool;
 }
@@ -1481,13 +1487,15 @@ static void pool_dtr(struct dm_target *t
 {
 	struct pool_c *pt = ti->private;
 
+	mutex_lock(&dm_thin_pool_table.mutex);
+
 	unbind_control_target(pt->pool, ti);
 	pool_dec(pt->pool);
-
 	dm_put_device(ti, pt->metadata_dev);
 	dm_put_device(ti, pt->data_dev);
-
 	kfree(pt);
+
+	mutex_unlock(&dm_thin_pool_table.mutex);
 }
 
 struct pool_features {
@@ -1551,9 +1559,12 @@ static int pool_ctr(struct dm_target *ti
 	struct dm_dev *metadata_dev;
 	sector_t metadata_dev_size;
 
+	mutex_lock(&dm_thin_pool_table.mutex);
+
 	if (argc < 4) {
 		ti->error = "Invalid argument count";
-		return -EINVAL;
+		r = -EINVAL;
+		goto out_unlock;
 	}
 	as.argc = argc;
 	as.argv = argv;
@@ -1561,7 +1572,7 @@ static int pool_ctr(struct dm_target *ti
 	r = dm_get_device(ti, argv[0], FMODE_READ | FMODE_WRITE, &metadata_dev);
 	if (r) {
 		ti->error = "Error opening metadata block device";
-		return r;
+		goto out_unlock;
 	}
 
 	metadata_dev_size = i_size_read(metadata_dev->bdev->bd_inode) >> SECTOR_SHIFT;
@@ -1604,19 +1615,19 @@ static int pool_ctr(struct dm_target *ti
 	if (r)
 		goto out;
 
+	pt = kzalloc(sizeof(*pt), GFP_KERNEL);
+	if (!pt) {
+		r = -ENOMEM;
+		goto out;
+	}
+
 	pool = pool_find(dm_table_get_md(ti->table), metadata_dev->bdev,
 			 block_size, &ti->error);
 	if (IS_ERR(pool)) {
 		r = PTR_ERR(pool);
-		goto out;
+		goto out_free_pt;
 	}
 
-	pt = kzalloc(sizeof(*pt), GFP_KERNEL);
-	if (!pt) {
-		pool_destroy(pool);
-		r = -ENOMEM;
-		goto out;
-	}
 	pt->pool = pool;
 	pt->ti = ti;
 	pt->metadata_dev = metadata_dev;
@@ -1630,12 +1641,18 @@ static int pool_ctr(struct dm_target *ti
 	pt->callbacks.congested_fn = pool_is_congested;
 	dm_table_add_target_callbacks(ti->table, &pt->callbacks);
 
+	mutex_unlock(&dm_thin_pool_table.mutex);
+
 	return 0;
 
+out_free_pt:
+	kfree(pt);
 out:
 	dm_put_device(ti, data_dev);
 out_metadata:
 	dm_put_device(ti, metadata_dev);
+out_unlock:
+	mutex_unlock(&dm_thin_pool_table.mutex);
 
 	return r;
 }
@@ -1716,12 +1733,6 @@ static int pool_preresume(struct dm_targ
 
 	wake_worker(pool);
 
-	/*
-	 * The pool object is only present if the pool is active.
-	 */
-	pool->pool_md = dm_table_get_md(ti->table);
-	pool_table_insert(pool);
-
 	return 0;
 }
 
@@ -1739,9 +1750,6 @@ static void pool_postsuspend(struct dm_t
 		      __func__, r);
 		/* FIXME: invalidate device? error the next FUA or FLUSH bio ?*/
 	}
-
-	pool_table_remove(pool);
-	pool->pool_md = NULL;
 }
 
 static int check_arg_count(unsigned argc, unsigned args_required)
@@ -2059,10 +2067,14 @@ static void thin_dtr(struct dm_target *t
 {
 	struct thin_c *tc = ti->private;
 
+	mutex_lock(&dm_thin_pool_table.mutex);
+
 	pool_dec(tc->pool);
 	dm_pool_close_thin_device(tc->td);
 	dm_put_device(ti, tc->pool_dev);
 	kfree(tc);
+
+	mutex_unlock(&dm_thin_pool_table.mutex);
 }
 
 /*
@@ -2080,15 +2092,19 @@ static int thin_ctr(struct dm_target *ti
 	struct dm_dev *pool_dev;
 	struct mapped_device *pool_md;
 
+	mutex_lock(&dm_thin_pool_table.mutex);
+
 	if (argc != 2) {
 		ti->error = "Invalid argument count";
-		return -EINVAL;
+		r = -EINVAL;
+		goto out_unlock;
 	}
 
 	tc = ti->private = kzalloc(sizeof(*tc), GFP_KERNEL);
 	if (!tc) {
 		ti->error = "Out of memory";
-		return -ENOMEM;
+		r = -ENOMEM;
+		goto out_unlock;
 	}
 
 	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &pool_dev);
@@ -2132,6 +2148,8 @@ static int thin_ctr(struct dm_target *ti
 
 	dm_put(pool_md);
 
+	mutex_unlock(&dm_thin_pool_table.mutex);
+
 	return 0;
 
 bad_thin_open:
@@ -2142,6 +2160,8 @@ bad_common:
 	dm_put_device(ti, tc->pool_dev);
 bad_pool_dev:
 	kfree(tc);
+out_unlock:
+	mutex_unlock(&dm_thin_pool_table.mutex);
 
 	return r;
 }
