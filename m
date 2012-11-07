From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] Fix deadlock with request based dm and some drivers
Date: Wed, 7 Nov 2012 09:00:57 +0100
Message-ID: <509A1539.3060203@fusionio.com>
References: <5098F47F.9030201@fusionio.com> <5098FF26.4070907@ce.jp.nec.com> <50990410.8080207@fusionio.com> <5099A80B.8070900@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5099A80B.8070900@ce.jp.nec.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair Kergon <agk@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2012-11-07 01:15, Jun'ichi Nomura wrote:
> On 11/06/12 21:35, Jens Axboe wrote:
>> On 2012-11-06 13:14, Jun'ichi Nomura wrote:
>>> (Cc to dm-devel)
>>>
>>> On 11/06/12 20:29, Jens Axboe wrote:
>>>> I recently fixed a deadlock for a customer we have with
>>>> the below patch. I have queued it up in my tree as not
>>>> to lose it. Can I have an ack from you, or do you want
>>>> to submit it yourself? I've marked it stable as well.
>>>
>>> Could you tell details about how the deadlock happened?
>>>
>>> dm's end_io always throws the completion handling to softirq:
>>>   end_clone_request()
>>>     dm_complete_request()
>>>       blk_complete_request()
>>>
>>> then it is processed in softirq context:
>>>   dm_softirq_done()
>>>     dm_done()
>>>       dm_end_request()
>>>         rq_completed(run_queue=true)
>>>           blk_run_queue()
>>>
>>> Since queue_lock is always held with interrupt disabled,
>>> I couldn't see why it could deadlock.
>>>
>>> Request-based dm followed the completion model of scsi
>>> mid layer. So similar code path exists in scsi, too.
>>> For example:
>>>   scsi_request_fn()
>>>     scsi_kill_request()
>>>       blk_complete_request()
>>> then:
>>>   scsi_softirq_done()
>>>     scsi_io_completion()
>>>       scsi_next_command()
>>>         scsi_run_queue()
>>>           spin_lock queue_lock
>>>           __blk_run_queue()
>>>
>>> If calling run-queue from softirq_done_fn() can cause deadlock,
>>> I'm afraid the problem is not limited to dm.
>>
>> dm_softirq_done()
>>     rq_completed()
>>         blk_run_queue()
>           ^^ this is for dm's queue
>>             dm_request_fn()
>>                 dm_dispatch_request()
>>                     blk_insert_cloned_request()
>>                         __elv_add_request()
>>                             elv_insert()
>>                                 blk_run_queue()
>                                   ^^ this is for lower device's queue
>>                                     ...
>>
>> Basically you recurse back into the request handler, since it ends up
>> running the queue.
> 
> But the queues are different as commented inline above.
> So it should be ok. (from deadlock point of view)

It's still not OK, some drivers end up doing spin_unlock_irq() in their
request_fn. Running unknown request_fn from ipi/irq is a bad idea, imho,
it'll quickly cause problems.

>> But I see I've been too focused on the older release,
>> since we don't actually do that anymore after the plugging rewrite. So
>> it should actually be safe in current kernels and hence the patch only
>> needed for the stable series where that is not the case.
> 
> BTW, using blk_run_queue_async() in softirq_done_fn() might be good
> from performance point of view? It may reduce latency of the softirq
> and have an effect of batching request_fn calls.

Yes, I argued the same for the original people who saw the problem. It
is quite an extensive and expensive path to have off the IPI handler. So
from that point of view, I'd recommend the patch as well.

-- 
Jens Axboe

