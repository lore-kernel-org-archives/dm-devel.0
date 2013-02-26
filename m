From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 1/2] dm: remove _rq_bio_info_cache
Date: Tue, 26 Feb 2013 17:00:34 +0900
Message-ID: <512C6BA2.2030305@ce.jp.nec.com>
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

Remove _rq_bio_info_cache, which is no longer used.
No functional changes.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

This patch is applicable over v3.8 and the following patch:
  [PATCH] dm: do not replace bioset for request-based dm
  https://www.redhat.com/archives/dm-devel/2013-February/msg00105.html

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 51fefb5..a1bdeea 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -205,12 +205,6 @@ struct dm_md_mempools {
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_rq_tio_cache;
 
-/*
- * Unused now, and needs to be deleted. But since io_pool is overloaded and it's
- * still used for _io_cache, I'm leaving this for a later cleanup
- */
-static struct kmem_cache *_rq_bio_info_cache;
-
 static int __init local_init(void)
 {
 	int r = -ENOMEM;
@@ -224,13 +218,9 @@ static int __init local_init(void)
 	if (!_rq_tio_cache)
 		goto out_free_io_cache;
 
-	_rq_bio_info_cache = KMEM_CACHE(dm_rq_clone_bio_info, 0);
-	if (!_rq_bio_info_cache)
-		goto out_free_rq_tio_cache;
-
 	r = dm_uevent_init();
 	if (r)
-		goto out_free_rq_bio_info_cache;
+		goto out_free_rq_tio_cache;
 
 	_major = major;
 	r = register_blkdev(_major, _name);
@@ -244,8 +234,6 @@ static int __init local_init(void)
 
 out_uevent_exit:
 	dm_uevent_exit();
-out_free_rq_bio_info_cache:
-	kmem_cache_destroy(_rq_bio_info_cache);
 out_free_rq_tio_cache:
 	kmem_cache_destroy(_rq_tio_cache);
 out_free_io_cache:
@@ -256,7 +244,6 @@ out_free_io_cache:
 
 static void local_exit(void)
 {
-	kmem_cache_destroy(_rq_bio_info_cache);
 	kmem_cache_destroy(_rq_tio_cache);
 	kmem_cache_destroy(_io_cache);
 	unregister_blkdev(_major, _name);
@@ -1973,7 +1960,7 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 {
 	struct dm_md_mempools *p = dm_table_get_md_mempools(t);
 
-	if (md->io_pool && md->bs) {
+	if (md->bs) {
 		/* The md already has necessary mempools. */
 		if (dm_table_get_type(t) == DM_TYPE_BIO_BASED) {
 			/*
@@ -2765,11 +2752,12 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 
 	per_bio_data_size = roundup(per_bio_data_size, __alignof__(struct dm_target_io));
 
-	pools->io_pool = (type == DM_TYPE_BIO_BASED) ?
-			 mempool_create_slab_pool(MIN_IOS, _io_cache) :
-			 mempool_create_slab_pool(MIN_IOS, _rq_bio_info_cache);
-	if (!pools->io_pool)
-		goto free_pools_and_out;
+	pools->io_pool = NULL;
+	if (type == DM_TYPE_BIO_BASED) {
+		pools->io_pool = mempool_create_slab_pool(MIN_IOS, _io_cache);
+		if (!pools->io_pool)
+			goto free_pools_and_out;
+	}
 
 	pools->tio_pool = NULL;
 	if (type == DM_TYPE_REQUEST_BASED) {
@@ -2799,7 +2787,8 @@ free_tio_pool_and_out:
 		mempool_destroy(pools->tio_pool);
 
 free_io_pool_and_out:
-	mempool_destroy(pools->io_pool);
+	if (pools->io_pool)
+		mempool_destroy(pools->io_pool);
 
 free_pools_and_out:
 	kfree(pools);
