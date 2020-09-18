From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [dm-devel] [PATCH v2] dm: Call proper helper to determine dax
 support
Date: Fri, 18 Sep 2020 08:30:41 -0700
Message-ID: <20200918153041.GN7954@magnolia>
References: <160040692945.25320.13233625491405115889.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <160040692945.25320.13233625491405115889.stgit@dwillia2-desk3.amr.corp.intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Jan Kara <jack@suse.cz>, snitzer@redhat.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, dm-devel@redhat.com, Adrian Huang <ahuang12@lenovo.com>, mpatocka@redhat.com, ira.weiny@intel.com
List-Id: dm-devel.ids

On Thu, Sep 17, 2020 at 10:30:03PM -0700, Dan Williams wrote:
> From: Jan Kara <jack@suse.cz>
> 
> DM was calling generic_fsdax_supported() to determine whether a device
> referenced in the DM table supports DAX. However this is a helper for "leaf" device drivers so that
> they don't have to duplicate common generic checks. High level code
> should call dax_supported() helper which that calls into appropriate
> helper for the particular device. This problem manifested itself as
> kernel messages:
> 
> dm-3: error: dax access failed (-95)
> 
> when lvm2-testsuite run in cases where a DM device was stacked on top of
> another DM device.

Is there somewhere where it is documented which of:

bdev_dax_supported, generic_fsdax_supported, and dax_supported

one is supposed to use for a given circumstance?

I guess the last two can test a given range w/ blocksize; the first one
only does blocksize; and the middle one also checks with whatever fs
might be mounted? <shrug>

(I ask because it took me a while to figure out how to revert correctly
the brokenness in rc3-5 that broke my nightly dax fstesting.)

--D

> 
> Fixes: 7bf7eac8d648 ("dax: Arrange for dax_supported check to span multiple devices")
> Cc: <stable@vger.kernel.org>
> Tested-by: Adrian Huang <ahuang12@lenovo.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> Acked-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Changes since v1 [1]:
> - Add missing dax_read_lock() around dax_supported()
> 
> [1]: http://lore.kernel.org/r/20200916151445.450-1-jack@suse.cz
> 
>  drivers/dax/super.c   |    4 ++++
>  drivers/md/dm-table.c |   10 +++++++---
>  include/linux/dax.h   |   11 +++++++++--
>  3 files changed, 20 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index e5767c83ea23..b6284c5cae0a 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -325,11 +325,15 @@ EXPORT_SYMBOL_GPL(dax_direct_access);
>  bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
>  		int blocksize, sector_t start, sector_t len)
>  {
> +	if (!dax_dev)
> +		return false;
> +
>  	if (!dax_alive(dax_dev))
>  		return false;
>  
>  	return dax_dev->ops->dax_supported(dax_dev, bdev, blocksize, start, len);
>  }
> +EXPORT_SYMBOL_GPL(dax_supported);
>  
>  size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>  		size_t bytes, struct iov_iter *i)
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 5edc3079e7c1..229f461e7def 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -860,10 +860,14 @@ EXPORT_SYMBOL_GPL(dm_table_set_type);
>  int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
>  			sector_t start, sector_t len, void *data)
>  {
> -	int blocksize = *(int *) data;
> +	int blocksize = *(int *) data, id;
> +	bool rc;
>  
> -	return generic_fsdax_supported(dev->dax_dev, dev->bdev, blocksize,
> -				       start, len);
> +	id = dax_read_lock();
> +	rc = dax_supported(dev->dax_dev, dev->bdev, blocksize, start, len);
> +	dax_read_unlock(id);
> +
> +	return rc;
>  }
>  
>  /* Check devices support synchronous DAX */
> diff --git a/include/linux/dax.h b/include/linux/dax.h
> index 6904d4e0b2e0..9f916326814a 100644
> --- a/include/linux/dax.h
> +++ b/include/linux/dax.h
> @@ -130,6 +130,8 @@ static inline bool generic_fsdax_supported(struct dax_device *dax_dev,
>  	return __generic_fsdax_supported(dax_dev, bdev, blocksize, start,
>  			sectors);
>  }
> +bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
> +		int blocksize, sector_t start, sector_t len);
>  
>  static inline void fs_put_dax(struct dax_device *dax_dev)
>  {
> @@ -157,6 +159,13 @@ static inline bool generic_fsdax_supported(struct dax_device *dax_dev,
>  	return false;
>  }
>  
> +static inline bool dax_supported(struct dax_device *dax_dev,
> +		struct block_device *bdev, int blocksize, sector_t start,
> +		sector_t len)
> +{
> +	return false;
> +}
> +
>  static inline void fs_put_dax(struct dax_device *dax_dev)
>  {
>  }
> @@ -195,8 +204,6 @@ bool dax_alive(struct dax_device *dax_dev);
>  void *dax_get_private(struct dax_device *dax_dev);
>  long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
>  		void **kaddr, pfn_t *pfn);
> -bool dax_supported(struct dax_device *dax_dev, struct block_device *bdev,
> -		int blocksize, sector_t start, sector_t len);
>  size_t dax_copy_from_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>  		size_t bytes, struct iov_iter *i);
>  size_t dax_copy_to_iter(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
