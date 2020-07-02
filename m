From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH 16/20] block: move ->make_request_fn to struct
 block_device_operations
Date: Thu, 2 Jul 2020 22:48:54 +0800
Message-ID: <ded333a3-c6d9-2a4d-b427-b06aaa1e925c@suse.de>
References: <20200701085947.3354405-1-hch@lst.de>
 <20200701085947.3354405-17-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200701085947.3354405-17-hch@lst.de>
Content-Language: en-US
Sender: linux-bcache-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

On 2020/7/1 16:59, Christoph Hellwig wrote:
> The make_request_fn is a little weird in that it sits directly in
> struct request_queue instead of an operation vector.  Replace it with
> a block_device_operations method called submit_bio (which describes much
> better what it does).  Also remove the request_queue argument to it, as
> the queue can be derived pretty trivially from the bio.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

For the bcache part,

Acked-by: Coly Li <colyli@suse.de>

> ---
>  Documentation/block/biodoc.rst                |  2 +-
>  .../block/writeback_cache_control.rst         |  2 +-
>  arch/m68k/emu/nfblock.c                       |  5 +-
>  arch/xtensa/platforms/iss/simdisk.c           |  5 +-
>  block/blk-cgroup.c                            |  2 +-
>  block/blk-core.c                              | 53 +++++++------------
>  block/blk-mq.c                                | 10 ++--
>  block/blk.h                                   |  2 -
>  drivers/block/brd.c                           |  5 +-
>  drivers/block/drbd/drbd_int.h                 |  2 +-
>  drivers/block/drbd/drbd_main.c                |  9 ++--
>  drivers/block/drbd/drbd_req.c                 |  2 +-
>  drivers/block/null_blk_main.c                 | 17 ++++--
>  drivers/block/pktcdvd.c                       | 11 ++--
>  drivers/block/ps3vram.c                       | 15 +++---
>  drivers/block/rsxx/dev.c                      |  7 ++-
>  drivers/block/umem.c                          |  5 +-
>  drivers/block/zram/zram_drv.c                 | 11 ++--
>  drivers/lightnvm/core.c                       |  8 +--
>  drivers/lightnvm/pblk-init.c                  | 12 +++--
>  drivers/md/bcache/request.c                   |  4 +-
>  drivers/md/bcache/request.h                   |  4 +-
>  drivers/md/bcache/super.c                     | 23 +++++---
>  drivers/md/dm.c                               | 23 ++++----
>  drivers/md/md.c                               |  5 +-
>  drivers/nvdimm/blk.c                          |  5 +-
>  drivers/nvdimm/btt.c                          |  5 +-
>  drivers/nvdimm/pmem.c                         |  5 +-
>  drivers/nvme/host/core.c                      |  1 +
>  drivers/nvme/host/multipath.c                 |  5 +-
>  drivers/nvme/host/nvme.h                      |  1 +
>  drivers/s390/block/dcssblk.c                  |  9 ++--
>  drivers/s390/block/xpram.c                    |  6 +--
>  include/linux/blk-mq.h                        |  2 +-
>  include/linux/blkdev.h                        |  7 +--
>  include/linux/lightnvm.h                      |  3 +-
>  36 files changed, 153 insertions(+), 140 deletions(-)
> 
[snipped]

> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index 7acf024e99f351..fc5702b10074d6 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -1158,7 +1158,7 @@ static void quit_max_writeback_rate(struct cache_set *c,
>  
>  /* Cached devices - read & write stuff */
>  
> -blk_qc_t cached_dev_make_request(struct request_queue *q, struct bio *bio)
> +blk_qc_t cached_dev_submit_bio(struct bio *bio)
>  {
>  	struct search *s;
>  	struct bcache_device *d = bio->bi_disk->private_data;
> @@ -1291,7 +1291,7 @@ static void flash_dev_nodata(struct closure *cl)
>  	continue_at(cl, search_free, NULL);
>  }
>  
> -blk_qc_t flash_dev_make_request(struct request_queue *q, struct bio *bio)
> +blk_qc_t flash_dev_submit_bio(struct bio *bio)
>  {
>  	struct search *s;
>  	struct closure *cl;
> diff --git a/drivers/md/bcache/request.h b/drivers/md/bcache/request.h
> index bb005c93dd7218..82b38366a95deb 100644
> --- a/drivers/md/bcache/request.h
> +++ b/drivers/md/bcache/request.h
> @@ -37,10 +37,10 @@ unsigned int bch_get_congested(const struct cache_set *c);
>  void bch_data_insert(struct closure *cl);
>  
>  void bch_cached_dev_request_init(struct cached_dev *dc);
> -blk_qc_t cached_dev_make_request(struct request_queue *q, struct bio *bio);
> +blk_qc_t cached_dev_submit_bio(struct bio *bio);
>  
>  void bch_flash_dev_request_init(struct bcache_device *d);
> -blk_qc_t flash_dev_make_request(struct request_queue *q, struct bio *bio);
> +blk_qc_t flash_dev_submit_bio(struct bio *bio);
>  
>  extern struct kmem_cache *bch_search_cache;
>  
> diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
> index 21aa168113d30b..de13f6e916966d 100644
> --- a/drivers/md/bcache/super.c
> +++ b/drivers/md/bcache/super.c
> @@ -680,7 +680,16 @@ static int ioctl_dev(struct block_device *b, fmode_t mode,
>  	return d->ioctl(d, mode, cmd, arg);
>  }
>  
> -static const struct block_device_operations bcache_ops = {
> +static const struct block_device_operations bcache_cached_ops = {
> +	.submit_bio	= cached_dev_submit_bio,
> +	.open		= open_dev,
> +	.release	= release_dev,
> +	.ioctl		= ioctl_dev,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static const struct block_device_operations bcache_flash_ops = {
> +	.submit_bio	= flash_dev_submit_bio,
>  	.open		= open_dev,
>  	.release	= release_dev,
>  	.ioctl		= ioctl_dev,
> @@ -820,8 +829,8 @@ static void bcache_device_free(struct bcache_device *d)
>  }
>  
>  static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
> -			      sector_t sectors, make_request_fn make_request_fn,
> -			      struct block_device *cached_bdev)
> +		sector_t sectors, struct block_device *cached_bdev,
> +		const struct block_device_operations *ops)
>  {
>  	struct request_queue *q;
>  	const size_t max_stripes = min_t(size_t, INT_MAX,
> @@ -868,10 +877,10 @@ static int bcache_device_init(struct bcache_device *d, unsigned int block_size,
>  
>  	d->disk->major		= bcache_major;
>  	d->disk->first_minor	= idx_to_first_minor(idx);
> -	d->disk->fops		= &bcache_ops;
> +	d->disk->fops		= ops;
>  	d->disk->private_data	= d;
>  
> -	q = blk_alloc_queue(make_request_fn, NUMA_NO_NODE);
> +	q = blk_alloc_queue(NUMA_NO_NODE);
>  	if (!q)
>  		return -ENOMEM;
>  
> @@ -1355,7 +1364,7 @@ static int cached_dev_init(struct cached_dev *dc, unsigned int block_size)
>  
>  	ret = bcache_device_init(&dc->disk, block_size,
>  			 dc->bdev->bd_part->nr_sects - dc->sb.data_offset,
> -			 cached_dev_make_request, dc->bdev);
> +			 dc->bdev, &bcache_cached_ops);
>  	if (ret)
>  		return ret;
>  
> @@ -1468,7 +1477,7 @@ static int flash_dev_run(struct cache_set *c, struct uuid_entry *u)
>  	kobject_init(&d->kobj, &bch_flash_dev_ktype);
>  
>  	if (bcache_device_init(d, block_bytes(c), u->sectors,
> -			flash_dev_make_request, NULL))
> +			NULL, &bcache_flash_ops))
>  		goto err;
>  
>  	bcache_device_attach(d, c, u - c->uuids);
