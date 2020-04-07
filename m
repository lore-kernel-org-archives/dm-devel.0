From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 05/11] dm-zoned: introduce
 dmz_metadata_label() to format device name
Date: Tue, 7 Apr 2020 02:26:08 +0000
Message-ID: <BY5PR04MB6900F83D0D17A2A183B1513BE7C30@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200406143505.133271-1-hare@suse.de>
	<20200406143505.133271-6-hare@suse.de>
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

On 2020/04/07 2:28, Hannes Reinecke wrote:
> Introduce dmz_metadata_label() to format the device-mapper device
> name and use it instead of the device name of the underlying device.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

> ---
>  drivers/md/dm-zoned-metadata.c | 11 ++++++++++-
>  drivers/md/dm-zoned-reclaim.c  | 15 ++++++++-------
>  drivers/md/dm-zoned-target.c   | 17 ++++++++++-------
>  drivers/md/dm-zoned.h          |  4 +++-
>  4 files changed, 31 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index ae261bf6452c..f7ae57e78230 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -134,6 +134,8 @@ struct dmz_sb {
>  struct dmz_metadata {
>  	struct dmz_dev		*dev;
>  
> +	char			devname[BDEVNAME_SIZE];
> +
>  	sector_t		zone_bitmap_size;
>  	unsigned int		zone_nr_bitmap_blocks;
>  	unsigned int		zone_bits_per_mblk;
> @@ -265,6 +267,11 @@ unsigned int dmz_nr_unmap_seq_zones(struct dmz_metadata *zmd)
>  	return atomic_read(&zmd->unmap_nr_seq);
>  }
>  
> +const char *dmz_metadata_label(struct dmz_metadata *zmd)
> +{
> +	return (const char *)zmd->devname;
> +}
> +
>  /*
>   * Lock/unlock mapping table.
>   * The map lock also protects all the zone lists.
> @@ -2445,7 +2452,8 @@ static void dmz_cleanup_metadata(struct dmz_metadata *zmd)
>  /*
>   * Initialize the zoned metadata.
>   */
> -int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
> +int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata,
> +		     const char *devname)
>  {
>  	struct dmz_metadata *zmd;
>  	unsigned int i, zid;
> @@ -2456,6 +2464,7 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
>  	if (!zmd)
>  		return -ENOMEM;
>  
> +	strcpy(zmd->devname, devname);
>  	zmd->dev = dev;
>  	zmd->mblk_rbtree = RB_ROOT;
>  	init_rwsem(&zmd->mblk_sem);
> diff --git a/drivers/md/dm-zoned-reclaim.c b/drivers/md/dm-zoned-reclaim.c
> index 95d2c8870480..c46159b6fc46 100644
> --- a/drivers/md/dm-zoned-reclaim.c
> +++ b/drivers/md/dm-zoned-reclaim.c
> @@ -481,15 +481,16 @@ static void dmz_reclaim_work(struct work_struct *work)
>  		zrc->kc_throttle.throttle = min(75U, 100U - p_unmap_rnd / 2);
>  	}
>  
> -	dmz_dev_debug(zrc->dev,
> -		      "Reclaim (%u): %s, %u%% free rnd zones (%u/%u)",
> -		      zrc->kc_throttle.throttle,
> -		      (dmz_target_idle(zrc) ? "Idle" : "Busy"),
> -		      p_unmap_rnd, nr_unmap_rnd, nr_rnd);
> +	DMDEBUG("(%s): Reclaim (%u): %s, %u%% free rnd zones (%u/%u)",
> +		dmz_metadata_label(zmd),
> +		zrc->kc_throttle.throttle,
> +		(dmz_target_idle(zrc) ? "Idle" : "Busy"),
> +		p_unmap_rnd, nr_unmap_rnd, nr_rnd);
>  
>  	ret = dmz_do_reclaim(zrc);
>  	if (ret) {
> -		dmz_dev_debug(zrc->dev, "Reclaim error %d\n", ret);
> +		DMDEBUG("(%s): Reclaim error %d\n",
> +			dmz_metadata_label(zmd), ret);
>  		if (!dmz_check_bdev(zrc->dev))
>  			return;
>  	}
> @@ -525,7 +526,7 @@ int dmz_ctr_reclaim(struct dmz_dev *dev, struct dmz_metadata *zmd,
>  	/* Reclaim work */
>  	INIT_DELAYED_WORK(&zrc->work, dmz_reclaim_work);
>  	zrc->wq = alloc_ordered_workqueue("dmz_rwq_%s", WQ_MEM_RECLAIM,
> -					  dev->name);
> +					  dmz_metadata_label(zmd));
>  	if (!zrc->wq) {
>  		ret = -ENOMEM;
>  		goto err;
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index f4e3be7f9474..c2c3aa090f97 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -782,7 +782,8 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  
>  	/* Initialize metadata */
>  	dev = dmz->dev;
> -	ret = dmz_ctr_metadata(dev, &dmz->metadata);
> +	ret = dmz_ctr_metadata(dev, &dmz->metadata,
> +			       dm_table_device_name(ti->table));
>  	if (ret) {
>  		ti->error = "Metadata initialization failed";
>  		goto err_dev;
> @@ -811,8 +812,9 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	/* Chunk BIO work */
>  	mutex_init(&dmz->chunk_lock);
>  	INIT_RADIX_TREE(&dmz->chunk_rxtree, GFP_NOIO);
> -	dmz->chunk_wq = alloc_workqueue("dmz_cwq_%s", WQ_MEM_RECLAIM | WQ_UNBOUND,
> -					0, dev->name);
> +	dmz->chunk_wq = alloc_workqueue("dmz_cwq_%s",
> +					WQ_MEM_RECLAIM | WQ_UNBOUND, 0,
> +					dmz_metadata_label(dmz->metadata));
>  	if (!dmz->chunk_wq) {
>  		ti->error = "Create chunk workqueue failed";
>  		ret = -ENOMEM;
> @@ -824,7 +826,7 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	bio_list_init(&dmz->flush_list);
>  	INIT_DELAYED_WORK(&dmz->flush_work, dmz_flush_work);
>  	dmz->flush_wq = alloc_ordered_workqueue("dmz_fwq_%s", WQ_MEM_RECLAIM,
> -						dev->name);
> +						dmz_metadata_label(dmz->metadata));
>  	if (!dmz->flush_wq) {
>  		ti->error = "Create flush workqueue failed";
>  		ret = -ENOMEM;
> @@ -839,9 +841,10 @@ static int dmz_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  		goto err_fwq;
>  	}
>  
> -	dmz_dev_info(dev, "Target device: %llu 512-byte logical sectors (%llu blocks)",
> -		     (unsigned long long)ti->len,
> -		     (unsigned long long)dmz_sect2blk(ti->len));
> +	DMINFO("(%s): Target device: %llu 512-byte logical sectors (%llu blocks)",
> +	       dmz_metadata_label(dmz->metadata),
> +	       (unsigned long long)ti->len,
> +	       (unsigned long long)dmz_sect2blk(ti->len));
>  
>  	return 0;
>  err_fwq:
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index c1b7b9a729c2..f7df7f67e404 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -163,7 +163,8 @@ struct dmz_reclaim;
>  /*
>   * Functions defined in dm-zoned-metadata.c
>   */
> -int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **zmd);
> +int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **zmd,
> +		     const char *devname);
>  void dmz_dtr_metadata(struct dmz_metadata *zmd);
>  int dmz_resume_metadata(struct dmz_metadata *zmd);
>  
> @@ -174,6 +175,7 @@ void dmz_unlock_metadata(struct dmz_metadata *zmd);
>  void dmz_lock_flush(struct dmz_metadata *zmd);
>  void dmz_unlock_flush(struct dmz_metadata *zmd);
>  int dmz_flush_metadata(struct dmz_metadata *zmd);
> +const char *dmz_metadata_label(struct dmz_metadata *zmd);
>  
>  unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone);
>  sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone);
> 


-- 
Damien Le Moal
Western Digital Research
