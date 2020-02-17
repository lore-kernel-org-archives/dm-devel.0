From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 2/7] pmem: Enable pmem_do_write() to deal with
 arbitrary ranges
Date: Mon, 17 Feb 2020 09:59:33 -0500
Message-ID: <20200217145933.GA24816@redhat.com>
References: <20200207202652.1439-1-vgoyal@redhat.com>
 <20200207202652.1439-3-vgoyal@redhat.com>
 <20200217132309.GC14490@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200217132309.GC14490@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, dm-devel@redhat.com, vishal.l.verma@intel.com
List-Id: dm-devel.ids

On Mon, Feb 17, 2020 at 05:23:09AM -0800, Christoph Hellwig wrote:
> On Fri, Feb 07, 2020 at 03:26:47PM -0500, Vivek Goyal wrote:
> > Currently pmem_do_write() is written with assumption that all I/O is
> > sector aligned. Soon I want to use this function in zero_page_range()
> > where range passed in does not have to be sector aligned.
> > 
> > Modify this function to be able to deal with an arbitrary range. Which
> > is specified by pmem_off and len.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  drivers/nvdimm/pmem.c | 30 ++++++++++++++++++++++--------
> >  1 file changed, 22 insertions(+), 8 deletions(-)
> > 
> > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> > index 9ad07cb8c9fc..281fe04d25fd 100644
> > --- a/drivers/nvdimm/pmem.c
> > +++ b/drivers/nvdimm/pmem.c
> > @@ -154,15 +154,23 @@ static blk_status_t pmem_do_read(struct pmem_device *pmem,
> >  
> >  static blk_status_t pmem_do_write(struct pmem_device *pmem,
> >  			struct page *page, unsigned int page_off,
> > -			sector_t sector, unsigned int len)
> > +			u64 pmem_off, unsigned int len)
> >  {
> >  	blk_status_t rc = BLK_STS_OK;
> >  	bool bad_pmem = false;
> > -	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
> > -	void *pmem_addr = pmem->virt_addr + pmem_off;
> > -
> > -	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
> > -		bad_pmem = true;
> > +	phys_addr_t pmem_real_off = pmem_off + pmem->data_offset;
> > +	void *pmem_addr = pmem->virt_addr + pmem_real_off;
> > +	sector_t sector_start, sector_end;
> > +	unsigned nr_sectors;
> > +
> > +	sector_start = DIV_ROUND_UP(pmem_off, SECTOR_SIZE);
> > +	sector_end = (pmem_off + len) >> SECTOR_SHIFT;
> > +	if (sector_end > sector_start) {
> > +		nr_sectors = sector_end - sector_start;
> > +		if (unlikely(is_bad_pmem(&pmem->bb, sector_start,
> > +					 nr_sectors << SECTOR_SHIFT)))
> > +			bad_pmem = true;
> 
> I don't think an unlikely annotation makes much sense for assigning
> a boolean value to a flag variable.

Ok, will get rid if this unlikely() instance.

> 
> > +		/*
> > +		 * Pass sector aligned offset and length. That seems
> > +		 * to work as of now. Other finer grained alignment
> > +		 * cases can be addressed later if need be.
> > +		 */
> 
> This comment seems pretty scary.  What other cases can you think of?

Currently firmware seems to have restrictions on alignment of size and
offset of poisoned memory being cleared.

drivers/nvdimm/bus.c

nvdimm_clear_poison()
{
...
	clear_err_unit = ars_cap.clear_err_unit;
	        mask = clear_err_unit - 1;
        if ((phys | len) & mask)
                return -ENXIO;
...
}

On the system I was testing clear_err_unit is 256. If I pass in offset
and len values which are not aligned to 256, I get errors.

So if a caller passes in a random offset and range, I clear poison
only on the part of the range which is aligned to 1 << SECTOR_SHIFT. Any
portion of the range left in the beginning or at the end, does not clear
poison.

Current code also clears poison on secotr boundaries only. One can go
the extra mile and query "clear_err_unit" and if it is less than
SECTOR_SIZE, then possibly clear the poison on range of memory which
is not sector aligned but clear_err_unit aligned.

But this retains existing functionality and is not a regression w.r.t
we are already doing. Querying "clear_err_unit" acting accordingly is
an improvement if one needs it.

Hence, I don't think this is something to be concerned about.

Thanks
Vivek
