From: Keith Busch <keith.busch@intel.com>
Subject: Re: [for-4.16 PATCH v2 0/5] block, nvme, dm: allow DM multipath to
 use NVMe's error handler
Date: Tue, 2 Jan 2018 16:29:43 -0700
Message-ID: <20180102232943.GC26533@localhost.localdomain>
References: <20171227032257.8182-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171227032257.8182-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Instead of hiding NVMe path related errors, the NVMe driver needs to
code an appropriate generic block status from an NVMe status.

We already do this translation whether or not CONFIG_NVME_MULTIPATHING is
set, so I think it's silly NVMe native multipathing has a second status
decoder. This just doubles the work if we need to handle any new NVMe
status codes in the future.

I have a counter-proposal below that unifies NVMe-to-block status
translations, and combines common code for determining if an error is a
path failure. This should work for both NVMe and DM, and DM won't need
NVMe specifics.

I can split this into a series if there's indication this is ok and
satisfies the need.

---
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index f7810cc869ac..f6f7a1aefc53 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1475,21 +1475,6 @@ static void activate_path_work(struct work_struct *work)
 	activate_or_offline_path(pgpath);
 }
 
-static int noretry_error(blk_status_t error)
-{
-	switch (error) {
-	case BLK_STS_NOTSUPP:
-	case BLK_STS_NOSPC:
-	case BLK_STS_TARGET:
-	case BLK_STS_NEXUS:
-	case BLK_STS_MEDIUM:
-		return 1;
-	}
-
-	/* Anything else could be a path failure, so should be retried */
-	return 0;
-}
-
 static int multipath_end_io(struct dm_target *ti, struct request *clone,
 			    blk_status_t error, union map_info *map_context)
 {
@@ -1508,7 +1493,7 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	 * request into dm core, which will remake a clone request and
 	 * clone bios for it and resubmit it later.
 	 */
-	if (error && !noretry_error(error)) {
+	if (error && blk_path_failure(error)) {
 		struct multipath *m = ti->private;
 
 		r = DM_ENDIO_REQUEUE;
@@ -1544,7 +1529,7 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 	unsigned long flags;
 	int r = DM_ENDIO_DONE;
 
-	if (!*error || noretry_error(*error))
+	if (!*error || !blk_path_failure(*error))
 		goto done;
 
 	if (pgpath)
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f837d666cbd4..25ef349fd4e4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -190,20 +190,18 @@ static inline bool nvme_req_needs_retry(struct request *req)
 
 void nvme_complete_rq(struct request *req)
 {
-	if (unlikely(nvme_req(req)->status && nvme_req_needs_retry(req))) {
-		if (nvme_req_needs_failover(req)) {
-			nvme_failover_req(req);
-			return;
-		}
+	blk_status_t status = nvme_error_status(req);
 
+	if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
+		if (nvme_failover_req(req, status))
+			return;
 		if (!blk_queue_dying(req->q)) {
 			nvme_req(req)->retries++;
 			blk_mq_requeue_request(req, true);
 			return;
 		}
 	}
-
-	blk_mq_end_request(req, nvme_error_status(req));
+	blk_mq_end_request(req, status);
 }
 EXPORT_SYMBOL_GPL(nvme_complete_rq);
 
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 1218a9fca846..fa3d96780258 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -19,11 +19,16 @@ module_param(multipath, bool, 0644);
 MODULE_PARM_DESC(multipath,
 	"turn on native support for multiple controllers per subsystem");
 
-void nvme_failover_req(struct request *req)
+bool nvme_failover_req(struct request *req, blk_status_t status)
 {
 	struct nvme_ns *ns = req->q->queuedata;
 	unsigned long flags;
 
+	if (!(req->cmd_flags & REQ_NVME_MPATH))
+		return false;
+	if (!blk_path_failure(status))
+		return false;
+
 	spin_lock_irqsave(&ns->head->requeue_lock, flags);
 	blk_steal_bios(&ns->head->requeue_list, req);
 	spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
@@ -31,52 +36,6 @@ void nvme_failover_req(struct request *req)
 
 	nvme_reset_ctrl(ns->ctrl);
 	kblockd_schedule_work(&ns->head->requeue_work);
-}
-
-bool nvme_req_needs_failover(struct request *req)
-{
-	if (!(req->cmd_flags & REQ_NVME_MPATH))
-		return false;
-
-	switch (nvme_req(req)->status & 0x7ff) {
-	/*
-	 * Generic command status:
-	 */
-	case NVME_SC_INVALID_OPCODE:
-	case NVME_SC_INVALID_FIELD:
-	case NVME_SC_INVALID_NS:
-	case NVME_SC_LBA_RANGE:
-	case NVME_SC_CAP_EXCEEDED:
-	case NVME_SC_RESERVATION_CONFLICT:
-		return false;
-
-	/*
-	 * I/O command set specific error.  Unfortunately these values are
-	 * reused for fabrics commands, but those should never get here.
-	 */
-	case NVME_SC_BAD_ATTRIBUTES:
-	case NVME_SC_INVALID_PI:
-	case NVME_SC_READ_ONLY:
-	case NVME_SC_ONCS_NOT_SUPPORTED:
-		WARN_ON_ONCE(nvme_req(req)->cmd->common.opcode ==
-			nvme_fabrics_command);
-		return false;
-
-	/*
-	 * Media and Data Integrity Errors:
-	 */
-	case NVME_SC_WRITE_FAULT:
-	case NVME_SC_READ_ERROR:
-	case NVME_SC_GUARD_CHECK:
-	case NVME_SC_APPTAG_CHECK:
-	case NVME_SC_REFTAG_CHECK:
-	case NVME_SC_COMPARE_FAILED:
-	case NVME_SC_ACCESS_DENIED:
-	case NVME_SC_UNWRITTEN_BLOCK:
-		return false;
-	}
-
-	/* Everything else could be a path failure, so should be retried */
 	return true;
 }
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ea1aa5283e8e..a251d1df4895 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -400,8 +400,7 @@ extern const struct attribute_group nvme_ns_id_attr_group;
 extern const struct block_device_operations nvme_ns_head_ops;
 
 #ifdef CONFIG_NVME_MULTIPATH
-void nvme_failover_req(struct request *req);
-bool nvme_req_needs_failover(struct request *req);
+bool nvme_failover_req(struct request *req, blk_status_t status);
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
 void nvme_mpath_add_disk(struct nvme_ns_head *head);
@@ -418,10 +417,7 @@ static inline void nvme_mpath_clear_current_path(struct nvme_ns *ns)
 }
 struct nvme_ns *nvme_find_path(struct nvme_ns_head *head);
 #else
-static inline void nvme_failover_req(struct request *req)
-{
-}
-static inline bool nvme_req_needs_failover(struct request *req)
+static inline bool nvme_failover_req(struct request *req, blk_status_t status)
 {
 	return false;
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index a1e628e032da..54e416acf55f 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -39,6 +39,21 @@ typedef u8 __bitwise blk_status_t;
 
 #define BLK_STS_AGAIN		((__force blk_status_t)12)
 
+static inline bool blk_path_failure(blk_status_t status)
+{
+	switch (status) {
+	case BLK_STS_NOTSUPP:
+	case BLK_STS_NOSPC:
+	case BLK_STS_TARGET:
+	case BLK_STS_NEXUS:
+	case BLK_STS_MEDIUM:
+	case BLK_STS_PROTECTION:
+		return false;
+	}
+	/* Anything else could be a path failure, so should be retried */
+	return true;
+}
+
 struct blk_issue_stat {
 	u64 stat;
 };
--
