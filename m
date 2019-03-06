From: Petr Mladek <pmladek@suse.com>
Subject: Re: Serial console is causing system lock-up
Date: Wed, 6 Mar 2019 16:22:18 +0100
Message-ID: <20190306152218.eocv4zulf7tv2mkc@pathway.suse.cz>
References: <alpine.LRH.2.02.1903060917280.5335@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1903060917280.5335@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Nigel Croxon <ncroxon@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On Wed 2019-03-06 09:27:13, Mikulas Patocka wrote:
> Hi
> 
> I was debugging some kernel lockup with storage drivers and it turned out 
> that the lockup is caused by the serial console subsystem. If we use 
> serial console and if we write to it excessively, the kernel sometimes 
> lockup, sometimes reports rcu stalls and NMI backtraces. Sometimes it will 
> just print the console messages without donig anything else.

This is a very old problem that we have been trying to solve for
years. There are two conflicting requirements on printk():
be fast and reliable.

The historical solution is that printk() callers store the messages
into the log buffer and then just _try_ to take the console lock.
The winner who succeeds is responsible for flushing all
pending messages to the console. As a result a random victim
might get blocked by the console handling for a long time.

An obvious solution is offloading the console handling. But
it is against the reliability. There are no guarantees that
the offload mechanism (kthread, irq) would happen when the
system is on their knees.

Anyway, which kernel version are you using, please?

I wonder if you already have the dbdda842fe96f8932 ("printk: Add
console owner and waiter logic to load balance console writes").
It improves the situation a lot. There was a hope that it would
be enough in the real life.


> This program tests the issue - on framebuffer console, the system is 
> sluggish, but it is possible to unload the module with rmmod. On serial 
> console, it locks up to the point that unloading the module is not 
> possible.

Is there any chance to send us logs from the original (real life)
problem, please?

Best regards,
Petr
