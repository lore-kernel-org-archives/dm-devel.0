From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] kvmalloc: always use vmalloc if CONFIG_DEBUG_VM
Date: Thu, 19 Apr 2018 17:19:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804191716100.10099@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1804181029270.19294@file01.intranet.prod.int.rdu2.redhat.com>
	<3e65977e-53cd-bf09-bc4b-0ce40e9091fe@gmail.com>
	<alpine.LRH.2.02.1804181218270.19136@file01.intranet.prod.int.rdu2.redhat.com>
	<20180418.134651.2225112489265654270.davem@davemloft.net>
	<alpine.LRH.2.02.1804181350050.17942@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1804191207380.31175@file01.intranet.prod.int.rdu2.redhat.com>
	<20180419124751.8884e516e99825d83da3d87a@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180419124751.8884e516e99825d83da3d87a@linux-foundation.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, edumazet@google.com, bhutchings@solarflare.com, David Miller <davem@davemloft.net>, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids



On Thu, 19 Apr 2018, Andrew Morton wrote:

> On Thu, 19 Apr 2018 12:12:38 -0400 (EDT) Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > The kvmalloc function tries to use kmalloc and falls back to vmalloc if
> > kmalloc fails.
> > 
> > Unfortunatelly, some kernel code has bugs - it uses kvmalloc and then
> > uses DMA-API on the returned memory or frees it with kfree. Such bugs were
> > found in the virtio-net driver, dm-integrity or RHEL7 powerpc-specific
> > code.
> > 
> > These bugs are hard to reproduce because vmalloc falls back to kmalloc
> > only if memory is fragmented.
> 
> Yes, that's nasty.
> 
> > In order to detect these bugs reliably I submit this patch that changes
> > kvmalloc to always use vmalloc if CONFIG_DEBUG_VM is turned on.
> > 
> > ...
> >
> > --- linux-2.6.orig/mm/util.c	2018-04-18 15:46:23.000000000 +0200
> > +++ linux-2.6/mm/util.c	2018-04-18 16:00:43.000000000 +0200
> > @@ -395,6 +395,7 @@ EXPORT_SYMBOL(vm_mmap);
> >   */
> >  void *kvmalloc_node(size_t size, gfp_t flags, int node)
> >  {
> > +#ifndef CONFIG_DEBUG_VM
> >  	gfp_t kmalloc_flags = flags;
> >  	void *ret;
> >  
> > @@ -426,6 +427,7 @@ void *kvmalloc_node(size_t size, gfp_t f
> >  	 */
> >  	if (ret || size <= PAGE_SIZE)
> >  		return ret;
> > +#endif
> >  
> >  	return __vmalloc_node_flags_caller(size, node, flags,
> >  			__builtin_return_address(0));
> 
> Well, it doesn't have to be done at compile-time, does it?  We could
> add a knob (in debugfs, presumably) which enables this at runtime. 
> That's far more user-friendly.

But who will turn it on in debugfs? It should be default for debugging 
kernels, so that users using them would report the error.

Conditioning it on CONFIG_DEBUG_SG is better than CONFIG_DEBUG_VM, it will 
print a stacktrace where the incorrect use happened.

Mikulas
