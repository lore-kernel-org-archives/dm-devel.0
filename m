From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V8 01/11] block: clone nr_integrity_segments and
 write_hint in blk_rq_prep_clone
Date: Fri, 24 Apr 2020 14:43:07 +0200
Message-ID: <43e63bfd-fd63-b9b8-d8db-64bff93f84be@suse.de>
References: <20200424102351.475641-1-ming.lei@redhat.com>
 <20200424102351.475641-2-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200424102351.475641-2-ming.lei@redhat.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, John Garry <john.garry@huawei.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 4/24/20 12:23 PM, Ming Lei wrote:
> So far blk_rq_prep_clone() is only used for setup one underlying cloned
> request from dm-rq request. block intetrity can be enabled for both dm-rq
> and the underlying queues, so it is reasonable to clone rq's
> nr_integrity_segments. Also write_hint is from bio, it should have been
> cloned too.
> 
> So clone nr_integrity_segments and write_hint in blk_rq_prep_clone.
> 
> Cc: John Garry <john.garry@huawei.com>
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: dm-devel@redhat.com
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   block/blk-core.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 7e4a1da0715e..91537e526b45 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1636,9 +1636,13 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
>   		rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
>   		rq->special_vec = rq_src->special_vec;
>   	}
> +#ifdef CONFIG_BLK_DEV_INTEGRITY
> +	rq->nr_integrity_segments = rq_src->nr_integrity_segments;
> +#endif
>   	rq->nr_phys_segments = rq_src->nr_phys_segments;
>   	rq->ioprio = rq_src->ioprio;
>   	rq->extra_len = rq_src->extra_len;
> +	rq->write_hint = rq_src->write_hint;
>   
>   	return 0;
>   
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
