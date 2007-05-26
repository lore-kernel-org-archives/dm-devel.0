From: Tejun Heo <htejun@gmail.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
 and dm/md.
Date: Sat, 26 May 2007 12:27:22 +0200
Message-ID: <46580B8A.1070009@gmail.com>
References: <18006.38689.818186.221707@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18006.38689.818186.221707@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>
List-Id: dm-devel.ids

Hello, Neil Brown.

Please cc me on blkdev barriers and, if you haven't yet, reading
Documentation/block/barrier.txt can be helpful too.

Neil Brown wrote:
[--snip--]
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
> 
> 3/ BARRIER.
> 	  A BARRIER device supports both blkdev_issue_flush and
>           BIO_RW_BARRIER.  Either may be used to synchronise any
> 	  write-behind cache to non-volatile storage (media).
> 
> Handling of SAFE and FLUSHABLE devices is essentially the same and can
> work on a BARRIER device.  The BARRIER device has the option of more
> efficient handling.

Actually, all above three are handled by blkdev flush code.

> How does a filesystem use this?
> ===============================
> 
[--snip--]
> 2/ Set the BIO_RW_BARRIER bit in the write request for the commit
>     block.
>    (This is more efficient on BARRIER).

This really should be enough.

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
>         call blkdev_issue_flush on all devices
>         issue the barrier write to the target device(s)
>            as BIO_RW_BARRIER,
>         if that is -EOPNOTSUP, re-issue, wait, flush.

Hmm... What do you think about introducing zero-length BIO_RW_BARRIER
for this case?

> 2/ Mirror devices.  This includes md/raid1 and dm-raid1.
> 
>    These device can trivially implement blkdev_issue_flush much like
>    the striping devices, and can support BIO_RW_BARRIER to some
>    extent.
>    md/raid1 currently tries.  I'm not sure about dm-raid1.
> 
>    md/raid1 determines if the underlying devices can handle
>    BIO_RW_BARRIER.  If any cannot, it rejects such requests (EOPNOTSUP)
>    itself.
>    If all underlying devices do appear to support barriers, md/raid1
>    will pass a barrier-write down to all devices.
>    The difficulty comes if it fails on one device, but not all
>    devices.  In this case it is not clear what to do.  Failing the
>    request is a lie, because some data has been written (possible too
>    early).  Succeeding the request (after re-submitting the failed
>    requests) is also a lie as the barrier wasn't really honoured.
>    md/raid1 currently takes the latter approach, but will only do it
>    once - after that it fails all barrier requests.
> 
>    Hopefully this is unlikely to happen.  What device would work
>    correctly with barriers once, and then not the next time?
>    The answer is md/raid1.  If you remove a failed device and add a
>    new device that doesn't support barriers, md/raid1 will notice and
>    stop supporting barriers.
>    If md/raid1 can change from supporting barrier to not, then maybe
>    some other device could too?
> 
>    I'm not sure what to do about this - maybe just ignore it...

That sounds good.  :-)

> 3/ Other modules
> 
>    Other md and dm modules (raid5, mpath, crypt) do not add anything
>    interesting to the above.  Either handling BIO_RW_BARRIER is
>    trivial, or extremely difficult.
> 
> HOW DO LOW LEVEL DEVICES HANDLE THIS
> ====================================
> 
> This is part of the picture that I haven't explored greatly.  My
> feeling is that most if not all devices support blkdev_issue_flush
> properly, and support barriers reasonably well providing that the
> hardware does.
> There in an exception I recently found though.
> For devices that don't support QUEUE_ORDERED_TAG (i.e. commands sent to
> the controller can be tagged as barriers), SCSI will use the
> SYNCHRONIZE_CACHE command to flush the cache after the barrier
> request (a bit like the filesystem calling blkdev_issue_flush, but at
> a lower level). However it does this without setting the SYNC_NV bit.
> This means that a device with a non-volatile cache will be required --
> needlessly -- to flush that cache to media.

Yeah, it probably needs updating but some devices might react badly too.

> So: some questions to help encourage response:
> 
>  - Is the above substantial correct?  Totally correct?
>  - Should the various filesystems be "fixed" as suggested above?  Is 
>     someone willing to do that?

I don't think adding the complexity to each and every FS is necessary.
Except for broken devices, the only reason barrier fails is when the
device lied about its capability - either about ordered tag or FUA.
It would be far nicer if we can do proper capability testing during
device initialization but unfortunately barriers are writes and we can't
test without side effects.

While developing the current flush code, I had automatic fallback
mechanism but removed it before submitting because 1. I wasn't sure
whether it would be necessary and 2. it couldn't handle fall back from
ordered tag properly (because ordered tag doesn't guarantee failure of
latter requests when an earlier one fails, you're already too late when
you get the error report from the device).  This can be solved by
running the first sequence in more restrictive way (ie. we do capability
probing at the first barrier from FS).

So, if barrier failure due to devices lying about their capability is an
actual problem (ATA hasn't seen much if any), it can be solved inside
block layer proper.  No need to update filesystems.  Just issuing
barrier when ordering is needed should be enough.

If there have been actual reports of these failures, please point me to
them.

Thanks.

-- 
tejun
