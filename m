From: Mike Snitzer <snitzer@redhat.com>
Subject: [RESEND PATCH] nvme: explicitly use normal NVMe error
 handling when appropriate
Date: Thu, 13 Aug 2020 10:48:11 -0400
Message-ID: <20200813144811.GA5452@redhat.com>
References: <E3390A8E-D582-47BA-A085-21663D883365@netapp.com>
	<20200806184057.GA27858@redhat.com>
	<20200806191943.GA27868@redhat.com>
	<6B826235-C504-4621-B8F7-34475B200979@netapp.com>
	<20200807000755.GA28957@redhat.com>
	<510f5aff-0437-b1ce-f7ab-c812edbea880@grimberg.me>
	<20200807045015.GA29737@redhat.com>
	<fec745aa-0091-ee1f-cb0f-da9e18cf0aa2@grimberg.me>
	<20200810143620.GA19127@redhat.com>
	<20200810172209.GA19535@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200810172209.GA19535@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Sagi Grimberg <sagi@grimberg.me>
Cc: linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Chao Leng <lengchao@huawei.com>, Keith Busch <kbusch@kernel.org>, "Meneghini,
	John" <John.Meneghini@netapp.com>, Ewan Milne <emilne@redhat.com>
List-Id: dm-devel.ids

Commit 764e9332098c0 ("nvme-multipath: do not reset on unknown
status"), among other things, fixed NVME_SC_CMD_INTERRUPTED error
handling by changing multipathing's nvme_failover_req() to short-circuit
path failover and then fallback to NVMe's normal error handling (which
takes care of NVME_SC_CMD_INTERRUPTED).

This detour through native NVMe multipathing code is unwelcome because
it prevents NVMe core from handling NVME_SC_CMD_INTERRUPTED independent
of any multipathing concerns.

Introduce nvme_status_needs_local_error_handling() to prioritize
non-failover retry, when appropriate, in terms of normal NVMe error
handling.  nvme_status_needs_local_error_handling() will naturely evolve
to include handling of any other errors that normal error handling must
be used for.

nvme_failover_req()'s ability to fallback to normal NVMe error handling
has been preserved because it may be useful for future NVME_SC that
nvme_status_needs_local_error_handling() hasn't been trained for yet.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/nvme/host/core.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 88cff309d8e4..be749b690af7 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -252,6 +252,16 @@ static inline bool nvme_req_needs_retry(struct request *req)
 	return true;
 }
 
+static inline bool nvme_status_needs_local_error_handling(u16 status)
+{
+	switch (status & 0x7ff) {
+	case NVME_SC_CMD_INTERRUPTED:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static void nvme_retry_req(struct request *req)
 {
 	struct nvme_ns *ns = req->q->queuedata;
@@ -270,7 +280,8 @@ static void nvme_retry_req(struct request *req)
 
 void nvme_complete_rq(struct request *req)
 {
-	blk_status_t status = nvme_error_status(nvme_req(req)->status);
+	u16 nvme_status = nvme_req(req)->status;
+	blk_status_t status = nvme_error_status(nvme_status);
 
 	trace_nvme_complete_rq(req);
 
@@ -280,7 +291,8 @@ void nvme_complete_rq(struct request *req)
 		nvme_req(req)->ctrl->comp_seen = true;
 
 	if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
-		if ((req->cmd_flags & REQ_NVME_MPATH) && nvme_failover_req(req))
+		if (!nvme_status_needs_local_error_handling(nvme_status) &&
+		    (req->cmd_flags & REQ_NVME_MPATH) && nvme_failover_req(req))
 			return;
 
 		if (!blk_queue_dying(req->q)) {
-- 
2.18.0
