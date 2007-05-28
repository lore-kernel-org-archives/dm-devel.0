From: David Chinner <dgc@sgi.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Mon, 28 May 2007 12:45:59 +1000
Message-ID: <20070528024559.GA85884050@sgi.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18010.12472.209452.148229@notabene.brown>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Mon, May 28, 2007 at 11:30:32AM +1000, Neil Brown wrote:
> 
> Thanks everyone for your input.  There was some very valuable
> observations in the various emails.
> I will try to pull most of it together and bring out what seem to be
> the important points.
> 
> 
> 1/ A BIO_RW_BARRIER request should never fail with -EOPNOTSUP.

Sounds good to me, but how do we test to see if the underlying
device supports barriers? Do we just assume that they do and
only change behaviour if -o nobarrier is specified in the mount
options?

> 2/ Maybe barriers provide stronger semantics than are required.
> 
>  All write requests are synchronised around a barrier write.  This is
>  often more than is required and apparently can cause a measurable
>  slowdown.
> 
>  Also the FUA for the actual commit write might not be needed.  It is
>  important for consistency that the preceding writes are in safe
>  storage before the commit write, but it is not so important that the
>  commit write is immediately safe on storage.  That isn't needed until
>  a 'sync' or 'fsync' or similar.

The use of barriers in XFS assumes the commit write to be on stable
storage before it returns.  One of the ordering guarantees that we
need is that the transaction (commit write) is on disk before the
metadata block containing the change in the transaction is written
to disk and the current barrier behaviour gives us that.

>  One possible alternative is:
>    - writes can overtake barriers, but barrier cannot overtake writes.

No, that breaks the above usage of a barrier....

>    - flush before the barrier, not after.
> 
>  This is considerably weaker, and hence cheaper. But I think it is
>  enough for all filesystems (providing it is still an option to call
>  blkdev_issue_flush on 'fsync').

No, not enough for XFS.

>  Another alternative would be to tag each bio was being in a
>  particular barrier-group.  Then bio's in different groups could
>  overtake each other in either direction, but a BARRIER request must
>  be totally ordered w.r.t. other requests in the barrier group.
>  This would require an extra bio field, and would give the filesystem
>  more appearance of control.  I'm not yet sure how much it would
>  really help...

And that assumes the filesystem is tracking exact dependencies
between I/Os.  Such a mechanism would probably require filesystems
to be redesigned to use this, but I can see how it would be useful
for doing things like ensuring ordering between just an inode and
it's data writes.  What would the overhead of having to support
several hundred thousand different barrier groups be (i.e. one per
dirty inode in a system)?

> I think the implementation priorities here are:

Depending on the answer to my first question:

0/ implement a specific test for filesystems to run at mount time
   to determine if barriers are supported or not.

> 1/ implement a zero-length BIO_RW_BARRIER option.
> 2/ Use it (or otherwise) to make all dm and md modules handle
>    barriers (and loop?).
> 3/ Devise and implement appropriate fall-backs with-in the block layer
>    so that  -EOPNOTSUP is never returned.
> 4/ Remove unneeded cruft from filesystems (and elsewhere).

Sounds like a good start. ;)

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
