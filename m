From: "John Stoffel" <john@stoffel.org>
Subject: Re: [dm-devel] [PATCH v5] fault-injection: introduce kvmalloc
 fallback options
Date: Thu, 26 Apr 2018 14:58:28 -0400
Message-ID: <23266.8532.619051.784274@quad.stoffel.home>
References: <20180421144757.GC14610@bombadil.infradead.org>
        <alpine.LRH.2.02.1804221733520.7995@file01.intranet.prod.int.rdu2.redhat.com>
        <20180423151545.GU17484@dhcp22.suse.cz>
        <alpine.LRH.2.02.1804232003100.2299@file01.intranet.prod.int.rdu2.redhat.com>
        <20180424125121.GA17484@dhcp22.suse.cz>
        <alpine.LRH.2.02.1804241142340.15660@file01.intranet.prod.int.rdu2.redhat.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524697697.4100.23.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Michal@stoffel.org, eric.dumazet@gmail.com, mst@redhat.com, netdev@vger.kernel.org, jasowang@redhat.com, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Hocko <mhocko@kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, Vlastimil Babka <vbabka@suse.cz>, Andrew@stoffel.org, David Rientjes <rientjes@google.com>, Morton <akpm@linux-foundation.org>, virtualization@lists.linux-foundation.org, David Miller <davem@davemloft.net>, edumazet@google.com
List-Id: dm-devel.ids

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> On Wed, 2018-04-25 at 19:00 -0400, Mikulas Patocka wrote:
>> 
>> On Wed, 25 Apr 2018, James Bottomley wrote:
>> 
>> > > > Do we really need the new config option?  This could just be
>> > > > manually  tunable via fault injection IIUC.
>> > > 
>> > > We do, because we want to enable it in RHEL and Fedora debugging
>> > > kernels, so that it will be tested by the users.
>> > > 
>> > > The users won't use some extra magic kernel options or debugfs
>> files.
>> > 
>> > If it can be enabled via a tunable, then the distro can turn it on
>> > without the user having to do anything.  If you want to present the
>> > user with a different boot option, you can (just have the tunable
>> set
>> > on the command line), but being tunable driven means that you don't
>> > have to choose that option, you could automatically enable it under
>> a
>> > range of circumstances.  I think most sane distributions would want
>> > that flexibility.
>> > 
>> > Kconfig proliferation, conversely, is a bit of a nightmare from
>> both
>> > the user and the tester's point of view, so we're trying to avoid
>> it
>> > unless absolutely necessary.
>> > 
>> > James
>> 
>> BTW. even developers who compile their own kernel should have this
>> enabled by a CONFIG option - because if the developer sees the option
>> when browsing through menuconfig, he may enable it. If he doesn't see
>> the option, he won't even know that such an option exists.

James> I may be an atypical developer but I'd rather have a root canal
James> than browse through menuconfig options.  The way to get people
James> to learn about new debugging options is to blog about it (or
James> write an lwn.net article) which google will find the next time
James> I ask it how I debug XXX.  Google (probably as a service to
James> humanity) rarely turns up Kconfig options in response to a
James> query.

I agree with James here.  Looking at the SLAB vs SLUB Kconfig entries
tells me *nothing* about why I should pick one or the other, as an
example.

John
