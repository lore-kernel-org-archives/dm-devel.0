From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/2] dm-zoned: fix a few typos
Date: Fri, 2 Aug 2019 23:20:46 +0000
Message-ID: <BYAPR04MB58160397B744B3D48AB11F9FE7D90@BYAPR04MB5816.namprd04.prod.outlook.com>
References: <20190802220251.1217-1-dmitry.fomichev@wdc.com>
	<20190802220251.1217-3-dmitry.fomichev@wdc.com>
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
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2019/08/03 7:02, Dmitry Fomichev wrote:
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  drivers/md/dm-zoned-metadata.c | 8 ++++----
>  drivers/md/dm-zoned-reclaim.c  | 2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 23e9a6d9350b..ded4984d18c9 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -35,7 +35,7 @@
>   *    (1) Super block (1 block)
>   *    (2) Chunk mapping table (nr_map_blocks)
>   *    (3) Bitmap blocks (nr_bitmap_blocks)
> - * All metadata blocks are stored in conventional zones, starting from the
> + * All metadata blocks are stored in conventional zones, starting from
>   * the first conventional zone found on disk.
>   */
>  struct dmz_super {
> @@ -234,7 +234,7 @@ void dmz_unlock_map(struct dmz_metadata *zmd)
>   * Lock/unlock metadata access. This is a "read" lock on a semaphore
>   * that prevents metadata flush from running while metadata are being
>   * modified. The actual metadata write mutual exclusion is achieved with
> - * the map lock and zone styate management (active and reclaim state are
> + * the map lock and zone state management (active and reclaim state are
>   * mutually exclusive).
>   */
>  void dmz_lock_metadata(struct dmz_metadata *zmd)
> @@ -1629,7 +1629,7 @@ struct dm_zone *dmz_get_chunk_mapping(struct dmz_metadata *zmd, unsigned int chu
>  		if (op != REQ_OP_WRITE)
>  			goto out;
>  
> -		/* Alloate a random zone */
> +		/* Allocate a random zone */
>  		dzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
>  		if (!dzone) {
>  			dmz_wait_for_free_zones(zmd);
> @@ -1726,7 +1726,7 @@ struct dm_zone *dmz_get_chunk_buffer(struct dmz_metadata *zmd,
>  	if (bzone)
>  		goto out;
>  
> -	/* Alloate a random zone */
> +	/* Allocate a random zone */
>  	bzone = dmz_alloc_zone(zmd, DMZ_ALLOC_RND);
>  	if (!bzone) {
>  		dmz_wait_for_free_zones(zmd);
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 387894e2add1..260e3598199e 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -428,7 +428,7 @@ static bool dmz_should_reclaim(struct dmz_reclaim *zrc)
>  		return false;
>  
>  	/*
> -	 * If the percentage of unmappped random zones is low,
> +	 * If the percentage of unmapped random zones is low,
>  	 * reclaim even if the target is busy.
>  	 */
>  	return p_unmap_rnd <= DMZ_RECLAIM_LOW_UNMAP_RND;
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>


-- 
Damien Le Moal
Western Digital Research
