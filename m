From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [dm-devel] [PATCH v5] fault-injection: introduce kvmalloc
 fallback options
Date: Fri, 27 Apr 2018 10:25:55 +0200
Message-ID: <20180427082555.GC17484@dhcp22.suse.cz>
References: <alpine.LRH.2.02.1804251656300.9428@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.DEB.2.21.1804251417470.166306@chino.kir.corp.google.com>
 <alpine.LRH.2.02.1804251720090.9428@file01.intranet.prod.int.rdu2.redhat.com>
 <1524694663.4100.21.camel@HansenPartnership.com>
 <alpine.LRH.2.02.1804251857070.31135@file01.intranet.prod.int.rdu2.redhat.com>
 <1524697697.4100.23.camel@HansenPartnership.com>
 <23266.8532.619051.784274@quad.stoffel.home>
 <alpine.LRH.2.02.1804261726540.13401@file01.intranet.prod.int.rdu2.redhat.com>
 <20180427005213-mutt-send-email-mst@kernel.org>
 <alpine.LRH.2.02.1804261829190.30599@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1804261829190.30599@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, John Stoffel <john@stoffel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Michal@stoffel.org, eric.dumazet@gmail.com, netdev@vger.kernel.org, jasowang@redhat.com, Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, dm-devel@redhat.com, Vlastimil Babka <vbabka@suse.cz>, Andrew@stoffel.org, David Rientjes <rientjes@google.com>, Morton <akpm@linux-foundation.org>, virtualization@lists.linux-foundation.org, David Miller <davem@davemloft.net>, edumazet@google.com
List-Id: dm-devel.ids

On Thu 26-04-18 18:52:05, Mikulas Patocka wrote:
> 
> 
> On Fri, 27 Apr 2018, Michael S. Tsirkin wrote:
[...]
> >    But assuming it's important to control this kind of
> >    fault injection to be controlled from
> >    a dedicated menuconfig option, why not the rest of
> >    faults?
> 
> The injected faults cause damage to the user, so there's no point to 
> enable them by default. vmalloc fallback should not cause any damage 
> (assuming that the code is correctly written).

But you want to find those bugs which would BUG_ON easier, so there is a
risk of harm IIUC and this is not much different than other fault
injecting paths.
-- 
Michal Hocko
SUSE Labs
