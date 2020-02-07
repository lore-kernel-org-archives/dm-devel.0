From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/5] dax, pmem: Add a dax operation zero_page_range
Date: Fri, 7 Feb 2020 08:58:45 -0800
Message-ID: <CAPcyv4j_SN3cyeVfkVQBEniGBZ+XgmCx3ezBJ_KwiUpawaq40g@mail.gmail.com>
References: <20200203200029.4592-1-vgoyal@redhat.com> <20200203200029.4592-2-vgoyal@redhat.com>
 <20200205183050.GA26711@infradead.org> <20200205200259.GE14544@redhat.com>
 <CAPcyv4iY=gw86UDLqpiCtathGXRUuxOMuU=unwxzA-cm=0x+Sg@mail.gmail.com> <20200206143443.GB12036@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200206143443.GB12036@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Feb 6, 2020 at 6:35 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Feb 05, 2020 at 04:40:44PM -0800, Dan Williams wrote:
> > On Wed, Feb 5, 2020 at 12:03 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Wed, Feb 05, 2020 at 10:30:50AM -0800, Christoph Hellwig wrote:
> > > > > +   /*
> > > > > +    * There are no users as of now. Once users are there, fix dm code
> > > > > +    * to be able to split a long range across targets.
> > > > > +    */
> > > >
> > > > This comment confused me.  I think this wants to say something like:
> > > >
> > > >       /*
> > > >        * There are now callers that want to zero across a page boundary as of
> > > >        * now.  Once there are users this check can be removed after the
> > > >        * device mapper code has been updated to split ranges across targets.
> > > >        */
> > >
> > > Yes, that's what I wanted to say but I missed one line. Thanks. Will fix
> > > it.
> > >
> > > >
> > > > > +static int pmem_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
> > > > > +                               unsigned int offset, size_t len)
> > > > > +{
> > > > > +   int rc = 0;
> > > > > +   phys_addr_t phys_pos = pgoff * PAGE_SIZE + offset;
> > > >
> > > > Any reason not to pass a phys_addr_t in the calling convention for the
> > > > method and maybe also for dax_zero_page_range itself?
> > >
> > > I don't have any reason not to pass phys_addr_t. If that sounds better,
> > > will make changes.
> >
> > The problem is device-mapper. That wants to use offset to route
> > through the map to the leaf device. If it weren't for the firmware
> > communication requirement you could do:
> >
> > dax_direct_access(...)
> > generic_dax_zero_page_range(...)
> >
> > ...but as long as the firmware error clearing path is required I think
> > we need to do pass the pgoff through the interface and do the pgoff to
> > virt / phys translation inside the ops handler.
>
> Hi Dan,
>
> Drivers can easily convert offset into dax device (say phys_addr_t) to
> pgoff and offset into page, isn't it?

It's not a phys_addr_t it's a 64-bit device relative offset.
