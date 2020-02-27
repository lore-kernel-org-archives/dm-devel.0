From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v5 2/8] drivers/pmem: Allow pmem_clear_poison() to accept
 arbitrary offset and len
Date: Thu, 27 Feb 2020 14:11:43 +1100
Message-ID: <20200227031143.GH10737@dread.disaster.area>
References: <20200223230330.GE10737@dread.disaster.area>
 <20200224201346.GC14651@redhat.com>
 <CAPcyv4gGrimesjZ=OKRaYTDd5dUVz+U9aPeBMh_H3_YCz4FOEQ@mail.gmail.com>
 <20200224211553.GD14651@redhat.com>
 <CAPcyv4gX8p0YuMg3=r9DtPAO3Lz-96nuNyXbK1X5-cyVzNrDTA@mail.gmail.com>
 <20200225133653.GA7488@redhat.com>
 <CAPcyv4h2fdo=-jqLPTqnuxYVMbBgODWPqafH35yBMBaPa5Rxcw@mail.gmail.com>
 <20200225200824.GB7488@redhat.com>
 <CAPcyv4jN7ntOO2hK4ByDcX4-Kob=aJNOr3fGR_k_8rxZ=3Sz7w@mail.gmail.com>
 <20200226165756.GB30329@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200226165756.GB30329@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Jeff Moyer <jmoyer@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Feb 26, 2020 at 11:57:56AM -0500, Vivek Goyal wrote:
> On Tue, Feb 25, 2020 at 02:49:30PM -0800, Dan Williams wrote:
> [..]
> > > > I'm ok with replacing blkdev_issue_zeroout() with a dax operation
> > > > callback that deals with page aligned entries. That change at least
> > > > makes the error boundary symmetric across copy_from_iter() and the
> > > > zeroing path.
> > >
> > > IIUC, you are suggesting that modify dax_zero_page_range() to take page
> > > aligned start and size and call this interface from
> > > __dax_zero_page_range() and get rid of blkdev_issue_zeroout() in that
> > > path?
> > >
> > > Something like.
> > >
> > > __dax_zero_page_range() {
> > >   if(page_aligned_io)
> > >         call_dax_page_zero_range()
> > >   else
> > >         use_direct_access_and_memcpy;
> > > }
> > >
> > > And other callers of blkdev_issue_zeroout() in filesystems can migrate
> > > to calling dax_zero_page_range() instead.
> > >
> > > If yes, I am not seeing what advantage do we get by this change.
> > >
> > > - __dax_zero_page_range() seems to be called by only partial block
> > >   zeroing code. So dax_zero_page_range() call will remain unused.
> > >
> > >
> > > - dax_zero_page_range() will be exact replacement of
> > >   blkdev_issue_zeroout() so filesystems will not gain anything. Just that
> > >   it will create a dax specific hook.
> > >
> > > In that case it might be simpler to just get rid of blkdev_issue_zeroout()
> > > call from __dax_zero_page_range() and make sure there are no callers of
> > > full block zeroing from this path.
> > 
> > I think you're right. The path I'm concerned about not regressing is
> > the error clearing on new block allocation and we get that already via
> > xfs_zero_extent() and sb_issue_zeroout().
> 
> Well I was wrong. I found atleast one user which uses __dax_zero_page_range()
> to zero full PAGE_SIZE blocks.
> 
> xfs_io -c "allocsp 32K 0" foo.txt

That ioctl interface is deprecated and likely unused by any new
application written since 1999. It predates unwritten extents (1998)
and I don't think any native linux applications have ever used it. A
newly written DAX aware application would almost certainly not use
this interface.

IOWs, I wouldn't use it as justification for some special case
behaviour; I'm more likely to say "rip that ancient ioctl out" than
to jump through hoops because it's implementation behaviour.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
