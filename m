From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 2/2] dm: merge io_pool and tio_pool
Date: Tue, 26 Feb 2013 17:00:41 +0900
Message-ID: <512C6BA9.2020606@ce.jp.nec.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Though old device-mapper had 2 pools of objects for each dm device,
use of bioset frontbad for per-bio data has shrinked the number of pools
to 1 for both bio-based and request-based device types.
(See c0820cf5 "dm: introduce per_bio_data" and
 94818742 "dm: Use bioset's front_pad for dm_rq_clone_bio_info")

So dm no longer has to maintain 2 different pointers.

This patch merges io_pool and tio_pool into io_pool
and cleans up related functions.

No functional changes.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |   76 +++++++++++++++++++-------------------------------------
 1 file changed, 27 insertions(+), 49 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a1bdeea..5aba374 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -163,7 +163,6 @@ struct mapped_device {
 	 * io objects are allocated from here.
 	 */
 	mempool_t *io_pool;
-	mempool_t *tio_pool;
 
 	struct bio_set *bs;
 
@@ -197,7 +196,6 @@ struct mapped_device {
  */
 struct dm_md_mempools {
 	mempool_t *io_pool;
-	mempool_t *tio_pool;
 	struct bio_set *bs;
 };
 
@@ -436,12 +434,12 @@ static void free_tio(struct mapped_device *md, struct dm_target_io *tio)
 static struct dm_rq_target_io *alloc_rq_tio(struct mapped_device *md,
 					    gfp_t gfp_mask)
 {
-	return mempool_alloc(md->tio_pool, gfp_mask);
+	return mempool_alloc(md->io_pool, gfp_mask);
 }
 
 static void free_rq_tio(struct dm_rq_target_io *tio)
 {
-	mempool_free(tio, tio->md->tio_pool);
+	mempool_free(tio, tio->md->io_pool);
 }
 
 static int md_in_flight(struct mapped_device *md)
@@ -1936,8 +1934,6 @@ static void free_dev(struct mapped_device *md)
 	unlock_fs(md);
 	bdput(md->bdev);
 	destroy_workqueue(md->wq);
-	if (md->tio_pool)
-		mempool_destroy(md->tio_pool);
 	if (md->io_pool)
 		mempool_destroy(md->io_pool);
 	if (md->bs)
@@ -1960,7 +1956,7 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 {
 	struct dm_md_mempools *p = dm_table_get_md_mempools(t);
 
-	if (md->bs) {
+	if (md->io_pool && md->bs) {
 		/* The md already has necessary mempools. */
 		if (dm_table_get_type(t) == DM_TYPE_BIO_BASED) {
 			/*
@@ -1971,7 +1967,6 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 			md->bs = p->bs;
 			p->bs = NULL;
 		} else if (dm_table_get_type(t) == DM_TYPE_REQUEST_BASED) {
-			BUG_ON(!md->tio_pool);
 			/*
 			 * No need to reload in case of request-based dm
 			 * because of fixed size front_pad.
@@ -1984,12 +1979,10 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 		goto out;
 	}
 
-	BUG_ON(!p || md->io_pool || md->tio_pool || md->bs);
+	BUG_ON(!p || md->io_pool || md->bs);
 
 	md->io_pool = p->io_pool;
 	p->io_pool = NULL;
-	md->tio_pool = p->tio_pool;
-	p->tio_pool = NULL;
 	md->bs = p->bs;
 	p->bs = NULL;
 
@@ -2744,54 +2737,42 @@ EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
 struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, unsigned per_bio_data_size)
 {
-	struct dm_md_mempools *pools = kmalloc(sizeof(*pools), GFP_KERNEL);
-	unsigned int pool_size = (type == DM_TYPE_BIO_BASED) ? 16 : MIN_IOS;
+	struct dm_md_mempools *pools = kzalloc(sizeof(*pools), GFP_KERNEL);
+	struct kmem_cache *cachep;
+	unsigned int pool_size;
+	unsigned int front_pad;
 
 	if (!pools)
 		return NULL;
 
-	per_bio_data_size = roundup(per_bio_data_size, __alignof__(struct dm_target_io));
-
-	pools->io_pool = NULL;
 	if (type == DM_TYPE_BIO_BASED) {
-		pools->io_pool = mempool_create_slab_pool(MIN_IOS, _io_cache);
-		if (!pools->io_pool)
-			goto free_pools_and_out;
-	}
+		cachep = _io_cache;
+		pool_size = 16;
+		front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
+	} else if (type == DM_TYPE_REQUEST_BASED) {
+		cachep = _rq_tio_cache;
+		pool_size = MIN_IOS;
+		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
+		/* per_bio_data_size is not used. See __bind_mempools(). */
+		WARN_ON(per_bio_data_size != 0);
+	} else
+		goto out;
 
-	pools->tio_pool = NULL;
-	if (type == DM_TYPE_REQUEST_BASED) {
-		pools->tio_pool = mempool_create_slab_pool(MIN_IOS, _rq_tio_cache);
-		if (!pools->tio_pool)
-			goto free_io_pool_and_out;
-	}
+	pools->io_pool = mempool_create_slab_pool(MIN_IOS, cachep);
+	if (!pools->io_pool)
+		goto out;
 
-	pools->bs = (type == DM_TYPE_BIO_BASED) ?
-		bioset_create(pool_size,
-			      per_bio_data_size + offsetof(struct dm_target_io, clone)) :
-		bioset_create(pool_size,
-			      offsetof(struct dm_rq_clone_bio_info, clone));
+	pools->bs = bioset_create(pool_size, front_pad);
 	if (!pools->bs)
-		goto free_tio_pool_and_out;
+		goto out;
 
 	if (integrity && bioset_integrity_create(pools->bs, pool_size))
-		goto free_bioset_and_out;
+		goto out;
 
 	return pools;
 
-free_bioset_and_out:
-	bioset_free(pools->bs);
-
-free_tio_pool_and_out:
-	if (pools->tio_pool)
-		mempool_destroy(pools->tio_pool);
-
-free_io_pool_and_out:
-	if (pools->io_pool)
-		mempool_destroy(pools->io_pool);
-
-free_pools_and_out:
-	kfree(pools);
+out:
+	dm_free_md_mempools(pools);
 
 	return NULL;
 }
@@ -2804,9 +2785,6 @@ void dm_free_md_mempools(struct dm_md_mempools *pools)
 	if (pools->io_pool)
 		mempool_destroy(pools->io_pool);
 
-	if (pools->tio_pool)
-		mempool_destroy(pools->tio_pool);
-
 	if (pools->bs)
 		bioset_free(pools->bs);
 
