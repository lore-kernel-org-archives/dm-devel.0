From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 4/6] dm-multipath: remove process_queued_ios()
Date: Mon, 3 Feb 2014 12:08:16 +0000
Message-ID: <11AF7C027C4C02408624617A4986078401058DDD@BPXM12GP.gisp.nec.co.jp>
References: <1391415493-102943-1-git-send-email-hare@suse.de>
	<1391415493-102943-5-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1391415493-102943-5-git-send-email-hare@suse.de>
Content-Language: ja-JP
Content-ID: <8F423C5D45320A4484FD93FBEB80C556@gisp.nec.co.jp>
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 02/03/14 17:18, Hannes Reinecke wrote:
> We only need to take care to add a small delay when calling
> __pg_init_all_paths() to move processing off to a workqueue;
> pg_init_done() is run from an interrupt context and needs to
> complete as fast as possible.
...
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

I forgot to comment on this.
Adding delay to queue_work() doesn't make it fast.
So I couldn't see why this "50/HZ" delay has to be added
and where this value comes.

-- 
Jun'ichi Nomura, NEC Corporation
