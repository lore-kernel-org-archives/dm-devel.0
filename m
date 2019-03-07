From: Petr Mladek <pmladek@suse.com>
Subject: Re: Serial console is causing system lock-up
Date: Thu, 7 Mar 2019 16:16:57 +0100
Message-ID: <20190307151657.op7ekkzyup23inr5@pathway.suse.cz>
References: <alpine.LRH.2.02.1903060917280.5335@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306152218.eocv4zulf7tv2mkc@pathway.suse.cz>
	<alpine.LRH.2.02.1903061031420.16905@file01.intranet.prod.int.rdu2.redhat.com>
	<20190306163003.GA31858@mit.edu>
	<alpine.LRH.2.02.1903061157530.3129@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Nigel Croxon <ncroxon@redhat.com>, "Theodore Y. Ts'o" <tytso@mit.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, dm-devel@redhat.com, linux-serial@vger.kernel.org
List-Id: dm-devel.ids

On Wed 2019-03-06 12:11:10, Mikulas Patocka wrote:
> =

> =

> On Wed, 6 Mar 2019, Theodore Y. Ts'o wrote:
> =

> > On Wed, Mar 06, 2019 at 11:07:55AM -0500, Mikulas Patocka wrote:
> > > This bug only happens if we select large logbuffer (millions of =

> > > characters). With smaller log buffer, there are messages "** X printk =

> > > messages dropped", but there's no lockup.
> > > =

> > > The kernel apparently puts 2 million characters into a console log bu=
ffer, =

> > > then takes some lock and than tries to write all of them to a slow se=
rial =

> > > line.
> > =

> > What are the messages; from what kernel subsystem?  Why are you seeing
> > so many log messages?
> > =

> > 					- Ted
> =

> The dm-integity subsystem (drivers/md/dm-integrity.c) can be attached to =
a =

> block device to provide checksum protection. It will return -EILSEQ and =

> print a message to a log for every corrupted block.
> =

> Nigel Croxon was testing MD-RAID recovery capabilities in such a way that =

> he activated RAID-5 array with one leg replaced by a dm-integrity block =

> device that had all checksums invalid.
> =

> The MD-RAID is supposed to recalculate data for the corrupted device and =

> bring it back to life. However, scrubbing the MD-RAID device resulted in =
a =

> lot of reads from the device with bad checksums, these were reported to =

> the log and killed the machine.
> =

> =

> I made a patch to dm-integrity to rate-limit the error messages. But =

> anyway - killing the machine in case of too many log messages seems
> bad. If the log messages are produced faster than the kernel can write th=
em, =

> the kernel should discard some of them, not kill itself.

printk() could not easily detect where the messages come from and
if it is acceptable to drop them.

In general, an "unlimited" output of messages that are not much useful
looks like a bug on the caller side. Some rate-limiting in
dm-integrity code looks appropriate here.

Even better might be to stop printing the messages after X occurrences
until the check is completed. It might do something like:

int errors_count =3D 0;

while(find_error()) {
	errors_count++;
	if (errors_count <=3D 10)
		pr_err("...");
	else if (errors_count =3D=3D 11)
		pr_error(=A8Too many errors. Continuing check silently\n");
}

if (errors_count)
	pr_error("Check finished. %d errors detected\n", errors_count);


Note that rate-limit is a bit ugly. It does not have feedback from
printk/consoles how long it takes to get the messages out. It might
not be enough if the console is very slow and if there are other
printk() users at the same time.


That said. I agree that printk() should not kill the system. It should
survive these "mistakes". On the other hand, printk() users must
cooperate. The log buffer and console bandwith is a limited resource.


Best Regards,
Petr
