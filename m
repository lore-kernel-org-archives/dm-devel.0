From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: Serial console is causing system lock-up
Date: Tue, 12 Mar 2019 17:59:34 +0900
Message-ID: <20190312085934.GA1383@jagdpanzerIV>
References: <20190307022254.GB4893@jagdpanzerIV> <87tvgfhzd6.fsf@linutronix.de>
	<20190307082509.GA1925@jagdpanzerIV> <87pnr3hyle.fsf@linutronix.de>
	<20190307091748.GA6307@jagdpanzerIV> <87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
	<87r2biojcx.fsf@linutronix.de> <20190312023231.GA4146@jagdpanzerIV>
	<87a7i05wwi.fsf@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87a7i05wwi.fsf@linutronix.de>
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

On (03/12/19 09:17), John Ogness wrote:
> >   wait M times (N - 1). Sounds quadratic.
> 
> If these are critical messages, then we are _not allowed to drop any_!
> For critical messages printk must be synchronous. Thus for critical
> messages the situation you illustrated is appropriate.
> 
> > 40) goto 10
> >
> > So I have some doubts regarding some of assumptions behind new printk
> > design. And the problem is not in prb_lock() unfairness. Current
> > printk design does look to me SMP-friendly; yes, it has unbound
> > printing loop; that can be addressed.
> 
> Let us not forget, it deadlocked the machine. That's the reason this
> thread exists.

It didn't deadlock the machine. It was a typical soft lockup. Printing
CPU loop-ed in console_unlock() with preemption disabled; soft lockup
hrtimer was running on that CPU, but due to disabled preemption around
console_unlock() soft lockup's per-CPU kthread could not get scheduled
and could not update per-CPU touch_ts. Soft lockup hrtimer detected it:

[ 5128.552442] watchdog: BUG: soft lockup - CPU#9 stuck for 23s! [kworker/9:53:4131]

Along with that RCU was not able to get scheduled. Which was detected
by RCU stall detector:

[ 4891.199009] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[ 4891.221308] device-mapper: integrity: Checksum failed at sector 0x118d4f
[ 4891.251366] rcu:     9-....: (1923 ticks this GP) idle=7fa/1/0x4000000000000002 softirq=2190/2190 fqs=15013
[ 4891.251367] rcu:     (detected by 16, t=60054 jiffies, g=24641, q=351)
[ 4891.311941] Sending NMI from CPU 16 to CPUs 9:

[..]
> 2. You seem unwilling to acknowledge the difference between emergency
>    and informational messages. A message is either critical or it is
>    not. If it is, it should be handled as such, regardless of
>    interference, regardless if it means turning an SMP machine into a UP
>    machine. If it is not critical, it should be sent along a
>    non-interfering path so the the system is _not_ affected.

OK.
Let's move on then.

	-ss
