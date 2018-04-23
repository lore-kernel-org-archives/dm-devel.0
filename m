From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] kvmalloc: always use vmalloc if CONFIG_DEBUG_VM
Date: Mon, 23 Apr 2018 19:20:11 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804231911280.25912@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180418.134651.2225112489265654270.davem@davemloft.net>
	<alpine.LRH.2.02.1804181350050.17942@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1804191207380.31175@file01.intranet.prod.int.rdu2.redhat.com>
	<20180420130852.GC16083@dhcp22.suse.cz>
	<alpine.LRH.2.02.1804201635180.25408@file01.intranet.prod.int.rdu2.redhat.com>
	<20180420210200.GH10788@bombadil.infradead.org>
	<alpine.LRH.2.02.1804201704580.25408@file01.intranet.prod.int.rdu2.redhat.com>
	<20180421144757.GC14610@bombadil.infradead.org>
	<20180422130356.GG17484@dhcp22.suse.cz>
	<alpine.LRH.2.02.1804231006440.22488@file01.intranet.prod.int.rdu2.redhat.com>
	<20180423151015.GT17484@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20180423151015.GT17484@dhcp22.suse.cz>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Michal Hocko <mhocko@kernel.org>
Cc: dm-devel@redhat.com, eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, edumazet@google.com, bhutchings@solarflare.com, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids



On Mon, 23 Apr 2018, Michal Hocko wrote:

> On Mon 23-04-18 10:24:02, Mikulas Patocka wrote:
> 
> > > Really, we have a fault injection framework and this sounds like
> > > something to hook in there.
> > 
> > The testing people won't set it up. They install the "kernel-debug" 
> > package and run the tests in it.
> > 
> > If you introduce a hidden option that no one knows about, no one will use 
> > it.
> 
> then make sure people know about it. Fuzzers already do test fault
> injections.

I think that in the long term we can introduce a kernel parameter like 
"debug_level=1", "debug_level=2", "debug_level=3" that will turn on 
debugging features across all kernel subsystems and we can teach users to 
use it to diagnose problems.

But it won't work if every subsystem has different debug parameters. There 
are 192 distinct filenames in debugfs, if we add 193rd one, harly anyone 
notices it.

Mikulas
