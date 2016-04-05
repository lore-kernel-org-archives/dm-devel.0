From: Andreas Herrmann <aherrmann@suse.com>
Subject: Re: dm-cache performance behaviour
Date: Tue, 5 Apr 2016 16:05:07 +0200
Message-ID: <20160405140507.GG27444@suselix.suse.de>
References: <20160405071253.GB27444@suselix.suse.de>
 <570378FC.3030701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570378FC.3030701@redhat.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Apr 05, 2016 at 10:36:12AM +0200, Zdenek Kabelac wrote:
> Dne 5.4.2016 v 09:12 Andreas Herrmann napsal(a):
> >Hi,
> >
> >I've recently looked at performance behaviour of dm-cache and bcache.
> >I've repeatedly observed very low performance with dm-cache in
> >different tests. (Similar tests with bcache showed no such oddities.)
> >
> >To rule out user errors that might have caused this, I shortly describe
> >what I've done and observed.
> >
> >- tested kernel version: 4.5.0
> >
> >- backing device: 1.5 TB spinning drive
> >
> >- caching device: 128 GB SSD (used for metadata and cache and size
> >   of metadata part calculated based on
> >   https://www.redhat.com/archives/dm-devel/2012-December/msg00046.html)
> >
> >- my test procedure consisted of a sequence of tests performing fio
> >   runs with different data sets, fio randread performance (bandwidth
> >   and IOPS) were compared, fio was invoked using something like
> >
> >   fio --directory=/cached-device --rw=randread --name=fio-1 \
> >     --size=50G --group_reporting --ioengine=libaio \
> >     --direct=1 --iodepth=1 --runtime=40 --numjobs=1
> >
> >   I've iterated over 10 runs for each of numjobs=1,2,3 and varied the
> >   name parameter to operate with different data sets.
> >
> >   This procedure implied that with 3 jobs the underlying data set for
> >   the test consisted of 3 files with 50G each which exceeds the size
> >   of the caching device.
> >
> >- Between some tests I've tried to empty the cache. For dm-cache I did
> >   this by unmounting the "compound" cache device, switching to cleaner
> >   target, zeroing metadata part of the caching device, recreating
> >   caching device and finally recreating the compound cache device
> >   (during this procedure I kept the backing device unmodified).
> >
> >   I used dmsetup status to check for success of this operation
> >   (checking for #used_cache_blocks).
> >   If there is an easier way to do this please let me know -- If it's
> >   documented I've missed it.
> >
> >- dm-cache parameters:
> >   * cache_mode: writeback
> >   * block size: 512 sectors
> >   * migration_threshold 2048 (default)
> >
> >I've observed two oddities:
> >
> >   (1) Only fio tests with the first data set created (and thus
> >   initially occupying the cache) showed decent performance
> >   results. Subsequent fio tests with another data set showed poor
> >   performance. I think this indicates that SMQ policy does not
> >   properly promote/demote data to/from caching device in my tests.
> >
> >   (2) I've seen results where performance was actually below "native"
> >   (w/o caching) performance of the backing device. I think that this
> >   should not happen. If a data access falls back to the backing device
> >   due to a cache miss I would have expected to see almost the
> >   performance of the backing device. Maybe this points to a
> >   performance issue in SMQ -- spending too much time in policy code
> >   before falling back to the backing device.
> >
> >I've tried to figure out what actually happened in SMQ code in these
> >cases - but eventually dismissed this. Next I want to check whether
> >there might be a flaw in my test setup/dm-cache configuration.
> 
> Hi
> 
> The dm-cache SMQ/MQ is a 'slow moving' hot-spot cache.

Yep that is mentioned in some places in the source code with the
hot-spot handling stuff.

> So before the block is 'promoted' to the cache - there needs to be a
> reason for it - and it's not a plain single read.

It's not obvious to me when a block finally gets promoted. I had the
impression that once the cache is filled with data, getting new data
into the cache takes quite some time.

> So if the other cache promotes the block to the cache with a single
> block access you may observe different performance.

Yep, that is what my measurements suggest.

> dm-cache is not targeted for 'quick' promoting of read blocks into a
> cache - rather 'slow' moving of often used blocks.

If I completely abandon to use a set of test files (which defined
hotspot blocks initially) and switch to a new set of test files this
"slow" moving of often used (in the past) blocks might be the cause of
the lower than expected (by me) performance in my tests. Would it be
possible to tune this behaviour to allow quicker promotion if a user
thinks he requires it for his workload?

> Unsure how that fits your testing environment and what you try to
> actually test?

Worst results for spinning disks are random accesses. I've seen some
dm-cache benchmark results (fio randread) that showed lower
performance than the underlying backing device itself. That was the
trigger for me to take a closer look at dm-cache and bcache and to do
some performance measurements esp. with random read I/O pattern.

I've observed two oddities (from my point of view) and either they are
due to setup errors, wrong expectations, or point to real issues that
might be worth to be looked at or to be aware of.
I think at least its worth to share my testing results.

> Regards
> 
> PS: 256K dm-cache blocks size is quite large - it really depends
> upon workload - min supported size is 32K - lvm2 defaults to 64K...

I had chosen 512 as block size because documenation mentioned it.

I've kicked off a test with the minimum block size.
Let's see whether that changes anything.


Thanks,

Andreas
