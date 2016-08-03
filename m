From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [dm-devel] [RFC PATCH 2/2] mm, mempool: do not throttle
 PF_LESS_THROTTLE tasks
Date: Wed, 3 Aug 2016 16:42:29 +0200
Message-ID: <20160803144229.GD1490@dhcp22.suse.cz>
References: <1468831285-27242-1-git-send-email-mhocko@kernel.org>
 <1468831285-27242-2-git-send-email-mhocko@kernel.org>
 <87oa5q5abi.fsf@notabene.neil.brown.name>
 <20160722091558.GF794@dhcp22.suse.cz>
 <878twt5i1j.fsf@notabene.neil.brown.name>
 <alpine.LRH.2.02.1607251730280.11852@file01.intranet.prod.int.rdu2.redhat.com>
 <87invr4tjm.fsf@notabene.neil.brown.name>
 <alpine.LRH.2.02.1607270948040.1779@file01.intranet.prod.int.rdu2.redhat.com>
 <20160727184021.GF21859@dhcp22.suse.cz>
 <alpine.LRH.2.02.1608030853430.15274@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1608030853430.15274@file01.intranet.prod.int.rdu2.redhat.com>
Sender: owner-linux-mm@kvack.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: NeilBrown <neilb@suse.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, dm-devel@redhat.com, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Ondrej Kozina <okozina@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: dm-devel.ids

On Wed 03-08-16 09:59:11, Mikulas Patocka wrote:
> 
> 
> On Wed, 27 Jul 2016, Michal Hocko wrote:
> 
> > On Wed 27-07-16 10:28:40, Mikulas Patocka wrote:
[...]
> > > I think that approach with PF_LESS_THROTTLE in mempool_alloc is incorrect 
> > > and that mempool allocations should never be throttled.
> > 
> > I'm not really sure this is the right approach. If a particular mempool
> > user cannot ever be throttled by the page allocator then it should
> > perform GFP_NOWAIT.
> 
> Then, all block device drivers should have GFP_NOWAIT - which means that 
> we can as well make it default.
> 
> But GFP_NOWAIT also disables direct reclaim. We really want direct reclaim 
> when allocating from mempool - we just don't want to throttle due to block 
> device congestion.
> 
> We could use __GFP_NORETRY as an indication that we don't want to sleep - 
> or make a new flag __GFP_NO_THROTTLE.

__GFP_NORETRY is used for other contexts so it is not suitable.
__GFP_NO_THROTTLE would be possible but I would still prefer if we
didn't go that way unless really necessary.

> > Even mempool allocations shouldn't allow reclaim to
> > scan pages too quickly even when LRU lists are full of dirty pages. But
> > as I've said that would restrict the success rates even under light page
> > cache load. Throttling on the wait_iff_congested should be quite rare.
> > 
> > Anyway do you see an excessive throttling with the patch posted
> > http://lkml.kernel.org/r/20160725192344.GD2166@dhcp22.suse.cz ? Or from
> 
> It didn't have much effect.
> 
> Since the patch 4e390b2b2f34b8daaabf2df1df0cf8f798b87ddb (revert of the 
> limitless mempool allocations), swapping to dm-crypt works in the simple 
> example.

OK. Do you see any throttling due to wait_iff_congested?
writeback_wait_iff_congested trace point should help here. If not maybe
we should start with the above patch and see how it works in practise.
If the there is still an excessive and unexpected throttling then we
should move on to a more mempool/block layer users specific solution.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
