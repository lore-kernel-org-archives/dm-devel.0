From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 2/3] block: remove bdev_stack_limits
Date: Mon, 20 Jul 2020 08:11:23 +0000
Message-ID: <CY4PR04MB3751CDE47A50C4F06D4C97F9E77B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200720061251.652457-1-hch@lst.de>
 <20200720061251.652457-3-hch@lst.de>
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
> This function is just a tiny wrapper around blk_stack_limit and has=0A=
> two callers.  Simplify the stack a bit by open coding it in the two=0A=
> callers.=0A=
> =0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> ---=0A=
>  block/blk-settings.c   | 25 ++-----------------------=0A=
>  drivers/md/dm-table.c  |  3 ++-=0A=
>  include/linux/blkdev.h |  2 --=0A=
>  3 files changed, 4 insertions(+), 26 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-settings.c b/block/blk-settings.c=0A=
> index 9cddbd73647405..8c63af7726850c 100644=0A=
> --- a/block/blk-settings.c=0A=
> +++ b/block/blk-settings.c=0A=
> @@ -614,28 +614,6 @@ int blk_stack_limits(struct queue_limits *t, struct =
queue_limits *b,=0A=
>  }=0A=
>  EXPORT_SYMBOL(blk_stack_limits);=0A=
>  =0A=
> -/**=0A=
> - * bdev_stack_limits - adjust queue limits for stacked drivers=0A=
> - * @t:	the stacking driver limits (top device)=0A=
> - * @bdev:  the component block_device (bottom)=0A=
> - * @start:  first data sector within component device=0A=
> - *=0A=
> - * Description:=0A=
> - *    Merges queue limits for a top device and a block_device.  Returns=
=0A=
> - *    0 if alignment didn't change.  Returns -1 if adding the bottom=0A=
> - *    device caused misalignment.=0A=
> - */=0A=
> -int bdev_stack_limits(struct queue_limits *t, struct block_device *bdev,=
=0A=
> -		      sector_t start)=0A=
> -{=0A=
> -	struct request_queue *bq =3D bdev_get_queue(bdev);=0A=
> -=0A=
> -	start +=3D get_start_sect(bdev);=0A=
> -=0A=
> -	return blk_stack_limits(t, &bq->limits, start);=0A=
> -}=0A=
> -EXPORT_SYMBOL(bdev_stack_limits);=0A=
> -=0A=
>  /**=0A=
>   * disk_stack_limits - adjust queue limits for stacked drivers=0A=
>   * @disk:  MD/DM gendisk (top)=0A=
> @@ -651,7 +629,8 @@ void disk_stack_limits(struct gendisk *disk, struct b=
lock_device *bdev,=0A=
>  {=0A=
>  	struct request_queue *t =3D disk->queue;=0A=
>  =0A=
> -	if (bdev_stack_limits(&t->limits, bdev, offset >> 9) < 0) {=0A=
> +	if (blk_stack_limits(&t->limits, &bdev_get_queue(bdev)->limits,=0A=
> +			get_start_sect(bdev) + (offset >> 9)) < 0) {=0A=
>  		char top[BDEVNAME_SIZE], bottom[BDEVNAME_SIZE];=0A=
>  =0A=
>  		disk_name(disk, 0, top);=0A=
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c=0A=
> index ec5364133cef7f..aac4c31cfc8498 100644=0A=
> --- a/drivers/md/dm-table.c=0A=
> +++ b/drivers/md/dm-table.c=0A=
> @@ -458,7 +458,8 @@ static int dm_set_device_limits(struct dm_target *ti,=
 struct dm_dev *dev,=0A=
>  		return 0;=0A=
>  	}=0A=
>  =0A=
> -	if (bdev_stack_limits(limits, bdev, start) < 0)=0A=
> +	if (blk_stack_limits(limits, &q->limits,=0A=
> +			get_start_sect(bdev) + start) < 0)=0A=
>  		DMWARN("%s: adding target device %s caused an alignment inconsistency:=
 "=0A=
>  		       "physical_block_size=3D%u, logical_block_size=3D%u, "=0A=
>  		       "alignment_offset=3D%u, start=3D%llu",=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 67b9ccc1da3560..247b0e0a2901f0 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -1106,8 +1106,6 @@ extern void blk_set_default_limits(struct queue_lim=
its *lim);=0A=
>  extern void blk_set_stacking_limits(struct queue_limits *lim);=0A=
>  extern int blk_stack_limits(struct queue_limits *t, struct queue_limits =
*b,=0A=
>  			    sector_t offset);=0A=
> -extern int bdev_stack_limits(struct queue_limits *t, struct block_device=
 *bdev,=0A=
> -			    sector_t offset);=0A=
>  extern void disk_stack_limits(struct gendisk *disk, struct block_device =
*bdev,=0A=
>  			      sector_t offset);=0A=
>  extern void blk_queue_stack_limits(struct request_queue *t, struct reque=
st_queue *b);=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
