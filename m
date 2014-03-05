From: alex chen <alex.chen@huawei.com>
Subject: Re: [PATCH] dm linear: disable WRITE SAME if it fails
Date: Wed, 5 Mar 2014 15:30:29 +0800
Message-ID: <5316D295.8030205@huawei.com>
References: <53042F91.4050201@huawei.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <53042F91.4050201@huawei.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, agk@redhat.com, joseph.qi@huawei.com, dm-devel@redhat.com
List-Id: dm-devel.ids

Who can help me review my patch? ths.

On 2014/2/19 12:14, alex chen wrote:
> The original commit f84cb8a46a771f36a04a02c61ea635c968ed5f6a("dm mpath:
> disable WRITE SAME if it fails") disables WRITE SAME in the DM multipath
> device if it fails, but when the DM linear device stacks ontop of the
> multipath device it doesn't help.
> 
> this patch adds DM linear end_io method to catch WRITE SAME errors and
> disables WRITE SAME in the DM linear device's queue_limits if an
> underlying device disables it.
> 
> Before this patch:
> 
> dm linear device(dm-20): ocfs2-fs;
> multipath device(dm-6);
> scsi device(sdt,sdu);
> 
> After a WRITE SAME bio fails, the DM linear device does not disable the
> WRITE SAME, although the underlying device(DM multipath device) has
> disabled WRITE SAME.
> 
> cat /sys/block/dm-20/queue/write_same_max_bytes
> 33553920
> cat /sys/block/dm-6/queue/write_same_max_bytes
> 0
> cat /sys/block/sdt/queue/write_same_max_bytes
> 0
> cat /sys/block/sdu/queue/write_same_max_bytes
> 0
> 
> After this patch:
> 
> dm linear device(dm-20): ocfs2-fs;
> multipath device(dm-6);
> scsi device(sdt,sdu);
> 
> After a WRITE SAME bio fails, the underlying device(DM multipath
> device) disables WRITE SAME and then the DM linear device also disables
> WRITE SAME.
> 
> cat /sys/block/dm-20/queue/write_same_max_bytes
> 0
> cat /sys/block/dm-6/queue/write_same_max_bytes
> 0
> cat /sys/block/sdt/queue/write_same_max_bytes
> 0
> cat /sys/block/sdu/queue/write_same_max_bytes
> 0
> 
> Signed-off-by: alex.chen <alex.chen@huawei.com>
> ---
>  drivers/md/dm-linear.c | 26 +++++++++++++++++++++++++-
>  drivers/md/dm.c        |  2 +-
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
> index 53e848c..eaf86a5 100644
> --- a/drivers/md/dm-linear.c
> +++ b/drivers/md/dm-linear.c
> @@ -96,6 +96,29 @@ static int linear_map(struct dm_target *ti, struct
> bio *bio)
>  	return DM_MAPIO_REMAPPED;
>  }
> 
> +static int linear_end_io(struct dm_target *ti, struct bio *bio, int error)
> +{
> +	struct linear_c *lc = ti->private;
> +	struct block_device *bdev;
> +	struct queue_limits *limits;
> +	struct queue_limits *bdev_limits;
> +
> +	if (!error)
> +		return error;
> +
> +	if (unlikely(bio->bi_rw & REQ_WRITE_SAME)) {
> +		bdev = lc->dev->bdev;
> +		bdev_limits = &bdev->bd_disk->queue->limits;
> +
> +		limits = dm_get_queue_limits(dm_table_get_md(ti->table));
> +
> +		if ((!bdev_limits->max_write_same_sectors) &&
> +				limits->max_write_same_sectors)
> +			limits->max_write_same_sectors = 0;
> +	}
> +
> +	return error;
> +}
>  static void linear_status(struct dm_target *ti, status_type_t type,
>  			  unsigned status_flags, char *result, unsigned maxlen)
>  {
> @@ -155,11 +178,12 @@ static int linear_iterate_devices(struct dm_target
> *ti,
> 
>  static struct target_type linear_target = {
>  	.name   = "linear",
> -	.version = {1, 2, 1},
> +	.version = {1, 2, 2},
>  	.module = THIS_MODULE,
>  	.ctr    = linear_ctr,
>  	.dtr    = linear_dtr,
>  	.map    = linear_map,
> +	.end_io = linear_end_io,
>  	.status = linear_status,
>  	.ioctl  = linear_ioctl,
>  	.merge  = linear_merge,
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 8c53b09..4337025 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -770,7 +770,7 @@ static void clone_endio(struct bio *bio, int error)
> 
>  	if (endio) {
>  		r = endio(tio->ti, bio, error);
> -		if (r < 0 || r == DM_ENDIO_REQUEUE)
> +		if (r <= 0 || r == DM_ENDIO_REQUEUE)
>  			/*
>  			 * error and requeue request are handled
>  			 * in dec_pending().
> 
