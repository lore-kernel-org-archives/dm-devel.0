From: Ming Lei <ming.lei@canonical.com>
Subject: Re: [dm-devel] [RFC] block: fix blk_queue_split() resource exhaustion
Date: Fri, 8 Jul 2016 19:08:32 +0800
Message-ID: <CACVXFVOpY5f4o-hKc+HFsap=a5YY95SGQ-4n33mWPxm=P+gS-g@mail.gmail.com>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <871t36ggcr.fsf@notabene.neil.brown.name> <20160707081616.GH13335@soda.linbit>
 <87vb0hf6fb.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <87vb0hf6fb.fsf@notabene.neil.brown.name>
Sender: linux-bcache-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>, linux-block <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, Takashi Iwai <tiwai@suse.de>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linb>
List-Id: dm-devel.ids

On Fri, Jul 8, 2016 at 6:07 AM, NeilBrown <neilb@suse.com> wrote:
> On Thu, Jul 07 2016, Lars Ellenberg wrote:
>
>> On Thu, Jul 07, 2016 at 03:35:48PM +1000, NeilBrown wrote:
>>> On Wed, Jun 22 2016, Lars Ellenberg wrote:
>>>
>>> > For a long time, generic_make_request() converts recursion into
>>> > iteration by queuing recursive arguments on current->bio_list.
>>> >
>>> > This is convenient for stacking drivers,
>>> > the top-most driver would take the originally submitted bio,
>>> > and re-submit a re-mapped version of it, or one or more clones,
>>> > or one or more new allocated bios to its backend(s). Which
>>> > are then simply processed in turn, and each can again queue
>>> > more "backend-bios" until we reach the bottom of the driver stack,
>>> > and actually dispatch to the real backend device.
>>> >
>>> > Any stacking driver ->make_request_fn() could expect that,
>>> > once it returns, any backend-bios it submitted via recursive calls
>>> > to generic_make_request() would now be processed and dispatched, before
>>> > the current task would call into this driver again.
>>> >
>>> > This is changed by commit
>>> >   54efd50 block: make generic_make_request handle arbitrarily sized bios
>>> >
>>> > Drivers may call blk_queue_split() inside their ->make_request_fn(),
>>> > which may split the current bio into a front-part to be dealt with
>>> > immediately, and a remainder-part, which may need to be split even
>>> > further. That remainder-part will simply also be pushed to
>>> > current->bio_list, and would end up being head-of-queue, in front
>>> > of any backend-bios the current make_request_fn() might submit during
>>> > processing of the fron-part.
>>> >
>>> > Which means the current task would immediately end up back in the same
>>> > make_request_fn() of the same driver again, before any of its backend
>>> > bios have even been processed.
>>> >
>>> > This can lead to resource starvation deadlock.
>>> > Drivers could avoid this by learning to not need blk_queue_split(),
>>> > or by submitting their backend bios in a different context (dedicated
>>> > kernel thread, work_queue context, ...). Or by playing funny re-ordering
>>> > games with entries on current->bio_list.
>>> >
>>> > Instead, I suggest to distinguish between recursive calls to
>>> > generic_make_request(), and pushing back the remainder part in
>>> > blk_queue_split(), by pointing current->bio_lists to a
>>> >    struct recursion_to_iteration_bio_lists {
>>> >            struct bio_list recursion;
>>> >            struct bio_list remainder;
>>> >    }
>>> >
>>> > To have all bios targeted to drivers lower in the stack processed before
>>> > processing the next piece of a bio targeted at the higher levels,
>>> > as long as queued bios resulting from recursion are available,
>>> > they will continue to be processed in FIFO order.
>>> > Pushed back bio-parts resulting from blk_queue_split() will be processed
>>> > in LIFO order, one-by-one, whenever the recursion list becomes empty.
>>>
>>> I really like this change.  It seems to precisely address the problem.
>>> The "problem" being that requests for "this" device are potentially
>>> mixed up with requests from underlying devices.
>>> However I'm not sure it is quite general enough.
>>>
>>> The "remainder" list is a stack of requests aimed at "this" level or
>>> higher, and I think it will always exactly fit that description.
>>> The "recursion" list needs to be a queue of requests aimed at the next
>>> level down, and that doesn't quiet work, because once you start acting
>>> on the first entry in that list, all the rest become "this" level.
>>
>> Uhm, well,
>> that's how it has been since you introduced this back in 2007, d89d879.
>> And it worked.
>
> Just because it "worked", doesn't mean it was "right" :-)
>
>>
>>> I think you can address this by always calling ->make_request_fn with an
>>> empty "recursion", then after the call completes, splice the "recursion"
>>> list that resulted (if any) on top of the "remainder" stack.
>>>
>>> This way, the "remainder" stack is always "requests for lower-level
>>> devices before request for upper level devices" and the "recursion"
>>> queue is always "requests for devices below the current level".
>>
>> Yes, I guess that would work as well,
>> but may need "empirical proof" to check for performance regressions.
>>
>>> I also really *don't* like the idea of punting to a separate thread - it
>>> seems to be just delaying the problem.
>>>
>>> Can you try move the bio_list_init(->recursion) call to just before
>>> the ->make_request_fn() call, and adding
>>>     bio_list_merge_head(->remainder, ->recursion)
>>> just after?
>>> (or something like that) and confirm it makes sense, and works?
>>
>> Sure, will do.
>> I'd suggest this would be a patch on its own though, on top of this one.
>> Because it would change the order in which stacked bios are processed
>> wrt the way it used to be since 2007 (my suggestion as is does not).
>
> Yes, because I think the original order is wrong, as you have helped me
> to see.
> Before I introduced the recursion limiting, requests were handled as an
> in-order tree walk.  The code I wrote tried to preserve that but didn't
> for several reasons.  I think we need to restore the original in-order
> walk because it makes the most sense.

