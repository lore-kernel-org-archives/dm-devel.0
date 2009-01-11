From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/4][RFC] dm-core: full barrier support
Date: Sun, 11 Jan 2009 14:28:29 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0901111319240.25677@hs20-bc2-1.build.redhat.com>
References: <4966260C.6070602@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4966260C.6070602@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

On Thu, 8 Jan 2009, Milan Broz wrote:

> This patchset is just resend for new kernel of a barrier implementation.
> 
> Please note that it is more request for discussion...
> 
> [PATCH 1/4] dm-core: remove current partial barrier implementation
> 
> [PATCH 2/4] dm-core: Add zero-size barrier processing to device-mapper
> 
> [PATCH 3/4] dm-core: Process barrier request with payload in device-mapper
> 
> [PATCH 4/4] dm-core: Implement waiting for barrier in dm_suspend request
> 
> 
> Milan
> --
> mbroz@redhat.com

Hi

I looked at the patches.

There are few fixable technical bugs:

* After you submit a barrier, you wait for completion of the barrier and 
preceding requests. Yet, in your implementation the barrier request may 
be reordered with preceding requests and this is against barrier 
specification. There need to be two waits, one before submitting the 
barrier and one after.

* If you endio a barrier request, you end the request and then call 
DM_WQ_BARRIER_POST that flushes caches. You must flush caches first and 
then do bio_endio (so that when the barrier request finishes, data are 
certainly on the disk).

* what about DM_ENDIO_REQUEUE and the pushback queue? Alasdair, please 
describe what is it used for (there is usage of this in mpath and raid1). 
With two queues it is impossible to get barrier ordering right, this needs 
somehow to be changed to one-queue design --- biolists deferred and 
pushback joined. It would be best to remove DM_ENDIO_REQUEUE, if it is 
possible.

* if you clear DMF_BLOCK_IO, you don't run the deferred queue --- it would 
produce lockup if barrier and non-barrier requests were submitted 
simultaneously (the non-barrier request gets queued on the deferred queue 
because of DMF_BLOCK_IO, but not dequeued when the barrier finishes). 
Single filesystems usually don't do it --- but they are allowed to --- for 
example to run direct io in parallel with journal commit. Another 
possibility when this lockup happens is when the filesystem is mounted 
read-wriet and the admin runs fsck in read-only mode.

* maybe the patch could be simplified somehow, not all the branches are 
needed (for example join DM_WQ_BARRIER and DM_WQ_BARRIER_POST).

--- and the main issue with the patch:

The patch waits in dm_request routine until the barrier finishes. This is 
allowed (there is no deadlock or crash hapenning because of it), but it 
basically turns asynchronous IO into synchronous IO and degrades 
performance.

As it turned out in my discussion before Christmas on lkml, all the 
current in-kernel filesystems use barriers in a synchronous way, so there 
is no problem with synchronous waiting inside dm_request now. But using 
barriers in a synchronous way supresses any performance advantage barriers 
could bring (you can replace synchronous barriers with hw-cache flushes 
and get the same performance with simpler code). If someone ever 
introduces async-barrier filesystem into kernel, synchronous processing 
will kill performance.

So this synchronous waiting is not a performance problem now but it may be 
problem in the future.


I have thought about it and written an implementation of asynchronous 
barriers --- it works by passing the requests to kdmflush and it returns 
immediatelly from dm_request. I'll post it in a few days.

Mikulas
