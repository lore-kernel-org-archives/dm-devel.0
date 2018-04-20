From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] kvmalloc: always use vmalloc if CONFIG_DEBUG_VM
Date: Fri, 20 Apr 2018 08:20:23 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804200817230.22382@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1804181029270.19294@file01.intranet.prod.int.rdu2.redhat.com> <3e65977e-53cd-bf09-bc4b-0ce40e9091fe@gmail.com> <alpine.LRH.2.02.1804181218270.19136@file01.intranet.prod.int.rdu2.redhat.com> <20180418.134651.2225112489265654270.davem@davemloft.net>
 <alpine.LRH.2.02.1804181350050.17942@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1804191207380.31175@file01.intranet.prod.int.rdu2.redhat.com> <20180420114712.GB10788@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180420114712.GB10788@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: David Miller <davem@davemloft.net>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, eric.dumazet@gmail.com, edumazet@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids



On Fri, 20 Apr 2018, Matthew Wilcox wrote:

> On Thu, Apr 19, 2018 at 12:12:38PM -0400, Mikulas Patocka wrote:
> > Unfortunatelly, some kernel code has bugs - it uses kvmalloc and then
> > uses DMA-API on the returned memory or frees it with kfree. Such bugs were
> > found in the virtio-net driver, dm-integrity or RHEL7 powerpc-specific
> > code.
> 
> Maybe it's time to have the SG code handle vmalloced pages?  This is
> becoming more and more common with vmapped stacks (and some of our
> workarounds are hideous -- allocate 4 bytes with kmalloc because we can't
> DMA onto the stack any more?).  We already have a few places which do
> handle sgs of vmalloced addresses, such as the nx crypto driver:
> 
>         if (is_vmalloc_addr(start_addr))
>                 sg_addr = page_to_phys(vmalloc_to_page(start_addr))
>                           + offset_in_page(sg_addr);
>         else
>                 sg_addr = __pa(sg_addr);
> 
> and videobuf:
> 
>                 pg = vmalloc_to_page(virt);
>                 if (NULL == pg)
>                         goto err;
>                 BUG_ON(page_to_pfn(pg) >= (1 << (32 - PAGE_SHIFT)));
>                 sg_set_page(&sglist[i], pg, PAGE_SIZE, 0);
> 
> Yes, there's the potential that we have to produce two SG entries for a
> virtually contiguous region if it crosses a page boundary, and our APIs
> aren't set up right to make it happen.  But this is something we should
> consider fixing ... otherwise we'll end up with dozens of driver hacks.
> The videobuf implementation was already copy-and-pasted into the saa7146
> driver, for example.

What if the device requires physically contiguous area and the vmalloc 
area crosses a page? Will you use a bounce buffer? Where do you allocate 
the bounce buffer from? What if you run out of bounce buffers?

Mikulkas
