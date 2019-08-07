From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/3] dm-zoned: properly handle backing device
	failure
Date: Wed, 7 Aug 2019 09:22:53 +0000
Message-ID: <BYAPR04MB58161DAE3EB6B54E67B068A5E7D40@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190806010625.27503-1-dmitry.fomichev@wdc.com>
	<20190806010625.27503-4-dmitry.fomichev@wdc.com>
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

On 2019/08/06 10:06, Dmitry Fomichev wrote:
> dm-zoned is observed to lock up or livelock in case of hardware
> failure or some misconfiguration of the backing zoned device.
> 
> This patch adds a new function in the target code that checks the
> status of the backing device request queue. If it goes to dying state,
> the health check code marks dm-zoned DM target read-only and begins

...target read-only and dying and beignins...

Marking the target as read-only seems useless though since *all* incoming
requests are rejected with DM_MAPIO_KILL for a dying device, including read
requests. So we can remove the set_disk_ro() call I think.

> to reject any further incoming I/O. In order to timely detect backing
> device failure, this new function is called in the request mapping
> path, at the beginning of every reclaim run and before performing any
> metadata I/O.
> 
> The proper way out of this situation is to do
> 
> dmsetup remove <dm-zoned target>
> 
> and recreate the target when the problem with the backing device
> is resolved.
> 
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  drivers/md/dm-zoned-metadata.c | 51 +++++++++++++++++++++++++++-------
>  drivers/md/dm-zoned-reclaim.c  | 18 ++++++++++--
>  drivers/md/dm-zoned-target.c   | 50 +++++++++++++++++++++++++++++++--
>  drivers/md/dm-zoned.h          | 10 +++++++
>  4 files changed, 115 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 6b7fbbd735ef..2a5bc51fd6d5 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -403,15 +403,18 @@ static struct dmz_mblock *dmz_get_mblock_slow(struct dmz_metadata *zmd,
>  	sector_t block = zmd->sb[zmd->mblk_primary].block + mblk_no;
>  	struct bio *bio;
>  
> +	if (dmz_bdev_is_dying(zmd->dev))
> +		return ERR_PTR(-EIO);
> +
>  	/* Get a new block and a BIO to read it */
>  	mblk = dmz_alloc_mblock(zmd, mblk_no);
>  	if (!mblk)
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  
>  	bio = bio_alloc(GFP_NOIO, 1);
>  	if (!bio) {
>  		dmz_free_mblock(zmd, mblk);
> -		return NULL;
> +		return ERR_PTR(-ENOMEM);
>  	}
>  
>  	spin_lock(&zmd->mblk_lock);
> @@ -542,8 +545,8 @@ static struct dmz_mblock *dmz_get_mblock(struct dmz_metadata *zmd,
>  	if (!mblk) {
>  		/* Cache miss: read the block from disk */
>  		mblk = dmz_get_mblock_slow(zmd, mblk_no);
> -		if (!mblk)
> -			return ERR_PTR(-ENOMEM);
> +		if (IS_ERR(mblk))
> +			return mblk;
>  	}
>  
>  	/* Wait for on-going read I/O and check for error */
> @@ -571,16 +574,19 @@ static void dmz_dirty_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk)
>  /*
>   * Issue a metadata block write BIO.
>   */
> -static void dmz_write_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk,
> -			     unsigned int set)
> +static int dmz_write_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk,
> +			    unsigned int set)
>  {
>  	sector_t block = zmd->sb[set].block + mblk->no;
>  	struct bio *bio;
>  
> +	if (dmz_bdev_is_dying(zmd->dev))
> +		return -EIO;
> +
>  	bio = bio_alloc(GFP_NOIO, 1);
>  	if (!bio) {
>  		set_bit(DMZ_META_ERROR, &mblk->state);
> -		return;
> +		return -ENOMEM;
>  	}
>  
>  	set_bit(DMZ_META_WRITING, &mblk->state);
> @@ -592,6 +598,8 @@ static void dmz_write_mblock(struct dmz_metadata *zmd, struct dmz_mblock *mblk,
>  	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_META | REQ_PRIO);
>  	bio_add_page(bio, mblk->page, DMZ_BLOCK_SIZE, 0);
>  	submit_bio(bio);
> +
> +	return 0;
>  }
>  
>  /*
> @@ -603,6 +611,9 @@ static int dmz_rdwr_block(struct dmz_metadata *zmd, int op, sector_t block,
>  	struct bio *bio;
>  	int ret;
>  
> +	if (dmz_bdev_is_dying(zmd->dev))
> +		return -EIO;
> +
>  	bio = bio_alloc(GFP_NOIO, 1);
>  	if (!bio)
>  		return -ENOMEM;
> @@ -660,22 +671,29 @@ static int dmz_write_dirty_mblocks(struct dmz_metadata *zmd,
>  {
>  	struct dmz_mblock *mblk;
>  	struct blk_plug plug;
> -	int ret = 0;
> +	int ret = 0, nr_mblks_submitted = 0;
>  
>  	/* Issue writes */
>  	blk_start_plug(&plug);
> -	list_for_each_entry(mblk, write_list, link)
> -		dmz_write_mblock(zmd, mblk, set);
> +	list_for_each_entry(mblk, write_list, link) {
> +		ret = dmz_write_mblock(zmd, mblk, set);
> +		if (ret)
> +			break;
> +		nr_mblks_submitted++;
> +	}
>  	blk_finish_plug(&plug);
>  
>  	/* Wait for completion */
>  	list_for_each_entry(mblk, write_list, link) {
> +		if (!nr_mblks_submitted)
> +			break;
>  		wait_on_bit_io(&mblk->state, DMZ_META_WRITING,
>  			       TASK_UNINTERRUPTIBLE);
>  		if (test_bit(DMZ_META_ERROR, &mblk->state)) {
>  			clear_bit(DMZ_META_ERROR, &mblk->state);
>  			ret = -EIO;
>  		}
> +		nr_mblks_submitted--;
>  	}
>  
>  	/* Flush drive cache (this will also sync data) */
> @@ -737,6 +755,11 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
>  	 */
>  	dmz_lock_flush(zmd);
>  
> +	if (dmz_bdev_is_dying(zmd->dev)) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
>  	/* Get dirty blocks */
>  	spin_lock(&zmd->mblk_lock);
>  	list_splice_init(&zmd->mblk_dirty_list, &write_list);
> @@ -1632,6 +1655,10 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
>  		/* Allocate a random zone */
>  		dzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
>  		if (!dzone) {
> +			if (dmz_bdev_is_dying(zmd->dev)) {
> +				dzone = ERR_PTR(-EIO);
> +				goto out;
> +			}
>  			dmz_wait_for_free_zones(zmd);
>  			goto again;
>  		}
> @@ -1729,6 +1756,10 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
>  	/* Allocate a random zone */
>  	bzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
>  	if (!bzone) {
> +		if (dmz_bdev_is_dying(zmd->dev)) {
> +			bzone = ERR_PTR(-EIO);
> +			goto out;
> +		}
>  		dmz_wait_for_free_zones(zmd);
>  		goto again;
>  	}
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 26e34493a2db..d240d7ca8a8a 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -38,7 +38,7 @@ enum {
>  /*
>   * Number of seconds of target BIO inactivity to consider the target idle.
>   */
> -#define DMZ_IDLE_PERIOD		(10UL * HZ)
> +#define DMZ_IDLE_PERIOD			(10UL * HZ)
>  
>  /*
>   * Percentage of unmapped (free) random zones below which reclaim starts
> @@ -135,6 +135,9 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
>  		set_bit(DM_KCOPYD_WRITE_SEQ, &flags);
>  
>  	while (block < end_block) {
> +		if (dev->flags & DMZ_BDEV_DYING)
> +			return -EIO;
> +
>  		/* Get a valid region from the source zone */
>  		ret = dmz_first_valid_block(zmd, src_zone, &block);
>  		if (ret <= 0)
> @@ -452,6 +455,9 @@ static void dmz_reclaim_work(struct work_struct *work)
>  	unsigned int p_unmap_rnd;
>  	int ret;
>  
> +	if (dmz_bdev_is_dying(zrc->dev))
> +		return;
> +
>  	if (!dmz_should_reclaim(zrc)) {
>  		mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
>  		return;
> @@ -481,8 +487,16 @@ static void dmz_reclaim_work(struct work_struct *work)
>  		      p_unmap_rnd, nr_unmap_rnd, nr_rnd);
>  
>  	ret = dmz_do_reclaim(zrc);
> -	if (ret)
> +	if (ret) {
>  		dmz_dev_debug(zrc->dev, "Reclaim error %d\n", ret);
> +		if (ret == -EIO)
> +			/*
> +			 * LLD might be performing some error handling sequence
> +			 * at the underlying device. To not interfere, do not
> +			 * attempt to schedule the next reclaim run immediately.
> +			 */
> +			return;
> +	}
>  
>  	dmz_schedule_reclaim(zrc);
>  }
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index c1992034c099..c40c18f7fd64 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -134,6 +134,8 @@ static int dmz_submit_bio(struct dmz_target *dmz, struct dm_zone *zone,
>  
>  	refcount_inc(&bioctx->ref);
>  	generic_make_request(clone);
> +	if (clone->bi_status == BLK_STS_IOERR)
> +		return -EIO;
>  
>  	if (bio_op(bio) == REQ_OP_WRITE && dmz_is_seq(zone))
>  		zone->wp_block += nr_blocks;
> @@ -278,8 +280,8 @@ static int dmz_handle_buffered_write(struct dmz_target *dmz,
>  
>  	/* Get the buffer zone. One will be allocated if needed */
>  	bzone = dmz_get_chunk_buffer(zmd, zone);
> -	if (!bzone)
> -		return -ENOSPC;
> +	if (IS_ERR(bzone))
> +		return PTR_ERR(bzone);
>  
>  	if (dmz_is_readonly(bzone))
>  		return -EROFS;
> @@ -390,6 +392,11 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
>  
>  	dmz_lock_metadata(zmd);
>  
> +	if (dmz->dev->flags & DMZ_BDEV_DYING) {
> +		ret = -EIO;
> +		goto out;
> +	}
> +
>  	/*
>  	 * Get the data zone mapping the chunk. There may be no
>  	 * mapping for read and discard. If a mapping is obtained,
> @@ -494,6 +501,8 @@ static void dmz_flush_work(struct work_struct *work)
>  
>  	/* Flush dirty metadata blocks */
>  	ret = dmz_flush_metadata(dmz->metadata);
> +	if (ret)
> +		dmz_dev_debug(dmz->dev, "Metadata flush failed, rc=%d\n", ret);
>  
>  	/* Process queued flush requests */
>  	while (1) {
> @@ -557,6 +566,37 @@ static int dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)
>  	return ret;
>  }
>  
> +/*
> + * Check the backing device availability. If it's on the way out,
> + * start failing I/O. Reclaim and metadata components also call this
> + * function to cleanly abort operation in the event of such failure.
> + */
> +bool dmz_bdev_is_dying(struct dmz_dev *dmz_dev)
> +{
> +	struct gendisk *disk;
> +	bool dying = dmz_dev->flags & DMZ_BDEV_DYING;
> +
> +	if (!dying) {
> +		disk = dmz_dev->bdev->bd_disk;
> +		if (blk_queue_dying(bdev_get_queue(dmz_dev->bdev))) {
> +			dmz_dev_warn(dmz_dev, "Backing device queue dying");
> +			dying = true;
> +		} else if (disk->fops->check_events) {
> +			if (disk->fops->check_events(disk, 0) &
> +					DISK_EVENT_MEDIA_CHANGE) {
> +				dmz_dev_warn(dmz_dev, "Backing device offline");
> +				dying = true;
> +			}
> +		}
> +		if (dying) {
> +			dmz_dev->flags |= DMZ_BDEV_DYING;
> +			set_disk_ro(dmz_dev->bdev->bd_disk, 1);
> +		}
> +	}
> +
> +	return dying;
> +}
> +
>  /*
>   * Process a new BIO.
>   */
> @@ -570,6 +610,9 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
>  	sector_t chunk_sector;
>  	int ret;
>  
> +	if (dmz_bdev_is_dying(dmz->dev))
> +		return DM_MAPIO_KILL;
> +
>  	dmz_dev_debug(dev, "BIO op %d sector %llu + %u => chunk %llu, block %llu, %u blocks",
>  		      bio_op(bio), (unsigned long long)sector, nr_sectors,
>  		      (unsigned long long)dmz_bio_chunk(dmz->dev, bio),
> @@ -866,6 +909,9 @@ static int dmz_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
>  {
>  	struct dmz_target *dmz = ti->private;
>  
> +	if (dmz_bdev_is_dying(dmz->dev))
> +		return -ENODEV;
> +
>  	*bdev = dmz->dev->bdev;
>  
>  	return 0;
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index 1a3b06de2c00..d8e70b0ade35 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -57,6 +57,8 @@ struct dmz_dev {
>  
>  	unsigned int		nr_zones;
>  
> +	unsigned int		flags;
> +
>  	sector_t		zone_nr_sectors;
>  	unsigned int		zone_nr_sectors_shift;
>  
> @@ -68,6 +70,9 @@ struct dmz_dev {
>  				 (dev)->zone_nr_sectors_shift)
>  #define dmz_chunk_block(dev, b)	((b) & ((dev)->zone_nr_blocks - 1))
>  
> +/* Device flags. */
> +#define DMZ_BDEV_DYING		(1 << 0)
> +
>  /*
>   * Zone descriptor.
>   */
> @@ -246,4 +251,9 @@ void dmz_resume_reclaim(struct dmz_reclaim *zrc);
>  void dmz_reclaim_bio_acc(struct dmz_reclaim *zrc);
>  void dmz_schedule_reclaim(struct dmz_reclaim *zrc);
>  
> +/*
> + * Functions defined in dm-zoned-target.c
> + */
> +bool dmz_bdev_is_dying(struct dmz_dev *dmz_dev);
> +
>  #endif /* DM_ZONED_H */
> 


-- 
Damien Le Moal
Western Digital Research
