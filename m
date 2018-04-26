From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [dm-devel] [PATCH v5] fault-injection: introduce kvmalloc
 fallback options
Date: Thu, 26 Apr 2018 08:24:16 -0700
Message-ID: <1524756256.3226.7.camel@HansenPartnership.com>
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
          <alpine.LRH.2.02.1804261006120.32722@file01.intranet.prod.int.rdu2.redhat.com>
         <1524753932.3226.5.camel@HansenPartnership.com>
         <alpine.LRH.2.02.1804261100170.12157@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1804261100170.12157@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, dm-devel@redhat.com, eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org, jasowang@redhat.com, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, edumazet@google.com, Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.linux-foundation.org, David Miller <davem@davemloft.net>, Vlastimil Babka <vbabka@suse.cz>
List-Id: dm-devel.ids

On Thu, 2018-04-26 at 11:05 -0400, Mikulas Patocka wrote:
> 
> On Thu, 26 Apr 2018, James Bottomley wrote:
[...]
> > Perhaps find out beforehand instead of insisting on an approach
> without
> > knowing.  On openSUSE the grub config is built from the files in
> > /etc/grub.d/ so any package can add a kernel option (and various
> > conditions around activating it) simply by adding a new file.
> 
> And then, different versions of the debug kernel will clash when 
> attempting to create the same file.

Don't be silly ... there are many ways of coping with that in rpm/dpkg.
 However, I take it the fact you're now trying to get me to explain
them means you take the point that a kernel dynamic option can be
activated in a variety of easy ways in a distribution including through
the boot menu; so if you want this to appear in the boot menu you don't
need a Kconfig option to achieve it.

> And what about other distributions? What about people who the RHEL
> kernel from source with "make"?

Well, if you build your own kernel and we have a dynamic option, it
will "just work" without you having to muck about trying to re-Kconfig
it, so I'd see that as a win.

> The problem with this approach that you are trying to bother more and
> more people with this little silly feature.

So you're shifting your argument from "I have to do it as a Kconfig
option because the distros require it" to "distributions will build
separate kernel packages for this, but won't do enabling in a non
kernel package"?  To be honest, I think the argument is nuts but I
don't really care.  From my point of view it's usually me explaining to
people how to debug stuff and "you have to build your own kernel with
this Kconfig option" compared to "add this to the kernel command line
and reboot" is much more effort for the debugger.

James
