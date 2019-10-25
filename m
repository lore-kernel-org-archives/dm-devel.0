From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/4] block: Enhance
	blk_revalidate_disk_zones()
Date: Fri, 25 Oct 2019 05:15:06 +0000
Message-ID: <BN8PR04MB58124835167609CED0AD69FAE7650@BN8PR04MB5812.namprd04.prod.outlook.com>
References: <20191024065006.8684-1-damien.lemoal@wdc.com>
	<20191024065006.8684-2-damien.lemoal@wdc.com>
	<20191024070838.GA19572@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: dm-devel.ids

On 2019/10/24 16:08, Christoph Hellwig wrote:
>> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
>> index 4bc5f260248a..293891b7068a 100644
>> --- a/block/blk-zoned.c
>> +++ b/block/blk-zoned.c
>> @@ -441,6 +441,57 @@ void blk_queue_free_zone_bitmaps(struct request_queue *q)
>>  	q->seq_zones_wlock = NULL;
>>  }
>>  
>> +/**
>> + * blk_check_zone - Check a zone information
>> + * @q:		request queue
>> + * @zone:	the zone to  check
>> + * @sector:	start sector of the zone
>> + *
>> + * Helper function to check zones of a zoned block device. Returns true if the
>> + * zone is correct and false if a problem is detected.
>> + */
>> +static bool blk_check_zone(struct gendisk *disk, struct blk_zone *zone,
>> +			   sector_t *sector)
> 
> Maybe call this blk_zone_valid?  Also in many places we don't really
> do the verbose kerneldoc comments with the duplicated parameter names
> for local functions, as the scripts only pick up non-stack ones anyway.
> 
>> +	/*
>> +	 * All zones must have the same size, with the exception on an eventual
>> +	 * smaller last zone.
>> +	 */
>> +	if (zone->start + zone_sectors < capacity &&
>> +	    zone->len != zone_sectors) {
>> +		pr_warn("%s: Invalid zone device with non constant zone size\n",
>> +			disk->disk_name);
>> +		return false;
>> +	}
> 
> I think we should also move the power of two zone size check here
> instead of leaving it in the driver.

We should not since the drivers calls blk_queue_chunk_sectors() first to
set the zone size and that function has a power of 2 check. So better
check that earlier than here.

-- 
Damien Le Moal
Western Digital Research
