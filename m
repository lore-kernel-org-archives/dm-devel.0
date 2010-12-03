From: Ted Ts'o <tytso@mit.edu>
Subject: Re: Bugs in mkfs.xfs, device mapper, xfs, and /dev/ram
Date: Fri, 3 Dec 2010 13:15:20 -0500
Message-ID: <20101203181520.GA26906@thunk.org>
References: <4CF7A539.1050206@shiftmail.org>
 <20101202141134.GA22012@infradead.org>
 <4CF7A9C4.2040607@shiftmail.org>
 <20101202141737.GA29799@infradead.org>
 <20101202212227.GA22703@redhat.com>
 <20101203171140.GA11889@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101203171140.GA11889@amd>
Sender: linux-kernel-owner@vger.kernel.org
To: Nick Piggin <npiggin@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, LVM general discussion and development <linux-lvm@redhat.com>, Spelic <spelic@shiftmail.org>, Christoph Hellwig <hch@infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Dec 04, 2010 at 04:11:40AM +1100, Nick Piggin wrote:
> > Alternatively, what about switching brd away from overloading BLKFLSBUF
> > to a real implementation of (overloaded) BLKDISCARD support in brd.c?
> > One that doesn't blindly nuke the entire device but that properly
> > processes the discard request.
> 
> Yeah the situation really sucks (mkfs.jfs doesn't work on ramdisk
> for the same reason).
> 
> I want to unfortunately keep ioctl for compatibility, but adding new
> saner ones would be welcome. Also, having a non-default config or
> load time parameter for brd, to skip the special case, if that would
> help testing on older userspace.

How many programs actually depend on BLKFLSBUF dropping the pages used
in /dev/ram?  The fact that it did this at all was a historical
accident of how the original /dev/ram was implemented (in the buffer
cache directly), and not anything that was intended.  I think that's
something that we should be able to fix, since the number of programs
that knowly operate on the ramdisk is quite small.  Just a few system
programs used by distributions in their early boot scripts....

So I would argue for dropping the "special" behavior of BLKFLSBUF for
/dev/ram.

							- Ted
