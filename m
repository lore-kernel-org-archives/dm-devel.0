From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Tue, 31 Jan 2012 15:30:16 +0900
Message-ID: <4F278A78.8080300@gmail.com>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com> <4F263B01.4050103@gmail.com> <20120130170548.GA3355@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120130170548.GA3355@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

2012-01-31 2:05 AM, Tejun Heo wrote:
> On Mon, Jan 30, 2012 at 03:38:57PM +0900, Namhyung Kim wrote:
>> 2012-01-29 6:41 PM, Namhyung Kim wrote:
>>> The block_bio_complete() TP has been missed so long, so that bio-based
>>> drivers haven't been able to trace its IO behavior. Add it.
>>>
>>> In some rare cases, such as loop_switch, @bio->bi_bdev can be NULL.
>>> Thus convert it to TRACE_EVENT_CONDITION() as Steven suggested.
>>>
>>
>> Now I see that it seems TRACE_EVENT_CONDITION() can protect event
>> tracing from such condition, but what about other users of the TP
>> like blktrace? I think it'll still get NULL pointer dereference on
>> bdev_get_queue() after the change, right? If so, convert to T_E_C()
>> looks meaningless IMHO. Do I miss something?
>
> Not really following, but the whole point of using
> TRACE_EVENT_CONDITION() is avoiding the conditional jump when the TP
> is disabled.  Whether the TP users need to test again / more isn't too
> important.
>
> Thanks.
>

Right, but the point is it could make a NULL pointer dereference during 
evaluation of the argument of the TP AFAICS. I'm not sure about the TP 
implementation though, I think I was wrong - T_E_C() cannot protect us 
from it because it happens just before jumping to the TP, right?

So I think we need a conditional jump (with the "likely" annotation) for 
this even when the TP is disabled.

Thanks,
Namhyung
