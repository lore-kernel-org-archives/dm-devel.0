From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/2] dm-zoned: split off random and cache
	zones
Date: Thu, 14 May 2020 06:45:46 +0000
Message-ID: <BY5PR04MB6900C924F85EE6007ACFE4C2E7BC0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200513070729.71461-1-hare@suse.de>
	<20200513070729.71461-3-hare@suse.de>
	<BY5PR04MB6900F36D4228D0FD0216AD61E7BF0@BY5PR04MB6900.namprd04.prod.outlook.com>
	<a95309e9-c0d1-cd9e-4e93-c7fb52667b2d@suse.de>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/05/14 15:41, Hannes Reinecke wrote:
> On 5/13/20 2:44 PM, Damien Le Moal wrote:
>> On 2020/05/13 16:07, Hannes Reinecke wrote:
>>> Instead of emulating zones on the regular disk as random zones
>>> this patch adds a new 'cache' zone type.
>>> This allows us to use the random zones on the zoned disk as
>>> data zones (if cache zones are present), and improves performance
>>> as the zones on the (slower) zoned disk are then never used
>>> for caching.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> ---
> [ .. ]
>>> @@ -1830,17 +1861,19 @@ static void dmz_wait_for_reclaim(struct dmz_metadata *zmd, struct dm_zone *zone)
>>>   }
>>>   
>>>   /*
>>> - * Select a random write zone for reclaim.
>>> + * Select a cache or random write zone for reclaim.
>>>    */
>>>   static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd)
>>>   {
>>>   	struct dm_zone *dzone = NULL;
>>>   	struct dm_zone *zone;
>>> +	struct list_head *zone_list = &zmd->map_rnd_list;
>>>   
>>> -	if (list_empty(&zmd->map_rnd_list))
>>> -		return ERR_PTR(-EBUSY);
>>> +	/* If we have cache zones select from the cache zone list */
>>> +	if (zmd->nr_cache)
>>> +		zone_list = &zmd->map_cache_list;
>>>   
>>> -	list_for_each_entry(zone, &zmd->map_rnd_list, link) {
>>> +	list_for_each_entry(zone, zone_list, link) {
>>>   		if (dmz_is_buf(zone))
>>>   			dzone = zone->bzone;
>>>   		else
>>> @@ -1853,15 +1886,21 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd)
>>>   }
>>>   
>>>   /*
>>> - * Select a buffered sequential zone for reclaim.
>>> + * Select a buffered random write or sequential zone for reclaim.
>>
>> Random write zoned should never be "buffered", or to be very precise, they will
>> be only during the time reclaim moves a cache zone data to a random zone. That
>> is visible in the dmz_handle_write() change that execute
>> dmz_handle_direct_write() for cache or buffered zones instead of using
>> dmz_handle_buffered_write(). So I think this comment can stay as is.
>>
>>>    */
>>>   static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_metadata *zmd)
>>>   {
>>>   	struct dm_zone *zone;
>>>   
>>> -	if (list_empty(&zmd->map_seq_list))
>>> -		return ERR_PTR(-EBUSY);
>>> -
>>> +	if (zmd->nr_cache) {
>>> +		/* If we have cache zones start with random zones */
>>> +		list_for_each_entry(zone, &zmd->map_rnd_list, link) {
>>> +			if (!zone->bzone)
>>> +				continue;
>>> +			if (dmz_lock_zone_reclaim(zone))
>>> +				return zone;
>>> +		}
>>> +	}
>>
>> For the reason stated above, I think this change is not necessary either.
>>
> Ah. Indeed. The above hunk makes us reclaim the random zones, too, which
> strictly speaking isn't necessary.
> I'll be dropping it and see how things behave.
> 
>>>   	list_for_each_entry(zone, &zmd->map_seq_list, link) {
>>>   		if (!zone->bzone)
>>>   			continue;
>>> @@ -1911,6 +1950,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
>>>   	unsigned int dzone_id;
>>>   	struct dm_zone *dzone = NULL;
>>>   	int ret = 0;
>>> +	int alloc_flags = zmd->nr_cache ? DMZ_ALLOC_CACHE : DMZ_ALLOC_RND;
>>>   
>>>   	dmz_lock_map(zmd);
>>>   again:
>>> @@ -1925,7 +1965,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
>>>   			goto out;
>>>   
>>>   		/* Allocate a random zone */
>>> -		dzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
>>> +		dzone = dmz_alloc_zone(zmd, alloc_flags);
>>>   		if (!dzone) {
>>>   			if (dmz_dev_is_dying(zmd)) {
>>>   				dzone = ERR_PTR(-EIO);
>>> @@ -2018,6 +2058,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
>>>   				     struct dm_zone *dzone)
>>>   {
>>>   	struct dm_zone *bzone;
>>> +	int alloc_flags = zmd->nr_cache ? DMZ_ALLOC_CACHE : DMZ_ALLOC_RND;
>>>   
>>>   	dmz_lock_map(zmd);
>>>   again:
>>> @@ -2026,7 +2067,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
>>>   		goto out;
>>>   
>>>   	/* Allocate a random zone */
>>> -	bzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
>>> +	bzone = dmz_alloc_zone(zmd, alloc_flags);
>>>   	if (!bzone) {
>>>   		if (dmz_dev_is_dying(zmd)) {
>>>   			bzone = ERR_PTR(-EIO);
>>> @@ -2043,7 +2084,10 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
>>>   	bzone->chunk = dzone->chunk;
>>>   	bzone->bzone = dzone;
>>>   	dzone->bzone = bzone;
>>> -	list_add_tail(&bzone->link, &zmd->map_rnd_list);
>>> +	if (alloc_flags == DMZ_ALLOC_CACHE)
>>> +		list_add_tail(&bzone->link, &zmd->map_cache_list);
>>> +	else
>>> +		list_add_tail(&bzone->link, &zmd->map_rnd_list);
>>>   out:
>>>   	dmz_unlock_map(zmd);
>>>   
>>> @@ -2059,31 +2103,53 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
>>>   	struct list_head *list;
>>>   	struct dm_zone *zone;
>>>   
>>> -	if (flags & DMZ_ALLOC_RND)
>>> +	switch (flags) {
>>> +	case DMZ_ALLOC_CACHE:
>>> +		list = &zmd->unmap_cache_list;
>>> +		break;
>>> +	case DMZ_ALLOC_RND:
>>>   		list = &zmd->unmap_rnd_list;
>>> -	else
>>> -		list = &zmd->unmap_seq_list;
>>> +		break;
>>> +	default:
>>> +		if (zmd->nr_cache)> +			list = &zmd->unmap_rnd_list;
>>> +		else
>>> +			list = &zmd->unmap_seq_list;
>>> +		break;
>>> +	}
>>>   again:
>>>   	if (list_empty(list)) {
>>>   		/*
>>> -		 * No free zone: if this is for reclaim, allow using the
>>> -		 * reserved sequential zones.
>>> +		 * No free zone: return NULL if this is for not reclaim.
>>
>> s/for not reclaim/not for reclaim
>>
> [ .. ]
>>
>> Apart from the nits above, all look good. I am running this right now and it is
>> running at SMR drive speed ! Awesome ! Will send a plot once the run is over.
>>
> Thanks. I'll be respinning the patch and wil be reposting it.

Can you check the reclaim trigger too ? It seems to be starting way too early,
well before half of the SSD is used... Was about to rerun some tests and debug
that but since you need to respin the patch...

> 
> Cheers,
> 
> Hannes
> 


-- 
Damien Le Moal
Western Digital Research
