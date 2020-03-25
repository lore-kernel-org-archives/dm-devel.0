From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [RFC PATCH v2 2/3] dm zoned: introduce regular device to
 dm-zoned-target
Date: Wed, 25 Mar 2020 06:20:47 +0000
Message-ID: <CO2PR04MB23437670CA0BD671AB008754E7CE0@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200324110255.8385-1-bob.liu@oracle.com>
 <20200324110255.8385-3-bob.liu@oracle.com>
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
> Introduce a regular device for storing metadata and buffer write, zoned=
=0A=
> device is used by default if no regular device was set by dmsetup.=0A=
> =0A=
> The corresponding dmsetup cmd is:=0A=
> echo "0 $size zoned $regular_device $zoned_device" | dmsetup create $dm-z=
oned-name=0A=
> =0A=
> Signed-off-by: Bob Liu <bob.liu@oracle.com>=0A=
> ---=0A=
>  drivers/md/dm-zoned-target.c | 141 +++++++++++++++++++++++++------------=
------=0A=
>  drivers/md/dm-zoned.h        |  50 +++++++++++++--=0A=
>  2 files changed, 127 insertions(+), 64 deletions(-)=0A=
> =0A=
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c=
=0A=
> index 28f4d00..cae4bfe 100644=0A=
> --- a/drivers/md/dm-zoned-target.c=0A=
> +++ b/drivers/md/dm-zoned-target.c=0A=
> @@ -35,38 +35,6 @@ struct dm_chunk_work {=0A=
>  };=0A=
>  =0A=
>  /*=0A=
> - * Target descriptor.=0A=
> - */=0A=
> -struct dmz_target {=0A=
> -	struct dm_dev		*ddev;=0A=
> -=0A=
> -	unsigned long		flags;=0A=
> -=0A=
> -	/* Zoned block device information */=0A=
> -	struct dmz_dev		*zoned_dev;=0A=
> -=0A=
> -	/* For metadata handling */=0A=
> -	struct dmz_metadata     *metadata;=0A=
> -=0A=
> -	/* For reclaim */=0A=
> -	struct dmz_reclaim	*reclaim;=0A=
> -=0A=
> -	/* For chunk work */=0A=
> -	struct radix_tree_root	chunk_rxtree;=0A=
> -	struct workqueue_struct *chunk_wq;=0A=
> -	struct mutex		chunk_lock;=0A=
> -=0A=
> -	/* For cloned BIOs to zones */=0A=
> -	struct bio_set		bio_set;=0A=
> -=0A=
> -	/* For flush */=0A=
> -	spinlock_t		flush_lock;=0A=
> -	struct bio_list		flush_list;=0A=
> -	struct delayed_work	flush_work;=0A=
> -	struct workqueue_struct *flush_wq;=0A=
> -};=0A=
=0A=
I am not sure I understand why this needs to be moved from here=0A=
into dm-zoned.h...=0A=
=0A=
> -=0A=
> -/*=0A=
>   * Flush intervals (seconds).=0A=
>   */=0A=
>  #define DMZ_FLUSH_PERIOD	(10 * HZ)=0A=
> @@ -679,7 +647,7 @@ static int dmz_map(struct dm_target *ti, struct bio *=
bio)=0A=
>  /*=0A=
>   * Get zoned device information.=0A=
>   */=0A=
> -static int dmz_get_zoned_device(struct dm_target *ti, char *path)=0A=
> +static int dmz_get_device(struct dm_target *ti, char *path, bool zoned)=
=0A=
=0A=
I do not think you need the zoned argument here. You can easily detect this=
=0A=
using bdev_is_zoned() once you get the bdev.=0A=
=0A=
>  {=0A=
>  	struct dmz_target *dmz =3D ti->private;=0A=
>  	struct request_queue *q;=0A=
> @@ -688,11 +656,22 @@ static int dmz_get_zoned_device(struct dm_target *t=
i, char *path)=0A=
>  	int ret;=0A=
>  =0A=
>  	/* Get the target device */=0A=
> -	ret =3D dm_get_device(ti, path, dm_table_get_mode(ti->table), &dmz->dde=
v);=0A=
> -	if (ret) {=0A=
> -		ti->error =3D "Get target device failed";=0A=
> -		dmz->ddev =3D NULL;=0A=
> -		return ret;=0A=
> +	if (zoned) {=0A=
> +		ret =3D dm_get_device(ti, path, dm_table_get_mode(ti->table),=0A=
> +				&dmz->ddev);=0A=
> +		if (ret) {=0A=
> +			ti->error =3D "Get target device failed";=0A=
> +			dmz->ddev =3D NULL;=0A=
> +			return ret;=0A=
> +		}=0A=
> +	} else {=0A=
> +		ret =3D dm_get_device(ti, path, dm_table_get_mode(ti->table),=0A=
> +				&dmz->regu_dm_dev);=0A=
> +		if (ret) {=0A=
> +			ti->error =3D "Get target device failed";=0A=
> +			dmz->regu_dm_dev =3D NULL;=0A=
> +			return ret;=0A=
> +		}=0A=
=0A=
If you use a local variable ddev, you do not need to duplicate this hunk.=
=0A=
All you need is:=0A=
=0A=
if (zoned)=0A=
	dmz->zddev =3D ddev;=0A=
else=0A=
	dmz->cddev =3D ddev;=0A=
=0A=
>  	}=0A=
>  =0A=
>  	dev =3D kzalloc(sizeof(struct dmz_dev), GFP_KERNEL);=0A=
> @@ -701,39 +680,61 @@ static int dmz_get_zoned_device(struct dm_target *t=
i, char *path)=0A=
>  		goto err;=0A=
>  	}=0A=
>  =0A=
> -	dev->bdev =3D dmz->ddev->bdev;=0A=
> -	(void)bdevname(dev->bdev, dev->name);=0A=
> -=0A=
> -	if (bdev_zoned_model(dev->bdev) =3D=3D BLK_ZONED_NONE) {=0A=
> -		ti->error =3D "Not a zoned block device";=0A=
> -		ret =3D -EINVAL;=0A=
> -		goto err;=0A=
> +	if (zoned) {=0A=
> +		dev->bdev =3D dmz->ddev->bdev;=0A=
> +		if (bdev_zoned_model(dev->bdev) =3D=3D BLK_ZONED_NONE) {=0A=
> +			ti->error =3D "Not a zoned block device";=0A=
> +			ret =3D -EINVAL;=0A=
> +			goto err;=0A=
> +		}=0A=
>  	}=0A=
> +	else=0A=
> +		dev->bdev =3D dmz->regu_dm_dev->bdev;=0A=
> +=0A=
> +	(void)bdevname(dev->bdev, dev->name);=0A=
> +	dev->target =3D dmz;=0A=
>  =0A=
>  	q =3D bdev_get_queue(dev->bdev);=0A=
>  	dev->capacity =3D i_size_read(dev->bdev->bd_inode) >> SECTOR_SHIFT;=0A=
>  	aligned_capacity =3D dev->capacity &=0A=
>  				~((sector_t)blk_queue_zone_sectors(q) - 1);=0A=
> -	if (ti->begin ||=0A=
> -	    ((ti->len !=3D dev->capacity) && (ti->len !=3D aligned_capacity))) =
{=0A=
> -		ti->error =3D "Partial mapping not supported";=0A=
> -		ret =3D -EINVAL;=0A=
> -		goto err;=0A=
> -	}=0A=
>  =0A=
> -	dev->zone_nr_sectors =3D blk_queue_zone_sectors(q);=0A=
> -	dev->zone_nr_sectors_shift =3D ilog2(dev->zone_nr_sectors);=0A=
> +	if (zoned) {=0A=
> +		if (ti->begin || ((ti->len !=3D dev->capacity) &&=0A=
> +					(ti->len !=3D aligned_capacity))) {=0A=
> +			ti->error =3D "Partial mapping not supported";=0A=
> +			ret =3D -EINVAL;=0A=
> +			goto err;=0A=
> +		}=0A=
> +		dev->zone_nr_sectors =3D blk_queue_zone_sectors(q);=0A=
> +		dev->zone_nr_sectors_shift =3D ilog2(dev->zone_nr_sectors);=0A=
> +=0A=
> +		dev->zone_nr_blocks =3D dmz_sect2blk(dev->zone_nr_sectors);=0A=
> +		dev->zone_nr_blocks_shift =3D ilog2(dev->zone_nr_blocks);=0A=
>  =0A=
> -	dev->zone_nr_blocks =3D dmz_sect2blk(dev->zone_nr_sectors);=0A=
> -	dev->zone_nr_blocks_shift =3D ilog2(dev->zone_nr_blocks);=0A=
> +		dev->nr_zones =3D blkdev_nr_zones(dev->bdev->bd_disk);=0A=
>  =0A=
> -	dev->nr_zones =3D blkdev_nr_zones(dev->bdev->bd_disk);=0A=
> +		dmz->zoned_dev =3D dev;=0A=
> +	} else {=0A=
> +		/* Emulate regular device zone info by using the same zone size.*/=0A=
> +		dev->zone_nr_sectors =3D dmz->zoned_dev->zone_nr_sectors;=0A=
> +		dev->zone_nr_sectors_shift =3D ilog2(dev->zone_nr_sectors);=0A=
>  =0A=
> -	dmz->zoned_dev =3D dev;=0A=
> +		dev->zone_nr_blocks =3D dmz_sect2blk(dev->zone_nr_sectors);=0A=
> +		dev->zone_nr_blocks_shift =3D ilog2(dev->zone_nr_blocks);=0A=
> +=0A=
> +		dev->nr_zones =3D (get_capacity(dev->bdev->bd_disk) >>=0A=
> +				ilog2(dev->zone_nr_sectors));=0A=
> +=0A=
> +		dmz->regu_dmz_dev =3D dev;=0A=
> +	}=0A=
>  =0A=
>  	return 0;=0A=
>  err:=0A=
> -	dm_put_device(ti, dmz->ddev);=0A=
> +	if (zoned)=0A=
> +		dm_put_device(ti, dmz->ddev);=0A=
> +	else=0A=
> +		dm_put_device(ti, dmz->regu_dm_dev);=0A=
=0A=
A local ddev variable will avoid the need for the if/else here.=0A=
=0A=
>  	kfree(dev);=0A=
>  =0A=
>  	return ret;=0A=
> @@ -746,6 +747,12 @@ static void dmz_put_zoned_device(struct dm_target *t=
i)=0A=
>  {=0A=
>  	struct dmz_target *dmz =3D ti->private;=0A=
>  =0A=
> +	if (dmz->regu_dm_dev)=0A=
> +		dm_put_device(ti, dmz->regu_dm_dev);=0A=
> +	if (dmz->regu_dmz_dev) {=0A=
> +		kfree(dmz->regu_dmz_dev);=0A=
> +		dmz->regu_dmz_dev =3D NULL;=0A=
> +	}=0A=
>  	dm_put_device(ti, dmz->ddev);=0A=
>  	kfree(dmz->zoned_dev);=0A=
>  	dmz->zoned_dev =3D NULL;=0A=
> @@ -761,7 +768,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int=
 argc, char **argv)=0A=
>  	int ret;=0A=
>  =0A=
>  	/* Check arguments */=0A=
> -	if (argc !=3D 1) {=0A=
> +	if ((argc !=3D 1) && (argc !=3D 2)) {=0A=
>  		ti->error =3D "Invalid argument count";=0A=
>  		return -EINVAL;=0A=
>  	}=0A=
> @@ -775,12 +782,25 @@ static int dmz_ctr(struct dm_target *ti, unsigned i=
nt argc, char **argv)=0A=
>  	ti->private =3D dmz;=0A=
>  =0A=
>  	/* Get the target zoned block device */=0A=
> -	ret =3D dmz_get_zoned_device(ti, argv[0]);=0A=
> +	ret =3D dmz_get_device(ti, argv[0], 1);=0A=
>  	if (ret) {=0A=
>  		dmz->ddev =3D NULL;=0A=
>  		goto err;=0A=
>  	}=0A=
>  =0A=
> +	snprintf(dmz->name, BDEVNAME_SIZE, "%s", dmz->zoned_dev->name);=0A=
> +	dmz->nr_zones =3D dmz->zoned_dev->nr_zones;=0A=
> +	if (argc =3D=3D 2) {=0A=
> +		ret =3D dmz_get_device(ti, argv[1], 0);=0A=
> +		if (ret) {=0A=
> +			dmz->regu_dm_dev =3D NULL;=0A=
> +			goto err;=0A=
> +		}=0A=
> +		snprintf(dmz->name, BDEVNAME_SIZE * 2, "%s:%s",=0A=
> +				dmz->zoned_dev->name, dmz->regu_dmz_dev->name);=0A=
> +		dmz->nr_zones +=3D dmz->regu_dmz_dev->nr_zones;=0A=
> +	}=0A=
> +=0A=
>  	/* Initialize metadata */=0A=
>  	dev =3D dmz->zoned_dev;=0A=
>  	ret =3D dmz_ctr_metadata(dev, &dmz->metadata);=0A=
> @@ -962,6 +982,7 @@ static int dmz_iterate_devices(struct dm_target *ti,=
=0A=
>  	struct dmz_dev *dev =3D dmz->zoned_dev;=0A=
>  	sector_t capacity =3D dev->capacity & ~(dev->zone_nr_sectors - 1);=0A=
>  =0A=
> +	/* Todo: fn(dmz->regu_dm_dev) */=0A=
>  	return fn(ti, dmz->ddev, 0, capacity, data);=0A=
>  }=0A=
>  =0A=
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h=0A=
> index 5b5e493..a3535bc 100644=0A=
> --- a/drivers/md/dm-zoned.h=0A=
> +++ b/drivers/md/dm-zoned.h=0A=
> @@ -46,9 +46,51 @@=0A=
>  #define dmz_bio_blocks(bio)	dmz_sect2blk(bio_sectors(bio))=0A=
>  =0A=
>  /*=0A=
> + * Target descriptor.=0A=
> + */=0A=
> +struct dmz_target {=0A=
> +	struct dm_dev		*ddev;=0A=
> +	/*=0A=
> +	 * Regular device for store metdata and buffer write, use zoned device=
=0A=
> +	 * by default if no regular device was set.=0A=
> +	 */=0A=
> +	struct dm_dev           *regu_dm_dev;=0A=
=0A=
rddev is shorter...=0A=
=0A=
> +	struct dmz_dev          *regu_dmz_dev;=0A=
=0A=
And rdev here ? Or "cdev" with the c standing for "cache" and "conventional=
=0A=
(=3Dnot zoned)" at the same time.=0A=
=0A=
> +	/* Total nr_zones. */=0A=
> +	unsigned int            nr_zones;=0A=
> +	char                    name[BDEVNAME_SIZE * 2];=0A=
=0A=
I would define 2 fields rather than doubling the nbame length. The field na=
mes=0A=
can follow the same pattern and zdev/cdev, you add zname and cname. Anyway,=
 this=0A=
string is already in dmz_dev, so why add it ?=0A=
=0A=
> +=0A=
> +	unsigned long		flags;=0A=
=0A=
Flags are currently for target and backedn device. This needs to sorted out=
=0A=
because there will be a need for per backend device (e.g. dying flag etc) f=
lags,=0A=
so this needs to be split, one flag field for each cache and zoned dev.=0A=
=0A=
> +=0A=
> +	/* Zoned block device information */=0A=
> +	struct dmz_dev		*zoned_dev;=0A=
=0A=
Similarly to regu_dmz_dev, it would be better to pair this one with struct=
=0A=
dm_dev *ddev above and rename ddev field to zddev.=0A=
=0A=
And to simplify everything, you could move ddev to struct dmz_dev and add a=
=0A=
flags field there. Then all you need in struct dmz_target is:=0A=
=0A=
struct dm_dev           *cdev;=0A=
struct dm_dev           *zdev;=0A=
=0A=
> +=0A=
> +	/* For metadata handling */=0A=
> +	struct dmz_metadata     *metadata;=0A=
> +=0A=
> +	/* For reclaim */=0A=
> +	struct dmz_reclaim	*reclaim;=0A=
> +=0A=
> +	/* For chunk work */=0A=
> +	struct radix_tree_root	chunk_rxtree;=0A=
> +	struct workqueue_struct *chunk_wq;=0A=
> +	struct mutex		chunk_lock;=0A=
> +=0A=
> +	/* For cloned BIOs to zones */=0A=
> +	struct bio_set		bio_set;=0A=
> +=0A=
> +	/* For flush */=0A=
> +	spinlock_t		flush_lock;=0A=
> +	struct bio_list		flush_list;=0A=
> +	struct delayed_work	flush_work;=0A=
> +	struct workqueue_struct *flush_wq;=0A=
> +};=0A=
> +=0A=
> +/*=0A=
>   * Zoned block device information.=0A=
>   */=0A=
>  struct dmz_dev {=0A=
> +	struct dmz_target       *target;=0A=
>  	struct block_device	*bdev;=0A=
>  =0A=
>  	char			name[BDEVNAME_SIZE];=0A=
> @@ -147,16 +189,16 @@ enum {=0A=
>   * Message functions.=0A=
>   */=0A=
>  #define dmz_dev_info(dev, format, args...)	\=0A=
> -	DMINFO("(%s): " format, (dev)->name, ## args)=0A=
> +	DMINFO("(%s): " format, (dev)->target->name, ## args)=0A=
>  =0A=
>  #define dmz_dev_err(dev, format, args...)	\=0A=
> -	DMERR("(%s): " format, (dev)->name, ## args)=0A=
> +	DMERR("(%s): " format, (dev)->target->name, ## args)=0A=
>  =0A=
>  #define dmz_dev_warn(dev, format, args...)	\=0A=
> -	DMWARN("(%s): " format, (dev)->name, ## args)=0A=
> +	DMWARN("(%s): " format, (dev)->target->name, ## args)=0A=
>  =0A=
>  #define dmz_dev_debug(dev, format, args...)	\=0A=
> -	DMDEBUG("(%s): " format, (dev)->name, ## args)=0A=
> +	DMDEBUG("(%s): " format, (dev)->target->name, ## args)=0A=
>  =0A=
>  struct dmz_metadata;=0A=
>  struct dmz_reclaim;=0A=
> =0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
