From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: System freezes after OOM
Date: Wed, 13 Jul 2016 22:19:23 +0900
Message-ID: <2d5e1f84-e886-7b98-cb11-170d7104fd13__40649.7526485056$1468417975$gmane$org@I-love.SAKURA.ne.jp>
References: <57837CEE.1010609@redhat.com>
	<f80dc690-7e71-26b2-59a2-5a1557d26713@redhat.com>
	<9be09452-de7f-d8be-fd5d-4a80d1cd1ba3@redhat.com>
	<alpine.LRH.2.02.1607111027080.14327@file01.intranet.prod.int.rdu2.redhat.com>
	<20160712064905.GA14586@dhcp22.suse.cz>
	<alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Resent-To: dm-devel@redhat.com
Resent-Message-ID: <358c2211-bd6a-d60c-e353-4b63be631b93@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1607121907160.24806@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>, Michal Hocko <mhocko@kernel.org>
Cc: Ondrej Kozina <okozina@redhat.com>, Stanislav Kozina <skozina@redhat.com>, Jerome Marchand <jmarchan@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
List-Id: dm-devel.ids

> On Tue, 12 Jul 2016, Michal Hocko wrote:
> 
>> On Mon 11-07-16 11:43:02, Mikulas Patocka wrote:
>> [...]
>>> The general problem is that the memory allocator does 16 retries to 
>>> allocate a page and then triggers the OOM killer (and it doesn't take into 
>>> account how much swap space is free or how many dirty pages were really 
>>> swapped out while it waited).
>>
>> Well, that is not how it works exactly. We retry as long as there is a
>> reclaim progress (at least one page freed) back off only if the
>> reclaimable memory can exceed watermks which is scaled down in 16
>> retries. The overal size of free swap is not really that important if we
>> cannot swap out like here due to complete memory reserves depletion:
>> https://okozina.fedorapeople.org/bugs/swap_on_dmcrypt/vmlog-1462458369-00000/sample-00011/dmesg:
>> [   90.491276] Node 0 DMA free:0kB min:60kB low:72kB high:84kB active_anon:4096kB inactive_anon:4636kB active_file:212kB inactive_file:280kB unevictable:488kB isolated(anon):0kB isolated(file):0kB present:15992kB managed:15908kB mlocked:488kB dirty:276kB writeback:4636kB mapped:476kB shmem:12kB slab_reclaimable:204kB slab_unreclaimable:4700kB kernel_stack:48kB pagetables:120kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:61132 all_unreclaimable? yes
>> [   90.491283] lowmem_reserve[]: 0 977 977 977
>> [   90.491286] Node 0 DMA32 free:0kB min:3828kB low:4824kB high:5820kB active_anon:423820kB inactive_anon:424916kB active_file:17996kB inactive_file:21800kB unevictable:20724kB isolated(anon):384kB isolated(file):0kB present:1032184kB managed:1001260kB mlocked:20724kB dirty:25236kB writeback:49972kB mapped:23076kB shmem:1364kB slab_reclaimable:13796kB slab_unreclaimable:43008kB kernel_stack:2816kB pagetables:7320kB unstable:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB writeback_tmp:0kB pages_scanned:5635400 all_unreclaimable? yes
>>
>> Look at the amount of free memory. It is completely depleted. So it
>> smells like a process which has access to memory reserves has consumed
>> all of it. I suspect a __GFP_MEMALLOC resp. PF_MEMALLOC from softirq
>> context user which went off the leash.
> 
> It is caused by the commit f9054c70d28bc214b2857cf8db8269f4f45a5e23. Prior 
> to this commit, mempool allocations set __GFP_NOMEMALLOC, so they never 
> exhausted reserved memory. With this commit, mempool allocations drop 
> __GFP_NOMEMALLOC, so they can dig deeper (if the process has PF_MEMALLOC, 
> they can bypass all limits).

I wonder whether commit f9054c70d28bc214 ("mm, mempool: only set
__GFP_NOMEMALLOC if there are free elements") is doing correct thing.
It says

    If an oom killed thread calls mempool_alloc(), it is possible that it'll
    loop forever if there are no elements on the freelist since
    __GFP_NOMEMALLOC prevents it from accessing needed memory reserves in
    oom conditions.

but we can allow mempool_alloc(__GFP_NOMEMALLOC) requests to access
memory reserves via below change, can't we? The purpose of allowing
ALLOC_NO_WATERMARKS via TIF_MEMDIE is to make sure current allocation
request does not to loop forever inside the page allocator, isn't it?
Why we need to allow mempool_alloc(__GFP_NOMEMALLOC) requests to use
ALLOC_NO_WATERMARKS when TIF_MEMDIE is not set?

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6903b69..e4e3700 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3439,14 +3439,14 @@ gfp_to_alloc_flags(gfp_t gfp_mask)
 	} else if (unlikely(rt_task(current)) && !in_interrupt())
 		alloc_flags |= ALLOC_HARDER;
 
-	if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
+	if (!in_interrupt() && unlikely(test_thread_flag(TIF_MEMDIE)))
+		alloc_flags |= ALLOC_NO_WATERMARKS;
+	else if (likely(!(gfp_mask & __GFP_NOMEMALLOC))) {
 		if (gfp_mask & __GFP_MEMALLOC)
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 		else if (in_serving_softirq() && (current->flags & PF_MEMALLOC))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
-		else if (!in_interrupt() &&
-				((current->flags & PF_MEMALLOC) ||
-				 unlikely(test_thread_flag(TIF_MEMDIE))))
+		else if (!in_interrupt() && (current->flags & PF_MEMALLOC))
 			alloc_flags |= ALLOC_NO_WATERMARKS;
 	}
 #ifdef CONFIG_CMA
