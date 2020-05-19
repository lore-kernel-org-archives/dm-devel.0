From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/6] dm-zoned: return NULL if
 dmz_get_zone_for_reclaim() fails to find a zone
Date: Tue, 19 May 2020 22:15:32 +0000
Message-ID: <BY5PR04MB6900DA6F738C755CA51BA5B1E7B90@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200519081424.103318-1-hare@suse.de>
	<20200519081424.103318-2-hare@suse.de>
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
> The only case where dmz_get_zone_for_reclaim() cannot return a zone is
> if the respective lists are empty. So we should better return a simple
> NULL value here as we really don't have an error code which would make
> sense.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 4 ++--
>  drivers/md/dm-zoned-reclaim.c  | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index d9e256762eff..65e196cfb443 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1845,7 +1845,7 @@ static struct dm_zone *dmz_get_rnd_zone_for_reclaim(struct dmz_metadata *zmd)
>  			return dzone;
>  	}
>  
> -	return ERR_PTR(-EBUSY);
> +	return NULL;
>  }
>  
>  /*
> @@ -1865,7 +1865,7 @@ static struct dm_zone *dmz_get_seq_zone_for_reclaim(struct dmz_metadata *zmd)
>  			return zone;
>  	}
>  
> -	return ERR_PTR(-EBUSY);
> +	return NULL;
>  }
>  
>  /*
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 4bfa61540b9c..77f02170cdd3 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -353,8 +353,8 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>  
>  	/* Get a data zone */
>  	dzone = dmz_get_zone_for_reclaim(zmd);
> -	if (IS_ERR(dzone))
> -		return PTR_ERR(dzone);
> +	if (!dzone)
> +		return -EBUSY;
>  
>  	start = jiffies;
>  	dev = dmz_zone_to_dev(zmd, dzone);
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
