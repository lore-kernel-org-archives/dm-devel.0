From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH RESENT] dm: Check kthread_run's return value
Date: Wed, 6 Jul 2016 09:16:01 -0400
Message-ID: <20160706131601.GA28379@redhat.com>
References: <1467645927-4143-1-git-send-email-mnghuan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1467645927-4143-1-git-send-email-mnghuan@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Minfei Huang <mnghuan@gmail.com>
Cc: agk@redhat.com, shli@kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, Jul 04 2016 at 11:25am -0400,
Minfei Huang <mnghuan@gmail.com> wrote:

> kthread function is used to process kthread_work. And there is no return
> value checking during create this thread. Add this checking to fix this
> issue.
> 
> Signed-off-by: Minfei Huang <mnghuan@gmail.com>
> ---
>  drivers/md/dm.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 1b2f962..d68b9d2 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -2654,12 +2654,15 @@ struct queue_limits *dm_get_queue_limits(struct mapped_device *md)
>  }
>  EXPORT_SYMBOL_GPL(dm_get_queue_limits);
>  
> -static void dm_old_init_rq_based_worker_thread(struct mapped_device *md)
> +static int dm_old_init_rq_based_worker_thread(struct mapped_device *md)
>  {
>  	/* Initialize the request-based DM worker thread */
>  	init_kthread_worker(&md->kworker);
>  	md->kworker_task = kthread_run(kthread_worker_fn, &md->kworker,
>  				       "kdmwork-%s", dm_device_name(md));
> +	if (IS_ERR(md->kworker_task))
> +		return -ENOMEM;
> +	return 0;
>  }
>  
>  /*
> @@ -2667,6 +2670,8 @@ static void dm_old_init_rq_based_worker_thread(struct mapped_device *md)
>   */
>  static int dm_old_init_request_queue(struct mapped_device *md)
>  {
> +	int ret;
> +
>  	/* Fully initialize the queue */
>  	if (!blk_init_allocated_queue(md->queue, dm_request_fn, NULL))
>  		return -EINVAL;
> @@ -2678,7 +2683,9 @@ static int dm_old_init_request_queue(struct mapped_device *md)
>  	blk_queue_softirq_done(md->queue, dm_softirq_done);
>  	blk_queue_prep_rq(md->queue, dm_old_prep_fn);
>  
> -	dm_old_init_rq_based_worker_thread(md);
> +	ret = dm_old_init_rq_based_worker_thread(md);
> +	if (ret < 0)
> +		return ret;
>  
>  	elv_register_queue(md->queue);
>  

This needed rebasing against linux-dm.git's 'for-next'.  I've now staged
this fix for 4.8 inclusion, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=for-next&id=7193a9defcab6f3d3f1eb64c68bad7534e5a39ad
