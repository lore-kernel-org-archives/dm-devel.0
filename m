From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH v5] fault-injection: introduce kvmalloc fallback
 options
Date: Thu, 26 Apr 2018 11:55:32 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1804261145140.21152@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180424170349.GQ17484@dhcp22.suse.cz>   <alpine.LRH.2.02.1804241319390.28995@file01.intranet.prod.int.rdu2.redhat.com>   <20180424173836.GR17484@dhcp22.suse.cz>   <alpine.LRH.2.02.1804251556060.30569@file01.intranet.prod.int.rdu2.redhat.com>
  <1114eda5-9b1f-4db8-2090-556b4a37c532@infradead.org>   <alpine.LRH.2.02.1804251656300.9428@file01.intranet.prod.int.rdu2.redhat.com>   <alpine.DEB.2.21.1804251417470.166306@chino.kir.corp.google.com>   <alpine.LRH.2.02.1804251720090.9428@file01.intranet.prod.int.rdu2.redhat.com>
  <1524694663.4100.21.camel@HansenPartnership.com>   <alpine.LRH.2.02.1804251830540.25124@file01.intranet.prod.int.rdu2.redhat.com>   <20180426125817.GO17484@dhcp22.suse.cz>   <alpine.LRH.2.02.1804261006120.32722@file01.intranet.prod.int.rdu2.redhat.com>
 <1524753932.3226.5.camel@HansenPartnership.com>  <alpine.LRH.2.02.1804261100170.12157@file01.intranet.prod.int.rdu2.redhat.com> <1524756256.3226.7.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1524756256.3226.7.camel@HansenPartnership.com>
Sender: netdev-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, dm-devel@redhat.com, eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org, jasowang@redhat.com, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, edumazet@google.com, Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.linux-foundation.org, David Miller <davem@davemloft.net>, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids



On Thu, 26 Apr 2018, James Bottomley wrote:

> So you're shifting your argument from "I have to do it as a Kconfig
> option because the distros require it" to "distributions will build
> separate kernel packages for this, but won't do enabling in a non
> kernel package"?  To be honest, I think the argument is nuts but I
> don't really care.  From my point of view it's usually me explaining to
> people how to debug stuff and "you have to build your own kernel with
> this Kconfig option" compared to "add this to the kernel command line
> and reboot" is much more effort for the debugger.
> 
> James

If you have to explain to the user that he needs to turn it on, it is 
already wrong.

In order to find the kvmalloc abuses, it should be tested by as many users 
as possible. And it could be tested by as many users as possible, if it 
can be enabled in a VISIBLE place (i.e. menuconfig) - or (in my opinion 
even better) it should be bound to an CONFIG_ option that is already 
enabled for debugging kernel - then you won't have to explain anything to 
the user at all.

Hardly anyone - except for people who read this thread - will know about 
the new commandline parameters or debugfs files.

I'm not arguing that the commandline parameter or debugfs files are wrong. 
They are OK to overridde the default settings for advanced users. But they 
are useless for common users because common users won't know about them.

Mikulas
