From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Remove _tio_cache
Date: Fri, 12 Oct 2012 14:25:17 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1210121415380.3884@file.rdu.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Remove _tio_cache

Remove _tio_cache and use tio_pool only for request-based devices.

Since we moved dm_target_io to bio front pad, we no longer need _tio_cache.
tio_pool is needed only for request-based devices.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

Index: linux-3.6.1-fast/drivers/md/dm.c
===================================================================
--- linux-3.6.1-fast.orig/drivers/md/dm.c	2012-10-12 19:39:04.000000000 +0200
+++ linux-3.6.1-fast/drivers/md/dm.c	2012-10-12 20:17:23.000000000 +0200
@@ -220,7 +220,6 @@ struct dm_md_mempools {
 #define RESERVED_BIO_BASED_IOS		16
 #define RESERVED_REQUEST_BASED_IOS	256
 static struct kmem_cache *_io_cache;
-static struct kmem_cache *_tio_cache;
 static struct kmem_cache *_rq_tio_cache;
 static struct kmem_cache *_rq_bio_info_cache;
 
@@ -233,14 +232,9 @@ static int __init local_init(void)
 	if (!_io_cache)
 		return r;
 
-	/* allocate a slab for the target ios */
-	_tio_cache = KMEM_CACHE(dm_target_io, 0);
-	if (!_tio_cache)
-		goto out_free_io_cache;
-
 	_rq_tio_cache = KMEM_CACHE(dm_rq_target_io, 0);
 	if (!_rq_tio_cache)
-		goto out_free_tio_cache;
+		goto out_free_io_cache;
 
 	_rq_bio_info_cache = KMEM_CACHE(dm_rq_clone_bio_info, 0);
 	if (!_rq_bio_info_cache)
@@ -266,8 +260,6 @@ out_free_rq_bio_info_cache:
 	kmem_cache_destroy(_rq_bio_info_cache);
 out_free_rq_tio_cache:
 	kmem_cache_destroy(_rq_tio_cache);
-out_free_tio_cache:
-	kmem_cache_destroy(_tio_cache);
 out_free_io_cache:
 	kmem_cache_destroy(_io_cache);
 
@@ -278,7 +270,6 @@ static void local_exit(void)
 {
 	kmem_cache_destroy(_rq_bio_info_cache);
 	kmem_cache_destroy(_rq_tio_cache);
-	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
 	unregister_blkdev(_major, _name);
 	dm_uevent_exit();
@@ -2008,7 +1999,7 @@ static void __bind_mempools(struct mappe
 {
 	struct dm_md_mempools *p;
 
-	if (md->io_pool && md->tio_pool && md->bs)
+	if (md->io_pool && (md->tio_pool || dm_table_get_type(t) == DM_TYPE_BIO_BASED) && md->bs)
 		/* the md already has necessary mempools */
 		goto out;
 
@@ -2777,11 +2768,12 @@ struct dm_md_mempools *dm_alloc_md_mempo
 	if (!pools->io_pool)
 		goto free_pools_and_out;
 
-	pools->tio_pool = (type == DM_TYPE_BIO_BASED) ?
-			  mempool_create_slab_pool(pool_size, _tio_cache) :
-			  mempool_create_slab_pool(pool_size, _rq_tio_cache);
-	if (!pools->tio_pool)
-		goto free_io_pool_and_out;
+	pools->tio_pool = NULL;
+	if (type == DM_TYPE_REQUEST_BASED) {
+		pools->tio_pool = mempool_create_slab_pool(pool_size, _rq_tio_cache);
+		if (!pools->tio_pool)
+			goto free_io_pool_and_out;
+	}
 
 	pools->bs = bioset_create(pool_size, (type == DM_TYPE_BIO_BASED) ?
 		offsetof(struct dm_target_io, clone) : 0);
@@ -2797,7 +2789,8 @@ free_bioset_and_out:
 	bioset_free(pools->bs);
 
 free_tio_pool_and_out:
-	mempool_destroy(pools->tio_pool);
+	if (pools->tio_pool)
+		mempool_destroy(pools->tio_pool);
 
 free_io_pool_and_out:
 	mempool_destroy(pools->io_pool);
