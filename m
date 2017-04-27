From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 04/13] dm-rq: Adjust requeuing delays
Date: Thu, 27 Apr 2017 07:48:12 +0200
Message-ID: <4e2af3ef-ae37-104f-8f47-57ec84def2db@suse.de>
References: <20170426183728.10821-1-bart.vanassche@sandisk.com>
	<20170426183728.10821-5-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170426183728.10821-5-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>, Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On 04/26/2017 08:37 PM, Bart Van Assche wrote:
> Reduce the requeue delay in dm_requeue_original_request() from 5s
> to 0.5s to avoid that this delay slows down failover or failback.
> Increase the requeue delay in dm_mq_queue_rq() from 0.1s to 0.5s
> to reduce the system load if immediate requeuing has been requested
> by the dm driver.
> =

> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-rq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> =

> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 0b081d170087..c53debdcd7dc 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -280,7 +280,7 @@ static void dm_requeue_original_request(struct dm_rq_=
target_io *tio, bool delay_
>  	if (!rq->q->mq_ops)
>  		dm_old_requeue_request(rq);
>  	else
> -		dm_mq_delay_requeue_request(rq, delay_requeue ? 5000 : 0);
> +		dm_mq_delay_requeue_request(rq, delay_requeue ? 500/*ms*/ : 0);
>  =

>  	rq_completed(md, rw, false);
>  }
> @@ -755,7 +755,7 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		/* Undo dm_start_request() before requeuing */
>  		rq_end_stats(md, rq);
>  		rq_completed(md, rq_data_dir(rq), false);
> -		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
> +		blk_mq_delay_run_hw_queue(hctx, 500/*ms*/);
>  		return BLK_MQ_RQ_QUEUE_BUSY;
>  	}
>  =

> =

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- =

Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
