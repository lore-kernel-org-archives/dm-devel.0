From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
Date: Mon, 28 May 2007 11:29:37 +0200
Message-ID: <465AA101.9060603@gmail.com>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18010.12472.209452.148229@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>
List-Id: dm-devel.ids

Hello,

Neil Brown wrote:
> 1/ A BIO_RW_BARRIER request should never fail with -EOPNOTSUP.
> 
>  This is certainly a very attractive position - it makes the interface
>  cleaner and makes life easier for filesystems and other clients of
>  the block interface.
>  Currently filesystems handle -EOPNOTSUP by
>   a/ resubmitting the request without the BARRIER (after waiting for
>     earlier requests to complete) and
>   b/ possibly printing an error message to the kernel logs.
> 
>  The block layer can do both of these just as easily and it does make
>  sense to do it there.

Yeah, I think doing all the above in the block layer is the cleanest way
to solve this.  If write back cache && flush doesn't work, barrier is
bound to fail but block layer still can write the barrier block as
requested (without actual barriering), whine about it to the user, and
tell the FS that barrier is failed but the write itself went through, so
that FS can go on without caring about it unless it wants to.

>  md/dm modules could keep count of requests as has been suggested
>  (though that would be a fairly big change for raid0 as it currently
>  doesn't know when a request completes - bi_endio goes directly to the
>  filesystem). 
>  However I think the idea of a zero-length BIO_RW_BARRIER would be a
>  good option.  raid0 could send one of these down each device, and
>  when they all return, the barrier request can be sent to it's target
>  device(s).

Yeap.

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
> 
>  One possible alternative is:
>    - writes can overtake barriers, but barrier cannot overtake writes.
>    - flush before the barrier, not after.

I think we can give this property to zero length barriers.

>  This is considerably weaker, and hence cheaper. But I think it is
>  enough for all filesystems (providing it is still an option to call
>  blkdev_issue_flush on 'fsync').
> 
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

Barrier code as it currently stands deals with two colors so there can
be only one outstanding barrier at given moment.  Expanding it to deal
with multiple colors and then to multiple simultaneous groups will take
some work but is definitely possible.  If FS people can make good use of
it, I think it would be worthwhile.

>  Of course, these weaker rules would only apply inside the elevator.
>  Once the request goes to the device we need to work with what the
>  device provides, which probably means total-ordering around the
>  barrier. 

Yeah, on device side, the best we can do most of the time is full flush
but as long as request queue depth is much deeper than the
controller/device one, having multiple barrier groups can be helpful.
We need more input from FS people, I think.

> 3/ Do we need explicit control of the 'ordered' mode?
> 
>   Consider a SCSI device that has NV RAM cache.  mode_sense reports
>   that write-back is enabled, so _FUA or _FLUSH will be used.
>   But as it is *NV* ram, QUEUE_ORDER_DRAIN is really the best mode.
>   But it seems there is no way to query this information.
>   Using _FLUSH causes the NVRAM to be flushed to media which is a
>   terrible performance problem.

If the NV RAM can be reliably detected using one of the inquiry pages,
sd driver can switch it to DRAIN automatically.

>   Setting SYNC_NV doesn't work on the particular device in question.
>   We currently tell customers to mount with -o nobarriers, but that
>   really feels like the wrong solution.  We should be telling the scsi
>   device "don't flush".
>   An advantage of 'nobarriers' is it can go in /etc/fstab.  Where
>   would you record that a SCSI drive should be set to
>   QUEUE_ORDERD_DRAIN ??

How about exporting ordered mode as sysfs attribute and configuring it
using a udev rule?  It's a device property after all.

Thanks.

-- 
tejun
