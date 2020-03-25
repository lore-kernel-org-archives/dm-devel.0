From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2 1/3] dm zoned: rename dev name to zoned_dev
Date: Wed, 25 Mar 2020 06:29:47 +0000
Message-ID: <CO2PR04MB234331E3605FE801A7696FBDE7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200324110255.8385-1-bob.liu@oracle.com>
 <20200324110255.8385-2-bob.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "hare@suse.de" <hare@suse.de>
List-Id: dm-devel.ids

On 2020/03/24 20:03, Bob Liu wrote:=0A=
> This is a prepare patch, no function change.=0A=
> Since will introduce regular device, rename dev name to zoned_dev to=0A=
> make things clear.=0A=
=0A=
zdev would be shorter and as explicit I think.=0A=
=0A=
> =0A=
> Signed-off-by: Bob Liu <bob.liu@oracle.com>=0A=
> ---=0A=
>  drivers/md/dm-zoned-metadata.c | 112 ++++++++++++++++++++---------------=
------=0A=
>  drivers/md/dm-zoned-target.c   |  62 +++++++++++------------=0A=
>  2 files changed, 87 insertions(+), 87 deletions(-)=0A=
> =0A=
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadat=
a.c=0A=
> index 369de15..e0e8be0 100644=0A=
> --- a/drivers/md/dm-zoned-metadata.c=0A=
> +++ b/drivers/md/dm-zoned-metadata.c=0A=
> @@ -130,7 +130,7 @@ struct dmz_sb {=0A=
>   * In-memory metadata.=0A=
>   */=0A=
>  struct dmz_metadata {=0A=
> -	struct dmz_dev		*dev;=0A=
> +	struct dmz_dev		*zoned_dev;=0A=
>  =0A=
>  	sector_t		zone_bitmap_size;=0A=
>  	unsigned int		zone_nr_bitmap_blocks;=0A=
> @@ -194,12 +194,12 @@ unsigned int dmz_id(struct dmz_metadata *zmd, struc=
t dm_zone *zone)=0A=
>  =0A=
>  sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone)=
=0A=
>  {=0A=
> -	return (sector_t)dmz_id(zmd, zone) << zmd->dev->zone_nr_sectors_shift;=
=0A=
> +	return (sector_t)dmz_id(zmd, zone) << zmd->zoned_dev->zone_nr_sectors_s=
hift;=0A=
>  }=0A=
>  =0A=
>  sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone)=
=0A=
>  {=0A=
> -	return (sector_t)dmz_id(zmd, zone) << zmd->dev->zone_nr_blocks_shift;=
=0A=
> +	return (sector_t)dmz_id(zmd, zone) << zmd->zoned_dev->zone_nr_blocks_sh=
ift;=0A=
>  }=0A=
>  =0A=
>  unsigned int dmz_nr_chunks(struct dmz_metadata *zmd)=0A=
> @@ -404,7 +404,7 @@ static struct dmz_mblock *dmz_get_mblock_slow(struct =
dmz_metadata *zmd,=0A=
>  	sector_t block =3D zmd->sb[zmd->mblk_primary].block + mblk_no;=0A=
>  	struct bio *bio;=0A=
>  =0A=
> -	if (dmz_bdev_is_dying(zmd->dev))=0A=
> +	if (dmz_bdev_is_dying(zmd->zoned_dev))=0A=
>  		return ERR_PTR(-EIO);=0A=
>  =0A=
>  	/* Get a new block and a BIO to read it */=0A=
> @@ -440,7 +440,7 @@ static struct dmz_mblock *dmz_get_mblock_slow(struct =
dmz_metadata *zmd,=0A=
>  =0A=
>  	/* Submit read BIO */=0A=
>  	bio->bi_iter.bi_sector =3D dmz_blk2sect(block);=0A=
> -	bio_set_dev(bio, zmd->dev->bdev);=0A=
> +	bio_set_dev(bio, zmd->zoned_dev->bdev);=0A=
>  	bio->bi_private =3D mblk;=0A=
>  	bio->bi_end_io =3D dmz_mblock_bio_end_io;=0A=
>  	bio_set_op_attrs(bio, REQ_OP_READ, REQ_META | REQ_PRIO);=0A=
> @@ -555,7 +555,7 @@ static struct dmz_mblock *dmz_get_mblock(struct dmz_m=
etadata *zmd,=0A=
>  		       TASK_UNINTERRUPTIBLE);=0A=
>  	if (test_bit(DMZ_META_ERROR, &mblk->state)) {=0A=
>  		dmz_release_mblock(zmd, mblk);=0A=
> -		dmz_check_bdev(zmd->dev);=0A=
> +		dmz_check_bdev(zmd->zoned_dev);=0A=
>  		return ERR_PTR(-EIO);=0A=
>  	}=0A=
>  =0A=
> @@ -582,7 +582,7 @@ static int dmz_write_mblock(struct dmz_metadata *zmd,=
 struct dmz_mblock *mblk,=0A=
>  	sector_t block =3D zmd->sb[set].block + mblk->no;=0A=
>  	struct bio *bio;=0A=
>  =0A=
> -	if (dmz_bdev_is_dying(zmd->dev))=0A=
> +	if (dmz_bdev_is_dying(zmd->zoned_dev))=0A=
>  		return -EIO;=0A=
>  =0A=
>  	bio =3D bio_alloc(GFP_NOIO, 1);=0A=
> @@ -594,7 +594,7 @@ static int dmz_write_mblock(struct dmz_metadata *zmd,=
 struct dmz_mblock *mblk,=0A=
>  	set_bit(DMZ_META_WRITING, &mblk->state);=0A=
>  =0A=
>  	bio->bi_iter.bi_sector =3D dmz_blk2sect(block);=0A=
> -	bio_set_dev(bio, zmd->dev->bdev);=0A=
> +	bio_set_dev(bio, zmd->zoned_dev->bdev);=0A=
>  	bio->bi_private =3D mblk;=0A=
>  	bio->bi_end_io =3D dmz_mblock_bio_end_io;=0A=
>  	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_META | REQ_PRIO);=0A=
> @@ -613,7 +613,7 @@ static int dmz_rdwr_block(struct dmz_metadata *zmd, i=
nt op, sector_t block,=0A=
>  	struct bio *bio;=0A=
>  	int ret;=0A=
>  =0A=
> -	if (dmz_bdev_is_dying(zmd->dev))=0A=
> +	if (dmz_bdev_is_dying(zmd->zoned_dev))=0A=
>  		return -EIO;=0A=
>  =0A=
>  	bio =3D bio_alloc(GFP_NOIO, 1);=0A=
> @@ -621,14 +621,14 @@ static int dmz_rdwr_block(struct dmz_metadata *zmd,=
 int op, sector_t block,=0A=
>  		return -ENOMEM;=0A=
>  =0A=
>  	bio->bi_iter.bi_sector =3D dmz_blk2sect(block);=0A=
> -	bio_set_dev(bio, zmd->dev->bdev);=0A=
> +	bio_set_dev(bio, zmd->zoned_dev->bdev);=0A=
>  	bio_set_op_attrs(bio, op, REQ_SYNC | REQ_META | REQ_PRIO);=0A=
>  	bio_add_page(bio, page, DMZ_BLOCK_SIZE, 0);=0A=
>  	ret =3D submit_bio_wait(bio);=0A=
>  	bio_put(bio);=0A=
>  =0A=
>  	if (ret)=0A=
> -		dmz_check_bdev(zmd->dev);=0A=
> +		dmz_check_bdev(zmd->zoned_dev);=0A=
>  	return ret;=0A=
>  }=0A=
>  =0A=
> @@ -661,7 +661,7 @@ static int dmz_write_sb(struct dmz_metadata *zmd, uns=
igned int set)=0A=
>  =0A=
>  	ret =3D dmz_rdwr_block(zmd, REQ_OP_WRITE, block, mblk->page);=0A=
>  	if (ret =3D=3D 0)=0A=
> -		ret =3D blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO, NULL);=0A=
> +		ret =3D blkdev_issue_flush(zmd->zoned_dev->bdev, GFP_NOIO, NULL);=0A=
>  =0A=
>  	return ret;=0A=
>  }=0A=
> @@ -695,7 +695,7 @@ static int dmz_write_dirty_mblocks(struct dmz_metadat=
a *zmd,=0A=
>  			       TASK_UNINTERRUPTIBLE);=0A=
>  		if (test_bit(DMZ_META_ERROR, &mblk->state)) {=0A=
>  			clear_bit(DMZ_META_ERROR, &mblk->state);=0A=
> -			dmz_check_bdev(zmd->dev);=0A=
> +			dmz_check_bdev(zmd->zoned_dev);=0A=
>  			ret =3D -EIO;=0A=
>  		}=0A=
>  		nr_mblks_submitted--;=0A=
> @@ -703,7 +703,7 @@ static int dmz_write_dirty_mblocks(struct dmz_metadat=
a *zmd,=0A=
>  =0A=
>  	/* Flush drive cache (this will also sync data) */=0A=
>  	if (ret =3D=3D 0)=0A=
> -		ret =3D blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO, NULL);=0A=
> +		ret =3D blkdev_issue_flush(zmd->zoned_dev->bdev, GFP_NOIO, NULL);=0A=
>  =0A=
>  	return ret;=0A=
>  }=0A=
> @@ -760,7 +760,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)=0A=
>  	 */=0A=
>  	dmz_lock_flush(zmd);=0A=
>  =0A=
> -	if (dmz_bdev_is_dying(zmd->dev)) {=0A=
> +	if (dmz_bdev_is_dying(zmd->zoned_dev)) {=0A=
>  		ret =3D -EIO;=0A=
>  		goto out;=0A=
>  	}=0A=
> @@ -772,7 +772,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)=0A=
>  =0A=
>  	/* If there are no dirty metadata blocks, just flush the device cache *=
/=0A=
>  	if (list_empty(&write_list)) {=0A=
> -		ret =3D blkdev_issue_flush(zmd->dev->bdev, GFP_NOIO, NULL);=0A=
> +		ret =3D blkdev_issue_flush(zmd->zoned_dev->bdev, GFP_NOIO, NULL);=0A=
>  		goto err;=0A=
>  	}=0A=
>  =0A=
> @@ -821,7 +821,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)=0A=
>  		list_splice(&write_list, &zmd->mblk_dirty_list);=0A=
>  		spin_unlock(&zmd->mblk_lock);=0A=
>  	}=0A=
> -	if (!dmz_check_bdev(zmd->dev))=0A=
> +	if (!dmz_check_bdev(zmd->zoned_dev))=0A=
>  		ret =3D -EIO;=0A=
>  	goto out;=0A=
>  }=0A=
> @@ -832,7 +832,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)=0A=
>  static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_super *sb)=
=0A=
>  {=0A=
>  	unsigned int nr_meta_zones, nr_data_zones;=0A=
> -	struct dmz_dev *dev =3D zmd->dev;=0A=
> +	struct dmz_dev *dev =3D zmd->zoned_dev;=0A=
>  	u32 crc, stored_crc;=0A=
>  	u64 gen;=0A=
>  =0A=
> @@ -908,7 +908,7 @@ static int dmz_read_sb(struct dmz_metadata *zmd, unsi=
gned int set)=0A=
>   */=0A=
>  static int dmz_lookup_secondary_sb(struct dmz_metadata *zmd)=0A=
>  {=0A=
> -	unsigned int zone_nr_blocks =3D zmd->dev->zone_nr_blocks;=0A=
> +	unsigned int zone_nr_blocks =3D zmd->zoned_dev->zone_nr_blocks;=0A=
>  	struct dmz_mblock *mblk;=0A=
>  	int i;=0A=
>  =0A=
> @@ -972,13 +972,13 @@ static int dmz_recover_mblocks(struct dmz_metadata =
*zmd, unsigned int dst_set)=0A=
>  	struct page *page;=0A=
>  	int i, ret;=0A=
>  =0A=
> -	dmz_dev_warn(zmd->dev, "Metadata set %u invalid: recovering", dst_set);=
=0A=
> +	dmz_dev_warn(zmd->zoned_dev, "Metadata set %u invalid: recovering", dst=
_set);=0A=
>  =0A=
>  	if (dst_set =3D=3D 0)=0A=
>  		zmd->sb[0].block =3D dmz_start_block(zmd, zmd->sb_zone);=0A=
>  	else {=0A=
>  		zmd->sb[1].block =3D zmd->sb[0].block +=0A=
> -			(zmd->nr_meta_zones << zmd->dev->zone_nr_blocks_shift);=0A=
> +			(zmd->nr_meta_zones << zmd->zoned_dev->zone_nr_blocks_shift);=0A=
>  	}=0A=
>  =0A=
>  	page =3D alloc_page(GFP_NOIO);=0A=
> @@ -1027,7 +1027,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)=0A=
>  	zmd->sb[0].block =3D dmz_start_block(zmd, zmd->sb_zone);=0A=
>  	ret =3D dmz_get_sb(zmd, 0);=0A=
>  	if (ret) {=0A=
> -		dmz_dev_err(zmd->dev, "Read primary super block failed");=0A=
> +		dmz_dev_err(zmd->zoned_dev, "Read primary super block failed");=0A=
>  		return ret;=0A=
>  	}=0A=
>  =0A=
> @@ -1037,13 +1037,13 @@ static int dmz_load_sb(struct dmz_metadata *zmd)=
=0A=
>  	if (ret =3D=3D 0) {=0A=
>  		sb_good[0] =3D true;=0A=
>  		zmd->sb[1].block =3D zmd->sb[0].block +=0A=
> -			(zmd->nr_meta_zones << zmd->dev->zone_nr_blocks_shift);=0A=
> +			(zmd->nr_meta_zones << zmd->zoned_dev->zone_nr_blocks_shift);=0A=
>  		ret =3D dmz_get_sb(zmd, 1);=0A=
>  	} else=0A=
>  		ret =3D dmz_lookup_secondary_sb(zmd);=0A=
>  =0A=
>  	if (ret) {=0A=
> -		dmz_dev_err(zmd->dev, "Read secondary super block failed");=0A=
> +		dmz_dev_err(zmd->zoned_dev, "Read secondary super block failed");=0A=
>  		return ret;=0A=
>  	}=0A=
>  =0A=
> @@ -1053,7 +1053,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)=0A=
>  =0A=
>  	/* Use highest generation sb first */=0A=
>  	if (!sb_good[0] && !sb_good[1]) {=0A=
> -		dmz_dev_err(zmd->dev, "No valid super block found");=0A=
> +		dmz_dev_err(zmd->zoned_dev, "No valid super block found");=0A=
>  		return -EIO;=0A=
>  	}=0A=
>  =0A=
> @@ -1068,7 +1068,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)=0A=
>  		ret =3D dmz_recover_mblocks(zmd, 1);=0A=
>  =0A=
>  	if (ret) {=0A=
> -		dmz_dev_err(zmd->dev, "Recovery failed");=0A=
> +		dmz_dev_err(zmd->zoned_dev, "Recovery failed");=0A=
>  		return -EIO;=0A=
>  	}=0A=
>  =0A=
> @@ -1080,7 +1080,7 @@ static int dmz_load_sb(struct dmz_metadata *zmd)=0A=
>  		zmd->mblk_primary =3D 1;=0A=
>  	}=0A=
>  =0A=
> -	dmz_dev_debug(zmd->dev, "Using super block %u (gen %llu)",=0A=
> +	dmz_dev_debug(zmd->zoned_dev, "Using super block %u (gen %llu)",=0A=
>  		      zmd->mblk_primary, zmd->sb_gen);=0A=
>  =0A=
>  	return 0;=0A=
> @@ -1093,7 +1093,7 @@ static int dmz_init_zone(struct blk_zone *blkz, uns=
igned int idx, void *data)=0A=
>  {=0A=
>  	struct dmz_metadata *zmd =3D data;=0A=
>  	struct dm_zone *zone =3D &zmd->zones[idx];=0A=
> -	struct dmz_dev *dev =3D zmd->dev;=0A=
> +	struct dmz_dev *dev =3D zmd->zoned_dev;=0A=
>  =0A=
>  	/* Ignore the eventual last runt (smaller) zone */=0A=
>  	if (blkz->len !=3D dev->zone_nr_sectors) {=0A=
> @@ -1156,7 +1156,7 @@ static void dmz_drop_zones(struct dmz_metadata *zmd=
)=0A=
>   */=0A=
>  static int dmz_init_zones(struct dmz_metadata *zmd)=0A=
>  {=0A=
> -	struct dmz_dev *dev =3D zmd->dev;=0A=
> +	struct dmz_dev *dev =3D zmd->zoned_dev;=0A=
>  	int ret;=0A=
>  =0A=
>  	/* Init */=0A=
> @@ -1223,16 +1223,16 @@ static int dmz_update_zone(struct dmz_metadata *z=
md, struct dm_zone *zone)=0A=
>  	 * GFP_NOIO was specified.=0A=
>  	 */=0A=
>  	noio_flag =3D memalloc_noio_save();=0A=
> -	ret =3D blkdev_report_zones(zmd->dev->bdev, dmz_start_sect(zmd, zone), =
1,=0A=
> +	ret =3D blkdev_report_zones(zmd->zoned_dev->bdev, dmz_start_sect(zmd, z=
one), 1,=0A=
>  				  dmz_update_zone_cb, zone);=0A=
>  	memalloc_noio_restore(noio_flag);=0A=
>  =0A=
>  	if (ret =3D=3D 0)=0A=
>  		ret =3D -EIO;=0A=
>  	if (ret < 0) {=0A=
> -		dmz_dev_err(zmd->dev, "Get zone %u report failed",=0A=
> +		dmz_dev_err(zmd->zoned_dev, "Get zone %u report failed",=0A=
>  			    dmz_id(zmd, zone));=0A=
> -		dmz_check_bdev(zmd->dev);=0A=
> +		dmz_check_bdev(zmd->zoned_dev);=0A=
>  		return ret;=0A=
>  	}=0A=
>  =0A=
> @@ -1254,7 +1254,7 @@ static int dmz_handle_seq_write_err(struct dmz_meta=
data *zmd,=0A=
>  	if (ret)=0A=
>  		return ret;=0A=
>  =0A=
> -	dmz_dev_warn(zmd->dev, "Processing zone %u write error (zone wp %u/%u)"=
,=0A=
> +	dmz_dev_warn(zmd->zoned_dev, "Processing zone %u write error (zone wp %=
u/%u)",=0A=
>  		     dmz_id(zmd, zone), zone->wp_block, wp);=0A=
>  =0A=
>  	if (zone->wp_block < wp) {=0A=
> @@ -1287,7 +1287,7 @@ static int dmz_reset_zone(struct dmz_metadata *zmd,=
 struct dm_zone *zone)=0A=
>  		return 0;=0A=
>  =0A=
>  	if (!dmz_is_empty(zone) || dmz_seq_write_err(zone)) {=0A=
> -		struct dmz_dev *dev =3D zmd->dev;=0A=
> +		struct dmz_dev *dev =3D zmd->zoned_dev;=0A=
>  =0A=
>  		ret =3D blkdev_zone_mgmt(dev->bdev, REQ_OP_ZONE_RESET,=0A=
>  				       dmz_start_sect(zmd, zone),=0A=
> @@ -1313,7 +1313,7 @@ static void dmz_get_zone_weight(struct dmz_metadata=
 *zmd, struct dm_zone *zone);=0A=
>   */=0A=
>  static int dmz_load_mapping(struct dmz_metadata *zmd)=0A=
>  {=0A=
> -	struct dmz_dev *dev =3D zmd->dev;=0A=
> +	struct dmz_dev *dev =3D zmd->zoned_dev;=0A=
>  	struct dm_zone *dzone, *bzone;=0A=
>  	struct dmz_mblock *dmap_mblk =3D NULL;=0A=
>  	struct dmz_map *dmap;=0A=
> @@ -1632,7 +1632,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_me=
tadata *zmd, unsigned int chu=0A=
>  		/* Allocate a random zone */=0A=
>  		dzone =3D dmz_alloc_zone(zmd, DMZ_ALLOC_RND);=0A=
>  		if (!dzone) {=0A=
> -			if (dmz_bdev_is_dying(zmd->dev)) {=0A=
> +			if (dmz_bdev_is_dying(zmd->zoned_dev)) {=0A=
>  				dzone =3D ERR_PTR(-EIO);=0A=
>  				goto out;=0A=
>  			}=0A=
> @@ -1733,7 +1733,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_met=
adata *zmd,=0A=
>  	/* Allocate a random zone */=0A=
>  	bzone =3D dmz_alloc_zone(zmd, DMZ_ALLOC_RND);=0A=
>  	if (!bzone) {=0A=
> -		if (dmz_bdev_is_dying(zmd->dev)) {=0A=
> +		if (dmz_bdev_is_dying(zmd->zoned_dev)) {=0A=
>  			bzone =3D ERR_PTR(-EIO);=0A=
>  			goto out;=0A=
>  		}=0A=
> @@ -1795,7 +1795,7 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata =
*zmd, unsigned long flags)=0A=
>  		atomic_dec(&zmd->unmap_nr_seq);=0A=
>  =0A=
>  	if (dmz_is_offline(zone)) {=0A=
> -		dmz_dev_warn(zmd->dev, "Zone %u is offline", dmz_id(zmd, zone));=0A=
> +		dmz_dev_warn(zmd->zoned_dev, "Zone %u is offline", dmz_id(zmd, zone));=
=0A=
>  		zone =3D NULL;=0A=
>  		goto again;=0A=
>  	}=0A=
> @@ -1943,7 +1943,7 @@ int dmz_copy_valid_blocks(struct dmz_metadata *zmd,=
 struct dm_zone *from_zone,=0A=
>  	sector_t chunk_block =3D 0;=0A=
>  =0A=
>  	/* Get the zones bitmap blocks */=0A=
> -	while (chunk_block < zmd->dev->zone_nr_blocks) {=0A=
> +	while (chunk_block < zmd->zoned_dev->zone_nr_blocks) {=0A=
>  		from_mblk =3D dmz_get_bitmap(zmd, from_zone, chunk_block);=0A=
>  		if (IS_ERR(from_mblk))=0A=
>  			return PTR_ERR(from_mblk);=0A=
> @@ -1978,7 +1978,7 @@ int dmz_merge_valid_blocks(struct dmz_metadata *zmd=
, struct dm_zone *from_zone,=0A=
>  	int ret;=0A=
>  =0A=
>  	/* Get the zones bitmap blocks */=0A=
> -	while (chunk_block < zmd->dev->zone_nr_blocks) {=0A=
> +	while (chunk_block < zmd->zoned_dev->zone_nr_blocks) {=0A=
>  		/* Get a valid region from the source zone */=0A=
>  		ret =3D dmz_first_valid_block(zmd, from_zone, &chunk_block);=0A=
>  		if (ret <=3D 0)=0A=
> @@ -2002,11 +2002,11 @@ int dmz_validate_blocks(struct dmz_metadata *zmd,=
 struct dm_zone *zone,=0A=
>  			sector_t chunk_block, unsigned int nr_blocks)=0A=
>  {=0A=
>  	unsigned int count, bit, nr_bits;=0A=
> -	unsigned int zone_nr_blocks =3D zmd->dev->zone_nr_blocks;=0A=
> +	unsigned int zone_nr_blocks =3D zmd->zoned_dev->zone_nr_blocks;=0A=
>  	struct dmz_mblock *mblk;=0A=
>  	unsigned int n =3D 0;=0A=
>  =0A=
> -	dmz_dev_debug(zmd->dev, "=3D> VALIDATE zone %u, block %llu, %u blocks",=
=0A=
> +	dmz_dev_debug(zmd->zoned_dev, "=3D> VALIDATE zone %u, block %llu, %u bl=
ocks",=0A=
>  		      dmz_id(zmd, zone), (unsigned long long)chunk_block,=0A=
>  		      nr_blocks);=0A=
>  =0A=
> @@ -2036,7 +2036,7 @@ int dmz_validate_blocks(struct dmz_metadata *zmd, s=
truct dm_zone *zone,=0A=
>  	if (likely(zone->weight + n <=3D zone_nr_blocks))=0A=
>  		zone->weight +=3D n;=0A=
>  	else {=0A=
> -		dmz_dev_warn(zmd->dev, "Zone %u: weight %u should be <=3D %u",=0A=
> +		dmz_dev_warn(zmd->zoned_dev, "Zone %u: weight %u should be <=3D %u",=
=0A=
>  			     dmz_id(zmd, zone), zone->weight,=0A=
>  			     zone_nr_blocks - n);=0A=
>  		zone->weight =3D zone_nr_blocks;=0A=
> @@ -2086,10 +2086,10 @@ int dmz_invalidate_blocks(struct dmz_metadata *zm=
d, struct dm_zone *zone,=0A=
>  	struct dmz_mblock *mblk;=0A=
>  	unsigned int n =3D 0;=0A=
>  =0A=
> -	dmz_dev_debug(zmd->dev, "=3D> INVALIDATE zone %u, block %llu, %u blocks=
",=0A=
> +	dmz_dev_debug(zmd->zoned_dev, "=3D> INVALIDATE zone %u, block %llu, %u =
blocks",=0A=
>  		      dmz_id(zmd, zone), (u64)chunk_block, nr_blocks);=0A=
>  =0A=
> -	WARN_ON(chunk_block + nr_blocks > zmd->dev->zone_nr_blocks);=0A=
> +	WARN_ON(chunk_block + nr_blocks > zmd->zoned_dev->zone_nr_blocks);=0A=
>  =0A=
>  	while (nr_blocks) {=0A=
>  		/* Get bitmap block */=0A=
> @@ -2116,7 +2116,7 @@ int dmz_invalidate_blocks(struct dmz_metadata *zmd,=
 struct dm_zone *zone,=0A=
>  	if (zone->weight >=3D n)=0A=
>  		zone->weight -=3D n;=0A=
>  	else {=0A=
> -		dmz_dev_warn(zmd->dev, "Zone %u: weight %u should be >=3D %u",=0A=
> +		dmz_dev_warn(zmd->zoned_dev, "Zone %u: weight %u should be >=3D %u",=
=0A=
>  			     dmz_id(zmd, zone), zone->weight, n);=0A=
>  		zone->weight =3D 0;=0A=
>  	}=0A=
> @@ -2133,7 +2133,7 @@ static int dmz_test_block(struct dmz_metadata *zmd,=
 struct dm_zone *zone,=0A=
>  	struct dmz_mblock *mblk;=0A=
>  	int ret;=0A=
>  =0A=
> -	WARN_ON(chunk_block >=3D zmd->dev->zone_nr_blocks);=0A=
> +	WARN_ON(chunk_block >=3D zmd->zoned_dev->zone_nr_blocks);=0A=
>  =0A=
>  	/* Get bitmap block */=0A=
>  	mblk =3D dmz_get_bitmap(zmd, zone, chunk_block);=0A=
> @@ -2163,7 +2163,7 @@ static int dmz_to_next_set_block(struct dmz_metadat=
a *zmd, struct dm_zone *zone,=0A=
>  	unsigned long *bitmap;=0A=
>  	int n =3D 0;=0A=
>  =0A=
> -	WARN_ON(chunk_block + nr_blocks > zmd->dev->zone_nr_blocks);=0A=
> +	WARN_ON(chunk_block + nr_blocks > zmd->zoned_dev->zone_nr_blocks);=0A=
>  =0A=
>  	while (nr_blocks) {=0A=
>  		/* Get bitmap block */=0A=
> @@ -2207,7 +2207,7 @@ int dmz_block_valid(struct dmz_metadata *zmd, struc=
t dm_zone *zone,=0A=
>  =0A=
>  	/* The block is valid: get the number of valid blocks from block */=0A=
>  	return dmz_to_next_set_block(zmd, zone, chunk_block,=0A=
> -				     zmd->dev->zone_nr_blocks - chunk_block, 0);=0A=
> +				     zmd->zoned_dev->zone_nr_blocks - chunk_block, 0);=0A=
>  }=0A=
>  =0A=
>  /*=0A=
> @@ -2223,7 +2223,7 @@ int dmz_first_valid_block(struct dmz_metadata *zmd,=
 struct dm_zone *zone,=0A=
>  	int ret;=0A=
>  =0A=
>  	ret =3D dmz_to_next_set_block(zmd, zone, start_block,=0A=
> -				    zmd->dev->zone_nr_blocks - start_block, 1);=0A=
> +				    zmd->zoned_dev->zone_nr_blocks - start_block, 1);=0A=
>  	if (ret < 0)=0A=
>  		return ret;=0A=
>  =0A=
> @@ -2231,7 +2231,7 @@ int dmz_first_valid_block(struct dmz_metadata *zmd,=
 struct dm_zone *zone,=0A=
>  	*chunk_block =3D start_block;=0A=
>  =0A=
>  	return dmz_to_next_set_block(zmd, zone, start_block,=0A=
> -				     zmd->dev->zone_nr_blocks - start_block, 0);=0A=
> +				     zmd->zoned_dev->zone_nr_blocks - start_block, 0);=0A=
>  }=0A=
>  =0A=
>  /*=0A=
> @@ -2270,7 +2270,7 @@ static void dmz_get_zone_weight(struct dmz_metadata=
 *zmd, struct dm_zone *zone)=0A=
>  	struct dmz_mblock *mblk;=0A=
>  	sector_t chunk_block =3D 0;=0A=
>  	unsigned int bit, nr_bits;=0A=
> -	unsigned int nr_blocks =3D zmd->dev->zone_nr_blocks;=0A=
> +	unsigned int nr_blocks =3D zmd->zoned_dev->zone_nr_blocks;=0A=
>  	void *bitmap;=0A=
>  	int n =3D 0;=0A=
>  =0A=
> @@ -2326,7 +2326,7 @@ static void dmz_cleanup_metadata(struct dmz_metadat=
a *zmd)=0A=
>  	while (!list_empty(&zmd->mblk_dirty_list)) {=0A=
>  		mblk =3D list_first_entry(&zmd->mblk_dirty_list,=0A=
>  					struct dmz_mblock, link);=0A=
> -		dmz_dev_warn(zmd->dev, "mblock %llu still in dirty list (ref %u)",=0A=
> +		dmz_dev_warn(zmd->zoned_dev, "mblock %llu still in dirty list (ref %u)=
",=0A=
>  			     (u64)mblk->no, mblk->ref);=0A=
>  		list_del_init(&mblk->link);=0A=
>  		rb_erase(&mblk->node, &zmd->mblk_rbtree);=0A=
> @@ -2344,7 +2344,7 @@ static void dmz_cleanup_metadata(struct dmz_metadat=
a *zmd)=0A=
>  	/* Sanity checks: the mblock rbtree should now be empty */=0A=
>  	root =3D &zmd->mblk_rbtree;=0A=
>  	rbtree_postorder_for_each_entry_safe(mblk, next, root, node) {=0A=
> -		dmz_dev_warn(zmd->dev, "mblock %llu ref %u still in rbtree",=0A=
> +		dmz_dev_warn(zmd->zoned_dev, "mblock %llu ref %u still in rbtree",=0A=
>  			     (u64)mblk->no, mblk->ref);=0A=
>  		mblk->ref =3D 0;=0A=
>  		dmz_free_mblock(zmd, mblk);=0A=
> @@ -2371,7 +2371,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dm=
z_metadata **metadata)=0A=
>  	if (!zmd)=0A=
>  		return -ENOMEM;=0A=
>  =0A=
> -	zmd->dev =3D dev;=0A=
> +	zmd->zoned_dev =3D dev;=0A=
>  	zmd->mblk_rbtree =3D RB_ROOT;=0A=
>  	init_rwsem(&zmd->mblk_sem);=0A=
>  	mutex_init(&zmd->mblk_flush_lock);=0A=
> @@ -2488,7 +2488,7 @@ void dmz_dtr_metadata(struct dmz_metadata *zmd)=0A=
>   */=0A=
>  int dmz_resume_metadata(struct dmz_metadata *zmd)=0A=
>  {=0A=
> -	struct dmz_dev *dev =3D zmd->dev;=0A=
> +	struct dmz_dev *dev =3D zmd->zoned_dev;=0A=
>  	struct dm_zone *zone;=0A=
>  	sector_t wp_block;=0A=
>  	unsigned int i;=0A=
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c=
=0A=
> index 70a1063..28f4d00 100644=0A=
> --- a/drivers/md/dm-zoned-target.c=0A=
> +++ b/drivers/md/dm-zoned-target.c=0A=
> @@ -43,7 +43,7 @@ struct dmz_target {=0A=
>  	unsigned long		flags;=0A=
>  =0A=
>  	/* Zoned block device information */=0A=
> -	struct dmz_dev		*dev;=0A=
> +	struct dmz_dev		*zoned_dev;=0A=
>  =0A=
>  	/* For metadata handling */=0A=
>  	struct dmz_metadata     *metadata;=0A=
> @@ -81,7 +81,7 @@ static inline void dmz_bio_endio(struct bio *bio, blk_s=
tatus_t status)=0A=
>  	if (status !=3D BLK_STS_OK && bio->bi_status =3D=3D BLK_STS_OK)=0A=
>  		bio->bi_status =3D status;=0A=
>  	if (bio->bi_status !=3D BLK_STS_OK)=0A=
> -		bioctx->target->dev->flags |=3D DMZ_CHECK_BDEV;=0A=
> +		bioctx->target->zoned_dev->flags |=3D DMZ_CHECK_BDEV;=0A=
>  =0A=
>  	if (refcount_dec_and_test(&bioctx->ref)) {=0A=
>  		struct dm_zone *zone =3D bioctx->zone;=0A=
> @@ -125,7 +125,7 @@ static int dmz_submit_bio(struct dmz_target *dmz, str=
uct dm_zone *zone,=0A=
>  	if (!clone)=0A=
>  		return -ENOMEM;=0A=
>  =0A=
> -	bio_set_dev(clone, dmz->dev->bdev);=0A=
> +	bio_set_dev(clone, dmz->zoned_dev->bdev);=0A=
>  	clone->bi_iter.bi_sector =3D=0A=
>  		dmz_start_sect(dmz->metadata, zone) + dmz_blk2sect(chunk_block);=0A=
>  	clone->bi_iter.bi_size =3D dmz_blk2sect(nr_blocks) << SECTOR_SHIFT;=0A=
> @@ -165,7 +165,7 @@ static void dmz_handle_read_zero(struct dmz_target *d=
mz, struct bio *bio,=0A=
>  static int dmz_handle_read(struct dmz_target *dmz, struct dm_zone *zone,=
=0A=
>  			   struct bio *bio)=0A=
>  {=0A=
> -	sector_t chunk_block =3D dmz_chunk_block(dmz->dev, dmz_bio_block(bio));=
=0A=
> +	sector_t chunk_block =3D dmz_chunk_block(dmz->zoned_dev, dmz_bio_block(=
bio));=0A=
>  	unsigned int nr_blocks =3D dmz_bio_blocks(bio);=0A=
>  	sector_t end_block =3D chunk_block + nr_blocks;=0A=
>  	struct dm_zone *rzone, *bzone;=0A=
> @@ -177,8 +177,8 @@ static int dmz_handle_read(struct dmz_target *dmz, st=
ruct dm_zone *zone,=0A=
>  		return 0;=0A=
>  	}=0A=
>  =0A=
> -	dmz_dev_debug(dmz->dev, "READ chunk %llu -> %s zone %u, block %llu, %u =
blocks",=0A=
> -		      (unsigned long long)dmz_bio_chunk(dmz->dev, bio),=0A=
> +	dmz_dev_debug(dmz->zoned_dev, "READ chunk %llu -> %s zone %u, block %ll=
u, %u blocks",=0A=
> +		      (unsigned long long)dmz_bio_chunk(dmz->zoned_dev, bio),=0A=
>  		      (dmz_is_rnd(zone) ? "RND" : "SEQ"),=0A=
>  		      dmz_id(dmz->metadata, zone),=0A=
>  		      (unsigned long long)chunk_block, nr_blocks);=0A=
> @@ -308,14 +308,14 @@ static int dmz_handle_buffered_write(struct dmz_tar=
get *dmz,=0A=
>  static int dmz_handle_write(struct dmz_target *dmz, struct dm_zone *zone=
,=0A=
>  			    struct bio *bio)=0A=
>  {=0A=
> -	sector_t chunk_block =3D dmz_chunk_block(dmz->dev, dmz_bio_block(bio));=
=0A=
> +	sector_t chunk_block =3D dmz_chunk_block(dmz->zoned_dev, dmz_bio_block(=
bio));=0A=
>  	unsigned int nr_blocks =3D dmz_bio_blocks(bio);=0A=
>  =0A=
>  	if (!zone)=0A=
>  		return -ENOSPC;=0A=
>  =0A=
> -	dmz_dev_debug(dmz->dev, "WRITE chunk %llu -> %s zone %u, block %llu, %u=
 blocks",=0A=
> -		      (unsigned long long)dmz_bio_chunk(dmz->dev, bio),=0A=
> +	dmz_dev_debug(dmz->zoned_dev, "WRITE chunk %llu -> %s zone %u, block %l=
lu, %u blocks",=0A=
> +		      (unsigned long long)dmz_bio_chunk(dmz->zoned_dev, bio),=0A=
>  		      (dmz_is_rnd(zone) ? "RND" : "SEQ"),=0A=
>  		      dmz_id(dmz->metadata, zone),=0A=
>  		      (unsigned long long)chunk_block, nr_blocks);=0A=
> @@ -345,7 +345,7 @@ static int dmz_handle_discard(struct dmz_target *dmz,=
 struct dm_zone *zone,=0A=
>  	struct dmz_metadata *zmd =3D dmz->metadata;=0A=
>  	sector_t block =3D dmz_bio_block(bio);=0A=
>  	unsigned int nr_blocks =3D dmz_bio_blocks(bio);=0A=
> -	sector_t chunk_block =3D dmz_chunk_block(dmz->dev, block);=0A=
> +	sector_t chunk_block =3D dmz_chunk_block(dmz->zoned_dev, block);=0A=
>  	int ret =3D 0;=0A=
>  =0A=
>  	/* For unmapped chunks, there is nothing to do */=0A=
> @@ -355,8 +355,8 @@ static int dmz_handle_discard(struct dmz_target *dmz,=
 struct dm_zone *zone,=0A=
>  	if (dmz_is_readonly(zone))=0A=
>  		return -EROFS;=0A=
>  =0A=
> -	dmz_dev_debug(dmz->dev, "DISCARD chunk %llu -> zone %u, block %llu, %u =
blocks",=0A=
> -		      (unsigned long long)dmz_bio_chunk(dmz->dev, bio),=0A=
> +	dmz_dev_debug(dmz->zoned_dev, "DISCARD chunk %llu -> zone %u, block %ll=
u, %u blocks",=0A=
> +		      (unsigned long long)dmz_bio_chunk(dmz->zoned_dev, bio),=0A=
>  		      dmz_id(zmd, zone),=0A=
>  		      (unsigned long long)chunk_block, nr_blocks);=0A=
>  =0A=
> @@ -392,7 +392,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, st=
ruct dm_chunk_work *cw,=0A=
>  =0A=
>  	dmz_lock_metadata(zmd);=0A=
>  =0A=
> -	if (dmz->dev->flags & DMZ_BDEV_DYING) {=0A=
> +	if (dmz->zoned_dev->flags & DMZ_BDEV_DYING) {=0A=
>  		ret =3D -EIO;=0A=
>  		goto out;=0A=
>  	}=0A=
> @@ -402,7 +402,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, st=
ruct dm_chunk_work *cw,=0A=
>  	 * mapping for read and discard. If a mapping is obtained,=0A=
>  	 + the zone returned will be set to active state.=0A=
>  	 */=0A=
> -	zone =3D dmz_get_chunk_mapping(zmd, dmz_bio_chunk(dmz->dev, bio),=0A=
> +	zone =3D dmz_get_chunk_mapping(zmd, dmz_bio_chunk(dmz->zoned_dev, bio),=
=0A=
>  				     bio_op(bio));=0A=
>  	if (IS_ERR(zone)) {=0A=
>  		ret =3D PTR_ERR(zone);=0A=
> @@ -427,7 +427,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, st=
ruct dm_chunk_work *cw,=0A=
>  		ret =3D dmz_handle_discard(dmz, zone, bio);=0A=
>  		break;=0A=
>  	default:=0A=
> -		dmz_dev_err(dmz->dev, "Unsupported BIO operation 0x%x",=0A=
> +		dmz_dev_err(dmz->zoned_dev, "Unsupported BIO operation 0x%x",=0A=
>  			    bio_op(bio));=0A=
>  		ret =3D -EIO;=0A=
>  	}=0A=
> @@ -502,7 +502,7 @@ static void dmz_flush_work(struct work_struct *work)=
=0A=
>  	/* Flush dirty metadata blocks */=0A=
>  	ret =3D dmz_flush_metadata(dmz->metadata);=0A=
>  	if (ret)=0A=
> -		dmz_dev_debug(dmz->dev, "Metadata flush failed, rc=3D%d\n", ret);=0A=
> +		dmz_dev_debug(dmz->zoned_dev, "Metadata flush failed, rc=3D%d\n", ret)=
;=0A=
>  =0A=
>  	/* Process queued flush requests */=0A=
>  	while (1) {=0A=
> @@ -525,7 +525,7 @@ static void dmz_flush_work(struct work_struct *work)=
=0A=
>   */=0A=
>  static int dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)=
=0A=
>  {=0A=
> -	unsigned int chunk =3D dmz_bio_chunk(dmz->dev, bio);=0A=
> +	unsigned int chunk =3D dmz_bio_chunk(dmz->zoned_dev, bio);=0A=
>  	struct dm_chunk_work *cw;=0A=
>  	int ret =3D 0;=0A=
>  =0A=
> @@ -618,20 +618,20 @@ bool dmz_check_bdev(struct dmz_dev *dmz_dev)=0A=
>  static int dmz_map(struct dm_target *ti, struct bio *bio)=0A=
>  {=0A=
>  	struct dmz_target *dmz =3D ti->private;=0A=
> -	struct dmz_dev *dev =3D dmz->dev;=0A=
> +	struct dmz_dev *dev =3D dmz->zoned_dev;=0A=
>  	struct dmz_bioctx *bioctx =3D dm_per_bio_data(bio, sizeof(struct dmz_bi=
octx));=0A=
>  	sector_t sector =3D bio->bi_iter.bi_sector;=0A=
>  	unsigned int nr_sectors =3D bio_sectors(bio);=0A=
>  	sector_t chunk_sector;=0A=
>  	int ret;=0A=
>  =0A=
> -	if (dmz_bdev_is_dying(dmz->dev))=0A=
> +	if (dmz_bdev_is_dying(dmz->zoned_dev))=0A=
>  		return DM_MAPIO_KILL;=0A=
>  =0A=
>  	dmz_dev_debug(dev, "BIO op %d sector %llu + %u =3D> chunk %llu, block %=
llu, %u blocks",=0A=
>  		      bio_op(bio), (unsigned long long)sector, nr_sectors,=0A=
> -		      (unsigned long long)dmz_bio_chunk(dmz->dev, bio),=0A=
> -		      (unsigned long long)dmz_chunk_block(dmz->dev, dmz_bio_block(bio)=
),=0A=
> +		      (unsigned long long)dmz_bio_chunk(dmz->zoned_dev, bio),=0A=
> +		      (unsigned long long)dmz_chunk_block(dmz->zoned_dev, dmz_bio_bloc=
k(bio)),=0A=
>  		      (unsigned int)dmz_bio_blocks(bio));=0A=
>  =0A=
>  	bio_set_dev(bio, dev->bdev);=0A=
> @@ -666,9 +666,9 @@ static int dmz_map(struct dm_target *ti, struct bio *=
bio)=0A=
>  	/* Now ready to handle this BIO */=0A=
>  	ret =3D dmz_queue_chunk_work(dmz, bio);=0A=
>  	if (ret) {=0A=
> -		dmz_dev_debug(dmz->dev,=0A=
> +		dmz_dev_debug(dmz->zoned_dev,=0A=
>  			      "BIO op %d, can't process chunk %llu, err %i\n",=0A=
> -			      bio_op(bio), (u64)dmz_bio_chunk(dmz->dev, bio),=0A=
> +			      bio_op(bio), (u64)dmz_bio_chunk(dmz->zoned_dev, bio),=0A=
>  			      ret);=0A=
>  		return DM_MAPIO_REQUEUE;=0A=
>  	}=0A=
> @@ -729,7 +729,7 @@ static int dmz_get_zoned_device(struct dm_target *ti,=
 char *path)=0A=
>  =0A=
>  	dev->nr_zones =3D blkdev_nr_zones(dev->bdev->bd_disk);=0A=
>  =0A=
> -	dmz->dev =3D dev;=0A=
> +	dmz->zoned_dev =3D dev;=0A=
>  =0A=
>  	return 0;=0A=
>  err:=0A=
> @@ -747,8 +747,8 @@ static void dmz_put_zoned_device(struct dm_target *ti=
)=0A=
>  	struct dmz_target *dmz =3D ti->private;=0A=
>  =0A=
>  	dm_put_device(ti, dmz->ddev);=0A=
> -	kfree(dmz->dev);=0A=
> -	dmz->dev =3D NULL;=0A=
> +	kfree(dmz->zoned_dev);=0A=
> +	dmz->zoned_dev =3D NULL;=0A=
>  }=0A=
>  =0A=
>  /*=0A=
> @@ -782,7 +782,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int=
 argc, char **argv)=0A=
>  	}=0A=
>  =0A=
>  	/* Initialize metadata */=0A=
> -	dev =3D dmz->dev;=0A=
> +	dev =3D dmz->zoned_dev;=0A=
>  	ret =3D dmz_ctr_metadata(dev, &dmz->metadata);=0A=
>  	if (ret) {=0A=
>  		ti->error =3D "Metadata initialization failed";=0A=
> @@ -895,7 +895,7 @@ static void dmz_dtr(struct dm_target *ti)=0A=
>  static void dmz_io_hints(struct dm_target *ti, struct queue_limits *limi=
ts)=0A=
>  {=0A=
>  	struct dmz_target *dmz =3D ti->private;=0A=
> -	unsigned int chunk_sectors =3D dmz->dev->zone_nr_sectors;=0A=
> +	unsigned int chunk_sectors =3D dmz->zoned_dev->zone_nr_sectors;=0A=
>  =0A=
>  	limits->logical_block_size =3D DMZ_BLOCK_SIZE;=0A=
>  	limits->physical_block_size =3D DMZ_BLOCK_SIZE;=0A=
> @@ -924,10 +924,10 @@ static int dmz_prepare_ioctl(struct dm_target *ti, =
struct block_device **bdev)=0A=
>  {=0A=
>  	struct dmz_target *dmz =3D ti->private;=0A=
>  =0A=
> -	if (!dmz_check_bdev(dmz->dev))=0A=
> +	if (!dmz_check_bdev(dmz->zoned_dev))=0A=
>  		return -EIO;=0A=
>  =0A=
> -	*bdev =3D dmz->dev->bdev;=0A=
> +	*bdev =3D dmz->zoned_dev->bdev;=0A=
>  =0A=
>  	return 0;=0A=
>  }=0A=
> @@ -959,7 +959,7 @@ static int dmz_iterate_devices(struct dm_target *ti,=
=0A=
>  			       iterate_devices_callout_fn fn, void *data)=0A=
>  {=0A=
>  	struct dmz_target *dmz =3D ti->private;=0A=
> -	struct dmz_dev *dev =3D dmz->dev;=0A=
> +	struct dmz_dev *dev =3D dmz->zoned_dev;=0A=
>  	sector_t capacity =3D dev->capacity & ~(dev->zone_nr_sectors - 1);=0A=
>  =0A=
>  	return fn(ti, dmz->ddev, 0, capacity, data);=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
