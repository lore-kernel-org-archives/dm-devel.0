From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 06/14] dm-zoned: temporary superblock for
	tertiary devices
Date: Sun, 31 May 2020 08:58:04 +0000
Message-ID: <736581c9a278556850b70a078980361212f155ca.camel@wdc.com>
References: <20200529173907.40529-1-hare@suse.de>
	<20200529173907.40529-7-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200529173907.40529-7-hare@suse.de>
Content-Language: en-US
Content-ID: <5CB640D3D23644448945C395EB7DBB08@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>, "hare@suse.de" <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Fri, 2020-05-29 at 19:38 +0200, Hannes Reinecke wrote:
> Checking the tertiary superblock just consists of validating UUIDs,
> crcs, and the generation number; it doesn't have contents which
> would be required during the actual operation.
> So we should be allocating a temporary superblock when checking
> tertiary devices and avoid having to store it together with the
> 'real' superblocks.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 109 +++++++++++++++++++++++------------------
>  1 file changed, 61 insertions(+), 48 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 839f9078806d..d9f3ecc76eff 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -174,7 +174,7 @@ struct dmz_metadata {
>  	/* Zone information array */
>  	struct xarray		zones;
>  
> -	struct dmz_sb		sb[3];
> +	struct dmz_sb		sb[2];
>  	unsigned int		mblk_primary;
>  	unsigned int		sb_version;
>  	u64			sb_gen;
> @@ -1014,10 +1014,11 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
>  /*
>   * Check super block.
>   */
> -static int dmz_check_sb(struct dmz_metadata *zmd, unsigned int set)
> +static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_sb *dsb,
> +			bool tertiary)
>  {
> -	struct dmz_super *sb = zmd->sb[set].sb;
> -	struct dmz_dev *dev = zmd->sb[set].dev;
> +	struct dmz_super *sb = dsb->sb;
> +	struct dmz_dev *dev = dsb->dev;
>  	unsigned int nr_meta_zones, nr_data_zones;
>  	u32 crc, stored_crc;
>  	u64 gen;
> @@ -1034,7 +1035,7 @@ static int dmz_check_sb(struct dmz_metadata *zmd, unsigned int set)
>  			    DMZ_META_VER, zmd->sb_version);
>  		return -EINVAL;
>  	}
> -	if ((zmd->sb_version < 1) && (set == 2)) {
> +	if (zmd->sb_version < 2 && tertiary) {
>  		dmz_dev_err(dev, "Tertiary superblocks are not supported");
>  		return -EINVAL;
>  	}
> @@ -1078,7 +1079,7 @@ static int dmz_check_sb(struct dmz_metadata *zmd, unsigned int set)
>  			return -ENXIO;
>  		}
>  
> -		if (set == 2) {
> +		if (tertiary) {
>  			/*
>  			 * Generation number should be 0, but it doesn't
>  			 * really matter if it isn't.
> @@ -1127,14 +1128,13 @@ static int dmz_check_sb(struct dmz_metadata *zmd, unsigned int set)
>  /*
>   * Read the first or second super block from disk.
>   */
> -static int dmz_read_sb(struct dmz_metadata *zmd, unsigned int set)
> +static int dmz_read_sb(struct dmz_metadata *zmd, struct dmz_sb *sb, int set)
>  {
>  	dmz_zmd_debug(zmd, "read superblock set %d dev %s block %llu",
> -		      set, zmd->sb[set].dev->name,
> -		      zmd->sb[set].block);
> +		      set, sb->dev->name, sb->block);
>  
> -	return dmz_rdwr_block(zmd->sb[set].dev, REQ_OP_READ,
> -			      zmd->sb[set].block, zmd->sb[set].mblk->page);
> +	return dmz_rdwr_block(sb->dev, REQ_OP_READ,
> +			      sb->block, sb->mblk->page);
>  }
>  
>  /*
> @@ -1162,7 +1162,7 @@ static int dmz_lookup_secondary_sb(struct dmz_metadata *zmd)
>  	zmd->sb[1].zone = dmz_get(zmd, zone_id + 1);
>  	zmd->sb[1].dev = zmd->sb[0].dev;
>  	for (i = 1; i < zmd->nr_rnd_zones; i++) {
> -		if (dmz_read_sb(zmd, 1) != 0)
> +		if (dmz_read_sb(zmd, &zmd->sb[1], 1) != 0)
>  			break;
>  		if (le32_to_cpu(zmd->sb[1].sb->magic) == DMZ_MAGIC)
>  			return 0;
> @@ -1179,9 +1179,9 @@ static int dmz_lookup_secondary_sb(struct dmz_metadata *zmd)
>  }
>  
>  /*
> - * Read the first or second super block from disk.
> + * Read a super block from disk.
>   */
> -static int dmz_get_sb(struct dmz_metadata *zmd, unsigned int set)
> +static int dmz_get_sb(struct dmz_metadata *zmd, struct dmz_sb *sb, int set)
>  {
>  	struct dmz_mblock *mblk;
>  	int ret;
> @@ -1191,14 +1191,14 @@ static int dmz_get_sb(struct dmz_metadata *zmd, unsigned int set)
>  	if (!mblk)
>  		return -ENOMEM;
>  
> -	zmd->sb[set].mblk = mblk;
> -	zmd->sb[set].sb = mblk->data;
> +	sb->mblk = mblk;
> +	sb->sb = mblk->data;
>  
>  	/* Read super block */
> -	ret = dmz_read_sb(zmd, set);
> +	ret = dmz_read_sb(zmd, sb, set);
>  	if (ret) {
>  		dmz_free_mblock(zmd, mblk);
> -		zmd->sb[set].mblk = NULL;
> +		sb->mblk = NULL;
>  		return ret;
>  	}
>  
> @@ -1272,13 +1272,13 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
>  	/* Read and check the primary super block */
>  	zmd->sb[0].block = dmz_start_block(zmd, zmd->sb[0].zone);
>  	zmd->sb[0].dev = dmz_zone_to_dev(zmd, zmd->sb[0].zone);
> -	ret = dmz_get_sb(zmd, 0);
> +	ret = dmz_get_sb(zmd, &zmd->sb[0], 0);
>  	if (ret) {
>  		dmz_dev_err(zmd->sb[0].dev, "Read primary super block failed");
>  		return ret;
>  	}
>  
> -	ret = dmz_check_sb(zmd, 0);
> +	ret = dmz_check_sb(zmd, &zmd->sb[0], false);
>  
>  	/* Read and check secondary super block */
>  	if (ret == 0) {
> @@ -1291,7 +1291,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
>  		}
>  		zmd->sb[1].block = dmz_start_block(zmd, zmd->sb[1].zone);
>  		zmd->sb[1].dev = zmd->sb[0].dev;
> -		ret = dmz_get_sb(zmd, 1);
> +		ret = dmz_get_sb(zmd, &zmd->sb[1], 1);
>  	} else
>  		ret = dmz_lookup_secondary_sb(zmd);
>  
> @@ -1300,7 +1300,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
>  		return ret;
>  	}
>  
> -	ret = dmz_check_sb(zmd, 1);
> +	ret = dmz_check_sb(zmd, &zmd->sb[1], false);
>  	if (ret == 0)
>  		sb_good[1] = true;
>  
> @@ -1345,20 +1345,40 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
>  		      "Using super block %u (gen %llu)",
>  		      zmd->mblk_primary, zmd->sb_gen);
>  
> -	if ((zmd->sb_version > 1) && zmd->sb[2].zone) {
> -		zmd->sb[2].block = dmz_start_block(zmd, zmd->sb[2].zone);
> -		zmd->sb[2].dev = dmz_zone_to_dev(zmd, zmd->sb[2].zone);
> -		ret = dmz_get_sb(zmd, 2);
> -		if (ret) {
> -			dmz_dev_err(zmd->sb[2].dev,
> -				    "Read tertiary super block failed");
> -			return ret;
> +	if (zmd->sb_version > 1) {
> +		int i;
> +		struct dmz_sb *sb;
> +
> +		sb = kzalloc(sizeof(struct dmz_sb), GFP_KERNEL);
> +		if (!sb)
> +			return -ENOMEM;
> +		for (i = 1; i < zmd->nr_devs; i++) {
> +			sb->block = 0;
> +			sb->zone = dmz_get(zmd, zmd->dev[i].zone_offset);
> +			sb->dev = &zmd->dev[i];
> +			if (!dmz_is_meta(sb->zone)) {
> +				dmz_dev_err(sb->dev,
> +					    "Tertiary super block zone %u not marked as metadata zone",
> +					    sb->zone->id);
> +				ret = -EINVAL;
> +				goto out_kfree;
> +			}
> +			ret = dmz_get_sb(zmd, sb, i + 1);
> +			if (ret) {
> +				dmz_dev_err(sb->dev,
> +					    "Read tertiary super block failed");
> +				dmz_free_mblock(zmd, sb->mblk);
> +				goto out_kfree;
> +			}
> +			ret = dmz_check_sb(zmd, sb, true);
> +			dmz_free_mblock(zmd, sb->mblk);
> +			if (ret == -EINVAL)
> +				goto out_kfree;
>  		}
> -		ret = dmz_check_sb(zmd, 2);
> -		if (ret == -EINVAL)
> -			return ret;
> +	out_kfree:
> +		kfree(sb);
>  	}
> -	return 0;
> +	return ret;
>  }
>  
>  /*
> @@ -1415,12 +1435,15 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int num, void *data)
>  				zmd->sb[0].zone = zone;
>  			}
>  		}
> -		if (zmd->nr_devs > 1 && !zmd->sb[2].zone) {
> -			/* Tertiary superblock zone */
> -			zmd->sb[2].zone = zone;
> +		if (zmd->nr_devs > 1 && num == 0) {
> +			/*
> +			 * Tertiary superblock zones are always at the
> +			 * start of the zoned devices, so mark them
> +			 * as metadata zone.
> +			 */
> +			set_bit(DMZ_META, &zone->flags);
>  		}
>  	}
> -
>  	return 0;
>  }
>  
> @@ -2858,16 +2881,6 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
>  		}
>  		set_bit(DMZ_META, &zone->flags);
>  	}
> -	if (zmd->sb[2].zone) {
> -		zone = dmz_get(zmd, zmd->sb[2].zone->id);
> -		if (!zone) {
> -			dmz_zmd_err(zmd,
> -				    "Tertiary metadata zone not present");
> -			ret = -ENXIO;
> -			goto err;
> -		}
> -		set_bit(DMZ_META, &zone->flags);
> -	}
>  	/* Load mapping table */
>  	ret = dmz_load_mapping(zmd);
>  	if (ret)

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>


-- 
Damien Le Moal
Western Digital Research
