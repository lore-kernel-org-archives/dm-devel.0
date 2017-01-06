From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 1/1] block: fix blk_queue_split() resource exhaustion
Date: Fri, 6 Jan 2017 14:52:16 -0500
Message-ID: <20170106195216.GA15583@redhat.com>
References: <1467990243-3531-1-git-send-email-lars.ellenberg@linbit.com>
 <1467990243-3531-2-git-send-email-lars.ellenberg@linbit.com>
 <20160711141042.GY13335@soda.linbit>
 <76d9bf14-d848-4405-8358-3771c0a93d39@profitbricks.com>
 <20161223114553.GP4138@soda.linbit>
 <CA+res+SjL6FrYWMroB-xjBO5gyz9pca6FQCy-arr7+4RQHeJGw@mail.gmail.com>
 <878tqrmmqx.fsf@notabene.neil.brown.name>
 <20170104185046.GA982@redhat.com>
 <alpine.LRH.2.02.1701061139160.13944@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1701061151010.13944@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1701061151010.13944@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: NeilBrown <neilb@suse.com>, Jack Wang <jack.wang.usish@gmail.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>, Michael Wang <yun.wang@profitbricks.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>, linux-block@vger.kernel.org, Takashi Iwai <tiwai@suse.de>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alasdair Kergon <agk@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Keith Busch <keith.busch@intel.com>, device-mapper development <dm-devel@redhat.com>, Shaohua Li <shli@kernel.org>, Kent
List-Id: dm-devel.ids

On Fri, Jan 06 2017 at 12:34pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Fri, 6 Jan 2017, Mikulas Patocka wrote:
> 
> > 
> > 
> > On Wed, 4 Jan 2017, Mike Snitzer wrote:
> > 
> > > On Wed, Jan 04 2017 at 12:12am -0500,
> > > NeilBrown <neilb@suse.com> wrote:
> > > 
> > > > > Suggested-by: NeilBrown <neilb@suse.com>
> > > > > Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> > > > > ---
> > > > >  block/blk-core.c | 20 ++++++++++++++++++++
> > > > >  1 file changed, 20 insertions(+)
> > > > >
> > > > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > > > index 9e3ac56..47ef373 100644
> > > > > --- a/block/blk-core.c
> > > > > +++ b/block/blk-core.c
> > > > > @@ -2138,10 +2138,30 @@ blk_qc_t generic_make_request(struct bio *bio)
> > > > >  		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
> > > > >  
> > > > >  		if (likely(blk_queue_enter(q, __GFP_DIRECT_RECLAIM) == 0)) {
> > > > > +			struct bio_list lower, same, hold;
> > > > > +
> > > > > +			/* Create a fresh bio_list for all subordinate requests */
> > > > > +			bio_list_init(&hold);
> > > > > +			bio_list_merge(&hold, &bio_list_on_stack);
> > > > > +			bio_list_init(&bio_list_on_stack);
> > > > >  
> > > > >  			ret = q->make_request_fn(q, bio);
> > > > >  
> > > > >  			blk_queue_exit(q);
> > > > > +			/* sort new bios into those for a lower level
> > > > > +			 * and those for the same level
> > > > > +			 */
> > > > > +			bio_list_init(&lower);
> > > > > +			bio_list_init(&same);
> > > > > +			while ((bio = bio_list_pop(&bio_list_on_stack)) != NULL)
> > > > > +				if (q == bdev_get_queue(bio->bi_bdev))
> > > > > +					bio_list_add(&same, bio);
> > > > > +				else
> > > > > +					bio_list_add(&lower, bio);
> > > > > +			/* now assemble so we handle the lowest level first */
> > > > > +			bio_list_merge(&bio_list_on_stack, &lower);
> > > > > +			bio_list_merge(&bio_list_on_stack, &same);
> > > > > +			bio_list_merge(&bio_list_on_stack, &hold);
> > > > >  
> > > > >  			bio = bio_list_pop(current->bio_list);
> > > > >  		} else {
> > > > > -- 
> > > > > 2.7.4
> > > 
> > > Mikulas, would you be willing to try the below patch with the
> > > dm-snapshot deadlock scenario and report back on whether it fixes that?
> > > 
> > > Patch below looks to be the same as here:
> > > https://marc.info/?l=linux-raid&m=148232453107685&q=p3
> > > 
> > > Neil and/or others if that isn't the patch that should be tested please
> > > provide a pointer to the latest.
> > > 
> > > Thanks,
> > > Mike
> > 
> > The bad news is that this doesn't fix the snapshot deadlock.
> > 
> > I created a test program for the snapshot deadlock bug (it was originally 
> > created years ago to test for a different bug, so it contains some cruft). 
> > You also need to insert "if (ci->sector_count) msleep(100);" to the end of 
> > __split_and_process_non_flush to make the kernel sleep when splitting the 
> > bio.
> > 
> > And with the above above patch, the snapshot deadlock bug still happens.

That is really unfortunate.  Would be useful to dig in and understand
why.  Because ordering of the IO in generic_make_request() really should
take care of it.

<snip>
 
> Here I post a patch that fixes the snapshot deadlock. On schedule(), it 
> redirects bios on current->bio_list to helper workqueues.

<snip old patch>

That patch is included in the series of changes sequenced at the top of
this git branch:
http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=wip

At the risk of repeating myself: unfortunately it doesn't have a way
forward with the timed offload implementation (which was done to appease
Ming Lei's concern about context switching causing reduced plugging that
results in less efficient IO).
