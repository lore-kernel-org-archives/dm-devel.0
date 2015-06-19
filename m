From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Persistent memory interface
Date: Fri, 19 Jun 2015 15:14:23 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506191510300.28742@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4iS4v0=QTzjBqRx=hv6egfYECAFNmtmZBrH0VOLM3H+Jw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPcyv4iS4v0=QTzjBqRx=hv6egfYECAFNmtmZBrH0VOLM3H+Jw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Andy Lutomirski <luto@amacapital.net>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids



On Fri, 19 Jun 2015, Dan Williams wrote:

> On Fri, Jun 19, 2015 at 9:33 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> > Hi
> >
> > I looked at the new the persistent memory block device driver
> > (drivers/block/pmem.c and arch/x86/kernel/pmem.c) and it seems that the
> > interface between them is incorrect.
> >
> > If I want to use persistent memory in another driver, for a different
> > purpose, how can I make sure that that drivers/block/pmem.c doesn't attach
> > to this piece of memory and export it? It seems not possible.
> > drivers/block/pmem.c attaches to everything without regard that there may
> > be other users of persistent memory.
> 
> Simply partition the pmem device however you see fit and then
> blkdev_get_by_path(<dev>, FMODE_EXCL, <holder>) the resulting
> partition(s).

But that still means accessing it through the block layer.

I need to access persistent memory directly - map it into the kernel space 
and access it as mapped memory - and if I do it, it will fight with 
drivers/block/pmem.c over ownership of the memory :-(

Mikulas
