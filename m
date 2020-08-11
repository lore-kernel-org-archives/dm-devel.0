From: Chao Leng <lengchao@huawei.com>
Subject: Re: [PATCH] nvme: explicitly use normal NVMe error
 handling when appropriate
Date: Tue, 11 Aug 2020 11:32:31 +0800
Message-ID: <7f99724a-a1eb-6bec-f8ae-f9a4601b0487@huawei.com>
References: <729820BC-5F38-4E22-A83A-862E57BAE201@netapp.com>
	<E3390A8E-D582-47BA-A085-21663D883365@netapp.com>
	<20200806184057.GA27858@redhat.com> <20200806191943.GA27868@redhat.com>
	<6B826235-C504-4621-B8F7-34475B200979@netapp.com>
	<20200807000755.GA28957@redhat.com>
	<510f5aff-0437-b1ce-f7ab-c812edbea880@grimberg.me>
	<20200807045015.GA29737@redhat.com>
	<fec745aa-0091-ee1f-cb0f-da9e18cf0aa2@grimberg.me>
	<20200810143620.GA19127@redhat.com> <20200810172209.GA19535@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200810172209.GA19535@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Ewan Milne <emilne@redhat.com>, Keith Busch <kbusch@kernel.org>, "Meneghini, John" <John.Meneghini@netapp.com>
List-Id: dm-devel.ids



