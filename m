From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 08/11] dm-zoned: use dmz_zone_to_dev() when
 handling metadata I/O
Date: Tue, 7 Apr 2020 02:52:50 +0000
Message-ID: <BY5PR04MB6900030603C2AD019DDC04E7E7C30@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200406143505.133271-1-hare@suse.de>
	<20200406143505.133271-9-hare@suse.de>
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
> Use accessors to retrieve the device pointer in preparation
> for adding an additional block device.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Looks OK.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

> ---
>  drivers/md/dm-zoned-metadata.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 9919aa6210c1..08707c886ca2 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1310,6 +1310,7 @@ static int dmz_update_zone_cb(struct blk_zone *blkz, unsigned int idx,
>   */
>  static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
>  {
> +	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
>  	unsigned int noio_flag;
>  	int ret;
>  
> @@ -1320,16 +1321,16 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
>  	 * GFP_NOIO was specified.
>  	 */
>  	noio_flag = memalloc_noio_save();
> -	ret = blkdev_report_zones(zmd->dev->bdev, dmz_start_sect(zmd, zone), 1,
> +	ret = blkdev_report_zones(dev->bdev, dmz_start_sect(zmd, zone), 1,
>  				  dmz_update_zone_cb, zone);
>  	memalloc_noio_restore(noio_flag);
>  
>  	if (ret == 0)
>  		ret = -EIO;
>  	if (ret < 0) {
> -		dmz_dev_err(zmd->dev, "Get zone %u report failed",
> +		dmz_dev_err(dev, "Get zone %u report failed",
>  			    dmz_id(zmd, zone));
> -		dmz_check_bdev(zmd->dev);
> +		dmz_check_bdev(dev);
>  		return ret;
>  	}
>  
> @@ -1343,6 +1344,7 @@ static int dmz_update_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
>  static int dmz_handle_seq_write_err(struct dmz_metadata *zmd,
>  				    struct dm_zone *zone)
>  {
> +	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
>  	unsigned int wp = 0;
>  	int ret;
>  
> @@ -1351,7 +1353,7 @@ static int dmz_handle_seq_write_err(struct dmz_metadata *zmd,
>  	if (ret)
>  		return ret;
>  
> -	dmz_dev_warn(zmd->dev, "Processing zone %u write error (zone wp %u/%u)",
> +	dmz_dev_warn(dev, "Processing zone %u write error (zone wp %u/%u)",
>  		     dmz_id(zmd, zone), zone->wp_block, wp);
>  
>  	if (zone->wp_block < wp) {
> @@ -1384,7 +1386,7 @@ static int dmz_reset_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
>  		return 0;
>  
>  	if (!dmz_is_empty(zone) || dmz_seq_write_err(zone)) {
> -		struct dmz_dev *dev = zmd->dev;
> +		struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
>  
>  		ret = blkdev_zone_mgmt(dev->bdev, REQ_OP_ZONE_RESET,
>  				       dmz_start_sect(zmd, zone),
> @@ -2098,12 +2100,13 @@ int dmz_merge_valid_blocks(struct dmz_metadata *zmd, struct dm_zone *from_zone,
>  int dmz_validate_blocks(struct dmz_metadata *zmd, struct dm_zone *zone,
>  			sector_t chunk_block, unsigned int nr_blocks)
>  {
> +	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
>  	unsigned int count, bit, nr_bits;
>  	unsigned int zone_nr_blocks = zmd->zone_nr_blocks;
>  	struct dmz_mblock *mblk;
>  	unsigned int n = 0;
>  
> -	dmz_dev_debug(zmd->dev, "=> VALIDATE zone %u, block %llu, %u blocks",
> +	dmz_dev_debug(dev, "=> VALIDATE zone %u, block %llu, %u blocks",
>  		      dmz_id(zmd, zone), (unsigned long long)chunk_block,
>  		      nr_blocks);
>  
> @@ -2133,7 +2136,7 @@ int dmz_validate_blocks(struct dmz_metadata *zmd, struct dm_zone *zone,
>  	if (likely(zone->weight + n <= zone_nr_blocks))
>  		zone->weight += n;
>  	else {
> -		dmz_dev_warn(zmd->dev, "Zone %u: weight %u should be <= %u",
> +		dmz_dev_warn(dev, "Zone %u: weight %u should be <= %u",
>  			     dmz_id(zmd, zone), zone->weight,
>  			     zone_nr_blocks - n);
>  		zone->weight = zone_nr_blocks;
> @@ -2179,11 +2182,12 @@ static int dmz_clear_bits(unsigned long *bitmap, int bit, int nr_bits)
>  int dmz_invalidate_blocks(struct dmz_metadata *zmd, struct dm_zone *zone,
>  			  sector_t chunk_block, unsigned int nr_blocks)
>  {
> +	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
>  	unsigned int count, bit, nr_bits;
>  	struct dmz_mblock *mblk;
>  	unsigned int n = 0;
>  
> -	dmz_dev_debug(zmd->dev, "=> INVALIDATE zone %u, block %llu, %u blocks",
> +	dmz_dev_debug(dev, "=> INVALIDATE zone %u, block %llu, %u blocks",
>  		      dmz_id(zmd, zone), (u64)chunk_block, nr_blocks);
>  
>  	WARN_ON(chunk_block + nr_blocks > zmd->zone_nr_blocks);
> @@ -2213,7 +2217,7 @@ int dmz_invalidate_blocks(struct dmz_metadata *zmd, struct dm_zone *zone,
>  	if (zone->weight >= n)
>  		zone->weight -= n;
>  	else {
> -		dmz_dev_warn(zmd->dev, "Zone %u: weight %u should be >= %u",
> +		dmz_dev_warn(dev, "Zone %u: weight %u should be >= %u",
>  			     dmz_id(zmd, zone), zone->weight, n);
>  		zone->weight = 0;
>  	}
> 


-- 
Damien Le Moal
Western Digital Research
