From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] kvmalloc: always use vmalloc if CONFIG_DEBUG_VM
Date: Thu, 3 May 2018 13:32:08 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1805031325020.28479@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180420130852.GC16083@dhcp22.suse.cz> <alpine.LRH.2.02.1804201635180.25408@file01.intranet.prod.int.rdu2.redhat.com> <20180420210200.GH10788@bombadil.infradead.org> <alpine.LRH.2.02.1804201704580.25408@file01.intranet.prod.int.rdu2.redhat.com>
 <20180421144757.GC14610@bombadil.infradead.org> <alpine.LRH.2.02.1804221733520.7995@file01.intranet.prod.int.rdu2.redhat.com> <20180423151545.GU17484@dhcp22.suse.cz> <alpine.LRH.2.02.1804232006540.2299@file01.intranet.prod.int.rdu2.redhat.com>
 <20180424133146.GG17484@dhcp22.suse.cz> <alpine.LRH.2.02.1804241107010.31601@file01.intranet.prod.int.rdu2.redhat.com> <20180424161242.GK17484@dhcp22.suse.cz> <alpine.LRH.2.02.1804241229410.23702@file01.intranet.prod.int.rdu2.redhat.com>
 <20180501173626.4593a87d0d64f6cc9d219d20@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180501173626.4593a87d0d64f6cc9d219d20@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Matthew Wilcox <willy@infradead.org>, David Miller <davem@davemloft.net>, linux-mm@kvack.org, eric.dumazet@gmail.com, edumazet@google.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, virtualization@lists.linux-foundation.org, dm-devel@redhat.com, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids



On Tue, 1 May 2018, Andrew Morton wrote:

> On Tue, 24 Apr 2018 12:33:01 -0400 (EDT) Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
> > 
> > 
> > On Tue, 24 Apr 2018, Michal Hocko wrote:
> > 
> > > On Tue 24-04-18 11:30:40, Mikulas Patocka wrote:
> > > > 
> > > > 
> > > > On Tue, 24 Apr 2018, Michal Hocko wrote:
> > > > 
> > > > > On Mon 23-04-18 20:25:15, Mikulas Patocka wrote:
> > > > > 
> > > > > > Fixing __vmalloc code 
> > > > > > is easy and it doesn't require cooperation with maintainers.
> > > > > 
> > > > > But it is a hack against the intention of the scope api.
> > > > 
> > > > It is not!
> > > 
> > > This discussion simply doesn't make much sense it seems. The scope API
> > > is to document the scope of the reclaim recursion critical section. That
> > > certainly is not a utility function like vmalloc.
> > 
> > That 15-line __vmalloc bugfix doesn't prevent you (or any other kernel 
> > developer) from converting the code to the scope API. You make nonsensical 
> > excuses.
> > 
> 
> Fun thread!
> 
> Winding back to the original problem, I'd state it as
> 
> - Caller uses kvmalloc() but passes the address into vmalloc-naive
>   DMA API and
> 
> - Caller uses kvmalloc() but passes the address into kfree()
> 
> Yes?
> 
> If so, then...
> 
> Is there a way in which, in the kvmalloc-called-kmalloc path, we can
> tag the slab-allocated memory with a "this memory was allocated with
> kvmalloc()" flag?  I *think* there's extra per-object storage available
> with suitable slab/slub debugging options?  Perhaps we could steal one
> bit from the redzone, dunno.
> 
> If so then we can
> 
> a) set that flag in kvmalloc() if the kmalloc() call succeeded
> 
> b) check for that flag in the DMA code, WARN if it is set.
> 
> c) in kvfree(), clear that flag before calling kfree()
> 
> d) in kfree(), check for that flag and go WARN() if set.
> 
> So both potential bugs are detected all the time, dependent upon
> CONFIG_SLUB_DEBUG (and perhaps other slub config options).

Yes, it would be good. You also need to check it in virt_to_phys(), 
virt_to_pfn(), __pa() and maybe some others.

Mikulas
