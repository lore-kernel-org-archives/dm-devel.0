From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-thin: optimize power of two block size
Date: Sun, 24 Jun 2012 21:53:22 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1206242119150.21557@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206181003170.22564@file.rdu.redhat.com>
	<20120618163536.GA3640@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120618163536.GA3640@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Mon, 18 Jun 2012, Joe Thornber wrote:

> On Mon, Jun 18, 2012 at 10:09:56AM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > This patch should be applied after 
> > dm-thin-support-for-non-power-of-2-pool-blocksize.patch. It optimizes 
> > power-of-two blocksize.
> 
> I'm going to nack this unless you can provide a benchmark that shows
> it measurably improves performance for some architecture somewhere.
> And a real benchmark, with io going through all the devices, not just
> a micro benchmark of the 'if' in a tight loop.
> 
> - Joe

Hi

Here are some tests ran on the collection of my computers.

This is a do_div benchmark, the source is here:
http://people.redhat.com/~mpatocka/testcases/do_div_benchmark.c
For the "bignum" test, I replaced 0x12345678 with 0xff12345678LL (so that 
do_div divides real 64-bit numbers).

It is especially slow on PA-RISC and Alpha because they don't have a 
divide instruction.

PA-RISC 900MHz 64-bit:
shift+mask:		4 ticks		(4.4ns)
shift+mask bignum:	4 ticks		(4.4ns)
do_div:			825 ticks	(917ns)
do_div bignum:		825 ticks	(917ns)

UltraSparc2 440MHz 64-bit:
shift+mask:		3 ticks		(6.8ns)
shift+mask bignum:	3 ticks		(6.8ns)
do_div:			87 ticks	(198ns)
do_div bignum:		93 ticks	(211ns)

Alpha ev45 233MHz 64-bit:
shift+mask:		7 ticks		(30ns)
shift+mask bignum:	8 ticks		(34ns)
do_div:			598 ticks	(2563ns)
do_div bignum:		897 ticks	(3844ns)

Pentium 3 850MHz:
shift+mask:		12.25 ticks	(14ns)
shift+mask bignum:	16 ticks	(19ns)
do_div:			63.5 ticks	(75ns)
do_div bignum:		94 ticks	(111ns)

Core2 Xeon 1600MHz 64-bit:
shift+mask:		3.2 ticks	(2ns)
shift+mask bignum:	3.4 ticks	(2.1ns)
do_div:			64 ticks	(40ns)
do_div bignum:		64 ticks	(40ns)

K10 Opteron 2300MHz 64-bit:
shift+mask:		3 ticks		(1.3ns)
shift+mask bignum:	3 ticks		(1.3ns)
do_div:			46 ticks	(20ns)
do_div bignum:		57 ticks	(28ns)

---

On that PA-RISC machine, I set up dm-stripe target consisting of two 
stripes on a ramdisk, with 4k stripe size. I performed
dd if=/dev/mapper/stripe of=/dev/null bs=512 count=100000 iflag=direct
With the optimization patches: 38.2-38.5 MB/s
Without the optimization patches: 35.3-35.6 MB/s

With larger io size:
dd if=/dev/mapper/stripe of=/dev/null bs=1M count=200 iflag=direct
With the optimization patches: 269-272 MB/s
Without the optimization patches: 250-253 MB/s


Tests with dm-thin on PA-RISC:
A device with 512MB pool and 512MB metadata on ramdisks, 64k chunk.

Overwrite the first time with
dd if=/dev/zero of=/dev/mapper/thin bs=1M oflag=direct
Without the optimization patches: 91.0-91.4
With the optimization patches: 90.6-91.6

Subsequent overwrite with
dd if=/dev/zero of=/dev/mapper/thin bs=1M oflag=direct
Without the optimization patches: 104 MB/s
With the optimization patches: 104 MB/s

Read the overwritten device with
dd if=/dev/mapper/thin of=/dev/null bs=1M iflag=direct
Without the optimization patches: 252-254 MB/s
With the optimization patches: 257-258 MB/s

So the conclusion is that is that that divide instruction degrades 
transfer speed, especially on dm-stripe with 4k stripe size (on dm-thin it 
is measurable only with raw read, the difference is smaller because it has 
a minimum chunk size 64k).


The question is why do you want to avoid such optimization? If it is 
because of source code clarity, we can create #define sector_div_optimized 
that optimizes the common case of power-of-two divisor and the code would 
be no more complicated than with sector div. Or do you have some other 
reasons?


BTW. when unloading the dm-thin device with debugging enabled (the tests 
were done with debugging disabled), I got this message:
device-mapper: space map checker: free block counts differ, checker 
131060, sm-disk:130991
--- so there is supposedly some bug? The kernel is 3.4.3.

Mikulas
