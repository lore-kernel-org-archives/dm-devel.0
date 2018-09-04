From: Michal Hocko <mhocko@kernel.org>
Subject: Re: dm bufio: Reduce dm_bufio_lock contention
Date: Tue, 4 Sep 2018 09:08:24 +0200
Message-ID: <20180904070824.GH14951@dhcp22.suse.cz>
References: <1528790608-19557-1-git-send-email-jing.xia@unisoc.com>
 <20180612212007.GA22717@redhat.com>
 <alpine.LRH.2.02.1806131001250.15845@file01.intranet.prod.int.rdu2.redhat.com>
 <CAN=25QMQiJ7wvfvYvmZnEnrkeb-SA7_hPj+N2RnO8y-aVO8wOQ@mail.gmail.com>
 <20180614073153.GB9371@dhcp22.suse.cz>
 <CAN=25QNrENVFbb9UAAAJJqKsEeMY+qNs5cQA4EGwgB2dMYTZug@mail.gmail.com>
 <alpine.LRH.2.02.1809031816120.27063@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1809031816120.27063@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: jing xia <jing.xia.mail@gmail.com>, Mike Snitzer <snitzer@redhat.com>, agk@redhat.com, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

On Mon 03-09-18 18:23:17, Mikulas Patocka wrote:
> 
> 
> On Wed, 1 Aug 2018, jing xia wrote:
> 
> > We reproduced this issue again and found out the root cause.
> > dm_bufio_prefetch() with dm_bufio_lock enters the direct reclaim and
> > takes a long time to do the soft_limit_reclaim, because of the huge
> > number of memory excess of the memcg.
> > Then, all the task who do shrink_slab() wait for  dm_bufio_lock.
> > 
> > Any suggestions for this?Thanks.
> 
> There's hardly any solution because Michal Hocko refuses to change 
> __GFP_NORETRY behavior.
> 
> The patches 41c73a49df31151f4ff868f28fe4f129f113fa2c and 
> d12067f428c037b4575aaeb2be00847fc214c24a could reduce the lock contention 
> on the dm-bufio lock - the patches don't fix the high CPU consumption 
> inside the memory allocation, but the kernel code should wait less on the 
> bufio lock.

If you actually looked at the bottom line of the problem then you would
quickly find out that dm-bufio lock is the least of the problem with the
soft limit reclaim. This is a misfeature which has been merged and we
have to live with it. All we can do is to discourage people from using
it and use much more saner low limit instead.

So please stop this stupid blaming, try to understand the reasoning
behind my arguments.
-- 
Michal Evil Hocko
SUSE Labs
