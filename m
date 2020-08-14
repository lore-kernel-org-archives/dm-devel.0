From: "Meneghini, John" <John.Meneghini@netapp.com>
Subject: Re: [RESEND PATCH] nvme: explicitly use normal NVMe
 error handling when appropriate
Date: Fri, 14 Aug 2020 04:26:29 +0000
Message-ID: <7A5B9516-373E-41A3-94F8-5ED16BB968CE@netapp.com>
References: <6B826235-C504-4621-B8F7-34475B200979@netapp.com>
	<20200807000755.GA28957@redhat.com>
	<510f5aff-0437-b1ce-f7ab-c812edbea880@grimberg.me>
	<20200807045015.GA29737@redhat.com>
	<fec745aa-0091-ee1f-cb0f-da9e18cf0aa2@grimberg.me>
	<20200810143620.GA19127@redhat.com> <20200810172209.GA19535@redhat.com>
	<20200813144811.GA5452@redhat.com>
	<20200813153623.GA30905@infradead.org>
	<20200813174704.GA6137@redhat.com>
	<20200813184349.GA8191@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200813184349.GA8191@infradead.org>
Content-Language: en-US
Content-ID: <66C07CD1A8013D478B4CAB755053F779@namprd06.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: Sagi Grimberg <sagi@grimberg.me>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Ewan Milne <emilne@redhat.com>, Chao Leng <lengchao@huawei.com>, Busch <kbusch@kernel.org>, "Meneghini,
	John" <John.Meneghini@netapp.com>, Keith
List-Id: dm-devel.ids

On 8/13/20, 2:44 PM, "Christoph Hellwig" <hch@infradead.org> wrote:

    On Thu, Aug 13, 2020 at 01:47:04PM -0400, Mike Snitzer wrote:
    > This is just a tweak to improve the high-level fault tree of core NVMe
    > error handling.  No functional change, but for such basic errors,
    > avoiding entering nvme_failover_req is meaningful on a code flow level.
    > Makes code to handle errors that need local retry clearer by being more
    > structured, less circuitous.
  
I don't understand how entering nvme_failover_req() is circuitous. 

This code path is only taken if REQ_NVME_MPATH is set which - unless I am mistaken - in
the case that you care about it will not be set.

    > Allows NVMe core's handling of such errors to be more explicit and live
    > in core.c rather than multipath.c -- so things like ACRE handling can be
    > made explicitly part of core and not nested under nvme_failover_req's
    > relatively obscure failsafe that returns false for anything it doesn't
    > care about.

The ACRE handling is already explicitly a part of the core.  I don't understand what
you are after here Mike.  Are you saying that you don't want the ACRE code to run
when REQ_NVME_MPATH is clear?

    If we're going that way I'd rather do something like the (untested)
    patch below that adds a dispostion function with a function that
    decides it and then just switches on it:

Christoph, it looks like you've moved a lot of stuff around here, with no actual
functional change.... but it's really hard for me to tell.  Please be sure to cc me if this
becomes a real patch.

How does your patch solve the problem of making dm-multipath work with command retries?

Mike, do you want the nvme-core driver to retry commands on the same path, with CRD, for the dm-multipath
use case... or are you looking for a different treatment of REQ_FAILFAST_DEV... or what? 

Maybe I'm not seeing it.

