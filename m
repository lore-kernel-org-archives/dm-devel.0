From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 1/3] block: inherit the zoned characteristics in
 blk_stack_limits
Date: Mon, 20 Jul 2020 08:09:53 +0000
Message-ID: <CY4PR04MB37515CAD1C2FBE1F85574CAAE77B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200720061251.652457-1-hch@lst.de>
 <20200720061251.652457-2-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 2020/07/20 15:13, Christoph Hellwig wrote:=0A=
> Lift the code from device mapper into blk_stack_limits to inherity=0A=
> the stacking limitations.  This ensures we do the right thing for=0A=
> all stacked zoned block devices.=0A=
> =0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> ---=0A=
>  block/blk-settings.c   |  1 +=0A=
>  drivers/md/dm-table.c  | 19 -------------------=0A=
>  include/linux/blkdev.h |  9 ++++++---=0A=
>  3 files changed, 7 insertions(+), 22 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-settings.c b/block/blk-settings.c=0A=
> index 9a2c23cd970073..9cddbd73647405 100644=0A=
> --- a/block/blk-settings.c=0A=
> +++ b/block/blk-settings.c=0A=
> @@ -609,6 +609,7 @@ int blk_stack_limits(struct queue_limits *t, struct q=
ueue_limits *b,=0A=
>  		t->chunk_sectors =3D min_not_zero(t->chunk_sectors,=0A=
>  						b->chunk_sectors);=0A=
>  =0A=
> +	t->zoned =3D max(t->zoned, b->zoned);=0A=
>  	return ret;=0A=
>  }=0A=
>  EXPORT_SYMBOL(blk_stack_limits);=0A=
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c=0A=
> index 0ea5b7367179ff..ec5364133cef7f 100644=0A=
> --- a/drivers/md/dm-table.c=0A=
> +++ b/drivers/md/dm-table.c=0A=
> @@ -467,9 +467,6 @@ static int dm_set_device_limits(struct dm_target *ti,=
 struct dm_dev *dev,=0A=
>  		       q->limits.logical_block_size,=0A=
>  		       q->limits.alignment_offset,=0A=
>  		       (unsigned long long) start << SECTOR_SHIFT);=0A=
> -=0A=
> -	limits->zoned =3D blk_queue_zoned_model(q);=0A=
> -=0A=
>  	return 0;=0A=
>  }=0A=
>  =0A=
> @@ -1528,22 +1525,6 @@ int dm_calculate_queue_limits(struct dm_table *tab=
le,=0A=
>  			       dm_device_name(table->md),=0A=
>  			       (unsigned long long) ti->begin,=0A=
>  			       (unsigned long long) ti->len);=0A=
> -=0A=
> -		/*=0A=
> -		 * FIXME: this should likely be moved to blk_stack_limits(), would=0A=
> -		 * also eliminate limits->zoned stacking hack in dm_set_device_limits(=
)=0A=
> -		 */=0A=
> -		if (limits->zoned =3D=3D BLK_ZONED_NONE && ti_limits.zoned !=3D BLK_ZO=
NED_NONE) {=0A=
> -			/*=0A=
> -			 * By default, the stacked limits zoned model is set to=0A=
> -			 * BLK_ZONED_NONE in blk_set_stacking_limits(). Update=0A=
> -			 * this model using the first target model reported=0A=
> -			 * that is not BLK_ZONED_NONE. This will be either the=0A=
> -			 * first target device zoned model or the model reported=0A=
> -			 * by the target .io_hints.=0A=
> -			 */=0A=
> -			limits->zoned =3D ti_limits.zoned;=0A=
> -		}=0A=
>  	}=0A=
>  =0A=
>  	/*=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 06995b96e94679..67b9ccc1da3560 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -306,11 +306,14 @@ enum blk_queue_state {=0A=
>  =0A=
>  /*=0A=
>   * Zoned block device models (zoned limit).=0A=
> + *=0A=
> + * Note: This needs to be ordered from the least to the most severe=0A=
> + * restrictions for the inheritance in blk_stack_limits() to work.=0A=
>   */=0A=
>  enum blk_zoned_model {=0A=
> -	BLK_ZONED_NONE,	/* Regular block device */=0A=
> -	BLK_ZONED_HA,	/* Host-aware zoned block device */=0A=
> -	BLK_ZONED_HM,	/* Host-managed zoned block device */=0A=
> +	BLK_ZONED_NONE =3D 0,	/* Regular block device */=0A=
> +	BLK_ZONED_HA,		/* Host-aware zoned block device */=0A=
> +	BLK_ZONED_HM,		/* Host-managed zoned block device */=0A=
>  };=0A=
>  =0A=
>  struct queue_limits {=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
