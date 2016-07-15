From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: System freezes after OOM
Date: Fri, 15 Jul 2016 13:02:17 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1607151256260.7011@file01.intranet.prod.int.rdu2.redhat.com>
References: <20160712064905.GA14586@dhcp22.suse.cz> <alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com> <20160713111006.GF28723@dhcp22.suse.cz> <alpine.LRH.2.02.1607131021410.31769@file01.intranet.prod.int.rdu2.redhat.com>
 <20160714125129.GA12289@dhcp22.suse.cz> <alpine.LRH.2.02.1607140952550.1102@file01.intranet.prod.int.rdu2.redhat.com> <20160714145937.GB12289@dhcp22.suse.cz> <alpine.LRH.2.02.1607141315130.17819@file01.intranet.prod.int.rdu2.redhat.com>
 <20160715083510.GD11811@dhcp22.suse.cz> <alpine.LRH.2.02.1607150802380.5034@file01.intranet.prod.int.rdu2.redhat.com> <20160715122210.GG11811@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160715122210.GG11811@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Ondrej Kozina <okozina@redhat.com>, Jerome Marchand <jmarchan@redhat.com>, Stanislav Kozina <skozina@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids



On Fri, 15 Jul 2016, Michal Hocko wrote:

> On Fri 15-07-16 08:11:22, Mikulas Patocka wrote:
> > 
> > The stacktraces showed that the kcryptd process was throttled when it 
> > tried to do mempool allocation. Mempool adds the __GFP_NORETRY flag to the 
> > allocation, but unfortunatelly, this flag doesn't prevent the allocator 
> > from throttling.
> 
> Yes and in fact it shouldn't prevent any throttling. The flag merely
> says that the allocation should give up rather than retry
> reclaim/compaction again and again.
> 
> > I say that the process doing mempool allocation shouldn't ever be 
> > throttled. Maybe add __GFP_NOTHROTTLE?
> 
> A specific gfp flag would be an option but we are slowly running out of
> bit space there and I am not yet convinced PF_LESS_THROTTLE is
> unsuitable.

PF_LESS_THROTTLE will make it throttle less, but it doesn't eliminate 
throttling entirely. So, maybe add PF_NO_THROTTLE? But PF_* flags are also 
almost exhausted.

> I might be missing something but exactly this is what happens in
> wait_iff_congested no? If the bdi doesn't see the congestion it wakes up
> the reclaim context even before the timeout. Or are we talking past each
> other?

OK, I see that there is wait queue in congestion_wait. I didn't notice it 
before.

Mikulas

> -- 
> Michal Hocko
> SUSE Labs
> 
