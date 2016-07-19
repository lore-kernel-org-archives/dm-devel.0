From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 1/2] mempool: do not consume memory reserves from the
 reclaim path
Date: Tue, 19 Jul 2016 09:49:35 +0200
Message-ID: <20160719074935.GC9486@dhcp22.suse.cz>
References: <1468831164-26621-1-git-send-email-mhocko@kernel.org>
 <1468831285-27242-1-git-send-email-mhocko@kernel.org>
 <alpine.DEB.2.10.1607181858020.16586@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1607181858020.16586@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Mikulas Patocka <mpatocka@redhat.com>, Ondrej Kozina <okozina@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Mel Gorman <mgorman@suse.de>, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com, Johannes Weiner <hannes@cmpxchg.org>
List-Id: dm-devel.ids

On Mon 18-07-16 19:00:57, David Rientjes wrote:
> On Mon, 18 Jul 2016, Michal Hocko wrote:
> 
> > David Rientjes was objecting that such an approach wouldn't help if the
> > oom victim was blocked on a lock held by process doing mempool_alloc. This
> > is very similar to other oom deadlock situations and we have oom_reaper
> > to deal with them so it is reasonable to rely on the same mechanism
> > rather inventing a different one which has negative side effects.
> > 
> 
> Right, this causes oom livelock as described in the aforementioned thread: 
> the oom victim is waiting on a mutex that is held by a thread doing 
> mempool_alloc().

The backtrace you have provided:
schedule
schedule_timeout
io_schedule_timeout
mempool_alloc
__split_and_process_bio
dm_request
generic_make_request
submit_bio
mpage_readpages
ext4_readpages
__do_page_cache_readahead
ra_submit
filemap_fault
handle_mm_fault
__do_page_fault
do_page_fault
page_fault

is not PF_MEMALLOC context AFAICS so clearing __GFP_NOMEMALLOC for such
a task will not help unless that task has TIF_MEMDIE. Could you provide
a trace where the PF_MEMALLOC context holding a lock cannot make a
forward progress?

> The oom reaper is not guaranteed to free any memory, so 
> nothing on the system can allocate memory from the page allocator.

Sure, there is no guarantee but as I've said earlier, 1) oom_reaper will
allow to select another victim in many cases and 2) such a deadlock is
no different from any other where the victim cannot continue because of
another context blocking a lock while waiting for memory. Tweaking
mempool allocator to potentially catch such a case in a different way
doesn't sound right in principle, not to mention this is other dangerous
side effects.
 
> I think the better solution here is to allow mempool_alloc() users to set 
> __GFP_NOMEMALLOC if they are in a context which allows them to deplete 
> memory reserves.

I am not really sure about that. I agree with Johannes [1] that this
is bending mempool allocator into an undesirable direction because
the point of the mempool is to have its own reliably reusable memory
reserves. Now I am even not sure whether TIF_MEMDIE exception is a
good way forward and a plain revert is more appropriate. Let's CC
Johannes. The patch is [2].

[1] http://lkml.kernel.org/r/20160718151445.GB14604@cmpxchg.org
[2] http://lkml.kernel.org/r/1468831285-27242-1-git-send-email-mhocko@kernel.org
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
