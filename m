From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH v2] blk: improve order of bio handling in
 generic_make_request()
Date: Fri, 10 Mar 2017 19:51:03 +0100
Message-ID: <20170310185103.GA15851@soda.linbit>
References: <87lgsjj9w8.fsf@notabene.neil.brown.name>
 <a674456d-fb93-437e-c50e-195e7a035ba4@kernel.dk>
 <87r328j00i.fsf@notabene.neil.brown.name>
 <87d1dphhuy.fsf@notabene.neil.brown.name>
 <58be6551-4aa7-72ee-1616-a1545606d029@kernel.dk>
 <87varhg14d.fsf@notabene.neil.brown.name>
 <CANr6vz8EbRWXq7igGCzRy9JC1Nt=MMma0h8M6nxHQtwiMDa5aQ@mail.gmail.com>
 <20170310143822.GA23879@redhat.com>
 <alpine.LRH.2.02.1703100953280.9054@file01.intranet.prod.int.rdu2.redhat.com>
 <153a6cff-c553-0d18-e15b-4f3defc3a42b@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <153a6cff-c553-0d18-e15b-4f3defc3a42b@profitbricks.com>
Sender: linux-block-owner@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>, NeilBrown <neilb@suse.com>, Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Pavel Machek <pavel@ucw.cz>, linux-raid@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Fri, Mar 10, 2017 at 04:07:58PM +0100, Jack Wang wrote:
> On 10.03.2017 15:55, Mikulas Patocka wrote:
> > On Fri, 10 Mar 2017, Mike Snitzer wrote:
> >> On Fri, Mar 10 2017 at  7:34am -0500,
> >> Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
> >>
> >>>> --- a/block/blk-core.c
> >>>> +++ b/block/blk-core.c
> >>>> @@ -1975,7 +1975,14 @@ generic_make_request_checks(struct bio *bio)
> >>>>   */
> >>>>  blk_qc_t generic_make_request(struct bio *bio)
> >>>>  {
> >>>> -       struct bio_list bio_list_on_stack;
> >>>> +       /*
> >>>> +        * bio_list_on_stack[0] contains bios submitted by the current
> >>>> +        * make_request_fn.
> >>>> +        * bio_list_on_stack[1] contains bios that were submitted before
> >>>> +        * the current make_request_fn, but that haven't been processed
> >>>> +        * yet.
> >>>> +        */
> >>>> +       struct bio_list bio_list_on_stack[2];
> >>>>         blk_qc_t ret = BLK_QC_T_NONE;
> >>>
> >>> May I suggest that, if you intend to assign something that is not a
> >>> plain &(struct bio_list), but a &(struct bio_list[2]),
> >>> you change the task member so it is renamed (current->bio_list vs
> >>> current->bio_lists, plural, is what I did last year).
> >>> Or you will break external modules, silently, and horribly (or,
> >>> rather, they won't notice, but break the kernel).
> >>> Examples of such modules would be DRBD, ZFS, quite possibly others.

> > It's better to make external modules not compile than to silently 
> > introduce bugs in them. So yes, I would rename that.
> > 
> > Mikulas
> 
> Agree, better rename current->bio_list to current->bio_lists
>
> Regards,
> Jack

Thank you.

(I don't know if some one does, but...)
Thing is: *IF* some external thing messes with
current->bio_list in "interesting" ways, and not just the
"I don't care, one level of real recursion fixes this for me"
pattern of
	struct bio_list *tmp = current->bio_list;
	current->bio_list = NULL;
	submit_bio()
	current->bio_list = tmp;
you get a chance of stack corruption,
without even as much as a compiler warning.

Which is why I wrote https://lkml.org/lkml/2016/7/8/469
...

Instead, I suggest to distinguish between recursive calls to
generic_make_request(), and pushing back the remainder part in
blk_queue_split(), by pointing current->bio_lists to a
	struct recursion_to_iteration_bio_lists {
		struct bio_list recursion;
		struct bio_list queue;
	}

By providing each q->make_request_fn() with an empty "recursion"
bio_list, then merging any recursively submitted bios to the
head of the "queue" list, we can make the recursion-to-iteration
logic in generic_make_request() process deepest level bios first,
and "sibling" bios of the same level in "natural" order.

...

Cheers,

	Lars
