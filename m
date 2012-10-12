From: Michael Zugelder <michael-o6OQtA6gQXJg9hUCZPvPmw@public.gmane.org>
Subject: Re: PROBLEM:  read starvation during writeback
Date: Sat, 13 Oct 2012 01:06:47 +0200
Message-ID: <1350083207.2673.5.camel@vpcz1>
References: <1350070656.2554.6.camel@vpcz1> <50787ECB.1050803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
In-Reply-To: <50787ECB.1050803-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <http://www.saout.de/mailman/options/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.saout.de/pipermail/dm-crypt/>
List-Post: <mailto:dm-crypt-4q3lyFh4P1g@public.gmane.org>
List-Help: <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=help>
List-Subscribe: <http://www.saout.de/mailman/listinfo/dm-crypt>,
 <mailto:dm-crypt-request-4q3lyFh4P1g@public.gmane.org?subject=subscribe>
Errors-To: dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org
Sender: "dm-crypt" <dm-crypt-bounces-4q3lyFh4P1g@public.gmane.org>
To: Milan Broz <gmazyland-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: dm-crypt <dm-crypt-4q3lyFh4P1g@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: dm-devel.ids

Hi,

On Fri, 2012-10-12 at 22:34 +0200, Milan Broz wrote:
> On 10/12/2012 09:37 PM, Michael Zugelder wrote: 
> > Testing setup:
> >  * Fedora 17, stock 3.5.4-2.fc17 kernel and a self-compiled 3.6.1 kernel
> >  * 320 GiB USB hard drive (sdb)
> 
> I guess that USB is the key factor here... I remember to have similar
> problem some time ago even without dmcrypt.
> 
> Is it reproducible with the same kernel cfg but with internal disk?

I noticed this problem on my encrypted root partition and used the
USB device to reproduce it. It's just much easier to get writeback on a
simple 20 MiB/s device and being able to actually use the root device
while performing tests.

My root device (SATA2, Samsung SSD 830, aes-xts-plain, btrfs):
  3463 seeks/second, 0.29 ms random access time

During writeback:
  0 seeks/second, 4285.71 ms random access time

> You can also test completely fake underlying device,
> use device-mapper- zero target:
> dmsetup create dev_zero --table "0 <sectors size> zero"
> (All writes are dropped and all reads returns zero in this case.)
> 
> Is there any starvation with this setup? (It shouldn't.)

Using the zero target alone, no issues (192286 seeks/second).

> Btw you can use cryptsetup with cipher "null" to simplify
> (I added to cryptsetup to test exactly such scenarios).

Neat, but doesn't work with the device mapper null target. Using raw
dmsetup with crypto_null results in a nice test case:

Preparation:
  # dmsetup create dev_zero --table "0 $((1024*1024*1024)) zero"
  # dmsetup create nullcrypt --table "0 $((1024*1024*1024)) crypt cipher_null - 0 /dev/mapper/dev_zero 0"

Now some writes:
  # dd if=/dev/zero of=/dev/mapper/nullcrypt bs=1M

Then try to read something:
  # seeker /dev/mapper/nullcrypt
  8260 seeks/second, 0.12 ms random access time

  # dd if=/dev/mapper/nullcrypt of=/dev/null count=1 skip=355154
  512 bytes (512 B) copied, 18.0695 s, 0.0 kB/s

For some time period, reads are fine (see the relatively low average
random access time), but sometimes reads take multiple seconds. A
benchmark showing min/max/avg/med/stdev values for random reads would be
nice.

> > * writeback induced by running 'dd if=/dev/zero of=$target bs=1M'
> 
> Any change if you use oflag=direct ? (iow using direct io)

No issues while using direct IO (25054 seeks/second, no obvious spikes)
using the null target, cipher_null test from above.

> > I experimented a bit with the other device mapper targets, namely linear
> > and stripe, but both worked completely fine. I also tried putting a
> > linear mapping above dm-crypt, with no impact on performance. Comparing
> > the content of the /sys/block/$DEV files of the linear mapping and
> > dm-crypt, there are no differences beside the name, dev no, stats,
> > uevent and inflight files.
> 
> There is crucial difference between linear/stripe and dmcrypt:
> linear just remaps IO target device, dmcrypt queues operations
> (using kernel workqueue) and creates full bio clones.
> So comparison here is IMHO not much helpful.

Okay, I just wanted to rule out a general device mapper problem.

> There are two internal dmcrypt queues, but I think that the problem
> is triggered by some combination with USB storage backend.

Results above seem to indicate otherwise.

> > Any pointers would be appreciated, I haven't found much on the web about
> > this issue.
> 
> Btw there was a proposed rewrite of internal dmcrypt queues, if you have time,
> you can try if it changes anything for your use case.
> Patches in dm-devel archive
> http://www.redhat.com/archives/dm-devel/2012-August/msg00210.html

Seems interesting, I'll try it out tomorrow.


Thanks,
Michael

_______________________________________________
dm-crypt mailing list
dm-crypt-4q3lyFh4P1g@public.gmane.org
http://www.saout.de/mailman/listinfo/dm-crypt
