From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/7] block: use block_device name vsprintf helper
Date: Tue, 14 Apr 2015 11:16:24 +0200
Message-ID: <20150414091624.GF23327@quack.suse.cz>
References: <1428928300-9132-1-git-send-email-dmonakhov@openvz.org>
 <1428928300-9132-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428928300-9132-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, viro@zeniv.linux.org.uk, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon 13-04-15 16:31:36, Dmitry Monakhov wrote:
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  block/blk-core.c     |   30 ++++++++++++------------------
>  block/blk-settings.c |    9 ++-------
>  2 files changed, 14 insertions(+), 25 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 794c3e7..88a4c94 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1694,12 +1694,9 @@ static inline void blk_partition_remap(struct bio *bio)
>  
>  static void handle_bad_sector(struct bio *bio)
>  {
> -	char b[BDEVNAME_SIZE];
> -
>  	printk(KERN_INFO "attempt to access beyond end of device\n");
> -	printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
> -			bdevname(bio->bi_bdev, b),
> -			bio->bi_rw,
> +	printk(KERN_INFO "%pg: rw=%ld, want=%Lu, limit=%Lu\n",
> +	       		bio->bi_bdev,bio->bi_rw,
>  			(unsigned long long)bio_end_sector(bio),
>  			(long long)(i_size_read(bio->bi_bdev->bd_inode) >> 9));
>  
> @@ -1776,7 +1773,6 @@ generic_make_request_checks(struct bio *bio)
>  	struct request_queue *q;
>  	int nr_sectors = bio_sectors(bio);
>  	int err = -EIO;
> -	char b[BDEVNAME_SIZE];
>  	struct hd_struct *part;
>  
>  	might_sleep();
> @@ -1788,16 +1784,16 @@ generic_make_request_checks(struct bio *bio)
>  	if (unlikely(!q)) {
>  		printk(KERN_ERR
>  		       "generic_make_request: Trying to access "
> -			"nonexistent block-device %s (%Lu)\n",
> -			bdevname(bio->bi_bdev, b),
> -			(long long) bio->bi_iter.bi_sector);
> +		       "nonexistent block-device %pg (%Lu)\n",
> +		       bio->bi_bdev,
> +		       (long long) bio->bi_iter.bi_sector);
>  		goto end_io;
>  	}
>  
>  	if (likely(bio_is_rw(bio) &&
>  		   nr_sectors > queue_max_hw_sectors(q))) {
> -		printk(KERN_ERR "bio too big device %s (%u > %u)\n",
> -		       bdevname(bio->bi_bdev, b),
> +		printk(KERN_ERR "bio too big device %pg (%u > %u)\n",
> +		       bio->bi_bdev,
>  		       bio_sectors(bio),
>  		       queue_max_hw_sectors(q));
>  		goto end_io;
> @@ -1970,13 +1966,11 @@ void submit_bio(int rw, struct bio *bio)
>  		}
>  
>  		if (unlikely(block_dump)) {
> -			char b[BDEVNAME_SIZE];
> -			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
> -			current->comm, task_pid_nr(current),
> -				(rw & WRITE) ? "WRITE" : "READ",
> -				(unsigned long long)bio->bi_iter.bi_sector,
> -				bdevname(bio->bi_bdev, b),
> -				count);
> +			printk(KERN_DEBUG "%s(%d): %s block %Lu on %pg (%u sectors)\n",
> +			       current->comm, task_pid_nr(current),
> +			       (rw & WRITE) ? "WRITE" : "READ",
> +			       (unsigned long long)bio->bi_iter.bi_sector,
> +			       bio->bi_bdev, count);
>  		}
>  	}
>  
> diff --git a/block/blk-settings.c b/block/blk-settings.c
> index 12600bf..6f9157c 100644
> --- a/block/blk-settings.c
> +++ b/block/blk-settings.c
> @@ -689,13 +689,8 @@ void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
>  	struct request_queue *t = disk->queue;
>  
>  	if (bdev_stack_limits(&t->limits, bdev, offset >> 9) < 0) {
> -		char top[BDEVNAME_SIZE], bottom[BDEVNAME_SIZE];
> -
> -		disk_name(disk, 0, top);
> -		bdevname(bdev, bottom);
> -
> -		printk(KERN_NOTICE "%s: Warning: Device %s is misaligned\n",
> -		       top, bottom);
> +		printk(KERN_NOTICE "%s: Warning: Device %pg is misaligned\n",
> +		       disk->disk_name, bdev);
>  	}
>  }
>  EXPORT_SYMBOL(disk_stack_limits);
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
