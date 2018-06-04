From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 15:16:31 -0700
Message-ID: <CA+55aFz8WL99++EeU=HjSo=w153zwsFqNaRcQk+nkjf8u_3beQ@mail.gmail.com>
References: <20180604153254.GA4793@redhat.com>
	<CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
	<20180604190922.GA5586@redhat.com>
	<CA+55aFyEVcS11N_7BwKV=k0RDqAWdMTJyWDpuFmkXy796k26_w@mail.gmail.com>
	<20180604193653.GC12217@hirez.programming.kicks-ass.net>
	<CA+55aFwkyzV81yEjoFAcjQ68PXxjZ_k-o+oYMobeVMFuj72OHQ@mail.gmail.com>
	<20180604195858.GD12217@hirez.programming.kicks-ass.net>
	<20180604211343.GB6079@redhat.com>
	<CA+55aFwSyiotexs3omf76=Ooo_rJFwdcpw=nF5pMd4bNkvN89A@mail.gmail.com>
	<alpine.LRH.2.02.1806041734390.11883@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1806041734390.11883@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 4, 2018 at 2:53 PM Mikulas Patocka <mpatocka@redhat.com> wrote:
>
> I'd be interested - does the kernel deal properly with spurious wake-up? -
> i.e. suppose that the kernel thread that I created is doing simething else
> in a completely different subsystem - can I call wake_up_process on it?
> Could it confuse some unrelated code?

We've always had that issue, and yes, we should handle it fine. Code
that doesn't handle it fine is broken, but I don't think we've ever
had that situation.

For example, a common case of "spurious" wakeups is when somebody adds
itself to a wait list, but then ends up doing other things (including
taking page faults because of user access etc). The wait-list is still
active, and events on the wait list will still wake people up, even if
they are sleeping on some *other* list too.

In fact, an example of spurious wakeups comes from just using regular
futexes. We send those locklessly, and you actually can get a futex
wakeup *after* you thought you removed yourself from the futex queue.

But that's actually only an example of the much more generic issue -
we've always supported having multiple sources of wakeups, so
"spurious" wakups have always been a thing.

People are probably not so aware of it, because they've never been an
actual _problem_.

Why? Our sleep/wake model has never been that "I woke up, so what I
waited on must be done". Our sleep/wake model has always been one
where being woken up just means that you go back and repeat the
checks.

The whole "wait_event()" loop being the most core example of that
model, but that's actually not the *traditional* model. Our really
traditional model of waiting for something actually predates
wait_event(), and is an explicit loop like

    add_to_wait_queue(..);
    for (;;) {
        set_task_state(TASK_INTERRUPTIBLE);
        .. see if we need to sleep, exit if ok ..
        schedule();
    }
    remove_from_wait_queue(..);

so even pretty much from day #1, the whole notion of "spurious wake
events" is a non-issue.

(We did have a legacy "sleep_on()" interface back in the dark ages,
but even that was supposed to be used in a loop).

> The commonly used synchronization primitives recheck the condition after
> wake-up, but it's hard to verify that the whole kernel does it.

See above. We have those spurious wakeups already.

> It looked to me like the standard wait-queues suffers from feature creep
> (three flags, high number of functions abd macros, it even uses an
> indirect call to wake something up) - that's why I used swait.

I agree that the standard wait-queues have gotten much more complex
over the years. But apart from the wait entries being a bit big, they
actually should not perform badly.,

The real problem with wait-queues is that because of their semantics,
you *can* end up walking the whole queue, waking up hundreds (or
thousands) of processes. That can be a latency issue for RT.

But the answer to that tends to be "don't do that then". If you have
wait-queues that can have thousands of entries, there's likely
something seriously wrong somewhere. We've had it, but it's very very
rare.

                        Linus
