From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 10/12] dm-zoned: support arbitrary number of
	devices
Date: Mon, 25 May 2020 08:22:55 +0000
Message-ID: <CY4PR04MB3751A01110515AE5F82E4D96E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522153901.133375-1-hare@suse.de>
	<20200522153901.133375-11-hare@suse.de>
	<CY4PR04MB3751A184940AC59203AC4D33E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
	<c1e5003c-05ca-e441-b368-8e2707da438f@suse.de>
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
To: Hannes Reinecke <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2020/05/25 16:52, Hannes Reinecke wrote:
> On 5/25/20 4:36 AM, Damien Le Moal wrote:
>> On 2020/05/23 0:39, Hannes Reinecke wrote:
>>> Remove the hard-coded limit of two devices and support an unlimited
>>> number of additional zoned devices.
>>> With that we need to increase the device-mapper version number to
>>> 3.0.0 as we've modified the interface.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>   drivers/md/dm-zoned-metadata.c |  68 +++++++++++-----------
>>>   drivers/md/dm-zoned-reclaim.c  |  28 ++++++---
>>>   drivers/md/dm-zoned-target.c   | 129 +++++++++++++++++++++++++----------------
>>>   drivers/md/dm-zoned.h          |   9 +--
>>>   4 files changed, 139 insertions(+), 95 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
>>> index 5f44970a6187..87784e7785bc 100644
>>> --- a/drivers/md/dm-zoned-metadata.c
>>> +++ b/drivers/md/dm-zoned-metadata.c
>>> @@ -260,6 +260,11 @@ unsigned int dmz_zone_nr_sectors_shift(struct dmz_metadata *zmd)
>>>   	return zmd->zone_nr_sectors_shift;
>>>   }
>>>   
>>> +unsigned int dmz_nr_devs(struct dmz_metadata *zmd)
>>> +{
>>> +	return zmd->nr_devs;
>>> +}
>>
>> Is this helper really needed ?
>>
> 
> Yes, in dm-zoned-reclaim.c

I meant to say: whoever needs to know the number of devices can just use
"zmd->nr_devs". No need for a helper for that was my point.


