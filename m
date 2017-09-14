From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH v2] block: directly insert blk-mq request from blk_insert_cloned_request()
Date: Fri, 15 Sep 2017 00:33:36 +0800
Message-ID: <CACVXFVMexXXtFi8zTHYsOjCFpguhBHUMoAP45wFmB80vou=YZA@mail.gmail.com>
References: <20170908164129.GA48286@redhat.com> <113c15ac-75f5-ff5b-695d-920dc6d5f708@kernel.dk>
 <20170908170727.GA29318@redhat.com> <20170908195805.GA30517@redhat.com>
 <57b4bb39-f50c-ad5e-d47d-01f0f84ec3ca@kernel.dk> <20170908214236.GA49918@redhat.com>
 <49cc6184-48da-2a45-e50e-13430e14e197@kernel.dk> <20170908220318.GA31120@redhat.com>
 <20170911161647.GA55061@redhat.com> <79287d3a-62e0-912e-dcad-e7ab5297ae34@kernel.dk>
 <20170911211327.GA17344@redhat.com> <ed493525-57c8-6a2c-6be0-bd6b36562f09@kernel.dk>
 <CACVXFVN5-sviq-1fRmQ8pmiq7NXvvMmjfn8Fuy42OkEFrASHSg@mail.gmail.com> <79fdc659-1fc0-2375-7c78-396b3e3b23cc@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <79fdc659-1fc0-2375-7c78-396b3e3b23cc@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Bart Van Assche <Bart.VanAssche@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Sep 15, 2017 at 12:30 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 09/14/2017 09:57 AM, Ming Lei wrote:
>> On Tue, Sep 12, 2017 at 5:27 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>> On 09/11/2017 03:13 PM, Mike Snitzer wrote:
>>>> On Mon, Sep 11 2017 at  4:51pm -0400,
>>>> Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>>> On 09/11/2017 10:16 AM, Mike Snitzer wrote:
>>>>>> Here is v2 that should obviate the need to rename blk_mq_insert_request
>>>>>> (by using bools to control run_queue and async).
>>>>>>
>>>>>> As for inserting directly into dispatch, if that can be done that is
>>>>>> great but I'd prefer to have that be a follow-up optimization.  This
>>>>>> fixes the regression in question, and does so in well-known terms.
>>>>>>
>>>>>> What do you think?
>>>>>
>>>>> I think it looks reasonable. My only concern is the use of the software
>>>>> queues. Depending on the scheduler, they may or may not be used. I'd
>>>>> need to review the code, but my first thought is that this would break
>>>>> if you use blk_mq_insert_request() on a device that is managed by
>>>>> mq-deadline or bfq, for instance. Schedulers are free to use the
>>>>> software queues, but they are also free to ignore them and use internal
>>>>> queuing.
>>>>>
>>>>> Looking at the code, looks like this was changed slightly at some point,
>>>>> we always flush the software queues, if any of them contain requests. So
>>>>> it's probably fine.
>>>>
>>>> OK good, but is that too brittle to rely on? Something that might change
>>>> in the future?
>>>
>>> I'm actually surprised we do flush software queues for that case, since
>>> we don't always have to. So it is a bit of a wart. If we don't have a
>>> scheduler, software queues is where IO goes. If we have a scheduler, the
>>> scheduler has complete control of where to queue IO. Generally, the
>>> scheduler will either utilize the software queues or it won't, there's
>>> nothing in between.
>>>
>>> I know realize I'm an idiot and didn't read it right. So here's the code
>>> in question:
>>>
>>> const bool has_sched_dispatch = e && e->type->ops.mq.dispatch_request;
>>>
>>> [...]
>>>
>>> } else if (!has_sched_dispatch) {
>>>         blk_mq_flush_busy_ctxs(hctx, &rq_list);
>>>         blk_mq_dispatch_rq_list(q, &rq_list);
>>> }
>>>
>>> so we do only enter sw queue flushing, if we don't have a scheduler with
>>> a dispatch_request hook. So now I am really wondering how your patch
>>> could work if the bottom device has bfq or mq-deadline attached?
>>>
>>>>> My earlier suggestion to use just hctx->dispatch for the IO and bypass
>>>>> the software queues completely. The use case for the dispatch list is
>>>>> the same, regardless of whether the device has a scheduler attached or
>>>>> not.
>>>>
>>>> I'm missing how these details relate to the goal of bypassing any
>>>> scheduler that might be attached.  Are you saying the attached elevator
>>>> would still get in the way?
>>>
>>> See above.
>>>
>>>> Looking at blk_mq_sched_insert_request(), submission when an elevator
>>>> isn't attached is exactly what I made blk_mq_insert_request() do
>>>> (which is exactly what it did in the past).
>>>
>>> Right, but that path is only used if we don't have a scheduler attached.
>>> So while the code will use that path IFF a scheduler isn't attached to
>>> that device, your use case will use it for both cases.
>>>
>>>> In the case of DM multipath, nothing else should be submitting IO to
>>>> the device so elevator shouldn't be used -- only interface for
>>>> submitting IO would be blk_mq_insert_request().  So even if a
>>>> scheduler is attached it should be bypassed right?
>>>
>>> The problem is the usage of the sw queue.
>>>
>>> Does the below work for you?
>>>
>>>
>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>> index d709c0e3a2ac..aebe676225e6 100644
>>> --- a/block/blk-core.c
>>> +++ b/block/blk-core.c
>>> @@ -2342,7 +2342,12 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
>>>         if (q->mq_ops) {
>>>                 if (blk_queue_io_stat(q))
>>>                         blk_account_io_start(rq, true);
>>> -               blk_mq_sched_insert_request(rq, false, true, false, false);
>>> +               /*
>>> +                * Since we have a scheduler attached on the top device,
>>> +                * bypass a potential scheduler on the bottom device for
>>> +                * insert.
>>> +                */
>>> +               blk_mq_request_bypass_insert(rq);
>>>                 return BLK_STS_OK;
>>>         }
>>>
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index 3f18cff80050..98a18609755e 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -1401,6 +1401,22 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
>>>         blk_mq_hctx_mark_pending(hctx, ctx);
>>>  }
>>>
>>> +/*
>>> + * Should only be used carefully, when the caller knows we want to
>>> + * bypass a potential IO scheduler on the target device.
>>> + */
>>> +void blk_mq_request_bypass_insert(struct request *rq)
>>> +{
>>> +       struct blk_mq_ctx *ctx = rq->mq_ctx;
>>> +       struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, ctx->cpu);
>>> +
>>> +       spin_lock(&hctx->lock);
>>> +       list_add_tail(&rq->queuelist, &hctx->dispatch);
>>> +       spin_unlock(&hctx->lock);
>>> +
>>> +       blk_mq_run_hw_queue(hctx, false);
>>> +}
>>> +
>>
>> Hello Jens and Mike,
>>
>> This patch sends flush request to ->dispatch directly too, which changes the
>> previous behaviour, is that OK for dm-rq?
>
> That's a good question, I need to look into that. The flush behavior is so
> annoying. Did you make any progress on fixing up the patch you posted the
> other day on treating flushes like any other request?

It has been ready, will post it out later.


-- 
Ming Lei
