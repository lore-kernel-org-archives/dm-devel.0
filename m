From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 2/8] drivers/pmem: Allow pmem_clear_poison() to accept
 arbitrary offset and len
Date: Fri, 28 Feb 2020 12:30:54 +1100
Message-ID: <20200228013054.GO10737@dread.disaster.area>
References: <20200218214841.10076-1-vgoyal@redhat.com>
 <20200218214841.10076-3-vgoyal@redhat.com>
 <x49lfoxj622.fsf@segfault.boston.devel.redhat.com>
 <20200220215707.GC10816@redhat.com>
 <x498skv3i5r.fsf@segfault.boston.devel.redhat.com>
 <20200221201759.GF25974@redhat.com>
 <20200223230330.GE10737@dread.disaster.area>
 <20200224153844.GB14651@redhat.com>
 <20200227030248.GG10737@dread.disaster.area>
 <CAPcyv4gTSb-xZ2k938HxQeAXATvGg1aSkEGPfrzeQAz9idkgzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gTSb-xZ2k938HxQeAXATvGg1aSkEGPfrzeQAz9idkgzQ@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 26, 2020 at 08:19:37PM -0800, Dan Williams wrote:
> On Wed, Feb 26, 2020 at 7:03 PM Dave Chinner <david@fromorbit.com> wrote:
> > On Mon, Feb 24, 2020 at 10:38:44AM -0500, Vivek Goyal wrote:
> > > Anyway, partial page truncate can't ensure that data in rest of the page can
> > > be read back successfully. Memory can get poison after the write and
> > > hence read after truncate will still fail.
> >
> > Which is where the notification requirement comes in. Yes, we may
> > still get errors on read or write, but if memory at rest goes bad,
> > we want to handle that and correct it ASAP, not wait days or months
> > for something to trip over the poisoned page before we find out
> > about it.
> >
> > > Hence, all we are trying to ensure is that if a poison is known at the
> > > time of writing partial page, then we should return error to user space.
> >
> > I think within FS-DAX infrastructure, any access to the data (read
> > or write) within a poisoned page or a page marked with PageError()
> > should return EIO to the caller, unless it's the specific command to
> > clear the error/poison state on the page. What happens with that
> > error state is then up to the caller.
> >
> 
> I agree with most of the above if you replace "device-dax error
> handling" with "System RAM error handling". It's typical memory error
> handling that injects the page->index and page->mappping dependency.

I disagree, but that's beside the point and not worth arguing.

> So you want the FS to have error handling for just pmem errors or all
> memory errors?

Just pmem errors in the specific range the filesystem manages - we
really only care storage errors because those are the only errors
the filesystem is responsible for handling correctly.

Somebody else can worry about errors that hit page cache pages -
page cache pages require mapping/index pointers on each page anyway,
so a generic mechanism for handling those errors can be built into
the page cache. And if the error is in general kernel memory, then
it's game over for the entire kernel at that point, not just the
filesystem.

> And you want this to be done without the mm core using
> page->index to identify what to unmap when the error happens?

Isn't that exactly what I just said? We get the page address that
failed, the daxdev can turn that into a sector address and call into
the filesystem with a {sector, len, errno} tuple. We then do a
reverse mapping lookup on {sector, len} to find all the owners of
that range in the filesystem. If it's file data, that owner record
gives us the inode and the offset into the file, which then gives us
a {mapping, index} tuple.

Further, the filesytem reverse map is aware that it's blocks can be
shared by multiple owners, so it will have a record for every inode
and file offset that maps to that page. Hence we can simply iterate
the reverse map and do that whacky collect_procs/kill_procs dance
for every {mapping, index} pair that references the the bad range.

Nothing ever needs to be stored on the struct page...

> Memory
> error scanning is not universally available on all pmem
> implementations, so FS will need to subscribe for memory-error
> handling events.

No. Filesystems interact with the underlying device abstraction, not
the physical storage that lies behind that device abstraction.  The
filesystem should not interface with pmem directly in any way (all
direct accesses are hidden inside fs/dax.c!), nor should it care
about the quirks of the pmem implementation it is sitting on. That's
what the daxdev abstraction is supposed to hide from the users of
the pmem.

IOWs, the daxdev infrastructure subscribes to memory-error event
subsystem, calls out to the filesystem when an error in a page in
the daxdev is reported. The filesystem only needs to know the
{sector, len, errno} tuple related to the error; it is the device's
responsibility to handle the physical mechanics of listening,
filtering and translating MCEs to a format the filesystem
understands....

Another reason it should be provided by the daxdev as a {sector,
len, errno} tuple is that it also allows non-dax block devices to
implement the similar error notifications and provide filesystems
with exactly the same information so the filesystem can start
auto-recovery processes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
