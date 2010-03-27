From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: shared snapshots release 17
Date: Fri, 26 Mar 2010 20:36:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1003262036030.6303@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1003221513150.15382@hs20-bc2-1.build.redhat.com>
	<20100322205433.GB13346@redhat.com> <20100322223318.GA26907@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100322223318.GA26907@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

Thanks for finding it. I used a smaller fix that does the same thing, but 
doesn't introduce a new function.

Mikulas

> multisnap_origin_iterate_devices() is failing for me with:
>  kernel: device-mapper: table: 253:0: dm-2 too small for target: start=0, len=8388608, dev_size=2097152
> 
> After failure to reload the origin, the remaining tables are:
> test-testlv1: 0 8388608 linear 254:16 384
> test-testlv1-cow: 0 2097152 linear 254:16 8388992
> test-testlv1-real: 0 8388608 linear 254:16 384
> 
> 
> The following patch fixes it for me, but it needs further cleanup
> (duplicates method from the old snapshot code).
> 
> diff --git a/drivers/md/dm-multisnap.c b/drivers/md/dm-multisnap.c
> index 5ba1af8..0644e19 100644
> --- a/drivers/md/dm-multisnap.c
> +++ b/drivers/md/dm-multisnap.c
> @@ -113,6 +113,15 @@ EXPORT_SYMBOL(dm_multisnap_drop_on_error);
>  static DEFINE_MUTEX(all_multisnapshots_lock);
>  static LIST_HEAD(all_multisnapshots);
>  
> +/*
> + * Return the number of sectors in the device.
> + * FIXME: duplicates dm-exception-store.h:get_dev_size
> + */
> +static inline sector_t get_dev_size(struct block_device *bdev)
> +{
> +	return i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
> +}
> +
>  static chunk_t sector_to_chunk(struct dm_multisnap *s, sector_t sector)
>  {
>  	return sector >> (s->chunk_shift - SECTOR_SHIFT);
> @@ -1476,7 +1485,8 @@ static int multisnap_iterate_devices(struct dm_target *ti, struct dm_multisnap *
>  	r = fn(ti, s->origin, 0, s->origin_sectors, data);
>  
>  	if (!r)
> -		r = fn(ti, s->snapshot, 0, s->origin_sectors, data);
> +		r = fn(ti, s->snapshot, 0,
> +		       get_dev_size(dm_multisnap_snapshot_bdev(s)), data);
>  
>  	return r;
>  }
> 