On 2020/8/11 1:22, Mike Snitzer wrote:
> On Mon, Aug 10 2020 at 10:36am -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
> 
>> On Fri, Aug 07 2020 at  7:35pm -0400,
>> Sagi Grimberg <sagi@grimberg.me> wrote:
>>
>>>
>>>>> Hey Mike,
> ...
>>>> I think NVMe can easily fix this by having an earlier stage of checking,
>>>> e.g. nvme_local_retry_req(), that shortcircuits ever getting to
>>>> higher-level multipathing consideration (be it native NVMe or DM
>>>> multipathing) for cases like NVME_SC_CMD_INTERRUPTED.
>>>> To be clear: the "default" case of nvme_failover_req() that returns
>>>> false to fallback to NVMe's "local" normal NVMe error handling -- that
>>>> can stay.. but a more explicit handling of cases like
>>>> NVME_SC_CMD_INTERRUPTED should be added to a nvme_local_retry_req()
>>>> check that happens before nvme_failover_req() in nvme_complete_rq().
>>>
>>> I don't necessarily agree with having a dedicated nvme_local_retry_req().
>>> a request that isn't failed over, goes to local error handling (retry or
>>> not). I actually think that just adding the condition to
>>> nvme_complete_req and having nvme_failover_req reject it would work.
>>>
>>> Keith?
>>
>> I think that is basically what I'm thinking too.
> 
> From: Mike Snitzer <snitzer@redhat.com>
> Subject: nvme: explicitly use normal NVMe error handling when appropriate
> 
> Commit 764e9332098c0 ("nvme-multipath: do not reset on unknown
> status"), among other things, fixed NVME_SC_CMD_INTERRUPTED error
> handling by changing multipathing's nvme_failover_req() to short-circuit
> path failover and then fallback to NVMe's normal error handling (which
> takes care of NVME_SC_CMD_INTERRUPTED).
> 
> This detour through native NVMe multipathing code is unwelcome because
> it prevents NVMe core from handling NVME_SC_CMD_INTERRUPTED independent
> of any multipathing concerns.
> 
> Introduce nvme_status_needs_local_error_handling() to prioritize
> non-failover retry, when appropriate, in terms of normal NVMe error
> handling.  nvme_status_needs_local_error_handling() will naturely evolve
> to include handling of any other errors that normal error handling must
> be used for.
> 
> nvme_failover_req()'s ability to fallback to normal NVMe error handling
> has been preserved because it may be useful for future NVME_SC that
> nvme_status_needs_local_error_handling() hasn't yet been trained for.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>   drivers/nvme/host/core.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 88cff309d8e4..be749b690af7 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -252,6 +252,16 @@ static inline bool nvme_req_needs_retry(struct request *req)
>   	return true;
>   }
>   
> +static inline bool nvme_status_needs_local_error_handling(u16 status)
> +{
> +	switch (status & 0x7ff) {
> +	case NVME_SC_CMD_INTERRUPTED:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>   static void nvme_retry_req(struct request *req)
>   {
>   	struct nvme_ns *ns = req->q->queuedata;
> @@ -270,7 +280,8 @@ static void nvme_retry_req(struct request *req)
>   
>   void nvme_complete_rq(struct request *req)
>   {
> -	blk_status_t status = nvme_error_status(nvme_req(req)->status);
> +	u16 nvme_status = nvme_req(req)->status;
> +	blk_status_t status = nvme_error_status(nvme_status);
>   
>   	trace_nvme_complete_rq(req);
>   
> @@ -280,7 +291,8 @@ void nvme_complete_rq(struct request *req)
>   		nvme_req(req)->ctrl->comp_seen = true;
>   
>   	if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
> -		if ((req->cmd_flags & REQ_NVME_MPATH) && nvme_failover_req(req))
> +		if (!nvme_status_needs_local_error_handling(nvme_status) &&
> +		    (req->cmd_flags & REQ_NVME_MPATH) && nvme_failover_req(req))This looks no affect. if work with nvme multipath, now is already retry local.
If work with dm-multipath, still return error.
>   			return;
>   
>   		if (!blk_queue_dying(req->q)) {
> 

Suggest:
REQ_FAILFAST_TRANSPORT may be designed for scsi, because scsi protocol
do not difine the local retry mechanism. SCSI implements a fuzzy local
retry mechanism, so need the REQ_FAILFAST_TRANSPORT for multipath
software, multipath software retry according error code is expected.
nvme is different with scsi about this. It define local retry mechanism
and path error code, so nvme should not care REQ_FAILFAST_TRANSPORT.

Another, for nvme multipath, if the error code is not a path error,
multipath will not fail over to retry. but maybe blk_queue_dying return
true, IO can not be retry at current path, thus IO will interrupted.
blk_queue_dying and path error both need fail over to retry.

So we can do like this:
---
  drivers/nvme/host/core.c      | 26 +++++++++++++++++++-------
  drivers/nvme/host/multipath.c | 11 +++--------
  drivers/nvme/host/nvme.h      |  5 ++---
  include/linux/nvme.h          |  9 +++++++++
  4 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4ee2330c603e..07471bd37f60 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -243,7 +243,7 @@ static blk_status_t nvme_error_status(u16 status)

  static inline bool nvme_req_needs_retry(struct request *req)
  {
-    if (blk_noretry_request(req))
+    if (req->cmd_flags & (REQ_FAILFAST_DEV | REQ_FAILFAST_DRIVER))
          return false;
      if (nvme_req(req)->status & NVME_SC_DNR)
          return false;
@@ -252,6 +252,14 @@ static inline bool nvme_req_needs_retry(struct request *req)
      return true;
  }

+static inline bool nvme_req_path_error(struct request *req)
+{
+    if ((nvme_req(req)->status & NVME_SCT_MASK) == NVME_SCT_PATH ||
+        blk_queue_dying(req->q))
+        return true;
+    return false;
+}
+
  static void nvme_retry_req(struct request *req)
  {
      struct nvme_ns *ns = req->q->queuedata;
@@ -270,7 +278,7 @@ static void nvme_retry_req(struct request *req)

  void nvme_complete_rq(struct request *req)
  {
-    blk_status_t status = nvme_error_status(nvme_req(req)->status);
+    blk_status_t status;

      trace_nvme_complete_rq(req);

@@ -279,16 +287,20 @@ void nvme_complete_rq(struct request *req)
      if (nvme_req(req)->ctrl->kas)
          nvme_req(req)->ctrl->comp_seen = true;

-    if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
-        if ((req->cmd_flags & REQ_NVME_MPATH) && nvme_failover_req(req))
-            return;
-
-        if (!blk_queue_dying(req->q)) {
+    if (unlikely(nvme_req(req)->status != NVME_SC_SUCCESS &&
+        nvme_req_needs_retry(req))) {
+        if (nvme_req_path_error(req)) {
+            if (req->cmd_flags & REQ_NVME_MPATH) {
+                nvme_failover_req(req);
+                return;
+            }
+        } else {
              nvme_retry_req(req);
              return;
          }
      }

+    status = nvme_error_status(nvme_req(req)->status);
      nvme_trace_bio_complete(req, status);
      blk_mq_end_request(req, status);
  }
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 66509472fe06..e182fb3bcd0c 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -65,7 +65,7 @@ void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
      }
  }

-bool nvme_failover_req(struct request *req)
+void nvme_failover_req(struct request *req)
  {
      struct nvme_ns *ns = req->q->queuedata;
      u16 status = nvme_req(req)->status;
@@ -90,17 +90,13 @@ bool nvme_failover_req(struct request *req)
              queue_work(nvme_wq, &ns->ctrl->ana_work);
          }
          break;
-    case NVME_SC_HOST_PATH_ERROR:
-    case NVME_SC_HOST_ABORTED_CMD:
+    default:
          /*
-         * Temporary transport disruption in talking to the controller.
+         * Normal error path.
           * Try to send on a new path.
           */
          nvme_mpath_clear_current_path(ns);
          break;
-    default:
-        /* This was a non-ANA error so follow the normal error path. */
-        return false;
      }

      spin_lock_irqsave(&ns->head->requeue_lock, flags);
@@ -109,7 +105,6 @@ bool nvme_failover_req(struct request *req)
      blk_mq_end_request(req, 0);

      kblockd_schedule_work(&ns->head->requeue_work);
-    return true;
  }

  void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 09ffc3246f60..cbb5d4ba6241 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -582,7 +582,7 @@ void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys);
  void nvme_mpath_start_freeze(struct nvme_subsystem *subsys);
  void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
              struct nvme_ctrl *ctrl, int *flags);
-bool nvme_failover_req(struct request *req);
+void nvme_failover_req(struct request *req);
  void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
  int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
  void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id);
@@ -640,9 +640,8 @@ static inline void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
      sprintf(disk_name, "nvme%dn%d", ctrl->instance, ns->head->instance);
  }

-static inline bool nvme_failover_req(struct request *req)
+static inline void nvme_failover_req(struct request *req)
  {
-    return false;
  }
  static inline void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
  {
diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 5ce51ab4c50e..8c4a5b4d5b4d 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -1441,6 +1441,15 @@ enum {
      NVME_SC_DNR            = 0x4000,
  };

+#define NVME_SCT_MASK 0x700
+enum {
+    NVME_SCT_GENERIC = 0,
+    NVME_SCT_COMMAND_SPECIFIC = 0x100,
+    NVME_SCT_MEDIA = 0x200,
+    NVME_SCT_PATH = 0x300,
+    NVME_SCT_VENDOR = 0x700
+};
+
  struct nvme_completion {
      /*
       * Used by Admin and Fabrics commands to return data:
-- 
2.16.4
