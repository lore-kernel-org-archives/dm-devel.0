From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 15/15] dm-zoned: prefer full zones for reclaim
Date: Thu, 28 May 2020 04:16:33 +0000
Message-ID: <ba3ed1771f0034a99d9d40bf9197b8ac969c0c5a.camel@wdc.com>
References: <20200527062225.72849-1-hare@suse.de>
	<20200527062225.72849-16-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200527062225.72849-16-hare@suse.de>
Content-Language: en-US
Content-ID: <C64F518291975F40B80A12A1C416EF1F@namprd04.prod.outlook.com>
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
> Prefer full zones when selecting the next zone for reclaim.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index b89b3d3b9ec9..f161ef4e3d3d 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1936,7 +1936,7 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd,
>  						    unsigned int idx, bool idle)
>  {
>  	struct dm_zone *dzone = NULL;
> -	struct dm_zone *zone;
> +	struct dm_zone *zone, *last = NULL;
>  	struct list_head *zone_list;
>  
>  	/* If we have cache zones select from the cache zone list */
> @@ -1953,6 +1953,13 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd,
>  			dzone = zone->bzone;
>  			if (dzone->dev->dev_idx != idx)
>  				continue;
> +			if (!last) {
> +				last = dzone;
> +				continue;
> +			}
> +			if (last->weight < dzone->weight)
> +				continue;
> +			dzone = last;
>  		} else
>  			dzone = zone;
>  		if (dmz_lock_zone_reclaim(dzone))

If all random/cache zones are used but none of them satisfy the
condition last->weight < dzone->weight, we may end up starving reclaim
and having user IOs accessing a new chunk wait a loooong time, if not
forever, No ? I agree that aiming at reclaim of full zones first is
more efficient, but we need a fallback to ensure forward progress.

-- 
Damien Le Moal
Western Digital Research
