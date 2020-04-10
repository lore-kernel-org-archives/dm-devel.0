From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 07/11] dm-zoned: replace 'target' pointer in
 the bio context
Date: Fri, 10 Apr 2020 06:52:35 +0000
Message-ID: <BY5PR04MB6900300E586A0BD669A88305E7DE0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200409064527.82992-1-hare@suse.de>
	<20200409064527.82992-8-hare@suse.de>
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
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>
Cc: Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/04/09 15:45, Hannes Reinecke wrote:
> Replace the 'target' pointer in the bio context with the
> device pointer as this is what's actually used.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-target.c | 54 +++++++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index fa297348f0bb..1ee10789f04d 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -17,7 +17,7 @@
>   * Zone BIO context.
>   */
>  struct dmz_bioctx {
> -	struct dmz_target	*target;
> +	struct dmz_dev		*dev;
>  	struct dm_zone		*zone;
>  	struct bio		*bio;
>  	refcount_t		ref;
> @@ -71,6 +71,11 @@ struct dmz_target {
>   */
>  #define DMZ_FLUSH_PERIOD	(10 * HZ)
>  
> +struct dmz_dev *dmz_sect_to_dev(struct dmz_target *dmz, sector_t sect)
> +{
> +	return &dmz->dev[0];
> +}
> +
>  /*
>   * Target BIO completion.
>   */
> @@ -81,7 +86,7 @@ static inline void dmz_bio_endio(struct bio *bio, blk_status_t status)
>  	if (status != BLK_STS_OK && bio->bi_status == BLK_STS_OK)
>  		bio->bi_status = status;
>  	if (bio->bi_status != BLK_STS_OK)
> -		bioctx->target->dev->flags |= DMZ_CHECK_BDEV;
> +		bioctx->dev->flags |= DMZ_CHECK_BDEV;
>  
>  	if (refcount_dec_and_test(&bioctx->ref)) {
>  		struct dm_zone *zone = bioctx->zone;
> @@ -118,14 +123,20 @@ static int dmz_submit_bio(struct dmz_target *dmz, struct dm_zone *zone,
>  			  struct bio *bio, sector_t chunk_block,
>  			  unsigned int nr_blocks)
>  {
> -	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
> +	struct dmz_dev *dev = dmz_zone_to_dev(dmz->metadata, zone);
> +	struct dmz_bioctx *bioctx =
> +		dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
>  	struct bio *clone;
>  
> +	if (dev->flags & DMZ_BDEV_DYING)
> +		return -EIO;
> +
>  	clone = bio_clone_fast(bio, GFP_NOIO, &dmz->bio_set);
>  	if (!clone)
>  		return -ENOMEM;
>  
> -	bio_set_dev(clone, dmz->dev->bdev);
> +	bio_set_dev(clone, dev->bdev);
> +	bioctx->dev = dev;
>  	clone->bi_iter.bi_sector =
>  		dmz_start_sect(dmz->metadata, zone) + dmz_blk2sect(chunk_block);
>  	clone->bi_iter.bi_size = dmz_blk2sect(nr_blocks) << SECTOR_SHIFT;
> @@ -218,8 +229,10 @@ static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,
>  
>  		if (nr_blocks) {
>  			/* Valid blocks found: read them */
> -			nr_blocks = min_t(unsigned int, nr_blocks, end_block - chunk_block);
> -			ret = dmz_submit_bio(dmz, rzone, bio, chunk_block, nr_blocks);
> +			nr_blocks = min_t(unsigned int, nr_blocks,
> +					  end_block - chunk_block);
> +			ret = dmz_submit_bio(dmz, rzone, bio,
> +					     chunk_block, nr_blocks);
>  			if (ret)
>  				return ret;
>  			chunk_block += nr_blocks;
> @@ -330,14 +343,16 @@ static int dmz_handle_write(struct dmz_target *dmz, struct dm_zone *zone,
>  		 * and the BIO is aligned to the zone write pointer:
>  		 * direct write the zone.
>  		 */
> -		return dmz_handle_direct_write(dmz, zone, bio, chunk_block, nr_blocks);
> +		return dmz_handle_direct_write(dmz, zone, bio,
> +					       chunk_block, nr_blocks);
>  	}
>  
>  	/*
>  	 * This is an unaligned write in a sequential zone:
>  	 * use buffered write.
>  	 */
> -	return dmz_handle_buffered_write(dmz, zone, bio, chunk_block, nr_blocks);
> +	return dmz_handle_buffered_write(dmz, zone, bio,
> +					 chunk_block, nr_blocks);
>  }
>  
>  /*
> @@ -383,7 +398,6 @@ static int dmz_handle_discard(struct dmz_target *dmz, struct dm_zone *zone,
>  static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
>  			   struct bio *bio)
>  {
> -	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
>  	struct dmz_metadata *zmd = dmz->metadata;
>  	struct dm_zone *zone;
>  	int ret;
> @@ -397,11 +411,6 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
>  
>  	dmz_lock_metadata(zmd);
>  
> -	if (dmz->dev->flags & DMZ_BDEV_DYING) {
> -		ret = -EIO;
> -		goto out;
> -	}

Are you removing this because you added the check to dmz_submit_bio() ?

> -
>  	/*
>  	 * Get the data zone mapping the chunk. There may be no
>  	 * mapping for read and discard. If a mapping is obtained,
> @@ -415,10 +424,8 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
>  	}
>  
>  	/* Process the BIO */
> -	if (zone) {
> +	if (zone)
>  		dmz_activate_zone(zone);
> -		bioctx->zone = zone;

Why are you removing this ? This is used in dmz_bio_endio()...


> -	}
>  
>  	switch (bio_op(bio)) {
>  	case REQ_OP_READ:
> @@ -625,14 +632,14 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
>  {
>  	struct dmz_target *dmz = ti->private;
>  	struct dmz_metadata *zmd = dmz->metadata;
> -	struct dmz_dev *dev = dmz->dev;
>  	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
>  	sector_t sector = bio->bi_iter.bi_sector;
>  	unsigned int nr_sectors = bio_sectors(bio);
> +	struct dmz_dev *dev = dmz_sect_to_dev(dmz, sector);
>  	sector_t chunk_sector;
>  	int ret;
>  
> -	if (dmz_bdev_is_dying(dmz->dev))
> +	if (dmz_bdev_is_dying(dev))
>  		return DM_MAPIO_KILL;
>  
>  	dmz_dev_debug(dev, "BIO op %d sector %llu + %u => chunk %llu, block %llu, %u blocks",
> @@ -651,7 +658,7 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
>  		return DM_MAPIO_KILL;
>  
>  	/* Initialize the BIO context */
> -	bioctx->target = dmz;
> +	bioctx->dev = NULL;
>  	bioctx->zone = NULL;
>  	bioctx->bio = bio;
>  	refcount_set(&bioctx->ref, 1);
> @@ -673,7 +680,7 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
>  	/* Now ready to handle this BIO */
>  	ret = dmz_queue_chunk_work(dmz, bio);
>  	if (ret) {
> -		dmz_dev_debug(dmz->dev,
> +		dmz_dev_debug(dev,
>  			      "BIO op %d, can't process chunk %llu, err %i\n",
>  			      bio_op(bio), (u64)dmz_bio_chunk(zmd, bio),
>  			      ret);
> @@ -930,11 +937,12 @@ static void dmz_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  static int dmz_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
>  {
>  	struct dmz_target *dmz = ti->private;
> +	struct dmz_dev *dev = dmz_sect_to_dev(dmz, 0);
>  
> -	if (!dmz_check_bdev(dmz->dev))
> +	if (!dmz_check_bdev(dev))
>  		return -EIO;
>  
> -	*bdev = dmz->dev->bdev;
> +	*bdev = dev->bdev;
>  
>  	return 0;
>  }
> 


-- 
Damien Le Moal
Western Digital Research
