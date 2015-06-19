From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Persistent memory interface
Date: Fri, 19 Jun 2015 12:33:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, linux-nvdimm@ml01.01.org
Cc: Boaz Harrosh <boaz@plexistor.com>, Keith Busch <keith.busch@intel.com>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: dm-devel.ids

Hi

I looked at the new the persistent memory block device driver 
(drivers/block/pmem.c and arch/x86/kernel/pmem.c) and it seems that the 
interface between them is incorrect.

If I want to use persistent memory in another driver, for a different 
purpose, how can I make sure that that drivers/block/pmem.c doesn't attach 
to this piece of memory and export it? It seems not possible. 
drivers/block/pmem.c attaches to everything without regard that there may 
be other users of persistent memory.

I think a correct solution would be to add a partition table at the 
beginning of persistent memory area and this partition table would 
describe which parts belong to which programs - so that different programs 
could use persistent memory and not step over each other's data. Is there 
some effort to standardize the partition table ongoing?


BTW. some journaling filesystems assume that 512-byte sector is written 
atomically. drivers/block/pmem.c breaks this requirement. Persistent 
memory only gurantees 8-byte atomic writes.

Mikulas
