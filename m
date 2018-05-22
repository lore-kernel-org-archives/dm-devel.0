From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 2/4] swait: export the symbols
 __prepare_to_swait and __finish_swait
Date: Mon, 21 May 2018 23:34:25 -0700
Message-ID: <20180522063425.GA7854@infradead.org>
References: <20180519052503.325953342@debian.vm>
	<20180519052633.037700597@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180519052633.037700597@debian.vm>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, peterz@infradead.org, wagi@monom.org, dm-devel@redhat.com, tglx@linutronix.de, Dan Williams <dan.j.williams@intel.com>
List-Id: dm-devel.ids

On Sat, May 19, 2018 at 07:25:05AM +0200, Mikulas Patocka wrote:
> In order to reduce locking overhead, I use the spinlock in
> swait_queue_head to protect not only the wait queue, but also the list of
> events. Consequently, I need to use unlocked functions __prepare_to_swait
> and __finish_swait. These functions are declared in the file
> include/linux/swait.h, but they are not exported, and so they are not
> useable from kernel modules.

Please CC the author and maintainers of the swait code.

My impression is that this is the wrong thing to do.  The swait code
is supposed to be simple and self contained, and if you want to do
anything else use normal waitqueues.

> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> 
> ---
>  kernel/sched/swait.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/kernel/sched/swait.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/swait.c	2018-04-16 21:10:05.000000000 +0200
> +++ linux-2.6/kernel/sched/swait.c	2018-04-16 21:10:05.000000000 +0200
> @@ -75,6 +75,7 @@ void __prepare_to_swait(struct swait_que
>  	if (list_empty(&wait->task_list))
>  		list_add(&wait->task_list, &q->task_list);
>  }
> +EXPORT_SYMBOL(__prepare_to_swait);
>  
>  void prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait, int state)
>  {
> @@ -104,6 +105,7 @@ void __finish_swait(struct swait_queue_h
>  	if (!list_empty(&wait->task_list))
>  		list_del_init(&wait->task_list);
>  }
> +EXPORT_SYMBOL(__finish_swait);
>  
>  void finish_swait(struct swait_queue_head *q, struct swait_queue *wait)
>  {
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
---end quoted text---
