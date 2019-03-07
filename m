From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: Serial console is causing system lock-up
Date: Thu, 7 Mar 2019 21:26:42 +0900
Message-ID: <20190307122642.GA10415@tigerII.localdomain>
References: <20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de> <20190307022254.GB4893@jagdpanzerIV>
	<87tvgfhzd6.fsf@linutronix.de> <20190307082509.GA1925@jagdpanzerIV>
	<87pnr3hyle.fsf@linutronix.de> <20190307091748.GA6307@jagdpanzerIV>
	<87o96nezr2.fsf@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87o96nezr2.fsf@linutronix.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Ogness <john.ogness@linutronix.de>
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On (03/07/19 11:37), John Ogness wrote:
> > Sorry John, the reasoning is that I'm trying to understand
> > why this does not look like soft or hard lock-up or RCU stall
> > scenario.
> 
> The reason is that you are seeing data being printed on the console. The
> watchdogs (soft, hard, rcu, nmi) are all touched with each emergency
> message.

Correct. Please see below.

> > The CPU which spins on prb_lock() can have preemption disabled and,
> > additionally, can have local IRQs disabled, or be under RCU read
> > side lock. If consoles are busy, then there are CPUs which printk()
> > data and keep prb_lock contended; prb_lock() does not seem to be
> > fair. What am I missing?
> 
> You are correct. Making prb_lock fair might be something we want to look
> into. Perhaps also based on the loglevel of what needs to be
> printed. (For example, KERN_ALERT always wins over KERN_CRIT.)

Good.

I'm not insisting, but I have a feeling that touching watchdogs after
call_console_drivers() might be too late, sometimes. When we spin in
prb_lock() we wait for all CPUs which are before/ahead of us to
finish their call_console_drivers(), one by one. So if CPUZ is very
unlucky and is in atomic context, then prb_lock() for that CPUZ can
last for  N * call_console_drivers().  And depending on N (which also
includes unfairness) and call_console_drivers() timings NMI watchdog
may pay CPUZ a visit before it gets its chance to touch watchdogs.

*May be* sometimes we might want to touch watchdogs in prb_lock().

So, given the design of new printk(), I can't help thinking about the
fact that current
	"the winner takes it all"
may become
	"the winner waits for all".

Mikulas mentioned that he observes "** X messages dropped" warnings.
And this suggests that, _most likely_, we had significantly more that
2 CPUs calling printk() concurrently.

- A single source - single CPU calling printk() - would not lose messages,
  because it would print its own message before it printk() another one (we
  still could have another CPU rescheduling under console_sem, but I don't
  think this is the case).

- Two CPUs would also probably not lose messages, Steven's console_owner
  would throttle them down.

So I think what we have was a spike of WARN/ERR printk-s comming from
N CPUs concurrently.

And this brings us to another pessimistic scenario: a very unlucky
CPUZ has to spin in prb_lock() waiting for other CPUs to print out
the very same 2 million chars. Which in terms of printk() latency
looks to me just like current printk.

John, sorry to ask this, does new printk() design always provide
latency guarantees good enough for PREEMPT_RT?

I'm surely missing something. Where am I wrong?

	-ss
