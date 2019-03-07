From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Serial console is causing system lock-up
Date: Thu, 7 Mar 2019 07:54:44 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1903070744580.20758@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de> <20190307022254.GB4893@jagdpanzerIV>
	<87tvgfhzd6.fsf@linutronix.de>
	<20190307082509.GA1925@jagdpanzerIV> <87pnr3hyle.fsf@linutronix.de>
	<20190307091748.GA6307@jagdpanzerIV> <87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190307122642.GA10415@tigerII.localdomain>
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
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, John Ogness <john.ogness@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, dm-devel@redhat.com, linux-serial@vger.kernel.org
List-Id: dm-devel.ids



On Thu, 7 Mar 2019, Sergey Senozhatsky wrote:

> On (03/07/19 11:37), John Ogness wrote:
> > > Sorry John, the reasoning is that I'm trying to understand
> > > why this does not look like soft or hard lock-up or RCU stall
> > > scenario.
> > 
> > The reason is that you are seeing data being printed on the console. The
> > watchdogs (soft, hard, rcu, nmi) are all touched with each emergency
> > message.
> 
> Correct. Please see below.
> 
> > > The CPU which spins on prb_lock() can have preemption disabled and,
> > > additionally, can have local IRQs disabled, or be under RCU read
> > > side lock. If consoles are busy, then there are CPUs which printk()
> > > data and keep prb_lock contended; prb_lock() does not seem to be
> > > fair. What am I missing?
> > 
> > You are correct. Making prb_lock fair might be something we want to look
> > into. Perhaps also based on the loglevel of what needs to be
> > printed. (For example, KERN_ALERT always wins over KERN_CRIT.)
> 
> Good.
> 
> I'm not insisting, but I have a feeling that touching watchdogs after
> call_console_drivers() might be too late, sometimes. When we spin in

There are still NMI stacktraces - see here 
http://people.redhat.com/~mpatocka/testcases/console-lockup/

> prb_lock() we wait for all CPUs which are before/ahead of us to
> finish their call_console_drivers(), one by one. So if CPUZ is very
> unlucky and is in atomic context, then prb_lock() for that CPUZ can
> last for  N * call_console_drivers().  And depending on N (which also
> includes unfairness) and call_console_drivers() timings NMI watchdog
> may pay CPUZ a visit before it gets its chance to touch watchdogs.
> 
> *May be* sometimes we might want to touch watchdogs in prb_lock().
> 
> So, given the design of new printk(), I can't help thinking about the
> fact that current
> 	"the winner takes it all"
> may become
> 	"the winner waits for all".
> 
> Mikulas mentioned that he observes "** X messages dropped" warnings.
> And this suggests that, _most likely_, we had significantly more that
> 2 CPUs calling printk() concurrently.

When I observe these messages (usually with small log buffer size), it 
doesn't lockup.

The lockups happen because the messages are stuffed into a 2MiB buffer and 
then printed over 115200 baud serial line.

You can see this: 
http://people.redhat.com/~mpatocka/testcases/console-lockup/5.0-total-lockup.txt

Here it attempted to write 1355277 bytes over the slow serial line - it 
takes a few minutes.

> - A single source - single CPU calling printk() - would not lose messages,
>   because it would print its own message before it printk() another one (we
>   still could have another CPU rescheduling under console_sem, but I don't
>   think this is the case).
> 
> - Two CPUs would also probably not lose messages, Steven's console_owner
>   would throttle them down.
> 
> So I think what we have was a spike of WARN/ERR printk-s comming from
> N CPUs concurrently.

Losing messages is in my opinion reasonable (if they are produced faster 
than they could be printed). Another possibility is to always write the 
message synchronously and exit printk only after it is written.

> And this brings us to another pessimistic scenario: a very unlucky
> CPUZ has to spin in prb_lock() waiting for other CPUs to print out
> the very same 2 million chars. Which in terms of printk() latency
> looks to me just like current printk.
> 
> John, sorry to ask this, does new printk() design always provide
> latency guarantees good enough for PREEMPT_RT?
> 
> I'm surely missing something. Where am I wrong?
> 
> 	-ss

Mikulas
