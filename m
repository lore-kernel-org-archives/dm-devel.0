From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 13/15] dm-zoned: allocate zone by device index
Date: Thu, 28 May 2020 04:08:13 +0000
Message-ID: <f38d9c9802239e3021b602af8c178428d72e791b.camel@wdc.com>
References: <20200527062225.72849-1-hare@suse.de>
	<20200527062225.72849-14-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200527062225.72849-14-hare@suse.de>
Content-Language: en-US
Content-ID: <AA2844876B46414F963E129039A249B1@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "snitzer@redhat.com" <snitzer@redhat.com>, "hare@suse.de" <hare@suse.de>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-05-27 at 08:22 +0200, Hannes Reinecke wrote:
> When allocating a zone we should pass in an indicator on which
> device the zone should be allocated; this increases performance
> for a multi-device setup as then reclaim can allocate zones on
> the device for which reclaim is running.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 17 +++++++++++------
>  drivers/md/dm-zoned-reclaim.c  |  3 ++-
>  drivers/md/dm-zoned.h          |  3 ++-
>  3 files changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 689c1dd7ab20..0d65af94309a 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -2045,7 +2045,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
>  			goto out;
>  
>  		/* Allocate a random zone */
> -		dzone = dmz_alloc_zone(zmd, alloc_flags);
> +		dzone = dmz_alloc_zone(zmd, 0, alloc_flags);
>  		if (!dzone) {
>  			if (dmz_dev_is_dying(zmd)) {
>  				dzone = ERR_PTR(-EIO);
> @@ -2151,7 +2151,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
>  		goto out;
>  
>  	/* Allocate a random zone */
> -	bzone = dmz_alloc_zone(zmd, alloc_flags);
> +	bzone = dmz_alloc_zone(zmd, 0, alloc_flags);
>  	if (!bzone) {
>  		if (dmz_dev_is_dying(zmd)) {
>  			bzone = ERR_PTR(-EIO);
> @@ -2182,11 +2182,12 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
>   * Get an unmapped (free) zone.
>   * This must be called with the mapping lock held.
>   */
> -struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
> +struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned int dev_idx,
> +			       unsigned long flags)
>  {
>  	struct list_head *list;
>  	struct dm_zone *zone;
> -	unsigned int dev_idx = 0;
> +	int i = 0;
>  
>  again:
>  	if (flags & DMZ_ALLOC_CACHE)
> @@ -2202,8 +2203,12 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
>  		 */
>  		if (!(flags & DMZ_ALLOC_RECLAIM))
>  			return NULL;
> -		if (dev_idx < zmd->nr_devs) {
> -			dev_idx++;
> +		/*
> +		 * Try to allocate from other devices
> +		 */
> +		if (i < zmd->nr_devs) {
> +			dev_idx = (dev_idx + 1) % zmd->nr_devs;

Hu ? You deleted dev_idx declaration above...

> +			i++;
>  			goto again;
>  		}
>  
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 18edf1b9bf52..5a04e34d17a9 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -288,7 +288,8 @@ static int dmz_reclaim_rnd_data(struct dmz_reclaim *zrc, struct dm_zone *dzone)
>  	/* Get a free random or sequential zone */
>  	dmz_lock_map(zmd);
>  again:
> -	szone = dmz_alloc_zone(zmd, alloc_flags | DMZ_ALLOC_RECLAIM);
> +	szone = dmz_alloc_zone(zmd, zrc->dev_idx,
> +			       alloc_flags | DMZ_ALLOC_RECLAIM);
>  	if (!szone && alloc_flags == DMZ_ALLOC_SEQ && dmz_nr_cache_zones(zmd)) {
>  		alloc_flags = DMZ_ALLOC_RND;
>  		goto again;
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index f2a760f62db5..ec020bb1caf7 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -214,7 +214,8 @@ bool dmz_dev_is_dying(struct dmz_metadata *zmd);
>  #define DMZ_ALLOC_SEQ		0x04
>  #define DMZ_ALLOC_RECLAIM	0x10
>  
> -struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags);
> +struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd,
> +			       unsigned int dev_idx, unsigned long flags);
>  void dmz_free_zone(struct dmz_metadata *zmd, struct dm_zone *zone);
>  
>  void dmz_map_zone(struct dmz_metadata *zmd, struct dm_zone *zone,

-- 
Damien Le Moal
Western Digital Research
