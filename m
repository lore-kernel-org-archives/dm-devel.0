From: Petr Mladek <pmladek@suse.com>
Subject: Re: Serial console is causing system lock-up
Date: Thu, 7 Mar 2019 16:35:44 +0100
Message-ID: <20190307153544.zj5ei65mrpk5q3mg@pathway.suse.cz>
References: <20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de> <20190307022254.GB4893@jagdpanzerIV>
	<87tvgfhzd6.fsf@linutronix.de> <20190307082509.GA1925@jagdpanzerIV>
	<87pnr3hyle.fsf@linutronix.de> <20190307091748.GA6307@jagdpanzerIV>
	<87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
	<87r2biojcx.fsf@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87r2biojcx.fsf@linutronix.de>
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
Cc: Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On Thu 2019-03-07 15:21:50, John Ogness wrote:
> On 2019-03-07, Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> >>> The CPU which spins on prb_lock() can have preemption disabled and,
> >>> additionally, can have local IRQs disabled, or be under RCU read
> >>> side lock. If consoles are busy, then there are CPUs which printk()
> >>> data and keep prb_lock contended; prb_lock() does not seem to be
> >>> fair. What am I missing?
> >> 
> >> You are correct. Making prb_lock fair might be something we want to
> >> look into. Perhaps also based on the loglevel of what needs to be
> >> printed. (For example, KERN_ALERT always wins over KERN_CRIT.)
> >
> > Good.
> >
> > I'm not insisting, but I have a feeling that touching watchdogs after
> > call_console_drivers() might be too late, sometimes. When we spin in
> > prb_lock() we wait for all CPUs which are before/ahead of us to
> > finish their call_console_drivers(), one by one. So if CPUZ is very
> > unlucky and is in atomic context, then prb_lock() for that CPUZ can
> > last for  N * call_console_drivers().  And depending on N (which also
> > includes unfairness) and call_console_drivers() timings NMI watchdog
> > may pay CPUZ a visit before it gets its chance to touch watchdogs.
> >
> > *May be* sometimes we might want to touch watchdogs in prb_lock().
> 
> This is an excellent point. The handling of the watchdogs needs to be
> more carefully considered/placed.
> 
> > So, given the design of new printk(), I can't help thinking about the
> > fact that current
> > 	"the winner takes it all"
> > may become
> > 	"the winner waits for all".
>
> I am open to looking at implementing a fair prb_cpulock(). I think
> without it, your observation for these "multi-CPU emergency message
> flood" cases is correct.

This should be rather discussed in the thread about the new printk
implementation.

Anyway, the first version should be acceptable even with the unfair
lock. Please, do not spend time on this now.

There is a bigger problem with the lock. It is not NMI safe as I wrote
in
https://lkml.kernel.org/r/20190227135504.gqtcsdwpy4rd7xvs@pathway.suse.cz
Therefore I am not sure if we could use it at all.


> In a previous response[0] to Petr, I talk about defining _all_ console
> printing as emergency and requiring userspace to handle informational
> messages. With that definition, one could argue that the atomic consoles
> are enough and we could avoid the printk-kthread(s) altogether. I am not
> absolutely against this idea. But there (most likely) will be consoles
> that cannot support atomic. And how should they be handled? We could
> keep the current (quite complex) implementation in place just for
> them. But I really wonder if all that is necessary just for those (few?)
> consoles.

We must keep it as a fallback as long as the "few" group is important
enough for users.


> printk-kthreads seem to me to be the ideal solution
> (particularly when dealing with PREEMPT_RT, where nearly everything
> important becomes a kthread).

This can be solved by a configuration setting. Real-time kernels
might do the offloading more aggressively.

Best Regards,
Petr
