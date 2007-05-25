From: "Stefan Bader" <Stefan.Bader@de.ibm.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Fri, 25 May 2007 15:52:25 +0200
Message-ID: <5201e28f0705250652mff2735dwd2c14f5ad130ae97@mail.gmail.com>
References: <18006.38689.818186.221707@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18006.38689.818186.221707@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, David Chinner <dgc@sgi.com>, Neil Brown <neilb@suse.de>
List-Id: dm-devel.ids

2007/5/25, Neil Brown <neilb@suse.de>:
>
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

This ensures that all of the previous requests have been processed but
does this guarantee they where successful? This might be too paranoid
but if I understood the concept correctly the success of a barrier
request should indicate success of all previous request between this
barrier and the last one.

>    These devices would find it very hard to support BIO_RW_BARRIER.
>    Doing this would require keeping track of all in-flight requests
>    (which some, possibly all, of the above don't) and then:
>      When a BIO_RW_BARRIER request arrives:
>         wait for all pending writes to complete
>         call blkdev_issue_flush on all devices
>         issue the barrier write to the target device(s)
>            as BIO_RW_BARRIER,
>         if that is -EOPNOTSUP, re-issue, wait, flush.
>

I guess just keep a count of submitted requests and errors since the
last barrier might be enough. As long as all of the underlying device
support at least support a flush the dm device could pretend to
support BIO_RW_BARRIER.

>
>     dm-linear and dm-stripe simply pass the BIO_RW_BARRIER flag down,
>      which means data may not be flushed correctly:  the commit block
>      might be written to one device before a preceding block is
>      written to another device.
>
Hm, even worse: if the barrier requests accidentally end up on a
device that does support barriers and another one on the map doesn't.
Would any layer/fs above care to issue a flush call?

>    I think the best approach for this class of devices is to return
>    -EOPNOSUP.  If the filesystem does the wait (which they all do
>    already) and the blkdev_issue_flush (which is easy to add), they
>    don't need to support BIO_RW_BARRIER.
>
Without any additional code these really should report -EOPNOTSUPP. If
disaster strikes there is no way to make assumptions on the real state
on disk.

> 2/ Mirror devices.  This includes md/raid1 and dm-raid1.
>
>    These device can trivially implement blkdev_issue_flush much like
>    the striping devices, and can support BIO_RW_BARRIER to some
>    extent.
>    md/raid1 currently tries.  I'm not sure about dm-raid1.
>
I fear this is more broken as with linear and stripe. There is no code
to check the features of underlying devices and the request itself
isn't sent forward but privately built ones (which do not have the
barrier flag)...

3/ Multipath devices

Requests are sent to the same device but one different paths. So at
least with them the chance of one path supporting barriers but not
another one seems little (as long as the paths do not use completely
different transport layers). But passing on a request with the barrier
flag also doesn't seem to be a good idea since previous requests can
arrive at the device later.

IMHO the best way to handle barriers for dm would be to add the
sequence described to the generic mapping layer of dm (before calling
the targets mapping function). There is already some sort of counting
in-flight requests (suspend/resume needs that) and I guess the
downgrade could also be rather simple. If a flush call to the target
(mapped device) fails report -EOPNOTSUPP and stay that way (until next
boot).

> So: some questions to help encourage response:

>
>  - Is the approach to barriers taken by md appropriate?  Should dm
>     do the same?  Who will do that?

If my assumption about barrier semantics is true, then also md has to
somehow make sure all previous requests have _successfully_ completed.
In the mirror case I guess it is valid to report success if the mirror
itself is in a clean state. Which is all previous requests (and the
barrier) where successful on at least one mirror half and this state
can be recovered.

Question to dm-devel: What do people there think of the possible
generic implementation in dm.c?

>  - The comment above blkdev_issue_flush says "Caller must run
>    wait_for_completion() on its own".  What does that mean?
>
Guess this means it initiates a flush but doesn't wait for completion.
So the caller must wait for the completion of the separate requests on
its own, doesn't it?

>  - Are there other bit that we could handle better?
>     BIO_RW_FAILFAST?  BIO_RW_SYNC?  What exactly do they mean?
>
BIO_RW_FAILFAST: means low-level driver shouldn't do much (or no)
error recovery. Mainly used by mutlipath targets to avoid long SCSI
recovery. This should just be propagated when passing requests on.

BIO_RW_SYNC: means this is a bio of a synchronous request. I don't
know whether there are more uses to it but this at least causes queues
to be flushed immediately instead of waiting for more requests for a
short time. Should also just be passed on. Otherwise performance gets
poor since something above will rather wait for the current
request/bio to complete instead of sending more.

Stefan Bader
