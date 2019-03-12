From: John Ogness <john.ogness@linutronix.de>
Subject: Re: Serial console is causing system lock-up
Date: Tue, 12 Mar 2019 09:17:49 +0100
Message-ID: <87a7i05wwi.fsf@linutronix.de>
References: <20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de> <20190307022254.GB4893@jagdpanzerIV>
	<87tvgfhzd6.fsf@linutronix.de> <20190307082509.GA1925@jagdpanzerIV>
	<87pnr3hyle.fsf@linutronix.de> <20190307091748.GA6307@jagdpanzerIV>
	<87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
	<87r2biojcx.fsf@linutronix.de> <20190312023231.GA4146@jagdpanzerIV>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190312023231.GA4146@jagdpanzerIV> (Sergey Senozhatsky's
	message of "Tue, 12 Mar 2019 11:32:31 +0900")
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

On 2019-03-12, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:
>>> John, sorry to ask this, does new printk() design always provide
>>> latency guarantees good enough for PREEMPT_RT?
>> 
>> Yes, because it is assumed that emergency messages will never occur
>> for a correctly running system.
>>
> [..]
>> Obviously as soon as any emergency message appears, an _unacceptable_
>> latency occurs. But that is considered OK because the system is no
>> longer running correctly and it is worth the price to pay to get
>> those messages with such high reliability.
>
> OK, so what *I'm learning* from this bug report:
>
> 10) WARN/ERR messages do not necessarily tell us that the stability of
>     the system was jeopardized. The system can "run correctly" and be
>     "perfectly healthy".

If the messages from this report are not critical, they should not be
classified as emergency messages. It is a bug if they are.

> 20) We can have N CPUs reporting issues simultaneously. Even in
>     production.  Such patterns exist in the kernel.

Sure. But it is important to distinguish if these messages are critical
or just informational.

> 30) The "reporting part" - printk()->call_console_drivers() - can be
>     the slowest one.
>
>   In this particular case, given that Mikulas saw dropped messages,
>   checksum calculation was significantly faster than
>   call_console_drivers(). Now, suppose we have new printk, and
>   suppose we have CPUs A B C D, each of them reports a checksum error:
>
>   A prb_lock owner    B prb_lock    C prb_lock    D prb_lock
>
>   A calls call_console_drivers, unlocks prb_lock
>   B grabs prb_lock
>   B calls call_console_drivers
>   A calculates new checksum mismatch
>   A calls printk and spins on prb_lock, behind D
>
>   So now we have:
>
>   B prb_lock owner    C prb_lock    D prb_lock    A prb_lock
>
>   And so on
>
>   B C D A  ->  C D A B  ->  D A B C  ->  A B C D  ->  ...
>
>   After M rounds of error reporting (M > N), each CPU, had have to busy
>   wait M times (N - 1). Sounds quadratic.

If these are critical messages, then we are _not allowed to drop any_!
For critical messages printk must be synchronous. Thus for critical
messages the situation you illustrated is appropriate.

> 40) goto 10
>
> So I have some doubts regarding some of assumptions behind new printk
> design. And the problem is not in prb_lock() unfairness. Current
> printk design does look to me SMP-friendly; yes, it has unbound
> printing loop; that can be addressed.

Let us not forget, it deadlocked the machine. That's the reason this
thread exists.

> But it doesn't turn SMP system into UP.

In this example it turned it into a brick.

The problems I see are:

1. The current loglevels used in the kernel are not sufficient to
   distinguish between emergency and informational messages. Addressing
   this issue may require things like using a new printk flag and
   manually marking the printks that we(?) decide are critical. I was
   hoping we could use existing loglevels, but this appears to be such a
   mess that it is probably not practically/politically fixable
   [0]. Maybe it could be a combination of flag and loglevel, where
   certain messages have been flagged by the kernel developers as
   emergency (for example BUG output) and the user still has the
   flexibility of setting a loglevel. I need more input here.

2. You seem unwilling to acknowledge the difference between emergency
   and informational messages. A message is either critical or it is
   not. If it is, it should be handled as such, regardless of
   interference, regardless if it means turning an SMP machine into a UP
   machine. If it is not critical, it should be sent along a
   non-interfering path so the the system is _not_ affected.

The current printk implementation is handling all console printing as
best effort. Trying hard enough to dramatically affect the system, but
not trying hard enough to guarantee success.

John Ogness

[0] https://lkml.kernel.org/r/f60d844d-9d3b-3154-4eec-982432c8e502@redhat.com
