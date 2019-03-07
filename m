From: John Ogness <john.ogness@linutronix.de>
Subject: Re: Serial console is causing system lock-up
Date: Thu, 07 Mar 2019 15:21:50 +0100
Message-ID: <87r2biojcx.fsf@linutronix.de>
References: <20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de> <20190307022254.GB4893@jagdpanzerIV>
	<87tvgfhzd6.fsf@linutronix.de> <20190307082509.GA1925@jagdpanzerIV>
	<87pnr3hyle.fsf@linutronix.de> <20190307091748.GA6307@jagdpanzerIV>
	<87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190307122642.GA10415@tigerII.localdomain> (Sergey
	Senozhatsky's message of "Thu, 7 Mar 2019 21:26:42 +0900")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On 2019-03-07, Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
>>> The CPU which spins on prb_lock() can have preemption disabled and,
>>> additionally, can have local IRQs disabled, or be under RCU read
>>> side lock. If consoles are busy, then there are CPUs which printk()
>>> data and keep prb_lock contended; prb_lock() does not seem to be
>>> fair. What am I missing?
>> 
>> You are correct. Making prb_lock fair might be something we want to
>> look into. Perhaps also based on the loglevel of what needs to be
>> printed. (For example, KERN_ALERT always wins over KERN_CRIT.)
>
> Good.
>
> I'm not insisting, but I have a feeling that touching watchdogs after
> call_console_drivers() might be too late, sometimes. When we spin in
> prb_lock() we wait for all CPUs which are before/ahead of us to
> finish their call_console_drivers(), one by one. So if CPUZ is very
> unlucky and is in atomic context, then prb_lock() for that CPUZ can
> last for  N * call_console_drivers().  And depending on N (which also
> includes unfairness) and call_console_drivers() timings NMI watchdog
> may pay CPUZ a visit before it gets its chance to touch watchdogs.
>
> *May be* sometimes we might want to touch watchdogs in prb_lock().

This is an excellent point. The handling of the watchdogs needs to be
more carefully considered/placed.

> So, given the design of new printk(), I can't help thinking about the
> fact that current
> 	"the winner takes it all"
> may become
> 	"the winner waits for all".

I am open to looking at implementing a fair prb_cpulock(). I think
without it, your observation for these "multi-CPU emergency message
flood" cases is correct.

> [...]
>
> And this brings us to another pessimistic scenario: a very unlucky
> CPUZ has to spin in prb_lock() waiting for other CPUs to print out
> the very same 2 million chars. Which in terms of printk() latency
> looks to me just like current printk.

If the prb_cpulock() is fair, they are both taking turns printing. The
prb_cpulock() is taken for _each_ printk() call and not (like in the
current printk) for the complete unprinted contents of the ringbuffer.

> John, sorry to ask this, does new printk() design always provide
> latency guarantees good enough for PREEMPT_RT?

Yes, because it is assumed that emergency messages will never occur for
a correctly running system. We've run tests where we pr_info() from all
contexts and the console_loglevel is set such that KERN_INFO is printed
to the console. The storage of the messages into the printk ringbuffer
do not cause any unacceptable latencies. And printing those messages to
the consoles via the fully preemptible printk-kthread also causes no
unacceptable latencies.

Obviously as soon as any emergency message appears, an _unacceptable_
latency occurs. But that is considered OK because the system is no
longer running correctly and it is worth the price to pay to get those
messages with such high reliability.

In a previous response[0] to Petr, I talk about defining _all_ console
printing as emergency and requiring userspace to handle informational
messages. With that definition, one could argue that the atomic consoles
are enough and we could avoid the printk-kthread(s) altogether. I am not
absolutely against this idea. But there (most likely) will be consoles
that cannot support atomic. And how should they be handled? We could
keep the current (quite complex) implementation in place just for
them. But I really wonder if all that is necessary just for those (few?)
consoles. printk-kthreads seem to me to be the ideal solution
(particularly when dealing with PREEMPT_RT, where nearly everything
important becomes a kthread). My RFC series implements a very simple
(naive) approach to kthread printing. I believe there is a lot[1][2] we
can do to make the printk-kthread printing more reliable.

John Ogness

[0] https://lkml.kernel.org/r/87k1hbbq2m.fsf@linutronix.de
[1] https://lkml.kernel.org/r/87o96p9gtx.fsf@linutronix.de
[2] https://lkml.kernel.org/r/87lg1rggcz.fsf@linutronix.de
