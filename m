From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/6] mm: Replace PF_MEMALLOC_NOIO with memalloc_noio
Date: Thu, 25 Jun 2020 14:42:34 +0200
Message-ID: <20200625124234.GM1320@dhcp22.suse.cz>
References: <20200625113122.7540-1-willy@infradead.org>
 <20200625113122.7540-2-willy@infradead.org>
 <20200625122239.GJ1320@dhcp22.suse.cz>
 <20200625123418.GB7703@casper.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200625123418.GB7703@casper.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>
List-Id: dm-devel.ids

On Thu 25-06-20 13:34:18, Matthew Wilcox wrote:
> On Thu, Jun 25, 2020 at 02:22:39PM +0200, Michal Hocko wrote:
> > On Thu 25-06-20 12:31:17, Matthew Wilcox wrote:
> > > We're short on PF_* flags, so make memalloc_noio its own bit where we
> > > have plenty of space.
> > 
> > I do not mind moving that outside of the PF_* space. Unless I
> > misremember all flags in this space were intented to be set only on the
> > current which rules out any RMW races and therefore they can be
> > lockless. I am not sure this holds for the bitfield you are adding this
> > to. At least in_memstall seem to be set on external task as well. But
> > this would require double checking. Maybe that is not really intended or
> > just a bug.
> 
> I was going from the comment:
> 
>         /* Unserialized, strictly 'current' */
> (which you can't see from the context of the diff, but is above the block)
> 
> The situation with ->flags is a little more ambiguous:
> 
> /*
>  * Only the _current_ task can read/write to tsk->flags, but other
>  * tasks can access tsk->flags in readonly mode for example
>  * with tsk_used_math (like during threaded core dumping).
>  * There is however an exception to this rule during ptrace
>  * or during fork: the ptracer task is allowed to write to the
>  * child->flags of its traced child (same goes for fork, the parent
>  * can write to the child->flags), because we're guaranteed the
>  * child is not running and in turn not changing child->flags
>  * at the same time the parent does it.
>  */

OK, I have obviously missed that.

> but it wasn't unsafe to use the PF_ flags in the way that you were.
> It's just crowded.
> 
> If in_memstall is set on other tasks, then it should be moved to the
> PFA flags, which there are plenty of.
> 
> But a quick grep shows it only being read on other tasks and always
> set on current:
> 
> kernel/sched/psi.c:     *flags = current->in_memstall;
> kernel/sched/psi.c:      * in_memstall setting & accounting needs to be atomic wrt
> kernel/sched/psi.c:     current->in_memstall = 1;
> kernel/sched/psi.c:      * in_memstall clearing & accounting needs to be atomic wrt
> kernel/sched/psi.c:     current->in_memstall = 0;
> kernel/sched/psi.c:     if (task->in_memstall)

Have a look at cgroup_move_task. So I believe this is something to be
fixed but independent on your change.

Feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>

> kernel/sched/stats.h:           if (p->in_memstall)
> kernel/sched/stats.h:           if (p->in_memstall)
> kernel/sched/stats.h:   if (unlikely(p->in_iowait || p->in_memstall)) {
> kernel/sched/stats.h:           if (p->in_memstall)
> kernel/sched/stats.h:   if (unlikely(rq->curr->in_memstall))
> 
> so I think everything is fine.

-- 
Michal Hocko
SUSE Labs
