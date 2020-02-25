From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 2/8] drivers/pmem: Allow pmem_clear_poison() to accept
 arbitrary offset and len
Date: Tue, 25 Feb 2020 13:52:38 -0800
Message-ID: <CAPcyv4jBCCYXQRjOLHa79rW3qB9kisGRN6yTvcXYs6JJU1-p7g@mail.gmail.com>
References: <20200218214841.10076-1-vgoyal@redhat.com> <20200218214841.10076-3-vgoyal@redhat.com>
 <x49lfoxj622.fsf@segfault.boston.devel.redhat.com> <20200220215707.GC10816@redhat.com>
 <x498skv3i5r.fsf@segfault.boston.devel.redhat.com> <20200221201759.GF25974@redhat.com>
 <20200223230330.GE10737@dread.disaster.area> <CAPcyv4ghusuMsAq8gSLJKh1fiKjwa8R_-ojVgjsttoPRqBd_Sg@mail.gmail.com>
 <x49blpop00m.fsf@segfault.boston.devel.redhat.com> <CAPcyv4gCA_oR8_8+zhAhMnqOga9GcpMX97S+x8_UD6zLEQ0Cew@mail.gmail.com>
 <x49sgizodni.fsf@segfault.boston.devel.redhat.com> <CAPcyv4gUM47QgGKvK4ZVUek6f=ABT7hRFX47-DQiD6AcrxtRHA@mail.gmail.com>
 <x494kveh0gm.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <x494kveh0gm.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 25, 2020 at 12:33 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > On Mon, Feb 24, 2020 at 1:53 PM Jeff Moyer <jmoyer@redhat.com> wrote:
> >>
> >> Dan Williams <dan.j.williams@intel.com> writes:
> >>
> >> >> Let's just focus on reporting errors when we know we have them.
> >> >
> >> > That's the problem in my eyes. If software needs to contend with
> >> > latent error reporting then it should always contend otherwise
> >> > software has multiple error models to wrangle.
> >>
> >> The only way for an application to know that the data has been written
> >> successfully would be to issue a read after every write.  That's not a
> >> performance hit most applications are willing to take.  And, of course,
> >> the media can still go bad at a later time, so it only guarantees the
> >> data is accessible immediately after having been written.
> >>
> >> What I'm suggesting is that we should not complete a write successfully
> >> if we know that the data will not be retrievable.  I wouldn't call this
> >> adding an extra error model to contend with.  Applications should
> >> already be checking for errors on write.
> >>
> >> Does that make sense? Are we talking past each other?
> >
> > The badblock list is late to update in both directions, late to add
> > entries that the scrub needs to find and late to delete entries that
> > were inadvertently cleared by cache-line writes that did not first
> > ingest the poison for a read-modify-write.
>
> We aren't looking for perfection.  If the badblocks list is populated,
> then report the error instead of letting the user write data that we
> know they won't be able to access later.
>
> You have confused me, though, since I thought that stores to bad media
> would not clear errors.  Perhaps you are talking about some future
> hardware implementation that doesn't yet exist?

No, today cacheline aligned DMA, and cpu cachelines that are fully
dirtied without a demand fill can end up clearing poison. The
movdir64b instruction provides a way to force this behavior from the
cpu where it was previously luck.

> > So I see the above as being wishful in using the error list as the
> > hard source of truth and unfortunate to up-level all sub-sector error
> > entries into full PAGE_SIZE data offline events.
>
> The page size granularity is only an issue for mmap().  If you are using
> read/write, then 512 byte granularity can be achieved.  Even with mmap,
> if you encounter an error on a 4k page, you can query the status of each
> sector in that page to isolate the error.  So I'm not quite sure I
> understand what you're getting at.

I'm getting at the fact that we don't allow mmap on PAGE_SIZE
granularity in the presence of errors, and don't allow dax I/O to the
page when an error is present. Only non-dax direct-I/O can read /
write at sub-page granularity in the presence of errors.

The interface to query the status is not coordinated with the
filesystem, but that's a whole other discussion. Yes, we're getting a
bit off in the weeds.

> > I'm hoping we can find a way to make the error handling more fine
> > grained over time, but for the current patch, managing the blast
> > radius as PAGE_SIZE granularity at least matches the zero path with
> > the write path.
>
> I think the write path can do 512 byte granularity, not page size.
> Anyway, I think we've gone far enough off into the weeds that more
> patches will have to be posted for debate.  :)
>

It can't, see dax_iomap_actor(). That call to dax_direct_access() will
fail if it hits a known badblock.

> >> > Setting that aside we can start with just treating zeroing the same as
> >> > the copy_from_iter() case and fail the I/O at the dax_direct_access()
> >> > step.
> >>
> >> OK.
> >>
> >> > I'd rather have a separate op that filesystems can use to clear errors
> >> > at block allocation time that can be enforced to have the correct
> >> > alignment.
> >>
> >> So would file systems always call that routine instead of zeroing, or
> >> would they first check to see if there are badblocks?
> >
> > The proposal is that filesystems distinguish zeroing from free-block
> > allocation/initialization such that the fsdax implementation directs
> > initialization to a driver callback. This "initialization op" would
> > take care to check for poison and clear it. All other dax paths would
> > not consult the badblocks list.
>
> What do you mean by "all other dax paths?"  Would that include
> mmap/direct_access?  Because that definitely should still consult the
> badblocks list.

dax_direct_access() consults the badblock list,
dax_copy_{to,from}_iter() do not, and badblocks discovered after a
page is mapped do not invalidate the page unless the poison is
consumed.

> I'm not against having a separate operation for clearing errors, but I
> guess I'm not convinced it's cleaner, either.

The idea with a separate op is to have an explicit ABI to clear errors
like page-aligned-hole-punch (FALLOC_FL_PUNCH_ERROR?) vs some implicit
side effect of direct-I/O writes.

I also feel like we're heading in a direction that tries to avoid
relying on the cpu machine-check recovery path at all costs. That's
the kernel's prerogative, of course, but it seems like at a minimum
we're not quite on the same page about what role machine-check
recovery plays in the error handling model.
