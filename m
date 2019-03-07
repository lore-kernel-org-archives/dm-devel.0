From: "John Stoffel" <john@stoffel.org>
Subject: Re: Serial console is causing system lock-up
Date: Thu, 7 Mar 2019 09:08:39 -0500
Message-ID: <23681.9703.524330.948156@quad.stoffel.home>
References: <alpine.LRH.2.02.1903060917280.5335@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306152218.eocv4zulf7tv2mkc@pathway.suse.cz>
	<alpine.LRH.2.02.1903061031420.16905@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306171943.12345598@oasis.local.home>
	<87ftrzbp3y.fsf@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <87ftrzbp3y.fsf@linutronix.de>
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
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

>>>>> "John" == John Ogness <john.ogness@linutronix.de> writes:

John> On 2019-03-06, Steven Rostedt <rostedt@goodmis.org> wrote:
>>> This bug only happens if we select large logbuffer (millions of
>>> characters). With smaller log buffer, there are messages "** X printk
>>> messages dropped", but there's no lockup.
>>> 
>>> The kernel apparently puts 2 million characters into a console log
>>> buffer, then takes some lock and than tries to write all of them to a
>>> slow serial line.
>>> 
>>> [...]
>>> 
>>> The MD-RAID is supposed to recalculate data for the corrupted device
>>> and bring it back to life. However, scrubbing the MD-RAID device
>>> resulted in a lot of reads from the device with bad checksums, these
>>> were reported to the log and killed the machine.
>>> 
>>> I made a patch to dm-integrity to rate-limit the error messages. But
>>> anyway - killing the machine in case of too many log messages seems
>>> bad.  If the log messages are produced faster than the kernel can
>>> write them, the kernel should discard some of them, not kill itself.
>> 
>> Sounds like another aurgment for the new printk design.

John> Assuming the bad checksum messages are considered an emergency
John> (for example, at least loglevel KERN_WARN), then the new printk
John> design would print those messages synchronously to the slow
John> serial line in the context of the driver as the driver is
John> producing them.

John> There wouldn't be a lock-up, but it would definitely slow down
John> the driver. The situation of "messages being produced faster
John> than the kernel can write them" would never exist because the
John> printk() call will only return after the writing is completed. I
John> am curious if that would be acceptable here?

The real problem is the disconnect between serial console speed and
capacity in bits/sec and that of the regular console.  Serial, esp at
9600 baud is just a slow and limited resource which needs to be
handled differently than a graphical console.

I'm also big on ratelimiting messages, even critical warning
messages.  Too much redundant info doesn't help anyone.  And what a
subsystem thinks is critical, may not be critical to the system as a
whole.

In this case, if these checksum messages are telling us that there's
corruption, why isn't dm-integrity going readonly and making the block
device get the filesystem to also go readonly and to stop the damage
right away?

If it's just a warning for the niceness, then please rate limit them,
or summarize them in some more useful way.  Or even log them to
somewhere else than the console once the problem is noted.

John
