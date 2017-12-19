From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH 3/5] nvme: move nvme_req_needs_failover() from multipath to core
Date: Tue, 19 Dec 2017 16:05:44 -0500
Message-ID: <20171219210546.65928-4-snitzer@redhat.com>
References: <20171219210546.65928-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171219210546.65928-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com
Cc: hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

nvme_req_needs_failover() could be usable regardless of whether
CONFIG_NVME_MULTIPATH is set.

DM multipath will also make use of it.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/nvme/host/core.c      | 46 ++++++++++++++++++++++++++++++++++++++++++
 drivers/nvme/host/multipath.c | 47 -------------------------------------------
 drivers/nvme/host/nvme.h      |  5 -----
 3 files changed, 46 insertions(+), 52 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 0c0a52fa78e4..63691e251f8c 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -188,6 +188,52 @@ static inline bool nvme_req_needs_retry(struct request *req)
 	return true;
 }
 
+static bool nvme_req_needs_failover(struct request *req)
+{
+	/* Caller verifies req->failover_rq is set */
+
+	switch (nvme_req(req)->status & 0x7ff) {
+	/*
+	 * Generic command status:
+	 */
+	case NVME_SC_INVALID_OPCODE:
+	case NVME_SC_INVALID_FIELD:
+	case NVME_SC_INVALID_NS:
+	case NVME_SC_LBA_RANGE:
+	case NVME_SC_CAP_EXCEEDED:
+	case NVME_SC_RESERVATION_CONFLICT:
+		return false;
+
+	/*
+	 * I/O command set specific error.  Unfortunately these values are
+	 * reused for fabrics commands, but those should never get here.
+	 */
+	case NVME_SC_BAD_ATTRIBUTES:
+	case NVME_SC_INVALID_PI:
+	case NVME_SC_READ_ONLY:
+	case NVME_SC_ONCS_NOT_SUPPORTED:
+		WARN_ON_ONCE(nvme_req(req)->cmd->common.opcode ==
+			nvme_fabrics_command);
+		return false;
+
+	/*
+	 * Media and Data Integrity Errors:
+	 */
+	case NVME_SC_WRITE_FAULT:
+	case NVME_SC_READ_ERROR:
+	case NVME_SC_GUARD_CHECK:
+	case NVME_SC_APPTAG_CHECK:
+	case NVME_SC_REFTAG_CHECK:
+	case NVME_SC_COMPARE_FAILED:
+	case NVME_SC_ACCESS_DENIED:
+	case NVME_SC_UNWRITTEN_BLOCK:
+		return false;
+	}
+
+	/* Everything else could be a path failure, so should be retried */
+	return true;
+}
+
 void nvme_complete_rq(struct request *req)
 {
 	if (unlikely(nvme_req(req)->status && nvme_req_needs_retry(req))) {
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 0ab51c184df9..8df01a8d6c02 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -33,53 +33,6 @@ static void nvme_failover_req(struct request *req)
 	kblockd_schedule_work(&ns->head->requeue_work);
 }
 
-bool nvme_req_needs_failover(struct request *req)
-{
-	if (!req->failover_rq)
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
-	return true;
-}
-
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
 {
 	struct nvme_ns *ns;
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 5195b4850eb0..130eed526e1f 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -395,7 +395,6 @@ extern const struct attribute_group nvme_ns_id_attr_group;
 extern const struct block_device_operations nvme_ns_head_ops;
 
 #ifdef CONFIG_NVME_MULTIPATH
-bool nvme_req_needs_failover(struct request *req);
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
 void nvme_mpath_add_disk(struct nvme_ns_head *head);
@@ -412,10 +411,6 @@ static inline void nvme_mpath_clear_current_path(struct nvme_ns *ns)
 }
 struct nvme_ns *nvme_find_path(struct nvme_ns_head *head);
 #else
-static inline bool nvme_req_needs_failover(struct request *req)
-{
-	return false;
-}
 static inline void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
 {
 }
-- 
2.15.0
