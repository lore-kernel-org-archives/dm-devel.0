From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 10/15] dm: allow immutable
	request-based targets to use blk-mq pdu
Date: Sun,  7 Feb 2016 10:53:32 -0500
Message-ID: <1454860417-3203-11-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

This will allow DM multipath to use a portion of the blk-mq pdu space
for target data (e.g. struct dm_mpath_io).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-ioctl.c |  2 +-
 drivers/md/dm.c       | 45 +++++++++++++++++++++++++++++++++++++--------
 drivers/md/dm.h       |  2 +-
 3 files changed, 39 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 4763c4a..2adf81d 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1304,7 +1304,7 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		dm_set_md_type(md, dm_table_get_type(t));
 
 		/* setup md->queue to reflect md's type (may block) */
-		r = dm_setup_md_queue(md);
+		r = dm_setup_md_queue(md, t);
 		if (r) {
 			DMWARN("unable to set up device queue for new table.");
 			goto err_unlock_md_type;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8bc798c..6b7e80e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -225,6 +225,7 @@ struct mapped_device {
 	/* for blk-mq request-based DM support */
 	struct blk_mq_tag_set *tag_set;
 	bool use_blk_mq;
+	bool init_tio_pdu;
 };
 
 #ifdef CONFIG_DM_MQ_DEFAULT
@@ -243,6 +244,7 @@ bool dm_use_blk_mq(struct mapped_device *md)
 {
 	return md->use_blk_mq;
 }
+EXPORT_SYMBOL_GPL(dm_use_blk_mq);
 
 /*
  * For mempools pre-allocation at the table loading time.
@@ -1850,6 +1852,8 @@ static struct request *clone_rq(struct request *rq, struct mapped_device *md,
 				struct dm_rq_target_io *tio, gfp_t gfp_mask)
 {
 	/*
+	 * Create clone for use with .request_fn request_queue
+	 *
 	 * Do not allocate a clone if tio->clone was already set
 	 * (see: dm_mq_queue_rq).
 	 */
@@ -1884,7 +1888,13 @@ static void init_tio(struct dm_rq_target_io *tio, struct request *rq,
 	tio->clone = NULL;
 	tio->orig = rq;
 	tio->error = 0;
-	memset(&tio->info, 0, sizeof(tio->info));
+	/*
+	 * Avoid initializing info for blk-mq; it passes
+	 * target-specific data through info.ptr
+	 * (see: dm_mq_init_request)
+	 */
+	if (md->init_tio_pdu)
+		memset(&tio->info, 0, sizeof(tio->info));
 	if (md->kworker_task)
 		init_kthread_work(&tio->work, map_tio_request);
 }
@@ -2303,6 +2313,7 @@ static struct mapped_device *alloc_dev(int minor)
 		goto bad_io_barrier;
 
 	md->use_blk_mq = use_blk_mq;
+	md->init_tio_pdu = true;
 	md->type = DM_TYPE_NONE;
 	mutex_init(&md->suspend_lock);
 	mutex_init(&md->type_lock);
@@ -2643,6 +2654,16 @@ static int dm_mq_init_request(void *data, struct request *rq,
 	 */
 	tio->md = md;
 
+	/*
+	 * FIXME: If/when there is another blk-mq request-based DM target
+	 * other than multipath: make conditional on ti->per_bio_data_size
+	 * but it is a serious pain to get target here.
+	 */
+	{
+		/* target-specific per-io data is immediately after the tio */
+		tio->info.ptr = tio + 1;
+	}
+
 	return 0;
 }
 
@@ -2680,8 +2701,11 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 	 * Both the table and md type cannot change after initial table load
 	 */
 	if (dm_get_md_type(md) == DM_TYPE_REQUEST_BASED) {
-		/* clone request is allocated at the end of the pdu */
-		tio->clone = (void *)blk_mq_rq_to_pdu(rq) + sizeof(struct dm_rq_target_io);
+		/*
+		 * Clone the request if underlying devices aren't blk-mq
+		 * - clone request is allocated at the end of the pdu
+		 */
+		tio->clone = blk_mq_rq_to_pdu(rq) + sizeof(*tio) + ti->per_io_data_size;
 		(void) clone_rq(rq, md, tio, GFP_ATOMIC);
 		queue_kthread_work(&md->kworker, &tio->work);
 	} else {
@@ -2704,7 +2728,8 @@ static struct blk_mq_ops dm_mq_ops = {
 	.init_request = dm_mq_init_request,
 };
 
-static int dm_init_request_based_blk_mq_queue(struct mapped_device *md)
+static int dm_init_request_based_blk_mq_queue(struct mapped_device *md,
+					      struct dm_target *immutable_tgt)
 {
 	unsigned md_type = dm_get_md_type(md);
 	struct request_queue *q;
@@ -2719,6 +2744,11 @@ static int dm_init_request_based_blk_mq_queue(struct mapped_device *md)
 	md->tag_set->driver_data = md;
 
 	md->tag_set->cmd_size = sizeof(struct dm_rq_target_io);
+	if (immutable_tgt && immutable_tgt->per_io_data_size) {
+		/* any target-specific per-io data is immediately after the tio */
+		md->tag_set->cmd_size += immutable_tgt->per_io_data_size;
+		md->init_tio_pdu = false;
+	}
 	if (md_type == DM_TYPE_REQUEST_BASED) {
 		/* put the memory for non-blk-mq clone at the end of the pdu */
 		md->tag_set->cmd_size += sizeof(struct request);
@@ -2763,7 +2793,7 @@ static unsigned filter_md_type(unsigned type, struct mapped_device *md)
 /*
  * Setup the DM device's queue based on md's type
  */
-int dm_setup_md_queue(struct mapped_device *md)
+int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
 	int r;
 	unsigned md_type = filter_md_type(dm_get_md_type(md), md);
@@ -2777,7 +2807,7 @@ int dm_setup_md_queue(struct mapped_device *md)
 		}
 		break;
 	case DM_TYPE_MQ_REQUEST_BASED:
-		r = dm_init_request_based_blk_mq_queue(md);
+		r = dm_init_request_based_blk_mq_queue(md, dm_table_get_immutable_target(t));
 		if (r) {
 			DMWARN("Cannot initialize queue for request-based blk-mq mapped device");
 			return r;
@@ -3505,8 +3535,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned t
 		if (!pool_size)
 			pool_size = dm_get_reserved_rq_based_ios();
 		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
-		/* per_io_data_size is not used. */
-		WARN_ON(per_io_data_size != 0);
+		/* per_io_data_size is used for blk-mq pdu at queue allocation */
 		break;
 	default:
 		BUG();
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 4305a51..13a758e 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -86,7 +86,7 @@ void dm_set_md_type(struct mapped_device *md, unsigned type);
 unsigned dm_get_md_type(struct mapped_device *md);
 struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
 
-int dm_setup_md_queue(struct mapped_device *md);
+int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t);
 
 /*
  * To check the return value from dm_table_find_target().
-- 
2.5.4 (Apple Git-61)
