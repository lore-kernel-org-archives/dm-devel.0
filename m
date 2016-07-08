From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [dm-devel] [RFC] block: fix blk_queue_split() resource	exhaustion
Date: Fri, 8 Jul 2016 15:00:35 +0200
Message-ID: <20160708130035.GW13335@soda.linbit>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <871t36ggcr.fsf@notabene.neil.brown.name>
 <20160707081616.GH13335@soda.linbit>
 <87vb0hf6fb.fsf@notabene.neil.brown.name>
 <20160708080219.GT13335@soda.linbit>
 <877fcwfoyv.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877fcwfoyv.fsf@notabene.neil.brown.name>
Sender: linux-bcache-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, linux-bcache@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

On Fri, Jul 08, 2016 at 07:39:36PM +1000, NeilBrown wrote:
> >> To make the patch "perfect", and maybe even more elegant we could treat
> >> ->remainder and ->recursion more alike.
> >> i.e.:
> >>   - generic make request has a private "stack" of requests.
> >>   - before calling ->make_request_fn(), both ->remainder and ->recursion
> >>     are initialised
> >>   - after ->make_request_fn(), ->remainder are spliced in to top of
> >>     'stack', then ->recursion is spliced onto that.
> >>   - If stack is not empty, the top request is popped and we loop to top.
> >> 
> >> This reliably follows in-order execution, and handles siblings correctly
> >> (in submitted order) if/when a request splits off multiple siblings.
> >
> > The only splitting that creates siblings on the current level
> > is blk_queue_split(), which splits the current bio into
> > "front piece" and "remainder", already processed in this order.
> 
> Yes.
> I imagine that a driver *could* split a bio into three parts with a
> single allocation, but I cannot actually see any point in doing it.  So
> I was over-complicating things.
> 
> >
> > Anything else creating "siblings" is not creating siblings for the
> > current layer, but for the next deeper layer, which are queue on
> > "recursion" and also processed in the order they have been generated.
> >
> >> I think that as long a requests are submitted in the order they are
> >> created at each level there is no reason to expect performance
> >> regressions.
> >> All we are doing is changing the ordering between requests generated at
> >> different levels, and I think we are restoring a more natural order.
> >
> > I believe both patches combined are doing exactly this already.
> > I could rename .remainder to .todo or .incoming, though.
> 
> :-)  neither "remainder" or "recursion" seem like brilliant names to me,
> but I don't have anything better to suggest.  Naming is hard!
> As long as a comment explains the name clearly I could cope with X and Y.

...

> I think we just might be in violent agreement.

I thought so, too :-)

Should I merge both patches,
rename to ".queue" and ".tmp",
and submit for inclusion?

    Lars Ellenberg
