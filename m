From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [for-4.16 PATCH v5 2/4] block: properly protect the 'queue' kobj
 in blk_unregister_queue
Date: Fri, 12 Jan 2018 23:17:05 +0800
Message-ID: <20180112151704.GB28061@ming.t460p>
References: <20180112150606.6037-1-snitzer@redhat.com>
 <20180112150606.6037-3-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180112150606.6037-3-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, Ming Lei <tom.leiming@gmail.com>, hare@suse.de, Bart.VanAssche@wdc.com, David Jeffery <djeffery@redhat.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Jan 12, 2018 at 10:06:04AM -0500, Mike Snitzer wrote:
> The original commit e9a823fb34a8b (block: fix warning when I/O elevator
> is changed as request_queue is being removed) is pretty conflated.
> "conflated" because the resource being protected by q->sysfs_lock isn't
> the queue_flags (it is the 'queue' kobj).
> 
> q->sysfs_lock serializes __elevator_change() (via elv_iosched_store)
> from racing with blk_unregister_queue():
> 1) By holding q->sysfs_lock first, __elevator_change() can complete
> before a racing blk_unregister_queue().
> 2) Conversely, __elevator_change() is testing for QUEUE_FLAG_REGISTERED
> in case elv_iosched_store() loses the race with blk_unregister_queue(),
> it needs a way to know the 'queue' kobj isn't there.
> 
> Expand the scope of blk_unregister_queue()'s q->sysfs_lock use so it is
> held until after the 'queue' kobj is removed.

This way will cause deadlock, see blow.

> 
> Also, blk_unregister_queue() should use q->queue_lock to protect against
> any concurrent writes to q->queue_flags -- even though chances are the
> queue is being cleaned up so no concurrent writes are likely.
> 
> Fixes: e9a823fb34a8b ("block: fix warning when I/O elevator is changed as request_queue is being removed")
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  block/blk-sysfs.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 870484eaed1f..9272452ff456 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -929,12 +929,17 @@ void blk_unregister_queue(struct gendisk *disk)
>  	if (WARN_ON(!q))
>  		return;
>  
> +	/*
> +	 * Protect against the 'queue' kobj being accessed
> +	 * while/after it is removed.
> +	 */
>  	mutex_lock(&q->sysfs_lock);
> -	queue_flag_clear_unlocked(QUEUE_FLAG_REGISTERED, q);
> -	mutex_unlock(&q->sysfs_lock);
>  
> -	wbt_exit(q);
> +	spin_lock_irq(q->queue_lock);
> +	queue_flag_clear(QUEUE_FLAG_REGISTERED, q);
> +	spin_unlock_irq(q->queue_lock);
>  
> +	wbt_exit(q);
>  
>  	if (q->mq_ops)
>  		blk_mq_unregister_dev(disk_to_dev(disk), q);

void blk_mq_unregister_dev(struct device *dev, struct request_queue *q)
{
        mutex_lock(&q->sysfs_lock);
        __blk_mq_unregister_dev(dev, q);
        mutex_unlock(&q->sysfs_lock);
}

> @@ -946,4 +951,6 @@ void blk_unregister_queue(struct gendisk *disk)
>  	kobject_del(&q->kobj);
>  	blk_trace_remove_sysfs(disk_to_dev(disk));
>  	kobject_put(&disk_to_dev(disk)->kobj);
> +
> +	mutex_unlock(&q->sysfs_lock);
>  }

Except for above, I remember there is also lockdep warning between
sysfs_lock and driver core's lock if the sysfs_lock is extended in this
way(I tried it before, but forget the details now), so please just hold
queue_lock inside the sysfs lock.

Thanks,
Ming