/John

    diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
    index 88cff309d8e4f0..a740320f0d4ee7 100644
    --- a/drivers/nvme/host/core.c
    +++ b/drivers/nvme/host/core.c
    @@ -241,17 +241,6 @@ static blk_status_t nvme_error_status(u16 status)
            }
     }

    -static inline bool nvme_req_needs_retry(struct request *req)
    -{
    -       if (blk_noretry_request(req))
    -               return false;
    -       if (nvme_req(req)->status & NVME_SC_DNR)
    -               return false;
    -       if (nvme_req(req)->retries >= nvme_max_retries)
    -               return false;
    -       return true;
    -}
    -
     static void nvme_retry_req(struct request *req)
     {
            struct nvme_ns *ns = req->q->queuedata;
    @@ -268,33 +257,75 @@ static void nvme_retry_req(struct request *req)
            blk_mq_delay_kick_requeue_list(req->q, delay);
     }

    -void nvme_complete_rq(struct request *req)
    +enum nvme_disposition {
    +       COMPLETE,
    +       RETRY,
    +       REDIRECT_ANA,
    +       REDIRECT_TMP,
    +};
    +
    +static inline enum nvme_disposition nvme_req_disposition(struct request *req)
    +{
    +       if (likely(nvme_req(req)->status == 0))
    +               return COMPLETE;
    +
    +       if (blk_noretry_request(req) ||
    +           (nvme_req(req)->status & NVME_SC_DNR) ||
    +           nvme_req(req)->retries >= nvme_max_retries)
    +               return COMPLETE;
    +
    +       if (req->cmd_flags & REQ_NVME_MPATH) {
    +               switch (nvme_req(req)->status & 0x7ff) {
    +               case NVME_SC_ANA_TRANSITION:
    +               case NVME_SC_ANA_INACCESSIBLE:
    +               case NVME_SC_ANA_PERSISTENT_LOSS:
    +                       return REDIRECT_ANA;
    +               case NVME_SC_HOST_PATH_ERROR:
    +               case NVME_SC_HOST_ABORTED_CMD:
    +                       return REDIRECT_TMP;
    +               }
    +       }
    +
    +       if (blk_queue_dying(req->q))
    +               return COMPLETE;
    +       return RETRY;
    +}
    +
    +static inline void nvme_complete_req(struct request *req)
     {
            blk_status_t status = nvme_error_status(nvme_req(req)->status);

    -       trace_nvme_complete_rq(req);
    +       if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
    +           req_op(req) == REQ_OP_ZONE_APPEND)
    +               req->__sector = nvme_lba_to_sect(req->q->queuedata,
    +                       le64_to_cpu(nvme_req(req)->result.u64));
    +
    +       nvme_trace_bio_complete(req, status);
    +       blk_mq_end_request(req, status);
    +}

    +void nvme_complete_rq(struct request *req)
    +{
    +       trace_nvme_complete_rq(req);
            nvme_cleanup_cmd(req);

            if (nvme_req(req)->ctrl->kas)
                    nvme_req(req)->ctrl->comp_seen = true;

    -       if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
    -               if ((req->cmd_flags & REQ_NVME_MPATH) && nvme_failover_req(req))
    -                       return;
    -
    -               if (!blk_queue_dying(req->q)) {
    -                       nvme_retry_req(req);
    -                       return;
    -               }
    -       } else if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
    -                  req_op(req) == REQ_OP_ZONE_APPEND) {
    -               req->__sector = nvme_lba_to_sect(req->q->queuedata,
    -                       le64_to_cpu(nvme_req(req)->result.u64));
    +       switch (nvme_req_disposition(req)) {
    +       case COMPLETE:
    +               nvme_complete_req(req);
    +               return;
    +       case RETRY:
    +               nvme_retry_req(req);
    +               return;
    +       case REDIRECT_ANA:
    +               nvme_failover_req(req, true);
    +               return;
    +       case REDIRECT_TMP:
    +               nvme_failover_req(req, false);
    +               return;
            }
    -
    -       nvme_trace_bio_complete(req, status);
    -       blk_mq_end_request(req, status);
     }
     EXPORT_SYMBOL_GPL(nvme_complete_rq);

    diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
    index 3ded54d2c9c6ad..0c22b2c88687a2 100644
    --- a/drivers/nvme/host/multipath.c
    +++ b/drivers/nvme/host/multipath.c
    @@ -65,51 +65,32 @@ void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
            }
     }

    -bool nvme_failover_req(struct request *req)
    +void nvme_failover_req(struct request *req, bool is_ana_status)
     {
            struct nvme_ns *ns = req->q->queuedata;
    -       u16 status = nvme_req(req)->status;
            unsigned long flags;

    -       switch (status & 0x7ff) {
    -       case NVME_SC_ANA_TRANSITION:
    -       case NVME_SC_ANA_INACCESSIBLE:
    -       case NVME_SC_ANA_PERSISTENT_LOSS:
    -               /*
    -                * If we got back an ANA error we know the controller is alive,
    -                * but not ready to serve this namespaces.  The spec suggests
    -                * we should update our general state here, but due to the fact
    -                * that the admin and I/O queues are not serialized that is
    -                * fundamentally racy.  So instead just clear the current path,
    -                * mark the the path as pending and kick of a re-read of the ANA
    -                * log page ASAP.
    -                */
    -               nvme_mpath_clear_current_path(ns);
    -               if (ns->ctrl->ana_log_buf) {
    -                       set_bit(NVME_NS_ANA_PENDING, &ns->flags);
    -                       queue_work(nvme_wq, &ns->ctrl->ana_work);
    -               }
    -               break;
    -       case NVME_SC_HOST_PATH_ERROR:
    -       case NVME_SC_HOST_ABORTED_CMD:
    -               /*
    -                * Temporary transport disruption in talking to the controller.
    -                * Try to send on a new path.
    -                */
    -               nvme_mpath_clear_current_path(ns);
    -               break;
    -       default:
    -               /* This was a non-ANA error so follow the normal error path. */
    -               return false;
    +       nvme_mpath_clear_current_path(ns);
    +
    +       /*
    +        * If we got back an ANA error we know the controller is alive, but not
    +        * ready to serve this namespaces.  The spec suggests we should update
    +        * our general state here, but due to the fact that the admin and I/O
    +        * queues are not serialized that is fundamentally racy.  So instead
    +        * just clear the current path, mark the the path as pending and kick
    +        * of a re-read of the ANA log page ASAP.
    +        */
    +       if (is_ana_status && ns->ctrl->ana_log_buf) {
    +               set_bit(NVME_NS_ANA_PENDING, &ns->flags);
    +               queue_work(nvme_wq, &ns->ctrl->ana_work);
            }

            spin_lock_irqsave(&ns->head->requeue_lock, flags);
            blk_steal_bios(&ns->head->requeue_list, req);
            spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
    -       blk_mq_end_request(req, 0);

    +       blk_mq_end_request(req, 0);
            kblockd_schedule_work(&ns->head->requeue_work);
    -       return true;
     }

     void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
    diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
    index ebb8c3ed388554..aeff1c491ac2ef 100644
    --- a/drivers/nvme/host/nvme.h
    +++ b/drivers/nvme/host/nvme.h
    @@ -629,7 +629,7 @@ void nvme_mpath_wait_freeze(struct nvme_subsystem *subsys);
     void nvme_mpath_start_freeze(struct nvme_subsystem *subsys);
     void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
                            struct nvme_ctrl *ctrl, int *flags);
    -bool nvme_failover_req(struct request *req);
    +void nvme_failover_req(struct request *req, bool is_ana_status);
     void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl);
     int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl,struct nvme_ns_head *head);
     void nvme_mpath_add_disk(struct nvme_ns *ns, struct nvme_id_ns *id);
    @@ -688,9 +688,8 @@ static inline void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
            sprintf(disk_name, "nvme%dn%d", ctrl->instance, ns->head->instance);
     }

    -static inline bool nvme_failover_req(struct request *req)
    +static inline void nvme_failover_req(struct request *req, bool is_ana_status)
     {
    -       return false;
     }
     static inline void nvme_kick_requeue_lists(struct nvme_ctrl *ctrl)
     {
