From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 07/15] dm-zoned: add device pointer to struct
	dm_zone
Date: Thu, 28 May 2020 02:57:30 +0000
Message-ID: <CY4PR04MB37512702CEA45734C65005F9E78E0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200527062225.72849-1-hare@suse.de>
	<20200527062225.72849-8-hare@suse.de>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/05/27 15:22, Hannes Reinecke wrote:
> Add a pointer to the containing device to struct dm_zone and
> kill dmz_zone_to_dev().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 39 ++++++++++-----------------------------
>  drivers/md/dm-zoned-reclaim.c  | 13 +++++--------
>  drivers/md/dm-zoned-target.c   |  2 +-
>  drivers/md/dm-zoned.h          |  4 +++-
>  4 files changed, 19 insertions(+), 39 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index bb9ce72bf18c..302443b2d885 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -229,16 +229,10 @@ struct dmz_metadata {
>   */
>  static unsigned int dmz_dev_zone_id(struct dmz_metadata *zmd, struct dm_zone *zone)
>  {
> -	unsigned int zone_id;
> -
>  	if (WARN_ON(!zone))
>  		return 0;
>  
> -	zone_id = zone->id;
> -	if (zmd->nr_devs > 1 &&
> -	    (zone_id >= zmd->dev[1].zone_offset))
> -		zone_id -= zmd->dev[1].zone_offset;
> -	return zone_id;
> +	return zone->id - zone->dev->zone_offset;
>  }
>  
>  sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone)
> @@ -255,18 +249,6 @@ sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone)
>  	return (sector_t)zone_id << zmd->zone_nr_blocks_shift;
>  }
>  
> -struct dmz_dev *dmz_zone_to_dev(struct dmz_metadata *zmd, struct dm_zone *zone)
> -{
> -	if (WARN_ON(!zone))
> -		return &zmd->dev[0];
> -
> -	if (zmd->nr_devs > 1 &&
> -	    zone->id >= zmd->dev[1].zone_offset)
> -		return &zmd->dev[1];
> -
> -	return &zmd->dev[0];
> -}
> -
>  unsigned int dmz_zone_nr_blocks(struct dmz_metadata *zmd)
>  {
>  	return zmd->zone_nr_blocks;
> @@ -333,7 +315,7 @@ static struct dm_zone *dmz_get(struct dmz_metadata *zmd, unsigned int zone_id)
>  }
>  
>  static struct dm_zone *dmz_insert(struct dmz_metadata *zmd,
> -				  unsigned int zone_id)
> +				  unsigned int zone_id, struct dmz_dev *dev)
>  {
>  	struct dm_zone *zone = kzalloc(sizeof(struct dm_zone), GFP_KERNEL);
>  
> @@ -347,6 +329,7 @@ static struct dm_zone *dmz_insert(struct dmz_metadata *zmd,
>  	atomic_set(&zone->refcount, 0);
>  	zone->id = zone_id;
>  	zone->chunk = DMZ_MAP_UNMAPPED;
> +	zone->dev = dev;
>  
>  	return zone;
>  }
> @@ -1271,7 +1254,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
>  
>  	/* Read and check the primary super block */
>  	zmd->sb[0].block = dmz_start_block(zmd, zmd->sb[0].zone);
> -	zmd->sb[0].dev = dmz_zone_to_dev(zmd, zmd->sb[0].zone);
> +	zmd->sb[0].dev = zmd->sb[0].zone->dev;
>  	ret = dmz_get_sb(zmd, &zmd->sb[0], 0);
>  	if (ret) {
>  		dmz_dev_err(zmd->sb[0].dev, "Read primary super block failed");
> @@ -1388,7 +1371,7 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int num, void *data)
>  	int idx = num + dev->zone_offset;
>  	struct dm_zone *zone;
>  
> -	zone = dmz_insert(zmd, idx);
> +	zone = dmz_insert(zmd, idx, dev);
>  	if (IS_ERR(zone))
>  		return PTR_ERR(zone);
>  
> @@ -1452,7 +1435,7 @@ static int dmz_emulate_zones(struct dmz_metadata *zmd, struct dmz_dev *dev)
>  	for(idx = 0; idx < dev->nr_zones; idx++) {
>  		struct dm_zone *zone;
>  
> -		zone = dmz_insert(zmd, idx);
> +		zone = dmz_insert(zmd, idx, dev);
>  		if (IS_ERR(zone))
>  			return PTR_ERR(zone);
>  		set_bit(DMZ_CACHE, &zone->flags);
> @@ -1578,7 +1561,7 @@ static int dmz_update_zone_cb(struct blk_zone *blkz, unsigned int idx,
>   */
>  static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
>  {
> -	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
> +	struct dmz_dev *dev = zone->dev;
>  	unsigned int noio_flag;
>  	int ret;
>  
> @@ -1615,7 +1598,7 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
>  static int dmz_handle_seq_write_err(struct dmz_metadata *zmd,
>  				    struct dm_zone *zone)
>  {
> -	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
> +	struct dmz_dev *dev = zone->dev;
>  	unsigned int wp = 0;
>  	int ret;
>  
> @@ -1652,7 +1635,7 @@ static int dmz_reset_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
>  		return 0;
>  
>  	if (!dmz_is_empty(zone) || dmz_seq_write_err(zone)) {
> -		struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
> +		struct dmz_dev *dev = zone->dev;
>  
>  		ret = blkdev_zone_mgmt(dev->bdev, REQ_OP_ZONE_RESET,
>  				       dmz_start_sect(zmd, zone),
> @@ -2213,9 +2196,7 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
>  		goto again;
>  	}
>  	if (dmz_is_meta(zone)) {
> -		struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
> -
> -		dmz_dev_warn(dev, "Zone %u has metadata", zone->id);
> +		dmz_zmd_warn(zmd, "Zone %u has metadata", zone->id);
>  		zone = NULL;
>  		goto again;
>  	}
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index fd4d47dfcea1..e9e3b730e258 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -58,7 +58,7 @@ static int dmz_reclaim_align_wp(struct dmz_reclaim *zrc, struct dm_zone *zone,
>  				sector_t block)
>  {
>  	struct dmz_metadata *zmd = zrc->metadata;
> -	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
> +	struct dmz_dev *dev = zone->dev;
>  	sector_t wp_block = zone->wp_block;
>  	unsigned int nr_blocks;
>  	int ret;
> @@ -116,7 +116,6 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
>  			    struct dm_zone *src_zone, struct dm_zone *dst_zone)
>  {
>  	struct dmz_metadata *zmd = zrc->metadata;
> -	struct dmz_dev *src_dev, *dst_dev;
>  	struct dm_io_region src, dst;
>  	sector_t block = 0, end_block;
>  	sector_t nr_blocks;
> @@ -130,17 +129,15 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
>  	else
>  		end_block = dmz_zone_nr_blocks(zmd);
>  	src_zone_block = dmz_start_block(zmd, src_zone);
> -	src_dev = dmz_zone_to_dev(zmd, src_zone);
>  	dst_zone_block = dmz_start_block(zmd, dst_zone);
> -	dst_dev = dmz_zone_to_dev(zmd, dst_zone);
>  
>  	if (dmz_is_seq(dst_zone))
>  		set_bit(DM_KCOPYD_WRITE_SEQ, &flags);
>  
>  	while (block < end_block) {
> -		if (src_dev->flags & DMZ_BDEV_DYING)
> +		if (src_zone->dev->flags & DMZ_BDEV_DYING)
>  			return -EIO;
> -		if (dst_dev->flags & DMZ_BDEV_DYING)
> +		if (dst_zone->dev->flags & DMZ_BDEV_DYING)
>  			return -EIO;
>  
>  		if (dmz_reclaim_should_terminate(src_zone))
> @@ -163,11 +160,11 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
>  				return ret;
>  		}
>  
> -		src.bdev = src_dev->bdev;
> +		src.bdev = src_zone->dev->bdev;
>  		src.sector = dmz_blk2sect(src_zone_block + block);
>  		src.count = dmz_blk2sect(nr_blocks);
>  
> -		dst.bdev = dst_dev->bdev;
> +		dst.bdev = dst_zone->dev->bdev;
>  		dst.sector = dmz_blk2sect(dst_zone_block + block);
>  		dst.count = src.count;
>  
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 2770e293a97b..087dd4801663 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -123,7 +123,7 @@ static int dmz_submit_bio(struct dmz_target *dmz, struct dm_zone *zone,
>  {
>  	struct dmz_bioctx *bioctx =
>  		dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
> -	struct dmz_dev *dev = dmz_zone_to_dev(dmz->metadata, zone);
> +	struct dmz_dev *dev = zone->dev;
>  	struct bio *clone;
>  
>  	if (dev->flags & DMZ_BDEV_DYING)
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index 3451b5a768b4..316344bf07bd 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -80,6 +80,9 @@ struct dm_zone {
>  	/* For listing the zone depending on its state */
>  	struct list_head	link;
>  
> +	/* Device containing this zone */
> +	struct dmz_dev		*dev;
> +
>  	/* Zone type and state */
>  	unsigned long		flags;
>  
> @@ -190,7 +193,6 @@ const char *dmz_metadata_label(struct dmz_metadata *zmd);
>  sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone);
>  sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone);
>  unsigned int dmz_nr_chunks(struct dmz_metadata *zmd);
> -struct dmz_dev *dmz_zone_to_dev(struct dmz_metadata *zmd, struct dm_zone *zone);
>  
>  bool dmz_check_dev(struct dmz_metadata *zmd);
>  bool dmz_dev_is_dying(struct dmz_metadata *zmd);
> 

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
