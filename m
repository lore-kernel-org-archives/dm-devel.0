From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 11/14] dm-zoned: support arbitrary number of
	devices
Date: Sun, 31 May 2020 09:10:57 +0000
Message-ID: <36914d620ecccdf0397a47703a69b926afd3d283.camel@wdc.com>
References: <20200529173907.40529-1-hare@suse.de>
	<20200529173907.40529-12-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200529173907.40529-12-hare@suse.de>
Content-Language: en-US
Content-ID: <B5476770B57E2740B59CEE8FE1A8F666@namprd04.prod.outlook.com>
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

On Fri, 2020-05-29 at 19:39 +0200, Hannes Reinecke wrote:
> Remove the hard-coded limit of two devices and support an unlimited
> number of additional zoned devices.
> With that we need to increase the device-mapper version number to
> 3.0.0 as we've modified the interface.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c |  15 +++++-
>  drivers/md/dm-zoned-target.c   | 106 ++++++++++++++++++++++++-----------------
>  2 files changed, 75 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 044c152eb756..221163ae5f68 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1523,7 +1523,20 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
>  		 */
>  		zmd->sb[0].zone = dmz_get(zmd, 0);
>  
> -		zoned_dev = &zmd->dev[1];
> +		for (i = 1; i < zmd->nr_devs; i++) {
> +			zoned_dev = &zmd->dev[i];
> +
> +			ret = blkdev_report_zones(zoned_dev->bdev, 0,
> +						  BLK_ALL_ZONES,
> +						  dmz_init_zone, zoned_dev);
> +			if (ret < 0) {
> +				DMDEBUG("(%s): Failed to report zones, error %d",
> +					zmd->devname, ret);
> +				dmz_drop_zones(zmd);
> +				return ret;
> +			}
> +		}
> +		return 0;
>  	}
>  
>  	/*
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index aa3d26d16441..4a51738d4b0d 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -13,8 +13,6 @@
>  
>  #define DMZ_MIN_BIOS		8192
>  
> -#define DMZ_MAX_DEVS		2
> -
>  /*
>   * Zone BIO context.
>   */
> @@ -40,10 +38,10 @@ struct dm_chunk_work {
>   * Target descriptor.
>   */
>  struct dmz_target {
> -	struct dm_dev		*ddev[DMZ_MAX_DEVS];
> +	struct dm_dev		**ddev;
>  	unsigned int		nr_ddevs;
>  
> -	unsigned long		flags;
> +	unsigned int		flags;
>  
>  	/* Zoned block device information */
>  	struct dmz_dev		*dev;
> @@ -764,7 +762,7 @@ static void dmz_put_zoned_device(struct dm_target *ti)
>  	struct dmz_target *dmz = ti->private;
>  	int i;
>  
> -	for (i = 0; i < DMZ_MAX_DEVS; i++) {
> +	for (i = 0; i < dmz->nr_ddevs; i++) {
>  		if (dmz->ddev[i]) {
>  			dm_put_device(ti, dmz->ddev[i]);
>  			dmz->ddev[i] = NULL;
> @@ -777,21 +775,35 @@ static int dmz_fixup_devices(struct dm_target *ti)
>  	struct dmz_target *dmz = ti->private;
>  	struct dmz_dev *reg_dev, *zoned_dev;
>  	struct request_queue *q;
> +	sector_t zone_nr_sectors = 0;
> +	int i;
>  
>  	/*
> -	 * When we have two devices, the first one must be a regular block
> -	 * device and the second a zoned block device.
> +	 * When we have more than on devices, the first one must be a
> +	 * regular block device and the others zoned block devices.
>  	 */
> -	if (dmz->ddev[0] && dmz->ddev[1]) {
> +	if (dmz->nr_ddevs > 1) {
>  		reg_dev = &dmz->dev[0];
>  		if (!(reg_dev->flags & DMZ_BDEV_REGULAR)) {
>  			ti->error = "Primary disk is not a regular device";
>  			return -EINVAL;
>  		}
> -		zoned_dev = &dmz->dev[1];
> -		if (zoned_dev->flags & DMZ_BDEV_REGULAR) {
> -			ti->error = "Secondary disk is not a zoned device";
> -			return -EINVAL;
> +		for (i = 1; i < dmz->nr_ddevs; i++) {
> +			zoned_dev = &dmz->dev[i];
> +			if (zoned_dev->flags & DMZ_BDEV_REGULAR) {
> +				ti->error = "Secondary disk is not a zoned device";
> +				return -EINVAL;
> +			}
> +			q = bdev_get_queue(zoned_dev->bdev);
> +			if (zone_nr_sectors &&
> +			    zone_nr_sectors != blk_queue_zone_sectors(q)) {
> +				ti->error = "Zone nr sectors mismatch";
> +				return -EINVAL;
> +			}
> +			zone_nr_sectors = blk_queue_zone_sectors(q);
> +			zoned_dev->zone_nr_sectors = zone_nr_sectors;
> +			zoned_dev->nr_zones =
> +				blkdev_nr_zones(zoned_dev->bdev->bd_disk);
>  		}
>  	} else {
>  		reg_dev = NULL;
> @@ -800,17 +812,24 @@ static int dmz_fixup_devices(struct dm_target *ti)
>  			ti->error = "Disk is not a zoned device";
>  			return -EINVAL;
>  		}
> +		q = bdev_get_queue(zoned_dev->bdev);
> +		zoned_dev->zone_nr_sectors = blk_queue_zone_sectors(q);
> +		zoned_dev->nr_zones = blkdev_nr_zones(zoned_dev->bdev->bd_disk);
>  	}
> -	q = bdev_get_queue(zoned_dev->bdev);
> -	zoned_dev->zone_nr_sectors = blk_queue_zone_sectors(q);
> -	zoned_dev->nr_zones = blkdev_nr_zones(zoned_dev->bdev->bd_disk);
>  
>  	if (reg_dev) {
> -		reg_dev->zone_nr_sectors = zoned_dev->zone_nr_sectors;
> +		sector_t zone_offset;
> +
> +		reg_dev->zone_nr_sectors = zone_nr_sectors;
>  		reg_dev->nr_zones =
>  			DIV_ROUND_UP_SECTOR_T(reg_dev->capacity,
>  					      reg_dev->zone_nr_sectors);
> -		zoned_dev->zone_offset = reg_dev->nr_zones;
> +		reg_dev->zone_offset = 0;
> +		zone_offset = reg_dev->nr_zones;
> +		for (i = 1; i < dmz->nr_ddevs; i++) {
> +			dmz->dev[i].zone_offset = zone_offset;
> +			zone_offset += dmz->dev[i].nr_zones;
> +		}
>  	}
>  	return 0;
>  }
> @@ -824,7 +843,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	int ret, i;
>  
>  	/* Check arguments */
> -	if (argc < 1 || argc > 2) {
> +	if (argc < 1) {
>  		ti->error = "Invalid argument count";
>  		return -EINVAL;
>  	}
> @@ -835,32 +854,31 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  		ti->error = "Unable to allocate the zoned target descriptor";
>  		return -ENOMEM;
>  	}
> -	dmz->dev = kcalloc(2, sizeof(struct dmz_dev), GFP_KERNEL);
> +	dmz->dev = kcalloc(argc, sizeof(struct dmz_dev), GFP_KERNEL);
>  	if (!dmz->dev) {
>  		ti->error = "Unable to allocate the zoned device descriptors";
>  		kfree(dmz);
>  		return -ENOMEM;
>  	}
> +	dmz->ddev = kcalloc(argc, sizeof(struct dm_dev *), GFP_KERNEL);
> +	if (!dmz->ddev) {
> +		ti->error = "Unable to allocate the dm device descriptors";
> +		ret = -ENOMEM;
> +		goto err;
> +	}
>  	dmz->nr_ddevs = argc;
> +
>  	ti->private = dmz;
>  
>  	/* Get the target zoned block device */
> -	ret = dmz_get_zoned_device(ti, argv[0], 0, argc);
> -	if (ret)
> -		goto err;
> -
> -	if (argc == 2) {
> -		ret = dmz_get_zoned_device(ti, argv[1], 1, argc);
> -		if (ret) {
> -			dmz_put_zoned_device(ti);
> -			goto err;
> -		}
> +	for (i = 0; i < argc; i++) {
> +		ret = dmz_get_zoned_device(ti, argv[i], i, argc);
> +		if (ret)
> +			goto err_dev;
>  	}
>  	ret = dmz_fixup_devices(ti);
> -	if (ret) {
> -		dmz_put_zoned_device(ti);
> -		goto err;
> -	}
> +	if (ret)
> +		goto err_dev;
>  
>  	/* Initialize metadata */
>  	ret = dmz_ctr_metadata(dmz->dev, argc, &dmz->metadata,
> @@ -1056,13 +1074,13 @@ static int dmz_iterate_devices(struct dm_target *ti,
>  	struct dmz_target *dmz = ti->private;
>  	unsigned int zone_nr_sectors = dmz_zone_nr_sectors(dmz->metadata);
>  	sector_t capacity;
> -	int r;
> +	int i, r;
>  
> -	capacity = dmz->dev[0].capacity & ~(zone_nr_sectors - 1);
> -	r = fn(ti, dmz->ddev[0], 0, capacity, data);
> -	if (!r && dmz->ddev[1]) {
> -		capacity = dmz->dev[1].capacity & ~(zone_nr_sectors - 1);
> -		r = fn(ti, dmz->ddev[1], 0, capacity, data);
> +	for (i = 0; i < dmz->nr_ddevs; i++) {
> +		capacity = dmz->dev[i].capacity & ~(zone_nr_sectors - 1);
> +		r = fn(ti, dmz->ddev[i], 0, capacity, data);
> +		if (r)
> +			break;
>  	}
>  	return r;
>  }
> @@ -1083,9 +1101,7 @@ static void dmz_status(struct dm_target *ti, status_type_t type,
>  		       dmz_nr_zones(dmz->metadata),
>  		       dmz_nr_unmap_cache_zones(dmz->metadata),
>  		       dmz_nr_cache_zones(dmz->metadata));
> -		for (i = 0; i < DMZ_MAX_DEVS; i++) {
> -			if (!dmz->ddev[i])
> -				continue;
> +		for (i = 0; i < dmz->nr_ddevs; i++) {
>  			/*
>  			 * For a multi-device setup the first device
>  			 * contains only cache zones.
> @@ -1104,8 +1120,8 @@ static void dmz_status(struct dm_target *ti, status_type_t type,
>  		dev = &dmz->dev[0];
>  		format_dev_t(buf, dev->bdev->bd_dev);
>  		DMEMIT("%s", buf);
> -		if (dmz->dev[1].bdev) {
> -			dev = &dmz->dev[1];
> +		for (i = 1; i < dmz->nr_ddevs; i++) {
> +			dev = &dmz->dev[i];
>  			format_dev_t(buf, dev->bdev->bd_dev);
>  			DMEMIT(" %s", buf);
>  		}
> @@ -1133,7 +1149,7 @@ static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
>  
>  static struct target_type dmz_type = {
>  	.name		 = "zoned",
> -	.version	 = {2, 0, 0},
> +	.version	 = {3, 0, 0},
>  	.features	 = DM_TARGET_SINGLETON | DM_TARGET_ZONED_HM,
>  	.module		 = THIS_MODULE,
>  	.ctr		 = dmz_ctr,

Looks all good to me, but thinking more about it, don't we need to add
a device index in the super blocks ? The reason is that if the drive
configuration changes between stopt/start (drives removed, added or
changed slots), the drive names will change and while the userspace
will still be able to find the group of drives constituting the target
(using UUID9, there is no obvious way to find out what the original
drive order was. Since the kernel side relies on the drive being passed
to the ctr function in the order of the mapping, we need to preserve
that. Or change also the kernel side to use the index in the super
block to put each drive in its correct dmz->dev[] slot.

-- 
Damien Le Moal
Western Digital Research
