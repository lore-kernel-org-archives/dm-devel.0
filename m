From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] block: add blktrace C events for bio-based
	drivers
Date: Wed, 18 Jan 2017 11:01:46 -0500
Message-ID: <x49ziiol5lh.fsf@segfault.boston.devel.redhat.com>
References: <x49ziips61y.fsf@segfault.boston.devel.redhat.com>
	<f3044f42-3134-c577-068f-bd2750528b32@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <f3044f42-3134-c577-068f-bd2750528b32@kernel.dk> (Jens Axboe's
	message of "Tue, 17 Jan 2017 14:07:32 -0800")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-raid@vger.kernel.org, snitzer@redhat.com, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, shli@kernel.org, hch@lst.de, agk@redhat.com
List-Id: dm-devel.ids

Hi, Jens,

Jens Axboe <axboe@kernel.dk> writes:

> I like the change, hate the naming. I'd prefer one of two things:
>
> - Add bio_endio_complete() instead. That name sucks too, the
>   important part is flipping the __name() to have a trace
>   version instead.

ITYM a notrace version.  By default, we want tracing for bio_endio.  The
only callers that need the inverse of that are in the request-based
path, and there are only 2 of them.

> - Mark the bio as trace completed, and keep the naming. Since
>   it's only off the completion path, that can be just marking
>   the bi_flags non-atomically.

One issue with this is in generic_make_request_checks, where we can call
bio_endio without having called trace_block_bio_queue (so you could get
a C event with no corresponding Q).  To address that, we could make the
flag indicate that trace_block_bio_queue was performed, and clear it in
bio_complete, like so:

	if (test_and_clear_bit(BIO_QUEUE_TRACED, &bio->bi_flags))
		trace_block_bio_complete(...);

That would solve the problem of duplicate completions, but requires
setting the flag in the submission path and clearing it in the
completion path.  I think the former can be done with just a
bio_set_flag (i.e. non-atomic), right?  Of course, where to stick that
bio_set_flag call is another bike-shedding discussion waiting to happen
(i.e. does it go in the tracepoint itself?).

Alternatively, we could set the trace_completed flag in the paths where
we end I/O without having done the trace_block_bio_queue, but that seems
way uglier to me.

Can you think of any other options?  If we're choosing from the above,
my preference is for adding the bio_endio_notrace(), since it's so much
simpler.

Cheers,
Jeff
