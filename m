From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH 2/2] dm-multipath: reduce memory pressure
 during requeuing
Date: Mon, 20 Jan 2014 11:59:28 +0000
Message-ID: <11AF7C027C4C02408624617A4986078401024EEB@BPXM12GP.gisp.nec.co.jp>
References: <1389955328-107148-1-git-send-email-hare@suse.de>
	<1389955328-107148-3-git-send-email-hare@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1389955328-107148-3-git-send-email-hare@suse.de>
Content-Language: ja-JP
Content-ID: <7127D23117FC0645ACBB8D3F37AB79C9@gisp.nec.co.jp>
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
> @@ -908,19 +910,9 @@ static void multipath_dtr(struct dm_target *ti)
>  static int multipath_map(struct dm_target *ti, struct request *clone,
>  			 union map_info *map_context)
>  {
> -	int r;
>  	struct multipath *m = (struct multipath *) ti->private;
>  
> -	if (set_mapinfo(m, map_context) < 0)
> -		/* ENOMEM, requeue */
> -		return DM_MAPIO_REQUEUE;
> -
> -	clone->cmd_flags |= REQ_FAILFAST_TRANSPORT;
> -	r = map_io(m, clone, map_context);
> -	if (r < 0 || r == DM_MAPIO_REQUEUE)
> -		clear_mapinfo(m, map_context);
> -
> -	return r;
> +	return map_io(m, clone, map_context);
>  }

Now multipath_map() is the only caller of map_io() and
most part of multipath_map() is moved to map_io(),
there is no reason to separate those functions.
You could fold map_io() into multipath_map().

-- 
Jun'ichi Nomura, NEC Corporation
