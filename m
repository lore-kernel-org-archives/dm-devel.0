From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 2/8] drivers/pmem: Allow pmem_clear_poison() to accept
 arbitrary offset and len
Date: Thu, 27 Feb 2020 19:28:41 -0800
Message-ID: <CAPcyv4i2vjUGrwaRsjp1-L0wFf0a00e46F-SUbocQBkiQ3M1kg@mail.gmail.com>
References: <20200218214841.10076-1-vgoyal@redhat.com> <20200218214841.10076-3-vgoyal@redhat.com>
 <x49lfoxj622.fsf@segfault.boston.devel.redhat.com> <20200220215707.GC10816@redhat.com>
 <x498skv3i5r.fsf@segfault.boston.devel.redhat.com> <20200221201759.GF25974@redhat.com>
 <20200223230330.GE10737@dread.disaster.area> <20200224153844.GB14651@redhat.com>
 <20200227030248.GG10737@dread.disaster.area> <CAPcyv4gTSb-xZ2k938HxQeAXATvGg1aSkEGPfrzeQAz9idkgzQ@mail.gmail.com>
 <20200228013054.GO10737@dread.disaster.area>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200228013054.GO10737@dread.disaster.area>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 27, 2020 at 5:31 PM Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Feb 26, 2020 at 08:19:37PM -0800, Dan Williams wrote:
[..]
> > So you want the FS to have error handling for just pmem errors or all
> > memory errors?
>
> Just pmem errors in the specific range the filesystem manages - we
> really only care storage errors because those are the only errors
> the filesystem is responsible for handling correctly.
>
> Somebody else can worry about errors that hit page cache pages -
> page cache pages require mapping/index pointers on each page anyway,
> so a generic mechanism for handling those errors can be built into
> the page cache. And if the error is in general kernel memory, then
> it's game over for the entire kernel at that point, not just the
> filesystem.
>
> > And you want this to be done without the mm core using
> > page->index to identify what to unmap when the error happens?
>
> Isn't that exactly what I just said? We get the page address that
> failed, the daxdev can turn that into a sector address and call into
> the filesystem with a {sector, len, errno} tuple. We then do a
> reverse mapping lookup on {sector, len} to find all the owners of
> that range in the filesystem. If it's file data, that owner record
> gives us the inode and the offset into the file, which then gives us
> a {mapping, index} tuple.
>
> Further, the filesytem reverse map is aware that it's blocks can be
> shared by multiple owners, so it will have a record for every inode
> and file offset that maps to that page. Hence we can simply iterate
> the reverse map and do that whacky collect_procs/kill_procs dance
> for every {mapping, index} pair that references the the bad range.
>
> Nothing ever needs to be stored on the struct page...

Ok, so fs/dax.c needs to coordinate with mm/memory-failure.c to say
"don't perform generic memory-error-handling, there's an fs that owns
this daxdev and wants to disposition errors". The fs/dax.c
infrastructure that sets up ->index and ->mapping would still need to
be there for ext4 until its ready to take on the same responsibility.
Last I checked the ext4 reverse mapping implementation was not as
capable as XFS. This goes back to why the initial design avoided
relying on not universally available / stable reverse-mapping
facilities and opted for extending the generic mm/memory-failure.c
implementation.

If XFS optionally supplants mm/memory-failure.c I would expect we'd
want to do better than the "whacky collect_procs/kill_procs"
implementation and let applications register for a notification format
better than BUS_MCEERR_AO signals.

> > Memory
> > error scanning is not universally available on all pmem
> > implementations, so FS will need to subscribe for memory-error
> > handling events.
>
> No. Filesystems interact with the underlying device abstraction, not
> the physical storage that lies behind that device abstraction.  The
> filesystem should not interface with pmem directly in any way (all
> direct accesses are hidden inside fs/dax.c!), nor should it care
> about the quirks of the pmem implementation it is sitting on. That's
> what the daxdev abstraction is supposed to hide from the users of
> the pmem.

I wasn't proposing that XFS have a machine-check handler, I was trying
to get to the next level detail of the async notification interface to
the fs.

>
> IOWs, the daxdev infrastructure subscribes to memory-error event
> subsystem, calls out to the filesystem when an error in a page in
> the daxdev is reported. The filesystem only needs to know the
> {sector, len, errno} tuple related to the error; it is the device's
> responsibility to handle the physical mechanics of listening,
> filtering and translating MCEs to a format the filesystem
> understands....
>
> Another reason it should be provided by the daxdev as a {sector,
> len, errno} tuple is that it also allows non-dax block devices to
> implement the similar error notifications and provide filesystems
> with exactly the same information so the filesystem can start
> auto-recovery processes....

The driver layer does already have 'struct badblocks' that both pmem
and md use, just no current way for the FS to get a reference to it.
However, my hope was to get away from the interface being sector based
because the error granularity is already smaller than a sector in the
daxdev case as compared to a bdev. A daxdev native error record should
be a daxdev relative byte offset, not a sector. If the fs wants to
align the blast radius of the error to sectors or fs-blocks that's its
choice, but I don't think the driver interface should preclude
sub-sector error handling. Essentially I don't want to add more bdev
semantics to fs/dax.c while Vivek is busy removing them.
