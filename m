From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 3/7] dm mpath: push back requests instead of
 queueing
Date: Tue, 4 Feb 2014 03:25:16 +0000
Message-ID: <11AF7C027C4C02408624617A498607840105D600@BPXM12GP.gisp.nec.co.jp>
References: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
	<1391459326-21569-4-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391459326-21569-4-git-send-email-snitzer@redhat.com>
Content-Language: ja-JP
Content-ID: <5A5C5E9BFEE8824582841D871B3A8D27@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 02/04/14 05:28, Mike Snitzer wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> There is no reason why multipath needs to queue requests internally for
> queue_if_no_path or pg_init; we should rather push them back onto the
> request queue.
> 
> And while we're at it we can simplify the conditional statement in
> map_io() to make it easier to read.
> 
> Since mpath no longer does internal queuing of I/O the table info no
> longer emits the internal queue_size.  Instead it displays 1 if queuing
> is being used or 0 if it is not.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

> @@ -391,37 +392,30 @@ static int map_io(struct multipath *m, struct request *clone,
>  
>  	pgpath = m->current_pgpath;
>  
> -	if (was_queued)
> -		m->queue_size--;
> -
> -	if (m->pg_init_required) {
> -		if (!m->pg_init_in_progress)
> -			queue_work(kmultipathd, &m->process_queued_ios);
> -		r = DM_MAPIO_REQUEUE;
> -	} else if ((pgpath && m->queue_io) ||
> -		   (!pgpath && m->queue_if_no_path)) {
> -		/* Queue for the daemon to resubmit */
> -		list_add_tail(&clone->queuelist, &m->queued_ios);
> -		m->queue_size++;
> -		if (!m->queue_io)
> -			queue_work(kmultipathd, &m->process_queued_ios);
> -		pgpath = NULL;
> -		r = DM_MAPIO_SUBMITTED;
> -	} else if (pgpath) {
> -		bdev = pgpath->path.dev->bdev;
> -		clone->q = bdev_get_queue(bdev);
> -		clone->rq_disk = bdev->bd_disk;
> -	} else if (__must_push_back(m))
> -		r = DM_MAPIO_REQUEUE;
> -	else
> -		r = -EIO;	/* Failed */
> -
> -	mpio->pgpath = pgpath;
> -	mpio->nr_bytes = nr_bytes;
> -
> -	if (r == DM_MAPIO_REMAPPED && pgpath->pg->ps.type->start_io)
> -		pgpath->pg->ps.type->start_io(&pgpath->pg->ps, &pgpath->path,
> -					      nr_bytes);
> +	if (pgpath) {

> +		if (__pgpath_busy(pgpath))
> +			r = DM_MAPIO_REQUEUE;

Sorry I forgot to comment on this.
The above 2 lines should be removed from this patch.
I suggested to add them because the early version of this patch was
going to remove multipath_busy(). It's no longer true.

Removing them will make this patch easier to understand.

Other than that:

Reviewed-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>


> +		else if (pg_ready(m)) {
> +			bdev = pgpath->path.dev->bdev;
> +			clone->q = bdev_get_queue(bdev);
> +			clone->rq_disk = bdev->bd_disk;
> +			mpio->pgpath = pgpath;
> +			mpio->nr_bytes = nr_bytes;
> +			if (pgpath->pg->ps.type->start_io)
> +				pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
> +							      &pgpath->path,
> +							      nr_bytes);
> +		} else {
> +			__pg_init_all_paths(m);
> +			r = DM_MAPIO_REQUEUE;
> +		}
> +	} else {
> +		/* No path */
> +		if (__must_push_back(m))
> +			r = DM_MAPIO_REQUEUE;
> +		else
> +			r = -EIO;	/* Failed */
> +	}
>  
>  	spin_unlock_irqrestore(&m->lock, flags);
>  

-- 
Jun'ichi Nomura, NEC Corporation
