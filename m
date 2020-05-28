From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 09/15] dm-zoned: allocate dm devices
	dynamically
Date: Thu, 28 May 2020 02:59:01 +0000
Message-ID: <CY4PR04MB3751E4ACF48C26D712DA020AE78E0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200527062225.72849-1-hare@suse.de>
	<20200527062225.72849-10-hare@suse.de>
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

On 2020/05/27 15:22, Hannes Reinecke wrote:
> Allocate dm devices dynamically to allow for expansion to
> several devices.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-target.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 087dd4801663..fec1b6a9c6f1 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -40,9 +40,10 @@ struct dm_chunk_work {
>   * Target descriptor.
>   */
>  struct dmz_target {
> -	struct dm_dev		*ddev[DMZ_MAX_DEVS];
> +	struct dm_dev		**ddev;
> +	unsigned int		nr_ddevs;
>  
> -	unsigned long		flags;
> +	unsigned int		flags;
>  
>  	/* Zoned block device information */
>  	struct dmz_dev		*dev;
> @@ -836,12 +837,20 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  		ti->error = "Unable to allocate the zoned target descriptor";
>  		return -ENOMEM;
>  	}
> -	dmz->dev = kcalloc(2, sizeof(struct dmz_dev), GFP_KERNEL);
> +	dmz->dev = kcalloc(argc, sizeof(struct dmz_dev), GFP_KERNEL);
>  	if (!dmz->dev) {
>  		ti->error = "Unable to allocate the zoned device descriptors";
>  		kfree(dmz);
>  		return -ENOMEM;
>  	}
> +	dmz->ddev = kcalloc(argc, sizeof(struct dm_dev *), GFP_KERNEL);
> +	if (!dmz->ddev) {
> +		ti->error = "Unable to allocate the dm device descriptors";
> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +	dmz->nr_ddevs = argc;
> +
>  	ti->private = dmz;
>  
>  	/* Get the target zoned block device */
> @@ -1048,13 +1057,13 @@ static int dmz_iterate_devices(struct dm_target *ti,
>  	struct dmz_target *dmz = ti->private;
>  	unsigned int zone_nr_sectors = dmz_zone_nr_sectors(dmz->metadata);
>  	sector_t capacity;
> -	int r;
> +	int i, r;
>  
> -	capacity = dmz->dev[0].capacity & ~(zone_nr_sectors - 1);
> -	r = fn(ti, dmz->ddev[0], 0, capacity, data);
> -	if (!r && dmz->ddev[1]) {
> -		capacity = dmz->dev[1].capacity & ~(zone_nr_sectors - 1);
> -		r = fn(ti, dmz->ddev[1], 0, capacity, data);
> +	for (i = 0; i < dmz->nr_ddevs; i++) {
> +		capacity = dmz->dev[i].capacity & ~(zone_nr_sectors - 1);
> +		r = fn(ti, dmz->ddev[i], 0, capacity, data);
> +		if (r)
> +			break;
>  	}
>  	return r;
>  }
> @@ -1083,7 +1092,7 @@ static void dmz_status(struct dm_target *ti, status_type_t type,
>  		dev = &dmz->dev[0];
>  		format_dev_t(buf, dev->bdev->bd_dev);
>  		DMEMIT("%s", buf);
> -		if (dmz->dev[1].bdev) {
> +		if (dmz->nr_ddevs > 1) {
>  			dev = &dmz->dev[1];
>  			format_dev_t(buf, dev->bdev->bd_dev);
>  			DMEMIT(" %s", buf);
> 

Looks good.

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
