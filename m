From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH REPOST] dm rq: remove BUG_ON(!irqs_disabled)
	check
Date: Fri, 4 May 2018 11:53:12 -0400
Message-ID: <20180504155311.GA4787@redhat.com>
References: <20180504143639.5300-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180504143639.5300-1-bigeasy@linutronix.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Fri, May 04 2018 at 10:36am -0400,
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> In commit 052189a2ec95 ("dm: remove superfluous irq disablement in
> dm_request_fn") the spin_lock_irq() was replaced with spin_lock() + a
> check for disabled interrupts. Later the locking part was removed in
> commit 2eb6e1e3aa87 ("dm: submit stacked requests in irq enabled
> context") but the BUG_ON() check remained.
> 
> Since the original purpose for the "are-irqs-off" check is gone (the
> ->queue_lock has been removed) remove it.
> 
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/md/dm-rq.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index bf0b840645cc..1a524f992f72 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -688,7 +688,6 @@ static void dm_old_request_fn(struct request_queue *q)
>  		/* Establish tio->ti before queuing work (map_tio_request) */
>  		tio->ti = ti;
>  		kthread_queue_work(&md->kworker, &tio->work);
> -		BUG_ON(!irqs_disabled());
>  	}
>  }
>  
> -- 
> 2.17.0
> 

the queue_lock hasn't been removed for the old .request_fn path in block
core -- which dm_old_request_fn is providing the hook for.

This BUG_ON() documents that reality.

Commit 2eb6e1e3aa87 made it such that work is queued into an irq enabled
context.   But it never changed the fact that old block core's
.request_fn (and as such dm_old_request_fn) is called with irqs
disabled.

So all said:

Nacked-by: Mike Snitzer <snitzer@redhat.com>
