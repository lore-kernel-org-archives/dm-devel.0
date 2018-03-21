From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Wed, 21 Mar 2018 10:49:37 -0700
Message-ID: <20180321174937.GF4780@bombadil.infradead.org>
References: <alpine.LRH.2.02.1803200954590.18995@file01.intranet.prod.int.rdu2.redhat.com>
	<20180320173512.GA19669@bombadil.infradead.org>
	<alpine.DEB.2.20.1803201250480.27540@nuc-kabylake>
	<alpine.LRH.2.02.1803201510030.21066@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803201536590.28319@nuc-kabylake>
	<alpine.LRH.2.02.1803201740280.21066@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803211024220.2175@nuc-kabylake>
	<alpine.LRH.2.02.1803211153320.16017@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803211226350.3174@nuc-kabylake>
	<alpine.DEB.2.20.1803211233290.3384@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1803211233290.3384@nuc-kabylake>
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

On Wed, Mar 21, 2018 at 12:39:33PM -0500, Christopher Lameter wrote:
> One other thought: If you want to improve the behavior for large scale
> objects allocated through kmalloc/kmemcache then we would certainly be
> glad to entertain those ideas.
> 
> F.e. you could optimize the allcations > 2x PAGE_SIZE so that they do not
> allocate powers of two pages. It would be relatively easy to make
> kmalloc_large round the allocation to the next page size and then allocate
> N consecutive pages via alloc_pages_exact() and free the remainder unused
> pages or some such thing.

I don't know if that's a good idea.  That will contribute to fragmentation
if the allocation is held onto for a short-to-medium length of time.
If the allocation is for a very long period of time then those pages
would have been unavailable anyway, but if the user of the tail pages
holds them beyond the lifetime of the large allocation, then this is
probably a bad tradeoff to make.

I do see Mikulas' use case as interesting, I just don't know whether it's
worth changing slab/slub to support it.  At first blush, other than the
sheer size of the allocations, it's a good fit.
