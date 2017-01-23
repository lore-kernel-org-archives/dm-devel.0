From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/13] dax, pmem: move cpu cache maintenance to
        libnvdimm
Date: Mon, 23 Jan 2017 16:58:17 +0100
Message-ID: <20170123155817.GA517@lst.de>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com> <BY2PR21MB0036C7BBC487D7C101F36DCFCB700@BY2PR21MB0036.namprd21.prod.outlook.com> <20170121175212.GA28180@lst.de> <BY2PR21MB00367799FE7B7E8302A99260CB730@BY2PR21MB0036.namprd21.prod.outlook.com> <20170122162910.GA5267@lst.de> <BY2PR21MB00368E95CBB533D4C761C882CB730@BY2PR21MB0036.namprd21.prod.outlook.com> <20170122183046.GA7359@lst.de> <BY2PR21MB0036CC7935BFE438EA001763CB730@BY2PR21MB0036.namprd21.prod.outlook.com> <20170122184439.GA7603@lst.de> <BY2PR21MB0036CA85562DDD21814C0B27CB720@BY2PR21MB0036.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BY2PR21MB0036CA85562DDD21814C0B27CB720@BY2PR21MB0036.namprd21.prod.outlook.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Toshi Kani <toshi.kani@hpe.com>, Mike Snitzer <snitzer@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@fb.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-Id: dm-devel.ids

On Mon, Jan 23, 2017 at 06:37:18AM +0000, Matthew Wilcox wrote:
> Wow, DAX devices look painful and awful.  I certainly don't want to be
> exposing the memory fronted by my network filesystem to userspace to
> access.  That just seems like a world of pain and bad experiences.

So what is your interest in using DAX for your file system then instead
of a private mechanisms?

> Absolutely the filesystem (or perhaps better, the ACPI tables) need to
> mark that chunk of memory as reserved, but it's definitely not available
> for anyone to access without the filesystem being aware.

That does sounds like a massive special case all over the stack.
But until we see it I think we should simply ignore this case and
concentrate on what we have right now.

> Even if we let the filesystem create a DAX device that doesn't show
> up in /dev (for example), Dan's patches don't give us a way to go
> from a file on the filesystem to a set of dax_ops.

Which doesn't make sense any way.  The entry points into the file system
are read + write and mmap, and the file system might then use libraries
to implement different types of I/O, such as the page cache or DAX.

> And it does need to be a per-file operation, eg to support a file on
> an XFS volume which might be on a RT device or a normal device.
> That was why I leaned towards an address_space operation, but I'd be
> happy to see an inode_operation instead. 

Again, no.  The layers above the file system have absolutely no business
to even know if we're using DAX or pagecache access, nevermind how
in detail they are used.  Assuming you want to use DAX-like semantics
it's up to the lower level to expose the correct operations for
a given memory region.  Right now these would just be intel nfit or
legacy 820 + ADR for regions marked such in the memory map.  If say
a hypervisor wants to expose a region that needs a special flush
call or even has requirements on the type of memcpy it needs to
provide operations for this memory region.  The user of this region
(DAX-native file system pmem driver or device DAX) then needs
to use these methods.

And those pretty much are the methods Dan proposes here - it's
just that we should not tie them to block device operations, at
least not in the long run.
