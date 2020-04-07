From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 06/11] dm-zoned: remove 'dev' argument from
	reclaim
Date: Tue, 7 Apr 2020 02:31:50 +0000
Message-ID: <BY5PR04MB6900FB3F974F3C3BB9A0C69BE7C30@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200406143505.133271-1-hare@suse.de>
	<20200406143505.133271-7-hare@suse.de>
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

On 2020/04/07 2:27, Hannes Reinecke wrote:
> Use the dmz_zone_to_dev() mapping function to remove the
> 'dev' argument from reclaim.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c |  5 ++++
>  drivers/md/dm-zoned-reclaim.c  | 44 ++++++++++++++++++----------------
>  drivers/md/dm-zoned-target.c   |  2 +-
>  drivers/md/dm-zoned.h          |  4 +++-
>  4 files changed, 33 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index f7ae57e78230..9919aa6210c1 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -272,6 +272,11 @@ const char *dmz_metadata_label(struct dmz_metadata *zmd)
>  	return (const char *)zmd->devname;
>  }
>  
> +bool dmz_check_dev(struct dmz_metadata *zmd)
> +{
> +	return dmz_check_bdev(&zmd->dev[0]);
> +}
> +
>  /*
>   * Lock/unlock mapping table.
>   * The map lock also protects all the zone lists.
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index c46159b6fc46..b41ef358210f 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -13,7 +13,6 @@
>  
>  struct dmz_reclaim {
>  	struct dmz_metadata     *metadata;
> -	struct dmz_dev		*dev;
>  
>  	struct delayed_work	work;
>  	struct workqueue_struct *wq;
> @@ -59,6 +58,7 @@ static int dmz_reclaim_align_wp(struct dmz_reclaim *zrc, struct dm_zone *zone,
>  				sector_t block)
>  {
>  	struct dmz_metadata *zmd = zrc->metadata;
> +	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
>  	sector_t wp_block = zone->wp_block;
>  	unsigned int nr_blocks;
>  	int ret;
> @@ -74,15 +74,15 @@ static int dmz_reclaim_align_wp(struct dmz_reclaim *zrc, struct dm_zone *zone,
>  	 * pointer and the requested position.
>  	 */
>  	nr_blocks = block - wp_block;
> -	ret = blkdev_issue_zeroout(zrc->dev->bdev,
> +	ret = blkdev_issue_zeroout(dev->bdev,
>  				   dmz_start_sect(zmd, zone) + dmz_blk2sect(wp_block),
>  				   dmz_blk2sect(nr_blocks), GFP_NOIO, 0);
>  	if (ret) {
> -		dmz_dev_err(zrc->dev,
> +		dmz_dev_err(dev,
>  			    "Align zone %u wp %llu to %llu (wp+%u) blocks failed %d",
>  			    dmz_id(zmd, zone), (unsigned long long)wp_block,
>  			    (unsigned long long)block, nr_blocks, ret);
> -		dmz_check_bdev(zrc->dev);
> +		dmz_check_bdev(dev);
>  		return ret;
>  	}
>  
> @@ -116,7 +116,7 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
>  			    struct dm_zone *src_zone, struct dm_zone *dst_zone)
>  {
>  	struct dmz_metadata *zmd = zrc->metadata;
> -	struct dmz_dev *dev = zrc->dev;
> +	struct dmz_dev *src_dev, *dst_dev;
>  	struct dm_io_region src, dst;
>  	sector_t block = 0, end_block;
>  	sector_t nr_blocks;
> @@ -130,13 +130,17 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
>  	else
>  		end_block = dmz_zone_nr_blocks(zmd);
>  	src_zone_block = dmz_start_block(zmd, src_zone);
> +	src_dev = dmz_zone_to_dev(zmd, src_zone);
>  	dst_zone_block = dmz_start_block(zmd, dst_zone);
> +	dst_dev = dmz_zone_to_dev(zmd, dst_zone);
>  
>  	if (dmz_is_seq(dst_zone))
>  		set_bit(DM_KCOPYD_WRITE_SEQ, &flags);
>  
>  	while (block < end_block) {
> -		if (dev->flags & DMZ_BDEV_DYING)
> +		if (src_dev->flags & DMZ_BDEV_DYING)
> +			return -EIO;
> +		if (dst_dev->flags & DMZ_BDEV_DYING)
>  			return -EIO;
>  
>  		/* Get a valid region from the source zone */
> @@ -156,11 +160,11 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
>  				return ret;
>  		}
>  
> -		src.bdev = dev->bdev;
> +		src.bdev = src_dev->bdev;
>  		src.sector = dmz_blk2sect(src_zone_block + block);
>  		src.count = dmz_blk2sect(nr_blocks);
>  
> -		dst.bdev = dev->bdev;
> +		dst.bdev = dst_dev->bdev;
>  		dst.sector = dmz_blk2sect(dst_zone_block + block);
>  		dst.count = src.count;
>  
> @@ -192,9 +196,10 @@ static int dmz_reclaim_buf(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>  	struct dm_zone *bzone = dzone->bzone;
>  	sector_t chunk_block = dzone->wp_block;
>  	struct dmz_metadata *zmd = zrc->metadata;
> +	struct dmz_dev *dev = dmz_zone_to_dev(zmd, dzone);
>  	int ret;
>  
> -	dmz_dev_debug(zrc->dev,
> +	dmz_dev_debug(dev,
>  		      "Chunk %u, move buf zone %u (weight %u) to data zone %u (weight %u)",
>  		      dzone->chunk, dmz_id(zmd, bzone), dmz_weight(bzone),
>  		      dmz_id(zmd, dzone), dmz_weight(dzone));
> @@ -231,9 +236,10 @@ static int dmz_reclaim_seq_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>  	unsigned int chunk = dzone->chunk;
>  	struct dm_zone *bzone = dzone->bzone;
>  	struct dmz_metadata *zmd = zrc->metadata;
> +	struct dmz_dev *dev = dmz_zone_to_dev(zmd, dzone);
>  	int ret = 0;
>  
> -	dmz_dev_debug(zrc->dev,
> +	dmz_dev_debug(dev,
>  		      "Chunk %u, move data zone %u (weight %u) to buf zone %u (weight %u)",
>  		      chunk, dmz_id(zmd, dzone), dmz_weight(dzone),
>  		      dmz_id(zmd, bzone), dmz_weight(bzone));
> @@ -276,6 +282,7 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>  	unsigned int chunk = dzone->chunk;
>  	struct dm_zone *szone = NULL;
>  	struct dmz_metadata *zmd = zrc->metadata;
> +	struct dmz_dev *dev = dmz_zone_to_dev(zmd, dzone);
>  	int ret;
>  
>  	/* Get a free sequential zone */
> @@ -285,7 +292,7 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>  	if (!szone)
>  		return -ENOSPC;
>  
> -	dmz_dev_debug(zrc->dev,
> +	dmz_dev_debug(dev,
>  		      "Chunk %u, move rnd zone %u (weight %u) to seq zone %u",
>  		      chunk, dmz_id(zmd, dzone), dmz_weight(dzone),
>  		      dmz_id(zmd, szone));
> @@ -344,6 +351,7 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>  	struct dmz_metadata *zmd = zrc->metadata;
>  	struct dm_zone *dzone;
>  	struct dm_zone *rzone;
> +	struct dmz_dev *dev;
>  	unsigned long start;
>  	int ret;
>  
> @@ -353,7 +361,7 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>  		return PTR_ERR(dzone);
>  
>  	start = jiffies;
> -
> +	dev = dmz_zone_to_dev(zmd, dzone);
>  	if (dmz_is_rnd(dzone)) {
>  		if (!dmz_weight(dzone)) {
>  			/* Empty zone */
> @@ -401,13 +409,13 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>  
>  	ret = dmz_flush_metadata(zrc->metadata);
>  	if (ret) {
> -		dmz_dev_debug(zrc->dev,
> +		dmz_dev_debug(dev,
>  			      "Metadata flush for zone %u failed, err %d\n",
>  			      dmz_id(zmd, rzone), ret);
>  		return ret;
>  	}
>  
> -	dmz_dev_debug(zrc->dev, "Reclaimed zone %u in %u ms",
> +	dmz_dev_debug(dev, "Reclaimed zone %u in %u ms",
>  		      dmz_id(zmd, rzone), jiffies_to_msecs(jiffies - start));

In patch 5, you changed dmz_dev_debug() to use DMDEBUG() to print the label. It
may be good to do the same here to have the label, but also add the bdev name
reclaim acted on ? Not super important though.

>  	return 0;
>  }
> @@ -456,9 +464,6 @@ static void dmz_reclaim_work(struct work_struct *work)
>  	unsigned int p_unmap_rnd;
>  	int ret;
>  
> -	if (dmz_bdev_is_dying(zrc->dev))
> -		return;
> -
>  	if (!dmz_should_reclaim(zrc)) {
>  		mod_delayed_work(zrc->wq, &zrc->work, DMZ_IDLE_PERIOD);
>  		return;
> @@ -491,7 +496,7 @@ static void dmz_reclaim_work(struct work_struct *work)
>  	if (ret) {
>  		DMDEBUG("(%s): Reclaim error %d\n",
>  			dmz_metadata_label(zmd), ret);
> -		if (!dmz_check_bdev(zrc->dev))
> +		if (!dmz_check_dev(zmd))
>  			return;
>  	}
>  
> @@ -501,7 +506,7 @@ static void dmz_reclaim_work(struct work_struct *work)
>  /*
>   * Initialize reclaim.
>   */
> -int dmz_ctr_reclaim(struct dmz_dev *dev, struct dmz_metadata *zmd,
> +int dmz_ctr_reclaim(struct dmz_metadata *zmd,
>  		    struct dmz_reclaim **reclaim)
>  {
>  	struct dmz_reclaim *zrc;
> @@ -511,7 +516,6 @@ int dmz_ctr_reclaim(struct dmz_dev *dev, struct dmz_metadata *zmd,
>  	if (!zrc)
>  		return -ENOMEM;
>  
> -	zrc->dev = dev;
>  	zrc->metadata = zmd;
>  	zrc->atime = jiffies;
>  
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index c2c3aa090f97..02ee0ca1f0b0 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -835,7 +835,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	mod_delayed_work(dmz->flush_wq, &dmz->flush_work, DMZ_FLUSH_PERIOD);
>  
>  	/* Initialize reclaim */
> -	ret = dmz_ctr_reclaim(dev, dmz->metadata, &dmz->reclaim);
> +	ret = dmz_ctr_reclaim(dmz->metadata, &dmz->reclaim);
>  	if (ret) {
>  		ti->error = "Zone reclaim initialization failed";
>  		goto err_fwq;
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index f7df7f67e404..808ffbef0da3 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -176,11 +176,13 @@ void dmz_lock_flush(struct dmz_metadata *zmd);
>  void dmz_unlock_flush(struct dmz_metadata *zmd);
>  int dmz_flush_metadata(struct dmz_metadata *zmd);
>  const char *dmz_metadata_label(struct dmz_metadata *zmd);
> +bool dmz_check_dev(struct dmz_metadata *zmd);
>  
>  unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone);
>  sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone);
>  sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone);
>  unsigned int dmz_nr_chunks(struct dmz_metadata *zmd);
> +struct dmz_dev *dmz_zone_to_dev(struct dmz_metadata *zmd, struct dm_zone *zone);
>  
>  #define DMZ_ALLOC_RND		0x01
>  #define DMZ_ALLOC_RECLAIM	0x02
> @@ -252,7 +254,7 @@ int dmz_merge_valid_blocks(struct dmz_metadata *zmd, struct dm_zone *from_zone,
>  /*
>   * Functions defined in dm-zoned-reclaim.c
>   */
> -int dmz_ctr_reclaim(struct dmz_dev *dev, struct dmz_metadata *zmd,
> +int dmz_ctr_reclaim(struct dmz_metadata *zmd,
>  		    struct dmz_reclaim **zrc);
>  void dmz_dtr_reclaim(struct dmz_reclaim *zrc);
>  void dmz_suspend_reclaim(struct dmz_reclaim *zrc);
> 

Apart from the nit above, looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
