From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 06/11] dm-zoned: remove 'dev' argument from
	reclaim
Date: Tue, 14 Apr 2020 06:37:33 +0000
Message-ID: <BY5PR04MB6900FEA91E3FFC617A885F25E7DA0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200409064527.82992-1-hare@suse.de>
	<20200409064527.82992-7-hare@suse.de>
	<BY5PR04MB69009A34D81599FF8208A014E7DE0@BY5PR04MB6900.namprd04.prod.outlook.com>
	<9a5ae1d5-4769-c1fa-2a52-f1f8fd6b25e0@suse.de>
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

On 2020/04/14 15:34, Hannes Reinecke wrote:
> On 4/10/20 8:43 AM, Damien Le Moal wrote:
>> On 2020/04/09 15:45, Hannes Reinecke wrote:
>>> Use the dmz_zone_to_dev() mapping function to remove the
>>> 'dev' argument from reclaim.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>   drivers/md/dm-zoned-metadata.c |  5 +++
>>>   drivers/md/dm-zoned-reclaim.c  | 63 +++++++++++++++++-----------------
>>>   drivers/md/dm-zoned-target.c   |  2 +-
>>>   drivers/md/dm-zoned.h          |  4 ++-
>>>   4 files changed, 41 insertions(+), 33 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
>>> index 7cda48683c0b..cd4a8093da24 100644
>>> --- a/drivers/md/dm-zoned-metadata.c
>>> +++ b/drivers/md/dm-zoned-metadata.c
>>> @@ -267,6 +267,11 @@ const char *dmz_metadata_label(struct dmz_metadata *zmd)
>>>   	return (const char *)zmd->devname;
>>>   }
>>>   
>>> +bool dmz_check_dev(struct dmz_metadata *zmd)
>>> +{
>>> +	return dmz_check_bdev(&zmd->dev[0]);
>>> +}
>>> +
>>>   /*
>>>    * Lock/unlock mapping table.
>>>    * The map lock also protects all the zone lists.
>>> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
>>> index 699c4145306e..102e0686542a 100644
>>> --- a/drivers/md/dm-zoned-reclaim.c
>>> +++ b/drivers/md/dm-zoned-reclaim.c
>>> @@ -13,7 +13,6 @@
>>>   
>>>   struct dmz_reclaim {
>>>   	struct dmz_metadata     *metadata;
>>> -	struct dmz_dev		*dev;
>>>   
>>>   	struct delayed_work	work;
>>>   	struct workqueue_struct *wq;
>>> @@ -59,6 +58,7 @@ static int dmz_reclaim_align_wp(struct dmz_reclaim *zrc, struct dm_zone *zone,
>>>   				sector_t block)
>>>   {
>>>   	struct dmz_metadata *zmd = zrc->metadata;
>>> +	struct dmz_dev *dev = dmz_zone_to_dev(zmd, zone);
>>>   	sector_t wp_block = zone->wp_block;
>>>   	unsigned int nr_blocks;
>>>   	int ret;
>>> @@ -74,15 +74,15 @@ static int dmz_reclaim_align_wp(struct dmz_reclaim *zrc, struct dm_zone *zone,
>>>   	 * pointer and the requested position.
>>>   	 */
>>>   	nr_blocks = block - wp_block;
>>> -	ret = blkdev_issue_zeroout(zrc->dev->bdev,
>>> +	ret = blkdev_issue_zeroout(dev->bdev,
>>>   				   dmz_start_sect(zmd, zone) + dmz_blk2sect(wp_block),
>>>   				   dmz_blk2sect(nr_blocks), GFP_NOIO, 0);
>>>   	if (ret) {
>>> -		dmz_dev_err(zrc->dev,
>>> +		dmz_dev_err(dev,
>>>   			    "Align zone %u wp %llu to %llu (wp+%u) blocks failed %d",
>>>   			    zone->id, (unsigned long long)wp_block,
>>>   			    (unsigned long long)block, nr_blocks, ret);
>>> -		dmz_check_bdev(zrc->dev);
>>> +		dmz_check_bdev(dev);
>>>   		return ret;
>>>   	}
>>>   
>>> @@ -116,7 +116,7 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
>>>   			    struct dm_zone *src_zone, struct dm_zone *dst_zone)
>>>   {
>>>   	struct dmz_metadata *zmd = zrc->metadata;
>>> -	struct dmz_dev *dev = zrc->dev;
>>> +	struct dmz_dev *src_dev, *dst_dev;
>>>   	struct dm_io_region src, dst;
>>>   	sector_t block = 0, end_block;
>>>   	sector_t nr_blocks;
>>> @@ -130,13 +130,17 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
>>>   	else
>>>   		end_block = dmz_zone_nr_blocks(zmd);
>>>   	src_zone_block = dmz_start_block(zmd, src_zone);
>>> +	src_dev = dmz_zone_to_dev(zmd, src_zone);
>>>   	dst_zone_block = dmz_start_block(zmd, dst_zone);
>>> +	dst_dev = dmz_zone_to_dev(zmd, dst_zone);
>>>   
>>>   	if (dmz_is_seq(dst_zone))
>>>   		set_bit(DM_KCOPYD_WRITE_SEQ, &flags);
>>>   
>>>   	while (block < end_block) {
>>> -		if (dev->flags & DMZ_BDEV_DYING)
>>> +		if (src_dev->flags & DMZ_BDEV_DYING)
>>> +			return -EIO;
>>> +		if (dst_dev->flags & DMZ_BDEV_DYING)
>>>   			return -EIO;
>>>   
>>>   		/* Get a valid region from the source zone */
>>> @@ -156,11 +160,11 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
>>>   				return ret;
>>>   		}
>>>   
>>> -		src.bdev = dev->bdev;
>>> +		src.bdev = src_dev->bdev;
>>>   		src.sector = dmz_blk2sect(src_zone_block + block);
>>>   		src.count = dmz_blk2sect(nr_blocks);
>>>   
>>> -		dst.bdev = dev->bdev;
>>> +		dst.bdev = dst_dev->bdev;
>>>   		dst.sector = dmz_blk2sect(dst_zone_block + block);
>>>   		dst.count = src.count;
>>>   
>>> @@ -194,10 +198,10 @@ static int dmz_reclaim_buf(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>>>   	struct dmz_metadata *zmd = zrc->metadata;
>>>   	int ret;
>>>   
>>> -	dmz_dev_debug(zrc->dev,
>>> -		      "Chunk %u, move buf zone %u (weight %u) to data zone %u (weight %u)",
>>> -		      dzone->chunk, bzone->id, dmz_weight(bzone),
>>> -		      dzone->id, dmz_weight(dzone));
>>> +	DMDEBUG("(%s): Chunk %u, move buf zone %u (weight %u) to data zone %u (weight %u)",
>>> +		dmz_metadata_label(zmd),
>>> +		dzone->chunk, bzone->id, dmz_weight(bzone),
>>> +		dzone->id, dmz_weight(dzone));
>>>   
>>>   	/* Flush data zone into the buffer zone */
>>>   	ret = dmz_reclaim_copy(zrc, bzone, dzone);
>>> @@ -233,10 +237,10 @@ static int dmz_reclaim_seq_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>>>   	struct dmz_metadata *zmd = zrc->metadata;
>>>   	int ret = 0;
>>>   
>>> -	dmz_dev_debug(zrc->dev,
>>> -		      "Chunk %u, move data zone %u (weight %u) to buf zone %u (weight %u)",
>>> -		      chunk, dzone->id, dmz_weight(dzone),
>>> -		      bzone->id, dmz_weight(bzone));
>>> +	DMDEBUG("(%s): Chunk %u, move data zone %u (weight %u) to buf zone %u (weight %u)",
>>> +		dmz_metadata_label(zmd),
>>> +		chunk, dzone->id, dmz_weight(dzone),
>>> +		bzone->id, dmz_weight(bzone));
>>>   
>>>   	/* Flush data zone into the buffer zone */
>>>   	ret = dmz_reclaim_copy(zrc, dzone, bzone);
>>> @@ -285,9 +289,9 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>>>   	if (!szone)
>>>   		return -ENOSPC;
>>>   
>>> -	dmz_dev_debug(zrc->dev,
>>> -		      "Chunk %u, move rnd zone %u (weight %u) to seq zone %u",
>>> -		      chunk, dzone->id, dmz_weight(dzone), szone->id);
>>> +	DMDEBUG("(%s): Chunk %u, move rnd zone %u (weight %u) to seq zone %u",
>>> +		dmz_metadata_label(zmd),
>>> +		chunk, dzone->id, dmz_weight(dzone), szone->id);
>>>   
>>>   	/* Flush the random data zone into the sequential zone */
>>>   	ret = dmz_reclaim_copy(zrc, dzone, szone);
>>> @@ -343,6 +347,7 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>>>   	struct dmz_metadata *zmd = zrc->metadata;
>>>   	struct dm_zone *dzone;
>>>   	struct dm_zone *rzone;
>>> +	struct dmz_dev *dev;
>>>   	unsigned long start;
>>>   	int ret;
>>>   
>>> @@ -352,7 +357,7 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>>>   		return PTR_ERR(dzone);
>>>   
>>>   	start = jiffies;
>>> -
>>> +	dev = dmz_zone_to_dev(zmd, dzone);
>>>   	if (dmz_is_rnd(dzone)) {
>>>   		if (!dmz_weight(dzone)) {
>>>   			/* Empty zone */
>>> @@ -400,14 +405,14 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>>>   
>>>   	ret = dmz_flush_metadata(zrc->metadata);
>>>   	if (ret) {
>>> -		dmz_dev_debug(zrc->dev,
>>> -			      "Metadata flush for zone %u failed, err %d\n",
>>> -			      rzone->id, ret);
>>> +		DMDEBUG("(%s): Metadata flush for zone %u failed, err %d\n",
>>> +			dmz_metadata_label(zmd), rzone->id, ret);
>>>   		return ret;
>>>   	}
>>>   
>>> -	dmz_dev_debug(zrc->dev, "Reclaimed zone %u in %u ms",
>>> -		      rzone->id, jiffies_to_msecs(jiffies - start));
>>> +	DMDEBUG("(%s): Reclaimed zone %u in %u ms",
>>> +		dmz_metadata_label(zmd),
>>> +		rzone->id, jiffies_to_msecs(jiffies - start));
>>>   	return 0;
>>>   }
>>>   
>>> @@ -455,9 +460,6 @@ static void dmz_reclaim_work(struct work_struct *work)
>>>   	unsigned int p_unmap_rnd;
>>>   	int ret;
>>>   
>>> -	if (dmz_bdev_is_dying(zrc->dev))
>>> -		return;
>>> -
>>
>> Why do you remove this ? We should not try to start reclaim if the device is
>> alreaady marked as dying.

Ah. Yes, of course. We could simplify though: any one of the 2 device marked as
dying equal a dying dmzoned target. We do not need to know which drive.

>>
> Because when moving to several devices we wouldn't know which device to 
> check at this point.
> But we could replace it with dmz_check_dev() like I did below.
> 
> Will be updating it for the next round.
> 
> Cheers,
> 
> Hannes
> 


-- 
Damien Le Moal
Western Digital Research
