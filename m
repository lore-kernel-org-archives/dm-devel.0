From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 4.18
Date: Mon, 4 Jun 2018 12:29:21 -0700
Message-ID: <CA+55aFyEVcS11N_7BwKV=k0RDqAWdMTJyWDpuFmkXy796k26_w@mail.gmail.com>
References: <20180604153254.GA4793@redhat.com>
	<CA+55aFyZk6Yeo0DSdakROxXRPvx9HWutbP1TwfoFd6fi-1FSUw@mail.gmail.com>
	<20180604190922.GA5586@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180604190922.GA5586@redhat.com>
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
Cc: Peter Zijlstra <peterz@infradead.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Mon, Jun 4, 2018 at 12:09 PM Mike Snitzer <snitzer@redhat.com> wrote:
>
> Mikulas elected to use swait because of the very low latency nature of
> layering ontop of persistent memory.  Use of "simple waitqueues"
> _seemed_ logical to me.

I know. It's actually the main reason I have an almost irrational
hatred of those interfaces. They _look_ so simple and obvious, and
they are very tempting to use. And then they have that very subtle
issue that the default wakeup is exclusive.

I've actually wanted to remove them entirely, but there are two
existing users (kvm and rcu), and the RCU one actually is a good user.
The kvm one is completely pointless, but I haven't had the energy to
just change it to use a direct task pointer, and I was hoping the kvm
people would do that themselves (because it should be both faster and
simpler than swait).

One option might be to rename them to be less tempting. Instead of
"swait" where the "s" stands for "simple" (which it isn't, because the
complexity is in the subtle semantics), we could perhaps write it out
as "specialized_wait". Make people actually write that "specialized"
word out, and maybe they'd have to be aware of just how subtle the
differences are to normal wait-queues.

Because those functions *are* smaller and can definitely be faster and
have lower latencies. So in *theory* they are perfectly fine, it's
just that they need a *lot* of careful thinking about before  you use
them.

So the rules with swake lists are that you either have to

 (a) use "swake_up_all()" to wake up everybody

 (b) be *very* careful and guarantee that every single place that
sleeps on an swait queue will actually consume the resource that it
was waiting on - or wake up the next sleeper.

and usually people absolutely don't want to do (a), and then they get (b) wrong.

And when you get (b) wrong, you can end up with processes stuck
waiting on things even after they got released. But in *practice* it
almost never actually happens, particularly if you have some array of
resources - like that freelist - where once somebody gets a resource,
they'll do another wakeup when they release it, so if you have lots of
threads that fight for the resource, you'll also end up with lots of
wakeups. Even if some thread ends up being blocked when there are free
resources, _another_ thread will come in, pick up one of those free
resources, and then wake up the incorrectly blocked one when it is
done.

So it's actually really hard to see the bug in practice. you have to
have really bad luck to first hit that "don't wake up the next waiter,
because the waiter that you _did_ wake didn't need the resource after
all", and then you also have to stop allocating (and freeing) other
copies of that resource.

So the common case is that you never really see the problem as a
deadlock, but you _can_ see it as an odd blip that basically is "stop
handling requests for one thread, until another thread comes in and
starts doing requests, which then restarts the first thread".

And don't get me wrong - you can get the exact same problem with
regular wait-queues too, but then you have to explicitly say "I'm an
exclusive waiter" and violate the rules for exclusivity.  We've had
that, but then I blame the user, not the wait-queue interface itself.

             Linus
