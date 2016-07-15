From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: fix parameter to blk_delay_queue()
Date: Fri, 15 Jul 2016 09:59:05 -0400
Message-ID: <20160715135905.GA22026@redhat.com>
References: <1468589228-20722-1-git-send-email-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1468589228-20722-1-git-send-email-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Cc: Alasdair Kergon <agk@redhat.com>, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Jul 15 2016 at  9:27am -0400,
Tahsin Erdogan <tahsin@google.com> wrote:

> Second parameter to blk_delay_queue() must be in msec units not jiffies.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

This needs to be rebased against linux-next (or linux-dm.git's
'for-next') because the code in question has been moved out to dm-rq.c

But I'll gladly take care of it.

Your change seems fine, and in fact my intent was always to have it be
10 msec, see commit: d548b34b062b60

Curious that the initial "HZ / 10" (from Jens' commit 7eaceaccab) wasn't
expressed in terms of msecs either.

Anyway, thanks for the fix!

Mike

> ---
>  drivers/md/dm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 1b2f96205361..17c63265a205 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2175,7 +2175,7 @@ static void dm_request_fn(struct request_queue *q)
>  		     md_in_flight(md) && rq->bio && rq->bio->bi_vcnt == 1 &&
>  		     md->last_rq_pos == pos && md->last_rq_rw == rq_data_dir(rq)) ||
>  		    (ti->type->busy && ti->type->busy(ti))) {
> -			blk_delay_queue(q, HZ / 100);
> +			blk_delay_queue(q, 10);
>  			return;
>  		}
>  
> -- 
> 2.8.0.rc3.226.g39d4020
> 
