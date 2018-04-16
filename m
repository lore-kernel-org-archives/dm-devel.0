From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Mon, 16 Apr 2018 11:25:30 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804161123400.17807@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1803201740280.21066@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803211024220.2175@nuc-kabylake>
	<alpine.LRH.2.02.1803211153320.16017@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1803211226350.3174@nuc-kabylake>
	<alpine.LRH.2.02.1803211425330.26409@file01.intranet.prod.int.rdu2.redhat.com>
	<20c58a03-90a8-7e75-5fc7-856facfb6c8a@suse.cz>
	<20180413151019.GA5660@redhat.com>
	<ee8807ff-d650-0064-70bf-e1d77fa61f5c@suse.cz>
	<20180416142703.GA22422@redhat.com>
	<alpine.LRH.2.02.1804161031300.24222@file01.intranet.prod.int.rdu2.redhat.com>
	<20180416144638.GA22484@redhat.com>
	<alpine.LRH.2.02.1804161054410.17807@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1804161018030.9397@nuc-kabylake>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.DEB.2.20.1804161018030.9397@nuc-kabylake>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids



On Mon, 16 Apr 2018, Christopher Lameter wrote:

> On Mon, 16 Apr 2018, Mikulas Patocka wrote:
> 
> > > Please clarify further, thanks!
> > > Mike
> >
> > Yes, using a slab cache currently doesn't avoid this rouding (it needs the
> > SLAB_MINIMIZE_WASTE patch to do that).
> 
> Or an increase in slab_max_order

But that will increase it for all slabs (often senselessly - i.e. 
kmalloc-4096 would have order 4MB).

I need to increase it just for dm-bufio slabs.

Mikulas
