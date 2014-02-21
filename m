From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH for-dm-3.14-fixes 7/8] dm thin: ensure user
 takes action to validate data and metadata consistency
Date: Fri, 21 Feb 2014 14:35:15 +0000
Message-ID: <20140221143515.GF13298@debian>
References: <1392951365-9829-1-git-send-email-snitzer@redhat.com>
	<1392951365-9829-8-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1392951365-9829-8-git-send-email-snitzer@redhat.com>
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

ACK.  But we need a lot of test cases for dmtest before this can go
upstream.

On Thu, Feb 20, 2014 at 09:56:04PM -0500, Mike Snitzer wrote:
> If a thin metadata operation fails the current transaction will abort,
> whereby causing potential for IO layers up the stack (e.g. filesystems)
> to have data loss.  As such, set THIN_METADATA_NEEDS_CHECK_FLAG in the
> thin metadata's superblock which forces the user to:
> 1) verify the thin metadata is consistent (e.g. use thin_check, etc)
> 2) verify the thin data is consistent (e.g. use fsck)
> 
> The only way to clear the superblock's THIN_METADATA_NEEDS_CHECK_FLAG is
> to run thin_repair.
> 
> On metadata operation failure: abort current metadata transaction, set
> pool in read-only mode, and now set the needs_check flag.
> 
> As part of this change, constraints are introduced or relaxed:
> * don't allow a pool to transition to write mode if needs_check is set
> * don't queue IO if needs_check is set
> * don't allow data or metadata space to be resized if needs_check is set
> * if a thin pool's metadata space is exhausted: the kernel will now
>   force the user to take the pool offline for repair before the kernel
>   will allow the metadata space to be extended.
> * relax response to data allocation failure due to no data space:
>   don't abort the current metadata transaction (this allows previously
>   allocated and prepared mappings to be committed).
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  Documentation/device-mapper/thin-provisioning.txt | 21 +++---
>  drivers/md/dm-thin-metadata.c                     | 20 +++++-
>  drivers/md/dm-thin-metadata.h                     |  8 +++
>  drivers/md/dm-thin.c                              | 82 +++++++++++++++++------
>  4 files changed, 102 insertions(+), 29 deletions(-)
> 
> diff --git a/Documentation/device-mapper/thin-provisioning.txt b/Documentation/device-mapper/thin-provisioning.txt
> index 3989dd6..075ca84 100644
> --- a/Documentation/device-mapper/thin-provisioning.txt
> +++ b/Documentation/device-mapper/thin-provisioning.txt
> @@ -130,14 +130,19 @@ a volatile write cache.  If power is lost you may lose some recent
>  writes.  The metadata should always be consistent in spite of any crash.
>  
>  If data space is exhausted the pool will either error or queue IO
> -according to the configuration (see: error_if_no_space).  When metadata
> -space is exhausted the pool will error IO, that requires new pool block
> -allocation, until the pool's metadata device is resized.  When either the
> -data or metadata space is exhausted the current metadata transaction
> -must be aborted.  Given that the pool will cache IO whose completion may
> -have already been acknowledged to the upper IO layers (e.g. filesystem)
> -it is strongly suggested that those layers perform consistency checks
> -before the data or metadata space is resized after having been exhausted.
> +according to the configuration (see: error_if_no_space).  If metadata
> +space is exhausted or a metadata operation fails: the pool will error IO
> +until the pool is taken offline and repair is performed to 1) fix any
> +potential inconsistencies and 2) clear the flag that imposes repair.
> +Once the pool's metadata device is repaired it may be resized, which
> +will allow the pool to return to normal operation.  Note that a pool's
> +data and metadata devices cannot be resized until repair is performed.
> +It should also be noted that when the pool's metadata space is exhausted
> +the current metadata transaction is aborted.  Given that the pool will
> +cache IO whose completion may have already been acknowledged to upper IO
> +layers (e.g. filesystem) it is strongly suggested that consistency
> +checks (e.g. fsck) be performed on those layers when repair of the pool
> +is required.
>  
>  Thin provisioning
>  -----------------
> diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
> index bea6db6..7c2bc26 100644
> --- a/drivers/md/dm-thin-metadata.c
> +++ b/drivers/md/dm-thin-metadata.c
> @@ -76,7 +76,7 @@
>  
>  #define THIN_SUPERBLOCK_MAGIC 27022010
>  #define THIN_SUPERBLOCK_LOCATION 0
> -#define THIN_VERSION 1
> +#define THIN_VERSION 2
>  #define THIN_METADATA_CACHE_SIZE 64
>  #define SECTOR_TO_BLOCK_SHIFT 3
>  
> @@ -1830,3 +1830,21 @@ int dm_pool_register_metadata_threshold(struct dm_pool_metadata *pmd,
>  
>  	return r;
>  }
> +
> +void dm_pool_metadata_set_needs_check(struct dm_pool_metadata *pmd)
> +{
> +	down_write(&pmd->root_lock);
> +	pmd->flags |= THIN_METADATA_NEEDS_CHECK_FLAG;
> +	up_write(&pmd->root_lock);
> +}
> +
> +bool dm_pool_metadata_needs_check(struct dm_pool_metadata *pmd)
> +{
> +	bool needs_check;
> +
> +	down_read(&pmd->root_lock);
> +	needs_check = pmd->flags & THIN_METADATA_NEEDS_CHECK_FLAG;
> +	up_read(&pmd->root_lock);
> +
> +	return needs_check;
> +}
> diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
> index 520dd34..583ff5d 100644
> --- a/drivers/md/dm-thin-metadata.h
> +++ b/drivers/md/dm-thin-metadata.h
> @@ -27,6 +27,11 @@
>  
>  /*----------------------------------------------------------------*/
>  
> +/*
> + * Thin metadata superblock flags.
> + */
> +#define THIN_METADATA_NEEDS_CHECK_FLAG		(1 << 0)
> +
>  struct dm_pool_metadata;
>  struct dm_thin_device;
>  
> @@ -214,6 +219,9 @@ int dm_pool_register_metadata_threshold(struct dm_pool_metadata *pmd,
>  					dm_sm_threshold_fn fn,
>  					void *context);
>  
> +void dm_pool_metadata_set_needs_check(struct dm_pool_metadata *pmd);
> +bool dm_pool_metadata_needs_check(struct dm_pool_metadata *pmd);
> +
>  /*----------------------------------------------------------------*/
>  
>  #endif
> diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
> index e560416..cd52cf2 100644
> --- a/drivers/md/dm-thin.c
> +++ b/drivers/md/dm-thin.c
> @@ -1014,6 +1014,7 @@ static bool should_error_unserviceable_bio(struct pool *pool)
>  {
>  	return (unlikely(get_pool_mode(pool) == PM_FAIL) ||
>  		pool->pf.error_if_no_space ||
> +		dm_pool_metadata_needs_check(pool->pmd) ||
>  		dm_pool_is_metadata_out_of_space(pool->pmd));
>  }
>  
> @@ -1436,8 +1437,19 @@ static enum pool_mode get_pool_mode(struct pool *pool)
>  static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
>  {
>  	int r;
> +	bool out_of_space, needs_check = dm_pool_metadata_needs_check(pool->pmd);
>  	enum pool_mode old_mode = pool->pf.mode;
>  
> +	/*
> +	 * Never allow the pool to transition to PM_WRITE mode if user
> +	 * intervention is required to verify metadata and data consistency.
> +	 */
> +	if (new_mode == PM_WRITE && old_mode != new_mode && needs_check) {
> +		DMERR("%s: unable to switch pool to write mode until repaired.",
> +		      dm_device_name(pool->pool_md));
> +		new_mode = old_mode;
> +	}
> +
>  	switch (new_mode) {
>  	case PM_FAIL:
>  		if (old_mode != new_mode)
> @@ -1454,23 +1466,35 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
>  		if (old_mode != new_mode)
>  			DMERR("%s: switching pool to read-only mode",
>  			      dm_device_name(pool->pool_md));
> -		r = dm_pool_abort_metadata(pool->pmd);
> -		if (r) {
> -			DMERR("%s: aborting transaction failed",
> -			      dm_device_name(pool->pool_md));
> -			new_mode = PM_FAIL;
> -			set_pool_mode(pool, new_mode);
> -		} else {
> -			bool out_of_space;
> -			if (!dm_pool_is_out_of_space(pool->pmd, &out_of_space) && out_of_space)
> -				dm_pool_metadata_read_write(pool->pmd);
> -			else
> -				dm_pool_metadata_read_only(pool->pmd);
> -			pool->process_bio = process_bio_read_only;
> -			pool->process_discard = process_discard;
> +		if (needs_check) {
> +			r = dm_pool_abort_metadata(pool->pmd);
> +			if (r) {
> +				DMERR("%s: aborting transaction failed",
> +				      dm_device_name(pool->pool_md));
> +				new_mode = PM_FAIL;
> +				set_pool_mode(pool, new_mode);
> +				goto out;
> +			}
> +		}
> +		if (!dm_pool_is_out_of_space(pool->pmd, &out_of_space) && out_of_space)
> +			dm_pool_metadata_read_write(pool->pmd);
> +		else
> +			dm_pool_metadata_read_only(pool->pmd);
> +		pool->process_bio = process_bio_read_only;
> +		pool->process_discard = process_discard;
> +		if (needs_check)
>  			pool->process_prepared_mapping = process_prepared_mapping_fail;
> -			pool->process_prepared_discard = process_prepared_discard_passdown;
> +		else {
> +			/*
> +			 * Allow previously prepared mappings to complete (important
> +			 * for proper handling of case when data space is exhausted).
> +			 * If read-only mode was requested no new mappings will be
> +			 * created (due to process_bio_read_only) so no risk using
> +			 * process_prepared_mapping.
> +			 */
> +			pool->process_prepared_mapping = process_prepared_mapping;
>  		}
> +		pool->process_prepared_discard = process_prepared_discard_passdown;
>  		break;
>  
>  	case PM_WRITE:
> @@ -1484,7 +1508,7 @@ static void set_pool_mode(struct pool *pool, enum pool_mode new_mode)
>  		pool->process_prepared_discard = process_prepared_discard;
>  		break;
>  	}
> -
> +out:
>  	pool->pf.mode = new_mode;
>  }
>  
> @@ -1501,15 +1525,21 @@ static void out_of_data_space(struct pool *pool)
>  
>  static void metadata_operation_failed(struct pool *pool, const char *op, int r)
>  {
> +	const char *pool_device_name = dm_device_name(pool->pool_md);
> +
>  	DMERR_LIMIT("%s: metadata operation '%s' failed: error = %d",
> -		    dm_device_name(pool->pool_md), op, r);
> +		    pool_device_name, op, r);
>  
>  	if (r == -ENOSPC) {
>  		dm_pool_set_metadata_out_of_space(pool->pmd);
>  		DMERR_LIMIT("%s: no free metadata space available.",
> -			    dm_device_name(pool->pool_md));
> +			    pool_device_name);
>  	}
>  
> +	DMWARN_LIMIT("%s: consistency of metadata and data must be verified, please repair.",
> +		     pool_device_name);
> +	dm_pool_metadata_set_needs_check(pool->pmd);
> +
>  	set_pool_mode(pool, PM_READ_ONLY);
>  }
>  
> @@ -2295,6 +2325,12 @@ static int maybe_resize_data_dev(struct dm_target *ti, bool *need_commit)
>  		return -EINVAL;
>  
>  	} else if (data_size > sb_data_size) {
> +		if (dm_pool_metadata_needs_check(pool->pmd)) {
> +			DMERR("%s: unable to grow the data device until repaired.",
> +			      dm_device_name(pool->pool_md));
> +			return -EINVAL;;
> +		}
> +
>  		if (sb_data_size)
>  			DMINFO("%s: growing the data device from %llu to %llu blocks",
>  			       dm_device_name(pool->pool_md),
> @@ -2336,6 +2372,12 @@ static int maybe_resize_metadata_dev(struct dm_target *ti, bool *need_commit)
>  		return -EINVAL;
>  
>  	} else if (metadata_dev_size > sb_metadata_dev_size) {
> +		if (dm_pool_metadata_needs_check(pool->pmd)) {
> +			DMERR("%s: unable to grow the metadata device until repaired.",
> +			      dm_device_name(pool->pool_md));
> +			return -EINVAL;;
> +		}
> +
>  		DMINFO("%s: growing the metadata device from %llu to %llu blocks",
>  		       dm_device_name(pool->pool_md),
>  		       sb_metadata_dev_size, metadata_dev_size);
> @@ -2865,7 +2907,7 @@ static struct target_type pool_target = {
>  	.name = "thin-pool",
>  	.features = DM_TARGET_SINGLETON | DM_TARGET_ALWAYS_WRITEABLE |
>  		    DM_TARGET_IMMUTABLE,
> -	.version = {1, 10, 0},
> +	.version = {1, 11, 0},
>  	.module = THIS_MODULE,
>  	.ctr = pool_ctr,
>  	.dtr = pool_dtr,
> @@ -3155,7 +3197,7 @@ static int thin_iterate_devices(struct dm_target *ti,
>  
>  static struct target_type thin_target = {
>  	.name = "thin",
> -	.version = {1, 10, 0},
> +	.version = {1, 11, 0},
>  	.module	= THIS_MODULE,
>  	.ctr = thin_ctr,
>  	.dtr = thin_dtr,
> -- 
> 1.8.3.1
> 