> So after processing a particular bio, we should then process all the
> 'child' bios - bios send to underlying devices.  Then the 'sibling'
> bios, that were split off, and then any remaining parents and ancestors.

IMHO, that is just what the oneline patch is doing, isn't it?

| diff --git a/block/blk-core.c b/block/blk-core.c
 | index 2475b1c7..a5623f6 100644
 | --- a/block/blk-core.c
 | +++ b/block/blk-core.c
 | @@ -2048,7 +2048,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 |       * should be added at the tail
 |       */
 |      if (current->bio_list) {
 | -            bio_list_add(current->bio_list, bio);
 | +            bio_list_add_head(current->bio_list, bio);
 |              goto out;
 |      }

Thanks,

>
> You patch created the right structures for doing this, my proposal took
> it a step closer, but now after more careful analysis I don't think it
> is quite right.
> With my previous proposal (and you latest patch - thanks!) requests for
> "this" level are stacked, but they should be queued.
> If a make_request_fn only ever submits one request for this level and
> zero or more lower levels, then the difference between a queue and a
> stack is irrelevant.  If it submited more that one, a stack would cause
> them to be handled in the reverse order.
>
> To make the patch "perfect", and maybe even more elegant we could treat
> ->remainder and ->recursion more alike.
> i.e.:
>   - generic make request has a private "stack" of requests.
>   - before calling ->make_request_fn(), both ->remainder and ->recursion
>     are initialised
>   - after ->make_request_fn(), ->remainder are spliced in to top of
>     'stack', then ->recursion is spliced onto that.
>   - If stack is not empty, the top request is popped and we loop to top.
>
> This reliably follows in-order execution, and handles siblings correctly
> (in submitted order) if/when a request splits off multiple siblings.
>
>>
>> Which may change performance metrics.
>> It may even improve some of them,
>> or maybe it does nothing, but we don't know.
>
> I think that as long a requests are submitted in the order they are
> created at each level there is no reason to expect performance
> regressions.
> All we are doing is changing the ordering between requests generated at
> different levels, and I think we are restoring a more natural order.
>
> Thanks,
> NeilBrown
