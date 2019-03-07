From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Serial console is causing system lock-up
Date: Thu, 7 Mar 2019 09:26:46 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1903070918110.6122@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1903060917280.5335@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306152218.eocv4zulf7tv2mkc@pathway.suse.cz>
	<alpine.LRH.2.02.1903061031420.16905@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de>
	<23681.9703.524330.948156@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <23681.9703.524330.948156@quad.stoffel.home>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Stoffel <john@stoffel.org>
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, John Ogness <john.ogness@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, linux-serial@vger.kernel.org
List-Id: dm-devel.ids



On Thu, 7 Mar 2019, John Stoffel wrote:

> The real problem is the disconnect between serial console speed and
> capacity in bits/sec and that of the regular console.  Serial, esp at
> 9600 baud is just a slow and limited resource which needs to be
> handled differently than a graphical console.
>
> I'm also big on ratelimiting messages, even critical warning
> messages.  Too much redundant info doesn't help anyone.  And what a
> subsystem thinks is critical, may not be critical to the system as a
> whole.

Perhaps a proper solution would be to drop excessive messages to serial 
console unless Oops or BUG has happened?

> In this case, if these checksum messages are telling us that there's
> corruption, why isn't dm-integrity going readonly and making the block
> device get the filesystem to also go readonly and to stop the damage
> right away?

Because we don't want to kill the filesystem. dm-integrity detects an 
error and returns the error code to md-raid5. md-raid5 recalculates the 
correct data from the remaining disks. And then, md-raid5 submits the 
correct data to the filesystem and also writes the correct data to the 
device that had the error.

In a real-life scenario, there would be few errors. When we are testing 
it, we deliberately create a device with all errorneous sectors.

> If it's just a warning for the niceness, then please rate limit them,
> or summarize them in some more useful way.  Or even log them to
> somewhere else than the console once the problem is noted.
> 
> John

I made a patch that rate-limits the message. But still, killing the 
machine is wrong.

Mikulas
