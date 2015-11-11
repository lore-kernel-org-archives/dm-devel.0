From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 1/2] block: Introduce BIO_ENDIO_FREE for bio flags
Date: Wed, 11 Nov 2015 17:31:44 +0800
Message-ID: <2bd3cc769530061501af545c7949dcc832263930.1447233227.git.baolin.wang@linaro.org>
References: <cover.1447233227.git.baolin.wang@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1447233227.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1447233227.git.baolin.wang@linaro.org>
References: <cover.1447233227.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.com
Cc: jack@suse.cz, tj@kernel.org, jmoyer@redhat.com, keith.busch@intel.com, bart.vanassche@sandisk.com, linux-raid@vger.kernel.org, broonie@kernel.org, arnd@arndb.de, dineshg@quicinc.com, linux-kernel@vger.kernel.org, baolin.wang@linaro.org
List-Id: dm-devel.ids

When we use dm-crypt to decrypt block data, it will decrypt the block data
in endio() when one IO is completed. In this situation we don't want the
cloned bios is freed before calling the endio().

Thus introduce 'BIO_ENDIO_FREE' flag to support the request handling for dm-crypt,
this flag will ensure that blk layer does not complete the cloned bios before
completing the request. When the crypt endio is called, post-processsing is
done and then the dm layer will complete the bios (clones) and free them.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 block/blk-core.c              |    6 +++++-
 drivers/md/dm.c               |   13 ++++++++++---
 include/linux/blk_types.h     |    6 ++++++
 include/linux/device-mapper.h |    5 +++++
 4 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 60912e9..6838936 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1411,7 +1411,7 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	elv_completed_request(q, req);
 
 	/* this is a bio leak */
-	WARN_ON(req->bio != NULL);
+	WARN_ON(req->bio != NULL && !bio_flagged(req->bio, BIO_ENDIO_FREE));
 
 	/*
 	 * Request may not have originated from ll_rw_blk. if not,
@@ -2521,6 +2521,10 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	blk_account_io_completion(req, nr_bytes);
 
 	total_bytes = 0;
+
+	if (bio_flagged(req->bio, BIO_ENDIO_FREE))
+		return false;
+
 	while (req->bio) {
 		struct bio *bio = req->bio;
 		unsigned bio_bytes = min(bio->bi_iter.bi_size, nr_bytes);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6264781..2c18a34 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1047,6 +1047,13 @@ static struct dm_rq_target_io *tio_from_request(struct request *rq)
 	return (rq->q->mq_ops ? blk_mq_rq_to_pdu(rq) : rq->special);
 }
 
+struct request *dm_get_orig_rq(struct request *clone)
+{
+	struct dm_rq_target_io *tio = clone->end_io_data;
+
+	return tio->orig;
+}
+
 static void rq_end_stats(struct mapped_device *md, struct request *orig)
 {
 	if (unlikely(dm_stats_used(&md->stats))) {
@@ -1118,7 +1125,7 @@ static void free_rq_clone(struct request *clone)
  * Must be called without clone's queue lock held,
  * see end_clone_request() for more details.
  */
-static void dm_end_request(struct request *clone, int error)
+void dm_end_request(struct request *clone, int error)
 {
 	int rw = rq_data_dir(clone);
 	struct dm_rq_target_io *tio = clone->end_io_data;
@@ -1311,7 +1318,7 @@ static void dm_complete_request(struct request *rq, int error)
  * Target's rq_end_io() function isn't called.
  * This may be used when the target's map_rq() or clone_and_map_rq() functions fail.
  */
-static void dm_kill_unmapped_request(struct request *rq, int error)
+void dm_kill_unmapped_request(struct request *rq, int error)
 {
 	rq->cmd_flags |= REQ_FAILED;
 	dm_complete_request(rq, error);
@@ -1758,7 +1765,7 @@ int dm_request_based(struct mapped_device *md)
 	return blk_queue_stackable(md->queue);
 }
 
-static void dm_dispatch_clone_request(struct request *clone, struct request *rq)
+void dm_dispatch_clone_request(struct request *clone, struct request *rq)
 {
 	int r;
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index e813013..30aee54 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -122,6 +122,12 @@ struct bio {
 #define BIO_REFFED	8	/* bio has elevated ->bi_cnt */
 
 /*
+ * Added for Req based dm which need to perform post processing. This flag
+ * ensures blk_update_request does not free the bios or request, this is done
+ * at the dm level.
+ */
+#define BIO_ENDIO_FREE 12
+/*
  * Flags starting here get preserved by bio_reset() - this includes
  * BIO_POOL_IDX()
  */
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 76d23fa..f636c50 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -407,6 +407,11 @@ union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
 
+void dm_end_request(struct request *clone, int error);
+void dm_kill_unmapped_request(struct request *rq, int error);
+void dm_dispatch_clone_request(struct request *clone, struct request *rq);
+struct request *dm_get_orig_rq(struct request *clone);
+
 /*
  * Geometry functions.
  */
-- 
1.7.9.5
