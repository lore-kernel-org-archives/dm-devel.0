From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: neutralize blk_insert_cloned_request IO stall regression
 (was: Re: [RFC PATCH] blk-mq: fixup RESTART when queue becomes idle)
Date: Tue, 23 Jan 2018 07:43:37 -0500
Message-ID: <20180123124337.GA24760@redhat.com>
References: <20180118204856.GA31679@redhat.com>
 <1516309128.2676.38.camel@wdc.com>
 <20180118212327.GB31679@redhat.com>
 <1516311554.2676.50.camel@wdc.com>
 <20180118220132.GA20860@redhat.com>
 <1516314012.2676.76.camel@wdc.com>
 <20180123092204.GA39002@redhat.com>
 <20180123105357.GA3344@ming.t460p>
 <20180123121519.GA24681@redhat.com>
 <CACVXFVM=8HB6ctE4+Yeh2NzRUxbokH9az2aVjoc2oS7ya54tiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVM=8HB6ctE4+Yeh2NzRUxbokH9az2aVjoc2oS7ya54tiQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "osandov@fb.com" <osandov@fb.com>
List-Id: dm-devel.ids

On Tue, Jan 23 2018 at  7:17am -0500,
Ming Lei <tom.leiming@gmail.com> wrote:

> On Tue, Jan 23, 2018 at 8:15 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> > On Tue, Jan 23 2018 at  5:53am -0500,
> > Ming Lei <ming.lei@redhat.com> wrote:
> >
> >> Hi Mike,
> >>
> >> On Tue, Jan 23, 2018 at 10:22:04AM +0100, Mike Snitzer wrote:
> >> >
> >> > From: Mike Snitzer <snitzer@redhat.com>
> >> > Date: Tue, 23 Jan 2018 09:40:22 +0100
> >> > Subject: [PATCH] block: neutralize blk_insert_cloned_request IO stall regression
> >> >
> >> > The series of blk-mq changes intended to improve sequential IO
> >> > performace (through improved merging with dm-mapth blk-mq stacked on
> >> > underlying blk-mq device).  Unfortunately these changes have caused
> >> > dm-mpath blk-mq IO stalls when blk_mq_request_issue_directly()'s call to
> >> > q->mq_ops->queue_rq() fails (due to device-specific resource
> >> > unavailability).
> >> >
> >> > Fix this by reverting back to how blk_insert_cloned_request() functioned
> >> > prior to commit 396eaf21ee -- by using blk_mq_request_bypass_insert()
> >> > instead of blk_mq_request_issue_directly().
> >> >
> >> > In the future, this commit should be reverted as the first change in a
> >> > followup series of changes that implements a comprehensive solution to
> >> > allowing an underlying blk-mq queue's resource limitation to trigger the
> >> > upper blk-mq queue to run once that underlying limited resource is
> >> > replenished.
> >> >
> >> > Fixes: 396eaf21ee ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
> >> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> >> > ---
> >> >  block/blk-core.c | 3 ++-
> >> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >> >
> >> > diff --git a/block/blk-core.c b/block/blk-core.c
> >> > index cdae69be68e9..a224f282b4a6 100644
> >> > --- a/block/blk-core.c
> >> > +++ b/block/blk-core.c
> >> > @@ -2520,7 +2520,8 @@ blk_status_t blk_insert_cloned_request(struct request_queue *q, struct request *
> >> >              * bypass a potential scheduler on the bottom device for
> >> >              * insert.
> >> >              */
> >> > -           return blk_mq_request_issue_directly(rq);
> >> > +           blk_mq_request_bypass_insert(rq, true);
> >> > +           return BLK_STS_OK;
> >> >     }
> >>
> >> If this patch is for fixing IO stall on DM, it isn't needed, and actually
> >> it can't fix the IO stall issue.
> >
> > It should "fix it" in conjunction with this:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.16&id=87b7e73546b55f4a3a37d4726daedd9a17a20509
> >
> > (Bart already said as much, I just effectively enabled the equivalent of
> > his reverts)
> 
> If the generic solution is take, Bart's revert isn't needed.

Yes, we need Bart to verify your v2 patch:
https://patchwork.kernel.org/patch/10179945/

Bart please test this tree:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/log/?h=for-next

Please report back with your results (and include details on any changes
you make to the tree, hopefully no changes are needed).

Thanks,
Mike
