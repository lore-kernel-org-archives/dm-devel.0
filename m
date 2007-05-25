From: David Chinner <dgc@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Fri, 25 May 2007 21:15:58 +1000
Message-ID: <20070525111557.GP85884050@sgi.com>
References: <18006.38689.818186.221707@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18006.38689.818186.221707@notabene.brown>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>
List-Id: dm-devel.ids

On Fri, May 25, 2007 at 05:58:25PM +1000, Neil Brown wrote:
> We can think of there being three types of devices:
>  
> 1/ SAFE.  With a SAFE device, there is no write-behind cache, or if
>           there is it is non-volatile.  Once a write completes it is 
>           completely safe.  Such a device does not require barriers
>           or ->issue_flush_fn, and can respond to them either by a
> 	  no-op or with -EOPNOTSUPP (the former is preferred).
> 
> 2/ FLUSHABLE.
>           A FLUSHABLE device may have a volatile write-behind cache.
>           This cache can be flushed with a call to blkdev_issue_flush.
> 	  It may not support barrier requests.

So returns -EOPNOTSUPP to any barrier request?

> 3/ BARRIER.
> 	  A BARRIER device supports both blkdev_issue_flush and
>           BIO_RW_BARRIER.  Either may be used to synchronise any
> 	  write-behind cache to non-volatile storage (media).
> 
> Handling of SAFE and FLUSHABLE devices is essentially the same and can
> work on a BARRIER device.  The BARRIER device has the option of more
> efficient handling.
> 
> How does a filesystem use this?
> ===============================
....
> 
> The filesystem will want to ensure that all preceding writes are safe
> before writing the barrier block.  There are two ways to achieve this.

Three, actually.

> 1/  Issue all 'preceding writes', wait for them to complete (bi_endio
>    called), call blkdev_issue_flush, issue the commit write, wait
>    for it to complete, call blkdev_issue_flush a second time.
>    (This is needed for FLUSHABLE)

*nod*

> 2/ Set the BIO_RW_BARRIER bit in the write request for the commit
>     block.
>    (This is more efficient on BARRIER).

*nod*

3/ Use a SAFE device.

> The second, while much easier, can fail.

So we do a test I/O to see if the device supports them before
enabling that mode.  But, as we've recently discovered, this is not
sufficient to detect *correctly functioning* barrier support.

> So a filesystem should be
> prepared to deal with that failure by falling back to the first
> option.

I don't buy that argument.....

> Thus the general sequence might be:
> 
>   a/ issue all "preceding writes".
>   b/ issue the commit write with BIO_RW_BARRIER

At this point, the filesystem has done everything it needs to ensure
that the block layer has been informed of the I/O ordering
requirements. Why should the filesystem now have to detect block
layer breakage, and then use a different block layer API to issue
the same I/O under the same constraints?

>   c/ wait for the commit to complete.
>          If it was successful - done.
>          If it failed other than with EOPNOTSUPP, abort
>          else continue
>   d/ wait for all 'preceding writes' to complete
>   e/ call blkdev_issue_flush
>   f/ issue commit write without BIO_RW_BARRIER
>   g/ wait for commit write to complete
>        if it failed, abort
>   h/ call blkdev_issue
            ^^^^^^^^^^^^_flush?

>   DONE
> 
> steps b and c can be left out if it is known that the device does not
> support barriers.  The only way to discover this to try and see if it
> fails.

That's a very linear, single-threaded way of looking at it... ;)

> I don't think any filesystem follows all these steps.
> 
>  ext3 has the right structure, but it doesn't include steps e and h.
>  reiserfs is similar.  It does have a call to blkdev_issue_flush, but 
>   that is only on the fsync path, so it isn't really protecting
>   general journal commits.
>  XFS - I'm less sure.  I think it does 'a' then 'd', then 'b' or 'f'
>    depending on a whether it thinks the device handles barriers,
>    and finally 'g'.

That's right, except for the "g" (or "c") bit - commit writes are
async and nothing waits for them - the io completion wakes anything
waiting on it's completion....

(yes, all XFS barrier I/Os are issued async which is why having to
handle an -EOPNOTSUPP error is a real pain. The fix I currently
have is to reissue the I/O from the completion handler with is
ugly, ugly, ugly.....)

> So for devices that support BIO_RW_BARRIER, and for devices that don't
> need any flush, they work OK, but for device that need flushing, but
> don't support BIO_RW_BARRIER, none of them work.  This should be easy
> to fix.

Right - XFS as it stands was designed to work on SAFE devices, and
we've modified it to work on BARRIER devices. We don't support
FLUSHABLE devices at all.

But if the filesystem supports BARRIER devices, I don't see any
reason why a filesystem needs to be modified to support FLUSHABLE
devices - the key point being that by the time the filesystem
has issued the "commit write" it has already waited for all it's
dependent I/O, and so all the block device needs to do is
issue flushes either side of the commit write....

> HOW DO MD or DM USE THIS
> ========================
> 
> 1/ striping devices.
>      This includes md/raid0 md/linear dm-linear dm-stripe and probably
>      others. 
> 
>    These devices can easily support blkdev_issue_flush by simply
>    calling blkdev_issue_flush on all component devices.
> 
>    These devices would find it very hard to support BIO_RW_BARRIER.
>    Doing this would require keeping track of all in-flight requests
>    (which some, possibly all, of the above don't) and then:
>      When a BIO_RW_BARRIER request arrives:
>         wait for all pending writes to complete

A count of outstanding I/Os and a wait queue is sufficient to implement
this, I think.

.....
>    I think the best approach for this class of devices is to return
>    -EOPNOSUP.  If the filesystem does the wait (which they all do
>    already) and the blkdev_issue_flush (which is easy to add), they
>    don't need to support BIO_RW_BARRIER.

So you want to define these as a FLUSHABLE device?

> 2/ Mirror devices.  This includes md/raid1 and dm-raid1.
......
>    Hopefully this is unlikely to happen.  What device would work
>    correctly with barriers once, and then not the next time?
>    The answer is md/raid1.  If you remove a failed device and add a
>    new device that doesn't support barriers, md/raid1 will notice and
>    stop supporting barriers.

In case you hadn't already guess, I don't like this behaviour at
all.  It makes async I/O completion of barrier I/O an ugly, messy
business, and every place you do sync I/O completion you need to put
special error handling.

If this happens to md/raid1, then why can't it simply do a
blkdev_issue_flush, write, blkdev_issue_flush sequence to the device
that doesn't support barriers and then the md device *never changes
behaviour*. Next time the filesystem is mounted, it will turn off
barriers because they won't be supported....

You do that, and suddenly there's 10 filesystems that no longer have
to handle this extremely rare corner case.

> So: some questions to help encourage response:
> 
>  - Is the above substantial correct?  Totally correct?

Mostly valid ;)

I like the idea of clearly defining the different types of devices
so we can say exactly what each device behaves like. It also
points out (to me, anyway) that from a filesystem POV there is
no logical difference between a BARRIER and a FLUSHABLE block device;
the only difference is that filesystems are forced to use a
different API to support them (and hence they are not supported).

>  - Should the various filesystems be "fixed" as suggested above?  Is 
>     someone willing to do that?

Alternate viewpoint - should the block layer be fixed so that the
filesystems only need to use one barrier API that provides static
behaviour for the life of the mount?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
