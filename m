From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm-mpath: push back requests instead of
 queueing
Date: Tue, 12 Nov 2013 07:48:05 +0000
Message-ID: <11AF7C027C4C02408624617A49860784F0A5F4@BPXM12GP.gisp.nec.co.jp>
References: <1383901339-81536-1-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1383901339-81536-1-git-send-email-hare@suse.de>
Content-Language: ja-JP
Content-ID: <C1F96BE02392CC4CB3BE50490758717A@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>, Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 11/08/13 18:02, Hannes Reinecke wrote:
> There is no reason why multipath needs to queue requests
> internally for queue_if_no_path or pg_init; we should
> rather push them back onto the request queue.
> 
> 
> This patch removes the internal queueing mechanism from dm-multipath.

Hi Hannes,
thanks for working on this.

> In doing so we can also remove the ->busy check as a requeue is identical
> to ->busy returning 'true' from the callers perspective. This simplifies
> the code by quite a lot.

They are not identical.
->busy returns true when underlying path cannot dispatch a request
immediately. In that case it's better to keep the request in queue
to allow merges.  (It used to have real impact on buffered sequential
write + fsync workload, though the performance impact might become
smaller in recent kernels due to plugging change.)
Also ->busy can be used by upper layer (dm_table_any_busy_target).
So you can't just remove it.

> @@ -385,21 +378,15 @@ static int map_io(struct multipath *m, struct request *clone,
>  	    (!m->queue_io && (m->repeat_count && --m->repeat_count == 0)))
>  		__choose_pgpath(m, nr_bytes);
>  
> -	pgpath = m->current_pgpath;
> -
> -	if (was_queued)
> -		m->queue_size--;
> +	if (m->current_pgpath &&
> +	    m->pg_init_required && !m->pg_init_in_progress)
> +		__pg_init_all_paths(m);
>  
> +	pgpath = m->current_pgpath;
>  	if ((pgpath && m->queue_io) ||
>  	    (!pgpath && m->queue_if_no_path)) {
> -		/* Queue for the daemon to resubmit */
> -		list_add_tail(&clone->queuelist, &m->queued_ios);
> -		m->queue_size++;
> -		if ((m->pg_init_required && !m->pg_init_in_progress) ||
> -		    !m->queue_io)
> -			queue_work(kmultipathd, &m->process_queued_ios);
>  		pgpath = NULL;
> -		r = DM_MAPIO_SUBMITTED;
> +		r = DM_MAPIO_REQUEUE;

if/else sequence in map_io() might be easier to read if we do:

	if (pgpath) {
		if (pg_ready(m)) {
			... // remap
			r = DM_MAPIO_REMAPPED;
		} else {
			__pg_init_all_paths(m);
			r = DM_MAPIO_REQUEUE;
		}
	} else { /* no path */
		if (need_requeue(m))
			r = DM_MAPIO_REQUEUE;
		else
			r = -EIO;
	}

where:
  #define pg_ready(m) (!m->queue_io) /* or rename 'queue_io' */
  #define need_requeue(m) (m->queue_if_no_path || __must_push_back(m))

and move pg_init_required, etc. checks to __pg_init_all_paths().


> @@ -1241,7 +1168,8 @@ static void pg_init_done(void *data, int errors)
>  		m->queue_io = 0;
>  
>  	m->pg_init_delay_retry = delay_retry;
> -	queue_work(kmultipathd, &m->process_queued_ios);
> +	if (!m->queue_io)
> +		dm_table_run_queue(m->ti->table);
>  
>  	/*
>  	 * Wake up any thread waiting to suspend.

process_queued_ios was responsible for retrying pg_init.
And when retrying, m->queue_io is still 0.
So don't we have to run queue unconditionally here
or call __pg_init_all_paths() directly?


> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index b3e26c7..20a19bd 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1876,6 +1876,19 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
>  	return r;
>  }
>  
> +void dm_table_run_queue(struct dm_table *t)
> +{
> +	struct mapped_device *md = dm_table_get_md(t);
> +	unsigned long flags;
> +
> +	if (md->queue) {
> +		spin_lock_irqsave(md->queue->queue_lock, flags);
> +		blk_run_queue_async(md->queue);
> +		spin_unlock_irqrestore(md->queue->queue_lock, flags);
> +	}
> +}
> +EXPORT_SYMBOL_GPL(dm_table_run_queue);

Shouldn't this be in dm-table.c?

-- 
Jun'ichi Nomura, NEC Corporation
