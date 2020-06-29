From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
Date: Mon, 29 Jun 2020 09:43:23 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006290918030.11293@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200625113122.7540-1-willy@infradead.org>
	<alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com>
	<20200626230847.GI2005@dread.disaster.area>
	<alpine.LRH.2.02.2006270848540.14350@file01.intranet.prod.int.rdu2.redhat.com>
	<20200629003550.GJ2005@dread.disaster.area>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200629003550.GJ2005@dread.disaster.area>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On Mon, 29 Jun 2020, Dave Chinner wrote:

> On Sat, Jun 27, 2020 at 09:09:09AM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Sat, 27 Jun 2020, Dave Chinner wrote:
> > 
> > > On Fri, Jun 26, 2020 at 11:02:19AM -0400, Mikulas Patocka wrote:
> > > > Hi
> > > > 
> > > > I suggest to join memalloc_noio and memalloc_nofs into just one flag that 
> > > > prevents both filesystem recursion and i/o recursion.
> > > > 
> > > > Note that any I/O can recurse into a filesystem via the loop device, thus 
> > > > it doesn't make much sense to have a context where PF_MEMALLOC_NOFS is set 
> > > > and PF_MEMALLOC_NOIO is not set.
> > > 
> > > Correct me if I'm wrong, but I think that will prevent swapping from
> > > GFP_NOFS memory reclaim contexts.
> > 
> > Yes.
> > 
> > > IOWs, this will substantially
> > > change the behaviour of the memory reclaim system under sustained
> > > GFP_NOFS memory pressure. Sustained GFP_NOFS memory pressure is
> > > quite common, so I really don't think we want to telling memory
> > > reclaim "you can't do IO at all" when all we are trying to do is
> > > prevent recursion back into the same filesystem.
> > 
> > So, we can define __GFP_ONLY_SWAP_IO and __GFP_IO.
> 
> Uh, why?
> 
> Exactly what problem are you trying to solve here?

This:

1. The filesystem does a GFP_NOFS allocation.
2. The allocation calls directly a dm-bufio shrinker.
3. The dm-bufio shrinker sees that there is __GFP_IO set, so it assumes 
   that it can do I/O. It selects some dirty buffers, writes them back and 
   waits for the I/O to finish.
4. The dirty buffers belong to a loop device.
5. The loop device thread calls the filesystem that did the GFP_NOFS 
   allocation in step 1 (and that is still waiting for the allocation to 
   succeed).

Note that setting PF_MEMALLOC_NOIO on the loop thread won't help with this 
deadlock.

Do you argue that this is a bug in dm-bufio? Or a bug in the kernel? Or 
that it can't happen?

> > I saw this deadlock in the past in the dm-bufio subsystem - see the commit 
> > 9d28eb12447ee08bb5d1e8bb3195cf20e1ecd1c0 that fixed it.
> 
> 2014?
> 
> /me looks closer.
> 
> Hmmm. Only sent to dm-devel, no comments, no review, just merged.
> No surprise that nobody else actually knows about this commit. Well,
> time to review it ~6 years after it was merged....
> 
> | dm-bufio tested for __GFP_IO. However, dm-bufio can run on a loop block
> | device that makes calls into the filesystem. If __GFP_IO is present and
> | __GFP_FS isn't, dm-bufio could still block on filesystem operations if it
> | runs on a loop block device.
> 
> OK, so from an architectural POV, this commit is fundamentally
> broken - block/device layer allocation should not allow relcaim
> recursion into filesystems because filesystems are dependent on
> the block layer making forwards progress. This commit is trying to
> work around the loop device doing GFP_KERNEL/GFP_NOFS context
> allocation back end IO path of the loop device. This part of the
> loop device is a block device, so needs to run under GFP_NOIO
> context.

I agree that it is broken, but it fixes the above deadlock.

Mikulas
