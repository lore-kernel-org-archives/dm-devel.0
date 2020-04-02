From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 4/4] dm-zoned: allow for device size smaller
 than the capacity
Date: Thu, 2 Apr 2020 02:45:00 +0000
Message-ID: <CO2PR04MB2343CFAF3E68FC7D53CFFC00E7C60@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200327071459.67796-1-hare@suse.de>
	<20200327071459.67796-5-hare@suse.de>
	<CO2PR04MB2343240ACAC524067A074813E7C80@CO2PR04MB2343.namprd04.prod.outlook.com>
	<3167d430-9987-150b-363d-dfce119a04b8@suse.de>
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

On 2020/03/31 17:53, Hannes Reinecke wrote:
> On 3/31/20 2:49 AM, Damien Le Moal wrote:
>> On 2020/03/27 16:15, Hannes Reinecke wrote:
>>> dm-zoned requires several zones for metadata and chunk bitmaps,
>>> so it cannot expose the entire capacity as the device size.
>>> Originally the code would check for the capacity being equal to
>>> the device size, which is arguably wrong.
>>> So relax this check and increase the interface version number
>>> to signal to userspace that it can set a smaller device size.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>   drivers/md/dm-zoned-target.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
>>> index 7ec9dde24516..89a825d1034e 100644
>>> --- a/drivers/md/dm-zoned-target.c
>>> +++ b/drivers/md/dm-zoned-target.c
>>> @@ -715,7 +715,7 @@ static int dmz_get_zoned_device(struct dm_target *ti, char *path)
>>>   	aligned_capacity = dev->capacity &
>>>   				~((sector_t)blk_queue_zone_sectors(q) - 1);
>>>   	if (ti->begin ||
>>> -	    ((ti->len != dev->capacity) && (ti->len != aligned_capacity))) {
>>> +	    ((ti->len > dev->capacity) && (ti->len > aligned_capacity))) {
>>>   		ti->error = "Partial mapping not supported";
>>
>> The message is now wrong. Also, the condition can now be simplified to:
>>
>> if ((ti->begin + ti->len) > aligned_capacity) {
>>
>> Since aligned capacity is equal or smaller than dev capacity. And we have to
>> account for the potential non-zero begin.
>>
> _Actually_ I would forbid for 'ti->begin' to be anything other than 0.
> For a zoned device there is no point in allowing for partial handling at 
> all.
> Problem is that 'dev->capacity' is the capacity of the zoned block 
> device, whereas 'ti-len' is the exported capacity of the device-mapper 
> device, which is smaller than the device capacity by the number of 
> metadata blocks/zones.

OK. Got it. I misunderstood that. Sounds good to me.

> 
>>>   		ret = -EINVAL;
>>>   		goto err;
>>> @@ -1008,7 +1008,7 @@ static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
>>>   
>>>   static struct target_type dmz_type = {
>>>   	.name		 = "zoned",
>>> -	.version	 = {1, 2, 0},
>>> +	.version	 = {1, 3, 0},
>>>   	.features	 = DM_TARGET_SINGLETON | DM_TARGET_ZONED_HM,
>>>   	.module		 = THIS_MODULE,
>>>   	.ctr		 = dmz_ctr,
>>>
>>
>> I do not think this is nearly enough: dmz_init_zones() is still considering the
>> entire drive and does a zone report from 0 on the backend bdev. It should start
>> at ti->begin and up to ti->begin+ti->len, no ?
>>
> Yes, and no. I want to disallow 'ti->begin' to be anything else than 0 
> as ti->begin and ti->len are relative to exported device-mapper device, 
> and we always want to have block 0 mapped :-)
> 
> And as such dmz_init_zones() needs to cover all zones, as this is 
> relative to the zoned block device.

Yes. Which is already the case since we need to see the metatdata and reserved
zones too. Makes sense.

> 
>> Furthermore, this introduce a change in the meaning of the zone ID. Since this
>> is set to the index of the zone in the report (patch 1), if the mapping is
>> partial and the zone report does not start at 0, then zone ID is not zone number
>> on the device anymore. So dmz_start_block() needs to be offset by ti->begin
>> otherwise IOs will go to the wrong zones.
>>
> As I said: We will never do a partial mapping.
> What this patch does it to bring the device-mapper mapping in-line with 
> the exported device size.

Got it !

> Originally we would export a device-mapper mapping for blocks up to the 
> zone-device capacity. As the resulting device-mapper block device has a 
> smaller capacity than the mapping would allow for those 'spare' blocks 
> would never been used, thus the invalid mapping was never triggered.
> 
> What this patch does is to bring the device-mapper mapping in-line with 
> the exported block device capacity, so that we don't have an invalid 
> mapping. Nothing else has (and should) be changed.
> 
> Especially not the partial zoned device handling :-)

OK. Thanks for doing that ! I  totally missed these points when I wrote the
mapper :)

Cheers.

-- 
Damien Le Moal
Western Digital Research
