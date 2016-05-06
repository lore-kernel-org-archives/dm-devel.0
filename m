From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/5] block: make bio_inc_remaining()
 interface accessible again
Date: Fri, 6 May 2016 11:57:15 -0400
Message-ID: <20160506155715.GB672@redhat.com>
References: <1462463665-85312-1-git-send-email-snitzer@redhat.com>
	<1462463665-85312-3-git-send-email-snitzer@redhat.com>
	<20160506152535.GA6738@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20160506152535.GA6738@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, May 06 2016 at 11:25am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> On Thu, May 05, 2016 at 11:54:22AM -0400, Mike Snitzer wrote:
> > Commit 326e1dbb57 ("block: remove management of bi_remaining when
> > restoring original bi_end_io") made bio_inc_remaining() private to bio.c
> > because the only use-case that made sense was confined to the
> > bio_chain() interface.
> > 
> > Since that time DM thinp went on to use bio_chain() in its relatively
> > complex implementation of async discard support.  That implementation,
> > even when converted over to use the new async __blkdev_issue_discard()
> > interface, depends on deferred completion of the original discard bio --
> > which is most appropriately implemented using bio_inc_remaining().
> 
> Can you explain that code flow to me?  I still fail to why exactly
> dm-thinp (and only dm-thinp) needs this.  Maybe start by pointing me
> to the additional bio_endio that pairs with the bio_inc_remaining
> call.

If you look at the latest code here:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-4.7

dm-thin.c:break_up_discard_bio()'s bio_inc_remaining() is paired with
dm-thin.c:end_discard()'s bio_endio()

But the flow is:

-> process_discard_cell_passdown
   -> break_up_discard_bio (per-mapping reference taken on original discard bio)
   -> bio_endio(original discard bio) -- cleanest place to complete
      it.. but doing so here requires extra references on that discard
      bio because we must wait for the N mappings and associated
      sub-discard bios to be chained, issued, and completed

... wait for associated sub-discard mappings to quiesce and become "prepared"...

-> process_prepared_discard_passdown (bio-chains aren't constructed until here)
   -> passdown_double_checking_shared_status (iterates over each mappings' subset of the original discard)
      -> __blkdev_issue_discard
      -> bio_endio (per-mapping reference, taken in break_up_discard_bio, is dropped)

> > All said, bio_inc_remaining() should really only be used in conjunction
> > with bio_chain().  It isn't intended for generic bio reference counting.
> 
> It's obviously used outside bio_chain in dm-thinp, so this sentence
> doesn't make too much sense to me.

It is used in conjunction with supporting thinp's use of bio_chain(),
via __blkdev_issue_discard, but yeah I can see why you think they aren't
related.
