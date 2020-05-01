From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 13/13] dm-zoned: metadata version 2
Date: Fri, 1 May 2020 00:15:13 +0000
Message-ID: <BY5PR04MB69007AC959AB1FB32B63453AE7AB0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200420100824.124618-1-hare@suse.de>
	<20200420100824.124618-14-hare@suse.de>
	<BY5PR04MB6900EA4ACB7303A1D5889C0EE7AC0@BY5PR04MB6900.namprd04.prod.outlook.com>
	<00d8048c-4f2e-82ef-7296-978ffa05bf62@suse.de>
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

On 2020/04/30 23:45, Hannes Reinecke wrote:
>>> +unsigned int dmz_dev_zone_id(struct dmz_metadata *zmd, struct dm_zone *zone)
>>> +{
>>> +	unsigned int zone_id;
>>> +
>>> +	if (WARN_ON(!zone))
>>> +		return 0;
>>> +
>>> +	zone_id = zone->id;
>>> +	if (zmd->nr_devs > 1 &&
>>> +	    (zone_id >= zmd->dev[1].zone_offset))
>>> +		zone_id -= zmd->dev[1].zone_offset;
>>
>> We could have this as:
>>
>> 	if (zone_id >= zmd->dev[0].nr_zones)
>> 		zone_id -= zmd->dev[0].nr_zones;
>>
>> No ? It is simpler and we can kill the zone_offset.
>>
> Yes, but it will make the device arrangement implicit; by specifying
> the block offset we allow us the option of possibly moving the block 
> offset into the metadata, and then having the metadata specifying the
> layout.
> Something which I'd like to keep as I have this weird idea of using 
> other, non-standard, drives, too, which then would require a more 
> complex layout.

OK. Got it. Let's keep this as is then.


-- 
Damien Le Moal
Western Digital Research
