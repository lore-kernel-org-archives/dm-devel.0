From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH 2/5] nvme/multipath: Consult blk_status_t for failover
Date: Thu,  4 Jan 2018 15:46:20 -0700
Message-ID: <20180104224623.8944-3-keith.busch@intel.com>
References: <20180104224623.8944-1-keith.busch@intel.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180104224623.8944-1-keith.busch@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: Linux Block <linux-block@vger.kernel.org>, Linux NVMe <linux-nvme@lists.infradead.org>, Device Mapper <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Bart VanAssche <bart.vanassche@wdc.com>, James Smart <james.smart@broadcom.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

This removes nvme multipath's specific status decoding to see if failover
is needed, using the generic blk_status_t that was translated earlier. This
abstraction from the raw NVMe status means nvme status decoding exists
in just one place.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 drivers/nvme/host/core.c      |  9 +++++----
 drivers/nvme/host/multipath.c | 44 ++++++++-----------------------------------
 drivers/nvme/host/nvme.h      |  4 ++--
 3 files changed, 15 insertions(+), 42 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f1cf1f6c5b28..4afc681f7089 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -196,8 +196,10 @@ static inline bool nvme_req_needs_retry(struct request *req)
 
 void nvme_complete_rq(struct request *req)
 {
-	if (unlikely(nvme_req(req)->status && nvme_req_needs_retry(req))) {
-		if (nvme_req_needs_failover(req)) {
+	blk_status_t status = nvme_error_status(req);
+
+	if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
+		if (nvme_req_needs_failover(req, status)) {
 			nvme_failover_req(req);
 			return;
 		}
@@ -208,8 +210,7 @@ void nvme_complete_rq(struct request *req)
 			return;
 		}
 	}
-
-	blk_mq_end_request(req, nvme_error_status(req));
+	blk_mq_end_request(req, status);
 }
 EXPORT_SYMBOL_GPL(nvme_complete_rq);
 
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 1218a9fca846..ae9abb600c0f 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -33,46 +33,18 @@ void nvme_failover_req(struct request *req)
 	kblockd_schedule_work(&ns->head->requeue_work);
 }
 
-bool nvme_req_needs_failover(struct request *req)
+bool nvme_req_needs_failover(struct request *req, blk_status_t error)
 {
 	if (!(req->cmd_flags & REQ_NVME_MPATH))
 		return false;
 
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
+	switch (error) {
+	case BLK_STS_NOTSUPP:
+	case BLK_STS_NOSPC:
+	case BLK_STS_TARGET:
+	case BLK_STS_NEXUS:
+	case BLK_STS_MEDIUM:
+	case BLK_STS_PROTECTION:
 		return false;
 	}
 
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ea1aa5283e8e..cf8548c1d7ec 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -401,7 +401,7 @@ extern const struct block_device_operations nvme_ns_head_ops;
 
 #ifdef CONFIG_NVME_MULTIPATH
 void nvme_failover_req(struct request *req);
-bool nvme_req_needs_failover(struct request *req);
+bool nvme_req_needs_failover(struct request *req, blk_status_t error);
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
 void nvme_mpath_add_disk(struct nvme_ns_head *head);
@@ -421,7 +421,7 @@ struct nvme_ns *nvme_find_path(struct nvme_ns_head *head);
 static inline void nvme_failover_req(struct request *req)
 {
 }
-static inline bool nvme_req_needs_failover(struct request *req)
+static inline bool nvme_req_needs_failover(struct request *req, blk_status_t error)
 {
 	return false;
 }
-- 
2.13.6
