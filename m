From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 12/14] dm-zoned: Reduce logging output on
	startup
Date: Mon, 11 May 2020 02:48:03 +0000
Message-ID: <BY5PR04MB69001396D7E9821865734BC5E7A10@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200508090332.40716-1-hare@suse.de>
	<20200508090332.40716-13-hare@suse.de>
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

On 2020/05/08 18:04, Hannes Reinecke wrote:
> dm-zoned is becoming quite chatty during startup; reduce the noise
> by moving some information to 'debug' level.
> 
> Suggested-by: Mike Snitzer <snitzer@redhat.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 77b9ea4bad74..80c0fe4c3546 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1279,8 +1279,8 @@ static int dmz_init_zones(struct dmz_metadata *zmd)
>  	if (!zmd->zones)
>  		return -ENOMEM;
>  
> -	DMINFO("(%s): Using %zu B for zone information",
> -	       zmd->devname, sizeof(struct dm_zone) * zmd->nr_zones);
> +	DMDEBUG("(%s): Using %zu B for zone information",
> +		zmd->devname, sizeof(struct dm_zone) * zmd->nr_zones);
>  
>  	/*
>  	 * Get zone information and initialize zone descriptors.  At the same
> @@ -2562,16 +2562,16 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata,
>  
>  	dmz_zmd_info(zmd, "  %u zones of %llu 512-byte logical sectors",
>  		     zmd->nr_zones, (u64)zmd->zone_nr_sectors);
> -	dmz_zmd_info(zmd, "  %u metadata zones",
> -		     zmd->nr_meta_zones * 2);
> -	dmz_zmd_info(zmd, "  %u data zones for %u chunks",
> -		     zmd->nr_data_zones, zmd->nr_chunks);
> -	dmz_zmd_info(zmd, "    %u random zones (%u unmapped)",
> -		     zmd->nr_rnd, atomic_read(&zmd->unmap_nr_rnd));
> -	dmz_zmd_info(zmd, "    %u sequential zones (%u unmapped)",
> -		     zmd->nr_seq, atomic_read(&zmd->unmap_nr_seq));
> -	dmz_zmd_info(zmd, "  %u reserved sequential data zones",
> -		     zmd->nr_reserved_seq);
> +	dmz_zmd_debug(zmd, "  %u metadata zones",
> +		      zmd->nr_meta_zones * 2);
> +	dmz_zmd_debug(zmd, "  %u data zones for %u chunks",
> +		      zmd->nr_data_zones, zmd->nr_chunks);
> +	dmz_zmd_debug(zmd, "    %u random zones (%u unmapped)",
> +		      zmd->nr_rnd, atomic_read(&zmd->unmap_nr_rnd));
> +	dmz_zmd_debug(zmd, "    %u sequential zones (%u unmapped)",
> +		      zmd->nr_seq, atomic_read(&zmd->unmap_nr_seq));
> +	dmz_zmd_debug(zmd, "  %u reserved sequential data zones",
> +		      zmd->nr_reserved_seq);
>  	dmz_zmd_debug(zmd, "Format:");
>  	dmz_zmd_debug(zmd, "%u metadata blocks per set (%u max cache)",
>  		      zmd->nr_meta_blocks, zmd->max_nr_mblks);
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
