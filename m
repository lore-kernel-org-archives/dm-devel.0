From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH 0/6] Overhaul memalloc_no*
Date: Sat, 27 Jun 2020 09:09:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.2006270848540.14350@file01.intranet.prod.int.rdu2.redhat.com>
References: <20200625113122.7540-1-willy@infradead.org> <alpine.LRH.2.02.2006261058250.11899@file01.intranet.prod.int.rdu2.redhat.com> <20200626230847.GI2005@dread.disaster.area>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200626230847.GI2005@dread.disaster.area>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids



On Sat, 27 Jun 2020, Dave Chinner wrote:

> On Fri, Jun 26, 2020 at 11:02:19AM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > I suggest to join memalloc_noio and memalloc_nofs into just one flag that 
> > prevents both filesystem recursion and i/o recursion.
> > 
> > Note that any I/O can recurse into a filesystem via the loop device, thus 
> > it doesn't make much sense to have a context where PF_MEMALLOC_NOFS is set 
> > and PF_MEMALLOC_NOIO is not set.
> 
> Correct me if I'm wrong, but I think that will prevent swapping from
> GFP_NOFS memory reclaim contexts.

Yes.

> IOWs, this will substantially
> change the behaviour of the memory reclaim system under sustained
> GFP_NOFS memory pressure. Sustained GFP_NOFS memory pressure is
> quite common, so I really don't think we want to telling memory
> reclaim "you can't do IO at all" when all we are trying to do is
> prevent recursion back into the same filesystem.

So, we can define __GFP_ONLY_SWAP_IO and __GFP_IO.

> Given that the loop device IO path already operates under
> memalloc_noio context, (i.e. the recursion restriction is applied in
> only the context that needs is) I see no reason for making that a
> global reclaim limitation....

I think this is a problem.

Suppose that a filesystem does GFP_NOFS allocation, the allocation 
triggers an IO and waits for it to finish, the loop device driver 
redirects the IO to the same filesystem that did the GFP_NOFS allocation.

I saw this deadlock in the past in the dm-bufio subsystem - see the commit 
9d28eb12447ee08bb5d1e8bb3195cf20e1ecd1c0 that fixed it.

Other subsystems that do IO in GFP_NOFS context may deadlock just like 
bufio.

Mikulas
