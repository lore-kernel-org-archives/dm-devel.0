From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: block: fix blk_queue_split() resource exhaustion
Date: Fri, 8 Jul 2016 09:05:51 -0400
Message-ID: <20160708130550.GB9196@redhat.com>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <871t36ggcr.fsf@notabene.neil.brown.name>
 <20160707081616.GH13335@soda.linbit>
 <87vb0hf6fb.fsf@notabene.neil.brown.name>
 <CACVXFVOpY5f4o-hKc+HFsap=a5YY95SGQ-4n33mWPxm=P+gS-g@mail.gmail.com>
 <20160708125225.GV13335@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160708125225.GV13335@soda.linbit>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Ming Lei <ming.lei@canonical.com>, NeilBrown <neilb@suse.com>, linux-block <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, Takashi Iwai <tiwai@suse.de>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

On Fri, Jul 08 2016 at  8:52am -0400,
Lars Ellenberg <lars.ellenberg@linbit.com> wrote:

> On Fri, Jul 08, 2016 at 07:08:32PM +0800, Ming Lei wrote:
> > > So after processing a particular bio, we should then process all the
> > > 'child' bios - bios send to underlying devices.  Then the 'sibling'
> > > bios, that were split off, and then any remaining parents and ancestors.
> > 
> > IMHO, that is just what the oneline patch is doing, isn't it?
> > 
> > | diff --git a/block/blk-core.c b/block/blk-core.c
> >  | index 2475b1c7..a5623f6 100644
> >  | --- a/block/blk-core.c
> >  | +++ b/block/blk-core.c
> >  | @@ -2048,7 +2048,7 @@ blk_qc_t generic_make_request(struct bio *bio)
> >  |       * should be added at the tail
> >  |       */
> >  |      if (current->bio_list) {
> >  | -            bio_list_add(current->bio_list, bio);
> >  | +            bio_list_add_head(current->bio_list, bio);
> >  |              goto out;
> >  |      }
> 
> Almost, but not quite.
> 
> As explained earlier, this will re-order.
> It will still process bios in "deepest level first" order,
> but it will process "sibling" bios in reverse submission order.
> 
> Think "very large bio" submitted to a stripe set
> with small stripe width/stripe unit size.
> 
> So I'd expect this to be a performance hit in some scenarios,
> unless the stack at some deeper level does back-merging in its elevator.
> (If some driver is not able to merge stuff because of "reverse submission
> order" this can easily mean saturating IOPS of the physical device with
> small requests, throttling bandwidth to a minimum.)
> 
> That's why I mentioned it as "potential easy fix for the deadlock",
> but did not suggest it as the proper way to fix this.
> 
> If however the powers that be decide that this was a non-issue,
> we could use it this way.

No, we cannot do this.  With blk-mq it doesn't have any of the more
elaborate IO scheduling that request_fn request_queues have.  We should
not be knowingly mangling the order of IO with the thought that some
other layer will fix it up.

I think it best for you to rebase your work (against jens' for-4.8/core)
into a single coherent patch and resubmit for 4.8 inclusion.  I really
don't see a huge benefit to keeping neilb's suggestion split out -- but
if you or others do that's fine.

The only concern I have relative to DM is: DM doesn't use
blk_queue_split, so will it need to open-code setting
recursion/remainder in order to ensure forward progress?  neilb seemed
to think the rework in generic_make_request would "just work" for the
dm-snapshot deadlock case though so maybe this isn't a valid
concern... unfortunately we don't have a quick reproducer for that
dm-snapshot issue so it'll take a bit to prove.

Mike
