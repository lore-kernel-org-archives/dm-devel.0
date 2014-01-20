From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 1/2] dm-multipath: push back requests instead
 of queueing
Date: Mon, 20 Jan 2014 11:57:17 +0000
Message-ID: <11AF7C027C4C02408624617A4986078401024EB7@BPXM12GP.gisp.nec.co.jp>
References: <1389955328-107148-1-git-send-email-hare@suse.de>
	<1389955328-107148-2-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1389955328-107148-2-git-send-email-hare@suse.de>
Content-Language: ja-JP
Content-ID: <8787ACB685F5CB47AA33891895999AE6@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 01/17/14 19:42, Hannes Reinecke wrote:
> @@ -1256,7 +1188,8 @@ static void pg_init_done(void *data, int errors)
>  		m->queue_io = 0;
>  
>  	m->pg_init_delay_retry = delay_retry;
> -	queue_work(kmultipathd, &m->process_queued_ios);
> +	if (!m->queue_io)
> +		dm_table_run_queue(m->ti->table);
>  
>  	/*
>  	 * Wake up any thread waiting to suspend.

Does pg_init retry still work with this change?

I suspect it doesn't. When a retry is requested in pg_init_done(),
m->queue_io is still 0 and somebody has to kick pg_init.

Instead of replacing "process_queued_ios" work completely,
how about keeping it around and just replacing dispatch_queued_ios() by
dm_table_run_queue()?

> @@ -1606,7 +1540,7 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
>  
>  	spin_lock_irqsave(&m->lock, flags);
>  
> -	if (!m->current_pgpath)
> +	if (!m->current_pgpath || !m->queue_io)
>  		__choose_pgpath(m, 0);
>  
>  	pgpath = m->current_pgpath;

Why is !m->queue_io check added here?

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 0704c52..291491b 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1912,6 +1912,19 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
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
> +

I think this funcion fits better in dm-table.c.

-- 
Jun'ichi Nomura, NEC Corporation
