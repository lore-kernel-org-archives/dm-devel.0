From: Michal Hocko <mhocko@kernel.org>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Mon, 25 Jun 2018 16:14:34 +0200
Message-ID: <20180625141434.GO28965@dhcp22.suse.cz>
References: <alpine.LRH.2.02.1806181003560.4201@file01.intranet.prod.int.rdu2.redhat.com>
 <20180619104312.GD13685@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806191228110.25656@file01.intranet.prod.int.rdu2.redhat.com>
 <20180622090151.GS10465@dhcp22.suse.cz>
 <20180622090935.GT10465@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806220845190.8072@file01.intranet.prod.int.rdu2.redhat.com>
 <20180622130524.GZ10465@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806221447050.2717@file01.intranet.prod.int.rdu2.redhat.com>
 <20180625090957.GF28965@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806250941380.11092@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1806250941380.11092@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: jing xia <jing.xia.mail@gmail.com>, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

On Mon 25-06-18 09:53:34, Mikulas Patocka wrote:
> y
> 
> On Mon, 25 Jun 2018, Michal Hocko wrote:
> 
> > On Fri 22-06-18 14:57:10, Mikulas Patocka wrote:
> > > 
> > > 
> > > On Fri, 22 Jun 2018, Michal Hocko wrote:
> > > 
> > > > On Fri 22-06-18 08:52:09, Mikulas Patocka wrote:
> > > > > 
> > > > > 
> > > > > On Fri, 22 Jun 2018, Michal Hocko wrote:
> > > > > 
> > > > > > On Fri 22-06-18 11:01:51, Michal Hocko wrote:
> > > > > > > On Thu 21-06-18 21:17:24, Mikulas Patocka wrote:
> > > > > > [...]
> > > > > > > > What about this patch? If __GFP_NORETRY and __GFP_FS is not set (i.e. the 
> > > > > > > > request comes from a block device driver or a filesystem), we should not 
> > > > > > > > sleep.
> > > > > > > 
> > > > > > > Why? How are you going to audit all the callers that the behavior makes
> > > > > > > sense and moreover how are you going to ensure that future usage will
> > > > > > > still make sense. The more subtle side effects gfp flags have the harder
> > > > > > > they are to maintain.
> > > > > > 
> > > > > > So just as an excercise. Try to explain the above semantic to users. We
> > > > > > currently have the following.
> > > > > > 
> > > > > >  * __GFP_NORETRY: The VM implementation will try only very lightweight
> > > > > >  *   memory direct reclaim to get some memory under memory pressure (thus
> > > > > >  *   it can sleep). It will avoid disruptive actions like OOM killer. The
> > > > > >  *   caller must handle the failure which is quite likely to happen under
> > > > > >  *   heavy memory pressure. The flag is suitable when failure can easily be
> > > > > >  *   handled at small cost, such as reduced throughput
> > > > > > 
> > > > > >  * __GFP_FS can call down to the low-level FS. Clearing the flag avoids the
> > > > > >  *   allocator recursing into the filesystem which might already be holding
> > > > > >  *   locks.
> > > > > > 
> > > > > > So how are you going to explain gfp & (__GFP_NORETRY | ~__GFP_FS)? What
> > > > > > is the actual semantic without explaining the whole reclaim or force
> > > > > > users to look into the code to understand that? What about GFP_NOIO |
> > > > > > __GFP_NORETRY? What does it mean to that "should not sleep". Do all
> > > > > > shrinkers have to follow that as well?
> > > > > 
> > > > > My reasoning was that there is broken code that uses __GFP_NORETRY and 
> > > > > assumes that it can't fail - so conditioning the change on !__GFP_FS would 
> > > > > minimize the diruption to the broken code.
> > > > > 
> > > > > Anyway - if you want to test only on __GFP_NORETRY (and fix those 16 
> > > > > broken cases that assume that __GFP_NORETRY can't fail), I'm OK with that.
> > > > 
> > > > As I've already said, this is a subtle change which is really hard to
> > > > reason about. Throttling on congestion has its meaning and reason. Look
> > > > at why we are doing that in the first place. You cannot simply say this
> > > 
> > > So - explain why is throttling needed. You support throttling, I don't, so 
> > > you have to explain it :)
> > > 
> > > > is ok based on your specific usecase. We do have means to achieve that.
> > > > It is explicit and thus it will be applied only where it makes sense.
> > > > You keep repeating that implicit behavior change for everybody is
> > > > better.
> > > 
> > > I don't want to change it for everybody. I want to change it for block 
> > > device drivers. I don't care what you do with non-block drivers.
> > 
> > Well, it is usually onus of the patch submitter to justify any change.
> > But let me be nice on you, for once. This throttling is triggered only
> > if we all the pages we have encountered during the reclaim attempt are
> > dirty and that means that we are rushing through the LRU list quicker
> > than flushers are able to clean. If we didn't throttle we could hit
> > stronger reclaim priorities (aka scan more to reclaim memory) and
> > reclaim more pages as a result.
> 
> And the throttling in dm-bufio prevents kswapd from making forward 
> progress, causing this situation...

Which is what we have PF_THROTTLE_LESS for. Geez, do we have to go in
circles like that? Are you even listening?

[...]

> And so what do you want to do to prevent block drivers from sleeping?

use the existing means we have.
-- 
Michal Hocko
SUSE Labs
