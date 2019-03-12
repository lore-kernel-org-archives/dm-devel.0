From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Serial console is causing system lock-up
Date: Tue, 12 Mar 2019 06:05:52 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1903120557560.12085@file01.intranet.prod.int.rdu2.redhat.com>
References: <20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de> <20190307022254.GB4893@jagdpanzerIV>
	<87tvgfhzd6.fsf@linutronix.de> <20190307082509.GA1925@jagdpanzerIV>
	<87pnr3hyle.fsf@linutronix.de> <20190307091748.GA6307@jagdpanzerIV>
	<87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
	<87r2biojcx.fsf@linutronix.de> <20190312023231.GA4146@jagdpanzerIV>
	<87a7i05wwi.fsf@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, linux-serial@vger.kernel.org
List-Id: dm-devel.ids



On Tue, 12 Mar 2019, John Ogness wrote:

> > But it doesn't turn SMP system into UP.
> 
> In this example it turned it into a brick.
> 
> The problems I see are:
> 
> 1. The current loglevels used in the kernel are not sufficient to
>    distinguish between emergency and informational messages. Addressing
>    this issue may require things like using a new printk flag and
>    manually marking the printks that we(?) decide are critical. I was

It depends on what the user considers important. The kernel doesn't know 
what's critical and can't know it.

For example, if the user plugs an USB stick and the USB stick reports an 
I/O error, it is not critical condition.

If the user runs the whole system from the USB stick and the USB stick 
reports an I/O error, it is critical condition.

The filesystems and the block device drivers can't know if the data stored 
on them are important.

Mikulas
