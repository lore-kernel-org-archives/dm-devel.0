From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2] swait: export symbols __prepare_to_swait
 and __finish_swait
Date: Thu, 24 May 2018 16:10:12 +0200
Message-ID: <20180524141012.GH12198@hirez.programming.kicks-ass.net>
References: <20180519052503.325953342@debian.vm>
	<20180519052633.037700597@debian.vm>
	<20180522063425.GA7854@infradead.org>
	<20180522185037.GB25826@redhat.com>
	<20180523092101.GW12217@hirez.programming.kicks-ass.net>
	<20180523151011.GA30696@redhat.com>
	<20180523181046.GA54883@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180523181046.GA54883@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, wagi@monom.org, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Dan Williams <dan.j.williams@intel.com>, tglx@linutronix.de
List-Id: dm-devel.ids

On Wed, May 23, 2018 at 02:10:46PM -0400, Mike Snitzer wrote:
> [Peter, in this v2 I switched to using _GPL for the exports and updated
> the patch header.  As covered in previous mail, please let me know if
> you're OK with me staging this change for 4.18 via linux-dm.git with
> your Ack, thanks]
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> Subject: [PATCH] swait: export symbols __prepare_to_swait and __finish_swait
> 
> __prepare_to_swait and __finish_swait are declared in
> include/linux/swait.h but they are not exported; so they are not useable
> from kernel modules.
> 
> A new consumer of swait (in dm-writecache) reduces its locking overhead
> by using the spinlock in swait_queue_head to protect not only the wait
> queue, but also the list of events.  Consequently, this swait consuming
> kernel module needs to use these unlocked functions.
> 
> Peter Zijlstra explained:
>   "The reason swait exists is to be deterministic (for RT) -- something
>   that regular wait code cannot be.
>   And by (ab)using / exporting the wait internal lock you risk losing
>   that. So I don't think the proposed [dm-writecache] usage is bad, it
>   is possible to create badness.
>   So if we're going to export them; someone needs to keep an eye on things
>   and ensure the lock isn't abused."
> 
> So while this new use of the wait internal lock doesn't jeopardize the
> realtime requirements of swait, these exports do open swait's internal
> locking up to being abused.  As such, EXPORT_SYMBOL_GPL is used because
> any future consumers of __prepare_to_swait and __finish_swait must
> always be thoroughly scrutinized.
> 

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  kernel/sched/swait.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/kernel/sched/swait.c b/kernel/sched/swait.c
> index b6fb2c3b3ff7..5d891b65ada5 100644
> --- a/kernel/sched/swait.c
> +++ b/kernel/sched/swait.c
> @@ -75,6 +75,7 @@ void __prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait)
>  	if (list_empty(&wait->task_list))
>  		list_add(&wait->task_list, &q->task_list);
>  }
> +EXPORT_SYMBOL_GPL(__prepare_to_swait);
>  
>  void prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait, int state)
>  {
> @@ -104,6 +105,7 @@ void __finish_swait(struct swait_queue_head *q, struct swait_queue *wait)
>  	if (!list_empty(&wait->task_list))
>  		list_del_init(&wait->task_list);
>  }
> +EXPORT_SYMBOL_GPL(__finish_swait);
>  
>  void finish_swait(struct swait_queue_head *q, struct swait_queue *wait)
>  {
> -- 
> 2.15.0
> 
