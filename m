From: Ming Lei <ming.lei@redhat.com>
Subject: Re: [PATCH v2 4/4] dm: unconditionally call blk_queue_split() in
 dm_process_bio()
Date: Wed, 16 Sep 2020 09:08:17 +0800
Message-ID: <20200916010817.GB791425@T590>
References: <20200915172357.83215-1-snitzer@redhat.com>
 <20200915172357.83215-5-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20200915172357.83215-5-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vijayendra Suman <vijayendra.suman@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

On Tue, Sep 15, 2020 at 01:23:57PM -0400, Mike Snitzer wrote:
> blk_queue_split() has become compulsory from .submit_bio -- regardless
> of whether it is recursing.  Update DM core to always call
> blk_queue_split().
> 
> dm_queue_split() is removed because __split_and_process_bio() handles
> splitting as needed.
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/md/dm.c | 45 +--------------------------------------------
>  1 file changed, 1 insertion(+), 44 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index fb0255d25e4b..0bae9f26dc8e 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1530,22 +1530,6 @@ static int __send_write_zeroes(struct clone_info *ci, struct dm_target *ti)
>  	return __send_changing_extent_only(ci, ti, get_num_write_zeroes_bios(ti));
>  }
>  
> -static bool is_abnormal_io(struct bio *bio)
> -{
> -	bool r = false;
> -
> -	switch (bio_op(bio)) {
> -	case REQ_OP_DISCARD:
> -	case REQ_OP_SECURE_ERASE:
> -	case REQ_OP_WRITE_SAME:
> -	case REQ_OP_WRITE_ZEROES:
> -		r = true;
> -		break;
> -	}
> -
> -	return r;
> -}
> -
>  static bool __process_abnormal_io(struct clone_info *ci, struct dm_target *ti,
>  				  int *result)
>  {
> @@ -1723,23 +1707,6 @@ static blk_qc_t __process_bio(struct mapped_device *md, struct dm_table *map,
>  	return ret;
>  }
>  
> -static void dm_queue_split(struct mapped_device *md, struct dm_target *ti, struct bio **bio)
> -{
> -	unsigned len, sector_count;
> -
> -	sector_count = bio_sectors(*bio);
> -	len = min_t(sector_t, max_io_len((*bio)->bi_iter.bi_sector, ti), sector_count);
> -
> -	if (sector_count > len) {
> -		struct bio *split = bio_split(*bio, len, GFP_NOIO, &md->queue->bio_split);
> -
> -		bio_chain(split, *bio);
> -		trace_block_split(md->queue, split, (*bio)->bi_iter.bi_sector);
> -		submit_bio_noacct(*bio);
> -		*bio = split;
> -	}
> -}
> -
>  static blk_qc_t dm_process_bio(struct mapped_device *md,
>  			       struct dm_table *map, struct bio *bio)
>  {
> @@ -1759,17 +1726,7 @@ static blk_qc_t dm_process_bio(struct mapped_device *md,
>  		}
>  	}
>  
> -	/*
> -	 * If in ->queue_bio we need to use blk_queue_split(), otherwise
> -	 * queue_limits for abnormal requests (e.g. discard, writesame, etc)
> -	 * won't be imposed.
> -	 */
> -	if (current->bio_list) {
> -		if (is_abnormal_io(bio))
> -			blk_queue_split(&bio);
> -		else
> -			dm_queue_split(md, ti, &bio);
> -	}
> +	blk_queue_split(&bio);

In max_io_len(), target boundary is taken into account when figuring out
the max io len. However, this info won't be used any more after
switching to blk_queue_split(). Is that one potential problem?


thanks,
Ming
