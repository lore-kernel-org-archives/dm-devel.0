From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH] dm-mpath: push back requests instead of
 queueing
Date: Tue, 12 Nov 2013 08:43:29 +0000
Message-ID: <11AF7C027C4C02408624617A49860784F0A9D8@BPXM12GP.gisp.nec.co.jp>
References: <1383901339-81536-1-git-send-email-hare@suse.de>
	<11AF7C027C4C02408624617A49860784F0A5F4@BPXM12GP.gisp.nec.co.jp>
	<5281E403.5020005@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5281E403.5020005@suse.de>
Content-Language: ja-JP
Content-ID: <446B1C4496DD0D459D632533CB5C7140@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: Steffen Maier <maier@linux.vnet.ibm.com>, device-mapper development <dm-devel@redhat.com>, Frank Mayhar <fmayhar@google.com>, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On 11/12/13 17:17, Hannes Reinecke wrote:
> On 11/12/2013 08:48 AM, Junichi Nomura wrote:
>> On 11/08/13 18:02, Hannes Reinecke wrote:
>>> In doing so we can also remove the ->busy check as a requeue is identical
>>> to ->busy returning 'true' from the callers perspective. This simplifies
>>> the code by quite a lot.
>>
>> They are not identical.
>> ->busy returns true when underlying path cannot dispatch a request
>> immediately. In that case it's better to keep the request in queue
>> to allow merges.  (It used to have real impact on buffered sequential
>> write + fsync workload, though the performance impact might become
>> smaller in recent kernels due to plugging change.)
>> Also ->busy can be used by upper layer (dm_table_any_busy_target).
>> So you can't just remove it.
>>
> But they are identical from the callers perspective:
> drivers/md/dm.c:dm_request_fn()
> 
> 		if (ti->type->busy && ti->type->busy(ti))
> 			goto delay_and_out;
> 
> 		clone = dm_start_request(md, rq);
> 
> 		spin_unlock(q->queue_lock);
> 		if (map_request(ti, clone, md))
> 			goto requeued;
> 
> 		BUG_ON(!irqs_disabled());
> 		spin_lock(q->queue_lock);
> 	}
> 
> 	goto out;
> 
> requeued:
> 	BUG_ON(!irqs_disabled());
> 	spin_lock(q->queue_lock);
> 
> delay_and_out:
> 	blk_delay_queue(q, HZ / 10);
> 
> So the only difference between ->busy and return 'DM_MAPIO_REQUEUE'
> is that 'busy' runs under the queue_lock.

A difference is whether the request is once dequeued or not.
I think requeued request does not accept any merge.

But the point is not there; if you remove ->busy, nobody checks whether
underlying device is busy and DM_MAPIO_REQUEUE won't be returned.
So the other option might be moving ->busy check in request_fn to
inside of map function and let it return DM_MAPIO_REQUEUE.

> And yes, in theory ->busy might be used from any upper layer; but
> so far the only caller I've found _is_ in dm_request_fn().
> So removing doesn't do any harm.
> 
> Unless I've misread something ...

<snip>

>>> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
>>> index b3e26c7..20a19bd 100644
>>> --- a/drivers/md/dm.c
>>> +++ b/drivers/md/dm.c
>>> @@ -1876,6 +1876,19 @@ static int dm_any_congested(void *congested_data, int bdi_bits)
>>>  	return r;
>>>  }
>>>  
>>> +void dm_table_run_queue(struct dm_table *t)
>>> +{
>>> +	struct mapped_device *md = dm_table_get_md(t);
>>> +	unsigned long flags;
>>> +
>>> +	if (md->queue) {
>>> +		spin_lock_irqsave(md->queue->queue_lock, flags);
>>> +		blk_run_queue_async(md->queue);
>>> +		spin_unlock_irqrestore(md->queue->queue_lock, flags);
>>> +	}
>>> +}
>>> +EXPORT_SYMBOL_GPL(dm_table_run_queue);
>>
>> Shouldn't this be in dm-table.c?
>>
> It would be logical.
> But as 'struct mapped_device' is internal to dm.c you
> would then end-up with something like:
> 
> void dm_run_queue(struct mapped_device *md)
> 
> and I would need to call it like
> 
> dm_run_queue(dm_table_get_md())
> 
> which I felt was a bit pointless, as this would
> be the _only_ valid calling sequence. Hence
> I moved the call to dm_table_get_md() into the
> function, even though it meant a possible
> layering violation.
> 
> Oh, the joys of device-mapper ...

Yeah, I know that feeling and don't insist on this.
But maybe a code like this work?

void dm_table_run_queue(struct dm_table *t)
{
	struct mapped_device *md = dm_table_get_md(t);
	struct request_queue *q = dm_disk(md)->queue;
	unsigned long flags;

	if (q) {
		spin_lock_irqsave(q->queue_lock, flags);
		blk_run_queue_async(q);
		spin_unlock_irqrestore(q->queue_lock, flags);
	}
}

-- 
Jun'ichi Nomura, NEC Corporation
