From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/3] dm: remove the make_request_fn check in
 device_area_is_invalid
Date: Tue, 28 Apr 2020 14:38:13 -0400
Message-ID: <20200428183812.GA17609@redhat.com>
References: <20200425075336.721021-1-hch@lst.de>
	<20200425075336.721021-3-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200425075336.721021-3-hch@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-bcache@vger.kernel.org
List-Id: dm-devel.ids

On Sat, Apr 25 2020 at  3:53am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Signed-off-by: Christoph Hellwig <hch@lst.de>

Think it'd be useful to add a commit message like you did for revert
commit f01b411f41f91fc3196eae4317cf8b4d872830a6 , e.g.:

We can't have queues without a make_request_fn any more (and the loop
device uses blk-mq these days anyway..).

But that aside:

Acked-by: Mike Snitzer <snitzer@redhat.com>

Thanks.

> ---
>  drivers/md/dm-table.c | 17 -----------------
>  1 file changed, 17 deletions(-)
> 
> diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
> index 0a2cc197f62b4..8277b959e00bd 100644
> --- a/drivers/md/dm-table.c
> +++ b/drivers/md/dm-table.c
> @@ -279,7 +279,6 @@ static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
>  static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  				  sector_t start, sector_t len, void *data)
>  {
> -	struct request_queue *q;
>  	struct queue_limits *limits = data;
>  	struct block_device *bdev = dev->bdev;
>  	sector_t dev_size =
> @@ -288,22 +287,6 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
>  		limits->logical_block_size >> SECTOR_SHIFT;
>  	char b[BDEVNAME_SIZE];
>  
> -	/*
> -	 * Some devices exist without request functions,
> -	 * such as loop devices not yet bound to backing files.
> -	 * Forbid the use of such devices.
> -	 */
> -	q = bdev_get_queue(bdev);
> -	if (!q || !q->make_request_fn) {
> -		DMWARN("%s: %s is not yet initialised: "
> -		       "start=%llu, len=%llu, dev_size=%llu",
> -		       dm_device_name(ti->table->md), bdevname(bdev, b),
> -		       (unsigned long long)start,
> -		       (unsigned long long)len,
> -		       (unsigned long long)dev_size);
> -		return 1;
> -	}
> -
>  	if (!dev_size)
>  		return 0;
>  
> -- 
> 2.26.1
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
