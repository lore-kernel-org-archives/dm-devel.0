From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Rename device_area_is_valid and reverse
	logic accordingly
Date: Thu, 30 Jul 2009 15:08:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0907301506420.17876@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0907270913170.25437@hs20-bc2-1.build.redhat.com>
	<20090727141506.GA4964@redhat.com>
	<Pine.LNX.4.64.0907271022490.3823@hs20-bc2-1.build.redhat.com>
	<20090728120705.GA10878@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090728120705.GA10878@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

> ---
> 
> From: Mikulas Patocka <mpatocka@redhat.com>
> 
> Rename device_area_is_valid and reverse logic accordingly
> 
> ->iterate_devices method calls the callback for every underlying device
> in the target.  If the callback returns non-zero iterate_devices exits
> immediately and the caller should understand that an error occurred.
> 
> The logic to check for valid device areas was reversed relative to
> proper use with iterate_devices.  device_area_is_valid returned 0 on
> error and 1 on success.  Thus error (from iterate_devices) was returned
> only if all the devices were invalid.
> 
> This patch renames device_area_is_valid to device_area_is_invalid and
> reverses the logic so that 0 means valid and 1 means invalid (to match
> iterate_devices).
> 
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> 
> ---
>  drivers/md/dm-table.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index d952b34..aa60526 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -343,10 +343,10 @@ static void close_dev(struct dm_dev_internal *d, struct mapped_device *md)
>  }
>  
>  /*
> - * If possible, this checks an area of a destination device is valid.
> + * If possible, this checks an area of a destination device is invalid.
>   */
> -static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
> -				sector_t start, sector_t len, void *data)
> +static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
> +				  sector_t start, sector_t len, void *data)
>  {
>  	struct queue_limits *limits = data;
>  	struct block_device *bdev = dev->bdev;
> @@ -357,16 +357,16 @@ static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
>  	char b[BDEVNAME_SIZE];
>  
>  	if (!dev_size)
> -		return 1;
> +		return 0;
>  
>  	if ((start >= dev_size) || (start + len > dev_size)) {
>  		DMWARN("%s: %s too small for target",
>  		       dm_device_name(ti->table->md), bdevname(bdev, b));
> -		return 0;
> +		return 1;
>  	}
>  
>  	if (logical_block_size_sectors <= 1)
> -		return 1;
> +		return 0;
>  
>  	if (start & (logical_block_size_sectors - 1)) {
>  		DMWARN("%s: start=%llu not aligned to h/w "
> @@ -374,7 +374,7 @@ static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
>  		       dm_device_name(ti->table->md),
>  		       (unsigned long long)start,
>  		       limits->logical_block_size, bdevname(bdev, b));
> -		return 0;
> +		return 1;
>  	}
>  
>  	if (len & (logical_block_size_sectors - 1)) {
> @@ -383,10 +383,10 @@ static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
>  		       dm_device_name(ti->table->md),
>  		       (unsigned long long)len,
>  		       limits->logical_block_size, bdevname(bdev, b));
> -		return 0;
> +		return 1;
>  	}
>  
> -	return 1;
> +	return 0;
>  }
>  
>  /*
> @@ -1000,8 +1000,8 @@ int dm_calculate_queue_limits(struct dm_table *table,
>  		 * Check each device area is consistent with the target's
>  		 * overall queue limits.
>  		 */
> -		if (!ti->type->iterate_devices(ti, device_area_is_valid,
> -					       &ti_limits))
> +		if (ti->type->iterate_devices(ti, device_area_is_invalid,
> +					      &ti_limits))
>  			return -EINVAL;
>  
>  combine_limits:
> 

Acked-by: Mikulas Patocka <mpatocka@redhat.com>
