From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 5/6] dm-zoned: terminate reclaim on congestion
Date: Tue, 19 May 2020 22:29:27 +0000
Message-ID: <BY5PR04MB69003CE101DCD6D994A62196E7B90@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200519081424.103318-1-hare@suse.de>
	<20200519081424.103318-6-hare@suse.de>
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
> When dmz_get_chunk_mapping() selects a zone which is under reclaim
> we should terminating the reclaim copy process; as we're changing
> the zone itself reclaim needs to run afterwards again anyway.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 2 ++
>  drivers/md/dm-zoned-reclaim.c  | 6 ++++--
>  drivers/md/dm-zoned.h          | 3 +++
>  3 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index ee613ba2e8aa..857390030cac 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -1851,7 +1851,9 @@ static void dmz_wait_for_reclaim(struct dmz_metadata *zmd, struct dm_zone *zone)
>  {
>  	dmz_unlock_map(zmd);
>  	dmz_unlock_metadata(zmd);
> +	set_bit(DMZ_RECLAIM_TERMINATE, &zone->flags);
>  	wait_on_bit_timeout(&zone->flags, DMZ_RECLAIM, TASK_UNINTERRUPTIBLE, HZ);
> +	clear_bit(DMZ_RECLAIM_TERMINATE, &zone->flags);
>  	dmz_lock_metadata(zmd);
>  	dmz_lock_map(zmd);
>  }
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 1283405bec29..3ed88581dc48 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -143,6 +143,9 @@ static int dmz_reclaim_copy(struct dmz_reclaim *zrc,
>  		if (dst_dev->flags & DMZ_BDEV_DYING)
>  			return -EIO;
>  
> +		if (dmz_reclaim_should_terminate(src_zone))
> +			return -EINTR;
> +
>  		/* Get a valid region from the source zone */
>  		ret = dmz_first_valid_block(zmd, src_zone, &block);
>  		if (ret <= 0)
> @@ -517,7 +520,7 @@ static void dmz_reclaim_work(struct work_struct *work)
>  		dmz_nr_rnd_zones(zmd));
>  
>  	ret = dmz_do_reclaim(zrc);
> -	if (ret) {
> +	if (ret && ret != -EINTR) {
>  		DMDEBUG("(%s): Reclaim error %d",
>  			dmz_metadata_label(zmd), ret);
>  		if (!dmz_check_dev(zmd))
> @@ -617,4 +620,3 @@ void dmz_schedule_reclaim(struct dmz_reclaim *zrc)
>  	if (dmz_should_reclaim(zrc, p_unmap))
>  		mod_delayed_work(zrc->wq, &zrc->work, 0);
>  }
> -
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index 288054dd7cf4..8083607b9535 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -127,6 +127,7 @@ enum {
>  	/* Zone internal state */
>  	DMZ_RECLAIM,
>  	DMZ_SEQ_WRITE_ERR,
> +	DMZ_RECLAIM_TERMINATE,
>  };
>  
>  /*
> @@ -140,6 +141,8 @@ enum {
>  #define dmz_is_readonly(z)	test_bit(DMZ_READ_ONLY, &(z)->flags)
>  #define dmz_in_reclaim(z)	test_bit(DMZ_RECLAIM, &(z)->flags)
>  #define dmz_seq_write_err(z)	test_bit(DMZ_SEQ_WRITE_ERR, &(z)->flags)
> +#define dmz_reclaim_should_terminate(z) \
> +				test_bit(DMZ_RECLAIM_TERMINATE, &(z)->flags)
>  
>  #define dmz_is_meta(z)		test_bit(DMZ_META, &(z)->flags)
>  #define dmz_is_buf(z)		test_bit(DMZ_BUF, &(z)->flags)
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
