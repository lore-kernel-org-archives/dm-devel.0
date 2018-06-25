From: Michal Hocko <mhocko@kernel.org>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Mon, 25 Jun 2018 16:57:33 +0200
Message-ID: <20180625145733.GP28965@dhcp22.suse.cz>
References: <alpine.LRH.2.02.1806191228110.25656@file01.intranet.prod.int.rdu2.redhat.com>
 <20180622090151.GS10465@dhcp22.suse.cz>
 <20180622090935.GT10465@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806220845190.8072@file01.intranet.prod.int.rdu2.redhat.com>
 <20180622130524.GZ10465@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806221447050.2717@file01.intranet.prod.int.rdu2.redhat.com>
 <20180625090957.GF28965@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806250941380.11092@file01.intranet.prod.int.rdu2.redhat.com>
 <20180625141434.GO28965@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806251037250.17405@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1806251037250.17405@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: jing xia <jing.xia.mail@gmail.com>, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

On Mon 25-06-18 10:42:30, Mikulas Patocka wrote:
> 
> 
> On Mon, 25 Jun 2018, Michal Hocko wrote:
> 
> > > And the throttling in dm-bufio prevents kswapd from making forward 
> > > progress, causing this situation...
> > 
> > Which is what we have PF_THROTTLE_LESS for. Geez, do we have to go in
> > circles like that? Are you even listening?
> > 
> > [...]
> > 
> > > And so what do you want to do to prevent block drivers from sleeping?
> > 
> > use the existing means we have.
> > -- 
> > Michal Hocko
> > SUSE Labs
> 
> So - do you want this patch?
> 
> There is no behavior difference between changing the allocator (so that it 
> implies PF_THROTTLE_LESS for block drivers) and chaning all the block 
> drivers to explicitly set PF_THROTTLE_LESS.

As long as you can reliably detect those users. And using gfp_mask is
about the worst way to achieve that because users tend to be creative
when it comes to using gfp mask. PF_THROTTLE_LESS in general is a
way to tell the allocator that _you_ are the one to help the reclaim by
cleaning data.

> But if you insist that the allocator can't be changed, we have to repeat 
> the same code over and over again in the block drivers.

I am not familiar with the patched code but mempool change at least
makes sense (bvec_alloc seems to fallback to mempool which then makes
sense as well). If others in md/ do the same thing

I would just use current_restore_flags rather than open code it.

Thanks!
-- 
Michal Hocko
SUSE Labs
