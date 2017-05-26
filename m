From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: [PATCH v3 00/10] dm: zoned block device support
Date: Fri, 26 May 2017 18:10:26 +0900
Message-ID: <7e0a0545-ee54-e367-5ea4-8b30e03cc10d@wdc.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
	<20170516200356.GA17063@redhat.com> <20170517185434.GC21862@redhat.com>
	<22BA92ED-D53B-4206-9DF3-BDFBB6F3E1DB@hgst.com>
	<20170526021211.GA33284@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170526021211.GA33284@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mike,

On 5/26/17 11:12, Mike Snitzer wrote:
> I'd like to get your thoughts on replacing the first 3 patches with
> something like the following patch (_not_ compile tested).
> 
> Basically I'm not interested in training DM for hypothetical zoned block
> device configurations.  I only want the bare minimum that is needed to
> support the dm-zoned target at this point.  The fact that dm-zoned is
> "drive managed" makes for a much more narrow validation (AFAICT anyway).

Indeed, it does. And in fact, no patches to the current dm code is
necessary for dm-zoned to compile and run. So the bare minimum for
dm-zoned is itself. This comes from the fact that dm-zoned will not
accept a target that is not an entire zoned block device, and only a
single target is allowed per dm-zoned instance. And since the queue
limit defaults currently to the NONE zone model, everything nicely fit
with the characteristics of the disk that dm-zoned exposes.

dm-zoned was coded this way for simplicity. Otherwise, the scattering of
conventional zones across different targets would have complicated
things quite a bit with metadata and would also potentially have
generated nasty performance characteristics.

In the series, patches 1-9 are solely for supporting zoned block devices
in a clean manner, and in particular dm-flakey, for testing file systems
with native zoned block device support, and dm-linear, because it is
easy and allows separating conventional and sequential zones into
different drives, with the conventional zones block device becoming a
normal disk (we have quite a few customers wanting to use SMR drives in
this manner).

> I dropped the zone_sectors validation -- we can backfill it if you feel
> it important but I wanted to float this simplified patch as is:

I think it is. The constraints imposed on zoned block devices in Linux
that are not mandated by the standards are that all zones of the device
must be the same size and the size must be a power of 2 number of LBAs.
Without validating that all devices of a target have an equal zone size,
a device created with dm-linear for instance would end up exposing
different zone sizes on the same block device. That would break the
block layer handling of zones through chunk_sectors.

That said, the patch below looks very good, much cleaner than what I had
done. Let me test it and I will report back.

> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 5f5eae4..0e4407e 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -340,6 +340,30 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  		return 1;
>  	}
>  
> +	/*
> +	 * If the target is mapped to zoned block device(s), check
> +	 * that the zones are not partially mapped.
> +	 */
> +	if (bdev_zoned_model(bdev) != BLK_ZONED_NONE) {
> +		unsigned int zone_sectors = bdev_zone_sectors(bdev);
> +
> +		if (start & (zone_sectors - 1)) {
> +			DMWARN("%s: start=%llu not aligned to h/w zone size %u of %s",
> +			       dm_device_name(ti->table->md),
> +			       (unsigned long long)start,
> +			       zone_sectors, bdevname(bdev, b));
> +			return 1;
> +		}
> +
> +		if (len & (zone_sectors - 1)) {
> +			DMWARN("%s: len=%llu not aligned to h/w zone size %u of %s",
> +			       dm_device_name(ti->table->md),
> +			       (unsigned long long)len,
> +			       zone_sectors, bdevname(bdev, b));
> +			return 1;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -456,6 +480,8 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
>  		       q->limits.alignment_offset,
>  		       (unsigned long long) start << SECTOR_SHIFT);
>  
> +	limits->zoned = blk_queue_zoned_model(q);
> +
>  	return 0;
>  }
>  
> @@ -1346,6 +1372,36 @@ bool dm_table_has_no_data_devices(struct dm_table *table)
>  	return true;
>  }
>  
> +static int device_is_zoned_model(struct dm_target *ti, struct dm_dev *dev,
> +				 sector_t start, sector_t len, void *data)
> +{
> +	struct request_queue *q = bdev_get_queue(dev->bdev);
> +	enum blk_zoned_model zoned_model = *data;
> +
> +	return q && blk_queue_zoned_model(q) == zoned_model;
> +}
> +
> +static bool dm_table_supports_zoned_model(struct dm_table *t,
> +					  enum blk_zoned_model zoned_model)
> +{
> +	struct dm_target *ti;
> +	unsigned i;
> +
> +	for (i = 0; i < dm_table_get_num_targets(t); i++) {
> +		ti = dm_table_get_target(t, i);
> +
> +		if (zoned_model == BLK_ZONED_HM &&
> +		    !dm_target_supports_zoned_hm(ti->type))
> +			return false;
> +
> +		if (!ti->type->iterate_devices ||
> +		    !ti->type->iterate_devices(ti, device_is_zoned_model, &zoned_model))
> +			return false;
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * Establish the new table's queue_limits and validate them.
>   */
> @@ -1355,6 +1411,7 @@ int dm_calculate_queue_limits(struct dm_table *table,
>  	struct dm_target *ti;
>  	struct queue_limits ti_limits;
>  	unsigned i;
> +	enum blk_zoned_model zoned_model = BLK_ZONED_NONE;
>  
>  	blk_set_stacking_limits(limits);
>  
> @@ -1372,6 +1429,14 @@ int dm_calculate_queue_limits(struct dm_table *table,
>  		ti->type->iterate_devices(ti, dm_set_device_limits,
>  					  &ti_limits);
>  
> +		if (zoned_model == BLK_ZONED_NONE && ti_limits.zoned != BLK_ZONED_NONE) {
> +			/*
> +			 * After stacking all limits, validate all devices
> +			 * in table support this zoned model.
> +			 */
> +			zoned_model = ti_limits.zoned;
> +		}
> +
>  		/* Set I/O hints portion of queue limits */
>  		if (ti->type->io_hints)
>  			ti->type->io_hints(ti, &ti_limits);
> @@ -1398,6 +1463,19 @@ int dm_calculate_queue_limits(struct dm_table *table,
>  			       (unsigned long long) ti->len);
>  	}
>  
> +	/*
> +	 * Verify that the zoned model, as determined before any .io_hints
> +	 * override, is the same across all devices in the table.
> +	 * - but if limits->zoned is not BLK_ZONED_NONE validate match for it
> +	 */
> +	if (limits->zoned != BLK_ZONED_NONE)
> +		zoned_model = limits->zoned;
> +	if (!dm_table_supports_zoned_model(table, zoned_model)) {
> +		DMERR("%s: zoned model is inconsistent across all devices"
> +		      dm_device_name(table->md));
> +		return -EINVAL;
> +	}
> +
>  	return validate_hardware_logical_block_alignment(table, limits);
>  }
>  
> diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
> index f4c639c..d13fcd2 100644
> --- a/include/linux/device-mapper.h
> +++ b/include/linux/device-mapper.h
> @@ -237,6 +237,12 @@ typedef unsigned (*dm_num_write_bios_fn) (struct dm_target *ti, struct bio *bio)
>  #define DM_TARGET_PASSES_INTEGRITY	0x00000020
>  #define dm_target_passes_integrity(type) ((type)->features & DM_TARGET_PASSES_INTEGRITY)
>  
> +/*
> + * Indicates that a target supports host-managed zoned block devices.
> + */
> +#define DM_TARGET_ZONED_HM		0x00000040
> +#define dm_target_supports_zoned_hm(type) ((type)->features & DM_TARGET_ZONED_HM)
> +
>  struct dm_target {
>  	struct dm_table *table;
>  	struct target_type *type;
> 

-- 
Damien Le Moal, Ph.D.
Sr Manager, System Software Group,
Western Digital Research
Damien.LeMoal@wdc.com
Tel: (+81) 0466-98-3593 (Ext. 51-3593)
1 kirihara-cho, Fujisawa, Kanagawa, 252-0888 Japan
www.wdc.com, www.hgst.com
Western Digital Corporation (and its subsidiaries) E-mail Confidentiality Notice & Disclaimer:

This e-mail and any files transmitted with it may contain confidential or legally privileged information of WDC and/or its affiliates, and are intended solely for the use of the individual or entity to which they are addressed. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited. If you have received this e-mail in error, please notify the sender immediately and delete the e-mail in its entirety from your system.
