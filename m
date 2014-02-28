From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 4/8] dm mpath: remove process_queued_ios()
Date: Fri, 28 Feb 2014 09:05:49 +0000
Message-ID: <11AF7C027C4C02408624617A49860784010D7D51@BPXM12GP.gisp.nec.co.jp>
References: <1393486229-72034-1-git-send-email-hare@suse.de>
	<1393486229-72034-5-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1393486229-72034-5-git-send-email-hare@suse.de>
Content-Language: ja-JP
Content-ID: <5D326F51BDE8944C863DB81F59D45D6D@gisp.nec.co.jp>
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

On 02/27/14 16:30, Hannes Reinecke wrote:
> @@ -1214,9 +1189,11 @@ static void pg_init_done(void *data, int errors)
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
> +	}

As I commented before:
https://www.redhat.com/archives/dm-devel/2014-February/msg00013.html

I think the code here should clear queue_io like this
when retry was requested but wasn't done:

	if (m->pg_init_required) {
		m->pg_init_delay_retry = delay_retry;
		if (__pg_init_all_paths(m))
			goto out;
	}
	m->queue_io = 0;

Otherwise, if __pg_init_all_paths() returns 0, m->queue_io will remain
as "1" and nobody will clear it.

-- 
Jun'ichi Nomura, NEC Corporation
