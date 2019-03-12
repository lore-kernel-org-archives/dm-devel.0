From: John Ogness <john.ogness@linutronix.de>
Subject: Re: Serial console is causing system lock-up
Date: Tue, 12 Mar 2019 14:19:56 +0100
Message-ID: <87wol444cj.fsf@linutronix.de>
References: <20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de> <20190307022254.GB4893@jagdpanzerIV>
	<87tvgfhzd6.fsf@linutronix.de> <20190307082509.GA1925@jagdpanzerIV>
	<87pnr3hyle.fsf@linutronix.de> <20190307091748.GA6307@jagdpanzerIV>
	<87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
	<87r2biojcx.fsf@linutronix.de> <20190312023231.GA4146@jagdpanzerIV>
	<87a7i05wwi.fsf@linutronix.de>
	<alpine.LRH.2.02.1903120557560.12085@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1903120557560.12085@file01.intranet.prod.int.rdu2.redhat.com>
	(Mikulas Patocka's message of "Tue, 12 Mar 2019 06:05:52 -0400 (EDT)")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On 2019-03-12, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>> But it doesn't turn SMP system into UP.
>> 
>> In this example it turned it into a brick.
>> 
>> The problems I see are:
>> 
>> 1. The current loglevels used in the kernel are not sufficient to
>>    distinguish between emergency and informational messages. Addressing
>>    this issue may require things like using a new printk flag and
>>    manually marking the printks that we(?) decide are critical. I was
>
> It depends on what the user considers important. The kernel doesn't
> know what's critical and can't know it.
>
> For example, if the user plugs an USB stick and the USB stick reports
> an I/O error, it is not critical condition.
>
> If the user runs the whole system from the USB stick and the USB stick
> reports an I/O error, it is critical condition.

I would argue that it is _not_ a critical condition. I/O errors are
something that happen. This is normal operation.

_My_ definition of critical is when something with the _kernel itself_
has gone wrong. If the kernel is in error paths that should never happen
(for example, when a WARN_ON is hit) or if a BUG/panic is hit. This is
critical information.

> The filesystems and the block device drivers can't know if the data
> stored on them are important.

Perhaps it would be nice if an administrator could additionally "mark"
what _they_ consider critical, i.e. they are aware of and accept the
consequences of a synchronous printk for certain messages. When I look
at things like dynamic_printk and ftrace, I see mechanisms that provide
excellent runtime tuning without much complexity.

We could extend dynamic_printk to include all printk messages and also
support the emergency classification. We could have something like
ftrace-events, where certain _events_ (i.e a group of printk messages)
could be classified as an emergency (for example, a WARN_ON event, a
watchdog event, a general stacktrace event, etc.).

These are just ideas that I'm bouncing around my brain. But as you said,
only the administrator can know what is important. So perhaps we need to
provide the administrator an interface to specify that.

John Ogness
