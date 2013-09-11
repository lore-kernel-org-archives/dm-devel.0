From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: dm-crypt parallelization patches
Date: Wed, 11 Sep 2013 19:03:29 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1309101947440.30003@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1309031457480.28146@file01.intranet.prod.int.rdu2.redhat.com>
	<20130903200702.GJ16724@tassilo.jf.intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20130903200702.GJ16724@tassilo.jf.intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andi Kleen <ak@linux.intel.com>
Cc: dm-devel@redhat.com, Milan Broz <gmazyland@gmail.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Tue, 3 Sep 2013, Andi Kleen wrote:

> On Tue, Sep 03, 2013 at 03:06:03PM -0400, Mikulas Patocka wrote:
> > Hi Andi
> > 
> > You wrote the original dm-crypt paralllelization patch (commit 
> > c029772125594e31eb1a5ad9e0913724ed9891f2). This patch improves 
> > parallelization, it makes data being encrypted on the same CPU that 
> > submitted the request.
> 
> The motivation for my patches was to make large systems with many
> cores scale.
> 
> I think the motivation for yours is to make small systems without
> hardware crypto offload slightly faster.
> 
> That's fine (although I suspect it's more and more obscure), as long as
> you don't impact the large systems scalability.
> 
> Can you do some tests with a larger system with very parallel IO
> (many CPUs submitting)  and see if the IO rate is equivalent?
> 
> If that's given the patches are ok for me.
> 
> -Andi

The patches mainly help with sequential I/O (sequential I/O is normally 
submitted from a few CPUs, so existing dm-crypt doesn't parallelize 
right). There is a decrease of performance when 12 threads are doing 
writes on ramdisk:

Sequential read of two SCSI disks in RAID-0 (throughput):
	raw read rate: 262MB/s stdev 2.9
	existing dm-crypt: 111MB/s stdev 19.4 (it varies greatly)
	new dm-crypt: 254MB/s stdev 1.5

Sequential read of ramdisk (throughput):
	raw read rate: 908MB/s stdev 7.7
	existing dm-crypt: 133MB/s stdev 0.8
	my new dm-crypt: 475MB/s stdev 6

fio --rw=randread --bs=4k --direct=1
Random read (4k block) on ramdisk from 12 threads (time in seconds):
	raw device: 2.32s stdev 0.02
	existing dm-crypt: 17.95s stdev 3.40
	new dm-crypt: 15.72s stdev 1.86

fio --rw=randwrite --bs=4k --direct=1
Random write (4k block) on ramdisk from 12 threads (time in seconds):
	raw device 3.91s stdev 0.01
	existing dm-crypt: 21.16s stdev 3.67
	new dm-crypt: 27.42s stdev 0.27

fio --rw=randrw --bs=4k --direct=1
Random read+write (4k block) on ramdisk from 12 threads (time in seconds):
	raw device: 3.09s stdev 0.01
	existing dm-crypt: 20.08s stdev 3.48
	new dm-crypt: 24.78s stdev 0.13

Tests were done on two six-core Istanbul-class Opterons.

I don't have a computer with AES-NI, so I can't test that.

Mikulas
