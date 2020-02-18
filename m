From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH v4 2/7] pmem: Enable pmem_do_write() to deal
 with arbitrary ranges
Date: Tue, 18 Feb 2020 16:10:08 -0500
Message-ID: <20200218211008.GB19413@redhat.com>
References: <20200217181653.4706-1-vgoyal@redhat.com>
 <20200217181653.4706-3-vgoyal@redhat.com>
 <20200218170928.GB30766@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200218170928.GB30766@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, vishal.l.verma@intel.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Tue, Feb 18, 2020 at 09:09:28AM -0800, Christoph Hellwig wrote:
> On Mon, Feb 17, 2020 at 01:16:48PM -0500, Vivek Goyal wrote:
> > Currently pmem_do_write() is written with assumption that all I/O is
> > sector aligned. Soon I want to use this function in zero_page_range()
> > where range passed in does not have to be sector aligned.
> > 
> > Modify this function to be able to deal with an arbitrary range. Which
> > is specified by pmem_off and len.
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  drivers/nvdimm/pmem.c | 32 +++++++++++++++++++++++---------
> >  1 file changed, 23 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> > index 075b11682192..fae8f67da9de 100644
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
> > +		if (is_bad_pmem(&pmem->bb, sector_start,
> > +				nr_sectors << SECTOR_SHIFT))
> > +			bad_pmem = true;
> > +	}
> >  
> >  	/*
> >  	 * Note that we write the data both before and after
> > @@ -181,7 +189,13 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
> >  	flush_dcache_page(page);
> >  	write_pmem(pmem_addr, page, page_off, len);
> >  	if (unlikely(bad_pmem)) {
> > -		rc = pmem_clear_poison(pmem, pmem_off, len);
> > +		/*
> > +		 * Pass sector aligned offset and length. That seems
> > +		 * to work as of now. Other finer grained alignment
> > +		 * cases can be addressed later if need be.
> > +		 */
> > +		rc = pmem_clear_poison(pmem, ALIGN(pmem_real_off, SECTOR_SIZE),
> > +				       nr_sectors << SECTOR_SHIFT);
> >  		write_pmem(pmem_addr, page, page_off, len);
> 
> I'm still scared about the as of now commnet.  If the interface to
> clearing poison is page aligned I think we should document that in the
> actual pmem_clear_poison function, and make that take the unaligned
> offset.  I also think we want some feedback from Dan or other what the
> official interface is instead of "seems to work".

Ok, I am adding one more patch to series and enabling pmem_clear_poison()
to accept arbitrary offset and length and let it align offset and length
to sector boundary. Keeping it in a separate patch so that Dan can have
a close look at it and make sure I am doing things correctly.

Here is the new patch. I will post the V5 soon with this new patch.

Thanks
Vivek


Subject: drivers/pmem: Allow pmem_clear_poison() to accept arbitrary offset and len

Currently pmem_clear_poison() expects offset and len to be sector aligned.
Atleast that seems to be the assumption with which code has been written.
It is called only from pmem_do_bvec() which is called only from pmem_rw_page()
and pmem_make_request() which will only passe sector aligned offset and len.

Soon we want use this function from dax_zero_page_range() code path which
can try to zero arbitrary range of memory with-in a page. So update this
function to assume that offset and length can be arbitrary and do the
necessary alignments as needed.

nvdimm_clear_poison() seems to assume offset and len to be aligned to
clear_err_unit boundary. But this is currently internal detail and is
not exported for others to use. So for now, continue to align offset and
length to SECTOR_SIZE boundary. Improving it further and to align it
to clear_err_unit boundary is a TODO item for future.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/nvdimm/pmem.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 075b11682192..e72959203253 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -74,14 +74,28 @@ static blk_status_t pmem_clear_poison(struct pmem_device *pmem,
 	sector_t sector;
 	long cleared;
 	blk_status_t rc = BLK_STS_OK;
+	phys_addr_t start_aligned, end_aligned;
+	unsigned int len_aligned;
 
-	sector = (offset - pmem->data_offset) / 512;
+	/*
+	 * Callers can pass arbitrary offset and len. But nvdimm_clear_poison()
+	 * expects memory offset and length to meet certain alignment
+	 * restrction (clear_err_unit). Currently nvdimm does not export
+	 * required alignment. So align offset and length to sector boundary
+	 * before passing it to nvdimm_clear_poison().
+	 */
+	start_aligned = ALIGN(offset, SECTOR_SIZE);
+	end_aligned = ALIGN_DOWN((offset + len), SECTOR_SIZE) - 1;
+	len_aligned = end_aligned - start_aligned + 1;
+
+	sector = (start_aligned - pmem->data_offset) / 512;
 
-	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + offset, len);
-	if (cleared < len)
+	cleared = nvdimm_clear_poison(dev, pmem->phys_addr + start_aligned,
+				      len_aligned);
+	if (cleared < len_aligned)
 		rc = BLK_STS_IOERR;
 	if (cleared > 0 && cleared / 512) {
-		hwpoison_clear(pmem, pmem->phys_addr + offset, cleared);
+		hwpoison_clear(pmem, pmem->phys_addr + start_aligned, cleared);
 		cleared /= 512;
 		dev_dbg(dev, "%#llx clear %ld sector%s\n",
 				(unsigned long long) sector, cleared,
-- 
2.20.1
