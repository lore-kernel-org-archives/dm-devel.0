From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [dm-devel] [PATCH v2] dm: Call proper helper to determine dax support
Date: Fri, 18 Sep 2020 09:54:51 -0700
Message-ID: <CAPcyv4ii+NWnJhLWwz=Z+2aAJ=DdjwQoqPC+hO88CsM2ub5FEw@mail.gmail.com>
References: <160040692945.25320.13233625491405115889.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20200918153041.GN7954@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20200918153041.GN7954@magnolia>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, Adrian Huang <ahuang12@lenovo.com>, Mikulas Patocka <mpatocka@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>
List-Id: dm-devel.ids

On Fri, Sep 18, 2020 at 8:31 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
>
> On Thu, Sep 17, 2020 at 10:30:03PM -0700, Dan Williams wrote:
> > From: Jan Kara <jack@suse.cz>
> >
> > DM was calling generic_fsdax_supported() to determine whether a device
> > referenced in the DM table supports DAX. However this is a helper for "leaf" device drivers so that
> > they don't have to duplicate common generic checks. High level code
> > should call dax_supported() helper which that calls into appropriate
> > helper for the particular device. This problem manifested itself as
> > kernel messages:
> >
> > dm-3: error: dax access failed (-95)
> >
> > when lvm2-testsuite run in cases where a DM device was stacked on top of
> > another DM device.
>
> Is there somewhere where it is documented which of:
>
> bdev_dax_supported, generic_fsdax_supported, and dax_supported
>
> one is supposed to use for a given circumstance?

generic_fsdax_supported should be private to device drivers populating
their dax_operations. I think it deserves a rename at this point.
dax_supported() knows how to route through multiple layers of stacked
block-devices to ask the "is dax supported" question at each level.

> I guess the last two can test a given range w/ blocksize; the first one
> only does blocksize; and the middle one also checks with whatever fs
> might be mounted? <shrug>
>
> (I ask because it took me a while to figure out how to revert correctly
> the brokenness in rc3-5 that broke my nightly dax fstesting.)

Again, apologies for that.
