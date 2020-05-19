From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/6] dm-zoned: reclaim random zones when idle
Date: Tue, 19 May 2020 22:26:26 +0000
Message-ID: <BY5PR04MB690069314E49070B4F4BA663E7B90@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200519081424.103318-1-hare@suse.de>
	<20200519081424.103318-4-hare@suse.de>
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

On 2020/05/19 17:14, Hannes Reinecke wrote:
> When the system is idle we should be starting reclaiming
> random zones, too.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 13 +++++++++----
>  drivers/md/dm-zoned-reclaim.c  | 30 +++++++++++++++++++-----------
>  drivers/md/dm-zoned.h          |  2 +-
>  3 files changed, 29 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index c7d44686a5ea..ee613ba2e8aa 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1859,15 +1859,20 @@ static void dmz_wait_for_reclaim(struct dmz_metadata *zmd, struct dm_zone *zone)
>  /*
>   * Select a cache or random write zone for reclaim.
>   */
> -static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd)
> +static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd,
> +						    bool idle)
>  {
>  	struct dm_zone *dzone = NULL;
>  	struct dm_zone *zone;
>  	struct list_head *zone_list = &zmd->map_rnd_list;
>  
>  	/* If we have cache zones select from the cache zone list */
> -	if (zmd->nr_cache)
> +	if (zmd->nr_cache) {
>  		zone_list = &zmd->map_cache_list;
> +		/* Try to relaim random zones, too, when idle */
> +		if (idle && list_empty(zone_list))
> +			zone_list = &zmd->map_rnd_list;
> +	}
>  
>  	list_for_each_entry(zone, zone_list, link) {
>  		if (dmz_is_buf(zone))
> @@ -1901,7 +1906,7 @@ static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_metadata *zmd)
>  /*
>   * Select a zone for reclaim.
>   */
> -struct dm_zone *dmz_get_zone_for_reclaim(struct dmz_metadata *zmd)
> +struct dm_zone *dmz_get_zone_for_reclaim(struct dmz_metadata *zmd, bool idle)
>  {
>  	struct dm_zone *zone;
>  
> @@ -1917,7 +1922,7 @@ struct dm_zone *dmz_get_zone_for_reclaim(struct dmz_metadata *zmd)
>  	if (list_empty(&zmd->reserved_seq_zones_list))
>  		zone = dmz_get_seq_zone_for_reclaim(zmd);
>  	else
> -		zone = dmz_get_rnd_zone_for_reclaim(zmd);
> +		zone = dmz_get_rnd_zone_for_reclaim(zmd, idle);
>  	dmz_unlock_map(zmd);
>  
>  	return zone;
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 9e3760091fcf..1855c056d6a4 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -284,7 +284,10 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>  	int alloc_flags = dmz_nr_cache_zones(zmd) ?
>  		DMZ_ALLOC_RND : DMZ_ALLOC_SEQ;
>  
> -	/* Get a free sequential zone */
> +	/* Always use sequential zones to reclaim random zones */
> +	if (dmz_is_rnd(dzone))
> +		alloc_flags = DMZ_ALLOC_SEQ;
> +	/* Get a free random or sequential zone */
>  	dmz_lock_map(zmd);
>  	szone = dmz_alloc_zone(zmd, alloc_flags | DMZ_ALLOC_RECLAIM);
>  	dmz_unlock_map(zmd);
> @@ -343,6 +346,14 @@ static void dmz_reclaim_empty(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>  	dmz_unlock_flush(zmd);
>  }
>  
> +/*
> + * Test if the target device is idle.
> + */
> +static inline int dmz_target_idle(struct dmz_reclaim *zrc)
> +{
> +	return time_is_before_jiffies(zrc->atime + DMZ_IDLE_PERIOD);
> +}
> +
>  /*
>   * Find a candidate zone for reclaim and process it.
>   */
> @@ -356,7 +367,7 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>  	int ret;
>  
>  	/* Get a data zone */
> -	dzone = dmz_get_zone_for_reclaim(zmd);
> +	dzone = dmz_get_zone_for_reclaim(zmd, dmz_target_idle(zrc));
>  	if (!dzone)
>  		return -EBUSY;
>  
> @@ -420,14 +431,6 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>  	return 0;
>  }
>  
> -/*
> - * Test if the target device is idle.
> - */
> -static inline int dmz_target_idle(struct dmz_reclaim *zrc)
> -{
> -	return time_is_before_jiffies(zrc->atime + DMZ_IDLE_PERIOD);
> -}
> -
>  static unsigned int dmz_reclaim_percentage(struct dmz_reclaim *zrc)
>  {
>  	struct dmz_metadata *zmd = zrc->metadata;
> @@ -450,8 +453,13 @@ static unsigned int dmz_reclaim_percentage(struct dmz_reclaim *zrc)
>   */
>  static bool dmz_should_reclaim(struct dmz_reclaim *zrc, unsigned int p_unmap)
>  {
> +	unsigned int nr_reclaim = dmz_nr_rnd_zones(zrc->metadata);
> +
> +	if (dmz_nr_cache_zones(zrc->metadata))
> +		nr_reclaim += dmz_nr_cache_zones(zrc->metadata);
> +
>  	/* Reclaim when idle */
> -	if (dmz_target_idle(zrc) && p_unmap < 100)
> +	if (dmz_target_idle(zrc) && nr_reclaim)
>  		return true;
>  
>  	/* If there are still plenty of cache zones, do not reclaim */
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index 29e01a853f84..288054dd7cf4 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -240,7 +240,7 @@ static inline bool dmz_is_active(struct dm_zone *zone)
>  
>  int dmz_lock_zone_reclaim(struct dm_zone *zone);
>  void dmz_unlock_zone_reclaim(struct dm_zone *zone);
> -struct dm_zone *dmz_get_zone_for_reclaim(struct dmz_metadata *zmd);
> +struct dm_zone *dmz_get_zone_for_reclaim(struct dmz_metadata *zmd, bool idle);
>  
>  struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd,
>  				      unsigned int chunk, int op);
> 

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>


-- 
Damien Le Moal
Western Digital Research
