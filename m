From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH RESEND] slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Tue, 17 Apr 2018 13:26:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804171318010.5023@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1803201740280.21066@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.20.1803211024220.2175@nuc-kabylake> <alpine.LRH.2.02.1803211153320.16017@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.20.1803211226350.3174@nuc-kabylake>
 <alpine.LRH.2.02.1803211425330.26409@file01.intranet.prod.int.rdu2.redhat.com> <20c58a03-90a8-7e75-5fc7-856facfb6c8a@suse.cz> <20180413151019.GA5660@redhat.com> <ee8807ff-d650-0064-70bf-e1d77fa61f5c@suse.cz> <20180416142703.GA22422@redhat.com>
 <alpine.LRH.2.02.1804161031300.24222@file01.intranet.prod.int.rdu2.redhat.com> <20180416144638.GA22484@redhat.com> <alpine.LRH.2.02.1804161530360.19492@file01.intranet.prod.int.rdu2.redhat.com> <alpine.DEB.2.20.1804170940340.17557@nuc-kabylake>
 <f8f736fe-9e0e-acd2-8040-f4f25ea5a7a2@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f8f736fe-9e0e-acd2-8040-f4f25ea5a7a2@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Christopher Lameter <cl@linux.com>, Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Tue, 17 Apr 2018, Vlastimil Babka wrote:

> On 04/17/2018 04:45 PM, Christopher Lameter wrote:
> > On Mon, 16 Apr 2018, Mikulas Patocka wrote:
> > 
> >> This patch introduces a flag SLAB_MINIMIZE_WASTE for slab and slub. This
> >> flag causes allocation of larger slab caches in order to minimize wasted
> >> space.
> >>
> >> This is needed because we want to use dm-bufio for deduplication index and
> >> there are existing installations with non-power-of-two block sizes (such
> >> as 640KB). The performance of the whole solution depends on efficient
> >> memory use, so we must waste as little memory as possible.
> > 
> > Hmmm. Can we come up with a generic solution instead?
> 
> Yes please.
> 
> > This may mean relaxing the enforcement of the allocation max order a bit
> > so that we can get dense allocation through higher order allocs.
> > 
> > But then higher order allocs are generally seen as problematic.
> 
> I think in this case they are better than wasting/fragmenting 384kB for
> 640kB object.

Wasting 37% of memory is still better than the kernel randomly returning 
-ENOMEM when higher-order allocation fails.

> > That
> > means that callers need to be able to tolerate failures.
> 
> Is it any different from now? I suppose there would still be
> smallest-order fallback involved in sl*b itself? And if your allocation
> is so large it can fail even with the fallback (i.e. >= costly order),
> you need to tolerate failures anyway?
> 
> One corner case I see is if there is anyone who would rather use their
> own fallback instead of the space-wasting smallest-order fallback.
> Maybe we could map some GFP flag to indicate that.

For example, if you create a cache with 17KB objects, the slab subsystem 
will pad it up to 32KB. You are wasting almost 1/2 memory, but the 
allocation is realiable and it won't fail.

If you use order higher than 32KB, you get less wasted memory, but you 
also get random -ENOMEMs (yes, we had a problem in dm-thin that it was 
randomly failing during initialization due to 64KB allocation).

Mikulas
