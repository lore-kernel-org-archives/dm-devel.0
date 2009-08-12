From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH-v2 2/2] Initialize mempool and elevator only
 for request-based dm devices
Date: Wed, 12 Aug 2009 11:15:56 +0900
Message-ID: <4A8225DC.1060200@ct.jp.nec.com>
References: <200908081026.01097.knikanth@suse.de>
	<200908101618.21060.knikanth@suse.de>
	<4A812680.7040804@ct.jp.nec.com>
	<200908111435.12020.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200908111435.12020.knikanth@suse.de>
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

On 08/11/2009 06:05 PM +0900, Nikanth Karthikesan wrote:
> On Tuesday 11 August 2009 13:36:24 Kiyoshi Ueda wrote:
>> On 08/10/2009 07:48 PM +0900, Nikanth Karthikesan wrote:
>>> +
>>> +		/*
>>> +		 * reinitialize make_request_fn as it was reset to the
>>> +		 * default __make_request by blk_init_allocate_queue
>>> +		 */
>>> +		md->saved_make_request_fn = md->queue->make_request_fn;
>>> +		blk_queue_make_request(md->queue, dm_request);
>>> +
>>> +		blk_queue_softirq_done(md->queue, dm_softirq_done);
>>> +		blk_queue_prep_rq(md->queue, dm_prep_fn);
>>> +		blk_queue_lld_busy(md->queue, dm_lld_busy);
>>> +	}
>>> +
>>>  	__unbind(md);
>>>  	r = __bind(md, table, &limits);
>> The queue has been registered at the device creation time by
>> add_disk() in alloc_dev().
>> Since the queue is reconfigured (elevator is attached), you have to
>> update the queue registration (e.g. unregister, then re-register).
>> But it may not be easy.  At least, there is no exported interface to
>> unregister/re-register queue.
> 
> Ah, yes. The scheduler attributes will not be exported in 
> /sys/block/dm*/queue/iosched. Exporting elv_register_queue() and calling it 
> here solves it. Something like..
> 
> @@ -2203,6 +2199,29 @@ int dm_swap_table(struct mapped_device *md, struct 
> dm_table *table)
>  		goto out;
>  	}
>  
> +	/* new device is being marked as request-based */
> +	if (!md->map && dm_table_request_based(table)) {
> +		/* initialize queue for request-based dm */
> +		r = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
> +		if (r)
> +			goto out;
> +
> +		r = elv_register_queue(md->queue);
> +		/* if (r)
> +		 *	 goto out; Better to ignore, just like add_disk does ;-)
> +		 */
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
>  
> I would post the v3 of the patches with this change. Do you see any problems 
> in this?

Humm, it might work for now, but I disagree with that.

Since elevator is block internal and dm doesn't really care
(its initialization is actually hidden in blk_init_allocated_queue()),
directly calling elv_register_queue() from dm seems not right.
It will likely introduce a bug by future changes in block layer.

I think the right approach is to define a proper block layer interface
to reflect the queue configuration change.
That's why I said "Updating the queue registration may not be easy".

Thanks,
Kiyoshi Ueda
