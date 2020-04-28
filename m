From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 01/13] dm-zoned: add 'status' and 'message'
	callbacks
Date: Tue, 28 Apr 2020 09:19:56 +0000
Message-ID: <BY5PR04MB690041D65C67CF80F1CD9014E7AC0@BY5PR04MB6900.namprd04.prod.outlook.com>
References: <20200420100824.124618-1-hare@suse.de>
	<20200420100824.124618-2-hare@suse.de>
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

On 2020/04/20 19:09, Hannes Reinecke wrote:
> Add callbacks to supply information for 'dmsetup status'
> and 'dmsetup info', and implement the message 'reclaim'
> to start the reclaim worker.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Bob Liu <bob.liu@oracle.com>
> ---
>  drivers/md/dm-zoned-metadata.c | 15 +++++++++++++++
>  drivers/md/dm-zoned-target.c   | 43 ++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/dm-zoned.h          |  3 +++
>  3 files changed, 61 insertions(+)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 369de15c4e80..c8787560fa9f 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -202,6 +202,11 @@ sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone)
>  	return (sector_t)dmz_id(zmd, zone) << zmd->dev->zone_nr_blocks_shift;
>  }
>  
> +unsigned int dmz_nr_zones(struct dmz_metadata *zmd)
> +{
> +	return zmd->dev->nr_zones;
> +}
> +
>  unsigned int dmz_nr_chunks(struct dmz_metadata *zmd)
>  {
>  	return zmd->nr_chunks;
> @@ -217,6 +222,16 @@ unsigned int dmz_nr_unmap_rnd_zones(struct dmz_metadata *zmd)
>  	return atomic_read(&zmd->unmap_nr_rnd);
>  }
>  
> +unsigned int dmz_nr_seq_zones(struct dmz_metadata *zmd)
> +{
> +	return zmd->nr_seq;
> +}
> +
> +unsigned int dmz_nr_unmap_seq_zones(struct dmz_metadata *zmd)
> +{
> +	return atomic_read(&zmd->unmap_nr_seq);
> +}
> +
>  /*
>   * Lock/unlock mapping table.
>   * The map lock also protects all the zone lists.
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index f4f83d39b3dc..44e30a7de8b9 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -965,6 +965,47 @@ static int dmz_iterate_devices(struct dm_target *ti,
>  	return fn(ti, dmz->ddev, 0, capacity, data);
>  }
>  
> +static void dmz_status(struct dm_target *ti, status_type_t type,
> +		       unsigned int status_flags, char *result,
> +		       unsigned int maxlen)
> +{
> +	struct dmz_target *dmz = ti->private;
> +	ssize_t sz = 0;
> +	char buf[BDEVNAME_SIZE];
> +
> +	switch (type) {
> +	case STATUSTYPE_INFO:
> +		DMEMIT("%u zones "
> +		       "%u/%u random "
> +		       "%u/%u sequential",
> +		       dmz_nr_zones(dmz->metadata),
> +		       dmz_nr_unmap_rnd_zones(dmz->metadata),
> +		       dmz_nr_rnd_zones(dmz->metadata),
> +		       dmz_nr_unmap_seq_zones(dmz->metadata),
> +		       dmz_nr_seq_zones(dmz->metadata));
> +		break;
> +	case STATUSTYPE_TABLE:
> +		format_dev_t(buf, dmz->dev->bdev->bd_dev);
> +		DMEMIT("%s ", buf);
> +		break;
> +	}
> +	return;
> +}
> +
> +static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
> +		       char *result, unsigned int maxlen)
> +{
> +	struct dmz_target *dmz = ti->private;
> +	int r = -EINVAL;
> +
> +	if (!strcasecmp(argv[0], "reclaim")) {
> +		dmz_schedule_reclaim(dmz->reclaim);
> +		r = 0;
> +	} else
> +		DMERR("unrecognized message %s", argv[0]);
> +	return r;
> +}
> +
>  static struct target_type dmz_type = {
>  	.name		 = "zoned",
>  	.version	 = {1, 1, 0},
> @@ -978,6 +1019,8 @@ static struct target_type dmz_type = {
>  	.postsuspend	 = dmz_suspend,
>  	.resume		 = dmz_resume,
>  	.iterate_devices = dmz_iterate_devices,
> +	.status		 = dmz_status,
> +	.message	 = dmz_message,
>  };
>  
>  static int __init dmz_init(void)
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index 5b5e493d479c..884c0e586082 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -190,8 +190,11 @@ void dmz_free_zone(struct dmz_metadata *zmd, struct dm_zone *zone);
>  void dmz_map_zone(struct dmz_metadata *zmd, struct dm_zone *zone,
>  		  unsigned int chunk);
>  void dmz_unmap_zone(struct dmz_metadata *zmd, struct dm_zone *zone);
> +unsigned int dmz_nr_zones(struct dmz_metadata *zmd);
>  unsigned int dmz_nr_rnd_zones(struct dmz_metadata *zmd);
>  unsigned int dmz_nr_unmap_rnd_zones(struct dmz_metadata *zmd);
> +unsigned int dmz_nr_seq_zones(struct dmz_metadata *zmd);
> +unsigned int dmz_nr_unmap_seq_zones(struct dmz_metadata *zmd);
>  
>  /*
>   * Activate a zone (increment its reference count).
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research
