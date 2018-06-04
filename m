From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 17:53:27 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1806041734390.11883@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180604153254.GA4793@redhat.com>
	<CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
	<20180604190922.GA5586@redhat.com>
	<CA+55aFyEVcS11N_7BwKV=k0RDqAWdMTJyWDpuFmkXy796k26_w@mail.gmail.com>
	<20180604193653.GC12217@hirez.programming.kicks-ass.net>
	<CA+55aFwkyzV81yEjoFAcjQ68PXxjZ_k-o+oYMobeVMFuj72OHQ@mail.gmail.com>
	<20180604195858.GD12217@hirez.programming.kicks-ass.net>
	<20180604211343.GB6079@redhat.com>
	<CA+55aFwSyiotexs3omf76=Ooo_rJFwdcpw=nF5pMd4bNkvN89A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CA+55aFwSyiotexs3omf76=Ooo_rJFwdcpw=nF5pMd4bNkvN89A@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



On Mon, 4 Jun 2018, Linus Torvalds wrote:

> On Mon, Jun 4, 2018 at 2:13 PM Mike Snitzer <snitzer@redhat.com> wrote:
> >
> > (Mikulas would like to still use swait for the dm-writecache's endio
> > thread, since endio_thread_wait only has a single waiter.
> 
> If you already know it has a single waiter, please don't use a queue at all.
> 
> Just have the "struct task_struct *" in the waiter field, and use
> "wake_up_process()". Use NULL for "no process".

I'd be interested - does the kernel deal properly with spurious wake-up? - 
i.e. suppose that the kernel thread that I created is doing simething else 
in a completely different subsystem - can I call wake_up_process on it? 
Could it confuse some unrelated code?

The commonly used synchronization primitives recheck the condition after 
wake-up, but it's hard to verify that the whole kernel does it.

> That's *much* simpler than swait(), and is a well-accepted traditional
> wake interface. It's also really really obvious.
> 
> The "there is only a single waiter" is *NOT* an excuse for using
> swait. Quite the reverse. Using swait is stupid, slow, and complex.
> And it generates code that is harder to understand.

It looked to me like the standard wait-queues suffers from feature creep 
(three flags, high number of functions abd macros, it even uses an 
indirect call to wake something up) - that's why I used swait.

> And yes, the fact that KVM also made that completely idiotic choice in
> their apic code is not an excuse either. I have no idea why they did
> it either. It's stupid. In the kvm case, I think what happened was
> that they had a historical wait-queue model, and they just didn't
> realize that they al;ways had just one waiter, so then they converted
> a waitqueue to a swait queue.
> 
> But if you already know there is only ever one waiter, please don't do
> that. Just avoid queues entirely.
> 
>                   Linus

Mikulas
