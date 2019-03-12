From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: Serial console is causing system lock-up
Date: Tue, 12 Mar 2019 11:32:31 +0900
Message-ID: <20190312023231.GA4146@jagdpanzerIV>
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
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On (03/07/19 15:21), John Ogness wrote:
> > John, sorry to ask this, does new printk() design always provide
> > latency guarantees good enough for PREEMPT_RT?
> 
> Yes, because it is assumed that emergency messages will never occur for
> a correctly running system.
>
[..]
> Obviously as soon as any emergency message appears, an _unacceptable_
> latency occurs. But that is considered OK because the system is no
> longer running correctly and it is worth the price to pay to get those
> messages with such high reliability.

OK, so what *I'm learning* from this bug report:

10) WARN/ERR messages do not necessarily tell us that the stability of the
    system was jeopardized. The system can "run correctly" and be
    "perfectly healthy".

20) We can have N CPUs reporting issues simultaneously. Even in production.
    Such patterns exist in the kernel.

30) The "reporting part" - printk()->call_console_drivers() - can be the
    slowest one.

  In this particular case, given that Mikulas saw dropped messages,
  checksum calculation was significantly faster than call_console_drivers().
  Now, suppose we have new printk, and suppose we have CPUs A B C D, each of
  them reports a checksum error:

  A prb_lock owner    B prb_lock    C prb_lock    D prb_lock

  A calls call_console_drivers, unlocks prb_lock
  B grabs prb_lock
  B calls call_console_drivers
  A calculates new checksum mismatch
  A calls printk and spins on prb_lock, behind D

  So now we have:

  B prb_lock owner    C prb_lock    D prb_lock    A prb_lock

  And so on

  B C D A  ->  C D A B  ->  D A B C  ->  A B C D  ->  ...

  After M rounds of error reporting (M > N), each CPU, had have to busy
  wait M times (N - 1). Sounds quadratic.

40) goto 10

So I have some doubts regarding some of assumptions behind new printk
design. And the problem is not in prb_lock() unfairness. Current printk
design does look to me SMP-friendly; yes, it has unbound printing loop;
that can be addressed. But it doesn't turn SMP system into UP.

	-ss
