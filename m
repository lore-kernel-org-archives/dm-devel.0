From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/13] dax, pmem: move cpu cache maintenance to libnvdimm
Date: Sun, 22 Jan 2017 09:30:23 -0800
Message-ID: <CAPcyv4jEXsjw_Mo3aLRFmJr8ThqLPJPjdPjz7Q3ZS0ZC-AaDBw@mail.gmail.com>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <BY2PR21MB0036C7BBC487D7C101F36DCFCB700@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170121175212.GA28180@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170121175212.GA28180-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: dm-devel.ids

On Sat, Jan 21, 2017 at 9:52 AM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> On Sat, Jan 21, 2017 at 04:28:52PM +0000, Matthew Wilcox wrote:
>> Of course, there may not be a backing device either!
>
> s/backing device/block device/ ?  If so fully agreed.  I like the dax_ops
> scheme, but we should go all the way and detangle it from the block
> device.  I already brought up this issue with the fallback to direct I/O
> on I/O error series.
>
>> I see two possible routes here:
>>
>> 1. Add a new address_space_operation:
>>
>>       const struct dax_operations *(*get_dax_ops)(struct address_space *);
>>
>> 2. Add two of the dax_operations to address_space_operations:
>>
>>       size_t (*copy_from_iter)(struct address_space *, void *, size_t, struct iov_iter *);
>>       void (*flush)(struct address_space *, void *, size_t);
>> (we won't need ->direct_access as an address_space op because that'll be handled a different way in the brave new world that supports non-bdev-based filesystems)
>
> And both of them are wrong.  The write_begin/write_end mistake
> notwithstanding address_space ops are operations the VM can call without
> knowing things like fs locking contexts.  The above on the other hand
> are device operations provided by the low-level driver, similar to
> block_device operations.  So what we need is to have a way to mount
> a dax device as a file system, similar to how we support that for block
> or MTD devices and can then call methods on it.  For now this will
> be a bit complicated because all current DAX-aware file systems also
> still need block device for the metadata path, so we can't just say
> you mount either a DAX or block device.  But I think we should aim
> for mounting a DAX device as the primary use case, and then deal
> with block device emulation as a generic DAX layer thing, similarly
> how we implement (bad in the rw case) block devices on top of MTD.

So are you saying we need a way to go from a block_device inode to a
dax_device inode and then look up the dax_operations from there?

A filesystem, if it so chooses, could mount on top of the dax_device
inode directly?

I did add a dax_superblock for the device-dax character device
representation I could refactor that so the block_device presentation
of a namespace and a character device presentation are just different
layers on top of the base-level dax inode.

...or am I not tracking what you are suggesting?
