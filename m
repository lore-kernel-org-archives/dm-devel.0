From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 09/12] dm-zoned: improve logging messages for
	reclaim
Date: Mon, 25 May 2020 02:28:31 +0000
Message-ID: <CY4PR04MB37516C617F9B021B240374A4E7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522153901.133375-1-hare@suse.de>
	<20200522153901.133375-10-hare@suse.de>
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
> Instead of just reporting the errno this patch adds some more
> verbose debugging message in the reclaim path.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-reclaim.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index d1a72b42dea2..fba0d48e38a7 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -367,8 +367,11 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>  
>  	/* Get a data zone */
>  	dzone = dmz_get_zone_for_reclaim(zmd, dmz_target_idle(zrc));
> -	if (!dzone)
> +	if (!dzone) {
> +		DMDEBUG("(%s): No zone found to reclaim",
> +			dmz_metadata_label(zmd));
>  		return -EBUSY;
> +	}
>  
>  	start = jiffies;
>  	if (dmz_is_cache(dzone) || dmz_is_rnd(dzone)) {
> @@ -412,6 +415,12 @@ static int dmz_do_reclaim(struct dmz_reclaim *zrc)
>  	}
>  out:
>  	if (ret) {
> +		if (ret == -EINTR)
> +			DMDEBUG("(%s): reclaim zone %u interrupted",
> +				dmz_metadata_label(zmd), rzone->id);
> +		else
> +			DMDEBUG("(%s): Failed to reclaim zone %u, err %d",
> +				dmz_metadata_label(zmd), rzone->id, ret);
>  		dmz_unlock_zone_reclaim(dzone);
>  		return ret;
>  	}
> @@ -515,8 +524,6 @@ static void dmz_reclaim_work(struct work_struct *work)
>  
>  	ret = dmz_do_reclaim(zrc);
>  	if (ret && ret != -EINTR) {
> -		DMDEBUG("(%s): Reclaim error %d",
> -			dmz_metadata_label(zmd), ret);
>  		if (!dmz_check_dev(zmd))
>  			return;
>  	}
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
