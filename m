From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] block: add blktrace C events for bio-based drivers
Date: Tue, 17 Jan 2017 17:39:06 -0500
Message-ID: <x49lgu9s451.fsf@segfault.boston.devel.redhat.com>
References: <x49ziips61y.fsf@segfault.boston.devel.redhat.com>
        <f3044f42-3134-c577-068f-bd2750528b32@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <f3044f42-3134-c577-068f-bd2750528b32@kernel.dk> (Jens Axboe's
        message of "Tue, 17 Jan 2017 14:07:32 -0800")
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, shli@kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
List-Id: dm-devel.ids

Jens Axboe <axboe@kernel.dk> writes:

> On 01/17/2017 01:57 PM, Jeff Moyer wrote:
>> Only a few bio-based drivers actually generate blktrace completion
>> (C) events.  Instead of changing all bio-based drivers to call
>> trace_block_bio_complete, move the tracing to bio_complete, and remove
>> the explicit tracing from the few drivers that actually do it.  After
>> this patch, there is exactly one caller of trace_block_bio_complete
>> and one caller of trace_block_rq_complete.  More importantly, all
>> bio-based drivers now generate C events, which is useful for
>> performance analysis.
>
> I like the change, hate the naming. I'd prefer one of two things:
>
> - Add bio_endio_complete() instead. That name sucks too, the
>   important part is flipping the __name() to have a trace
>   version instead.

I had also considered bio_endio_notrace().

> - Mark the bio as trace completed, and keep the naming. Since
>   it's only off the completion path, that can be just marking
>   the bi_flags non-atomically.
>
> I probably prefer the latter.

Hmm, okay.  I'll take a crack at that.

Thanks!
Jeff
