From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 0/5] device mapper percpu patches
Date: Thu, 15 Nov 2018 19:00:56 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1811151815520.25860@file01.intranet.prod.int.rdu2.redhat.com>
References: <20181106213458.308968760@debian-a64.vm>
	<20181107222904.GB24491@redhat.com>
	<alpine.LRH.2.02.1811071741470.20405@file01.intranet.prod.int.rdu2.redhat.com>
	<edc963dd-378a-0342-83f6-b364aecb40cd@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <edc963dd-378a-0342-83f6-b364aecb40cd@kernel.dk>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



On Wed, 7 Nov 2018, Jens Axboe wrote:

> On 11/7/18 3:47 PM, Mikulas Patocka wrote:
> > 
> > I'd like to know - which kernel part needs to sum the percpu IO counters 
> > frequently?
> > 
> > My impression was that the counters need to be summed only when the user 
> > is reading the files in sysfs and that is not frequent at all.
> 
> part_round_stats() does it on IO completion - only every jiffy, but it's
> enough that previous attempts at percpu inflight counters only worked
> for some cases, and were worse for others.

I see.

I thought about it - part_round_stats() is used to calculate two counters 
- time_in_queue and io_ticks.

time_in_queue can be calculating by adding the duration of the I/O when 
the I/O ends (the value will be the same except for in-progress I/Os).

io_ticks could be approximated - if an I/O is started or finished and the 
"jiffies" value changes, we add 1. This is approximation, but if the I/Os 
take less than a jiffy, the value will be the same.


These are the benchmarks for the patches for IOPS on ramdisk (request 
size 512 bytes) and ramdisk with dm-linear attached:

fio --ioengine=psync --iodepth=1 --rw=read --bs=512 --direct=1 --numjobs=12 --time_based --runtime=10 --group_reporting --name=/dev/ram0

a system with 2 6-core processors:
/dev/ram0					6656445 IOPS
/dev/mapper/linear				2061914 IOPS
/dev/mapper/linear with percpu counters		5500976 IOPS

a system with 1 6-core processor:
/dev/ram0					4019921 IOPS
/dev/mapper/linear				2104687 IOPS
/dev/mapper/linear with percpu counters		3050195 IOPS

a virtual machine (12 virtual cores and 12 physical cores):
/dev/ram0					5304687 IOPS
/dev/mapper/linear				2115234 IOPS
/dev/mapper/linear with percpu counters		4457031 IOPS


My point of view is that we shouldn't degrade I/O throughput just to keep 
the counters accurate, so I suggest to change the counters to 
less-accurate mode. I'll send patches for that.

Device mapper has a separate dm-stats functionality that can provide 
accurate I/O counters for the whole device and for any range - it is off 
by default, so it doesn't degrade performance if the user doesn't need it.

Mikulas
