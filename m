From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: Serial console is causing system lock-up
Date: Thu, 14 Mar 2019 19:30:45 +0900
Message-ID: <20190314103045.GA24210@jagdpanzerIV>
References: <87pnr3hyle.fsf@linutronix.de> <20190307091748.GA6307@jagdpanzerIV>
	<87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
	<87r2biojcx.fsf@linutronix.de> <20190312023231.GA4146@jagdpanzerIV>
	<87a7i05wwi.fsf@linutronix.de>
	<20190312120824.4eaa4eyjcxvuzm23@pathway.suse.cz>
	<20190313023836.GC783@jagdpanzerIV> <878sxj9nbb.fsf@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <878sxj9nbb.fsf@linutronix.de>
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

On (03/13/19 09:43), John Ogness wrote:
> I don't understand how you can think "print or die trying" is replaced
> with another "print or die trying".

Sorry, let me explain. In some contexts CPUs which are spinning on
prb_lock don't do anything else. A careful placement of

        touch_softlockup_watchdog_sync();
        clocksource_touch_watchdog();
        rcu_cpu_stall_reset();
        touch_nmi_watchdog();

keeps the watchdogs away, yes, but that doesn't mean that we are not
sitting on a time bomb. Think of RCU, for instance. We keep rcu_cpu_stall
silent and things can look OK, but that doesn't mean that RCU is OK in
reality; spinning CPUs may hold off grace periods. So now a relatively
simple issue - raid checksum mismatch in this particular case - has
potential to become OOM. Quadratic CPU serialisation doesn't scale.
Throw enough reporting CPUs on it and we may get very close to some
big problems. Does this make sense?

This bug report demonstrates that we can have N CPUs reporting warns
simultaneously. And I think that people would want to have pr_warns
and WARN_ONs to be printed as emergency level messages (it sort of
sounds reasonable. I understand that you have different opinion on this).

And what I'm thinking is that *probably* we can have a bit less radical
approach - the system is not always doomed when it WARNs us - and a bit
more "best effort" one. *May be* we don't need to apply full serialisation
all the time. *May be* full serialisation can be applied only when we see
that we are about to run out of free space in logbuf. Or may be can
start dynamically resize the logbuf. And so on.

> By the way, Sergey, I appreciate your skepticism.

Sorry, John. I know I'm a PITA.

	-ss
