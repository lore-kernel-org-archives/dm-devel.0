From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 1/1] block: fix blk_queue_split() resource
	exhaustion
Date: Wed, 4 Jan 2017 13:50:46 -0500
Message-ID: <20170104185046.GA982@redhat.com>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com>
	<1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com>
	<20160711141042.GY13335@soda.linbit>
	<76d9bf14-d848-4405-8358-3771c0a93d39@profitbricks.com>
	<20161223114553.GP4138@soda.linbit>
	<CA+res+SjL6FrYWMroB-xjBO5gyz9pca6FQCy-arr7+4RQHeJGw@mail.gmail.com>
	<878tqrmmqx.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <878tqrmmqx.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ming Lei <ming.lei@canonical.com>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Jack Wang <jack.wang.usish@gmail.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>, Michael Wang <yun.wang@profitbricks.com>, Takashi Iwai <tiwai@suse.de>, Ingo Molnar <mingo@redhat.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, linux-block@vger.kernel.org, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org, Lars
List-Id: dm-devel.ids

On Wed, Jan 04 2017 at 12:12am -0500,
NeilBrown <neilb@suse.com> wrote:

> On Tue, Jan 03 2017, Jack Wang wrote:
> 
> > 2016-12-23 12:45 GMT+01:00 Lars Ellenberg <lars.ellenberg@linbit.com>:
> >> On Fri, Dec 23, 2016 at 09:49:53AM +0100, Michael Wang wrote:
> >>> Dear Maintainers
> >>>
> >>> I'd like to ask for the status of this patch since we hit the
> >>> issue too during our testing on md raid1.
> >>>
> >>> Split remainder bio_A was queued ahead, following by bio_B for
> >>> lower device, at this moment raid start freezing, the loop take
> >>> out bio_A firstly and deliver it, which will hung since raid is
> >>> freezing, while the freezing never end since it waiting for
> >>> bio_B to finish, and bio_B is still on the queue, waiting for
> >>> bio_A to finish...
> >>>
> >>> We're looking for a good solution and we found this patch
> >>> already progressed a lot, but we can't find it on linux-next,
> >>> so we'd like to ask are we still planning to have this fix
> >>> in upstream?
> >>
> >> I don't see why not, I'd even like to have it in older kernels,
> >> but did not have the time and energy to push it.
> >>
> >> Thanks for the bump.
> >>
> >>         Lars
> >>
> > Hi folks,
> >
> > As Michael mentioned, we hit a bug this patch is trying to fix.
> > Neil suggested another way to fix it.  I attached below.
> > I personal prefer Neil's version as it's less code change, and straight forward.
> >
> > Could you share your comments, we can get one fix into mainline.
> >
> > Thanks,
> > Jinpu
> > From 69a4829a55503e496ce9c730d2c8e3dd8a08874a Mon Sep 17 00:00:00 2001
> > From: NeilBrown <neilb@suse.com>
> > Date: Wed, 14 Dec 2016 16:55:52 +0100
> > Subject: [PATCH] block: fix deadlock between freeze_array() and wait_barrier()
> >
> > When we call wait_barrier, we might have some bios waiting
> > in current->bio_list, which prevents the array_freeze call to
> > complete. Those can only be internal READs, which have already
> > passed the wait_barrier call (thus incrementing nr_pending), but
> > still were not submitted to the lower level, due to generic_make_request
> > logic to avoid recursive calls. In such case, we have a deadlock:
> > - array_frozen is already set to 1, so wait_barrier unconditionally waits, so
> > - internal READ bios will not be submitted, thus freeze_array will
> > never completes.
> >
> > To fix this, modify generic_make_request to always sort bio_list_on_stack
> > first with lowest level, then higher, until same level.
> >
> > Sent to linux-raid mail list:
> > https://marc.info/?l=linux-raid&m=148232453107685&w=2
> >
> 
> This should probably also have
> 
>   Inspired-by: Lars Ellenberg <lars.ellenberg@linbit.com>
> 
> or something that, as I was building on Lars' ideas when I wrote this.
> 
> It would also be worth noting in the description that this addresses
> issues with dm and drbd as well as md.

I never saw this patch but certainly like the relative simplicity of the
solution when compared with other approaches taken, e.g. (5 topmost
commits on this branch):
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip

> In fact, I think that with this patch in place, much of the need for the
> rescue_workqueue won't exist any more.  I cannot promise it can be
> removed completely, but it should be to hard to make it optional and
> only enabled for those few block devices that will still need it.
> The rescuer should only be needed for a bioset which can be allocated
> From twice in the one call the ->make_request_fn.  This would include
> raid0 for example, though raid0_make_reqest could be re-written to not
> use a loop and to just call generic_make_request(bio) if bio != split.

Mikulas, would you be willing to try the below patch with the
dm-snapshot deadlock scenario and report back on whether it fixes that?

Patch below looks to be the same as here:
https://marc.info/?l=linux-raid&m=148232453107685&q=p3

Neil and/or others if that isn't the patch that should be tested please
provide a pointer to the latest.

Thanks,
Mike

> > Suggested-by: NeilBrown <neilb@suse.com>
> > Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> > ---
> >  block/blk-core.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> >
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 9e3ac56..47ef373 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -2138,10 +2138,30 @@ blk_qc_t generic_make_request(struct bio *bio)
> >  		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> >  
> >  		if (likely(blk_queue_enter(q, __GFP_DIRECT_RECLAIM) == 0)) {
> > +			struct bio_list lower, same, hold;
> > +
> > +			/* Create a fresh bio_list for all subordinate requests */
> > +			bio_list_init(&hold);
> > +			bio_list_merge(&hold, &bio_list_on_stack);
> > +			bio_list_init(&bio_list_on_stack);
> >  
> >  			ret = q->make_request_fn(q, bio);
> >  
> >  			blk_queue_exit(q);
> > +			/* sort new bios into those for a lower level
> > +			 * and those for the same level
> > +			 */
> > +			bio_list_init(&lower);
> > +			bio_list_init(&same);
> > +			while ((bio = bio_list_pop(&bio_list_on_stack)) != NULL)
> > +				if (q == bdev_get_queue(bio->bi_bdev))
> > +					bio_list_add(&same, bio);
> > +				else
> > +					bio_list_add(&lower, bio);
> > +			/* now assemble so we handle the lowest level first */
> > +			bio_list_merge(&bio_list_on_stack, &lower);
> > +			bio_list_merge(&bio_list_on_stack, &same);
> > +			bio_list_merge(&bio_list_on_stack, &hold);
> >  
> >  			bio = bio_list_pop(current->bio_list);
> >  		} else {
> > -- 
> > 2.7.4
