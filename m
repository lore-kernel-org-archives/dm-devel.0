From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] dax: Define a helper dax_pgoff() which takes in
 dax_offset as argument
Date: Mon, 17 Feb 2020 05:30:43 -0800
Message-ID: <20200217133043.GA20444@infradead.org>
References: <20200212170733.8092-1-vgoyal@redhat.com>
 <20200212170733.8092-2-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200212170733.8092-2-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, hch@infradead.org, dm-devel@redhat.com, jack@suse.cz
List-Id: dm-devel.ids

On Wed, Feb 12, 2020 at 12:07:28PM -0500, Vivek Goyal wrote:
> Create a new helper dax_pgoff() which will replace bdev_dax_pgoff(). Difference
> between two is that dax_pgoff() takes in "sector_t dax_offset" as an argument
> instead of "struct block_device".
> 
> dax_offset specifies any offset into dax device which should be added to
> sector while calculating pgoff.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  drivers/dax/super.c | 12 ++++++++++++
>  include/linux/dax.h |  1 +
>  2 files changed, 13 insertions(+)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 0aa4b6bc5101..e9daa30e4250 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -56,6 +56,18 @@ int bdev_dax_pgoff(struct block_device *bdev, sector_t sector, size_t size,
>  }
>  EXPORT_SYMBOL(bdev_dax_pgoff);
>  
> +int dax_pgoff(sector_t dax_offset, sector_t sector, size_t size, pgoff_t *pgoff)

Please add a kerneldoc document.  I can't really make sense of what
dax_offset and sector mean here and why they are passed separately.

> +{
> +	phys_addr_t phys_off = (dax_offset + sector) * 512;

							<< SECTOR_SHIFT;

> +
> +	if (pgoff)
> +		*pgoff = PHYS_PFN(phys_off);

What is the use case of not passing a pgoff argument?

> +	if (phys_off % PAGE_SIZE || size % PAGE_SIZE)
> +		return -EINVAL;
> +	return 0;
> +}
> +EXPORT_SYMBOL(dax_pgoff);

EXPORT_SYMBOL_GPL, please.
