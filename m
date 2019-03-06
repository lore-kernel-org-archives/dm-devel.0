From: John Ogness <john.ogness@linutronix.de>
Subject: Re: Serial console is causing system lock-up
Date: Wed, 06 Mar 2019 23:43:45 +0100
Message-ID: <87ftrzbp3y.fsf@linutronix.de>
References: <alpine.LRH.2.02.1903060917280.5335@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306152218.eocv4zulf7tv2mkc@pathway.suse.cz>
	<alpine.LRH.2.02.1903061031420.16905@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306171943.12345598@oasis.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190306171943.12345598@oasis.local.home> (Steven Rostedt's
	message of "Wed, 6 Mar 2019 17:19:43 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On 2019-03-06, Steven Rostedt <rostedt@goodmis.org> wrote:
>> This bug only happens if we select large logbuffer (millions of
>> characters). With smaller log buffer, there are messages "** X printk
>> messages dropped", but there's no lockup.
>> 
>> The kernel apparently puts 2 million characters into a console log
>> buffer, then takes some lock and than tries to write all of them to a
>> slow serial line.
>>
>> [...]
>>
>> The MD-RAID is supposed to recalculate data for the corrupted device
>> and bring it back to life. However, scrubbing the MD-RAID device
>> resulted in a lot of reads from the device with bad checksums, these
>> were reported to the log and killed the machine.
>> 
>> I made a patch to dm-integrity to rate-limit the error messages. But
>> anyway - killing the machine in case of too many log messages seems
>> bad.  If the log messages are produced faster than the kernel can
>> write them, the kernel should discard some of them, not kill itself.
>
> Sounds like another aurgment for the new printk design.

Assuming the bad checksum messages are considered an emergency (for
example, at least loglevel KERN_WARN), then the new printk design would
print those messages synchronously to the slow serial line in the
context of the driver as the driver is producing them.

There wouldn't be a lock-up, but it would definitely slow down the
driver. The situation of "messages being produced faster than the kernel
can write them" would never exist because the printk() call will only
return after the writing is completed. I am curious if that would be
acceptable here?

John Ogness
