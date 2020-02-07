From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/5] dax, pmem: Add a dax operation zero_page_range
Date: Fri, 7 Feb 2020 09:06:32 -0800
Message-ID: <CAPcyv4g8jUhaKXhoh-1cvE4oi2v0JQcLrnFUW9zsRiC4F-7-zQ@mail.gmail.com>
References: <20200203200029.4592-1-vgoyal@redhat.com> <20200203200029.4592-2-vgoyal@redhat.com>
 <20200205183050.GA26711@infradead.org> <20200205200259.GE14544@redhat.com>
 <CAPcyv4iY=gw86UDLqpiCtathGXRUuxOMuU=unwxzA-cm=0x+Sg@mail.gmail.com>
 <20200206074142.GB28365@infradead.org> <CAPcyv4iTBTOuKjQX3eoojLM=Eai_pfARXmzpMAtgi5OWBHXvzQ@mail.gmail.com>
 <20200207170150.GC11998@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200207170150.GC11998@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, Feb 7, 2020 at 9:02 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Fri, Feb 07, 2020 at 08:57:39AM -0800, Dan Williams wrote:
> > On Wed, Feb 5, 2020 at 11:41 PM Christoph Hellwig <hch@infradead.org> wrote:
> > >
> > > On Wed, Feb 05, 2020 at 04:40:44PM -0800, Dan Williams wrote:
> > > > > I don't have any reason not to pass phys_addr_t. If that sounds better,
> > > > > will make changes.
> > > >
> > > > The problem is device-mapper. That wants to use offset to route
> > > > through the map to the leaf device. If it weren't for the firmware
> > > > communication requirement you could do:
> > > >
> > > > dax_direct_access(...)
> > > > generic_dax_zero_page_range(...)
> > > >
> > > > ...but as long as the firmware error clearing path is required I think
> > > > we need to do pass the pgoff through the interface and do the pgoff to
> > > > virt / phys translation inside the ops handler.
> > >
> > > Maybe phys_addr_t was the wrong type - but why do we split the offset
> > > into the block device argument into a pgoff and offset into page instead
> > > of a single 64-bit value?
> >
> > Oh, got it yes, that looks odd for sub-page zeroing. Yes, let's just
> > have one device relative byte-offset.
>
> So what's the best type to represent this offset. "u64" or "phys_addr_t"
> or "loff_t" or something else.  I like phys_addr_t followed by u64.

Let's make it u64.

phys_addr_t has already led to confusion in this thread because the
first question I ask when I read it is "why call ->direct_access() to
do the translation when you already have the physical address?".
