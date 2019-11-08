From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 4/9] block: Remove partition support for
 zoned block devices
Date: Fri, 8 Nov 2019 07:28:15 +0000
Message-ID: <BYAPR04MB58161069E47E24E188FC91EEE77B0@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
 <20191108015702.233102-5-damien.lemoal@wdc.com>
 <160bfb8f-2793-af74-df2b-5f30ae9383db@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
Content-Language: en-US
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Hannes Reinecke <hare@suse.de>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K .
 Petersen" <martin.petersen@oracle.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
List-Id: dm-devel.ids

On 2019/11/08 16:17, Hannes Reinecke wrote:
> On 11/8/19 2:56 AM, Damien Le Moal wrote:
>> No known partitioning tool supports zoned block devices, especially the
>> host managed flavor with strong sequential write constraints.
>> Furthermore, there are also no known user nor use cases for partitioned
>> zoned block devices.
>>
>> This patch removes partition device creation for zoned block devices,
>> which allows simplifying the processing of zone commands for zoned
>> block devices. A warning is added if a partition table is found on the
>> device.
>>
>> For report zones operations no zone sector information remapping is
>> necessary anymore, simplifying the code. Of note is that remapping of
>> zone reports for DM targets is still necessary as done by
>> dm_remap_zone_report().
>>
>> Similarly, remaping of a zone reset bio is not necessary anymore.
>> Testing for the applicability of the zone reset all request also becomes
>> simpler and only needs to check that the number of sectors of the
>> requested zone range is equal to the disk capacity.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> ---
>>  block/blk-core.c          |  6 +---
>>  block/blk-zoned.c         | 62 ++++++--------------------------
>>  block/partition-generic.c | 74 +++++----------------------------------
>>  drivers/md/dm.c           |  3 --
>>  4 files changed, 21 insertions(+), 124 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 3306a3c5bed6..df6b70476187 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -851,11 +851,7 @@ static inline int blk_partition_remap(struct bio *bio)
>>  	if (unlikely(bio_check_ro(bio, p)))
>>  		goto out;
>>  
>> -	/*
>> -	 * Zone management bios do not have a sector count but they do have
>> -	 * a start sector filled out and need to be remapped.
>> -	 */
>> -	if (bio_sectors(bio) || op_is_zone_mgmt(bio_op(bio))) {
>> +	if (bio_sectors(bio)) {
>>  		if (bio_check_eod(bio, part_nr_sects_read(p)))
>>  			goto out;
>>  		bio->bi_iter.bi_sector += p->start_sect;
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index ea4e086ba00e..ae665e490858 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -93,32 +93,10 @@ unsigned int blkdev_nr_zones(struct block_device *bdev)
>>  	if (!blk_queue_is_zoned(q))
>>  		return 0;
>>  
>> -	return __blkdev_nr_zones(q, bdev->bd_part->nr_sects);
>> +	return __blkdev_nr_zones(q, get_capacity(bdev->bd_disk));
>>  }
>>  EXPORT_SYMBOL_GPL(blkdev_nr_zones);
>>  
>> -/*
>> - * Check that a zone report belongs to this partition, and if yes, fix its start
>> - * sector and write pointer and return true. Return false otherwise.
>> - */
>> -static bool blkdev_report_zone(struct block_device *bdev, struct blk_zone *rep)
>> -{
>> -	sector_t offset = get_start_sect(bdev);
>> -
>> -	if (rep->start < offset)
>> -		return false;
>> -
>> -	rep->start -= offset;
>> -	if (rep->start + rep->len > bdev->bd_part->nr_sects)
>> -		return false;
>> -
>> -	if (rep->type == BLK_ZONE_TYPE_CONVENTIONAL)
>> -		rep->wp = rep->start + rep->len;
>> -	else
>> -		rep->wp -= offset;
>> -	return true;
>> -}
>> -
>>  /**
>>   * blkdev_report_zones - Get zones information
>>   * @bdev:	Target block device
>> @@ -140,8 +118,7 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
>>  {
>>  	struct request_queue *q = bdev_get_queue(bdev);
>>  	struct gendisk *disk = bdev->bd_disk;
>> -	unsigned int i, nrz;
>> -	int ret;
>> +	sector_t capacity = get_capacity(disk);
>>  
>>  	if (!blk_queue_is_zoned(q))
>>  		return -EOPNOTSUPP;
>> @@ -154,27 +131,14 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
>>  	if (WARN_ON_ONCE(!disk->fops->report_zones))
>>  		return -EOPNOTSUPP;
>>  
>> -	if (!*nr_zones || sector >= bdev->bd_part->nr_sects) {
>> +	if (!*nr_zones || sector >= capacity) {
>>  		*nr_zones = 0;
>>  		return 0;
>>  	}
>>  
>> -	nrz = min(*nr_zones,
>> -		  __blkdev_nr_zones(q, bdev->bd_part->nr_sects - sector));
>> -	ret = disk->fops->report_zones(disk, get_start_sect(bdev) + sector,
>> -				       zones, &nrz);
>> -	if (ret)
>> -		return ret;
>> +	*nr_zones = min(*nr_zones, __blkdev_nr_zones(q, capacity - sector));
>>  
>> -	for (i = 0; i < nrz; i++) {
>> -		if (!blkdev_report_zone(bdev, zones))
>> -			break;
>> -		zones++;
>> -	}
>> -
>> -	*nr_zones = i;
>> -
>> -	return 0;
>> +	return disk->fops->report_zones(disk, sector, zones, nr_zones);
>>  }
>>  EXPORT_SYMBOL_GPL(blkdev_report_zones);
>>  
>> @@ -185,15 +149,11 @@ static inline bool blkdev_allow_reset_all_zones(struct block_device *bdev,
>>  	if (!blk_queue_zone_resetall(bdev_get_queue(bdev)))
>>  		return false;
>>  
>> -	if (sector || nr_sectors != part_nr_sects_read(bdev->bd_part))
>> -		return false;
>>  	/*
>> -	 * REQ_OP_ZONE_RESET_ALL can be executed only if the block device is
>> -	 * the entire disk, that is, if the blocks device start offset is 0 and
>> -	 * its capacity is the same as the entire disk.
>> +	 * REQ_OP_ZONE_RESET_ALL can be executed only if the number of sectors
>> +	 * of the applicable zone range is the entire disk.
>>  	 */
>> -	return get_start_sect(bdev) == 0 &&
>> -	       part_nr_sects_read(bdev->bd_part) == get_capacity(bdev->bd_disk);
>> +	return !sector && nr_sectors == get_capacity(bdev->bd_disk);
>>  }
>>  
>>  /**
>> @@ -218,6 +178,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>>  {
>>  	struct request_queue *q = bdev_get_queue(bdev);
>>  	sector_t zone_sectors = blk_queue_zone_sectors(q);
>> +	sector_t capacity = get_capacity(bdev->bd_disk);
>>  	sector_t end_sector = sector + nr_sectors;
>>  	struct bio *bio = NULL;
>>  	int ret;
>> @@ -231,7 +192,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>>  	if (!op_is_zone_mgmt(op))
>>  		return -EOPNOTSUPP;
>>  
>> -	if (!nr_sectors || end_sector > bdev->bd_part->nr_sects)
>> +	if (!nr_sectors || end_sector > capacity)
>>  		/* Out of range */
>>  		return -EINVAL;
>>  
>> @@ -239,8 +200,7 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_opf op,
>>  	if (sector & (zone_sectors - 1))
>>  		return -EINVAL;
>>  
>> -	if ((nr_sectors & (zone_sectors - 1)) &&
>> -	    end_sector != bdev->bd_part->nr_sects)
>> +	if ((nr_sectors & (zone_sectors - 1)) && end_sector != capacity)
>>  		return -EINVAL;
>>  
>>  	while (sector < end_sector) {
>> diff --git a/block/partition-generic.c b/block/partition-generic.c
>> index aee643ce13d1..31bff3fb28af 100644
>> --- a/block/partition-generic.c
>> +++ b/block/partition-generic.c
>> @@ -459,56 +459,6 @@ static int drop_partitions(struct gendisk *disk, struct block_device *bdev)
>>  	return 0;
>>  }
>>  
>> -static bool part_zone_aligned(struct gendisk *disk,
>> -			      struct block_device *bdev,
>> -			      sector_t from, sector_t size)
>> -{
>> -	unsigned int zone_sectors = bdev_zone_sectors(bdev);
>> -
>> -	/*
>> -	 * If this function is called, then the disk is a zoned block device
>> -	 * (host-aware or host-managed). This can be detected even if the
>> -	 * zoned block device support is disabled (CONFIG_BLK_DEV_ZONED not
>> -	 * set). In this case, however, only host-aware devices will be seen
>> -	 * as a block device is not created for host-managed devices. Without
>> -	 * zoned block device support, host-aware drives can still be used as
>> -	 * regular block devices (no zone operation) and their zone size will
>> -	 * be reported as 0. Allow this case.
>> -	 */
>> -	if (!zone_sectors)
>> -		return true;
>> -
>> -	/*
>> -	 * Check partition start and size alignement. If the drive has a
>> -	 * smaller last runt zone, ignore it and allow the partition to
>> -	 * use it. Check the zone size too: it should be a power of 2 number
>> -	 * of sectors.
>> -	 */
>> -	if (WARN_ON_ONCE(!is_power_of_2(zone_sectors))) {
>> -		u32 rem;
>> -
>> -		div_u64_rem(from, zone_sectors, &rem);
>> -		if (rem)
>> -			return false;
>> -		if ((from + size) < get_capacity(disk)) {
>> -			div_u64_rem(size, zone_sectors, &rem);
>> -			if (rem)
>> -				return false;
>> -		}
>> -
>> -	} else {
>> -
>> -		if (from & (zone_sectors - 1))
>> -			return false;
>> -		if ((from + size) < get_capacity(disk) &&
>> -		    (size & (zone_sectors - 1)))
>> -			return false;
>> -
>> -	}
>> -
>> -	return true;
>> -}
>> -
>>  int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
>>  {
>>  	struct parsed_partitions *state = NULL;
>> @@ -544,6 +494,14 @@ int rescan_partitions(struct gendisk *disk, struct block_device *bdev)
>>  		}
>>  		return -EIO;
>>  	}
>> +
>> +	/* Partitions are not supported on zoned block devices */
>> +	if (bdev_is_zoned(bdev)) {
>> +		pr_warn("%s: ignoring partition table on zoned block device\n",
>> +			disk->disk_name);
>> +		goto out;
>> +	}
>> +
>>  	/*
>>  	 * If any partition code tried to read beyond EOD, try
>>  	 * unlocking native capacity even if partition table is
> 
> While I do applaud removing special cases for zoned devices, we do have
> the GENHD_FL_NO_PART_SCAN for precisely this use case.
> Any particular reason why this isn't being used, nor even set?

If we set the flag, indeed partitions will be ignored, which is exactly
what we want. But that also means that there will be no warning message
whatsoever in the very unlikely case of a user using an SMR disk with
partitions. I fully agree with you that we should set this flag, but I
decided against it initially to have the "partition table ignored"
warning printed for now.

If, as I expect, there are no screams coming from the field/users, we
can then safely add the flag and remove some more code (the test and
pr_warn call in rescan_partitions()).

> 
> Cheers,
> 
> Hannes
> 


-- 
Damien Le Moal
Western Digital Research
