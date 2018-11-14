From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: multipath-tools: add ANA support for NVMe device
Date: Wed, 14 Nov 2018 12:47:47 -0500
Message-ID: <20181114174746.GA18526@redhat.com>
References: <1541657381-7452-1-git-send-email-lijie34@huawei.com>
 <2691abf6733f791fb16b86d96446440e4aaff99f.camel@suse.com>
 <20181112215323.GA7983@redhat.com>
 <20181113161838.GC9827@localhost.localdomain>
 <20181113180008.GA12513@redhat.com>
 <20181114053837.GA15086@redhat.com>
 <30cf7af7-8826-55bd-e39a-4f81ed032f6d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <30cf7af7-8826-55bd-e39a-4f81ed032f6d@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, hch@lst.de, axboe@kernel.dk, Martin Wilck <mwilck@suse.com>, lijie <lijie34@huawei.com>, xose.vazquez@gmail.com, linux-nvme@lists.infradead.org, chengjike.cheng@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, wangzhoumengjian@huawei.com, christophe.varoqui@opensvc.com, bmarzins@redhat.com, sschremm@netapp.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Wed, Nov 14 2018 at  2:49am -0500,
Hannes Reinecke <hare@suse.de> wrote:

> On 11/14/18 6:38 AM, Mike Snitzer wrote:
> >On Tue, Nov 13 2018 at  1:00pm -0500,
> >Mike Snitzer <snitzer@redhat.com> wrote:
> >
> >>[1]: http://lists.infradead.org/pipermail/linux-nvme/2018-November/020765.html
> >>[2]: https://www.redhat.com/archives/dm-devel/2018-November/msg00072.html
> >...
> >
> >I knew there had to be a pretty tight coupling between the NVMe driver's
> >native multipathing and ANA support... and that the simplicity of
> >Hannes' patch [1] was too good to be true.
> >
> >The real justification for not making Hannes' change is it'd effectively
> >be useless without first splitting out the ANA handling done during NVMe
> >request completion (NVME_SC_ANA_* cases in nvme_failover_req) that
> >triggers re-reading the ANA log page accordingly.
> >
> >So without the ability to drive the ANA workqueue to trigger
> >nvme_read_ana_log() from the nvme driver's completion path -- even if
> >nvme_core.multipath=N -- it really doesn't buy multipath-tools anything
> >to have the NVMe driver export the ana state via sysfs, because that ANA
> >state will never get updated.
> >
> Hmm. Indeed, I was more focussed on having the sysfs attributes
> displayed, so yes, indeed it needs some more work.
...
> >Not holding my breath BUT:
> >if decoupling the reading of ANA state from native NVMe multipathing
> >specific work during nvme request completion were an acceptable
> >advancement I'd gladly do the work.
> >
> I'd be happy to work on that, given that we'll have to have 'real'
> ANA support for device-mapper anyway for SLE12 SP4 etc.

