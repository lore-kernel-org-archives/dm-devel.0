From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [dm-devel] [RFC] block: fix blk_queue_split() resource exhaustion
Date: Fri, 8 Jul 2016 14:52:25 +0200
Message-ID: <20160708125225.GV13335@soda.linbit>
References: <1466583730-28595-1-git-send-email-lars.ellenberg@linbit.com>
 <871t36ggcr.fsf@notabene.neil.brown.name>
 <20160707081616.GH13335@soda.linbit>
 <87vb0hf6fb.fsf@notabene.neil.brown.name>
 <CACVXFVOpY5f4o-hKc+HFsap=a5YY95SGQ-4n33mWPxm=P+gS-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVOpY5f4o-hKc+HFsap=a5YY95SGQ-4n33mWPxm=P+gS-g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: NeilBrown <neilb@suse.com>, linux-block <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Jiri Kosina <jkosina@suse.cz>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, Zheng Liu <gnehzuil.liu@gmail.com>, Keith Busch <keith.busch@intel.com>, Takashi Iwai <tiwai@suse.de>, "open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Shaohua Li <shli@kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Alasdair Kergon <agk@redhat.com>, Roland Kammerer <roland.kammerer@linbit.com>
List-Id: dm-devel.ids

On Fri, Jul 08, 2016 at 07:08:32PM +0800, Ming Lei wrote:
> > So after processing a particular bio, we should then process all the
> > 'child' bios - bios send to underlying devices.  Then the 'sibling'
> > bios, that were split off, and then any remaining parents and ancestors.
> 
> IMHO, that is just what the oneline patch is doing, isn't it?
> 
> | diff --git a/block/blk-core.c b/block/blk-core.c
>  | index 2475b1c7..a5623f6 100644
>  | --- a/block/blk-core.c
>  | +++ b/block/blk-core.c
>  | @@ -2048,7 +2048,7 @@ blk_qc_t generic_make_request(struct bio *bio)
>  |       * should be added at the tail
>  |       */
>  |      if (current->bio_list) {
>  | -            bio_list_add(current->bio_list, bio);
>  | +            bio_list_add_head(current->bio_list, bio);
>  |              goto out;
>  |      }

Almost, but not quite.

As explained earlier, this will re-order.
It will still process bios in "deepest level first" order,
but it will process "sibling" bios in reverse submission order.

Think "very large bio" submitted to a stripe set
with small stripe width/stripe unit size.

So I'd expect this to be a performance hit in some scenarios,
unless the stack at some deeper level does back-merging in its elevator.
(If some driver is not able to merge stuff because of "reverse submission
order" this can easily mean saturating IOPS of the physical device with
small requests, throttling bandwidth to a minimum.)

That's why I mentioned it as "potential easy fix for the deadlock",
but did not suggest it as the proper way to fix this.

If however the powers that be decide that this was a non-issue,
we could use it this way.

	Lars

