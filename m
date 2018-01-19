From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] dm rq: Avoid that request processing stalls sporadically
Date: Thu, 18 Jan 2018 17:24:29 -0700
Message-ID: <040c195c-732e-70e8-3a54-89c5939e815c@kernel.dk>
References: <20180118163707.11825-1-bart.vanassche@wdc.com>
 <20180119001136.GA4712@ming.t460p> <1516320863.2676.104.camel@wdc.com>
 <20180119001834.GB4712@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180119001834.GB4712@ming.t460p>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>
List-Id: dm-devel.ids

On 1/18/18 5:18 PM, Ming Lei wrote:
> On Fri, Jan 19, 2018 at 12:14:24AM +0000, Bart Van Assche wrote:
>> On Fri, 2018-01-19 at 08:11 +0800, Ming Lei wrote:
>>> On Thu, Jan 18, 2018 at 08:37:07AM -0800, Bart Van Assche wrote:
>>>> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
>>>> index f16096af879a..c59c59cfd2a5 100644
>>>> --- a/drivers/md/dm-rq.c
>>>> +++ b/drivers/md/dm-rq.c
>>>> @@ -761,6 +761,7 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
>>>>  		/* Undo dm_start_request() before requeuing */
>>>>  		rq_end_stats(md, rq);
>>>>  		rq_completed(md, rq_data_dir(rq), false);
>>>> +		blk_mq_delay_run_hw_queue(hctx, 100/*ms*/);
>>>>  		return BLK_STS_RESOURCE;
>>>>  	}
>>>>  
>>>
>>> Nak.
>>
>> This patch fixes a regression that was introduced by you. You should know
>> that regressions are not acceptable. If you don't agree with this patch,
>> please fix the root cause.
> 
> Yesterday I sent a patch, did you test that?

That patch isn't going to be of much help. It might prevent you from
completely stalling, but it might take you tens of seconds to get there.

On top of that, it's a rolling timer that gets added when IO is queued,
and re-added if IO is pending when it fires. If the latter case is not
true, then it won't get armed again. So if IO fails to queue without
any other IO pending, you're pretty much in the same situation as if
you marked the queue as restart. Nobody is going to be noticing
either of those conditions.

-- 
Jens Axboe
