From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH v5] fault-injection: introduce kvmalloc fallback
	options
Date: Thu, 26 Apr 2018 17:50:20 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804261726540.13401@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180421144757.GC14610@bombadil.infradead.org>
	<20180424162906.GM17484@dhcp22.suse.cz>
	<alpine.LRH.2.02.1804241250350.28995@file01.intranet.prod.int.rdu2.redhat.com>
	<20180424170349.GQ17484@dhcp22.suse.cz>
	<alpine.LRH.2.02.1804241319390.28995@file01.intranet.prod.int.rdu2.redhat.com>
	<20180424173836.GR17484@dhcp22.suse.cz>
	<alpine.LRH.2.02.1804251556060.30569@file01.intranet.prod.int.rdu2.redhat.com>
	<1114eda5-9b1f-4db8-2090-556b4a37c532@infradead.org>
	<alpine.LRH.2.02.1804251656300.9428@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.DEB.2.21.1804251417470.166306@chino.kir.corp.google.com>
	<alpine.LRH.2.02.1804251720090.9428@file01.intranet.prod.int.rdu2.redhat.com>
	<1524694663.4100.21.camel@HansenPartnership.com>
	<alpine.LRH.2.02.1804251857070.31135@file01.intranet.prod.int.rdu2.redhat.com>
	<1524697697.4100.23.camel@HansenPartnership.com>
	<23266.8532.619051.784274@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <23266.8532.619051.784274@quad.stoffel.home>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: John Stoffel <john@stoffel.org>
Cc: Andrew@stoffel.org, eric.dumazet@gmail.com, mst@redhat.com, edumazet@google.com, netdev@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Hocko <mhocko@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Michal@stoffel.org, dm-devel@redhat.com, David Miller <davem@davemloft.net>, David Rientjes <rientjes@google.com>, Morton <akpm@linux-foundation.org>, virtualization@lists.linux-foundation.org, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids



On Thu, 26 Apr 2018, John Stoffel wrote:

> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> James> I may be an atypical developer but I'd rather have a root canal
> James> than browse through menuconfig options.  The way to get people
> James> to learn about new debugging options is to blog about it (or
> James> write an lwn.net article) which google will find the next time
> James> I ask it how I debug XXX.  Google (probably as a service to
> James> humanity) rarely turns up Kconfig options in response to a
> James> query.
> 
> I agree with James here.  Looking at the SLAB vs SLUB Kconfig entries
> tells me *nothing* about why I should pick one or the other, as an
> example.
> 
> John

I see your point - and I think the misunderstanding is this.

This patch is not really helping people to debug existing crashes. It is 
not like "you get a crash" - "you google for some keywords" - "you get a 
page that suggests to turn this option on" - "you turn it on and solve the 
crash".

What this patch really does is that - it makes the kernel deliberately 
crash in a situation when the code violates the specification, but it 
would not crash otherwise or it would crash very rarely. It helps to 
detect specification violations.

If the kernel developer (or tester) doesn't use this option, his buggy 
code won't crash - and if it won't crash, he won't fix the bug or report 
it. How is the user or developer supposed to learn about this option, if 
he gets no crash at all?

Mikulas
