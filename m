From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 3/5] dm-multipath: remove process_queued_ios()
Date: Fri, 31 Jan 2014 09:43:00 +0000
Message-ID: <11AF7C027C4C02408624617A49860784010535C4@BPXM12GP.gisp.nec.co.jp>
References: <1391159444-17987-1-git-send-email-hare@suse.de>
	<1391159444-17987-4-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391159444-17987-4-git-send-email-hare@suse.de>
Content-Language: ja-JP
Content-ID: <A83D56AF2E993747BEAF4E988641B2C6@gisp.nec.co.jp>
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

On 01/31/14 18:10, Hannes Reinecke wrote:
> @@ -1217,9 +1185,21 @@ static void pg_init_done(void *data, int errors)
>  
>  	if (!m->pg_init_required)
>  		m->queue_io = 0;
> -
> -	m->pg_init_delay_retry = delay_retry;
> -	queue_work(kmultipathd, &m->process_queued_ios);
> +	else {
> +		if (!pg_init_delay) {
> +			m->pg_init_delay_retry = 0;
> +			/*
> +			 * Add a small delay to move the
> +			 * activation to a workqueue
> +			 */
> +			pg_init_delay = HZ / 50;
> +		} else
> +			m->pg_init_delay_retry = 1;
> +		if (queue_delayed_work(kmpath_handlerd, &pgpath->activate_path,
> +				       pg_init_delay))
> +			m->pg_init_in_progress++;
> +		goto out;
> +	}

This code is called when pg_init_progress becomes 0,
that means it is possible that multiple pgpaths have requested retries.
So you have to activate_path for all non-active pgpath in this pg,
like __pg_init_all_paths() does in the current code.

Also, you aren't clearing pg_init_required here.
I think it causes extra pg_init unnecessarily.

What do you think if we just call __pg_init_all_paths() here
instead of open coding it?

-- 
Jun'ichi Nomura, NEC Corporation
