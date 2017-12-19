From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH 2/5] nvme: use request's failover callback for multipath failover
Date: Tue, 19 Dec 2017 16:05:43 -0500
Message-ID: <20171219210546.65928-3-snitzer@redhat.com>
References: <20171219210546.65928-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171219210546.65928-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, emilne@redhat.com, james.smart@broadcom.com
Cc: hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Also, remove NVMe-local REQ_NVME_MPATH since setting bio's
bi_failover_rq serves the same purpose: flag the request as being from
multipath (which NVMe's error handler then gives further consideration
about it being retryable).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/nvme/host/core.c      | 4 ++--
 drivers/nvme/host/multipath.c | 7 ++++---
 drivers/nvme/host/nvme.h      | 9 ---------
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f837d666cbd4..0c0a52fa78e4 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -191,8 +191,8 @@ static inline bool nvme_req_needs_retry(struct request *req)
 void nvme_complete_rq(struct request *req)
 {
 	if (unlikely(nvme_req(req)->status && nvme_req_needs_retry(req))) {
-		if (nvme_req_needs_failover(req)) {
-			nvme_failover_req(req);
+		if (req->failover_rq && nvme_req_needs_failover(req)) {
+			req->failover_rq(req);
 			return;
 		}
 
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 1218a9fca846..0ab51c184df9 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -19,7 +19,7 @@ module_param(multipath, bool, 0644);
 MODULE_PARM_DESC(multipath,
 	"turn on native support for multiple controllers per subsystem");
 
-void nvme_failover_req(struct request *req)
+static void nvme_failover_req(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
 	unsigned long flags;
@@ -35,7 +35,7 @@ void nvme_failover_req(struct request *req)
 
 bool nvme_req_needs_failover(struct request *req)
 {
-	if (!(req->cmd_flags & REQ_NVME_MPATH))
+	if (!req->failover_rq)
 		return false;
 
 	switch (nvme_req(req)->status & 0x7ff) {
@@ -128,7 +128,8 @@ static blk_qc_t nvme_ns_head_make_request(struct request_queue *q,
 	ns = nvme_find_path(head);
 	if (likely(ns)) {
 		bio->bi_disk = ns->disk;
-		bio->bi_opf |= REQ_NVME_MPATH;
+		/* Mark bio as coming in through the mpath node. */
+		bio->bi_failover_rq = nvme_failover_req;
 		ret = direct_make_request(bio);
 	} else if (!list_empty_careful(&head->list)) {
 		dev_warn_ratelimited(dev, "no path available - requeuing I/O\n");
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ea1aa5283e8e..5195b4850eb0 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -95,11 +95,6 @@ struct nvme_request {
 	u16			status;
 };
 
-/*
- * Mark a bio as coming in through the mpath node.
- */
-#define REQ_NVME_MPATH		REQ_DRV
-
 enum {
 	NVME_REQ_CANCELLED		= (1 << 0),
 };
@@ -400,7 +395,6 @@ extern const struct attribute_group nvme_ns_id_attr_group;
 extern const struct block_device_operations nvme_ns_head_ops;
 
 #ifdef CONFIG_NVME_MULTIPATH
-void nvme_failover_req(struct request *req);
 bool nvme_req_needs_failover(struct request *req);
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
@@ -418,9 +412,6 @@ static inline void nvme_mpath_clear_current_path(struct nvme_ns *ns)
 }
 struct nvme_ns *nvme_find_path(struct nvme_ns_head *head);
 #else
-static inline void nvme_failover_req(struct request *req)
-{
-}
 static inline bool nvme_req_needs_failover(struct request *req)
 {
 	return false;
-- 
2.15.0
