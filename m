From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 1/2] mempool: do not consume memory reserves from the
 reclaim path
Date: Thu, 21 Jul 2016 16:53:10 +0200
Message-ID: <20160721145309.GR26379@dhcp22.suse.cz>
References: <1468831164-26621-1-git-send-email-mhocko@kernel.org>
 <1468831285-27242-1-git-send-email-mhocko@kernel.org>
 <20160719135426.GA31229@cmpxchg.org>
 <alpine.DEB.2.10.1607191315400.58064@chino.kir.corp.google.com>
 <20160720081541.GF11249@dhcp22.suse.cz>
 <alpine.DEB.2.10.1607201353230.22427@chino.kir.corp.google.com>
 <20160721085202.GC26379@dhcp22.suse.cz>
 <20160721121300.GA21806@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160721121300.GA21806@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org, Mikulas Patocka <mpatocka@redhat.com>, Ondrej Kozina <okozina@redhat.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Mel Gorman <mgorman@suse.de>, Neil Brown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu 21-07-16 08:13:00, Johannes Weiner wrote:
> On Thu, Jul 21, 2016 at 10:52:03AM +0200, Michal Hocko wrote:
> > Look, there are
> > $ git grep mempool_alloc | wc -l
> > 304
> > 
> > many users of this API and we do not want to flip the default behavior
> > which is there for more than 10 years. So far you have been arguing
> > about potential deadlocks and haven't shown any particular path which
> > would have a direct or indirect dependency between mempool and normal
> > allocator and it wouldn't be a bug. As the matter of fact the change
> > we are discussing here causes a regression. If you want to change the
> > semantic of mempool allocator then you are absolutely free to do so. In
> > a separate patch which would be discussed with IO people and other
> > users, though. But we _absolutely_ want to fix the regression first
> > and have a simple fix for 4.6 and 4.7 backports. At this moment there
> > are revert and patch 1 on the table.  The later one should make your
> > backtrace happy and should be only as a temporal fix until we find out
> > what is actually misbehaving on your systems. If you are not interested
> > to pursue that way I will simply go with the revert.
> 
> +1
> 
> It's very unlikely that decade-old mempool semantics are suddenly a
> fundamental livelock problem, when all the evidence we have is one
> hang and vague speculation. Given that the patch causes regressions,
> and that the bug is most likely elsewhere anyway, a full revert rather
> than merely-less-invasive mempool changes makes the most sense to me.

OK, fair enough. What do you think about the following then? Mikulas, I
have dropped your Tested-by and Reviewed-by because the patch is
different but unless you have hit the OOM killer then the testing
results should be same.
---
From d64815758c212643cc1750774e2751721685059a Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.com>
Date: Thu, 21 Jul 2016 16:40:59 +0200
Subject: [PATCH] Revert "mm, mempool: only set __GFP_NOMEMALLOC if there are
 free elements"

This reverts commit f9054c70d28bc214b2857cf8db8269f4f45a5e23.

There has been a report about OOM killer invoked when swapping out to
a dm-crypt device. The primary reason seems to be that the swapout
out IO managed to completely deplete memory reserves. Ondrej was
able to bisect and explained the issue by pointing to f9054c70d28b
("mm, mempool: only set __GFP_NOMEMALLOC if there are free elements").

The reason is that the swapout path is not throttled properly because
the md-raid layer needs to allocate from the generic_make_request path
which means it allocates from the PF_MEMALLOC context. dm layer uses
mempool_alloc in order to guarantee a forward progress which used to
inhibit access to memory reserves when using page allocator. This has
changed by f9054c70d28b ("mm, mempool: only set __GFP_NOMEMALLOC if
there are free elements") which has dropped the __GFP_NOMEMALLOC
protection when the memory pool is depleted.

If we are running out of memory and the only way forward to free memory
is to perform swapout we just keep consuming memory reserves rather than
throttling the mempool allocations and allowing the pending IO to
complete up to a moment when the memory is depleted completely and there
is no way forward but invoking the OOM killer. This is less than
optimal.

The original intention of f9054c70d28b was to help with the OOM
situations where the oom victim depends on mempool allocation to make a
forward progress. David has mentioned the following backtrace:

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

We do not know more about why the mempool is depleted without being
replenished in time, though. In any case the dm layer shouldn't depend
on any allocations outside of the dedicated pools so a forward progress
should be guaranteed. If this is not the case then the dm should be
fixed rather than papering over the problem and postponing it to later
by accessing more memory reserves.

mempools are a mechanism to maintain dedicated memory reserves to guaratee
forward progress. Allowing them an unbounded access to the page allocator
memory reserves is going against the whole purpose of this mechanism.

Bisected-by: Ondrej Kozina <okozina@redhat.com>
Signed-off-by: Michal Hocko <mhocko@suse.com>
---
 mm/mempool.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index 8f65464da5de..5ba6c8b3b814 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -306,36 +306,25 @@ EXPORT_SYMBOL(mempool_resize);
  * returns NULL. Note that due to preallocation, this function
  * *never* fails when called from process contexts. (it might
  * fail if called from an IRQ context.)
- * Note: neither __GFP_NOMEMALLOC nor __GFP_ZERO are supported.
+ * Note: using __GFP_ZERO is not supported.
  */
-void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
+void * mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 {
 	void *element;
 	unsigned long flags;
 	wait_queue_t wait;
 	gfp_t gfp_temp;
 
-	/* If oom killed, memory reserves are essential to prevent livelock */
-	VM_WARN_ON_ONCE(gfp_mask & __GFP_NOMEMALLOC);
-	/* No element size to zero on allocation */
 	VM_WARN_ON_ONCE(gfp_mask & __GFP_ZERO);
-
 	might_sleep_if(gfp_mask & __GFP_DIRECT_RECLAIM);
 
+	gfp_mask |= __GFP_NOMEMALLOC;	/* don't allocate emergency reserves */
 	gfp_mask |= __GFP_NORETRY;	/* don't loop in __alloc_pages */
 	gfp_mask |= __GFP_NOWARN;	/* failures are OK */
 
 	gfp_temp = gfp_mask & ~(__GFP_DIRECT_RECLAIM|__GFP_IO);
 
 repeat_alloc:
-	if (likely(pool->curr_nr)) {
-		/*
-		 * Don't allocate from emergency reserves if there are
-		 * elements available.  This check is racy, but it will
-		 * be rechecked each loop.
-		 */
-		gfp_temp |= __GFP_NOMEMALLOC;
-	}
 
 	element = pool->alloc(gfp_temp, pool->pool_data);
 	if (likely(element != NULL))
@@ -359,12 +348,11 @@ void *mempool_alloc(mempool_t *pool, gfp_t gfp_mask)
 	 * We use gfp mask w/o direct reclaim or IO for the first round.  If
 	 * alloc failed with that and @pool was empty, retry immediately.
 	 */
-	if ((gfp_temp & ~__GFP_NOMEMALLOC) != gfp_mask) {
+	if (gfp_temp != gfp_mask) {
 		spin_unlock_irqrestore(&pool->lock, flags);
 		gfp_temp = gfp_mask;
 		goto repeat_alloc;
 	}
-	gfp_temp = gfp_mask;
 
 	/* We must not sleep if !__GFP_DIRECT_RECLAIM */
 	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
-- 
2.8.1


-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
