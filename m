From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 6/8] dm: split request structure out from
	dm_rq_target_io structure
Date: Tue, 16 Dec 2014 23:00:02 -0500
Message-ID: <1418788804-1982-7-git-send-email-snitzer@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Keith Busch <keith.busch@intel.com>
Cc: axboe@kernel.dk, hch@infradead.org, j-nomura@ce.jp.nec.com, bvanassche@acm.org
List-Id: dm-devel.ids

Request-based DM support for blk-mq devices requires that
dm_rq_target_io structures not be allocated with an embedded request
structure.  The request-based DM target (e.g. dm-multipath) must
allocate the request from the blk-mq devices' request_queue using
blk_get_request().

The unfortunate side-effect of this change is old-style request-based DM
support will no longer use contiguous memory for the dm_rq_target_io and
request structures for each clone.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 61 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1c69fcb..ca5eed2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -78,7 +78,7 @@ struct dm_io {
 struct dm_rq_target_io {
 	struct mapped_device *md;
 	struct dm_target *ti;
-	struct request *orig, clone;
+	struct request *orig, *clone;
 	int error;
 	union map_info info;
 };
@@ -179,6 +179,7 @@ struct mapped_device {
 	 * io objects are allocated from here.
 	 */
 	mempool_t *io_pool;
+	mempool_t *rq_pool;
 
 	struct bio_set *bs;
 
@@ -214,6 +215,7 @@ struct mapped_device {
  */
 struct dm_md_mempools {
 	mempool_t *io_pool;
+	mempool_t *rq_pool;
 	struct bio_set *bs;
 };
 
@@ -228,6 +230,7 @@ struct table_device {
 #define RESERVED_MAX_IOS		1024
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_rq_tio_cache;
+static struct kmem_cache *_rq_cache;
 
 /*
  * Bio-based DM's mempools' reserved IOs set by the user.
@@ -285,9 +288,14 @@ static int __init local_init(void)
 	if (!_rq_tio_cache)
 		goto out_free_io_cache;
 
+	_rq_cache = kmem_cache_create("dm_clone_request", sizeof(struct request),
+				      __alignof__(struct request), 0, NULL);
+	if (!_rq_cache)
+		goto out_free_rq_tio_cache;
+
 	r = dm_uevent_init();
 	if (r)
-		goto out_free_rq_tio_cache;
+		goto out_free_rq_cache;
 
 	deferred_remove_workqueue = alloc_workqueue("kdmremove", WQ_UNBOUND, 1);
 	if (!deferred_remove_workqueue) {
@@ -309,6 +317,8 @@ out_free_workqueue:
 	destroy_workqueue(deferred_remove_workqueue);
 out_uevent_exit:
 	dm_uevent_exit();
+out_free_rq_cache:
+	kmem_cache_destroy(_rq_cache);
 out_free_rq_tio_cache:
 	kmem_cache_destroy(_rq_tio_cache);
 out_free_io_cache:
@@ -322,6 +332,7 @@ static void local_exit(void)
 	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
+	kmem_cache_destroy(_rq_cache);
 	kmem_cache_destroy(_rq_tio_cache);
 	kmem_cache_destroy(_io_cache);
 	unregister_blkdev(_major, _name);
@@ -574,6 +585,17 @@ static void free_rq_tio(struct dm_rq_target_io *tio)
 	mempool_free(tio, tio->md->io_pool);
 }
 
+static struct request *alloc_clone_request(struct mapped_device *md,
+					   gfp_t gfp_mask)
+{
+	return mempool_alloc(md->rq_pool, gfp_mask);
+}
+
+static void free_clone_request(struct mapped_device *md, struct request *rq)
+{
+	mempool_free(rq, md->rq_pool);
+}
+
 static int md_in_flight(struct mapped_device *md)
 {
 	return atomic_read(&md->pending[READ]) +
@@ -1017,6 +1039,7 @@ static void free_rq_clone(struct request *clone)
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
 	blk_rq_unprep_clone(clone);
+	free_clone_request(tio->md, clone);
 	free_rq_tio(tio);
 }
 
@@ -1712,12 +1735,11 @@ static int dm_rq_bio_constructor(struct bio *bio, struct bio *bio_orig,
 }
 
 static int setup_clone(struct request *clone, struct request *rq,
-		       struct dm_rq_target_io *tio)
+		       struct dm_rq_target_io *tio, gfp_t gfp_mask)
 {
 	int r;
 
-	blk_rq_init(NULL, rq);
-	r = blk_rq_prep_clone(clone, rq, tio->md->bs, GFP_ATOMIC,
+	r = blk_rq_prep_clone(clone, rq, tio->md->bs, gfp_mask,
 			      dm_rq_bio_constructor, tio);
 	if (r)
 		return r;
@@ -1728,9 +1750,29 @@ static int setup_clone(struct request *clone, struct request *rq,
 	clone->end_io = end_clone_request;
 	clone->end_io_data = tio;
 
+	tio->clone = clone;
+
 	return 0;
 }
 
+static struct request *__clone_rq(struct request *rq, struct mapped_device *md,
+				  struct dm_rq_target_io *tio, gfp_t gfp_mask)
+{
+	struct request *clone = alloc_clone_request(md, gfp_mask);
+
+	if (!clone)
+		return NULL;
+
+	blk_rq_init(NULL, clone);
+	if (setup_clone(clone, rq, tio, gfp_mask)) {
+		/* -ENOMEM */
+		free_clone_request(md, clone);
+		return NULL;
+	}
+
+	return clone;
+}
+
 static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 				gfp_t gfp_mask)
 {
@@ -1743,13 +1785,13 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 
 	tio->md = md;
 	tio->ti = NULL;
+	tio->clone = NULL;
 	tio->orig = rq;
 	tio->error = 0;
 	memset(&tio->info, 0, sizeof(tio->info));
 
-	clone = &tio->clone;
-	if (setup_clone(clone, rq, tio)) {
-		/* -ENOMEM */
+	clone = __clone_rq(rq, md, tio, GFP_ATOMIC);
+	if (!clone) {
 		free_rq_tio(tio);
 		return NULL;
 	}
@@ -2149,6 +2191,8 @@ static void free_dev(struct mapped_device *md)
 	destroy_workqueue(md->wq);
 	if (md->io_pool)
 		mempool_destroy(md->io_pool);
+	if (md->rq_pool)
+		mempool_destroy(md->rq_pool);
 	if (md->bs)
 		bioset_free(md->bs);
 	blk_integrity_unregister(md->disk);
@@ -2195,10 +2239,12 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 		goto out;
 	}
 
-	BUG_ON(!p || md->io_pool || md->bs);
+	BUG_ON(!p || md->io_pool || md->rq_pool || md->bs);
 
 	md->io_pool = p->io_pool;
 	p->io_pool = NULL;
+	md->rq_pool = p->rq_pool;
+	p->rq_pool = NULL;
 	md->bs = p->bs;
 	p->bs = NULL;
 
@@ -3129,6 +3175,9 @@ struct dm_md_mempools *dm_alloc_md_mempools(unsigned type, unsigned integrity, u
 	} else if (type == DM_TYPE_REQUEST_BASED) {
 		cachep = _rq_tio_cache;
 		pool_size = dm_get_reserved_rq_based_ios();
+		pools->rq_pool = mempool_create_slab_pool(pool_size, _rq_cache);
+		if (!pools->rq_pool)
+			goto out;
 		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
 		/* per_bio_data_size is not used. See __bind_mempools(). */
 		WARN_ON(per_bio_data_size != 0);
@@ -3162,6 +3211,9 @@ void dm_free_md_mempools(struct dm_md_mempools *pools)
 	if (pools->io_pool)
 		mempool_destroy(pools->io_pool);
 
+	if (pools->rq_pool)
+		mempool_destroy(pools->rq_pool);
+
 	if (pools->bs)
 		bioset_free(pools->bs);
 
-- 
1.9.3
