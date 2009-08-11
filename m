From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH-v2 2/2] Initialize mempool and elevator only
 for request-based dm devices
Date: Tue, 11 Aug 2009 17:06:24 +0900
Message-ID: <4A812680.7040804@ct.jp.nec.com>
References: <200908081026.01097.knikanth@suse.de>
	<20090808162156.GA7432@redhat.com>
	<200908101551.12047.knikanth@suse.de>
	<200908101618.21060.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200908101618.21060.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi Nikanth,

On 08/10/2009 07:48 PM +0900, Nikanth Karthikesan wrote:
> Intialize the request_queue and elevator only when the device is marked as
> a request-based device. This avoids unnecessary creation of mempool for
> requests. Also we wrongly initialize the elevator even for bio-based devices.
> As the /sys/block/dm-*/queue/scheduler is exported for device-mapper devices,
> it is possible to confuse with scheduler options for bio-based devices where
> scheduler is not at all used.

Thank you for working on this.
Actually, I had tried this delayed allocation thing before,
but I chose the current implementation since I couldn't solve
some problems, which your patch also has.
Please see my comment below.


> @@ -2203,6 +2199,25 @@ int dm_swap_table(struct mapped_device *md, struct dm_table *table)
>  		goto out;
>  	}
>  
> +	/* new device is being marked as request-based */
> +	if (!md->map && dm_table_request_based(table)) {
> +		/* initialize queue for request-based dm */
> +		r = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
> +		if (r)
> +			goto out;

Generally, dm must not allocate memory during resume because
it may cause a deadlock in no memory situation.
However, there is no I/O on this device at this point,
so the allocation should be ok for this special case.
I think some comments are needed here to describe that.


> +
> +		/*
> +		 * reinitialize make_request_fn as it was reset to the
> +		 * default __make_request by blk_init_allocate_queue
> +		 */
> +		md->saved_make_request_fn = md->queue->make_request_fn;
> +		blk_queue_make_request(md->queue, dm_request);
> +
> +		blk_queue_softirq_done(md->queue, dm_softirq_done);
> +		blk_queue_prep_rq(md->queue, dm_prep_fn);
> +		blk_queue_lld_busy(md->queue, dm_lld_busy);
> +	}
> +
>  	__unbind(md);
>  	r = __bind(md, table, &limits);

The queue has been registered at the device creation time by
add_disk() in alloc_dev().
Since the queue is reconfigured (elevator is attached), you have to
update the queue registration (e.g. unregister, then re-register).
But it may not be easy.  At least, there is no exported interface to
unregister/re-register queue.

Thanks,
Kiyoshi Ueda
