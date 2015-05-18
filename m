From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH for-4.2 04/14] block: factor out
 blkdev_issue_discard_async
Date: Mon, 18 May 2015 09:32:23 -0400
Message-ID: <20150518133223.GC13998@redhat.com>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
 <1431637512-64245-5-git-send-email-snitzer@redhat.com>
 <20150518082756.GB5439@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150518082756.GB5439@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, Joe Thornber <ejt@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon, May 18 2015 at  4:27am -0400,
Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, May 14, 2015 at 05:05:02PM -0400, Mike Snitzer wrote:
> > From: Joe Thornber <ejt@redhat.com>
> > 
> > Useful for callers who wish to manage the async completion of discard(s)
> > without explicitly blocking waiting for completion.
> > 
> > blkdev_issue_discard() is updated to call blkdev_issue_discard_async()
> > and DM thinp will make use of blkdev_issue_discard_async() in the
> > upcoming "dm thin: range discard support" commit.
> 
> I think this is the wrong level of interface.  I think dm should just
> submit the bios directly, which will also allow it to use bio_chain
> properly instead of needing the inc_remaining hack.  Instead export
> helpers that properly split up the discard chunk sectors without
> touching the bio itself.  And with bio split on demand work even
> that will hopefully go away soon.

The proposed blkdev_issue_discard_async interface allows DM (or any
caller) to not have to concern itself with how discard(s) gets issued.

It leaves all the details of how large a discard can be, etc to block
core.  The entire point of doing things this way is to _not_ pollute DM
with code that breaks up a discard into N bios based on the discard
limits of the underlying device.

What you're suggesting sounds a lot like having DM open code
blkdev_issue_discard() -- blkdev_issue_discard_async() was engineered to
avoid that completely.

I hope we can reach consensus on this because as it stands I know Jens
will be less inclined to take this blkdev_issue_discard_async() change
given your early disapproval.  Which basically pretty much screws me up
for the coming merge window.. I'm OK with that (and exploring
alternatives) but I _really_ hope you've explored this carefully (not
getting that vibe yet given your suggestion appears to be "open code all
of blkdev_issue_discard in DM").

Mike
