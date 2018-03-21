From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Wed, 21 Mar 2018 14:36:58 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1803211425330.26409@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1803200954590.18995@file01.intranet.prod.int.rdu2.redhat.com>
	<20180320173512.GA19669@bombadil.infradead.org>
	<alpine.DEB.2.20.1803201250480.27540@nuc-kabylake>
	<alpine.LRH.2.02.1803201510030.21066@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803201536590.28319@nuc-kabylake>
	<alpine.LRH.2.02.1803201740280.21066@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803211024220.2175@nuc-kabylake>
	<alpine.LRH.2.02.1803211153320.16017@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803211226350.3174@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.DEB.2.20.1803211226350.3174@nuc-kabylake>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Christopher Lameter <cl@linux.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids



On Wed, 21 Mar 2018, Christopher Lameter wrote:

> On Wed, 21 Mar 2018, Mikulas Patocka wrote:
> 
> > > You should not be using the slab allocators for these. Allocate higher
> > > order pages or numbers of consecutive smaller pagess from the page
> > > allocator. The slab allocators are written for objects smaller than page
> > > size.
> >
> > So, do you argue that I need to write my own slab cache functionality
> > instead of using the existing slab code?
> 
> Just use the existing page allocator calls to allocate and free the
> memory you need.
> 
> > I can do it - but duplicating code is bad thing.
> 
> There is no need to duplicate anything. There is lots of infrastructure
> already in the kernel. You just need to use the right allocation / freeing
> calls.

So, what would you recommend for allocating 640KB objects while minimizing 
wasted space?
* alloc_pages - rounds up to the next power of two
* kmalloc - rounds up to the next power of two
* alloc_pages_exact - O(n*log n) complexity; and causes memory 
  fragmentation if used excesivelly
* vmalloc - horrible performance (modifies page tables and that causes 
  synchronization across all CPUs)

anything else?

The slab cache with large order seems as a best choice for this.

> > > What kind of problem could be caused here?
> >
> > Unlocked accesses are generally considered bad. For example, see this
> > piece of code in calculate_sizes:
> >         s->allocflags = 0;
> >         if (order)
> >                 s->allocflags |= __GFP_COMP;
> >
> >         if (s->flags & SLAB_CACHE_DMA)
> >                 s->allocflags |= GFP_DMA;
> >
> >         if (s->flags & SLAB_RECLAIM_ACCOUNT)
> >                 s->allocflags |= __GFP_RECLAIMABLE;
> >
> > If you are running this while the cache is in use (i.e. when the user
> > writes /sys/kernel/slab/<cache>/order), then other processes will see
> > invalid s->allocflags for a short time.
> 
> Calculating sizes is done when the slab has only a single accessor. Thus
> no locking is neeed.

The calculation is done whenever someone writes to 
"/sys/kernel/slab/*/order"

And you can obviously write to that file why the slab cache is in use. Try 
it.

So, the function calculate_sizes can actually race with allocation from 
the slab cache.

> Changing the size of objects in a slab cache when there is already a set
> of object allocated and under management by the slab cache would
> cause the allocator to fail and lead to garbled data.

I am not talking about changing the size of objects in a slab cache. I am 
talking about changing the allocation order of a slab cache while the 
cache is in use. This can be done with the sysfs interface.

Mikulas
