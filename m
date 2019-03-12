From: Petr Mladek <pmladek@suse.com>
Subject: Re: Serial console is causing system lock-up
Date: Tue, 12 Mar 2019 14:44:18 +0100
Message-ID: <20190312134418.vznoqsdidkfs2zbl@pathway.suse.cz>
References: <20190307082509.GA1925@jagdpanzerIV> <87pnr3hyle.fsf@linutronix.de>
	<20190307091748.GA6307@jagdpanzerIV> <87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
	<87r2biojcx.fsf@linutronix.de> <20190312023231.GA4146@jagdpanzerIV>
	<87a7i05wwi.fsf@linutronix.de>
	<alpine.LRH.2.02.1903120557560.12085@file01.intranet.prod.int.rdu2.redhat.com>
	<87wol444cj.fsf@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <87wol444cj.fsf@linutronix.de>
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

On Tue 2019-03-12 14:19:56, John Ogness wrote:
> On 2019-03-12, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >>> But it doesn't turn SMP system into UP.
> >> 
> >> In this example it turned it into a brick.
> >> 
> >> The problems I see are:
> >> 
> >> 1. The current loglevels used in the kernel are not sufficient to
> >>    distinguish between emergency and informational messages. Addressing
> >>    this issue may require things like using a new printk flag and
> >>    manually marking the printks that we(?) decide are critical. I was
> 
> Perhaps it would be nice if an administrator could additionally "mark"
> what _they_ consider critical, i.e. they are aware of and accept the
> consequences of a synchronous printk for certain messages. When I look
> at things like dynamic_printk and ftrace, I see mechanisms that provide
> excellent runtime tuning without much complexity.
> 
> We could extend dynamic_printk to include all printk messages and also
> support the emergency classification. We could have something like
> ftrace-events, where certain _events_ (i.e a group of printk messages)
> could be classified as an emergency (for example, a WARN_ON event, a
> watchdog event, a general stacktrace event, etc.).
> 
> These are just ideas that I'm bouncing around my brain. But as you said,
> only the administrator can know what is important. So perhaps we need to
> provide the administrator an interface to specify that.

Interesting idea. But I am very sceptical about it. I can't imagine
that anyone would like to configure 100k messages or so.

It is even worse than kernel configuration. And the trend is
to avoid config options where possible. It is because it is
almost impossible to understand all existing options and
make qualified decisions. And it is hard to expect that
users would be able to make a better decision than a developer
who implemented the code behind the option.

Our discussion is a nice example. Even we have troubles to
understand all consequences of different approaches. Even
if we reach a conclusion and document it. Then nobody
would want to read several pages long tutorial how to
configure printk ;-)

Best Regards,
Petr
