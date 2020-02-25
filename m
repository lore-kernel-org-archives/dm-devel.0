From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v5 2/8] drivers/pmem: Allow pmem_clear_poison() to accept
 arbitrary offset and len
Date: Tue, 25 Feb 2020 08:25:27 -0800
Message-ID: <CAPcyv4h2fdo=-jqLPTqnuxYVMbBgODWPqafH35yBMBaPa5Rxcw@mail.gmail.com>
References: <20200218214841.10076-3-vgoyal@redhat.com> <x49lfoxj622.fsf@segfault.boston.devel.redhat.com>
 <20200220215707.GC10816@redhat.com> <x498skv3i5r.fsf@segfault.boston.devel.redhat.com>
 <20200221201759.GF25974@redhat.com> <20200223230330.GE10737@dread.disaster.area>
 <20200224201346.GC14651@redhat.com> <CAPcyv4gGrimesjZ=OKRaYTDd5dUVz+U9aPeBMh_H3_YCz4FOEQ@mail.gmail.com>
 <20200224211553.GD14651@redhat.com> <CAPcyv4gX8p0YuMg3=r9DtPAO3Lz-96nuNyXbK1X5-cyVzNrDTA@mail.gmail.com>
 <20200225133653.GA7488@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200225133653.GA7488@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Feb 25, 2020 at 5:37 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Feb 24, 2020 at 01:32:58PM -0800, Dan Williams wrote:
>
> [..]
> > > > > Ok, how about if I add one more patch to the series which will check
> > > > > if unwritten portion of the page has known poison. If it has, then
> > > > > -EIO is returned.
> > > > >
> > > > >
> > > > > Subject: pmem: zero page range return error if poisoned memory in unwritten area
> > > > >
> > > > > Filesystems call into pmem_dax_zero_page_range() to zero partial page upon
> > > > > truncate. If partial page is being zeroed, then at the end of operation
> > > > > file systems expect that there is no poison in the whole page (atleast
> > > > > known poison).
> > > > >
> > > > > So make sure part of the partial page which is not being written, does not
> > > > > have poison. If it does, return error. If there is poison in area of page
> > > > > being written, it will be cleared.
> > > >
> > > > No, I don't like that the zero operation is special cased compared to
> > > > the write case. I'd say let's make them identical for now. I.e. fail
> > > > the I/O at dax_direct_access() time.
> > >
> > > So basically __dax_zero_page_range() will only write zeros (and not
> > > try to clear any poison). Right?
> >
> > Yes, the zero operation would have already failed at the
> > dax_direct_access() step if there was present poison.
> >
> > > > I think the error clearing
> > > > interface should be an explicit / separate op rather than a
> > > > side-effect. What about an explicit interface for initializing newly
> > > > allocated blocks, and the only reliable way to destroy poison through
> > > > the filesystem is to free the block?
> > >
> > > Effectively pmem_make_request() is already that interface filesystems
> > > use to initialize blocks and clear poison. So we don't really have to
> > > introduce a new interface?
> >
> > pmem_make_request() is shared with the I/O path and is too low in the
> > stack to understand intent. DAX intercepts the I/O path closer to the
> > filesystem and can understand zeroing vs writing today. I'm proposing
> > we go a step further and make DAX understand free-to-allocated-block
> > initialization instead of just zeroing. Inject the error clearing into
> > that initialization interface.
> >
> > > Or you are suggesting separate dax_zero_page_range() interface which will
> > > always call into firmware to clear poison. And that will make sure latent
> > > poison is cleared as well and filesystem should use that for block
> > > initialization instead?
> >
> > Yes, except latent poison would not be cleared until the zeroing is
> > implemented with movdir64b instead of callouts to firmware. It's
> > otherwise too slow to call out to firmware unconditionally.
> >
> > > I do like the idea of not having to differentiate
> > > between known poison and latent poison. Once a block has been initialized
> > > all poison should be cleared (known/latent). I am worried though that
> > > on large devices this might slowdown filesystem initialization a lot
> > > if they are zeroing large range of blocks.
> > >
> > > If yes, this sounds like two different patch series. First patch series
> > > takes care of removing blkdev_issue_zeroout() from
> > > __dax_zero_page_range() and couple of iomap related cleans christoph
> > > wanted.
> > >
> > > And second patch series for adding new dax operation to zero a range
> > > and always call info firmware to clear poison and modify filesystems
> > > accordingly.
> >
> > Yes, but they may need to be merged together. I don't want to regress
> > the ability of a block-aligned hole-punch to clear errors.
>
> Hi Dan,
>
> IIUC, block aligned hole punch don't go through __dax_zero_page_range()
> path. Instead they call blkdev_issue_zeroout() at later point of time.
>
> Only partial block zeroing path is taking __dax_zero_page_range(). So
> even if we remove poison clearing code from __dax_zero_page_range(),
> there should not be a regression w.r.t full block zeroing. Only possible
> regression will be if somebody was doing partial block zeroing on sector
> boundary, then poison will not be cleared.
>
> We now seem to be discussing too many issues w.r.t poison clearing
> and dax. Atleast 3 issues are mentioned in this thread.
>
> A. Get rid of dependency on block device in dax zeroing path.
>    (__dax_zero_page_range)
>
> B. Provide a way to clear latent poison. And possibly use movdir64b to
>    do that and make filesystems use that interface for initialization
>    of blocks.
>
> C. Dax zero operation is clearing known poison while copy_from_iter() is
>    not. I guess this ship has already sailed. If we change it now,
>    somebody will complain of some regression.
>
> For issue A, there are two possible ways to deal with it.
>
> 1. Implement a dax method to zero page. And this method will also clear
>    known poison. This is what my patch series is doing.
>
> 2. Just get rid of blkdev_issue_zeroout() from __dax_zero_page_range()
>    so that no poison will be cleared in __dax_zero_page_range() path. This
>    path is currently used in partial page zeroing path and full filesystem
>    block zeroing happens with blkdev_issue_zeroout(). There is a small
>    chance of regression here in case of sector aligned partial block
>    zeroing.
>
> My patch series takes care of issue A without any regressions. In fact it
> improves current interface. For example, currently "truncate -s 512
> foo.txt" will succeed even if first sector in the block is poisoned. My
> patch series fixes it. Current implementation will return error on if any
> non sector aligned truncate is done and any of the sector is poisoned. My
> implementation will not return error if poisoned can be cleared as part
> of zeroing. It will return only if poison is present in non-zeoring part.

That asymmetry makes the implementation too much of a special case. If
the dax mapping path forces error boundaries on PAGE_SIZE blocks then
so should zeroing.

>
> Why don't we solve one issue A now and deal with issue B and C later in
> a sepaprate patch series. This patch series gets rid of dependency on
> block device in dax path and also makes current zeroing interface better.

I'm ok with replacing blkdev_issue_zeroout() with a dax operation
callback that deals with page aligned entries. That change at least
makes the error boundary symmetric across copy_from_iter() and the
zeroing path.
