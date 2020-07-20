From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/3] block: remove blk_queue_stack_limits
Date: Mon, 20 Jul 2020 08:11:53 +0000
Message-ID: <CY4PR04MB37519991BBC1A1341F3CBFA6E77B0@CY4PR04MB3751.namprd04.prod.outlook.com>
References: <20200720061251.652457-1-hch@lst.de>
 <20200720061251.652457-4-hch@lst.de>
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
> This function is just a tiny wrapper around blk_stack_limits.  Open code=
=0A=
> it int the two callers.=0A=
> =0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> ---=0A=
>  block/blk-settings.c         | 11 -----------=0A=
>  drivers/block/drbd/drbd_nl.c |  4 ++--=0A=
>  drivers/nvme/host/core.c     |  3 ++-=0A=
>  include/linux/blkdev.h       |  1 -=0A=
>  4 files changed, 4 insertions(+), 15 deletions(-)=0A=
> =0A=
> diff --git a/block/blk-settings.c b/block/blk-settings.c=0A=
> index 8c63af7726850c..76a7e03bcd6cac 100644=0A=
> --- a/block/blk-settings.c=0A=
> +++ b/block/blk-settings.c=0A=
> @@ -455,17 +455,6 @@ void blk_queue_io_opt(struct request_queue *q, unsig=
ned int opt)=0A=
>  }=0A=
>  EXPORT_SYMBOL(blk_queue_io_opt);=0A=
>  =0A=
> -/**=0A=
> - * blk_queue_stack_limits - inherit underlying queue limits for stacked =
drivers=0A=
> - * @t:	the stacking driver (top)=0A=
> - * @b:  the underlying device (bottom)=0A=
> - **/=0A=
> -void blk_queue_stack_limits(struct request_queue *t, struct request_queu=
e *b)=0A=
> -{=0A=
> -	blk_stack_limits(&t->limits, &b->limits, 0);=0A=
> -}=0A=
> -EXPORT_SYMBOL(blk_queue_stack_limits);=0A=
> -=0A=
>  /**=0A=
>   * blk_stack_limits - adjust queue_limits for stacked devices=0A=
>   * @t:	the stacking driver limits (top device)=0A=
> diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c=
=0A=
> index da4a3ebe04efa5..d0d9a549b58388 100644=0A=
> --- a/drivers/block/drbd/drbd_nl.c=0A=
> +++ b/drivers/block/drbd/drbd_nl.c=0A=
> @@ -1250,7 +1250,7 @@ static void fixup_discard_if_not_supported(struct r=
equest_queue *q)=0A=
>  =0A=
>  static void fixup_write_zeroes(struct drbd_device *device, struct reques=
t_queue *q)=0A=
>  {=0A=
> -	/* Fixup max_write_zeroes_sectors after blk_queue_stack_limits():=0A=
> +	/* Fixup max_write_zeroes_sectors after blk_stack_limits():=0A=
>  	 * if we can handle "zeroes" efficiently on the protocol,=0A=
>  	 * we want to do that, even if our backend does not announce=0A=
>  	 * max_write_zeroes_sectors itself. */=0A=
> @@ -1361,7 +1361,7 @@ static void drbd_setup_queue_param(struct drbd_devi=
ce *device, struct drbd_backi=0A=
>  	decide_on_write_same_support(device, q, b, o, disable_write_same);=0A=
>  =0A=
>  	if (b) {=0A=
> -		blk_queue_stack_limits(q, b);=0A=
> +		blk_stack_limits(&q->limits, &b->limits, 0);=0A=
>  =0A=
>  		if (q->backing_dev_info->ra_pages !=3D=0A=
>  		    b->backing_dev_info->ra_pages) {=0A=
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c=0A=
> index 5192a024dc1b9c..45c4c408649080 100644=0A=
> --- a/drivers/nvme/host/core.c=0A=
> +++ b/drivers/nvme/host/core.c=0A=
> @@ -1973,7 +1973,8 @@ static int __nvme_revalidate_disk(struct gendisk *d=
isk, struct nvme_id_ns *id)=0A=
>  #ifdef CONFIG_NVME_MULTIPATH=0A=
>  	if (ns->head->disk) {=0A=
>  		nvme_update_disk_info(ns->head->disk, ns, id);=0A=
> -		blk_queue_stack_limits(ns->head->disk->queue, ns->queue);=0A=
> +		blk_stack_limits(&ns->head->disk->queue->limits,=0A=
> +				 &ns->queue->limits, 0);=0A=
>  		revalidate_disk(ns->head->disk);=0A=
>  	}=0A=
>  #endif=0A=
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h=0A=
> index 247b0e0a2901f0..484cd3c8447452 100644=0A=
> --- a/include/linux/blkdev.h=0A=
> +++ b/include/linux/blkdev.h=0A=
> @@ -1108,7 +1108,6 @@ extern int blk_stack_limits(struct queue_limits *t,=
 struct queue_limits *b,=0A=
>  			    sector_t offset);=0A=
>  extern void disk_stack_limits(struct gendisk *disk, struct block_device =
*bdev,=0A=
>  			      sector_t offset);=0A=
> -extern void blk_queue_stack_limits(struct request_queue *t, struct reque=
st_queue *b);=0A=
>  extern void blk_queue_update_dma_pad(struct request_queue *, unsigned in=
t);=0A=
>  extern void blk_queue_segment_boundary(struct request_queue *, unsigned =
long);=0A=
>  extern void blk_queue_virt_boundary(struct request_queue *, unsigned lon=
g);=0A=
> =0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
=0A=
-- =0A=
Damien Le Moal=0A=
Western Digital Research=0A=
