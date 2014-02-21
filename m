From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH for-dm-3.14-fixes 8/8] dm thin: allow
 metadata space larger than supported to go unused
Date: Fri, 21 Feb 2014 14:36:12 +0000
Message-ID: <20140221143611.GG13298@debian>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
	<1392951365-9829-9-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1392951365-9829-9-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

ACK

On Thu, Feb 20, 2014 at 09:56:05PM -0500, Mike Snitzer wrote:
> It was always intended that a user could provide a thin metadata device
> that is larger than the max supported by the on-disk format.  The extra
> space would just go unused.
> 
> That would only work when extending the metadata device, not on initial
> thin-pool creation.  If the user attempted to use a larger metadata
> device on creation they would get an error like the following:
> 
>  device-mapper: space map common: space map too large
>  device-mapper: transaction manager: couldn't create metadata space map
>  device-mapper: thin metadata: tm_create_with_sm failed
>  device-mapper: table: 252:17: thin-pool: Error creating metadata object
>  device-mapper: ioctl: error adding target to table
> 
> Fix this by allowing the initial thin-pool creation to cap the size of
> the metadata area to be smaller than the size of the metadata device.
> 
> Also, the calculation for THIN_METADATA_MAX_SECTORS didn't account for
> the sizeof the disk_bitmap_header.  So the supported maximum metadata
> size is a bit smaller (reduced from 33423360 to 33292800 sectors).
> 
> Lastly, remove the "excess space will not be used" warning message from
> get_metadata_dev_size(); it resulted in printing the warning multiple
> times.  Factor out warn_if_metadata_device_too_big(), call it from
> pool_ctr() and maybe_resize_metadata_dev().
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm-cache-metadata.c                     |  2 +-
>  drivers/md/dm-thin-metadata.c                      | 21 +++++++------
>  drivers/md/dm-thin-metadata.h                      |  5 ++--
>  drivers/md/dm-thin.c                               | 35 ++++++++++++++--------
>  .../md/persistent-data/dm-transaction-manager.c    | 13 ++++----
>  .../md/persistent-data/dm-transaction-manager.h    |  2 +-
>  6 files changed, 47 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
> index 9ef0752..1baf615 100644
> --- a/drivers/md/dm-cache-metadata.c
> +++ b/drivers/md/dm-cache-metadata.c
> @@ -323,7 +323,7 @@ static int __format_metadata(struct dm_cache_metadata *cmd)
>  {
>  	int r;
>  
> -	r = dm_tm_create_with_sm(cmd->bm, CACHE_SUPERBLOCK_LOCATION,
> +	r = dm_tm_create_with_sm(cmd->bm, CACHE_SUPERBLOCK_LOCATION, 0,
>  				 &cmd->tm, &cmd->metadata_sm);
>  	if (r < 0) {
>  		DMERR("tm_create_with_sm failed");
> diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> index 7c2bc26..3780650 100644
> --- a/drivers/md/dm-thin-metadata.c
> +++ b/drivers/md/dm-thin-metadata.c
> @@ -503,11 +503,11 @@ bad_locked:
>  	return r;
>  }
>  
> -static int __format_metadata(struct dm_pool_metadata *pmd)
> +static int __format_metadata(struct dm_pool_metadata *pmd, dm_block_t nr_blocks)
>  {
>  	int r;
>  
> -	r = dm_tm_create_with_sm(pmd->bm, THIN_SUPERBLOCK_LOCATION,
> +	r = dm_tm_create_with_sm(pmd->bm, THIN_SUPERBLOCK_LOCATION, nr_blocks,
>  				 &pmd->tm, &pmd->metadata_sm);
>  	if (r < 0) {
>  		DMERR("tm_create_with_sm failed");
> @@ -642,7 +642,8 @@ bad_unlock_sblock:
>  	return r;
>  }
>  
> -static int __open_or_format_metadata(struct dm_pool_metadata *pmd, bool format_device)
> +static int __open_or_format_metadata(struct dm_pool_metadata *pmd, bool format_device,
> +				     dm_block_t nr_blocks)
>  {
>  	int r, unformatted;
>  
> @@ -651,12 +652,13 @@ static int __open_or_format_metadata(struct dm_pool_metadata *pmd, bool format_d
>  		return r;
>  
>  	if (unformatted)
> -		return format_device ? __format_metadata(pmd) : -EPERM;
> +		return format_device ? __format_metadata(pmd, nr_blocks) : -EPERM;
>  
>  	return __open_metadata(pmd);
>  }
>  
> -static int __create_persistent_data_objects(struct dm_pool_metadata *pmd, bool format_device)
> +static int __create_persistent_data_objects(struct dm_pool_metadata *pmd, bool format_device,
> +					    dm_block_t nr_blocks)
>  {
>  	int r;
>  
> @@ -668,7 +670,7 @@ static int __create_persistent_data_objects(struct dm_pool_metadata *pmd, bool f
>  		return PTR_ERR(pmd->bm);
>  	}
>  
> -	r = __open_or_format_metadata(pmd, format_device);
> +	r = __open_or_format_metadata(pmd, format_device, nr_blocks);
>  	if (r)
>  		dm_block_manager_destroy(pmd->bm);
>  
> @@ -808,7 +810,8 @@ out_locked:
>  
>  struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
>  					       sector_t data_block_size,
> -					       bool format_device)
> +					       bool format_device,
> +					       dm_block_t nr_blocks)
>  {
>  	int r;
>  	struct dm_pool_metadata *pmd;
> @@ -828,7 +831,7 @@ struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
>  	pmd->bdev = bdev;
>  	pmd->data_block_size = data_block_size;
>  
> -	r = __create_persistent_data_objects(pmd, format_device);
> +	r = __create_persistent_data_objects(pmd, format_device, nr_blocks);
>  	if (r) {
>  		kfree(pmd);
>  		return ERR_PTR(r);
> @@ -1578,7 +1581,7 @@ int dm_pool_abort_metadata(struct dm_pool_metadata *pmd)
>  
>  	__set_abort_with_changes_flags(pmd);
>  	__destroy_persistent_data_objects(pmd);
> -	r = __create_persistent_data_objects(pmd, false);
> +	r = __create_persistent_data_objects(pmd, false, 0);
>  	if (r)
>  		pmd->fail_io = true;
>  
> diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
> index 583ff5d..e24169c 100644
> --- a/drivers/md/dm-thin-metadata.h
> +++ b/drivers/md/dm-thin-metadata.h
> @@ -18,7 +18,7 @@
>   * We have one block of index, which can hold 255 index entries.  Each
>   * index entry contains allocation info about 16k metadata blocks.
>   */
> -#define THIN_METADATA_MAX_SECTORS (255 * (1 << 14) * (THIN_METADATA_BLOCK_SIZE / (1 << SECTOR_SHIFT)))
> +#define THIN_METADATA_MAX_SECTORS (255 * ((1 << 14) - 64) * (THIN_METADATA_BLOCK_SIZE / (1 << SECTOR_SHIFT)))
>  
>  /*
>   * A metadata device larger than 16GB triggers a warning.
> @@ -45,7 +45,8 @@ typedef uint64_t dm_thin_id;
>   */
>  struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
>  					       sector_t data_block_size,
> -					       bool format_device);
> +					       bool format_device,
> +					       dm_block_t nr_blocks);
>  
>  int dm_pool_metadata_close(struct dm_pool_metadata *pmd);
>  
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index cd52cf2..c4cee29 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -1829,6 +1829,8 @@ static void __pool_destroy(struct pool *pool)
>  
>  static struct kmem_cache *_new_mapping_cache;
>  
> +static dm_block_t get_metadata_dev_size_in_blocks(struct block_device *);
> +
>  static struct pool *pool_create(struct mapped_device *pool_md,
>  				struct block_device *metadata_dev,
>  				unsigned long block_size,
> @@ -1839,8 +1841,10 @@ static struct pool *pool_create(struct mapped_device *pool_md,
>  	struct pool *pool;
>  	struct dm_pool_metadata *pmd;
>  	bool format_device = read_only ? false : true;
> +	dm_block_t nr_blocks = get_metadata_dev_size_in_blocks(metadata_dev);
>  
> -	pmd = dm_pool_metadata_open(metadata_dev, block_size, format_device);
> +	pmd = dm_pool_metadata_open(metadata_dev, block_size, format_device,
> +				    nr_blocks);
>  	if (IS_ERR(pmd)) {
>  		*error = "Error creating metadata object";
>  		return (struct pool *)pmd;
> @@ -2078,16 +2082,27 @@ static void metadata_low_callback(void *context)
>  	dm_table_event(pool->ti->table);
>  }
>  
> -static sector_t get_metadata_dev_size(struct block_device *bdev)
> +static sector_t get_dev_size(struct block_device *bdev)
>  {
> -	sector_t metadata_dev_size = i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
> +	return i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
> +}
> +
> +static void warn_if_metadata_device_too_big(struct block_device *bdev)
> +{
> +	sector_t metadata_dev_size = get_dev_size(bdev);
>  	char buffer[BDEVNAME_SIZE];
>  
> -	if (metadata_dev_size > THIN_METADATA_MAX_SECTORS_WARNING) {
> +	if (metadata_dev_size > THIN_METADATA_MAX_SECTORS_WARNING)
>  		DMWARN("Metadata device %s is larger than %u sectors: excess space will not be used.",
>  		       bdevname(bdev, buffer), THIN_METADATA_MAX_SECTORS);
> -		metadata_dev_size = THIN_METADATA_MAX_SECTORS_WARNING;
> -	}
> +}
> +
> +static sector_t get_metadata_dev_size(struct block_device *bdev)
> +{
> +	sector_t metadata_dev_size = get_dev_size(bdev);
> +
> +	if (metadata_dev_size > THIN_METADATA_MAX_SECTORS)
> +		metadata_dev_size = THIN_METADATA_MAX_SECTORS;
>  
>  	return metadata_dev_size;
>  }
> @@ -2174,12 +2189,7 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  		ti->error = "Error opening metadata block device";
>  		goto out_unlock;
>  	}
> -
> -	/*
> -	 * Run for the side-effect of possibly issuing a warning if the
> -	 * device is too big.
> -	 */
> -	(void) get_metadata_dev_size(metadata_dev->bdev);
> +	warn_if_metadata_device_too_big(metadata_dev->bdev);
>  
>  	r = dm_get_device(ti, argv[1], FMODE_READ | FMODE_WRITE, &data_dev);
>  	if (r) {
> @@ -2378,6 +2388,7 @@ static int maybe_resize_metadata_dev(struct dm_target *ti, bool *need_commit)
>  			return -EINVAL;;
>  		}
>  
> +		warn_if_metadata_device_too_big(pool->md_dev);
>  		DMINFO("%s: growing the metadata device from %llu to %llu blocks",
>  		       dm_device_name(pool->pool_md),
>  		       sb_metadata_dev_size, metadata_dev_size);
> diff --git a/drivers/md/persistent-data/dm-transaction-manager.c b/drivers/md/persistent-data/dm-transaction-manager.c
> index 81da1a2..495277e 100644
> --- a/drivers/md/persistent-data/dm-transaction-manager.c
> +++ b/drivers/md/persistent-data/dm-transaction-manager.c
> @@ -322,7 +322,7 @@ static int dm_tm_create_internal(struct dm_block_manager *bm,
>  				 dm_block_t sb_location,
>  				 struct dm_transaction_manager **tm,
>  				 struct dm_space_map **sm,
> -				 int create,
> +				 int create, dm_block_t nr_blocks,
>  				 void *sm_root, size_t sm_len)
>  {
>  	int r;
> @@ -338,8 +338,9 @@ static int dm_tm_create_internal(struct dm_block_manager *bm,
>  	}
>  
>  	if (create) {
> -		r = dm_sm_metadata_create(*sm, *tm, dm_bm_nr_blocks(bm),
> -					  sb_location);
> +		if (!nr_blocks)
> +			nr_blocks = dm_bm_nr_blocks(bm);
> +		r = dm_sm_metadata_create(*sm, *tm, nr_blocks, sb_location);
>  		if (r) {
>  			DMERR("couldn't create metadata space map");
>  			goto bad;
> @@ -362,10 +363,10 @@ bad:
>  }
>  
>  int dm_tm_create_with_sm(struct dm_block_manager *bm, dm_block_t sb_location,
> -			 struct dm_transaction_manager **tm,
> +			 dm_block_t nr_blocks, struct dm_transaction_manager **tm,
>  			 struct dm_space_map **sm)
>  {
> -	return dm_tm_create_internal(bm, sb_location, tm, sm, 1, NULL, 0);
> +	return dm_tm_create_internal(bm, sb_location, tm, sm, 1, nr_blocks, NULL, 0);
>  }
>  EXPORT_SYMBOL_GPL(dm_tm_create_with_sm);
>  
> @@ -374,7 +375,7 @@ int dm_tm_open_with_sm(struct dm_block_manager *bm, dm_block_t sb_location,
>  		       struct dm_transaction_manager **tm,
>  		       struct dm_space_map **sm)
>  {
> -	return dm_tm_create_internal(bm, sb_location, tm, sm, 0, sm_root, root_len);
> +	return dm_tm_create_internal(bm, sb_location, tm, sm, 0, 0, sm_root, root_len);
>  }
>  EXPORT_SYMBOL_GPL(dm_tm_open_with_sm);
>  
> diff --git a/drivers/md/persistent-data/dm-transaction-manager.h b/drivers/md/persistent-data/dm-transaction-manager.h
> index b5b1390..a8403f0 100644
> --- a/drivers/md/persistent-data/dm-transaction-manager.h
> +++ b/drivers/md/persistent-data/dm-transaction-manager.h
> @@ -120,7 +120,7 @@ struct dm_block_manager *dm_tm_get_bm(struct dm_transaction_manager *tm);
>   * shouldn't be used.
>   */
>  int dm_tm_create_with_sm(struct dm_block_manager *bm, dm_block_t sb_location,
> -			 struct dm_transaction_manager **tm,
> +			 dm_block_t nr_blocks, struct dm_transaction_manager **tm,
>  			 struct dm_space_map **sm);
>  
>  int dm_tm_open_with_sm(struct dm_block_manager *bm, dm_block_t sb_location,
> -- 
> 1.8.3.1
> 
