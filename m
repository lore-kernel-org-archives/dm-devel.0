From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH v5] fault-injection: introduce kvmalloc
 fallback options
Date: Thu, 26 Apr 2018 10:28:45 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804261006120.32722@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180424170349.GQ17484@dhcp22.suse.cz>
	<alpine.LRH.2.02.1804241319390.28995@file01.intranet.prod.int.rdu2.redhat.com>
	<20180424173836.GR17484@dhcp22.suse.cz>
	<alpine.LRH.2.02.1804251556060.30569@file01.intranet.prod.int.rdu2.redhat.com>
	<1114eda5-9b1f-4db8-2090-556b4a37c532@infradead.org>
	<alpine.LRH.2.02.1804251656300.9428@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.21.1804251417470.166306@chino.kir.corp.google.com>
	<alpine.LRH.2.02.1804251720090.9428@file01.intranet.prod.int.rdu2.redhat.com>
	<1524694663.4100.21.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1804251830540.25124@file01.intranet.prod.int.rdu2.redhat.com>
	<20180426125817.GO17484@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180426125817.GO17484@dhcp22.suse.cz>
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
Cc: eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org, jasowang@redhat.com, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, virtualization@lists.linux-foundation.org, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-mm@kvack.org, dm-devel@redhat.com, Vlastimil Babka <vbabka@suse.cz>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, edumazet@google.com
List-Id: dm-devel.ids



On Thu, 26 Apr 2018, Michal Hocko wrote:

> On Wed 25-04-18 18:42:57, Mikulas Patocka wrote:
> > 
> > 
> > On Wed, 25 Apr 2018, James Bottomley wrote:
> [...]
> > > Kconfig proliferation, conversely, is a bit of a nightmare from both
> > > the user and the tester's point of view, so we're trying to avoid it
> > > unless absolutely necessary.
> > > 
> > > James
> > 
> > I already offered that we don't need to introduce a new kernel option and 
> > we can bind this feature to any other kernel option, that is enabled in 
> > the debug kernel, for example CONFIG_DEBUG_SG. Michal said no and he said 
> > that he wants a new kernel option instead.
> 
> Just for the record. I didn't say I _want_ a config option. Do not
> misinterpret my words. I've said that a config option would be
> acceptable if there is no way to deliver the functionality via kernel
> package automatically. You haven't provided any argument that would
> explain why the kernel package cannot add a boot option. Maybe there are
> some but I do not see them right now.

AFAIK Grub doesn't load per-kernel options from a per-kernel file. Even if 
we hacked grub scripts to add this option, other distributions won't.

Mikulas
