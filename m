From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/2] swait: export the symbols __prepare_to_swait
 and __finish_swait
Date: Thu, 23 Nov 2017 17:27:18 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1711231722440.12809@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711222134370.2330@file01.intranet.prod.int.rdu2.redhat.com> <20171123082857.GA17859@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171123082857.GA17859@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, Daniel Wagner <daniel.wagner@bmw-carit.de>, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids



On Thu, 23 Nov 2017, Christoph Hellwig wrote:

> Please run this past the swait authors.  It is supposed to be a simple
> and self-contained API so I'd expect this patch to be seen critical.

I already sent it to Peter Zijlstra and didn't get a response yet.

> You might be better off to just use the normal complex waitqueues if
> you want to micro-optimize like this.

If we wanted to micro-optimize, we should use the simpler wait queue 
variant.


If these functions are not supposed to be used by others, then
- why are they in in file swait.h?
- why does the implementation export swake_up_locked which assumes that 
someone else will lock the spinlock before calling it?

> On Wed, Nov 22, 2017 at 09:35:36PM -0500, Mikulas Patocka wrote:
> > In order to reduce locking overhead, I use the spinlock in
> > swait_queue_head to protect not only the wait queue, but also the list of
> > events. Consequently, I need to use unlocked functions __prepare_to_swait
> > and __finish_swait. These functions are declared in the file
> > include/linux/swait.h, but they are not exported, and so they are not
> > useable from kernel modules.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  kernel/sched/swait.c |    2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > Index: linux-2.6/kernel/sched/swait.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/sched/swait.c
> > +++ linux-2.6/kernel/sched/swait.c
> > @@ -73,6 +73,7 @@ void __prepare_to_swait(struct swait_que
> >  	if (list_empty(&wait->task_list))
> >  		list_add(&wait->task_list, &q->task_list);
> >  }
> > +EXPORT_SYMBOL(__prepare_to_swait);
> >  
> >  void prepare_to_swait(struct swait_queue_head *q, struct swait_queue *wait, int state)
> >  {
> > @@ -102,6 +103,7 @@ void __finish_swait(struct swait_queue_h
> >  	if (!list_empty(&wait->task_list))
> >  		list_del_init(&wait->task_list);
> >  }
> > +EXPORT_SYMBOL(__finish_swait);
> >  
> >  void finish_swait(struct swait_queue_head *q, struct swait_queue *wait)
> >  {
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel
> ---end quoted text---
> 