> 
>>> +
>>>   unsigned int dmz_nr_zones(struct dmz_metadata *zmd)
>>>   {
>>>   	return zmd->nr_zones;
>>> @@ -270,24 +275,14 @@ unsigned int dmz_nr_chunks(struct dmz_metadata *zmd)
>>>   	return zmd->nr_chunks;
>>>   }
>>>   
>>> -unsigned int dmz_nr_rnd_zones(struct dmz_metadata *zmd)
>>> +unsigned int dmz_nr_rnd_zones(struct dmz_metadata *zmd, int idx)
>>>   {
>>> -	unsigned int nr_rnd_zones = 0;
>>> -	int i;
>>> -
>>> -	for (i = 0; i < zmd->nr_devs; i++)
>>> -		nr_rnd_zones += zmd->dev[i].nr_rnd;
>>> -	return nr_rnd_zones;
>>> +	return zmd->dev[idx].nr_rnd;
>>
>> AH. OK. So my comment on patch 8 is voided :)
>>
> Yeah, the patch arrangement could be improved; I'll see to roll both 
> changes into one patch.
> 
>>>   }
>>>   
>>> -unsigned int dmz_nr_unmap_rnd_zones(struct dmz_metadata *zmd)
>>> +unsigned int dmz_nr_unmap_rnd_zones(struct dmz_metadata *zmd, int idx)
>>>   {
>>> -	unsigned int nr_unmap_rnd_zones = 0;
>>> -	int i;
>>> -
>>> -	for (i = 0; i < zmd->nr_devs; i++)
>>> -		nr_unmap_rnd_zones += atomic_read(&zmd->dev[i].unmap_nr_rnd);
>>> -	return nr_unmap_rnd_zones;
>>> +	return atomic_read(&zmd->dev[idx].unmap_nr_rnd);
>>>   }
>>>   
>>>   unsigned int dmz_nr_cache_zones(struct dmz_metadata *zmd)
>>> @@ -300,24 +295,14 @@ unsigned int dmz_nr_unmap_cache_zones(struct dmz_metadata *zmd)
>>>   	return atomic_read(&zmd->unmap_nr_cache);
>>>   }
>>>   
>>> -unsigned int dmz_nr_seq_zones(struct dmz_metadata *zmd)
>>> +unsigned int dmz_nr_seq_zones(struct dmz_metadata *zmd, int idx)
>>>   {
>>> -	unsigned int nr_seq_zones = 0;
>>> -	int i;
>>> -
>>> -	for (i = 0; i < zmd->nr_devs; i++)
>>> -		nr_seq_zones += zmd->dev[i].nr_seq;
>>> -	return nr_seq_zones;
>>> +	return zmd->dev[idx].nr_seq;
>>>   }
>>>   
>>> -unsigned int dmz_nr_unmap_seq_zones(struct dmz_metadata *zmd)
>>> +unsigned int dmz_nr_unmap_seq_zones(struct dmz_metadata *zmd, int idx)
>>>   {
>>> -	unsigned int nr_unmap_seq_zones = 0;
>>> -	int i;
>>> -
>>> -	for (i = 0; i < zmd->nr_devs; i++)
>>> -		nr_unmap_seq_zones += atomic_read(&zmd->dev[i].unmap_nr_seq);
>>> -	return nr_unmap_seq_zones;
>>> +	return atomic_read(&zmd->dev[idx].unmap_nr_seq);
>>>   }
>>>   
>>>   static struct dm_zone *dmz_get(struct dmz_metadata *zmd, unsigned int zone_id)
>>> @@ -1530,7 +1515,20 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
>>>   		 */
>>>   		zmd->sb[0].zone = dmz_get(zmd, 0);
>>>   
>>> -		zoned_dev = &zmd->dev[1];
>>> +		for (i = 1; i < zmd->nr_devs; i++) {
>>> +			zoned_dev = &zmd->dev[i];
>>> +
>>> +			ret = blkdev_report_zones(zoned_dev->bdev, 0,
>>> +						  BLK_ALL_ZONES,
>>> +						  dmz_init_zone, zoned_dev);
>>> +			if (ret < 0) {
>>> +				DMDEBUG("(%s): Failed to report zones, error %d",
>>> +					zmd->devname, ret);
>>> +				dmz_drop_zones(zmd);
>>> +				return ret;
>>> +			}
>>> +		}
>>> +		return 0;
>>>   	}
>>>   
>>>   	/*
>>> @@ -2921,10 +2919,14 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
>>>   		      zmd->nr_data_zones, zmd->nr_chunks);
>>>   	dmz_zmd_debug(zmd, "    %u cache zones (%u unmapped)",
>>>   		      zmd->nr_cache, atomic_read(&zmd->unmap_nr_cache));
>>> -	dmz_zmd_debug(zmd, "    %u random zones (%u unmapped)",
>>> -		      dmz_nr_rnd_zones(zmd), dmz_nr_unmap_rnd_zones(zmd));
>>> -	dmz_zmd_debug(zmd, "    %u sequential zones (%u unmapped)",
>>> -		      dmz_nr_seq_zones(zmd), dmz_nr_unmap_seq_zones(zmd));
>>> +	for (i = 0; i < zmd->nr_devs; i++) {
>>> +		dmz_zmd_debug(zmd, "    %u random zones (%u unmapped)",
>>> +			      dmz_nr_rnd_zones(zmd, i),
>>> +			      dmz_nr_unmap_rnd_zones(zmd, i));
>>> +		dmz_zmd_debug(zmd, "    %u sequential zones (%u unmapped)",
>>> +			      dmz_nr_seq_zones(zmd, i),
>>> +			      dmz_nr_unmap_seq_zones(zmd, i));
>>> +	}
>>>   	dmz_zmd_debug(zmd, "  %u reserved sequential data zones",
>>>   		      zmd->nr_reserved_seq);
>>>   	dmz_zmd_debug(zmd, "Format:");
>>> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
>>> index fba0d48e38a7..f2e053b5f2db 100644
>>> --- a/drivers/md/dm-zoned-reclaim.c
>>> +++ b/drivers/md/dm-zoned-reclaim.c
>>> @@ -442,15 +442,18 @@ static unsigned int dmz_reclaim_percentage(struct dmz_reclaim *zrc)
>>>   {
>>>   	struct dmz_metadata *zmd = zrc->metadata;
>>>   	unsigned int nr_cache = dmz_nr_cache_zones(zmd);
>>> -	unsigned int nr_rnd = dmz_nr_rnd_zones(zmd);
>>> -	unsigned int nr_unmap, nr_zones;
>>> +	unsigned int nr_unmap = 0, nr_zones = 0;
>>>   
>>>   	if (nr_cache) {
>>>   		nr_zones = nr_cache;
>>>   		nr_unmap = dmz_nr_unmap_cache_zones(zmd);
>>>   	} else {
>>> -		nr_zones = nr_rnd;
>>> -		nr_unmap = dmz_nr_unmap_rnd_zones(zmd);
>>> +		int i;
>>> +
>>> +		for (i = 0; i < dmz_nr_devs(zmd); i++) {
>>> +			nr_zones += dmz_nr_rnd_zones(zmd, i);
>>
>> May be not... We could keep constant totals in zmd to avoid this.
>>
>>> +			nr_unmap += dmz_nr_unmap_rnd_zones(zmd, i);
>>> +		}
>>>   	}
>>>   	return nr_unmap * 100 / nr_zones;
>>>   }
>>> @@ -460,7 +463,11 @@ static unsigned int dmz_reclaim_percentage(struct dmz_reclaim *zrc)
>>>    */
>>>   static bool dmz_should_reclaim(struct dmz_reclaim *zrc, unsigned int p_unmap)
>>>   {
>>> -	unsigned int nr_reclaim = dmz_nr_rnd_zones(zrc->metadata);
>>> +	int i;
>>> +	unsigned int nr_reclaim = 0;
>>> +
>>> +	for (i = 0; i < dmz_nr_devs(zrc->metadata); i++)
>>> +		nr_reclaim += dmz_nr_rnd_zones(zrc->metadata, i);
>>>   
>>>   	if (dmz_nr_cache_zones(zrc->metadata))
>>>   		nr_reclaim += dmz_nr_cache_zones(zrc->metadata);
>>> @@ -487,8 +494,8 @@ static void dmz_reclaim_work(struct work_struct *work)
>>>   {
>>>   	struct dmz_reclaim *zrc = container_of(work, struct dmz_reclaim, work.work);
>>>   	struct dmz_metadata *zmd = zrc->metadata;
>>> -	unsigned int p_unmap;
>>> -	int ret;
>>> +	unsigned int p_unmap, nr_unmap_rnd = 0, nr_rnd = 0;
>>> +	int ret, i;
>>>   
>>>   	if (dmz_dev_is_dying(zmd))
>>>   		return;
>>> @@ -513,14 +520,17 @@ static void dmz_reclaim_work(struct work_struct *work)
>>>   		zrc->kc_throttle.throttle = min(75U, 100U - p_unmap / 2);
>>>   	}
>>>   
>>> +	for (i = 0; i < dmz_nr_devs(zmd); i++) {
>>> +		nr_unmap_rnd += dmz_nr_unmap_rnd_zones(zmd, i);
>>> +		nr_rnd += dmz_nr_rnd_zones(zmd, i);
>>> +	}
>>>   	DMDEBUG("(%s): Reclaim (%u): %s, %u%% free zones (%u/%u cache %u/%u random)",
>>>   		dmz_metadata_label(zmd),
>>>   		zrc->kc_throttle.throttle,
>>>   		(dmz_target_idle(zrc) ? "Idle" : "Busy"),
>>>   		p_unmap, dmz_nr_unmap_cache_zones(zmd),
>>>   		dmz_nr_cache_zones(zmd),
>>> -		dmz_nr_unmap_rnd_zones(zmd),
>>> -		dmz_nr_rnd_zones(zmd));
>>> +		nr_unmap_rnd, nr_rnd);
>>>   
>>>   	ret = dmz_do_reclaim(zrc);
>>>   	if (ret && ret != -EINTR) {
> 
> In the light of this I guess there is a benefit from having the counters
> in the metadata; that indeed would save us to having to export the 
> number of devices.
> I'll give it a go with the next round.
> 
>>> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
>>> index bca9a611b8dd..f34fcc3f7cc6 100644
>>> --- a/drivers/md/dm-zoned-target.c
>>> +++ b/drivers/md/dm-zoned-target.c
>>> @@ -13,8 +13,6 @@
>>>   
>>>   #define DMZ_MIN_BIOS		8192
>>>   
>>> -#define DMZ_MAX_DEVS		2
>>> -
>>>   /*
>>>    * Zone BIO context.
>>>    */
>>> @@ -40,9 +38,10 @@ struct dm_chunk_work {
>>>    * Target descriptor.
>>>    */
>>>   struct dmz_target {
>>> -	struct dm_dev		*ddev[DMZ_MAX_DEVS];
>>> +	struct dm_dev		**ddev;
>>> +	unsigned int		nr_ddevs;
>>>   
>>> -	unsigned long		flags;
>>> +	unsigned int		flags;
>>>   
>>>   	/* Zoned block device information */
>>>   	struct dmz_dev		*dev;
>>> @@ -764,7 +763,7 @@ static void dmz_put_zoned_device(struct dm_target *ti)
>>>   	struct dmz_target *dmz = ti->private;
>>>   	int i;
>>>   
>>> -	for (i = 0; i < DMZ_MAX_DEVS; i++) {
>>> +	for (i = 0; i < dmz->nr_ddevs; i++) {
>>>   		if (dmz->ddev[i]) {
>>>   			dm_put_device(ti, dmz->ddev[i]);
>>>   			dmz->ddev[i] = NULL;
>>> @@ -777,21 +776,35 @@ static int dmz_fixup_devices(struct dm_target *ti)
>>>   	struct dmz_target *dmz = ti->private;
>>>   	struct dmz_dev *reg_dev, *zoned_dev;
>>>   	struct request_queue *q;
>>> +	sector_t zone_nr_sectors = 0;
>>> +	int i;
>>>   
>>>   	/*
>>> -	 * When we have two devices, the first one must be a regular block
>>> -	 * device and the second a zoned block device.
>>> +	 * When we have more than on devices, the first one must be a
>>> +	 * regular block device and the others zoned block devices.
>>>   	 */
>>> -	if (dmz->ddev[0] && dmz->ddev[1]) {
>>> +	if (dmz->nr_ddevs > 1) {
>>>   		reg_dev = &dmz->dev[0];
>>>   		if (!(reg_dev->flags & DMZ_BDEV_REGULAR)) {
>>>   			ti->error = "Primary disk is not a regular device";
>>>   			return -EINVAL;
>>>   		}
>>> -		zoned_dev = &dmz->dev[1];
>>> -		if (zoned_dev->flags & DMZ_BDEV_REGULAR) {
>>> -			ti->error = "Secondary disk is not a zoned device";
>>> -			return -EINVAL;
>>> +		for (i = 1; i < dmz->nr_ddevs; i++) {
>>> +			zoned_dev = &dmz->dev[i];
>>> +			if (zoned_dev->flags & DMZ_BDEV_REGULAR) {
>>> +				ti->error = "Secondary disk is not a zoned device";
>>> +				return -EINVAL;
>>> +			}
>>> +			q = bdev_get_queue(zoned_dev->bdev);
>>
>> May be add a comment here that we must check that all zoned devices have the
>> same zone size ?
>>
> 
> I thought it was self-explanatory; but maybe not.
> Will be adding it.

It is indeed not too hard to figure out. But a plain english sentence is nice too :)

> 
> Cheers,
> 
> Hannes
> 


-- 
Damien Le Moal
Western Digital Research
