From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Tue, 17 Apr 2018 14:53:45 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804171453190.26973@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1803201740280.21066@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1803211425330.26409@file01.intranet.prod.int.rdu2.redhat.com>
	<20c58a03-90a8-7e75-5fc7-856facfb6c8a@suse.cz>
	<20180413151019.GA5660@redhat.com>
	<ee8807ff-d650-0064-70bf-e1d77fa61f5c@suse.cz>
	<20180416142703.GA22422@redhat.com>
	<alpine.LRH.2.02.1804161031300.24222@file01.intranet.prod.int.rdu2.redhat.com>
	<20180416144638.GA22484@redhat.com>
	<alpine.LRH.2.02.1804161054410.17807@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1804161018030.9397@nuc-kabylake>
	<alpine.LRH.2.02.1804161123400.17807@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1804161043430.9622@nuc-kabylake>
	<alpine.LRH.2.02.1804161532480.19492@file01.intranet.prod.int.rdu2.redhat.com>
	<b0e6ccf6-06ce-e50b-840e-c8d3072382fd@suse.cz>
	<alpine.LRH.2.02.1804161650170.7237@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1804170939420.17557@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.DEB.2.20.1804170939420.17557@nuc-kabylake>
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
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids



On Tue, 17 Apr 2018, Christopher Lameter wrote:

> On Mon, 16 Apr 2018, Mikulas Patocka wrote:
> 
> > dm-bufio deals gracefully with allocation failure, because it preallocates
> > some buffers with vmalloc, but other subsystems may not deal with it and
> > they cound return ENOMEM randomly or misbehave in other ways. So, the
> > "SLAB_MINIMIZE_WASTE" flag is also saying that the allocation may fail and
> > the caller is prepared to deal with it.
> >
> > The slub subsystem does actual fallback to low-order when the allocation
> > fails (it allows different order for each slab in the same cache), but
> > slab doesn't fallback and you get NULL if higher-order allocation fails.
> > So, SLAB_MINIMIZE_WASTE is needed for slab because it will just randomly
> > fail with higher order.
> 
> Fix Slab instead of adding a flag that is only useful for one allocator?

Slab assumes that all slabs have the same order, so it's not so easy to 
fix it.

Mikulas
