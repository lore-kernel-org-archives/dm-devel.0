From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: Persistent memory interface
Date: Fri, 19 Jun 2015 16:50:20 +0000
Message-ID: <1434732620.32433.37.camel@intel.com>
References: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-US
Content-ID: <9258C06FA79C6948A472FD6C01A1EEA0@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "mpatocka@redhat.com" <mpatocka@redhat.com>
Cc: "Busch, Keith" <keith.busch@intel.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "luto@amacapital.net" <luto@amacapital.net>, "axboe@fb.com" <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "hch@lst.de" <hch@lst.de>
List-Id: dm-devel.ids

On Fri, 2015-06-19 at 12:33 -0400, Mikulas Patocka wrote:
> Hi
> 
> I looked at the new the persistent memory block device driver 
> (drivers/block/pmem.c and arch/x86/kernel/pmem.c) and it seems that the 
> interface between them is incorrect.
> 
> If I want to use persistent memory in another driver, for a different 
> purpose, how can I make sure that that drivers/block/pmem.c doesn't attach 
> to this piece of memory and export it? It seems not possible. 
> drivers/block/pmem.c attaches to everything without regard that there may 
> be other users of persistent memory.
> 
> I think a correct solution would be to add a partition table at the 
> beginning of persistent memory area and this partition table would 
> describe which parts belong to which programs - so that different programs 
> could use persistent memory and not step over each other's data. Is there 
> some effort to standardize the partition table ongoing?
> 
> 
> BTW. some journaling filesystems assume that 512-byte sector is written 
> atomically. drivers/block/pmem.c breaks this requirement. Persistent 
> memory only gurantees 8-byte atomic writes.

Hi Mikulas,

I can answer this part - The idea is that file systems that need sector
atomicity will use the "Block Translation Table" (BTT) [1]. It would be
a stacked block device on top of a pmem device (or partition), and file
systems would be able to use it either for the entire space to get
atomicity for all blocks, or if they want to use DAX, make two
partitions, and enable the BTT only on one partition, and use it as the
logdev.

	-Vishal

[1]: https://lkml.org/lkml/2015/6/17/950

> 
> Mikulas
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
