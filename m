From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
Date: Tue, 30 Jun 2020 08:34:10 +1000
Message-ID: <20200629223410.GK2005@dread.disaster.area>
References: <20200625113122.7540-1-willy@infradead.org>
 <alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com>
 <20200626230847.GI2005@dread.disaster.area>
 <alpine.LRH.2.02.2006270848540.14350@file01.intranet.prod.int.rdu2.redhat.com>
 <20200629003550.GJ2005@dread.disaster.area>
 <alpine.LRH.2.02.2006290918030.11293@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.2006290918030.11293@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

On Mon, Jun 29, 2020 at 09:43:23AM -0400, Mikulas Patocka wrote:
> On Mon, 29 Jun 2020, Dave Chinner wrote:
> > On Sat, Jun 27, 2020 at 09:09:09AM -0400, Mikulas Patocka wrote:
> > > On Sat, 27 Jun 2020, Dave Chinner wrote:
> > > > On Fri, Jun 26, 2020 at 11:02:19AM -0400, Mikulas Patocka wrote:
> > > > > Hi
> > > > > 
> > > > > I suggest to join memalloc_noio and memalloc_nofs into just one flag that 
> > > > > prevents both filesystem recursion and i/o recursion.
> > > > > 
> > > > > Note that any I/O can recurse into a filesystem via the loop device, thus 
> > > > > it doesn't make much sense to have a context where PF_MEMALLOC_NOFS is set 
> > > > > and PF_MEMALLOC_NOIO is not set.
> > > > 
> > > > Correct me if I'm wrong, but I think that will prevent swapping from
> > > > GFP_NOFS memory reclaim contexts.
> > > 
> > > Yes.
> > > 
> > > > IOWs, this will substantially
> > > > change the behaviour of the memory reclaim system under sustained
> > > > GFP_NOFS memory pressure. Sustained GFP_NOFS memory pressure is
> > > > quite common, so I really don't think we want to telling memory
> > > > reclaim "you can't do IO at all" when all we are trying to do is
> > > > prevent recursion back into the same filesystem.
> > > 
> > > So, we can define __GFP_ONLY_SWAP_IO and __GFP_IO.
> > 
> > Uh, why?
> > 
> > Exactly what problem are you trying to solve here?
> 
> This:
> 
> 1. The filesystem does a GFP_NOFS allocation.
> 2. The allocation calls directly a dm-bufio shrinker.
> 3. The dm-bufio shrinker sees that there is __GFP_IO set, so it assumes 
>    that it can do I/O. It selects some dirty buffers, writes them back and 
>    waits for the I/O to finish.

And so you are doing IO in a GFP_NOFS context because someone thought
the block layer can't recurse back into filesystems? That's a broken
assumption and has been since the loop device was introduced over a
couple of decades ago. I mean, the dm-bufio IO submission path uses
GFP_NOIO for obvious reasons, but once it's in the next device down
it loses all control of the submission context.

This is what I mean about "looking at reclaim contexts above the
current layer is a Big Red Flag"? The fundamental assumption of
dm-bufio that it can issue IO in GFP_NOFS context and not have a
lower layer recurse back into a filesystem has always been
incorrect. Just because the loop device now does GFP_NOIO
allocation, that doesn't mean what dm-bufio is doing in this
shrinker is correct or valid.

Because, as you point out:

> 4. The dirty buffers belong to a loop device.
> 5. The loop device thread calls the filesystem that did the GFP_NOFS 
>    allocation in step 1 (and that is still waiting for the allocation to 
>    succeed).
> Note that setting PF_MEMALLOC_NOIO on the loop thread won't help with this 
> deadlock.

Right, re-entering the filesystem might block on a lock, IO, memory
allocation, journal space reservation, etc. Indeed, it might not
even be able to issue transactions because the allocating context is
using GFP_NOFS because it is already running a transaction.

> Do you argue that this is a bug in dm-bufio? Or a bug in the kernel? Or 
> that it can't happen?

That's a bug in dm-bufio - dm is a layered block device and so has
_always_ been able to have filesystems both above and below
it in the storage stack. i.e. the assumption that there is no
filesystem context under the DM layers has always been wrong.

i.e. the memory reclaim context specfically directed dm-bufio that
whatever the shrinker does, it must not recurse into the filesystem
layer. It is the responsibility of the shrinker to obey the
constraints it was given by memory reclaim, and the dm-bufio
shrinker's assumption that there cannot be a filesystem below the DM
device violates this directive because, quite clearly, there can be
filesystems underneath DM devices.

IOWs, assuming that you can issue and block on IO from a -layered
block device- in GFP_NOFS shrinker context is flawed.  i.e. Anything
that presents as a block device that is layered on top of another
block device can recurse into a filesystem as they can sit on top of
a loop device. This has always been the case, and that means the
assumptions the dm-bufio shrinker is making about what it can do in
GFP_NOFS shrinker context has always been incorrect.

Remember that I explained "you should not block kswapd" in this
shrinker a year ago?

| What follows from that, and is pertinent for in this situation, is
| that if you don't block kswapd, then other reclaim contexts are not
| going to get stuck waiting for it regardless of the reclaim context
| they use.

https://lore.kernel.org/linux-fsdevel/20190809215733.GZ7777@dread.disaster.area/

If you did that when I suggested it, this problem would be solved.
i.e. The only way to fix this problem once adn for all is to stop
using the shrinker as a mechanism to issue and wait on IO. If you
need background writeback of dirty buffers, do it from a
WQ_MEM_RECLAIM workqueue that isn't directly in the memory reclaim
path and so can issue writeback and block safely from a GFP_KERNEL
context. Kick the workqueue from the shrinker context, but get rid
of the IO submission and waiting from the shrinker and all the
GFP_NOFS memory reclaim recursion problems go away.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
