From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: initialize queuedata and congested_data early
Date: Wed, 28 Oct 2015 15:17:40 -0400
Message-ID: <20151028191740.GA22082@redhat.com>
References: <alpine.LRH.2.02.1510271904430.4649@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1510271904430.4649@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

On Tue, Oct 27 2015 at  7:06pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> This fixes a possible race when md->queue->backing_dev_info.congested_fn 
> is changed.
> 
> Note that Zdenek is seeing some other memory corruption where 
> dm_any_congested is called with invalid argument, but it is unlikely to be 
> fixed by this patch.
> 
> Mikulas
> 
> -
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> The patch bfebd1cdb497a57757c83f5fbf1a29931591e2a4 ("dm: add full blk-mq
> support to request-based DM") moves the initialization of fields
> queuedata, backing_dev_info.congested_fn and
> backing_dev_info.congested_data from the function dm_init_md_queue (that
> is called when the device is created) to dm_init_old_md_queue (that is
> called when type of device is determined).
> 
> There is no locking when accessing these variables, thus it is possible
> that other part of the kernel sees queue->backing_dev_info.congested_fn
> initialized and md->queue->backing_dev_info.congested_data uninitialized,
> passing incorrect parameter to the function dm_any_congested.
> 
> This patch fixes this race condition by moving initialization of queuedata
> and backing_dev_info.congested_data to the function dm_init_md_queue, so
> that these values are initialized when the device is created.
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Fixes: bfebd1cdb497 ("dm: add full blk-mq support to request-based DM")
> Cc: stable@vger.kernel.org	# v4.1+
> 
> ---
>  drivers/md/dm.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> Index: linux-4.3-rc7/drivers/md/dm.c
> ===================================================================
> --- linux-4.3-rc7.orig/drivers/md/dm.c	2015-10-27 23:25:41.000000000 +0100
> +++ linux-4.3-rc7/drivers/md/dm.c	2015-10-27 23:26:45.000000000 +0100
> @@ -2198,6 +2198,9 @@ static void dm_init_md_queue(struct mapp
>  	 * This queue is new, so no concurrency on the queue_flags.
>  	 */
>  	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
> +
> +	md->queue->queuedata = md;
> +	md->queue->backing_dev_info.congested_data = md;
>  }

I don't like these moving to dm_init_md_queue() because they aren't
needed for blk-mq.  No sense establishing data that will go unused in
the blk-mq case.
  
>  static void dm_init_old_md_queue(struct mapped_device *md)
> @@ -2208,9 +2211,7 @@ static void dm_init_old_md_queue(struct 
>  	/*
>  	 * Initialize aspects of queue that aren't relevant for blk-mq
>  	 */
> -	md->queue->queuedata = md;
>  	md->queue->backing_dev_info.congested_fn = dm_any_congested;
> -	md->queue->backing_dev_info.congested_data = md;
>  
>  	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
>  }

Wouldn't it be sufficient to simply reorder so the congested_fn
assignment is last?  E.g.:

	md->queue->queuedata = md;
	md->queue->backing_dev_info.congested_data = md;
	md->queue->backing_dev_info.congested_fn = dm_any_congested;
