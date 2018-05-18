From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] swait: export the symbols __prepare_to_swait and
 __finish_swait
Date: Fri, 18 May 2018 17:03:23 -0400
Message-ID: <20180518210323.GA6119@redhat.com>
References: <alpine.LRH.2.02.1711222134370.2330@file01.intranet.prod.int.rdu2.redhat.com>
 <20171123082857.GA17859@infradead.org>
 <alpine.LRH.2.02.1711231722440.12809@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1711231722440.12809@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-rt-users@vger.kernel.org, Daniel Wagner <daniel.wagner@bmw-carit.de>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>
List-Id: dm-devel.ids

On Thu, Nov 23 2017 at  5:27pm -0500,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> 
> 
> On Thu, 23 Nov 2017, Christoph Hellwig wrote:
> 
> > Please run this past the swait authors.  It is supposed to be a simple
> > and self-contained API so I'd expect this patch to be seen critical.
> 
> I already sent it to Peter Zijlstra and didn't get a response yet.
> 
> > You might be better off to just use the normal complex waitqueues if
> > you want to micro-optimize like this.
> 
> If we wanted to micro-optimize, we should use the simpler wait queue 
> variant.
> 
> 
> If these functions are not supposed to be used by others, then
> - why are they in in file swait.h?
> - why does the implementation export swake_up_locked which assumes that 
> someone else will lock the spinlock before calling it?

Hi,

I'd like to get this patch upstream.  I'm happy to send it to Linus via
linux-dm.git but I wanted to check with others who might care more
deeply about swait interfaces to get their Ack (or otherwise):
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.18&id=4a2ec3f321f83db09da4824025420586c9ef1612

Here is Mikulas' DM driver code that makes use of __prepare_to_swait()
and __finish_swait():

static int writecache_endio_thread(void *data)
{
        struct dm_writecache *wc = data;

        while (1) {
                DECLARE_SWAITQUEUE(wait);
                struct list_head list;

                raw_spin_lock_irq(&wc->endio_thread_wait.lock);
continue_locked:
                if (!list_empty(&wc->endio_list))
                        goto pop_from_list;
                set_current_state(TASK_INTERRUPTIBLE);
                __prepare_to_swait(&wc->endio_thread_wait, &wait);
                raw_spin_unlock_irq(&wc->endio_thread_wait.lock);

                if (unlikely(kthread_should_stop())) {
                        finish_swait(&wc->endio_thread_wait, &wait);
                        break;
                }

                schedule();

                raw_spin_lock_irq(&wc->endio_thread_wait.lock);
                __finish_swait(&wc->endio_thread_wait, &wait);
                goto continue_locked;

pop_from_list:
                list = wc->endio_list;
                list.next->prev = list.prev->next = &list;
                INIT_LIST_HEAD(&wc->endio_list);
                raw_spin_unlock_irq(&wc->endio_thread_wait.lock);
                ...
