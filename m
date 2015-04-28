From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/1] dm: do not allocate any mempools for blk-mq
 request-based DM
Date: Mon, 27 Apr 2015 21:03:04 -0400
Message-ID: <20150428010303.GB31039@redhat.com>
References: <1429957432-20672-1-git-send-email-hch@lst.de>
	<20150428005950.GA31039@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150428005950.GA31039@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@fb.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Do not allocate the io_pool mempool for blk-mq request-based DM
(DM_TYPE_MQ_REQUEST_BASED) in dm_alloc_rq_mempools().

Also refine __bind_mempools() to have more precise awareness of which
mempools each type of DM device uses -- avoids mempool churn when
reloading DM tables (particularly for DM_TYPE_REQUEST_BASED).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |  4 +--
 drivers/md/dm.c       | 69 ++++++++++++++++++++++++++++-----------------------
 2 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3662b2e..2000fea 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -962,8 +962,8 @@ static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *
 		return -EINVAL;
 	}
 
-	if (!t->mempools)
-		return -ENOMEM;
+	if (IS_ERR(t->mempools))
+		return PTR_ERR(t->mempools);
 
 	return 0;
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 77ed371..1c0bc67 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2309,39 +2309,52 @@ static void free_dev(struct mapped_device *md)
 	kfree(md);
 }
 
+static unsigned filter_md_type(unsigned type, struct mapped_device *md)
+{
+	if (type == DM_TYPE_BIO_BASED)
+		return type;
+
+	return !md->use_blk_mq ? DM_TYPE_REQUEST_BASED : DM_TYPE_MQ_REQUEST_BASED;
+}
+
 static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 {
 	struct dm_md_mempools *p = dm_table_get_md_mempools(t);
 
-	if (md->bs) {
-		/* The md already has necessary mempools. */
-		if (dm_table_get_type(t) == DM_TYPE_BIO_BASED) {
+	switch (filter_md_type(dm_table_get_type(t), md)) {
+	case DM_TYPE_BIO_BASED:
+		if (md->bs && md->io_pool) {
 			/*
+			 * This bio-based md already has necessary mempools.
 			 * Reload bioset because front_pad may have changed
 			 * because a different table was loaded.
 			 */
 			bioset_free(md->bs);
 			md->bs = p->bs;
 			p->bs = NULL;
+			goto out;
 		}
-		/*
-		 * There's no need to reload with request-based dm
-		 * because the size of front_pad doesn't change.
-		 * Note for future: If you are to reload bioset,
-		 * prep-ed requests in the queue may refer
-		 * to bio from the old bioset, so you must walk
-		 * through the queue to unprep.
-		 */
-		goto out;
+		break;
+	case DM_TYPE_REQUEST_BASED:
+		if (md->rq_pool && md->io_pool)
+			/*
+			 * This request-based md already has necessary mempools.
+			 */
+			goto out;
+		break;
+	case DM_TYPE_MQ_REQUEST_BASED:
+		BUG_ON(p); /* No mempools needed */
+		return;
 	}
 
+	BUG_ON(!p || md->io_pool || md->rq_pool || md->bs);
+
 	md->io_pool = p->io_pool;
 	p->io_pool = NULL;
 	md->rq_pool = p->rq_pool;
 	p->rq_pool = NULL;
 	md->bs = p->bs;
 	p->bs = NULL;
-
 out:
 	/* mempool bind completed, no longer need any mempools in the table */
 	dm_table_free_md_mempools(t);
@@ -2721,14 +2734,6 @@ out_tag_set:
 	return err;
 }
 
-static unsigned filter_md_type(unsigned type, struct mapped_device *md)
-{
-	if (type == DM_TYPE_BIO_BASED)
-		return type;
-
-	return !md->use_blk_mq ? DM_TYPE_REQUEST_BASED : DM_TYPE_MQ_REQUEST_BASED;
-}
-
 /*
  * Setup the DM device's queue based on md's type
  */
@@ -3450,7 +3455,7 @@ struct dm_md_mempools *dm_alloc_bio_mempools(unsigned integrity,
 
 	pools = kzalloc(sizeof(*pools), GFP_KERNEL);
 	if (!pools)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) +
 		offsetof(struct dm_target_io, clone);
@@ -3469,24 +3474,26 @@ struct dm_md_mempools *dm_alloc_bio_mempools(unsigned integrity,
 	return pools;
 out:
 	dm_free_md_mempools(pools);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 struct dm_md_mempools *dm_alloc_rq_mempools(struct mapped_device *md,
 					    unsigned type)
 {
-	unsigned int pool_size = dm_get_reserved_rq_based_ios();
+	unsigned int pool_size;
 	struct dm_md_mempools *pools;
 
+	if (filter_md_type(type, md) == DM_TYPE_MQ_REQUEST_BASED)
+		return NULL; /* No mempools needed */
+
+	pool_size = dm_get_reserved_rq_based_ios();
 	pools = kzalloc(sizeof(*pools), GFP_KERNEL);
 	if (!pools)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
-	if (filter_md_type(type, md) == DM_TYPE_REQUEST_BASED) {
-		pools->rq_pool = mempool_create_slab_pool(pool_size, _rq_cache);
-		if (!pools->rq_pool)
-			goto out;
-	}
+	pools->rq_pool = mempool_create_slab_pool(pool_size, _rq_cache);
+	if (!pools->rq_pool)
+		goto out;
 
 	pools->io_pool = mempool_create_slab_pool(pool_size, _rq_tio_cache);
 	if (!pools->io_pool)
@@ -3495,7 +3502,7 @@ struct dm_md_mempools *dm_alloc_rq_mempools(struct mapped_device *md,
 	return pools;
 out:
 	dm_free_md_mempools(pools);
-	return NULL;
+	return ERR_PTR(-ENOMEM);
 }
 
 void dm_free_md_mempools(struct dm_md_mempools *pools)
-- 
2.3.2 (Apple Git-55)
