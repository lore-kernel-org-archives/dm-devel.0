From: Petr Mladek <pmladek@suse.com>
Subject: Re: Serial console is causing system lock-up
Date: Tue, 12 Mar 2019 13:08:24 +0100
Message-ID: <20190312120824.4eaa4eyjcxvuzm23@pathway.suse.cz>
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
Cc: Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On Tue 2019-03-12 09:17:49, John Ogness wrote:
> On 2019-03-12, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com> wrote:
> The problems I see are:
> 
> 1. The current loglevels used in the kernel are not sufficient to
>    distinguish between emergency and informational messages. Addressing
>    this issue may require things like using a new printk flag and
>    manually marking the printks that we(?) decide are critical. I was
>    hoping we could use existing loglevels, but this appears to be such a
>    mess that it is probably not practically/politically fixable
>    [0]. Maybe it could be a combination of flag and loglevel, where
>    certain messages have been flagged by the kernel developers as
>    emergency (for example BUG output) and the user still has the
>    flexibility of setting a loglevel. I need more input here.

No, please! No extra flag could safe us if people are not able
to set loglevel correctly. Also the importance depends on the
situation. Any message is as important as it helps to resolve
the problem.


> 2. You seem unwilling to acknowledge the difference between emergency
>    and informational messages. A message is either critical or it is
>    not. If it is, it should be handled as such, regardless of
>    interference, regardless if it means turning an SMP machine into a UP
>    machine. If it is not critical, it should be sent along a
>    non-interfering path so the the system is _not_ affected.

This means that any critical message is always more important than any
workload. It opens doors for iteresting DOS attacks.


> The current printk implementation is handling all console printing as
> best effort. Trying hard enough to dramatically affect the system, but
> not trying hard enough to guarantee success.

I agree that direct output is more reliable. It might be very useful
for debugging some types of problems. The question is
if it is worth the cost (code complexity, serializing CPUs
== slowing down the entire system).

But it is is possible that a reasonable offloading (in the direction
of last Sergey's approach) might be a better deal.


I suggest the following way forward (separate patchsets):

    1. Replace log buffer (least controversial thing)
    2. Reliable offload to kthread (would be useful anyway)
    3. Atomic consoles (a lot of tricky code, might not be
		worth the effort)

Could we agree on this?

Best Regards,
Petr
