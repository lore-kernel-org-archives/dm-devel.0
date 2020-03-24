From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/2] dm-zoned: add 'status' and 'message'
	callbacks
Date: Tue, 24 Mar 2020 03:54:17 +0000
Message-ID: <CO2PR04MB23435B2F65967957A5055580E7F10@CO2PR04MB2343.namprd04.prod.outlook.com>
References: <20200323150352.107826-1-hare@suse.de>
	<20200323150352.107826-3-hare@suse.de>
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
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, Johannes Thumshirn <jth@kernel.org>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

On 2020/03/24 0:04, Hannes Reinecke wrote:
> Add callbacks to supply information for 'dmsetup status'
> and 'dmsetup info', and implement the message 'reclaim'
> to start the reclaim worker.

This one is nice ! Can you send it out minus the cache changes ? We can use it
with unmodified dm-zoned :)

> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/md/dm-zoned-metadata.c | 15 ++++++++++
>  drivers/md/dm-zoned-target.c   | 50 ++++++++++++++++++++++++++++++++++
>  drivers/md/dm-zoned.h          |  3 ++
>  3 files changed, 68 insertions(+)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 41cc3a29db0b..878e152250ab 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -219,6 +219,11 @@ sector_t dmz_start_block(struct dmz_metadata *zmd, struct dm_zone *zone)
>  	return zone_id << zmd->dev->zone_nr_blocks_shift;
>  }
>  
> +unsigned int dmz_nr_zones(struct dmz_metadata *zmd)
> +{
> +	return zmd->nr_zones;
> +}
> +
>  unsigned int dmz_nr_chunks(struct dmz_metadata *zmd)
>  {
>  	return zmd->nr_chunks;
> @@ -244,6 +249,16 @@ unsigned int dmz_nr_unmap_cache_zones(struct dmz_metadata *zmd)
>  	return atomic_read(&zmd->unmap_nr_cache);
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
> index 3f25953672b9..1c0368981f49 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -1050,6 +1050,54 @@ static int dmz_iterate_devices(struct dm_target *ti,
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
> +		       "%u/%u cache "
> +		       "%u/%u random "
> +		       "%u/%u sequential",
> +		       dmz_nr_zones(dmz->metadata),
> +		       dmz_nr_unmap_cache_zones(dmz->metadata),
> +		       dmz_nr_cache_zones(dmz->metadata),
> +		       dmz_nr_unmap_rnd_zones(dmz->metadata),
> +		       dmz_nr_rnd_zones(dmz->metadata),
> +		       dmz_nr_unmap_seq_zones(dmz->metadata),
> +		       dmz_nr_seq_zones(dmz->metadata));
> +		break;
> +	case STATUSTYPE_TABLE:
> +		format_dev_t(buf, dmz->dev->bdev->bd_dev);
> +		DMEMIT("%s ", buf);
> +		if (dmz->cdev) {
> +			format_dev_t(buf, dmz->cdev->bdev->bd_dev);
> +			DMEMIT("%s ", buf);
> +		}
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
> @@ -1063,6 +1111,8 @@ static struct target_type dmz_type = {
>  	.postsuspend	 = dmz_suspend,
>  	.resume		 = dmz_resume,
>  	.iterate_devices = dmz_iterate_devices,
> +	.status		 = dmz_status,
> +	.message	 = dmz_message,
>  };
>  
>  static int __init dmz_init(void)
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index c2b6a919681a..2b3745e8f679 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -213,10 +213,13 @@ void dmz_free_zone(struct dmz_metadata *zmd, struct dm_zone *zone);
>  void dmz_map_zone(struct dmz_metadata *zmd, struct dm_zone *zone,
>  		  unsigned int chunk);
>  void dmz_unmap_zone(struct dmz_metadata *zmd, struct dm_zone *zone);
> +unsigned int dmz_nr_zones(struct dmz_metadata *zmd);
>  unsigned int dmz_nr_rnd_zones(struct dmz_metadata *zmd);
>  unsigned int dmz_nr_unmap_rnd_zones(struct dmz_metadata *zmd);
>  unsigned int dmz_nr_cache_zones(struct dmz_metadata *zmd);
>  unsigned int dmz_nr_unmap_cache_zones(struct dmz_metadata *zmd);
> +unsigned int dmz_nr_seq_zones(struct dmz_metadata *zmd);
> +unsigned int dmz_nr_unmap_seq_zones(struct dmz_metadata *zmd);
>  
>  /*
>   * Activate a zone (increment its reference count).
> 


-- 
Damien Le Moal
Western Digital Research
