From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Wed, 21 Mar 2018 11:55:58 -0700
Message-ID: <20180321185558.GA18494@bombadil.infradead.org>
References: <alpine.LRH.2.02.1803201510030.21066@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803201536590.28319@nuc-kabylake>
	<alpine.LRH.2.02.1803201740280.21066@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803211024220.2175@nuc-kabylake>
	<alpine.LRH.2.02.1803211153320.16017@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803211226350.3174@nuc-kabylake>
	<alpine.DEB.2.20.1803211233290.3384@nuc-kabylake>
	<20180321174937.GF4780@bombadil.infradead.org>
	<alpine.LRH.2.02.1803211406180.26409@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803211335240.13978@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1803211335240.13978@nuc-kabylake>
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
Cc: Mike Snitzer <msnitzer@redhat.com>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

On Wed, Mar 21, 2018 at 01:40:31PM -0500, Christopher Lameter wrote:
> On Wed, 21 Mar 2018, Mikulas Patocka wrote:
> 
> > > > F.e. you could optimize the allcations > 2x PAGE_SIZE so that they do not
> > > > allocate powers of two pages. It would be relatively easy to make
> > > > kmalloc_large round the allocation to the next page size and then allocate
> > > > N consecutive pages via alloc_pages_exact() and free the remainder unused
> > > > pages or some such thing.
> >
> > alloc_pages_exact() has O(n*log n) complexity with respect to the number
> > of requested pages. It would have to be reworked and optimized if it were
> > to be used for the dm-bufio cache. (it could be optimized down to O(log n)
> > if it didn't split the compound page to a lot of separate pages, but split
> > it to a power-of-two clusters instead).
> 
> Well then a memory pool of page allocator requests may address that issue?
> 
> Have a look at include/linux/mempool.h.

That's not what mempool is for.  mempool is a cache of elements that were
allocated from slab in the first place.  (OK, technically, you don't have
to use slab as the allocator, but since there is no allocator that solves
this problem, mempool doesn't solve the problem either!)

> > BTW. it could be possible to open the file
> > "/sys/kernel/slab/<cache>/order" from the dm-bufio kernel driver and write
> > the requested value there, but it seems very dirty. It would be better to
> > have a kernel interface for that.
> 
> Hehehe you could directly write to the kmem_cache structure and increase
> the order. AFAICT this would be dirty but work.
> 
> But still the increased page order will get you into trouble with
> fragmentation when the system runs for a long time. That is the reason we
> try to limit the allocation sizes coming from the slab allocator.

Right; he has a fallback already (vmalloc).  So ... let's just add the
interface to allow slab caches to have their order tuned by users who
really know what they're doing?
