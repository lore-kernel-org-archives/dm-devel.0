From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 4/8] dm mpath: remove process_queued_ios()
Date: Sun, 2 Mar 2014 23:12:05 +0000
Message-ID: <11AF7C027C4C02408624617A49860784010DC73B@BPXM12GP.gisp.nec.co.jp>
References: <1393598029-67995-1-git-send-email-hare@suse.de>
	<1393598029-67995-5-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1393598029-67995-5-git-send-email-hare@suse.de>
Content-Language: ja-JP
Content-ID: <360189C74465F144B47ADD45E80E1948@gisp.nec.co.jp>
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

On 02/28/14 23:33, Hannes Reinecke wrote:
> @@ -1214,9 +1189,12 @@ static void pg_init_done(void *data, int errors)
>  
>  	if (!m->pg_init_required)
>  		m->queue_io = 0;
> -
> -	m->pg_init_delay_retry = delay_retry;
> -	queue_work(kmultipathd, &m->process_queued_ios);
> +	else if (m->current_pg) {
> +		m->pg_init_delay_retry = delay_retry;
> +		if (__pg_init_all_paths(m))
> +			goto out;
> +		m->queue_io = 0;
> +	}

Hi Hannes,

If m->pg_init_required && !m->current_pg,
doesn't m->queue_io remain 1 while nobody kicks pg_init?

That's why I suggested this:

	if (m->pg_init_required) {
		m->pg_init_delay_retry = delay_retry;
		if (__pg_init_all_paths(m))
			goto out;
	}
	m->queue_io = 0;

-- 
Jun'ichi Nomura, NEC Corporation
