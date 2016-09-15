From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 2/6] dm rq: add DM_MAPIO_DELAY_REQUEUE to delay requeue
 of blk-mq requests
Date: Thu, 15 Sep 2016 08:14:40 +0200
Message-ID: <f8ec9117-2191-590c-582d-e41d69072fd6@suse.de>
References: <1473870576-54331-1-git-send-email-snitzer@redhat.com>
 <1473870576-54331-3-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1473870576-54331-3-git-send-email-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, axboe@kernel.dk, dm-devel@redhat.com
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

On 09/14/2016 06:29 PM, Mike Snitzer wrote:
> Otherwise blk-mq will immediately dispatch requests that are requeued
> via a BLK_MQ_RQ_QUEUE_BUSY return from blk_mq_ops .queue_rq.
> 
> Delayed requeue is implemented using blk_mq_delay_kick_requeue_list()
> with a delay of 5 secs.  In the context of DM multipath (all paths down)
> it doesn't make any sense to requeue more quickly.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-rq.c            | 32 ++++++++++++++++++--------------
>  include/linux/device-mapper.h |  1 +
>  2 files changed, 19 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index 0d301d5..9eebc8d 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
[..]
> @@ -671,7 +673,10 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
>  		break;
>  	case DM_MAPIO_REQUEUE:
>  		/* The target wants to requeue the I/O */
> -		dm_requeue_original_request(md, tio->orig);
> +		break;
> +	case DM_MAPIO_DELAY_REQUEUE:
> +		/* The target wants to requeue the I/O after a delay */
> +		dm_requeue_original_request(md, tio->orig, true);
>  		break;
>  	default:
>  		if (r > 0) {
Hmm? What happened here?
Don't we need to requeue the request for DM_MAPIO_REQUEUE?

> @@ -681,10 +686,9 @@ static int map_request(struct dm_rq_target_io *tio, struct request *rq,
>  
>  		/* The target wants to complete the I/O */
>  		dm_kill_unmapped_request(rq, r);
> -		return r;
>  	}
>  
> -	return 0;
> +	return r;
>  }
>  
>  static void dm_start_request(struct mapped_device *md, struct request *orig)
[ .. ]

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
