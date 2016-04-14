From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC v2 PATCH 05/10] dm thin: add methods to set and get
 reserved space
Date: Thu, 14 Apr 2016 16:18:12 -0400
Message-ID: <20160414201812.GA14466@redhat.com>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
 <1460479373-63317-6-git-send-email-bfoster@redhat.com>
 <20160413174442.GD18517@birch.djwong.org>
 <20160413183352.GB2775@bfoster.bfoster>
 <20160413204117.GA6870@bfoster.bfoster>
 <20160414151014.GA13074@redhat.com>
 <20160414162344.GG20696@bfoster.bfoster>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160414162344.GG20696@bfoster.bfoster>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Brian Foster <bfoster@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Joe Thornber <ejt@redhat.com>, xfs@oss.sgi.com, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

On Thu, Apr 14 2016 at 12:23pm -0400,
Brian Foster <bfoster@redhat.com> wrote:

> On Thu, Apr 14, 2016 at 11:10:14AM -0400, Mike Snitzer wrote:
> > 
> > Brian, I need to circle back with you to understand why XFS even needs
> > reservation as opposed to just using something like fallocate (which
> > would provision the space before you actually initiate the IO that would
> > use it).  But we can discuss that in person and then report back to the
> > list if it makes it easier...
> >  
> 
> The primary reason is delayed allocation. Buffered writes to the fs copy
> data into the pagecache before the physical space has been allocated.
> E.g., we only modify the free blocks counters at write() time in order
> to guarantee that we have space somewhere in the fs. The physical
> extents aren't allocated until later at writeback time.
> 
> So reservation from dm-thin basically extends the mechanism to also
> guarantee that the underlying thin volume has space for writes that
> we've received but haven't written back yet.

OK, so even if/when we have bdev_fallocate support that would be more
rigid than XFS would like.

As you've said, the XFS established reservation is larger than is really
needed.  Whereas regularly provisioning more than is actually needed is
a recipe for disaster.

> > > > > > +		if (error)
> > > > > > +			return error;
> > > > > > +
> > > > > > +		error = dm_thin_insert_block(tc->td, vblock, pblock);
> > > > > 
> > > > > Having reserved and mapped blocks, what happens when we try to read them?
> > > > > Do we actually get zeroes, or does the read go straight through to whatever
> > > > > happens to be in the disk blocks?  I don't think it's correct that we could
> > > > > BDEV_RES_PROVISION and end up with stale credit card numbers from some other
> > > > > thin device.
> > > > > 
> > > > 
> > > > Agree, but I'm not really sure how this works in thinp tbh. fallocate
> > > > wasn't really on my mind when doing this. I was simply trying to cobble
> > > > together what I could to facilitate making progress on the fs parts
> > > > (e.g., I just needed a call that allocated blocks and consumed
> > > > reservation in the process).
> > > > 
> > > > Skimming through the dm-thin code, it looks like a (configurable) block
> > > > zeroing mechanism can be triggered from somewhere around
> > > > provision_block()->schedule_zero(), depending on whether the incoming
> > > > write overwrites the newly allocated block. If that's the case, then I
> > > > suspect that means reads would just fall through to the block and return
> > > > whatever was on disk. This code would probably need to tie into that
> > > > zeroing mechanism one way or another to deal with that issue. (Though
> > > > somebody who actually knows something about dm-thin should verify that.
> > > > :)
> > > > 
> > > 
> > > BTW, if that mechanism is in fact doing I/O, that might not be the
> > > appropriate solution for fallocate. Perhaps we'd have to consider an
> > > unwritten flag or some such in dm-thin, if possible.
> > 
> > DM thinp defaults to enabling 'zero_new_blocks' (can be disabled using
> > the 'skip_block_zeroing' feature when loading the DM table for the
> > thin-pool).  With block-zeroing any blocks that are provisioned _will_
> > be overwritten with zeroes (using dm-kcopyd which is trained to use
> > WRITE_SAME if supported).
> > 
> 
> Ok, thanks.
> 
> > But yeah, for fallocate.. certainly not something we want as it defeats
> > the point of fallocate being cheap.
> > 
> 
> Indeed.
> 
> > So we probably would need a flag comparable to the
> > ext4-stale-flag-that-shall-not-be-named ;)
> > 
> 
> Any chance to support an unwritten flag for all blocks that are
> allocated via fallocate? E.g., subsequent reads detect the flag and
> return zeroes as if the block wasn't there and a subsequent write clears
> the flag (doing any partial block zeroing that might be necessary as
> well).

Yeah, I've already started talking to Joe about doing exactly that.
Without it we cannot securely provide fallocate support in DM thinp.

I'll keep discussing with Joe... he doesn't like this requirement but
we'll work through it.
