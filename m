From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2 3/3] dm zoned: add regular device info to metadata
Date: Wed, 25 Mar 2020 06:29:29 +0000
Message-ID: <CO2PR04MB23438E0AB35CC46732F96085E7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200324110255.8385-1-bob.liu@oracle.com>
 <20200324110255.8385-4-bob.liu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bob Liu <bob.liu@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "hare@suse.de" <hare@suse.de>
List-Id: dm-devel.ids

On 2020/03/24 20:04, Bob Liu wrote:=0A=
> This patch implemented metadata support for regular device by:=0A=
>  - Emulated zone information for regular device.=0A=
>  - Store metadata at the beginning of regular device.=0A=
> =0A=
>      | --- zoned device --- | -- regular device ||=0A=
>      ^                      ^=0A=
>      |                      |Metadata=0A=
> zone 0=0A=
> =0A=
> Signed-off-by: Bob Liu <bob.liu@oracle.com>=0A=
> ---=0A=
>  drivers/md/dm-zoned-metadata.c | 135 +++++++++++++++++++++++++++++++----=
------=0A=
>  drivers/md/dm-zoned-target.c   |   6 +-=0A=
>  drivers/md/dm-zoned.h          |   3 +-=0A=
>  3 files changed, 108 insertions(+), 36 deletions(-)=0A=
> =0A=
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadat=
a.c=0A=
> index e0e8be0..a96158a 100644=0A=
> --- a/drivers/md/dm-zoned-metadata.c=0A=
> +++ b/drivers/md/dm-zoned-metadata.c=0A=
> @@ -131,6 +131,7 @@ struct dmz_sb {=0A=
>   */=0A=
>  struct dmz_metadata {=0A=
>  	struct dmz_dev		*zoned_dev;=0A=
> +	struct dmz_dev		*regu_dmz_dev;=0A=
>  =0A=
>  	sector_t		zone_bitmap_size;=0A=
>  	unsigned int		zone_nr_bitmap_blocks;=0A=
> @@ -187,6 +188,15 @@ struct dmz_metadata {=0A=
>  /*=0A=
>   * Various accessors=0A=
>   */=0A=
> +static inline struct dmz_dev *zmd_mdev(struct dmz_metadata *zmd)=0A=
> +{=0A=
> +	/* Metadata always stores in regular device if there is. */=0A=
> +	if (zmd->regu_dmz_dev)=0A=
> +		return zmd->regu_dmz_dev;=0A=
> +	else=0A=
> +		return zmd->zoned_dev;=0A=
=0A=
OK. I think we will be better off using an array of pointers to struct_dmz_=
dev=0A=
in dmz_target, i.e., a filed "struct dmz_dev	*dev[2]". Doing so, we can be =
sure=0A=
to always have the device holding metatdata in entry 0, which will always b=
e=0A=
true for the single drive case too.=0A=
With this, you will not need all these dance with "which device has metadat=
a" ?=0A=
It always will be dmz->dev[0].=0A=
=0A=
> +}=0A=
> +=0A=
>  unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone)=0A=
>  {=0A=
>  	return ((unsigned int)(zone - zmd->zones));=0A=
> @@ -194,12 +204,33 @@ unsigned int dmz_id(struct dmz_metadata *zmd, struc=
t dm_zone *zone)=0A=
>  =0A=
>  sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone)=
=0A=
>  {=0A=
> -	return (sector_t)dmz_id(zmd, zone) << zmd->zoned_dev->zone_nr_sectors_s=
hift;=0A=
=0A=
With the array of dev trick, most of the changes below are simplified or go=
 away.=0A=
=0A=
> +	int dmz_real_id;=0A=
> +=0A=
> +	dmz_real_id =3D dmz_id(zmd, zone);=0A=
> +	if (dmz_real_id >=3D zmd->zoned_dev->nr_zones) {=0A=
> +		/* Regular dev. */=0A=
> +		dmz_real_id -=3D zmd->zoned_dev->nr_zones;=0A=
> +		WARN_ON(!zmd->regu_dmz_dev);=0A=
> +=0A=
> +		return (sector_t)dmz_real_id << zmd->zoned_dev->zone_nr_sectors_shift;=
=0A=
> +	}=0A=
> +	return (sector_t)dmz_real_id << zmd->zoned_dev->zone_nr_sectors_shift;=
=0A=
>  }=0A=
>  =0A=
>  sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone)=
=0A=
>  {=0A=
> -	return (sector_t)dmz_id(zmd, zone) << zmd->zoned_dev->zone_nr_blocks_sh=
ift;=0A=
> +	int dmz_real_id;=0A=
> +=0A=
> +	dmz_real_id =3D dmz_id(zmd, zone);=0A=
> +	if (dmz_real_id >=3D zmd->zoned_dev->nr_zones) {=0A=
> +		/* Regular dev. */=0A=
> +		dmz_real_id -=3D zmd->zoned_dev->nr_zones;=0A=
> +		WARN_ON(!zmd->regu_dmz_dev);=0A=
> +=0A=
> +		return (sector_t)dmz_real_id << zmd->zoned_dev->zone_nr_blocks_shift;=
=0A=
> +	}=0A=
> +=0A=
> +	return (sector_t)dmz_real_id << zmd->zoned_dev->zone_nr_blocks_shift;=
=0A=
>  }=0A=
>  =0A=
>  unsigned int dmz_nr_chunks(struct dmz_metadata *zmd)=0A=
> @@ -403,8 +434,10 @@ static struct dmz_mblock *dmz_get_mblock_slow(struct=
 dmz_metadata *zmd,=0A=
>  	struct dmz_mblock *mblk, *m;=0A=
>  	sector_t block =3D zmd->sb[zmd->mblk_primary].block + mblk_no;=0A=
>  	struct bio *bio;=0A=
> +	struct dmz_dev *mdev;=0A=
>  =0A=
> -	if (dmz_bdev_is_dying(zmd->zoned_dev))=0A=
> +	mdev =3D zmd_mdev(zmd);=0A=
> +	if (dmz_bdev_is_dying(mdev))=0A=
>  		return ERR_PTR(-EIO);=0A=
>  =0A=
>  	/* Get a new block and a BIO to read it */=0A=
> @@ -440,7 +473,7 @@ static struct dmz_mblock *dmz_get_mblock_slow(struct =
dmz_metadata *zmd,=0A=
>  =0A=
>  	/* Submit read BIO */=0A=
>  	bio->bi_iter.bi_sector =3D dmz_blk2sect(block);=0A=
> -	bio_set_dev(bio, zmd->zoned_dev->bdev);=0A=
> +	bio_set_dev(bio, mdev->bdev);=0A=
>  	bio->bi_private =3D mblk;=0A=
>  	bio->bi_end_io =3D dmz_mblock_bio_end_io;=0A=
>  	bio_set_op_attrs(bio, REQ_OP_READ, REQ_META | REQ_PRIO);=0A=
> @@ -555,7 +588,7 @@ static struct dmz_mblock *dmz_get_mblock(struct dmz_m=
etadata *zmd,=0A=
>  		       TASK_UNINTERRUPTIBLE);=0A=
>  	if (test_bit(DMZ_META_ERROR, &mblk->state)) {=0A=
>  		dmz_release_mblock(zmd, mblk);=0A=
> -		dmz_check_bdev(zmd->zoned_dev);=0A=
> +		dmz_check_bdev(zmd_mdev(zmd));=0A=
>  		return ERR_PTR(-EIO);=0A=
>  	}=0A=
>  =0A=
> @@ -581,8 +614,10 @@ static int dmz_write_mblock(struct dmz_metadata *zmd=
, struct dmz_mblock *mblk,=0A=
>  {=0A=
>  	sector_t block =3D zmd->sb[set].block + mblk->no;=0A=
>  	struct bio *bio;=0A=
> +	struct dmz_dev *mdev;=0A=
>  =0A=
> -	if (dmz_bdev_is_dying(zmd->zoned_dev))=0A=
> +	mdev =3D zmd_mdev(zmd);=0A=
> +	if (dmz_bdev_is_dying(mdev))=0A=
>  		return -EIO;=0A=
>  =0A=
>  	bio =3D bio_alloc(GFP_NOIO, 1);=0A=
> @@ -594,7 +629,7 @@ static int dmz_write_mblock(struct dmz_metadata *zmd,=
 struct dmz_mblock *mblk,=0A=
>  	set_bit(DMZ_META_WRITING, &mblk->state);=0A=
>  =0A=
>  	bio->bi_iter.bi_sector =3D dmz_blk2sect(block);=0A=
> -	bio_set_dev(bio, zmd->zoned_dev->bdev);=0A=
> +	bio_set_dev(bio, mdev->bdev);=0A=
>  	bio->bi_private =3D mblk;=0A=
>  	bio->bi_end_io =3D dmz_mblock_bio_end_io;=0A=
>  	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_META | REQ_PRIO);=0A=
> @@ -612,8 +647,10 @@ static int dmz_rdwr_block(struct dmz_metadata *zmd, =
int op, sector_t block,=0A=
>  {=0A=
>  	struct bio *bio;=0A=
>  	int ret;=0A=
> +	struct dmz_dev *mdev;=0A=
>  =0A=
> -	if (dmz_bdev_is_dying(zmd->zoned_dev))=0A=
> +	mdev =3D zmd_mdev(zmd);=0A=
> +	if (dmz_bdev_is_dying(mdev))=0A=
>  		return -EIO;=0A=
>  =0A=
>  	bio =3D bio_alloc(GFP_NOIO, 1);=0A=
> @@ -621,14 +658,14 @@ static int dmz_rdwr_block(struct dmz_metadata *zmd,=
 int op, sector_t block,=0A=
>  		return -ENOMEM;=0A=
>  =0A=
>  	bio->bi_iter.bi_sector =3D dmz_blk2sect(block);=0A=
> -	bio_set_dev(bio, zmd->zoned_dev->bdev);=0A=
> +	bio_set_dev(bio, mdev->bdev);=0A=
>  	bio_set_op_attrs(bio, op, REQ_SYNC | REQ_META | REQ_PRIO);=0A=
>  	bio_add_page(bio, page, DMZ_BLOCK_SIZE, 0);=0A=
>  	ret =3D submit_bio_wait(bio);=0A=
>  	bio_put(bio);=0A=
>  =0A=
>  	if (ret)=0A=
> -		dmz_check_bdev(zmd->zoned_dev);=0A=
> +		dmz_check_bdev(mdev);=0A=
>  	return ret;=0A=
>  }=0A=
>  =0A=
> @@ -661,7 +698,7 @@ static int dmz_write_sb(struct dmz_metadata *zmd, uns=
igned int set)=0A=
>  =0A=
>  	ret =3D dmz_rdwr_block(zmd, REQ_OP_WRITE, block, mblk->page);=0A=
>  	if (ret =3D=3D 0)=0A=
> -		ret =3D blkdev_issue_flush(zmd->zoned_dev->bdev, GFP_NOIO, NULL);=0A=
> +		ret =3D blkdev_issue_flush(zmd_mdev(zmd)->bdev, GFP_NOIO, NULL);=0A=
>  =0A=
>  	return ret;=0A=
>  }=0A=
> @@ -695,15 +732,20 @@ static int dmz_write_dirty_mblocks(struct dmz_metad=
ata *zmd,=0A=
>  			       TASK_UNINTERRUPTIBLE);=0A=
>  		if (test_bit(DMZ_META_ERROR, &mblk->state)) {=0A=
>  			clear_bit(DMZ_META_ERROR, &mblk->state);=0A=
> -			dmz_check_bdev(zmd->zoned_dev);=0A=
> +			dmz_check_bdev(zmd_mdev(zmd));=0A=
>  			ret =3D -EIO;=0A=
>  		}=0A=
>  		nr_mblks_submitted--;=0A=
>  	}=0A=
>  =0A=
>  	/* Flush drive cache (this will also sync data) */=0A=
> -	if (ret =3D=3D 0)=0A=
> -		ret =3D blkdev_issue_flush(zmd->zoned_dev->bdev, GFP_NOIO, NULL);=0A=
> +	if (ret =3D=3D 0) {=0A=
> +		/* Flush metadata device */=0A=
> +		ret =3D blkdev_issue_flush(zmd_mdev(zmd)->bdev, GFP_NOIO, NULL);=0A=
> +		if ((ret =3D=3D 0) && zmd->regu_dmz_dev)=0A=
> +			/* Flush data device. */=0A=
> +			ret =3D blkdev_issue_flush(zmd->zoned_dev->bdev, GFP_NOIO, NULL);=0A=
> +	}=0A=
>  =0A=
>  	return ret;=0A=
>  }=0A=
> @@ -760,7 +802,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)=0A=
>  	 */=0A=
>  	dmz_lock_flush(zmd);=0A=
>  =0A=
> -	if (dmz_bdev_is_dying(zmd->zoned_dev)) {=0A=
> +	if (dmz_bdev_is_dying(zmd_mdev(zmd))) {=0A=
>  		ret =3D -EIO;=0A=
>  		goto out;=0A=
>  	}=0A=
> @@ -772,7 +814,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)=0A=
>  =0A=
>  	/* If there are no dirty metadata blocks, just flush the device cache *=
/=0A=
>  	if (list_empty(&write_list)) {=0A=
> -		ret =3D blkdev_issue_flush(zmd->zoned_dev->bdev, GFP_NOIO, NULL);=0A=
> +		ret =3D blkdev_issue_flush(zmd_mdev(zmd)->bdev, GFP_NOIO, NULL);=0A=
>  		goto err;=0A=
>  	}=0A=
>  =0A=
> @@ -821,7 +863,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)=0A=
>  		list_splice(&write_list, &zmd->mblk_dirty_list);=0A=
>  		spin_unlock(&zmd->mblk_lock);=0A=
>  	}=0A=
> -	if (!dmz_check_bdev(zmd->zoned_dev))=0A=
> +	if (!dmz_check_bdev(zmd_mdev(zmd)))=0A=
>  		ret =3D -EIO;=0A=
>  	goto out;=0A=
>  }=0A=
> @@ -832,10 +874,11 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)=0A=
>  static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_super *sb)=
=0A=
>  {=0A=
>  	unsigned int nr_meta_zones, nr_data_zones;=0A=
> -	struct dmz_dev *dev =3D zmd->zoned_dev;=0A=
> +	struct dmz_dev *dev;=0A=
>  	u32 crc, stored_crc;=0A=
>  	u64 gen;=0A=
>  =0A=
> +	dev =3D zmd_mdev(zmd);=0A=
>  	gen =3D le64_to_cpu(sb->gen);=0A=
>  	stored_crc =3D le32_to_cpu(sb->crc);=0A=
>  	sb->crc =3D 0;=0A=
> @@ -1131,8 +1174,11 @@ static int dmz_init_zone(struct blk_zone *blkz, un=
signed int idx, void *data)=0A=
>  		zmd->nr_useable_zones++;=0A=
>  		if (dmz_is_rnd(zone)) {=0A=
>  			zmd->nr_rnd_zones++;=0A=
> -			if (!zmd->sb_zone) {=0A=
> -				/* Super block zone */=0A=
> +			if (!zmd->sb_zone && !zmd->regu_dmz_dev) {=0A=
> +				/*=0A=
> +				 * Super block zone goes to regular=0A=
> +				 * device by default.=0A=
> +				 */=0A=
>  				zmd->sb_zone =3D zone;=0A=
>  			}=0A=
>  		}=0A=
> @@ -1157,7 +1203,8 @@ static void dmz_drop_zones(struct dmz_metadata *zmd=
)=0A=
>  static int dmz_init_zones(struct dmz_metadata *zmd)=0A=
>  {=0A=
>  	struct dmz_dev *dev =3D zmd->zoned_dev;=0A=
> -	int ret;=0A=
> +	int ret, i;=0A=
> +	unsigned int total_nr_zones;=0A=
>  =0A=
>  	/* Init */=0A=
>  	zmd->zone_bitmap_size =3D dev->zone_nr_blocks >> 3;=0A=
> @@ -1167,7 +1214,10 @@ static int dmz_init_zones(struct dmz_metadata *zmd=
)=0A=
>  					DMZ_BLOCK_SIZE_BITS);=0A=
>  =0A=
>  	/* Allocate zone array */=0A=
> -	zmd->zones =3D kcalloc(dev->nr_zones, sizeof(struct dm_zone), GFP_KERNE=
L);=0A=
> +	total_nr_zones =3D dev->nr_zones;=0A=
> +	if (zmd->regu_dmz_dev)=0A=
> +		total_nr_zones +=3D zmd->regu_dmz_dev->nr_zones;=0A=
> +	zmd->zones =3D kcalloc(total_nr_zones, sizeof(struct dm_zone), GFP_KERN=
EL);=0A=
>  	if (!zmd->zones)=0A=
>  		return -ENOMEM;=0A=
>  =0A=
> @@ -1186,6 +1236,25 @@ static int dmz_init_zones(struct dmz_metadata *zmd=
)=0A=
>  		return ret;=0A=
>  	}=0A=
>  =0A=
> +	if (zmd->regu_dmz_dev) {=0A=
> +		/* Emulate zone information for regular device zone. */=0A=
> +		for (i =3D 0; i < zmd->regu_dmz_dev->nr_zones; i++) {=0A=
> +			struct dm_zone *zone =3D &zmd->zones[i + dev->nr_zones];=0A=
> +=0A=
> +			INIT_LIST_HEAD(&zone->link);=0A=
> +			atomic_set(&zone->refcount, 0);=0A=
> +			zone->chunk =3D DMZ_MAP_UNMAPPED;=0A=
> +=0A=
> +			set_bit(DMZ_RND, &zone->flags);=0A=
> +			zmd->nr_rnd_zones++;=0A=
> +			zmd->nr_useable_zones++;=0A=
> +			zone->wp_block =3D 0;=0A=
> +			if (!zmd->sb_zone)=0A=
> +				/* Super block zone */=0A=
> +				zmd->sb_zone =3D zone;=0A=
> +		}=0A=
> +	}=0A=
> +=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> @@ -1313,13 +1382,13 @@ static void dmz_get_zone_weight(struct dmz_metada=
ta *zmd, struct dm_zone *zone);=0A=
>   */=0A=
>  static int dmz_load_mapping(struct dmz_metadata *zmd)=0A=
>  {=0A=
> -	struct dmz_dev *dev =3D zmd->zoned_dev;=0A=
>  	struct dm_zone *dzone, *bzone;=0A=
>  	struct dmz_mblock *dmap_mblk =3D NULL;=0A=
>  	struct dmz_map *dmap;=0A=
>  	unsigned int i =3D 0, e =3D 0, chunk =3D 0;=0A=
>  	unsigned int dzone_id;=0A=
>  	unsigned int bzone_id;=0A=
> +	struct dmz_dev *dev =3D zmd_mdev(zmd);=0A=
>  =0A=
>  	/* Metadata block array for the chunk mapping table */=0A=
>  	zmd->map_mblk =3D kcalloc(zmd->nr_map_blocks,=0A=
> @@ -1345,7 +1414,7 @@ static int dmz_load_mapping(struct dmz_metadata *zm=
d)=0A=
>  		if (dzone_id =3D=3D DMZ_MAP_UNMAPPED)=0A=
>  			goto next;=0A=
>  =0A=
> -		if (dzone_id >=3D dev->nr_zones) {=0A=
> +		if (dzone_id >=3D dev->target->nr_zones) {=0A=
>  			dmz_dev_err(dev, "Chunk %u mapping: invalid data zone ID %u",=0A=
>  				    chunk, dzone_id);=0A=
>  			return -EIO;=0A=
> @@ -1366,7 +1435,7 @@ static int dmz_load_mapping(struct dmz_metadata *zm=
d)=0A=
>  		if (bzone_id =3D=3D DMZ_MAP_UNMAPPED)=0A=
>  			goto next;=0A=
>  =0A=
> -		if (bzone_id >=3D dev->nr_zones) {=0A=
> +		if (bzone_id >=3D dev->target->nr_zones) {=0A=
>  			dmz_dev_err(dev, "Chunk %u mapping: invalid buffer zone ID %u",=0A=
>  				    chunk, bzone_id);=0A=
>  			return -EIO;=0A=
> @@ -1398,7 +1467,7 @@ static int dmz_load_mapping(struct dmz_metadata *zm=
d)=0A=
>  	 * fully initialized. All remaining zones are unmapped data=0A=
>  	 * zones. Finish initializing those here.=0A=
>  	 */=0A=
> -	for (i =3D 0; i < dev->nr_zones; i++) {=0A=
> +	for (i =3D 0; i < dev->target->nr_zones; i++) {=0A=
>  		dzone =3D dmz_get(zmd, i);=0A=
>  		if (dmz_is_meta(dzone))=0A=
>  			continue;=0A=
> @@ -1632,7 +1701,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_me=
tadata *zmd, unsigned int chu=0A=
>  		/* Allocate a random zone */=0A=
>  		dzone =3D dmz_alloc_zone(zmd, DMZ_ALLOC_RND);=0A=
>  		if (!dzone) {=0A=
> -			if (dmz_bdev_is_dying(zmd->zoned_dev)) {=0A=
> +			if (dmz_bdev_is_dying(zmd_mdev(zmd))) {=0A=
>  				dzone =3D ERR_PTR(-EIO);=0A=
>  				goto out;=0A=
>  			}=0A=
> @@ -1733,7 +1802,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_met=
adata *zmd,=0A=
>  	/* Allocate a random zone */=0A=
>  	bzone =3D dmz_alloc_zone(zmd, DMZ_ALLOC_RND);=0A=
>  	if (!bzone) {=0A=
> -		if (dmz_bdev_is_dying(zmd->zoned_dev)) {=0A=
> +		if (dmz_bdev_is_dying(zmd_mdev(zmd))) {=0A=
>  			bzone =3D ERR_PTR(-EIO);=0A=
>  			goto out;=0A=
>  		}=0A=
> @@ -2360,7 +2429,8 @@ static void dmz_cleanup_metadata(struct dmz_metadat=
a *zmd)=0A=
>  /*=0A=
>   * Initialize the zoned metadata.=0A=
>   */=0A=
> -int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata=
)=0A=
> +int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_dev *regu_dmz_dev,=
=0A=
> +		struct dmz_metadata **metadata)=0A=
>  {=0A=
>  	struct dmz_metadata *zmd;=0A=
>  	unsigned int i, zid;=0A=
> @@ -2372,6 +2442,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dm=
z_metadata **metadata)=0A=
>  		return -ENOMEM;=0A=
>  =0A=
>  	zmd->zoned_dev =3D dev;=0A=
> +	zmd->regu_dmz_dev =3D regu_dmz_dev;=0A=
>  	zmd->mblk_rbtree =3D RB_ROOT;=0A=
>  	init_rwsem(&zmd->mblk_sem);=0A=
>  	mutex_init(&zmd->mblk_flush_lock);=0A=
> @@ -2440,9 +2511,9 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dm=
z_metadata **metadata)=0A=
>  		     bdev_zoned_model(dev->bdev) =3D=3D BLK_ZONED_HA ?=0A=
>  		     "aware" : "managed");=0A=
>  	dmz_dev_info(dev, "  %llu 512-byte logical sectors",=0A=
> -		     (u64)dev->capacity);=0A=
> +		     (u64)dev->capacity  + (u64)regu_dmz_dev->capacity);=0A=
>  	dmz_dev_info(dev, "  %u zones of %llu 512-byte logical sectors",=0A=
> -		     dev->nr_zones, (u64)dev->zone_nr_sectors);=0A=
> +		     dev->nr_zones + regu_dmz_dev->nr_zones, (u64)dev->zone_nr_sectors=
);=0A=
>  	dmz_dev_info(dev, "  %u metadata zones",=0A=
>  		     zmd->nr_meta_zones * 2);=0A=
>  	dmz_dev_info(dev, "  %u data zones for %u chunks",=0A=
> @@ -2488,7 +2559,7 @@ void dmz_dtr_metadata(struct dmz_metadata *zmd)=0A=
>   */=0A=
>  int dmz_resume_metadata(struct dmz_metadata *zmd)=0A=
>  {=0A=
> -	struct dmz_dev *dev =3D zmd->zoned_dev;=0A=
> +	struct dmz_dev *dev =3D zmd_mdev(zmd);=0A=
>  	struct dm_zone *zone;=0A=
>  	sector_t wp_block;=0A=
>  	unsigned int i;=0A=
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c=
=0A=
> index cae4bfe..41dbb9d 100644=0A=
> --- a/drivers/md/dm-zoned-target.c=0A=
> +++ b/drivers/md/dm-zoned-target.c=0A=
> @@ -803,7 +803,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int=
 argc, char **argv)=0A=
>  =0A=
>  	/* Initialize metadata */=0A=
>  	dev =3D dmz->zoned_dev;=0A=
> -	ret =3D dmz_ctr_metadata(dev, &dmz->metadata);=0A=
> +	ret =3D dmz_ctr_metadata(dev, dmz->regu_dmz_dev, &dmz->metadata);=0A=
>  	if (ret) {=0A=
>  		ti->error =3D "Metadata initialization failed";=0A=
>  		goto err_dev;=0A=
> @@ -852,8 +852,8 @@ static int dmz_ctr(struct dm_target *ti, unsigned int=
 argc, char **argv)=0A=
>  	}=0A=
>  	mod_delayed_work(dmz->flush_wq, &dmz->flush_work, DMZ_FLUSH_PERIOD);=0A=
>  =0A=
> -	/* Initialize reclaim */=0A=
> -	ret =3D dmz_ctr_reclaim(dev, dmz->metadata, &dmz->reclaim);=0A=
> +	/* Initialize reclaim, only reclaim from regular device. */=0A=
> +	ret =3D dmz_ctr_reclaim(dmz->regu_dmz_dev, dmz->metadata, &dmz->reclaim=
);=0A=
>  	if (ret) {=0A=
>  		ti->error =3D "Zone reclaim initialization failed";=0A=
>  		goto err_fwq;=0A=
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h=0A=
> index a3535bc..7aa1a30 100644=0A=
> --- a/drivers/md/dm-zoned.h=0A=
> +++ b/drivers/md/dm-zoned.h=0A=
> @@ -206,7 +206,8 @@ struct dmz_reclaim;=0A=
>  /*=0A=
>   * Functions defined in dm-zoned-metadata.c=0A=
>   */=0A=
> -int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **zmd);=0A=
> +int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_dev *regu_dmz_dev,=
=0A=
> +		struct dmz_metadata **zmd);=0A=
>  void dmz_dtr_metadata(struct dmz_metadata *zmd);=0A=
>  int dmz_resume_metadata(struct dmz_metadata *zmd);=0A=
>  =0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
