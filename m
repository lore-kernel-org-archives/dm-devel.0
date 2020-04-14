From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 11/11] dm-zoned: metadata version 2
Date: Tue, 14 Apr 2020 05:58:44 +0000
Message-ID: <BY5PR04MB6900554B6F4AA00619BDC67FE7DA0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200409064527.82992-1-hare@suse.de>
	<20200409064527.82992-12-hare@suse.de>
	<BY5PR04MB690091C3AD432DCF2B08658FE7DD0@BY5PR04MB6900.namprd04.prod.outlook.com>
	<7f791599-afca-cc07-31f0-bc1cd4702dae@suse.de>
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

On 2020/04/14 14:47, Hannes Reinecke wrote:
[...]
>>> +
>>> +	if (zmd->dev[0].zone_offset &&
>>> +	    zone->id < zmd->dev[0].zone_offset)
>>> +			return &zmd->dev[1];
>>> +
>>>   	return &zmd->dev[0];
>>>   }
>>
>> OK. This one still confuses me. I think we need to have a comment here reminding
>> that when there are 2 devices, the second one holds the low ID zones and the
>> first one (the SMR drive) the high ID zones. While I think it is OK as is (with
>> the comment), I still think we should reverse that as the reverse would be more
>> natural...
>>
> Sure, we can reverse the order of devices by using the regular disk 
> device as first and the SMR drive as second argument when creating the 
> device-mapper device:
> 
> 0 <size> zoned <regular device> <zoned device>
> 
> That would make it more natural, and we don't have to rearrange disks 
> within the code.
> 
> We'd lose compability with v1, but one could argue it's not a bad thing.

Not sure what you mean here. For the single drive case, we would have:

0 <size> zoned <zoned device>

and the zoned device ending up in zmd->dev[0]. The format can be V1 or v2 single
drive. Where is the problem ? Similarly to the V2 2-drive case, in this case too
zmd->dev[0] holds the metadata and random zones. So it should still work as
is... Or am I missing something ?

[...]
>>> -	dev->zone_nr_sectors = blk_queue_zone_sectors(q);
>>> -
>>> -	dev->nr_zones = blkdev_nr_zones(dev->bdev->bd_disk);
>>> -
>>> -	dmz->dev = dev;
>>> -
>>> +	if (num == 1) {
>>> +		dev->zone_nr_sectors = dmz->dev[0].zone_nr_sectors;
>>> +		dev->nr_zones = dev->capacity / dev->zone_nr_sectors;
>>> +		if (dev->capacity % dev->nr_zones)
>>> +			dev->nr_zones++;
>>
>> dev->nr_zones =
>> 	(dev->capacity + dev->zone_nr_sectors - 1) / dev->zone_nr_sectors;
>>
>> or use DIV_ROUND_UP() ?
>>
> OK.
> 
>> And may be add a comment to remind (again) that znd->dev[1] is the normal disk
>> so we cannot use blk_queue_zone_sectors() and blkdev_nr_zones().
>>
> Or, better still, check if it's a regular device and drop the magic 'num 
> == 1' comparison.

Yes, that would be easier !

Best.

-- 
Damien Le Moal
Western Digital Research
