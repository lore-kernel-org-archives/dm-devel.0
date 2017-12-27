From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v2 2/5] nvme: use request_queue's failover_rq_fn callback for multipath failover
Date: Tue, 26 Dec 2017 22:22:54 -0500
Message-ID: <20171227032257.8182-3-snitzer@redhat.com>
References: <20171227032257.8182-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171227032257.8182-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, keith.busch@intel.com
Cc: emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Also, remove NVMe-local REQ_NVME_MPATH since setting request_queue's
failover_rq_fn serves the same purpose.  NVMe's error handling gives a
request further consideration about it being retryable if its
request_queue has failover_rq_fn set.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/nvme/host/core.c      | 5 +++--
 drivers/nvme/host/multipath.c | 4 +---
 drivers/nvme/host/nvme.h      | 5 -----
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f837d666cbd4..99f1c7d8514e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -191,8 +191,8 @@ static inline bool nvme_req_needs_retry(struct request *req)
 void nvme_complete_rq(struct request *req)
 {
 	if (unlikely(nvme_req(req)->status && nvme_req_needs_retry(req))) {
-		if (nvme_req_needs_failover(req)) {
-			nvme_failover_req(req);
+		if (req->q->failover_rq_fn && nvme_req_needs_failover(req)) {
+			req->q->failover_rq_fn(req);
 			return;
 		}
 
@@ -2893,6 +2893,7 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid)
 		sprintf(disk_name, "nvme%dc%dn%d", ctrl->subsys->instance,
 				ctrl->cntlid, ns->head->instance);
 		flags = GENHD_FL_HIDDEN;
+		ns->queue->failover_rq_fn = nvme_failover_req;
 	} else {
 		sprintf(disk_name, "nvme%dn%d", ctrl->subsys->instance,
 				ns->head->instance);
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 1218a9fca846..b576942b96b2 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -35,8 +35,7 @@ void nvme_failover_req(struct request *req)
 
 bool nvme_req_needs_failover(struct request *req)
 {
-	if (!(req->cmd_flags & REQ_NVME_MPATH))
-		return false;
+	/* Caller verifies req->q->failover_rq_fn is set */
 
 	switch (nvme_req(req)->status & 0x7ff) {
 	/*
@@ -128,7 +127,6 @@ static blk_qc_t nvme_ns_head_make_request(struct request_queue *q,
 	ns = nvme_find_path(head);
 	if (likely(ns)) {
 		bio->bi_disk = ns->disk;
-		bio->bi_opf |= REQ_NVME_MPATH;
 		ret = direct_make_request(bio);
 	} else if (!list_empty_careful(&head->list)) {
 		dev_warn_ratelimited(dev, "no path available - requeuing I/O\n");
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index ea1aa5283e8e..5ec44935690f 100644
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
-- 
2.15.0
