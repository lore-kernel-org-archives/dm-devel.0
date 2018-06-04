From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 13:40:35 -0700
Message-ID: <CA+55aFyzXSOXa94FqgAkK2ZG6HPB1WDmD4rYG-xeo=MEpB62Nw@mail.gmail.com>
References: <20180604153254.GA4793@redhat.com>
	<CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
	<20180604190922.GA5586@redhat.com>
	<CA+55aFyEVcS11N_7BwKV=k0RDqAWdMTJyWDpuFmkXy796k26_w@mail.gmail.com>
	<20180604193653.GC12217@hirez.programming.kicks-ass.net>
	<CA+55aFwkyzV81yEjoFAcjQ68PXxjZ_k-o+oYMobeVMFuj72OHQ@mail.gmail.com>
	<20180604195858.GD12217@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180604195858.GD12217@hirez.programming.kicks-ass.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Zijlstra <peterz@infradead.org>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 4, 2018 at 12:59 PM Peter Zijlstra <peterz@infradead.org> wrote:
>
>
> The below will of course conflict with the merge request under
> discussion. Also completely untested.

Side note: it's not just swake_up() itself.

It's very much the "prepare_to_swait()" logic and the event waiting friends.

For a regular non-exclusive wait-queue, this is all reasonably simple.
Want to wait on an event? Go right ahead. You waiting on it doesn't
affect anybody else waiting on it.

For an swait()  queue, though? What are the semantics of two different
users doing something like

    swait_event_interruptible(wq, <event>);

when coupled with "swake_up_one()"?

The whole notion of "wait until this is true" is not an exclusive wait
per se. And being "interruptible" means that we definitely can be in
the situation that we added ourselves to the wait-queue, but then a
signal happened, so we're going to exit. But what if we were the *one*
thread who got woken up? We can't just return with an error code,
because then we've lost a wakeup.

We do actually have this issue for regular wait-queues too, and I
think we should try to clarify it there as well:

     wait_event_interruptible_exclusive()

is simply a pretty dangerous thing to do. But at least (again) it has
that "exclusive()" in the name, so _hopefully_ users think about it.
The danger is pretty explicit.

The rule for exclusive waits has to be that even if you're
interruptible, you have to first check the event you're waiting for -
because you *have* to take it if it's there.

Alternatively, if you're returning with -EINTR or something, and you
were woken up, you need to do wake_up_one() on the queue you were
waiting on, but now it's already hard to tell whether you were woken
up by the event, or by you being interruptible, so that's already more
complicated (but it's always safe - but might be bad for performance -
to wake up too much).

So I really wish that all the swait interfaces had more of a red flag.
Because right now they all look simple, and they really aren't. They
are all equivalent to the really *complex* cases of the regular
wait-queues.

Again, the "normal" wait queue interfaces that look simple really
_are_ simple. It's simply safe to call

        wait_event{_interruptible}(wq, <event>)

and there are absolutely no subtle gotchas.  You're not affecting any
other waiters, and it's doing exactly what you think it's doing from
reading the code.

In contrast,

        swait_event(wq, <event>)

is much subtler. You're not just waiting on the event, you're also
potentially blocking some other waiter, because only one of you will
be woken up.

So maybe along with "swake_up()" -> "swake_up_one()", we should also
make all the "swait_event*()" functions be renamed as
"swait_event*_exclusive()". Same for the "prepare_to_swait()" etc
cases, add the "_exclusive()" there at the end to mark their special
semantics.

Then the "swait" functions would actually have the same semantics and
gotcha's as the (very specialized) subset of regular wait-queue event
functions.

I think that would cover my worries. Hmm?

                   Linus
