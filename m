From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/13] dax, pmem: move cpu cache maintenance to libnvdimm
Date: Sun, 22 Jan 2017 23:10:04 -0800
Message-ID: <CAPcyv4h83wk5SGVPY+8nUZ1e4Gq9fz61GE3BhAdzGi=HFAuDcg@mail.gmail.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <BY2PR21MB0036C7BBC487D7C101F36DCFCB700@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170121175212.GA28180@lst.de>
 <BY2PR21MB00367799FE7B7E8302A99260CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122162910.GA5267@lst.de>
 <BY2PR21MB00368E95CBB533D4C761C882CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122183046.GA7359@lst.de>
 <BY2PR21MB0036CC7935BFE438EA001763CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122184439.GA7603@lst.de>
 <BY2PR21MB0036CA85562DDD21814C0B27CB720@BY2PR21MB0036.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <BY2PR21MB0036CA85562DDD21814C0B27CB720-vtcBUbTck+B5JOYzoceCCc1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: dm-devel.ids

On Sun, Jan 22, 2017 at 10:37 PM, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org> wrote:
> From: Christoph Hellwig [mailto:hch-jcswGhMUV9g@public.gmane.org]
>> On Sun, Jan 22, 2017 at 06:39:28PM +0000, Matthew Wilcox wrote:
>> > Two guests on the same physical machine (or a guest and a host) have access
>> > to the same set of physical addresses.  This might be an NV-DIMM, or it might
>> > just be DRAM (for the purposes of reducing guest overhead).  The network
>> > filesystem has been enhanced with a call to allow the client to ask the server
>> > "What is the physical address for this range of bytes in this file?"
>> >
>> > We don't want to use the guest pagecache here.  That's antithetical to the
>> > second usage, and it's inefficient for the first usage.
>>
>> And the answer is that you need a dax device for whatever memoery exposed
>> in this way, as it needs to show up in the memory map for example.
>
> Wow, DAX devices look painful and awful.  I certainly don't want to be exposing the memory fronted by my network filesystem to userspace to access.  That just seems like a world of pain and bad experiences.  Absolutely the filesystem (or perhaps better, the ACPI tables) need to mark that chunk of memory as reserved, but it's definitely not available for anyone to access without the filesystem being aware.
>
> Even if we let the filesystem create a DAX device that doesn't show up in /dev (for example), Dan's patches don't give us a way to go from a file on the filesystem to a set of dax_ops.  And it does need to be a per-file operation, eg to support a file on an XFS volume which might be on a RT device or a normal device.  That was why I leaned towards an address_space operation, but I'd be happy to see an inode_operation instead.

How about we solve the copy_from_user() abuse first before we hijack
this thread for some future feature that afaics has no patches posted
yet.

An incremental step towards disentangling filesystem-dax from
block_devices is a lookup mechanism to go from a block_device to a dax
object that holds dax_ops. When this brave new filesystem enabling
appears it can grow a mechanism to lookup, or mount on, the dax object
directly.

One idea is to just hang a pointer to this dax object off of
bdev_inode, set at bdev open() time.