I had a close enough look yesterday that I figured I'd just implement
what I reasoned through as one way forward, compile tested only (patch
relative to Jens' for-4.21/block):

 drivers/nvme/host/core.c      | 14 +++++++---
 drivers/nvme/host/multipath.c | 65 ++++++++++++++++++++++++++-----------------
 drivers/nvme/host/nvme.h      |  4 +++
 3 files changed, 54 insertions(+), 29 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f172d63db2b5..05313ab5d91e 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -252,10 +252,16 @@ void nvme_complete_rq(struct request *req)
 	trace_nvme_complete_rq(req);
 
 	if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
-		if ((req->cmd_flags & REQ_NVME_MPATH) &&
-		    blk_path_error(status)) {
-			nvme_failover_req(req);
-			return;
+		if (blk_path_error(status)) {
+			struct nvme_ns *ns = req->q->queuedata;
+			u16 nvme_status = nvme_req(req)->status;
+
+			if (req->cmd_flags & REQ_NVME_MPATH) {
+				nvme_failover_req(req);
+				nvme_update_ana(ns, nvme_status);
+				return;
+			}
+			nvme_update_ana(ns, nvme_status);
 		}
 
 		if (!blk_queue_dying(req->q)) {
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 5e3cc8c59a39..f7fbc161dc8c 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -22,7 +22,7 @@ MODULE_PARM_DESC(multipath,
 
 inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
 {
-	return multipath && ctrl->subsys && (ctrl->subsys->cmic & (1 << 3));
+	return ctrl->subsys && (ctrl->subsys->cmic & (1 << 3));
 }
 
 /*
@@ -47,6 +47,17 @@ void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
 	}
 }
 
+static bool nvme_ana_error(u16 status)
+{
+	switch (status & 0x7ff) {
+	case NVME_SC_ANA_TRANSITION:
+	case NVME_SC_ANA_INACCESSIBLE:
+	case NVME_SC_ANA_PERSISTENT_LOSS:
+		return true;
+	}
+	return false;
+}
+
 void nvme_failover_req(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
@@ -58,10 +69,7 @@ void nvme_failover_req(struct request *req)
 	spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
 	blk_mq_end_request(req, 0);
 
-	switch (status & 0x7ff) {
-	case NVME_SC_ANA_TRANSITION:
-	case NVME_SC_ANA_INACCESSIBLE:
-	case NVME_SC_ANA_PERSISTENT_LOSS:
+	if (nvme_ana_error(status)) {
 		/*
 		 * If we got back an ANA error we know the controller is alive,
 		 * but not ready to serve this namespaces.  The spec suggests
@@ -69,31 +77,38 @@ void nvme_failover_req(struct request *req)
 		 * that the admin and I/O queues are not serialized that is
 		 * fundamentally racy.  So instead just clear the current path,
 		 * mark the the path as pending and kick of a re-read of the ANA
-		 * log page ASAP.
+		 * log page ASAP (see nvme_update_ana() below).
 		 */
 		nvme_mpath_clear_current_path(ns);
-		if (ns->ctrl->ana_log_buf) {
-			set_bit(NVME_NS_ANA_PENDING, &ns->flags);
-			queue_work(nvme_wq, &ns->ctrl->ana_work);
+	} else {
+		switch (status & 0x7ff) {
+		case NVME_SC_HOST_PATH_ERROR:
+			/*
+			 * Temporary transport disruption in talking to the
+			 * controller.  Try to send on a new path.
+			 */
+			nvme_mpath_clear_current_path(ns);
+			break;
+		default:
+			/*
+			 * Reset the controller for any non-ANA error as we
+			 * don't know what caused the error.
+			 */
+			nvme_reset_ctrl(ns->ctrl);
+			break;
 		}
-		break;
-	case NVME_SC_HOST_PATH_ERROR:
-		/*
-		 * Temporary transport disruption in talking to the controller.
-		 * Try to send on a new path.
-		 */
-		nvme_mpath_clear_current_path(ns);
-		break;
-	default:
-		/*
-		 * Reset the controller for any non-ANA error as we don't know
-		 * what caused the error.
-		 */
-		nvme_reset_ctrl(ns->ctrl);
-		break;
 	}
+}
 
-	kblockd_schedule_work(&ns->head->requeue_work);
+void nvme_update_ana(struct nvme_ns *ns, u16 status)
+{
+	if (nvme_ana_error(status) && ns->ctrl->ana_log_buf) {
+		set_bit(NVME_NS_ANA_PENDING, &ns->flags);
+		queue_work(nvme_wq, &ns->ctrl->ana_work);
+	}
+
+	if (multipath)
+		kblockd_schedule_work(&ns->head->requeue_work);
 }
 
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 32a1f1cfdfb4..8b4bc2054b7a 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -468,6 +468,7 @@ bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl);
 void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
 			struct nvme_ctrl *ctrl, int *flags);
 void nvme_failover_req(struct request *req);
+void nvme_update_ana(struct nvme_ns *ns, u16 status);
 void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
 int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
 void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id);
@@ -507,6 +508,9 @@ static inline void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
 static inline void nvme_failover_req(struct request *req)
 {
 }
+static inline void nvme_update_ana(struct nvme_ns *ns, u16 status)
+{
+}
 static inline void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
 {
 }
