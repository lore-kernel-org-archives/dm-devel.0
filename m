From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [RESEND PATCH] nvme: explicitly use normal NVMe
 error handling when appropriate
Date: Thu, 13 Aug 2020 23:53:14 -0700
Message-ID: <96aff2d0-5907-f5c9-9164-8fea0d030d95@grimberg.me>
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
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200813184349.GA8191@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <snitzer@redhat.com>
Cc: linux-nvme@lists.infradead.org, dm-devel@redhat.com, Ewan Milne <emilne@redhat.com>, Chao Leng <lengchao@huawei.com>, Keith Busch <kbusch@kernel.org>, "Meneghini,
	John" <John.Meneghini@netapp.com>
List-Id: dm-devel.ids


> +static inline enum nvme_disposition nvme_req_disposition(struct request *req)
> +{
> +	if (likely(nvme_req(req)->status == 0))
> +		return COMPLETE;
> +
> +	if (blk_noretry_request(req) ||
> +	    (nvme_req(req)->status & NVME_SC_DNR) ||
> +	    nvme_req(req)->retries >= nvme_max_retries)
> +		return COMPLETE;
> +
> +	if (req->cmd_flags & REQ_NVME_MPATH) {
> +		switch (nvme_req(req)->status & 0x7ff) {
> +		case NVME_SC_ANA_TRANSITION:
> +		case NVME_SC_ANA_INACCESSIBLE:
> +		case NVME_SC_ANA_PERSISTENT_LOSS:
> +			return REDIRECT_ANA;
> +		case NVME_SC_HOST_PATH_ERROR:
> +		case NVME_SC_HOST_ABORTED_CMD:
> +			return REDIRECT_TMP;
> +		}
> +	}
> +
> +	if (blk_queue_dying(req->q))
> +		return COMPLETE;
> +	return RETRY;
> +}
> +
> +static inline void nvme_complete_req(struct request *req)
>   {
>   	blk_status_t status = nvme_error_status(nvme_req(req)->status);
>   
> -	trace_nvme_complete_rq(req);
> +	if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
> +	    req_op(req) == REQ_OP_ZONE_APPEND)
> +		req->__sector = nvme_lba_to_sect(req->q->queuedata,
> +			le64_to_cpu(nvme_req(req)->result.u64));
> +
> +	nvme_trace_bio_complete(req, status);
> +	blk_mq_end_request(req, status);
> +}
>   
> +void nvme_complete_rq(struct request *req)
> +{
> +	trace_nvme_complete_rq(req);
>   	nvme_cleanup_cmd(req);
>   
>   	if (nvme_req(req)->ctrl->kas)
>   		nvme_req(req)->ctrl->comp_seen = true;
>   
> -	if (unlikely(status != BLK_STS_OK && nvme_req_needs_retry(req))) {
> -		if ((req->cmd_flags & REQ_NVME_MPATH) && nvme_failover_req(req))
> -			return;
> -
> -		if (!blk_queue_dying(req->q)) {
> -			nvme_retry_req(req);
> -			return;
> -		}
> -	} else if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
> -		   req_op(req) == REQ_OP_ZONE_APPEND) {
> -		req->__sector = nvme_lba_to_sect(req->q->queuedata,
> -			le64_to_cpu(nvme_req(req)->result.u64));
> +	switch (nvme_req_disposition(req)) {
> +	case COMPLETE:
> +		nvme_complete_req(req);

nvme_complete_rq calling nvme_complete_req... Maybe call it
__nvme_complete_rq instead?

> +		return;
> +	case RETRY:
> +		nvme_retry_req(req);
> +		return;
> +	case REDIRECT_ANA:
> +		nvme_failover_req(req, true);
> +		return;
> +	case REDIRECT_TMP:
> +		nvme_failover_req(req, false);
> +		return;
>   	}
> -
> -	nvme_trace_bio_complete(req, status);
> -	blk_mq_end_request(req, status);
>   }
>   EXPORT_SYMBOL_GPL(nvme_complete_rq);
>   
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index 3ded54d2c9c6ad..0c22b2c88687a2 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -65,51 +65,32 @@ void nvme_set_disk_name(char *disk_name, struct nvme_ns *ns,
>   	}
>   }
>   
> -bool nvme_failover_req(struct request *req)
> +void nvme_failover_req(struct request *req, bool is_ana_status)
>   {
>   	struct nvme_ns *ns = req->q->queuedata;
> -	u16 status = nvme_req(req)->status;
>   	unsigned long flags;
>   
> -	switch (status & 0x7ff) {
> -	case NVME_SC_ANA_TRANSITION:
> -	case NVME_SC_ANA_INACCESSIBLE:
> -	case NVME_SC_ANA_PERSISTENT_LOSS:
> -		/*
> -		 * If we got back an ANA error we know the controller is alive,
> -		 * but not ready to serve this namespaces.  The spec suggests
> -		 * we should update our general state here, but due to the fact
> -		 * that the admin and I/O queues are not serialized that is
> -		 * fundamentally racy.  So instead just clear the current path,
> -		 * mark the the path as pending and kick of a re-read of the ANA
> -		 * log page ASAP.
> -		 */
> -		nvme_mpath_clear_current_path(ns);
> -		if (ns->ctrl->ana_log_buf) {
> -			set_bit(NVME_NS_ANA_PENDING, &ns->flags);
> -			queue_work(nvme_wq, &ns->ctrl->ana_work);
> -		}
> -		break;
> -	case NVME_SC_HOST_PATH_ERROR:
> -	case NVME_SC_HOST_ABORTED_CMD:
> -		/*
> -		 * Temporary transport disruption in talking to the controller.
> -		 * Try to send on a new path.
> -		 */
> -		nvme_mpath_clear_current_path(ns);
> -		break;
> -	default:
> -		/* This was a non-ANA error so follow the normal error path. */
> -		return false;
> +	nvme_mpath_clear_current_path(ns);
> +
> +	/*
> +	 * If we got back an ANA error we know the controller is alive, but not
> +	 * ready to serve this namespaces.  The spec suggests we should update
> +	 * our general state here, but due to the fact that the admin and I/O
> +	 * queues are not serialized that is fundamentally racy.  So instead
> +	 * just clear the current path, mark the the path as pending and kick
> +	 * of a re-read of the ANA log page ASAP.
> +	 */
> +	if (is_ana_status && ns->ctrl->ana_log_buf) {

Maybe call nvme_req_disposition again locally here to not carry
the is_ana_status. But not a biggy..

Overall this looks good I think.
