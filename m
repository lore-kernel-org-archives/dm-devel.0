From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 04/13] dm-rq: Adjust requeuing delays
Date: Thu, 27 Apr 2017 15:16:11 -0400
Message-ID: <20170427191610.GA67119@redhat.com>
References: <20170427171126.26814-1-bart.vanassche@sandisk.com>
	<20170427171126.26814-5-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20170427171126.26814-5-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Thu, Apr 27 2017 at  1:11P -0400,
Bart Van Assche <bart.vanassche@sandisk.com> wrote:

> Reduce the requeue delay in dm_requeue_original_request() from 5s
> to 0.5s to avoid that this delay slows down failover or failback.
> Increase the requeue delay in dm_mq_queue_rq() from 0.1s to 0.5s
> to reduce the system load if immediate requeuing has been requested
> by the dm driver.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/dm-rq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 0b081d170087..c53debdcd7dc 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -280,7 +280,7 @@ static void dm_requeue_original_request(struct dm_rq_target_io *tio, bool delay_
>  	if (!rq->q->mq_ops)
>  		dm_old_requeue_request(rq);
>  	else
> -		dm_mq_delay_requeue_request(rq, delay_requeue ? 5000 : 0);
> +		dm_mq_delay_requeue_request(rq, delay_requeue ? 500/*ms*/ : 0);
>  
>  	rq_completed(md, rw, false);
>  }

This one was already changed to 100ms via commit 06eb061f that I already
staged for 4.12, see:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.12&id=06eb061f48594aa369f6e852b352410298b317a8

> @@ -755,7 +755,7 @@ static int dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>  		/* Undo dm_start_request() before requeuing */
>  		rq_end_stats(md, rq);
>  		rq_completed(md, rq_data_dir(rq), false);
> -		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
> +		blk_mq_delay_run_hw_queue(hctx, 500/*ms*/);
>  		return BLK_MQ_RQ_QUEUE_BUSY;
>  	}
>

This call toblk_mq_delay_run_hw_queue(), while unconvincing and suspect,
is being introduced via block core during the 4.12 merge.

But in general, this tweaking of the timeouts in such a short period
speaks to indecision and leaves me unconvinced of what the _best_ values
to use are.

Let's revisit this after the merge window closes, we can tweak the 100ms
up to 500ms in both locations if you _really_ prefer that.

Mike
