From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: Serial console is causing system lock-up
Date: Wed, 13 Mar 2019 11:38:36 +0900
Message-ID: <20190313023836.GC783@jagdpanzerIV>
References: <87tvgfhzd6.fsf@linutronix.de> <20190307082509.GA1925@jagdpanzerIV>
	<87pnr3hyle.fsf@linutronix.de> <20190307091748.GA6307@jagdpanzerIV>
	<87o96nezr2.fsf@linutronix.de>
	<20190307122642.GA10415@tigerII.localdomain>
	<87r2biojcx.fsf@linutronix.de> <20190312023231.GA4146@jagdpanzerIV>
	<87a7i05wwi.fsf@linutronix.de>
	<20190312120824.4eaa4eyjcxvuzm23@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20190312120824.4eaa4eyjcxvuzm23@pathway.suse.cz>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Petr Mladek <pmladek@suse.com>
Cc: Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, John Ogness <john.ogness@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On (03/12/19 13:08), Petr Mladek wrote:
> > 2. You seem unwilling to acknowledge the difference between emergency
> >    and informational messages. A message is either critical or it is
> >    not. If it is, it should be handled as such, regardless of
> >    interference, regardless if it means turning an SMP machine into a UP
> >    machine. If it is not critical, it should be sent along a
> >    non-interfering path so the the system is _not_ affected.
> 
> This means that any critical message is always more important than any
> workload. It opens doors for iteresting DOS attacks.

Agreed.

So what I thought about "mutual exclusive error reporting with
quadratic latencies" was that if any workload involves error
reporting then it might be a good idea to _not_ parallelize such
workload anymore.

> > The current printk implementation is handling all console printing as
> > best effort. Trying hard enough to dramatically affect the system, but
> > not trying hard enough to guarantee success.
>
> I agree that direct output is more reliable. It might be very useful
> for debugging some types of problems. The question is
> if it is worth the cost (code complexity, serializing CPUs
> == slowing down the entire system).

Agreed.

I'm very skeptical about "serializing CPUs" part. It looks like one
"print or die trying" is replaced with another "print or die trying".
What happened to  log_store() + flush_on_panic()?

	-ss
