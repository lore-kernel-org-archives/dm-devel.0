From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH] slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Wed, 21 Mar 2018 13:58:39 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1803211357480.14119@nuc-kabylake>
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
	<20180321185558.GA18494@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180321185558.GA18494@bombadil.infradead.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Matthew Wilcox <willy@infradead.org>
Cc: Mike Snitzer <msnitzer@redhat.com>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

On Wed, 21 Mar 2018, Matthew Wilcox wrote:

> > Have a look at include/linux/mempool.h.
>
> That's not what mempool is for.  mempool is a cache of elements that were
> allocated from slab in the first place.  (OK, technically, you don't have
> to use slab as the allocator, but since there is no allocator that solves
> this problem, mempool doesn't solve the problem either!)

You can put the page allocator in there instead of a slab allocator.

> > But still the increased page order will get you into trouble with
> > fragmentation when the system runs for a long time. That is the reason we
> > try to limit the allocation sizes coming from the slab allocator.
>
> Right; he has a fallback already (vmalloc).  So ... let's just add the
> interface to allow slab caches to have their order tuned by users who
> really know what they're doing?

Ok thats trivial.
