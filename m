From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
Date: Tue, 29 May 2007 15:59:33 -0400
Message-ID: <465C8625.1010001@cfl.rr.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <18010.12472.209452.148229@notabene.brown>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

Neil Brown wrote:
>  md/dm modules could keep count of requests as has been suggested
>  (though that would be a fairly big change for raid0 as it currently
>  doesn't know when a request completes - bi_endio goes directly to the
>  filesystem). 

Are you sure?  I believe that dm handles bi_endio because it waits for 
all in progress bio to complete before switching tables.

> 2/ Maybe barriers provide stronger semantics than are required.
> 
>  All write requests are synchronised around a barrier write.  This is
>  often more than is required and apparently can cause a measurable
>  slowdown.

I'm not quite sure I understand this correctly, but the purpose of a 
barrier request is to prevent the elevator from reordering requests 
around a barrier.  Previous requests must be completed before the 
barrier, and latter requests must be executed after.  That is a 
sufficiently strong guarantee for careful write or journal filesystems 
to ensure that a log block hits the disk before the actual transaction 
blocks, and then the log block is marked as complete only after the 
actual transaction.  This is a weaker guarantee than a flush, and allows 
for some reordering to improve performance.

>  Also the FUA for the actual commit write might not be needed.  It is
>  important for consistency that the preceding writes are in safe
>  storage before the commit write, but it is not so important that the
>  commit write is immediately safe on storage.  That isn't needed until
>  a 'sync' or 'fsync' or similar.

Right, the barrier doesn't need to be flushed right away, so the 
elevator could complete writes after the barrier if it wishes, then 
complete the ones before, and finally the barrier itself.  Not setting 
the FUA bit allows the disk to cache the barrier write so it can be 
completed sooner, but before the queue sends any more requests to the 
disk, it must be flushed to ensure that the barrier has hit the media 
before the new requests.

>  One possible alternative is:
>    - writes can overtake barriers, but barrier cannot overtake writes.
>    - flush before the barrier, not after.
> 
>  This is considerably weaker, and hence cheaper. But I think it is
>  enough for all filesystems (providing it is still an option to call
>  blkdev_issue_flush on 'fsync').

Again I am not sure I quite understand what you mean here, but only 
writes issued after the barrier can complete before the barrier.  Those 
issued before the barrier can not overtake it in the queue.

>  Another alternative would be to tag each bio was being in a
>  particular barrier-group.  Then bio's in different groups could
>  overtake each other in either direction, but a BARRIER request must
>  be totally ordered w.r.t. other requests in the barrier group.
>  This would require an extra bio field, and would give the filesystem
>  more appearance of control.  I'm not yet sure how much it would
>  really help...
>  It would allow us to set FUA on all bios with a non-zero
>  barrier-group.  That would mean we don't have to flush the entire
>  cache, just those blocks that are critical.... but I'm still not sure
>  it's a good idea.

This all seems unnecessary work.


