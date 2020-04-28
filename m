From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 09/13] dm-zoned: replace 'target' pointer in
 the bio context
Date: Tue, 28 Apr 2020 09:43:48 +0000
Message-ID: <CH2PR04MB69025EE2333E2E72F9658F92E7AC0@CH2PR04MB6902.namprd04.prod.outlook.com>
References: <20200420100824.124618-1-hare@suse.de>
	<20200420100824.124618-10-hare@suse.de>
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

On 2020/04/20 19:08, Hannes Reinecke wrote:
> Replace the 'target' pointer in the bio context with the
> device pointer as this is what's actually used.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bob Liu <bob.liu@oracle.com>
> ---
>  drivers/md/dm-zoned-target.c | 26 ++++++++++++--------------
>  1 file changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index a1f42af2877c..4897ffae96ca 100644
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
> @@ -81,7 +81,7 @@ static inline void dmz_bio_endio(struct bio *bio, blk_status_t status)
>  	if (status != BLK_STS_OK && bio->bi_status == BLK_STS_OK)
>  		bio->bi_status = status;
>  	if (bio->bi_status != BLK_STS_OK)
> -		bioctx->target->dev->flags |= DMZ_CHECK_BDEV;
> +		bioctx->dev->flags |= DMZ_CHECK_BDEV;
>  
>  	if (refcount_dec_and_test(&bioctx->ref)) {
>  		struct dm_zone *zone = bioctx->zone;
> @@ -119,13 +119,18 @@ static int dmz_submit_bio(struct dmz_target *dmz, struct dm_zone *zone,
>  			  unsigned int nr_blocks)
>  {
>  	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
> +	struct dmz_dev *dev = dmz_zone_to_dev(dmz->metadata, zone);
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
> @@ -397,11 +402,6 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
>  
>  	dmz_lock_metadata(zmd);
>  
> -	if (dmz->dev->flags & DMZ_BDEV_DYING) {
> -		ret = -EIO;
> -		goto out;
> -	}
> -
>  	/*
>  	 * Get the data zone mapping the chunk. There may be no
>  	 * mapping for read and discard. If a mapping is obtained,
> @@ -625,7 +625,6 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
>  {
>  	struct dmz_target *dmz = ti->private;
>  	struct dmz_metadata *zmd = dmz->metadata;
> -	struct dmz_dev *dev = dmz->dev;
>  	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
>  	sector_t sector = bio->bi_iter.bi_sector;
>  	unsigned int nr_sectors = bio_sectors(bio);
> @@ -642,8 +641,6 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
>  		(unsigned long long)dmz_chunk_block(zmd, dmz_bio_block(bio)),
>  		(unsigned int)dmz_bio_blocks(bio));
>  
> -	bio_set_dev(bio, dev->bdev);
> -
>  	if (!nr_sectors && bio_op(bio) != REQ_OP_WRITE)
>  		return DM_MAPIO_REMAPPED;
>  
> @@ -652,7 +649,7 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
>  		return DM_MAPIO_KILL;
>  
>  	/* Initialize the BIO context */
> -	bioctx->target = dmz;
> +	bioctx->dev = NULL;
>  	bioctx->zone = NULL;
>  	bioctx->bio = bio;
>  	refcount_set(&bioctx->ref, 1);
> @@ -931,11 +928,12 @@ static void dmz_io_hints(struct dm_target *ti, struct queue_limits *limits)
>  static int dmz_prepare_ioctl(struct dm_target *ti, struct block_device **bdev)
>  {
>  	struct dmz_target *dmz = ti->private;
> +	struct dmz_dev *dev = &dmz->dev[0];
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

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
