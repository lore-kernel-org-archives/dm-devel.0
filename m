From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Persistent memory interface
Date: Fri, 19 Jun 2015 12:23:13 -0700
Message-ID: <CAPcyv4i7e-wu6kJq5_0AV24RdqorJ5wwTrgOnJfjbyJcytc2hw@mail.gmail.com>
References: <alpine.LRH.2.02.1506191211480.30318@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4iS4v0=QTzjBqRx=hv6egfYECAFNmtmZBrH0VOLM3H+Jw@mail.gmail.com>
	<alpine.LRH.2.02.1506191510300.28742@file01.intranet.prod.int.rdu2.redhat.com>
	<CAPcyv4ihXLfHcEGx=ZWMWCmfgJpibYQiPiTZBPH5HVuYOmdzkQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAPcyv4ihXLfHcEGx=ZWMWCmfgJpibYQiPiTZBPH5HVuYOmdzkQ@mail.gmail.com>
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
Cc: Jens Axboe <axboe@fb.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm <linux-nvdimm@ml01.01.org>, Andy Lutomirski <luto@amacapital.net>, Keith Busch <keith.busch@intel.com>, dm-devel@redhat.com, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-Id: dm-devel.ids

On Fri, Jun 19, 2015 at 12:22 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Jun 19, 2015 at 12:14 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>
>>
>> On Fri, 19 Jun 2015, Dan Williams wrote:
>>
>>> On Fri, Jun 19, 2015 at 9:33 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>>> > Hi
>>> >
>>> > I looked at the new the persistent memory block device driver
>>> > (drivers/block/pmem.c and arch/x86/kernel/pmem.c) and it seems that the
>>> > interface between them is incorrect.
>>> >
>>> > If I want to use persistent memory in another driver, for a different
>>> > purpose, how can I make sure that that drivers/block/pmem.c doesn't attach
>>> > to this piece of memory and export it? It seems not possible.
>>> > drivers/block/pmem.c attaches to everything without regard that there may
>>> > be other users of persistent memory.
>>>
>>> Simply partition the pmem device however you see fit and then
>>> blkdev_get_by_path(<dev>, FMODE_EXCL, <holder>) the resulting
>>> partition(s).
>>
>> But that still means accessing it through the block layer.
>>
>> I need to access persistent memory directly - map it into the kernel space
>> and access it as mapped memory - and if I do it, it will fight with
>> drivers/block/pmem.c over ownership of the memory :-(
>>
>
> See the latest definition of struct block_device_operations in these
> patches.  We now have ->direct_access() in the 4.0 kernel and will
> have ->rw_bytes() in the 4.2 kernel if you want to directly access the
> memory published by a pmem device.

I'll include you on the next rev of patches that add a
kmap_atomic_pfn_t(): https://lkml.org/lkml/2015/6/5/802
