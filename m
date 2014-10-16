From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] slab: implement kmalloc guard
Date: Thu, 16 Oct 2014 10:55:34 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1410161049280.25043@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1409051833510.9790@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.11.1409080932490.20388@gentwo.org> <alpine.LRH.2.02.1409081041160.29432@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.11.1409081108190.20388@gentwo.org>
 <alpine.LRH.2.02.1409112211060.30537@file01.intranet.prod.int.rdu2.redhat.com> <20140915021133.GC2676@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20140915021133.GC2676@js1304-P5Q-DELUXE>
Sender: owner-linux-mm@kvack.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, Milan Broz <gmazyland@gmail.com>, kkolasa@winsoft.pl, dm-devel@redhat.com
List-Id: dm-devel.ids



On Mon, 15 Sep 2014, Joonsoo Kim wrote:

> On Thu, Sep 11, 2014 at 10:32:52PM -0400, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 8 Sep 2014, Christoph Lameter wrote:
> > 
> > > On Mon, 8 Sep 2014, Mikulas Patocka wrote:
> > > 
> > > > I don't know what you mean. If someone allocates 10000 objects with sizes
> > > > from 1 to 10000, you can't have 10000 slab caches - you can't have a slab
> > > > cache for each used size. Also - you can't create a slab cache in
> > > > interrupt context.
> > > 
> > > Oh you can create them up front on bootup. And I think only the small
> > > sizes matter. Allocations >=8K are pushed to the page allocator anyways.
> > 
> > Only for SLUB. For SLAB, large allocations are still use SLAB caches up to 
> > 4M. But anyway - having 8K preallocated slab caches is too much.
> > 
> > If you want to integrate this patch into the slab/slub subsystem, a better 
> > solution would be to store the exact size requested with kmalloc along the 
> > slab/slub object itself (before the preceding redzone). But it would 
> > result in duplicating the work - you'd have to repeat the logic in this 
> > patch three times - once for slab, once for slub and once for 
> > kmalloc_large/kmalloc_large_node.
> > 
> > I don't know if it would be better than this patch.
> 
> Hello,
> 
> Out of bound write could be detected by kernel address asanitizer(KASan).
> See following link.
> 
> https://lkml.org/lkml/2014/9/10/441
> 
> Although this patch also looks good to me, I think that KASan is
> better than this, because it could detect out of bound write and
> has more features for debugging.
> 
> Thanks.

Surely, KAsan detects more bugs. But it has also high overhead. The 
overhead of kmalloc guard is very low.

The kmalloc guard already helped to find one previously unknown bug: 
http://lkml.iu.edu/hypermail/linux/kernel/1409.1/02325.html

Mikulas

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
