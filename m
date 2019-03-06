From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: Serial console is causing system lock-up
Date: Wed, 6 Mar 2019 17:19:43 -0500
Message-ID: <20190306171943.12345598@oasis.local.home>
References: <alpine.LRH.2.02.1903060917280.5335@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306152218.eocv4zulf7tv2mkc@pathway.suse.cz>
	<alpine.LRH.2.02.1903061031420.16905@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Petr Mladek <pmladek@suse.com>, Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, John Ogness <john.ogness@linutronix.de>, Kroah-Hartman <gregkh@linuxfoundation.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, Greg, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On Wed, 6 Mar 2019 12:11:10 -0500 (EST)
Mikulas Patocka <mpatocka@redhat.com> wrote:

> On Wed, 6 Mar 2019, Theodore Y. Ts'o wrote:
> 
> > On Wed, Mar 06, 2019 at 11:07:55AM -0500, Mikulas Patocka wrote:  
> > > This bug only happens if we select large logbuffer (millions of 
> > > characters). With smaller log buffer, there are messages "** X printk 
> > > messages dropped", but there's no lockup.
> > > 
> > > The kernel apparently puts 2 million characters into a console log buffer, 
> > > then takes some lock and than tries to write all of them to a slow serial 
> > > line.  
> > 
> > What are the messages; from what kernel subsystem?  Why are you seeing
> > so many log messages?
> > 
> > 					- Ted  
> 
> The dm-integity subsystem (drivers/md/dm-integrity.c) can be attached to a 
> block device to provide checksum protection. It will return -EILSEQ and 
> print a message to a log for every corrupted block.
> 
> Nigel Croxon was testing MD-RAID recovery capabilities in such a way that 
> he activated RAID-5 array with one leg replaced by a dm-integrity block 
> device that had all checksums invalid.
> 
> The MD-RAID is supposed to recalculate data for the corrupted device and 
> bring it back to life. However, scrubbing the MD-RAID device resulted in a 
> lot of reads from the device with bad checksums, these were reported to 
> the log and killed the machine.
> 
> 
> I made a patch to dm-integrity to rate-limit the error messages. But 
> anyway - killing the machine in case of too many log messages seems bad. 
> If the log messages are produced faster than the kernel can write them, 
> the kernel should discard some of them, not kill itself.

Sounds like another aurgment for the new printk design.

-- Steve
