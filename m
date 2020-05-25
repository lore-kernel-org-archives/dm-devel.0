From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 07/12] dm-zoned: add a 'reserved' zone flag
Date: Mon, 25 May 2020 02:18:45 +0000
Message-ID: <CY4PR04MB37515F9D681D8473A968CC4FE7B30@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200522153901.133375-1-hare@suse.de>
	<20200522153901.133375-8-hare@suse.de>
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
> Instead of counting the number of reserved zones in dmz_free_zone()
> we should mark the zone as 'reserved' during allocation and simplify
> dmz_free_zone().
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 4 ++--
>  drivers/md/dm-zoned.h          | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 73479b4c8bca..1b9da698a812 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1783,6 +1783,7 @@ static int dmz_load_mapping(struct dmz_metadata *zmd)
>  			atomic_inc(&zmd->unmap_nr_rnd);
>  		} else if (atomic_read(&zmd->nr_reserved_seq_zones) < zmd->nr_reserved_seq) {
>  			list_add_tail(&dzone->link, &zmd->reserved_seq_zones_list);
> +			set_bit(DMZ_RESERVED, &dzone->flags);
>  			atomic_inc(&zmd->nr_reserved_seq_zones);
>  			zmd->nr_seq--;
>  		} else {
> @@ -2210,8 +2211,7 @@ void dmz_free_zone(struct dmz_metadata *zmd, struct dm_zone *zone)
>  	} else if (dmz_is_rnd(zone)) {
>  		list_add_tail(&zone->link, &zmd->unmap_rnd_list);
>  		atomic_inc(&zmd->unmap_nr_rnd);
> -	} else if (atomic_read(&zmd->nr_reserved_seq_zones) <
> -		   zmd->nr_reserved_seq) {
> +	} else if (dmz_is_reserved(zone)) {
>  		list_add_tail(&zone->link, &zmd->reserved_seq_zones_list);
>  		atomic_inc(&zmd->nr_reserved_seq_zones);
>  	} else {
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index dab701893b67..983f5b5e9fa0 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -130,6 +130,7 @@ enum {
>  	DMZ_META,
>  	DMZ_DATA,
>  	DMZ_BUF,
> +	DMZ_RESERVED,
>  
>  	/* Zone internal state */
>  	DMZ_RECLAIM,
> @@ -147,6 +148,7 @@ enum {
>  #define dmz_is_offline(z)	test_bit(DMZ_OFFLINE, &(z)->flags)
>  #define dmz_is_readonly(z)	test_bit(DMZ_READ_ONLY, &(z)->flags)
>  #define dmz_in_reclaim(z)	test_bit(DMZ_RECLAIM, &(z)->flags)
> +#define dmz_is_reserved(z)	test_bit(DMZ_RESERVED, &(z)->flags)
>  #define dmz_seq_write_err(z)	test_bit(DMZ_SEQ_WRITE_ERR, &(z)->flags)
>  #define dmz_reclaim_should_terminate(z) \
>  				test_bit(DMZ_RECLAIM_TERMINATE, &(z)->flags)
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
