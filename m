From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 4/7] dm mpath: remove process_queued_ios()
Date: Tue, 4 Feb 2014 03:24:37 +0000
Message-ID: <11AF7C027C4C02408624617A498607840105D5F0@BPXM12GP.gisp.nec.co.jp>
References: <1391459326-21569-1-git-send-email-snitzer@redhat.com>
	<1391459326-21569-5-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391459326-21569-5-git-send-email-snitzer@redhat.com>
Content-Language: ja-JP
Content-ID: <528FEAED68D1B249A800387278003944@gisp.nec.co.jp>
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
> @@ -1216,9 +1185,12 @@ static void pg_init_done(void *data, int errors)
>  
>  	if (!m->pg_init_required)
>  		m->queue_io = 0;
> -
> -	m->pg_init_delay_retry = delay_retry;
> -	queue_work(kmultipathd, &m->process_queued_ios);
> +	else if (m->current_pg) {
> +		m->pg_init_delay_retry = delay_retry;
> +		/* Use a small delay to force the use of workqueue context */
> +		__pg_init_all_paths(m, 50/HZ);
> +		goto out;
> +	}

I think the patch is still broken.

When "m->pg_init_required && !m->current_pg",
it ends up with !pg_ready() and no pg_init running.
So map_io() will not be called and IO will stall.

What do you think about my suggestion here:
https://www.redhat.com/archives/dm-devel/2014-February/msg00013.html

Also it's not yet clear why the second parameter of __pg_init_all_paths()
is needed. (At least, "50/HZ" is typo or something.)

> @@ -1591,8 +1563,17 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
...
> +		if (m->current_pg && m->pg_init_required)
> +			__pg_init_all_paths(m, 0);
> +		spin_unlock_irqrestore(&m->lock, flags);
> +		dm_table_run_md_queue_async(m->ti->table);
> +	}

What happens if "!m->current_pg && m->pg_init_required"?

-- 
Jun'ichi Nomura, NEC Corporation
