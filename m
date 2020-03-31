From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/4] dm-zoned: store zone id within the zone
	structure
Date: Tue, 31 Mar 2020 00:57:12 +0000
Message-ID: <CO2PR04MB2343EA1C30F6ACC57B36F170E7C80@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200327071459.67796-1-hare@suse.de>
	<20200327071459.67796-2-hare@suse.de>
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

On 2020/03/27 16:15, Hannes Reinecke wrote:
> Instead of calculating the zone index by the offset within the
> zone array store the index within the structure itself.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 3 ++-
>  drivers/md/dm-zoned.h          | 3 +++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index c8787560fa9f..afce594067fb 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -189,7 +189,7 @@ struct dmz_metadata {
>   */
>  unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone)
>  {
> -	return ((unsigned int)(zone - zmd->zones));
> +	return zone->id;
>  }
>  
>  sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone)
> @@ -1119,6 +1119,7 @@ static int dmz_init_zone(struct blk_zone *blkz, unsigned int idx, void *data)
>  
>  	INIT_LIST_HEAD(&zone->link);
>  	atomic_set(&zone->refcount, 0);
> +	zone->id = idx;

See my comment on patch 4. Allowing partial bdev mapping changes the meaning of
this ID: for a partial mapping, this is not equal to the zone number anymore. So
we should document that (in the struct declaration), and may be merge this patch
with patch 4 since they are related so closely ?

>  	zone->chunk = DMZ_MAP_UNMAPPED;
>  
>  	switch (blkz->type) {
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index 884c0e586082..39d59898abbe 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -87,6 +87,9 @@ struct dm_zone {
>  	/* Zone activation reference count */
>  	atomic_t		refcount;
>  
> +	/* Zone id */
> +	unsigned int		id;
> +
>  	/* Zone write pointer block (relative to the zone start block) */
>  	unsigned int		wp_block;
>  
> 


-- 
Damien Le Moal
Western Digital Research
