From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH] block: xfs: dm thin: train XFS to give up on
 retrying IO if thinp is out of space
Date: Tue, 21 Jul 2015 21:40:29 -0400
Message-ID: <20150722014029.GA10628@redhat.com>
References: <20150720151849.GA2282@redhat.com>
 <20150720223610.GV7943@dastard>
 <55AE6670.40903@redhat.com>
 <20150721174753.GA8563@redhat.com>
 <20150722000923.GB7943@dastard>
 <20150722010056.GC7943@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150722010056.GC7943@dastard>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, axboe@kernel.dk, hch@lst.de, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, xfs@oss.sgi.com, Vivek Goyal <vgoyal@redhat.com>
List-Id: dm-devel.ids

On Tue, Jul 21 2015 at  9:00pm -0400,
Dave Chinner <david@fromorbit.com> wrote:

> On Wed, Jul 22, 2015 at 10:09:23AM +1000, Dave Chinner wrote:
> > On Tue, Jul 21, 2015 at 01:47:53PM -0400, Mike Snitzer wrote:
> > > On Tue, Jul 21 2015 at 11:34am -0400, Eric Sandeen <sandeen@redhat.com> wrote:
> > > > On 7/20/15 5:36 PM, Dave Chinner wrote:
> > > > The issue we had discussed previously is that there is no agreement
> > > > across block devices about whether ENOSPC is a permanent or temporary
> > > > condition.  Asking the admin to tune  the fs to each block device's
> > > > behavior sucks, IMHO.
> > > 
> > > It does suck, but it beats the alternative of XFS continuing to do
> > > nothing about the problem.
> > 
> > Just a comment on that: doing nothing is better than doing the wrong
> > thing and being stuck with it forever. :)
> > 
> > > Disucssing more with Vivek, might be that XFS would be best served to
> > > model what dm-thinp has provided with its 'no_space_timeout'.  It
> > > defaults to queueing IO for 60 seconds, once the timeout expires the
> > > queued IOs getted errored.  If set to 0 dm-thinp will queue IO
> > > indefinitely.
> > 
> > Yes, that's exactly what I proposed in the thread I referenced in
> > my previous email, and what got stuck on the bikeshed wall because
> > of these concerns about knob twiddling:
> > 
> > http://oss.sgi.com/archives/xfs/2015-02/msg00346.html
> > 
> > | e.g. if we need configurable error handling, it needs to be
> > | configurable for different error types, and it needs to be
> > | configurable on a per-mount basis. And it needs to be configurable
> > | at runtime, not just at mount time. That kind of leads to using
> > | sysfs for this. e.g. for each error type we ned to handle different
> > | behaviour for:
> > | 
> > | $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/type
> > | [transient] permanent
> > | $ cat /sys/fs/xfs/vda/meta_write_errors/enospc/perm_timeout_seconds
> > | 300
> > | $ cat
> > | /sys/fs/xfs/vda/meta_write_errors/enospc/perm_max_retry_attempts
> > | 50
> > | $ cat
> > | /sys/fs/xfs/vda/meta_write_errors/enospc/transient_fail_at_umount
> > | 1
> > 
> > I've rebased this patchset, and I'm cleaning it up now, so in a few
> > days I'll have something for review, likely for the 4.3 merge
> > window....
> 
> Just thinking a bit more on how to make this simpler to configure,
> is there a simple way for the filesystem to determine the current
> config of the dm thinp volume? i.e. if the dm-thinp volume is
> configured to error out immediately on enospc, then XFS should
> default to doing the same thing. having XFS be able to grab this
> status at mount time and change the default ENOSPC error config from
> transient to permanent on such dm-thinp volumes would go a long way
> to making these configs Just Do The Right Thing on block dev enospc
> errors...
> 
> e.g. if dm-thinp is configured to queue for 60s and then fail on
> ENOSPC, we want XFS to fail immediately on ENOSPC in metadata IO. If
> dm-thinp is configured to ENOSPC instantly (i.e. no queueing) then
> we want XFS to retry and use it's default retry maximums before
> failing permanently.

Yes, that'd be nice.  But there isn't a way to easily get the DM thinp
device's config from within the kernel (unless XFS wants to get into the
business of issuing ioctls to DM devices.. unlikely).  I could be
persuaded to expose a per-device sysfs file to get the status (would
avoid need for ioctl), e.g.:
 # cat /sys/block/dm-5/dm/status
(but that doesn't _really_ help in-kernel access, awkward for filesystem
code to be opening sysfs files!)

SO userspace (mkfs.xfs) could easily check the thinp device's setup
using 'dmsetup status <device>' (output will either contain
'queue_if_no_space' or 'error_if_no_space').  The DM thinp
'no_space_timeout' (applicable if queue_if_no_space) is a thinp global
accessed using a module param:
 # cat /sys/module/dm_thin_pool/parameters/no_space_timeout
 60

I'm open to considering alternative interfaces for getting you the info
you need.  I just don't have a great sense for what mechanism you'd like
to use.  Do we invent a new block device operations table method that
sets values in a 'struct no_space_strategy' passed in to the
blockdevice?
