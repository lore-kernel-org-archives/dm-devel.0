From: Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH 3/4] dm-zoned: V2 metadata handling
Date: Tue, 31 Mar 2020 17:11:17 +0800
Message-ID: <93a26ed9-6f6e-2a4d-38d3-3fb76fa91e70@oracle.com>
References: <20200327071459.67796-1-hare@suse.de>
	<20200327071459.67796-4-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200327071459.67796-4-hare@suse.de>
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
Cc: Damien LeMoal <damien.lemoal@wdc.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 3/27/20 3:14 PM, Hannes Reinecke wrote:
> Add 'V2' metadata which includes UUIDs for the dmz set and for
> the device itself.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Bob Liu <bob.liu@oracle.com>

> ---
>  drivers/md/dm-zoned-metadata.c | 80 +++++++++++++++++++++++++++++++++---------
>  drivers/md/dm-zoned-target.c   |  2 +-
>  2 files changed, 64 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index dc1d17bc3bbb..026f285fba33 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -16,7 +16,8 @@
>  /*
>   * Metadata version.
>   */
> -#define DMZ_META_VER	1
> +#define DMZ_META_COMPAT_VER 1
> +#define DMZ_META_VER	2
>  
>  /*
>   * On-disk super block magic.
> @@ -69,8 +70,17 @@ struct dmz_super {
>  	/* Checksum */
>  	__le32		crc;			/*  48 */
>  
> -	/* Padding to full 512B sector */
> -	u8		reserved[464];		/* 512 */
> +	/* DM-Zoned label */
> +	u8		dmz_label[32];		/*  80 */
> +
> +	/* DM-Zoned UUID */
> +	u8		dmz_uuid[16];		/*  96 */
> +
> +	/* Device UUID */
> +	u8		dev_uuid[16];		/* 112 */
> +
> +	/* Padding to full 512B - CRC sector */
> +	u8		reserved[400];		/* 512 */
>  };
>  
>  /*
> @@ -133,6 +143,10 @@ struct dmz_sb {
>  struct dmz_metadata {
>  	struct dmz_dev		*dev;
>  
> +	char			dmz_label[BDEVNAME_SIZE];
> +	uuid_t			dmz_uuid;
> +	uuid_t			dev_uuid;
> +
>  	sector_t		zone_bitmap_size;
>  	unsigned int		zone_nr_bitmap_blocks;
>  	unsigned int		zone_bits_per_mblk;
> @@ -659,7 +673,14 @@ static int dmz_write_sb(struct dmz_metadata *zmd, unsigned int set)
>  	int ret;
>  
>  	sb->magic = cpu_to_le32(DMZ_MAGIC);
> -	sb->version = cpu_to_le32(DMZ_META_VER);
> +
> +	if (!uuid_is_null(&zmd->dmz_uuid)) {
> +		sb->version = cpu_to_le32(DMZ_META_VER);
> +		uuid_copy((uuid_t *)sb->dmz_uuid, &zmd->dmz_uuid);
> +		memcpy(sb->dmz_label, zmd->dmz_label, BDEVNAME_SIZE);
> +		uuid_copy((uuid_t *)sb->dev_uuid, &zmd->dev_uuid);
> +	} else
> +		sb->version = cpu_to_le32(DMZ_META_COMPAT_VER);
>  
>  	sb->gen = cpu_to_le64(sb_gen);
>  
> @@ -848,28 +869,29 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_super *sb)
>  {
>  	unsigned int nr_meta_zones, nr_data_zones;
>  	struct dmz_dev *dev = zmd->dev;
> -	u32 crc, stored_crc;
> +	u32 crc, stored_crc, dmz_version;
>  	u64 gen;
>  
> -	gen = le64_to_cpu(sb->gen);
> -	stored_crc = le32_to_cpu(sb->crc);
> -	sb->crc = 0;
> -	crc = crc32_le(gen, (unsigned char *)sb, DMZ_BLOCK_SIZE);
> -	if (crc != stored_crc) {
> -		dmz_dev_err(dev, "Invalid checksum (needed 0x%08x, got 0x%08x)",
> -			    crc, stored_crc);
> -		return -ENXIO;
> -	}
> -
>  	if (le32_to_cpu(sb->magic) != DMZ_MAGIC) {
>  		dmz_dev_err(dev, "Invalid meta magic (needed 0x%08x, got 0x%08x)",
>  			    DMZ_MAGIC, le32_to_cpu(sb->magic));
>  		return -ENXIO;
>  	}
>  
> -	if (le32_to_cpu(sb->version) != DMZ_META_VER) {
> +	dmz_version = le32_to_cpu(sb->version);
> +	if (dmz_version > DMZ_META_VER) {
>  		dmz_dev_err(dev, "Invalid meta version (needed %d, got %d)",
> -			    DMZ_META_VER, le32_to_cpu(sb->version));
> +			    DMZ_META_VER, dmz_version);
> +		return -ENXIO;
> +	}
> +
> +	gen = le64_to_cpu(sb->gen);
> +	stored_crc = le32_to_cpu(sb->crc);
> +	sb->crc = 0;
> +	crc = crc32_le(gen, (unsigned char *)sb, DMZ_BLOCK_SIZE);
> +	if (crc != stored_crc) {
> +		dmz_dev_err(dev, "Invalid checksum (needed 0x%08x, got 0x%08x)",
> +			    crc, stored_crc);
>  		return -ENXIO;
>  	}
>  
> @@ -895,6 +917,21 @@ static int dmz_check_sb(struct dmz_metadata *zmd, struct dmz_super *sb)
>  		return -ENXIO;
>  	}
>  
> +	if (dmz_version == DMZ_META_VER) {
> +		if (uuid_is_null((uuid_t *)sb->dmz_uuid)) {
> +			dmz_dev_err(dev, "NULL DM-Zoned uuid");
> +			return -ENXIO;
> +		}
> +		uuid_copy(&zmd->dmz_uuid, (uuid_t *)sb->dmz_uuid);
> +		memcpy(zmd->dmz_label, sb->dmz_label, BDEVNAME_SIZE);
> +		if (uuid_is_null((uuid_t *)sb->dev_uuid)) {
> +			dmz_dev_err(dev, "NULL device uuid");
> +			return -ENXIO;
> +		}
> +		uuid_copy(&zmd->dev_uuid, (uuid_t *)sb->dev_uuid);
> +
> +	}
> +
>  	/* OK */
>  	zmd->nr_meta_blocks = le32_to_cpu(sb->nr_meta_blocks);
>  	zmd->nr_reserved_seq = le32_to_cpu(sb->nr_reserved_seq);
> @@ -2460,9 +2497,18 @@ int dmz_ctr_metadata(struct dmz_dev *dev, struct dmz_metadata **metadata)
>  		goto err;
>  	}
>  
> +	dmz_dev_info(dev, "DM-Zoned version %d",
> +		     uuid_is_null(&zmd->dmz_uuid) ?
> +		     DMZ_META_COMPAT_VER : DMZ_META_VER);
> +	if (!uuid_is_null(&zmd->dmz_uuid))
> +		dmz_dev_info(dev, "DM UUID %pUl", &zmd->dmz_uuid);
> +	if (strlen(zmd->dmz_label))
> +		dmz_dev_info(dev, "DM Label %s", zmd->dmz_label);
>  	dmz_dev_info(dev, "Host-%s zoned block device",
>  		     bdev_zoned_model(dev->bdev) == BLK_ZONED_HA ?
>  		     "aware" : "managed");
> +	if (!uuid_is_null(&zmd->dev_uuid))
> +		dmz_dev_info(dev, "  uuid %pUl", &zmd->dev_uuid);
>  	dmz_dev_info(dev, "  %llu 512-byte logical sectors",
>  		     (u64)dev->capacity);
>  	dmz_dev_info(dev, "  %u zones of %llu 512-byte logical sectors",
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 44e30a7de8b9..7ec9dde24516 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -1008,7 +1008,7 @@ static int dmz_message(struct dm_target *ti, unsigned int argc, char **argv,
>  
>  static struct target_type dmz_type = {
>  	.name		 = "zoned",
> -	.version	 = {1, 1, 0},
> +	.version	 = {1, 2, 0},
>  	.features	 = DM_TARGET_SINGLETON | DM_TARGET_ZONED_HM,
>  	.module		 = THIS_MODULE,
>  	.ctr		 = dmz_ctr,
> 
