From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 03/12] dm-zoned: use on-stack superblock for
 tertiary devices
Date: Tue, 26 May 2020 08:48:47 +0000
Message-ID: <CY4PR04MB3751038F62CCE4431153C4DFE7B00@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522153901.133375-1-hare@suse.de>
	<20200522153901.133375-4-hare@suse.de>
	<CY4PR04MB3751FB76DF953D2E84BFC419E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
	<66f5340e-b069-8c1a-3c61-5f4bb9f469af@suse.de>
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

On 2020/05/26 17:25, Hannes Reinecke wrote:
> On 5/25/20 4:09 AM, Damien Le Moal wrote:
>> On 2020/05/23 0:39, Hannes Reinecke wrote:
>>> Checking the teriary superblock just consists of validating UUIDs,
>>
>> s/teriary/tertiary
>>
>>> crcs, and the generation number; it doesn't have contents which
>>> would be required during the actual operation.
>>> So we should use an on-stack superblock and avoid having to store
>>> it together with the 'real' superblocks.
>>
>> ...a temoprary in-memory superblock allocation...
>>
>> The entire structure should not be on stack... see below.
>>
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
>>>   drivers/md/dm-zoned-metadata.c | 98 +++++++++++++++++++++++-------------------
>>>   1 file changed, 53 insertions(+), 45 deletions(-)
>>>
>>> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
>>> index 3da6702bb1ae..b70a988fa771 100644
>>> --- a/drivers/md/dm-zoned-metadata.c
>>> +++ b/drivers/md/dm-zoned-metadata.c
> [ .. ]
>>> @@ -1326,18 +1327,32 @@ static int dmz_load_sb(struct dmz_metadata *zmd)
>>>   		      "Using super block %u (gen %llu)",
>>>   		      zmd->mblk_primary, zmd->sb_gen);
>>>   
>>> -	if ((zmd->sb_version > 1) && zmd->sb[2].zone) {
>>> -		zmd->sb[2].block = dmz_start_block(zmd, zmd->sb[2].zone);
>>> -		zmd->sb[2].dev = dmz_zone_to_dev(zmd, zmd->sb[2].zone);
>>> -		ret = dmz_get_sb(zmd, 2);
>>> -		if (ret) {
>>> -			dmz_dev_err(zmd->sb[2].dev,
>>> -				    "Read tertiary super block failed");
>>> -			return ret;
>>> +	if (zmd->sb_version > 1) {
>>> +		int i;
>>> +
>>> +		for (i = 1; i < zmd->nr_devs; i++) {
>>> +			struct dmz_sb sb;
>>
>> I would rather have dmz_get_sb() allocate this struct than have it on stack...
>> It is not big, but still. To be symetric, we can add dmz_put_sb() for freeing it.
>>
> While I do agree to not having it on the stack, having dmz_get_sb() 
> returning the structure would require (yet another) overhaul of the
> main metadata structure which currently has the primary and secondary
> superblocks embedded.
> And I would argue to keep it that way, as the primary and secondary 
> superblocks are essential to the actual operation. So allocating them 
> separately would mean yet another indirection to get to them.
> At the same time, any tertiary superblock is just used for validation
> during startup, and not referenced anywhere afterwards.
> So using kzalloc() here and freeing them after checking is fine.

OK. Works for me.

> 
> Cheers,
> 
> Hannes
> 


-- 
Damien Le Moal
Western Digital Research
