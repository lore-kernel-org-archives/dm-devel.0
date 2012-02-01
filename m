From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH] block: add missing block_bio_complete() tracepoint
Date: Wed, 01 Feb 2012 11:18:33 +0900
Message-ID: <4F28A0F9.9070603@gmail.com>
References: <1327830093-12130-1-git-send-email-namhyung@gmail.com> <4F263B01.4050103@gmail.com> <20120130170548.GA3355@google.com> <4F278A78.8080300@gmail.com> <CAOS58YP1F6_yBxRArcP4oyzAJVArLJB-ckjdXU35U1SNwi75XQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOS58YP1F6_yBxRArcP4oyzAJVArLJB-ckjdXU35U1SNwi75XQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

2012-01-31 7:39 PM, Tejun Heo wrote:
> Hello,
>
> On Mon, Jan 30, 2012 at 10:30 PM, Namhyung Kim<namhyung@gmail.com>  wrote:
>> Right, but the point is it could make a NULL pointer dereference during
>> evaluation of the argument of the TP AFAICS. I'm not sure about the TP
>> implementation though, I think I was wrong - T_E_C() cannot protect us from
>> it because it happens just before jumping to the TP, right?
>>
>> So I think we need a conditional jump (with the "likely" annotation) for
>> this even when the TP is disabled.
>
> Hmmm... still not following. Where the said NULL dereference happen?
> TEC conditional is equivalent to "if (COND) TP;".  If you don't use
> TEC, it'll be "if (COND) if (TP enabled) TP;".  With TEC, it will be
> "if (TP enabled) if (COND) TP;".  There's no other difference.
>
> Thanks.
>

I've made a quick investigation on TP implementation, and finally 
figured out what I was wrong - I thought the COND would be checkd in a 
probe, but it's not. Thanks for pointing it out.

However, for some reason, it seems gcc generated code that evaluates the 
arguments - bdev_get_queue() in this case - before checking the COND. 
Simple test module below caused a NULL pointer dereference when I used 
TRACE_EVENT_CONDITION(), but not for conditional jump:

#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/bio.h>

static int __init init_mod(void)
{
         struct bio *bio = bio_alloc(GFP_KERNEL, 0);
         bio_endio(bio, 0);
         bio_put(bio);
         return 0;
}

static void __exit exit_mod(void)
{
}

module_init(init_mod);
module_exit(exit_mod);


Thanks,
Namhyung
