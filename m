From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/13] dax, pmem: move cpu cache maintenance to
        libnvdimm
Date: Sat, 21 Jan 2017 18:52:12 +0100
Message-ID: <20170121175212.GA28180@lst.de>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com> <BY2PR21MB0036C7BBC487D7C101F36DCFCB700@BY2PR21MB0036.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BY2PR21MB0036C7BBC487D7C101F36DCFCB700@BY2PR21MB0036.namprd21.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Brian Boylston <brian.boylston@hpe.com>, Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Ross Zwisler <ros>
List-Id: dm-devel.ids

On Sat, Jan 21, 2017 at 04:28:52PM +0000, Matthew Wilcox wrote:
> Of course, there may not be a backing device either!

s/backing device/block device/ ?  If so fully agreed.  I like the dax_ops
scheme, but we should go all the way and detangle it from the block
device.  I already brought up this issue with the fallback to direct I/O
on I/O error series.

> I see two possible routes here:
> 
> 1. Add a new address_space_operation:
> 
> 	const struct dax_operations *(*get_dax_ops)(struct address_space *);
> 
> 2. Add two of the dax_operations to address_space_operations:
> 
> 	size_t (*copy_from_iter)(struct address_space *, void *, size_t, struct iov_iter *);
> 	void (*flush)(struct address_space *, void *, size_t);
> (we won't need ->direct_access as an address_space op because that'll be handled a different way in the brave new world that supports non-bdev-based filesystems)

And both of them are wrong.  The write_begin/write_end mistake
notwithstanding address_space ops are operations the VM can call without
knowing things like fs locking contexts.  The above on the other hand
are device operations provided by the low-level driver, similar to
block_device operations.  So what we need is to have a way to mount
a dax device as a file system, similar to how we support that for block
or MTD devices and can then call methods on it.  For now this will
be a bit complicated because all current DAX-aware file systems also
still need block device for the metadata path, so we can't just say
you mount either a DAX or block device.  But I think we should aim
for mounting a DAX device as the primary use case, and then deal
with block device emulation as a generic DAX layer thing, similarly
how we implement (bad in the rw case) block devices on top of MTD.
