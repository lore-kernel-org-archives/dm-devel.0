From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] block: xfs: dm thin: train XFS to give up on
 retrying IO if thinp is out of space
Date: Wed, 22 Jul 2015 09:34:51 -0400
Message-ID: <20150722133451.GB16842@redhat.com>
References: <20150720151849.GA2282@redhat.com>
 <20150720223610.GV7943@dastard>
 <55AE6670.40903@redhat.com>
 <20150721174753.GA8563@redhat.com>
 <20150722000923.GB7943@dastard>
 <20150722010056.GC7943@dastard>
 <20150722014029.GA10628@redhat.com>
 <20150722023711.GD7943@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150722023711.GD7943@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, hch@lst.de, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Tue, Jul 21 2015 at 10:37pm -0400,
Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Jul 21, 2015 at 09:40:29PM -0400, Mike Snitzer wrote:
> 
> > I'm open to considering alternative interfaces for getting you the info
> > you need.  I just don't have a great sense for what mechanism you'd like
> > to use.  Do we invent a new block device operations table method that
> > sets values in a 'struct no_space_strategy' passed in to the
> > blockdevice?
> 
> It's long been frowned on having the filesystems dig into block
> device structures. We have lots of wrapper functions for getting
> information from or performing operations on block devices. (e.g.
> bdev_read_only(), bdev_get_queue(), blkdev_issue_flush(),
> blkdev_issue_zeroout(), etc) and so I think this is the pattern we'd
> need to follow. If we do that - bdev_get_nospace_strategy() - then
> how that information gets to the filesystem is completely opaque
> at the fs level, and the block layer can implement it in whatever
> way is considered sane...
> 
> And, realistically, all we really need returned is a enum to tell us
> how the bdev behaves on enospc:
> 	- bdev fails fast, (i.e. immediate ENOSPC)
> 	- bdev fails slow, (i.e. queue for some time, then ENOSPC)
> 	- bdev never fails (i.e. queue forever)
> 	- bdev doesn't support this (i.e. EOPNOTSUPP)

This 'struct no_space_strategy' would be invented purely for
informational purposes for upper layers' benefit -- I don't consider it
a "block device structure" it the traditional sense.

I was thinking upper layers would like to know the actual timeout value
for the "fails slow" case.  As such the 'struct no_space_strategy' would
have the enum and the timeout.  And would be returned with a call:
     bdev_get_nospace_strategy(bdev, &no_space_strategy)
