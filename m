From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/5] dax, pmem: Add a dax operation zero_page_range
Date: Wed, 5 Feb 2020 15:02:59 -0500
Message-ID: <20200205200259.GE14544@redhat.com>
References: <20200203200029.4592-1-vgoyal@redhat.com>
 <20200203200029.4592-2-vgoyal@redhat.com>
 <20200205183050.GA26711@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200205183050.GA26711@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Feb 05, 2020 at 10:30:50AM -0800, Christoph Hellwig wrote:
> > +	/*
> > +	 * There are no users as of now. Once users are there, fix dm code
> > +	 * to be able to split a long range across targets.
> > +	 */
> 
> This comment confused me.  I think this wants to say something like:
> 
> 	/*
> 	 * There are now callers that want to zero across a page boundary as of
> 	 * now.  Once there are users this check can be removed after the
> 	 * device mapper code has been updated to split ranges across targets.
> 	 */

Yes, that's what I wanted to say but I missed one line. Thanks. Will fix
it.

> 
> > +static int pmem_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
> > +				    unsigned int offset, size_t len)
> > +{
> > +	int rc = 0;
> > +	phys_addr_t phys_pos = pgoff * PAGE_SIZE + offset;
> 
> Any reason not to pass a phys_addr_t in the calling convention for the
> method and maybe also for dax_zero_page_range itself?

I don't have any reason not to pass phys_addr_t. If that sounds better,
will make changes.

> 
> > +	sector_start = ALIGN(phys_pos, 512)/512;
> > +	sector_end = ALIGN_DOWN(phys_pos + bytes, 512)/512;
> 
> Missing whitespaces.  Also this could use DIV_ROUND_UP and
> DIV_ROUND_DOWN.

Will do.


> 
> > +	if (sector_end > sector_start)
> > +		nr_sectors = sector_end - sector_start;
> > +
> > +	if (nr_sectors &&
> > +	    unlikely(is_bad_pmem(&pmem->bb, sector_start,
> > +				 nr_sectors * 512)))
> > +		bad_pmem = true;
> 
> How could nr_sectors be zero?

If somebody specified a range across two sectors but none of the sector is
completely written. Then nr_sectors will be zero. In fact this check
shoudl probably be nr_sectors > 0 as writes with-in a sector will lead
to nr_sector being -1.

Am I missing something.

> 
> > +	write_pmem(pmem_addr, page, 0, bytes);
> > +	if (unlikely(bad_pmem)) {
> > +		/*
> > +		 * Pass block aligned offset and length. That seems
> > +		 * to work as of now. Other finer grained alignment
> > +		 * cases can be addressed later if need be.
> > +		 */
> > +		rc = pmem_clear_poison(pmem, ALIGN(pmem_off, 512),
> > +				       nr_sectors * 512);
> > +		write_pmem(pmem_addr, page, 0, bytes);
> > +	}
> 
> This code largerly duplicates the write side of pmem_do_bvec.  I
> think it might make sense to split pmem_do_bvec into a read and a write
> side as a prep patch, and then reuse the write side here.

Ok, I will look into it. How about just add a helper function for write
side and use that function both here and in pmem_do_bvec().

> 
> > +int generic_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
> > +				 unsigned int offset, size_t len);
> 
> This should probably go into a separare are of the header and have
> comment about being a section for generic helpers for drivers.

ok, will do.

Thanks
Vivek
