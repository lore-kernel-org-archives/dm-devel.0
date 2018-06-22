From: Michal Hocko <mhocko@kernel.org>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Fri, 22 Jun 2018 15:05:24 +0200
Message-ID: <20180622130524.GZ10465@dhcp22.suse.cz>
References: <alpine.LRH.2.02.1806150724260.15022@file01.intranet.prod.int.rdu2.redhat.com>
 <20180615115547.GH24039@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806150832100.26650@file01.intranet.prod.int.rdu2.redhat.com>
 <20180615130925.GI24039@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806181003560.4201@file01.intranet.prod.int.rdu2.redhat.com>
 <20180619104312.GD13685@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806191228110.25656@file01.intranet.prod.int.rdu2.redhat.com>
 <20180622090151.GS10465@dhcp22.suse.cz>
 <20180622090935.GT10465@dhcp22.suse.cz>
 <alpine.LRH.2.02.1806220845190.8072@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1806220845190.8072@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: jing xia <jing.xia.mail@gmail.com>, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

On Fri 22-06-18 08:52:09, Mikulas Patocka wrote:
> 
> 
> On Fri, 22 Jun 2018, Michal Hocko wrote:
> 
> > On Fri 22-06-18 11:01:51, Michal Hocko wrote:
> > > On Thu 21-06-18 21:17:24, Mikulas Patocka wrote:
> > [...]
> > > > What about this patch? If __GFP_NORETRY and __GFP_FS is not set (i.e. the 
> > > > request comes from a block device driver or a filesystem), we should not 
> > > > sleep.
> > > 
> > > Why? How are you going to audit all the callers that the behavior makes
> > > sense and moreover how are you going to ensure that future usage will
> > > still make sense. The more subtle side effects gfp flags have the harder
> > > they are to maintain.
> > 
> > So just as an excercise. Try to explain the above semantic to users. We
> > currently have the following.
> > 
> >  * __GFP_NORETRY: The VM implementation will try only very lightweight
> >  *   memory direct reclaim to get some memory under memory pressure (thus
> >  *   it can sleep). It will avoid disruptive actions like OOM killer. The
> >  *   caller must handle the failure which is quite likely to happen under
> >  *   heavy memory pressure. The flag is suitable when failure can easily be
> >  *   handled at small cost, such as reduced throughput
> > 
> >  * __GFP_FS can call down to the low-level FS. Clearing the flag avoids the
> >  *   allocator recursing into the filesystem which might already be holding
> >  *   locks.
> > 
> > So how are you going to explain gfp & (__GFP_NORETRY | ~__GFP_FS)? What
> > is the actual semantic without explaining the whole reclaim or force
> > users to look into the code to understand that? What about GFP_NOIO |
> > __GFP_NORETRY? What does it mean to that "should not sleep". Do all
> > shrinkers have to follow that as well?
> 
> My reasoning was that there is broken code that uses __GFP_NORETRY and 
> assumes that it can't fail - so conditioning the change on !__GFP_FS would 
> minimize the diruption to the broken code.
> 
> Anyway - if you want to test only on __GFP_NORETRY (and fix those 16 
> broken cases that assume that __GFP_NORETRY can't fail), I'm OK with that.

As I've already said, this is a subtle change which is really hard to
reason about. Throttling on congestion has its meaning and reason. Look
at why we are doing that in the first place. You cannot simply say this
is ok based on your specific usecase. We do have means to achieve that.
It is explicit and thus it will be applied only where it makes sense.
You keep repeating that implicit behavior change for everybody is
better. I guess we will not agree on that part. I consider it a hack
rather than a systematic solution. I can easily imagine that we just
find out other call sites that would cause over reclaim or similar
problems because they are not throttled on too many dirty pages due to
congested storage. What are we going to then? Add another magic gfp
flag? Really, try to not add even more subtle side effects for gfp
flags. We _do_ have ways to accomplish what your particular usecase
requires.
-- 
Michal Hocko
SUSE Labs
