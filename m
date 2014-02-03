From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 4/6] dm-multipath: remove process_queued_ios()
Date: Mon, 3 Feb 2014 11:30:41 +0000
Message-ID: <11AF7C027C4C02408624617A4986078401058C7E@BPXM12GP.gisp.nec.co.jp>
References: <1391415493-102943-1-git-send-email-hare@suse.de>
	<1391415493-102943-5-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391415493-102943-5-git-send-email-hare@suse.de>
Content-Language: ja-JP
Content-ID: <19F4F36E3A2C474695EA1031112ADC81@gisp.nec.co.jp>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 02/03/14 17:18, Hannes Reinecke wrote:
> Doesn't serve any real purpose anymore; dm_table_run_queue()
> will already move things to a workqueue, so we don't need
> to do it ourselves.
> We only need to take care to add a small delay when calling
> __pg_init_all_paths() to move processing off to a workqueue;
> pg_init_done() is run from an interrupt context and needs to
> complete as fast as possible.

I think more explanation is needed for the patch description.
As far as I understand, the change is based on the following reasoning:

  process_queued_ios() has served 3 functions:
    1) select pg and pgpath if none is selected
    2) start pg_init if requested
    3) dispatch queued IOs when pg is ready

  Basically, a call to queue_work(process_queued_ios) can be replaced by
  dm_table_run_queue(), which runs request queue and ends up calling
  map_io(), which does 1), 2) and 3).

  Exception is when !pg_ready() (= either pg_init is running or requested),
  multipath_busy() prevents map_io() being called from request_fn.

  If pg_init is running, it should be ok as far as pg_init_done() does
  the right thing when pg_init is completed. I.e. restart pg_init if
  !pg_ready() or call dm_table_run_queue() to kick map_io().

  If pg_init is requested, we have to make sure the request is detected
  and pg_init will be started.
  pg_init is requested in 3 places:
    a) __choose_pgpath() in map_io()
    b) __choose_pgpath() in multipath_ioctl()
    c) pg_init retry in pg_init_done()
  a) is ok because map_io() calls __pg_init_all_paths(), which does 2).
  b) needs a call to __pg_init_all_paths(), which does 2).
  c) needs a call to __pg_init_all_paths(), which does 2).


By writing the above, I found possible bugs related to 1):

> @@ -1217,9 +1185,11 @@ static void pg_init_done(void *data, int errors)
>  
>  	if (!m->pg_init_required)
>  		m->queue_io = 0;
> -
> -	m->pg_init_delay_retry = delay_retry;
> -	queue_work(kmultipathd, &m->process_queued_ios);
> +	else {
> +		m->pg_init_delay_retry = delay_retry;
> +		__pg_init_all_paths(m, 50/HZ);
> +		goto out;
> +	}
>  
>  	/*
>  	 * Wake up any thread waiting to suspend.

It is possible that m->current_pg is NULL.
(E.g. pg_init failed for current_pgpath, bypass_pg() was called, etc.)
__pg_init_all_paths() will cause oops in such a case.

So how about doing this in pg_init_done():

	if (m->pg_init_required) {
		m->pg_init_delay_retry = delay_retry;
		if (__pg_init_all_paths(m))
			goto out;
	}

	/* pg_init successfully completed */
	m->queue_io = 0;

and in __pg_init_all_paths(), do something like:

	m->pg_init_required = 0;
	...
	if (!m->current_pg)
		return 0;
	...
	return m->pg_init_in_progress;


> @@ -1593,8 +1563,13 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
>  	if (!r && ti->len != i_size_read(bdev->bd_inode) >> SECTOR_SHIFT)
>  		r = scsi_verify_blk_ioctl(NULL, cmd);
>  
> -	if (r == -ENOTCONN && !fatal_signal_pending(current))
> -		queue_work(kmultipathd, &m->process_queued_ios);
> +	if (r == -ENOTCONN && !fatal_signal_pending(current)) {
> +		spin_lock_irqsave(&m->lock, flags);
> +		if (m->current_pgpath && m->pg_init_required)
> +			__pg_init_all_paths(m, 0);
> +		spin_unlock_irqrestore(&m->lock, flags);
> +		dm_table_run_md_queue_async(m->ti->table);
> +	}
>  
>  	return r ? : __blkdev_driver_ioctl(bdev, mode, cmd, arg);
>  }

Similarly, m->current_pgpath can be NULL here while pg_init_required.
Then pg_init_required is left uncleared and all IOs in the queue will
stall until somebody calls multipath_ioctl() to redo pg selection.

-- 
Jun'ichi Nomura, NEC Corporation
