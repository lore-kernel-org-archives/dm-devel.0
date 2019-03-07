From: John Ogness <john.ogness@linutronix.de>
Subject: Re: Serial console is causing system lock-up
Date: Thu, 07 Mar 2019 11:37:53 +0100
Message-ID: <87o96nezr2.fsf@linutronix.de>
References: <20190306152218.eocv4zulf7tv2mkc@pathway.suse.cz>
	<alpine.LRH.2.02.1903061031420.16905@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de> <20190307022254.GB4893@jagdpanzerIV>
	<87tvgfhzd6.fsf@linutronix.de> <20190307082509.GA1925@jagdpanzerIV>
	<87pnr3hyle.fsf@linutronix.de> <20190307091748.GA6307@jagdpanzerIV>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190307091748.GA6307@jagdpanzerIV> (Sergey Senozhatsky's
	message of "Thu, 7 Mar 2019 18:17:48 +0900")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On 2019-03-07, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:
>>>> When the console is constantly printing messages, I wouldn't say
>>>> that looks like a lock-up scenario. It looks like the system is
>>>> busy printing critical information to the console (which it is).
>>>
>>> What if we have N tasks/CPUs calling printk() simultaneously?
>> 
>> Then they take turns printing their messages to the console, spinning
>> until they get their turn. This still is not and does not look like a
>> lock-up. But I think you already know this, so I don't understand the
>> reasoning behind asking the question. Maybe you could clarify what
>> you are getting at.
>
> Sorry John, the reasoning is that I'm trying to understand
> why this does not look like soft or hard lock-up or RCU stall
> scenario.

The reason is that you are seeing data being printed on the console. The
watchdogs (soft, hard, rcu, nmi) are all touched with each emergency
message.

> The CPU which spins on prb_lock() can have preemption disabled and,
> additionally, can have local IRQs disabled, or be under RCU read
> side lock. If consoles are busy, then there are CPUs which printk()
> data and keep prb_lock contended; prb_lock() does not seem to be
> fair. What am I missing?

You are correct. Making prb_lock fair might be something we want to look
into. Perhaps also based on the loglevel of what needs to be
printed. (For example, KERN_ALERT always wins over KERN_CRIT.)

> You probably talk about the case when all
> printing CPUs are in preemptible contexts (assumingly this is what
> is happening in dm-integrity case) so they can spin on prb_lock(),
> that's OK. The case I'm talking about is - what if we have the same
> situation, but then one of the CPUs printk()-s from !preemptible.
> Does this make sense?

Yes, you are referring to a worst case. We could have local_irqs
disabled on every CPU while every CPU is hit with an NMI and all those
NMIs want to dump a load of messages. The rest of the system will be
frozen until those NMI printers can finish. But that is still not a
lock-up. At some point those printers should finish and eventually the
system should be able to resume.

John Ogness
