From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH] dm-zoned: support zone sizes smaller than
	128MiB
Date: Wed, 25 Dec 2019 04:33:47 +0000
Message-ID: <BYAPR04MB58164CDACE14A503D4B6A72FE7280@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191224010546.20532-1-dmitry.fomichev@wdc.com>
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

On 2019/12/24 10:05, Dmitry Fomichev wrote:
> dm-zoned is observed to log failed kernel assertions and not to work
> correctly when operating against a device with a zone size smaller
> than 128MiB (4K block size times 32768 bits per 4K block). The reason
> is that the bitmap size per zone is calculated as zero with such a
> small zone size. This patch fixes this problem and also makes the code
> related to zone bitmap management be able to handle per zone bitmaps
> smaller than a single block.
> 
> A dm-zoned-tools patch is required to properly format dm-zoned devices
> with zone sizes smaller than 128MiB and this patch is being posted
> separately.
> 
> Fixes: 3b1a94c88b79 ("dm zoned: drive-managed zoned block device target")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>


> ---
>  drivers/md/dm-zoned-metadata.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 069e4675da6b..91512eb40458 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -134,6 +134,7 @@ struct dmz_metadata {
>  
>  	sector_t		zone_bitmap_size;
>  	unsigned int		zone_nr_bitmap_blocks;
> +	unsigned int		zone_bits_per_mblk;
>  
>  	unsigned int		nr_bitmap_blocks;
>  	unsigned int		nr_map_blocks;
> @@ -1153,7 +1154,10 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
>  
>  	/* Init */
>  	zmd->zone_bitmap_size = dev->zone_nr_blocks >> 3;
> -	zmd->zone_nr_bitmap_blocks = zmd->zone_bitmap_size >> DMZ_BLOCK_SHIFT;
> +	zmd->zone_nr_bitmap_blocks =
> +		max_t(sector_t, 1, zmd->zone_bitmap_size >> DMZ_BLOCK_SHIFT);
> +	zmd->zone_bits_per_mblk = min_t(sector_t, dev->zone_nr_blocks,
> +					DMZ_BLOCK_SIZE_BITS);
>  
>  	/* Allocate zone array */
>  	zmd->zones = kcalloc(dev->nr_zones, sizeof(struct dm_zone), GFP_KERNEL);
> @@ -1947,7 +1951,7 @@ int dmz_copy_valid_blocks(struct dmz_metadata *zmd, struct dm_zone *from_zone,
>  		dmz_release_mblock(zmd, to_mblk);
>  		dmz_release_mblock(zmd, from_mblk);
>  
> -		chunk_block += DMZ_BLOCK_SIZE_BITS;
> +		chunk_block += zmd->zone_bits_per_mblk;
>  	}
>  
>  	to_zone->weight = from_zone->weight;
> @@ -2008,7 +2012,7 @@ int dmz_validate_blocks(struct dmz_metadata *zmd, struct dm_zone *zone,
>  
>  		/* Set bits */
>  		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
> -		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
> +		nr_bits = min(nr_blocks, zmd->zone_bits_per_mblk - bit);
>  
>  		count = dmz_set_bits((unsigned long *)mblk->data, bit, nr_bits);
>  		if (count) {
> @@ -2087,7 +2091,7 @@ int dmz_invalidate_blocks(struct dmz_metadata *zmd, struct dm_zone *zone,
>  
>  		/* Clear bits */
>  		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
> -		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
> +		nr_bits = min(nr_blocks, zmd->zone_bits_per_mblk - bit);
>  
>  		count = dmz_clear_bits((unsigned long *)mblk->data,
>  				       bit, nr_bits);
> @@ -2147,6 +2151,7 @@ static int dmz_to_next_set_block(struct dmz_metadata *zmd, struct dm_zone *zone,
>  {
>  	struct dmz_mblock *mblk;
>  	unsigned int bit, set_bit, nr_bits;
> +	unsigned int zone_bits = zmd->zone_bits_per_mblk;
>  	unsigned long *bitmap;
>  	int n = 0;
>  
> @@ -2161,15 +2166,15 @@ static int dmz_to_next_set_block(struct dmz_metadata *zmd, struct dm_zone *zone,
>  		/* Get offset */
>  		bitmap = (unsigned long *) mblk->data;
>  		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
> -		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
> +		nr_bits = min(nr_blocks, zone_bits - bit);
>  		if (set)
> -			set_bit = find_next_bit(bitmap, DMZ_BLOCK_SIZE_BITS, bit);
> +			set_bit = find_next_bit(bitmap, zone_bits, bit);
>  		else
> -			set_bit = find_next_zero_bit(bitmap, DMZ_BLOCK_SIZE_BITS, bit);
> +			set_bit = find_next_zero_bit(bitmap, zone_bits, bit);
>  		dmz_release_mblock(zmd, mblk);
>  
>  		n += set_bit - bit;
> -		if (set_bit < DMZ_BLOCK_SIZE_BITS)
> +		if (set_bit < zone_bits)
>  			break;
>  
>  		nr_blocks -= nr_bits;
> @@ -2272,7 +2277,7 @@ static void dmz_get_zone_weight(struct dmz_metadata *zmd, struct dm_zone *zone)
>  		/* Count bits in this block */
>  		bitmap = mblk->data;
>  		bit = chunk_block & DMZ_BLOCK_MASK_BITS;
> -		nr_bits = min(nr_blocks, DMZ_BLOCK_SIZE_BITS - bit);
> +		nr_bits = min(nr_blocks, zmd->zone_bits_per_mblk - bit);
>  		n += dmz_count_bits(bitmap, bit, nr_bits);
>  
>  		dmz_release_mblock(zmd, mblk);
> 


-- 
Damien Le Moal
Western Digital Research
