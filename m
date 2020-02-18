From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH v4 2/7] pmem: Enable pmem_do_write() to deal
 with arbitrary ranges
Date: Tue, 18 Feb 2020 09:09:28 -0800
Message-ID: <20200218170928.GB30766@infradead.org>
References: <20200217181653.4706-1-vgoyal@redhat.com>
 <20200217181653.4706-3-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200217181653.4706-3-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, hch@infradead.org, dan.j.williams@intel.com, vishal.l.verma@intel.com, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Feb 17, 2020 at 01:16:48PM -0500, Vivek Goyal wrote:
> Currently pmem_do_write() is written with assumption that all I/O is
> sector aligned. Soon I want to use this function in zero_page_range()
> where range passed in does not have to be sector aligned.
> 
> Modify this function to be able to deal with an arbitrary range. Which
> is specified by pmem_off and len.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  drivers/nvdimm/pmem.c | 32 +++++++++++++++++++++++---------
>  1 file changed, 23 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index 075b11682192..fae8f67da9de 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -154,15 +154,23 @@ static blk_status_t pmem_do_read(struct pmem_device *pmem,
>  
>  static blk_status_t pmem_do_write(struct pmem_device *pmem,
>  			struct page *page, unsigned int page_off,
> -			sector_t sector, unsigned int len)
> +			u64 pmem_off, unsigned int len)
>  {
>  	blk_status_t rc = BLK_STS_OK;
>  	bool bad_pmem = false;
> -	phys_addr_t pmem_off = sector * 512 + pmem->data_offset;
> -	void *pmem_addr = pmem->virt_addr + pmem_off;
> -
> -	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
> -		bad_pmem = true;
> +	phys_addr_t pmem_real_off = pmem_off + pmem->data_offset;
> +	void *pmem_addr = pmem->virt_addr + pmem_real_off;
> +	sector_t sector_start, sector_end;
> +	unsigned nr_sectors;
> +
> +	sector_start = DIV_ROUND_UP(pmem_off, SECTOR_SIZE);
> +	sector_end = (pmem_off + len) >> SECTOR_SHIFT;
> +	if (sector_end > sector_start) {
> +		nr_sectors = sector_end - sector_start;
> +		if (is_bad_pmem(&pmem->bb, sector_start,
> +				nr_sectors << SECTOR_SHIFT))
> +			bad_pmem = true;
> +	}
>  
>  	/*
>  	 * Note that we write the data both before and after
> @@ -181,7 +189,13 @@ static blk_status_t pmem_do_write(struct pmem_device *pmem,
>  	flush_dcache_page(page);
>  	write_pmem(pmem_addr, page, page_off, len);
>  	if (unlikely(bad_pmem)) {
> -		rc = pmem_clear_poison(pmem, pmem_off, len);
> +		/*
> +		 * Pass sector aligned offset and length. That seems
> +		 * to work as of now. Other finer grained alignment
> +		 * cases can be addressed later if need be.
> +		 */
> +		rc = pmem_clear_poison(pmem, ALIGN(pmem_real_off, SECTOR_SIZE),
> +				       nr_sectors << SECTOR_SHIFT);
>  		write_pmem(pmem_addr, page, page_off, len);

I'm still scared about the as of now commnet.  If the interface to
clearing poison is page aligned I think we should document that in the
actual pmem_clear_poison function, and make that take the unaligned
offset.  I also think we want some feedback from Dan or other what the
official interface is instead of "seems to work".
