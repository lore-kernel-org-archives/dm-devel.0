From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Tue, 20 Mar 2018 18:02:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1803201740280.21066@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1803200954590.18995@file01.intranet.prod.int.rdu2.redhat.com>
	<20180320173512.GA19669@bombadil.infradead.org>
	<alpine.DEB.2.20.1803201250480.27540@nuc-kabylake>
	<alpine.LRH.2.02.1803201510030.21066@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803201536590.28319@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.DEB.2.20.1803201536590.28319@nuc-kabylake>
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



On Tue, 20 Mar 2018, Christopher Lameter wrote:

> On Tue, 20 Mar 2018, Mikulas Patocka wrote:
> 
> > > Maybe do the same thing for SLAB?
> >
> > Yes, but I need to change it for a specific cache, not for all caches.
> 
> Why only some caches?

I need high order for the buffer cache that holds the deduplicated data. I 
don't need to force it system-wide.

> > When the order is greater than 3 (PAGE_ALLOC_COSTLY_ORDER), the allocation
> > becomes unreliable, thus it is a bad idea to increase slub_max_order
> > system-wide.
> 
> Well the allocations is more likely to fail that is true but SLUB will
> fall back to a smaller order should the page allocator refuse to give us
> that larger sized page.

Does SLAB have this fall-back too?

> > Another problem with slub_max_order is that it would pad all caches to
> > slub_max_order, even those that already have a power-of-two size (in that
> > case, the padding is counterproductive).
> 
> No it does not. Slub will calculate the configuration with the least byte
> wastage. It is not the standard order but the maximum order to be used.
> Power of two caches below PAGE_SIZE will have order 0.

Try to boot with slub_max_order=10 and you can see this in /proc/slabinfo:
kmalloc-8192         352    352   8192   32   64 : tunables    0    0    0 : slabdata     11     11      0
                                             ^^^^

So it rounds up power-of-two sizes to high orders unnecessarily. Without 
slub_max_order=10, the number of pages for the kmalloc-8192 cache is just 
8.

I observe the same pathological rounding in dm-bufio caches.

> There are some corner cases where extra metadata is needed per object or
> per page that will result in either object sizes that are no longer a
> power of two or in page sizes smaller than the whole page. Maybe you have
> a case like that? Can you show me a cache that has this issue?

Here I have a patch set that changes the dm-bufio subsystem to support 
buffer sizes that are not a power of two:
http://people.redhat.com/~mpatocka/patches/kernel/dm-bufio-arbitrary-sector-size/

I need to change the slub cache to minimize wasted space - i.e. when 
asking for a slab cache for 640kB objects, the slub system currently 
allocates 1MB per object and 384kB is wasted. This is the reason why I'm 
making this patch.

> > BTW. the function "order_store" in mm/slub.c modifies the structure
> > kmem_cache without taking any locks - is it a bug?
> 
> The kmem_cache structure was just allocated. Only one thread can access it
> thus no locking is necessary.

No - order_store is called when writing to /sys/kernel/slab/<cache>/order 
- you can modify order for any existing cache - and the modification 
happens without any locking.

Mikulas
