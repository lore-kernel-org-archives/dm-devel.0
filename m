From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 11/12] dm-zoned: round-robin load balancer
 for reclaiming zones
Date: Mon, 25 May 2020 02:42:54 +0000
Message-ID: <CY4PR04MB375158B6B94B1452DFDFCF98E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522153901.133375-1-hare@suse.de>
	<20200522153901.133375-12-hare@suse.de>
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

On 2020/05/23 0:39, Hannes Reinecke wrote:
> When reclaiming zones we should arbitrate between the zoned
> devices to get a better throughput. So implement a simple
> round-robin load balancer between the zoned devices.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 87784e7785bc..25dcad2a565f 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -171,6 +171,8 @@ struct dmz_metadata {
>  	unsigned int		nr_reserved_seq;
>  	unsigned int		nr_chunks;
>  
> +	unsigned int		last_alloc_idx;
> +
>  	/* Zone information array */
>  	struct xarray		zones;
>  
> @@ -2178,7 +2180,7 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
>  {
>  	struct list_head *list;
>  	struct dm_zone *zone;
> -	unsigned int dev_idx = 0;
> +	unsigned int dev_idx = zmd->last_alloc_idx;
>  
>  again:
>  	if (flags & DMZ_ALLOC_CACHE)
> @@ -2214,6 +2216,9 @@ struct dm_zone *dmz_alloc_zone(struct dmz_metadata *zmd, unsigned long flags)
>  	zone = list_first_entry(list, struct dm_zone, link);
>  	list_del_init(&zone->link);
>  
> +	if (!(flags & DMZ_ALLOC_CACHE))
> +		zmd->last_alloc_idx = (dev_idx + 1) % zmd->nr_devs;
> +
>  	if (dmz_is_cache(zone))
>  		atomic_dec(&zmd->unmap_nr_cache);
>  	else if (dmz_is_rnd(zone))
> @@ -2839,6 +2844,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, int num_dev,
>  	zmd->dev = dev;
>  	zmd->nr_devs = num_dev;
>  	zmd->mblk_rbtree = RB_ROOT;
> +	zmd->last_alloc_idx = 0;
>  	init_rwsem(&zmd->mblk_sem);
>  	mutex_init(&zmd->mblk_flush_lock);
>  	spin_lock_init(&zmd->mblk_lock);
> 


OK. So my comment on patch 8 is already addressed. Or at least partly... Where
is last_alloc_idx actually used ? It looks like this only sets last_alloc_idx
but do not use that value on entry to dmz_alloc_zone() to allocate the zone.

-- 
Damien Le Moal
Western Digital Research
