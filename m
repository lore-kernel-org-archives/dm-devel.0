From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] nvme: allow ANA support to be independent of native
 multipathing
Date: Fri, 16 Nov 2018 08:25:35 +0100
Message-ID: <f7fe5b65-d030-bc5d-233f-e5bc2f995efc@suse.de>
References: <1541657381-7452-1-git-send-email-lijie34@huawei.com>
 <2691abf6733f791fb16b86d96446440e4aaff99f.camel@suse.com>
 <20181112215323.GA7983@redhat.com>
 <20181113161838.GC9827@localhost.localdomain>
 <20181113180008.GA12513@redhat.com> <20181114053837.GA15086@redhat.com>
 <30cf7af7-8826-55bd-e39a-4f81ed032f6d@suse.de>
 <20181114174746.GA18526@redhat.com>
 <87c931e5-4ac9-1795-8d40-cc5541d3ebcf@suse.de>
 <20181115174605.GA19782@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181115174605.GA19782@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org
Cc: Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>, hch@lst.de, axboe@kernel.dk, Martin Wilck <mwilck@suse.com>, lijie <lijie34@huawei.com>, xose.vazquez@gmail.com, chengjike.cheng@huawei.com, shenhong09@huawei.com, dm-devel@redhat.com, wangzhoumengjian@huawei.com, christophe.varoqui@opensvc.com, bmarzins@redhat.com, sschremm@netapp.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On 11/15/18 6:46 PM, Mike Snitzer wrote:
> Whether or not ANA is present is a choice of the target implementation;
> the host (and whether it supports multipathing) has _zero_ influence on
> this.  If the target declares a path as 'inaccessible' the path _is_
> inaccessible to the host.  As such, ANA support should be functional
> even if native multipathing is not.
> 
> Introduce ability to always re-read ANA log page as required due to ANA
> error and make current ANA state available via sysfs -- even if native
> multipathing is disabled on the host (e.g. nvme_core.multipath=N).
> 
> This affords userspace access to the current ANA state independent of
> which layer might be doing multipathing.  It also allows multipath-tools
> to rely on the NVMe driver for ANA support while dm-multipath takes care
> of multipathing.
> 
> While implementing these changes care was taken to preserve the exact
> ANA functionality and code sequence native multipathing has provided.
> This manifests as native multipathing's nvme_failover_req() being
> tweaked to call __nvme_update_ana() which was factored out to allow
> nvme_update_ana() to be called independent of nvme_failover_req().
> 
> And as always, if embedded NVMe users do not want any performance
> overhead associated with ANA or native NVMe multipathing they can
> disable CONFIG_NVME_MULTIPATH.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>   drivers/nvme/host/core.c      | 10 +++++----
>   drivers/nvme/host/multipath.c | 49 +++++++++++++++++++++++++++++++++----------
>   drivers/nvme/host/nvme.h      |  4 ++++
>   3 files changed, 48 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index fe957166c4a9..3df607905628 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -255,10 +255,12 @@ void nvme_complete_rq(struct request *req)
>   		nvme_req(req)->ctrl->comp_seen = true;
>   
>   	if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
> -		if ((req->cmd_flags & REQ_NVME_MPATH) &&
> -		    blk_path_error(status)) {
> -			nvme_failover_req(req);
> -			return;
> +		if (blk_path_error(status)) {
> +			if (req->cmd_flags & REQ_NVME_MPATH) {
> +				nvme_failover_req(req);
> +				return;
> +			}
> +			nvme_update_ana(req);
>   		}
>   
>   		if (!blk_queue_dying(req->q)) {
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index 8e03cda770c5..0adbcff5fba2 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -22,7 +22,7 @@ MODULE_PARM_DESC(multipath,
>   
>   inline bool nvme_ctrl_use_ana(struct nvme_ctrl *ctrl)
>   {
> -	return multipath && ctrl->subsys && (ctrl->subsys->cmic & (1 << 3));
> +	return ctrl->subsys && (ctrl->subsys->cmic & (1 << 3));
>   }
>   
>   /*
> @@ -47,6 +47,35 @@ void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
>   	}
>   }
>   
> +static bool nvme_ana_error(u16 status)
> +{
> +	switch (status & 0x7ff) {
> +	case NVME_SC_ANA_TRANSITION:
> +	case NVME_SC_ANA_INACCESSIBLE:
> +	case NVME_SC_ANA_PERSISTENT_LOSS:
> +		return true;
> +	}
> +	return false;
> +}
> +
> +static void __nvme_update_ana(struct nvme_ns *ns)
> +{
> +	if (!ns->ctrl->ana_log_buf)
> +		return;
> +
> +	set_bit(NVME_NS_ANA_PENDING, &ns->flags);
> +	queue_work(nvme_wq, &ns->ctrl->ana_work);
> +}
> +
> +void nvme_update_ana(struct request *req)
> +{
> +	struct nvme_ns *ns = req->q->queuedata;
> +	u16 status = nvme_req(req)->status;
> +
> +	if (nvme_ana_error(status))
> +		__nvme_update_ana(ns);
> +}
> +
>   void nvme_failover_req(struct request *req)
>   {
>   	struct nvme_ns *ns = req->q->queuedata;
> @@ -58,25 +87,22 @@ void nvme_failover_req(struct request *req)
>   	spin_unlock_irqrestore(&ns->head->requeue_lock, flags);
>   	blk_mq_end_request(req, 0);
>   
> -	switch (status & 0x7ff) {
> -	case NVME_SC_ANA_TRANSITION:
> -	case NVME_SC_ANA_INACCESSIBLE:
> -	case NVME_SC_ANA_PERSISTENT_LOSS:
> +	if (nvme_ana_error(status)) {
>   		/*
>   		 * If we got back an ANA error we know the controller is alive,
>   		 * but not ready to serve this namespaces.  The spec suggests
>   		 * we should update our general state here, but due to the fact
>   		 * that the admin and I/O queues are not serialized that is
>   		 * fundamentally racy.  So instead just clear the current path,
> -		 * mark the the path as pending and kick of a re-read of the ANA
> +		 * mark the path as pending and kick off a re-read of the ANA
>   		 * log page ASAP.
>   		 */
>   		nvme_mpath_clear_current_path(ns);
> -		if (ns->ctrl->ana_log_buf) {
> -			set_bit(NVME_NS_ANA_PENDING, &ns->flags);
> -			queue_work(nvme_wq, &ns->ctrl->ana_work);
> -		}
> -		break;
> +		__nvme_update_ana(ns);
> +		goto kick_requeue;
> +	}
> +
> +	switch (status & 0x7ff) {
>   	case NVME_SC_HOST_PATH_ERROR:
>   		/*
>   		 * Temporary transport disruption in talking to the controller.
> @@ -93,6 +119,7 @@ void nvme_failover_req(struct request *req)
>   		break;
>   	}
>   
> +kick_requeue:
>   	kblockd_schedule_work(&ns->head->requeue_work);
>   }
>   
Doesn't the need to be protected by 'if (ns->head->disk)' or somesuch?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
