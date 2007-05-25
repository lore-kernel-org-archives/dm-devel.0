From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Fri, 25 May 2007 13:49:11 +0200
Message-ID: <20070525114910.GQ7653@kernel.dk>
References: <18006.38689.818186.221707@notabene.brown> <20070525111557.GP85884050@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070525111557.GP85884050@sgi.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: dm-devel.ids

On Fri, May 25 2007, David Chinner wrote:
> > The second, while much easier, can fail.
> 
> So we do a test I/O to see if the device supports them before
> enabling that mode.  But, as we've recently discovered, this is not
> sufficient to detect *correctly functioning* barrier support.

Right, those are two different things. But paranoia aside, will this
ever be a real life problem? I've always been of the opinion to just
nicely ignore them. We can't easily detect it and tell the user his hw
is crap.

> > So a filesystem should be
> > prepared to deal with that failure by falling back to the first
> > option.
> 
> I don't buy that argument.....

The problem with Neils reasoning there is that blkdev_issue_flush() may
use the same method as the barrier to ensure data is on platter.

A barrier write will include a flush, but it may also use the FUA bit to
ensure data is on platter. So the only situation where a fallback from a
barrier to flush would be valid, is if the device lied and told you it
could do FUA but it could not and that is the reason why the barrier
write failed. If that is the case, the block layer should stop using FUA
and fallback to flush-write-flush. And if it does that, then there's
never a valid reason to switch from using barrier writes to
blkdev_issue_flush() since both methods would either both work or both
fail.

> > Thus the general sequence might be:
> > 
> >   a/ issue all "preceding writes".
> >   b/ issue the commit write with BIO_RW_BARRIER
> 
> At this point, the filesystem has done everything it needs to ensure
> that the block layer has been informed of the I/O ordering
> requirements. Why should the filesystem now have to detect block
> layer breakage, and then use a different block layer API to issue
> the same I/O under the same constraints?

It's not block layer breakage, it's a device issue.

> > 2/ Mirror devices.  This includes md/raid1 and dm-raid1.
> ......
> >    Hopefully this is unlikely to happen.  What device would work
> >    correctly with barriers once, and then not the next time?
> >    The answer is md/raid1.  If you remove a failed device and add a
> >    new device that doesn't support barriers, md/raid1 will notice and
> >    stop supporting barriers.
> 
> In case you hadn't already guess, I don't like this behaviour at
> all.  It makes async I/O completion of barrier I/O an ugly, messy
> business, and every place you do sync I/O completion you need to put
> special error handling.

That's unfortunately very true. It's an artifact of the sometimes
problematic device capability discovery.

> If this happens to md/raid1, then why can't it simply do a
> blkdev_issue_flush, write, blkdev_issue_flush sequence to the device
> that doesn't support barriers and then the md device *never changes
> behaviour*. Next time the filesystem is mounted, it will turn off
> barriers because they won't be supported....

Because if it doesn't support barriers, blkdev_issue_flush() wouldn't
work either. At least that is the case for SATA/IDE, SCSI is somewhat
different (and has somewhat other issues).

> >  - Should the various filesystems be "fixed" as suggested above?  Is 
> >     someone willing to do that?
> 
> Alternate viewpoint - should the block layer be fixed so that the
> filesystems only need to use one barrier API that provides static
> behaviour for the life of the mount?

blkdev_issue_flush() isn't part of the barrier API, and using it as a
work-around for a device that has barrier "issues" is wrong for the
reasons listed above.

The DRAIN_FUA -> DRAIN_FLUSH automatic downgrade I mentioned above
should be added, in which case blkdev_issue_flush() would never be
needed (unless you want to do a data-less barrier, and we should
probably add that specific functionality with an empty bio instead of
providing an alternate way of doing that).

-- 
Jens Axboe

