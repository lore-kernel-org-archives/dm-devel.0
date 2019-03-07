From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: Serial console is causing system lock-up
Date: Thu, 7 Mar 2019 18:17:48 +0900
Message-ID: <20190307091748.GA6307@jagdpanzerIV>
References: <20190306152218.eocv4zulf7tv2mkc@pathway.suse.cz>
	<alpine.LRH.2.02.1903061031420.16905@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de> <20190307022254.GB4893@jagdpanzerIV>
	<87tvgfhzd6.fsf@linutronix.de> <20190307082509.GA1925@jagdpanzerIV>
	<87pnr3hyle.fsf@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87pnr3hyle.fsf@linutronix.de>
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

On (03/07/19 09:34), John Ogness wrote:
> >> When the console is constantly printing messages, I wouldn't say that
> >> looks like a lock-up scenario. It looks like the system is busy
> >> printing critical information to the console (which it is).
> >
> > What if we have N tasks/CPUs calling printk() simultaneously?
> 
> Then they take turns printing their messages to the console, spinning
> until they get their turn. This still is not and does not look like a
> lock-up. But I think you already know this, so I don't understand the
> reasoning behind asking the question. Maybe you could clarify what you
> are getting at.

Sorry John, the reasoning is that I'm trying to understand
why this does not look like soft or hard lock-up or RCU stall
scenario.

The CPU which spins on prb_lock() can have preemption disabled and,
additionally, can have local IRQs disabled, or be under RCU read
side lock. If consoles are busy, then there are CPUs which printk()
data and keep prb_lock contended; prb_lock() does not seem to be
fair. What am I missing? You probably talk about the case when all
printing CPUs are in preemptible contexts (assumingly this is what
is happening in dm-integrity case) so they can spin on prb_lock(),
that's OK. The case I'm talking about is - what if we have the same
situation, but then one of the CPUs printk()-s from !preemptible.
Does this make sense?

	-ss
