From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/2] dm-zoned: cache device for zones
Date: Tue, 24 Mar 2020 09:03:44 +0000
Message-ID: <CO2PR04MB234309CE05F101A57A12825CE7F10@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200323150352.107826-1-hare@suse.de>
	<20200323150352.107826-2-hare@suse.de>
	<CO2PR04MB2343170DAC13D92E9A649BBFE7F10@CO2PR04MB2343.namprd04.prod.outlook.com>
	<ac6881a9-1b9f-539d-f0e8-9039b4852a2e@suse.de>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Johannes Thumshirn <jth@kernel.org>, Bob Liu <bob.liu@oracle.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2020/03/24 16:51, Hannes Reinecke wrote:
> On 3/24/20 4:52 AM, Damien Le Moal wrote:
>> +Bob who had proposed a similar change a last month.
>>
>> On 2020/03/24 0:04, Hannes Reinecke wrote:
>>> Implement 'cache' zones which reside on a different device.
>>> The device is logically split into zones, which then will be
>>> used as 'cache' zones, similar to the existing randow write
>>> zones.
>>
>> It does look like the new "cache" zones are really used exactly as conventional
>> zones of the SMR drive. So I wonder: why even define this new zone type ? We
>> could have the "cache" device split into random (conventional) zones added to a
>> single pool of random zones. We can simply add device awareness to the zone
>> allocator to avoid as much as possible using a random zone from the same drive
>> as the sequential zone it buffers. That would avoid repeating most of the code
>> for cache & random.
>>
> Yes, indeed that was the idea to keep 'cache' and 'random' zones 
> essentially similar. But then as there is a need to differentiate 
> between them I thought it easier to introduce a new zone type.
> 
> However, it's a nice idea to use the device to differentiate between 
> both. And it would even lend to a simpler reclaim mechanism; set the low 
> watermark when all random zones on the cache device are full, and set 
> the high watermark when half of the random zones on the SMR device are full.
> 
> I'll give it a go and see where I end up.
> 
>> Furthermore, this work is really great to support SMR drives with no
>> conventional zones (a lot of ask for these). And considering that the new FORMAT
>> WITH PRESET command is coming soon, a user will be able to reformat an SMR drive
>> with sequential zones only to maximize capacity. For these, the cache device
>> would need to hold the random zones, at which point the difference between cache
>> and rando goes away.
>>
> I know :-)
> 
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>   drivers/md/dm-zoned-metadata.c | 174 ++++++++++++++++++++++++++++-----
>>>   drivers/md/dm-zoned-reclaim.c  |  76 +++++++++++---
>>>   drivers/md/dm-zoned-target.c   | 109 ++++++++++++++++++---
>>>   drivers/md/dm-zoned.h          |  31 +++++-
>>>   4 files changed, 339 insertions(+), 51 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
>>> index 369de15c4e80..41cc3a29db0b 100644
>>> --- a/drivers/md/dm-zoned-metadata.c
>>> +++ b/drivers/md/dm-zoned-metadata.c
>>> @@ -132,6 +132,8 @@ struct dmz_sb {
>>>   struct dmz_metadata {
>>>   	struct dmz_dev		*dev;
>>>   
>>> +	struct dmz_cdev		*cdev;
>>
>> Given the point above, we could have this generalized as an array of devices,
>> with the first one meeting the constraints:
>> * It contains the metadata
>> * It has random/conventional zones, or is a regular device (with all its
>> capacity used through emulated random zones)
>>
>> I do not think that complicates the changes you did a lot. The reclaim part will
>> need some more love I guess to be efficient, but it may be as simple as defining
>> one work struct for each drive beside the first one.
>>
>> Thoughts ?
>>
> Rather not. Stringing several devices together essentially emulates a 
> RAID0 setup without any of the benefits. And the reclaim mechanism gets 
> infinitely more complex.

OK. Fair point.

> 
> Another thing: I would need to update the metadata to hold the device 
> and zoneset UUID; both devices need to carry a metadata so that we can 
> stitch them together upon restart.
> 
> But some bright soul put a crc in the middle of the metadata :-(
> So we can't easily extend the metadata with new fields as then the 
> meaning of the crc is unclear; as it stands it would only cover the old 
> fields, and not the new ones.

Haha ! OK. You got me. Not my finest hour on this one :)

> So I would propose a 'v2' metadata, holding the crc as the last entry of 
> the metadata. And adding a device UUID and cacheset UUID.
> And ensuring that the first metadata set is stored on the cache device, 
> and the backup one on the SMR device.

That would work.

> 
> Cheers,
> 
> Hannes
> 


-- 
Damien Le Moal
Western Digital Research
