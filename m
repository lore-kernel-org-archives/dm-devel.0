From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] dm-zoned: reduce overhead of backing device
	checks
Date: Fri, 8 Nov 2019 06:36:18 +0000
Message-ID: <BYAPR04MB5816753ABD46229FBD99F526E77B0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191107001941.30991-1-dmitry.fomichev@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2019/11/07 9:19, Dmitry Fomichev wrote:
> Commit 75d66ffb48efb3 added backing device health checks and as a part
> of these checks, check_events() block ops template call is invoked
> in dm-zoned mapping path as well as in reclaim and flush path. Calling
> check_events() with ATA or SCSI backing devices introduces a blocking
> scsi_test_unit_ready() call being made in sd_check_events().
> Even though the overhead of calling scsi_test_unit_ready() is small
> for ATA zoned devices, it is much larger for SCSI and it affects
> performance in a very negative way.
> 
> This commit fixes this performance regression by executing
> check_events() only in case of any I/O errors. The function
> dmz_bdev_is_dying() is modified to call only blk_queue_dying(),
> while calls to check_events() are made in a new helper function,
> dmz_check_bdev().

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

> 
> Cc: stable@vger.kernel.org
> Fixes: 75d66ffb48efb3 ("dm zoned: properly handle backing device failure")
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  drivers/md/dm-zoned-metadata.c | 29 +++++++++++-------
>  drivers/md/dm-zoned-reclaim.c  |  8 ++---
>  drivers/md/dm-zoned-target.c   | 54 ++++++++++++++++++++++++----------
>  drivers/md/dm-zoned.h          |  2 ++
>  4 files changed, 61 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 595a73110e17..ac1179ca80d9 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -554,6 +554,7 @@ static struct dmz_mblock *dmz_get_mblock(struct dmz_metadata *zmd,
>  		       TASK_UNINTERRUPTIBLE);
>  	if (test_bit(DMZ_META_ERROR, &mblk->state)) {
>  		dmz_release_mblock(zmd, mblk);
> +		dmz_check_bdev(zmd->dev);
>  		return ERR_PTR(-EIO);
>  	}
>  
> @@ -625,6 +626,8 @@ static int dmz_rdwr_block(struct dmz_metadata *zmd, int op, sector_t block,
>  	ret = submit_bio_wait(bio);
>  	bio_put(bio);
>  
> +	if (ret)
> +		dmz_check_bdev(zmd->dev);
>  	return ret;
>  }
>  
> @@ -691,6 +694,7 @@ static int dmz_write_dirty_mblocks(struct dmz_metadata *zmd,
>  			       TASK_UNINTERRUPTIBLE);
>  		if (test_bit(DMZ_META_ERROR, &mblk->state)) {
>  			clear_bit(DMZ_META_ERROR, &mblk->state);
> +			dmz_check_bdev(zmd->dev);
>  			ret = -EIO;
>  		}
>  		nr_mblks_submitted--;
> @@ -768,7 +772,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
>  	/* If there are no dirty metadata blocks, just flush the device cache */
>  	if (list_empty(&write_list)) {
>  		ret = blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO, NULL);
> -		goto out;
> +		goto err;
>  	}
>  
>  	/*
> @@ -778,7 +782,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
>  	 */
>  	ret = dmz_log_dirty_mblocks(zmd, &write_list);
>  	if (ret)
> -		goto out;
> +		goto err;
>  
>  	/*
>  	 * The log is on disk. It is now safe to update in place
> @@ -786,11 +790,11 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
>  	 */
>  	ret = dmz_write_dirty_mblocks(zmd, &write_list, zmd->mblk_primary);
>  	if (ret)
> -		goto out;
> +		goto err;
>  
>  	ret = dmz_write_sb(zmd, zmd->mblk_primary);
>  	if (ret)
> -		goto out;
> +		goto err;
>  
>  	while (!list_empty(&write_list)) {
>  		mblk = list_first_entry(&write_list, struct dmz_mblock, link);
> @@ -805,16 +809,20 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
>  
>  	zmd->sb_gen++;
>  out:
> -	if (ret && !list_empty(&write_list)) {
> -		spin_lock(&zmd->mblk_lock);
> -		list_splice(&write_list, &zmd->mblk_dirty_list);
> -		spin_unlock(&zmd->mblk_lock);
> -	}
> -
>  	dmz_unlock_flush(zmd);
>  	up_write(&zmd->mblk_sem);
>  
>  	return ret;
> +
> +err:
> +	if (!list_empty(&write_list)) {
> +		spin_lock(&zmd->mblk_lock);
> +		list_splice(&write_list, &zmd->mblk_dirty_list);
> +		spin_unlock(&zmd->mblk_lock);
> +	}
> +	if (!dmz_check_bdev(zmd->dev))
> +		ret = -EIO;
> +	goto out;
>  }
>  
>  /*
> @@ -1244,6 +1252,7 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
>  	if (ret) {
>  		dmz_dev_err(zmd->dev, "Get zone %u report failed",
>  			    dmz_id(zmd, zone));
> +		dmz_check_bdev(zmd->dev);
>  		return ret;
>  	}
>  
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index d240d7ca8a8a..e7ace908a9b7 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -82,6 +82,7 @@ static int dmz_reclaim_align_wp(struct dmz_reclaim *zrc, struct dm_zone *zone,
>  			    "Align zone %u wp %llu to %llu (wp+%u) blocks failed %d",
>  			    dmz_id(zmd, zone), (unsigned long long)wp_block,
>  			    (unsigned long long)block, nr_blocks, ret);
> +		dmz_check_bdev(zrc->dev);
>  		return ret;
>  	}
>  
> @@ -489,12 +490,7 @@ static void dmz_reclaim_work(struct work_struct *work)
>  	ret = dmz_do_reclaim(zrc);
>  	if (ret) {
>  		dmz_dev_debug(zrc->dev, "Reclaim error %d\n", ret);
> -		if (ret == -EIO)
> -			/*
> -			 * LLD might be performing some error handling sequence
> -			 * at the underlying device. To not interfere, do not
> -			 * attempt to schedule the next reclaim run immediately.
> -			 */
> +		if (!dmz_check_bdev(zrc->dev))
>  			return;
>  	}
>  
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 09f5a63e0803..e0b809bb4885 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -85,6 +85,8 @@ static inline void dmz_bio_endio(struct bio *bio, blk_status_t status)
>  
>  	if (status != BLK_STS_OK && bio->bi_status == BLK_STS_OK)
>  		bio->bi_status = status;
> +	if (bio->bi_status != BLK_STS_OK)
> +		bioctx->target->dev->flags |= DMZ_CHECK_BDEV;
>  
>  	if (refcount_dec_and_test(&bioctx->ref)) {
>  		struct dm_zone *zone = bioctx->zone;
> @@ -570,31 +572,51 @@ static int dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)
>  }
>  
>  /*
> - * Check the backing device availability. If it's on the way out,
> + * Check if the backing device is being removed. If it's on the way out,
>   * start failing I/O. Reclaim and metadata components also call this
>   * function to cleanly abort operation in the event of such failure.
>   */
>  bool dmz_bdev_is_dying(struct dmz_dev *dmz_dev)
>  {
> -	struct gendisk *disk;
> +	if (dmz_dev->flags & DMZ_BDEV_DYING)
> +		return true;
>  
> -	if (!(dmz_dev->flags & DMZ_BDEV_DYING)) {
> -		disk = dmz_dev->bdev->bd_disk;
> -		if (blk_queue_dying(bdev_get_queue(dmz_dev->bdev))) {
> -			dmz_dev_warn(dmz_dev, "Backing device queue dying");
> -			dmz_dev->flags |= DMZ_BDEV_DYING;
> -		} else if (disk->fops->check_events) {
> -			if (disk->fops->check_events(disk, 0) &
> -					DISK_EVENT_MEDIA_CHANGE) {
> -				dmz_dev_warn(dmz_dev, "Backing device offline");
> -				dmz_dev->flags |= DMZ_BDEV_DYING;
> -			}
> -		}
> +	if (dmz_dev->flags & DMZ_CHECK_BDEV)
> +		return !dmz_check_bdev(dmz_dev);
> +
> +	if (blk_queue_dying(bdev_get_queue(dmz_dev->bdev))) {
> +		dmz_dev_warn(dmz_dev, "Backing device queue dying");
> +		dmz_dev->flags |= DMZ_BDEV_DYING;
>  	}
>  
>  	return dmz_dev->flags & DMZ_BDEV_DYING;
>  }
>  
> +/*
> + * Check the backing device availability. This detects such events as
> + * backing device going offline due to errors, media removals, etc.
> + * This check is less efficient than dmz_bdev_is_dying() and should
> + * only be performed as a part of error handling.
> + */
> +bool dmz_check_bdev(struct dmz_dev *dmz_dev)
> +{
> +	struct gendisk *disk;
> +
> +	dmz_dev->flags &= ~DMZ_CHECK_BDEV;
> +
> +	if (dmz_bdev_is_dying(dmz_dev))
> +		return false;
> +
> +	disk = dmz_dev->bdev->bd_disk;
> +	if (disk->fops->check_events &&
> +	    disk->fops->check_events(disk, 0) & DISK_EVENT_MEDIA_CHANGE) {
> +		dmz_dev_warn(dmz_dev, "Backing device offline");
> +		dmz_dev->flags |= DMZ_BDEV_DYING;
> +	}
> +
> +	return !(dmz_dev->flags & DMZ_BDEV_DYING);
> +}
> +
>  /*
>   * Process a new BIO.
>   */
> @@ -907,8 +929,8 @@ static int dmz_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
>  {
>  	struct dmz_target *dmz = ti->private;
>  
> -	if (dmz_bdev_is_dying(dmz->dev))
> -		return -ENODEV;
> +	if (!dmz_check_bdev(dmz->dev))
> +		return -EIO;
>  
>  	*bdev = dmz->dev->bdev;
>  
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index d8e70b0ade35..5b5e493d479c 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -72,6 +72,7 @@ struct dmz_dev {
>  
>  /* Device flags. */
>  #define DMZ_BDEV_DYING		(1 << 0)
> +#define DMZ_CHECK_BDEV		(2 << 0)
>  
>  /*
>   * Zone descriptor.
> @@ -255,5 +256,6 @@ void dmz_schedule_reclaim(struct dmz_reclaim *zrc);
>   * Functions defined in dm-zoned-target.c
>   */
>  bool dmz_bdev_is_dying(struct dmz_dev *dmz_dev);
> +bool dmz_check_bdev(struct dmz_dev *dmz_dev);
>  
>  #endif /* DM_ZONED_H */
> 


-- 
Damien Le Moal
Western Digital Research
