From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: System freezes after OOM
Date: Wed, 13 Jul 2016 10:18:35 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1607131004340.31769__14662.235583137$1468427774$gmane$org@file01.intranet.prod.int.rdu2.redhat.com>
References: <57837CEE.1010609@redhat.com>
	<f80dc690-7e71-26b2-59a2-5a1557d26713@redhat.com>
	<9be09452-de7f-d8be-fd5d-4a80d1cd1ba3@redhat.com>
	<alpine.LRH.2.02.1607111027080.14327@file01.intranet.prod.int.rdu2.redhat.com>
	<20160712064905.GA14586@dhcp22.suse.cz>
	<alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com>
	<2d5e1f84-e886-7b98-cb11-170d7104fd13@I-love.SAKURA.ne.jp>
	<20160713133955.GK28723@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-To: dm-devel@redhat.com
Resent-Message-ID: <6fd68214-1c00-4db9-2790-5f0dc7bc68ca@redhat.com>
In-Reply-To: <20160713133955.GK28723@dhcp22.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Michal Hocko <mhocko@kernel.org>
Cc: Stanislav Kozina <skozina@redhat.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, David Rientjes <rientjes@google.com>, Ondrej Kozina <okozina@redhat.com>, Jerome Marchand <jmarchan@redhat.com>
List-Id: dm-devel.ids



On Wed, 13 Jul 2016, Michal Hocko wrote:

> [CC David]
> 
> > > It is caused by the commit f9054c70d28bc214b2857cf8db8269f4f45a5e23. 
> > > Prior to this commit, mempool allocations set __GFP_NOMEMALLOC, so 
> > > they never exhausted reserved memory. With this commit, mempool 
> > > allocations drop __GFP_NOMEMALLOC, so they can dig deeper (if the 
> > > process has PF_MEMALLOC, they can bypass all limits).
> > 
> > I wonder whether commit f9054c70d28bc214 ("mm, mempool: only set 
> > __GFP_NOMEMALLOC if there are free elements") is doing correct thing. 
> > It says
> > 
> >     If an oom killed thread calls mempool_alloc(), it is possible that 
> > it'll
> >     loop forever if there are no elements on the freelist since
> >     __GFP_NOMEMALLOC prevents it from accessing needed memory reserves in
> >     oom conditions.
> 
> I haven't studied the patch very deeply so I might be missing something
> but from a quick look the patch does exactly what the above says.
> 
> mempool_alloc used to inhibit ALLOC_NO_WATERMARKS by default. David has
> only changed that to allow ALLOC_NO_WATERMARKS if there are no objects
> in the pool and so we have no fallback for the default __GFP_NORETRY
> request.

The swapper core sets the flag PF_MEMALLOC and calls generic_make_request 
to submit the swapping bio to the block driver. The device mapper driver 
uses mempools for all its I/O processing.

Prior to the patch f9054c70d28bc214b2857cf8db8269f4f45a5e23, mempool_alloc 
never exhausted the reserved memory - it tried to allocace first with 
__GFP_NOMEMALLOC (thus preventing the allocator from allocating below the 
limits), then it tried to allocate from the mempool reserve and if the 
mempool is exhausted, it waits until some structures are returned to the 
mempool.

After the patch f9054c70d28bc214b2857cf8db8269f4f45a5e23, __GFP_NOMEMALLOC 
is not used if the mempool is exhausted - and so repeated use of 
mempool_alloc (tohether with PF_MEMALLOC that is implicitly set) can 
exhaust all available memory.

The patch f9054c70d28bc214b2857cf8db8269f4f45a5e23 allows more paralellism 
(mempool_alloc waits less and proceeds more often), but the downside is 
that it exhausts all the memory. Bisection showed that those dm-crypt 
swapping failures were caused by that patch.

I think f9054c70d28bc214b2857cf8db8269f4f45a5e23 should be reverted - but 
first, we need to find out why does swapping fail if all the memory is 
exhausted - that is a separate bug that should be addressed first.

> > but we can allow mempool_alloc(__GFP_NOMEMALLOC) requests to access
> > memory reserves via below change, can't we?

There are no mempool_alloc(__GFP_NOMEMALLOC) requsts - mempool users don't 
use this flag.

Mikulas
