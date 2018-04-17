From: Christopher Lameter <cl@linux.com>
Subject: Re: slab: introduce the flag SLAB_MINIMIZE_WASTE
Date: Tue, 17 Apr 2018 09:47:58 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1804170945450.17557@nuc-kabylake>
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
	<alpine.LRH.2.02.1804161123400.17807@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.20.1804161043430.9622@nuc-kabylake>
	<alpine.LRH.2.02.1804161532480.19492@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1804161532480.19492@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Matthew Wilcox <willy@infradead.org>, Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids

On Mon, 16 Apr 2018, Mikulas Patocka wrote:

> If you boot with slub_max_order=10, the kmalloc-8192 cache has 64 pages.
> So yes, it increases the order of all slab caches (although not up to
> 4MB).

Hmmm... Ok. There is another setting slub_min_objects that controls how
many objects to fit into a slab page.

We could change the allocation scheme so that it finds the mininum order
with the minimum waste. Allocator performance will drop though since fewer
object are then in a slab page.
