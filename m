From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: Persistent memory interface
Date: Fri, 19 Jun 2015 12:48:25 -0400
Message-ID: <20150619164825.GB1971@linux.intel.com>
References: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
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
Cc: Boaz Harrosh <boaz@plexistor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@ml01.01.org, Keith Busch <keith.busch@intel.com>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, dm-devel@redhat.com, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Fri, Jun 19, 2015 at 12:33:09PM -0400, Mikulas Patocka wrote:
> If I want to use persistent memory in another driver, for a different 
> purpose, how can I make sure that that drivers/block/pmem.c doesn't attach 
> to this piece of memory and export it? It seems not possible. 
> drivers/block/pmem.c attaches to everything without regard that there may 
> be other users of persistent memory.

You need to look at the patches that Dan has been posting to add support
for Labels (and NFIT and ...).  Those weren't available earlier because
the label spec wasn't public.

> BTW. some journaling filesystems assume that 512-byte sector is written 
> atomically. drivers/block/pmem.c breaks this requirement. Persistent 
> memory only gurantees 8-byte atomic writes.

... and that's addressed by the BTT patches.
