From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: Re: [PATCH-v2 2/2] Initialize mempool and elevator only
 for request-based dm devices
Date: Fri, 14 Aug 2009 16:01:07 +0900
Message-ID: <4A850BB3.3070703@ct.jp.nec.com>
References: <200908081026.01097.knikanth@suse.de>
	<200908111435.12020.knikanth@suse.de>
	<4A8225DC.1060200@ct.jp.nec.com>
	<200908121417.28760.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200908121417.28760.knikanth@suse.de>
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

On 08/12/2009 05:47 PM +0900, Nikanth Karthikesan wrote:
> Hi Kiyoshi Ueda,
> 
> On Wednesday 12 August 2009 07:45:56 Kiyoshi Ueda wrote:
>> Hi Nikanth,
>>
>> On 08/11/2009 06:05 PM +0900, Nikanth Karthikesan wrote:
>>> On Tuesday 11 August 2009 13:36:24 Kiyoshi Ueda wrote:
>>>> On 08/10/2009 07:48 PM +0900, Nikanth Karthikesan wrote:
>>>>> +
>>>>> +		/*
>>>>> +		 * reinitialize make_request_fn as it was reset to the
>>>>> +		 * default __make_request by blk_init_allocate_queue
>>>>> +		 */
>>>>> +		md->saved_make_request_fn = md->queue->make_request_fn;
>>>>> +		blk_queue_make_request(md->queue, dm_request);
>>>>> +
>>>>> +		blk_queue_softirq_done(md->queue, dm_softirq_done);
>>>>> +		blk_queue_prep_rq(md->queue, dm_prep_fn);
>>>>> +		blk_queue_lld_busy(md->queue, dm_lld_busy);
>>>>> +	}
>>>>> +
>>>>>  	__unbind(md);
>>>>>  	r = __bind(md, table, &limits);
>>>> The queue has been registered at the device creation time by
>>>> add_disk() in alloc_dev().
>>>> Since the queue is reconfigured (elevator is attached), you have to
>>>> update the queue registration (e.g. unregister, then re-register).
>>>> But it may not be easy.  At least, there is no exported interface to
>>>> unregister/re-register queue.
>>> Ah, yes. The scheduler attributes will not be exported in
>>> /sys/block/dm*/queue/iosched. Exporting elv_register_queue() and calling
>>> it here solves it. Something like..
>>>
>>> @@ -2203,6 +2199,29 @@ int dm_swap_table(struct mapped_device *md, struct
>>> dm_table *table)
>>>  		goto out;
>>>  	}
>>>
>>> +	/* new device is being marked as request-based */
>>> +	if (!md->map && dm_table_request_based(table)) {
>>> +		/* initialize queue for request-based dm */
>>> +		r = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
>>> +		if (r)
>>> +			goto out;
>>> +
>>> +		r = elv_register_queue(md->queue);
>>> +		/* if (r)
>>> +		 *	 goto out; Better to ignore, just like add_disk does ;-)
>>> +		 */
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
>>>
>>> I would post the v3 of the patches with this change. Do you see any
>>> problems in this?
>> Humm, it might work for now, but I disagree with that.
>>
>> Since elevator is block internal and dm doesn't really care
>> (its initialization is actually hidden in blk_init_allocated_queue()),
>> directly calling elv_register_queue() from dm seems not right.
>> It will likely introduce a bug by future changes in block layer.
>>
>> I think the right approach is to define a proper block layer interface
>> to reflect the queue configuration change.
>> That's why I said "Updating the queue registration may not be easy".
> 
> I do not see too much of overhead in the future with this approach,
> atleast no more than "proper block layer interface".

I don't think so.
Just exporting elv_register_queue() will cause some maintenance costs
to request-based dm developers as below.

Although currently only elevator is the queue's feature which is
needed for only request-based dm, such other features may be added
to queue in the future.
Then, the developer who added the feature may not notice that
request-based dm needs to register the feature here, if there
is no critical problem (e.g. compile error or panic) without it.
That causes the lack of such features only in request-based dm.
Therefore, request-based dm developers always have to watch
the change of the block-layer and make the registration related code.
I think it's a sort of big maintenance cost.

So we should make the code as the change of the block-layer becomes
effective automatically in request-based dm, too, as mush as possible.
In this case, you should make/call an interface for the whole queue,
not only for the elevator, since dm can't/shouldn't know how
blk_init_allocated_queue() initializes the queue.
(And the interface should be used in other generic paths (e.g. add_disk()))
That's a proper block-layer interface which I mentioned, and this
approach should have less overhead than your approach from view point
of longer period.


> IMHO, unregistering the queue and registering the queue again with
> the elevator, is basically wasting CPU cycles and possibly would
> confuse the user-space, which may be watching the sysfs... 

Right, so I said "Updating may not be easy."
(By the way, wasting CPU cycles doesn't matter here, since it happens
 only when we initialize the device and it shouldn't too much.)


> Or asking block layer to recheck and find what we have changed
> in the request_queue. It does not sound like the best solution.

I think this is a better solution than exposing a part of queue
internals as I described above.


> It is better to tell the block-layer that we have added a q->request_fn 
> function, so initialize the elevator.

I don't think it's better as I described above.
(dm can't/shouldn't know how blk_init_allocated_queue() initializes
 the queue.)



By the way, another approach to optimizing the memory usage would be
to determine whether the dm device is bio-based or request-based
at the device creation time, instead of the table binding time.
We want the delayed allocation, since kernel can't decide the device
type until the first table is bound because of the auto-detection
mechanism.  The auto-detection is good for keeping compatibility with
existing user-space tools.  But once user-space tools are changed to
specify device type at the device creation time, we can eventually
remove the auto-detection.
Then, kernel can decide device type in alloc_dev(), so
the initialization code in kernel will become very simple.

FYI, actually, I had this approach in a very early stage of
request-based dm development:
    [kernel]     http://marc.info/?l=dm-devel&m=116656637419846&w=2
    [kernel]     http://marc.info/?l=dm-devel&m=116656689701459&w=2
    [kernel]     http://marc.info/?l=dm-devel&m=116656689707043&w=2
    [user-space] http://marc.info/?l=dm-devel&m=116656689906056&w=2
Now, you can change user-space first before kernel, since
request-based dm is already available.

Thanks,
Kiyoshi Ueda
