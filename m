From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: [dm-devel] [PATCH] dm-crypt: fix lost ioprio when queuing crypto
 bios from task with ioprio
Date: Fri, 16 Dec 2016 14:29:46 -0800 (PST)
Message-ID: <alpine.LRH.2.11.1612161414280.9898@mail.ewheeler.net>
References: <alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1612141049250.13402@mail.ewheeler.net>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org
List-Id: dm-devel.ids

On Wed, 14 Dec 2016, Eric Wheeler wrote:
> Since dm-crypt queues writes (and sometimes reads) to a different kernel
> thread (workqueue), the bios will dispatch from tasks with different
> io_context->ioprio settings than the submitting task, thus giving
> incorrect ioprio hints to the io scheduler.

The motivation of this patch is for ioprio-driven writebackup/bypass 
hinting inside bcache when bcache is under dm-crypt which Jens is picking 
up for 4.10:
  https://lkml.org/lkml/2016/12/6/607

Without assigning the ioprio before queuing to the en/decrypt queues, 
bcache isn't notified of the priority---and presumably neither is the IO 
scheduler.

The ioprio aware schedulers like CFQ and BFQ also benefit with more 
knowledge about the bio's when passing through dm-crypt.  It would be 
great if this can be accepted for 4.10, too.

--
Eric Wheeler

> 
> By assigning the ioprio to the bio before queuing to a workqueue, the
> original submitting task's io_context->ioprio setting can be retained
> through the life of the bio.  We only set the bio's ioprio in dm-crypt
> if not already set (by somewhere else, higher in the stack).
> 
> Signed-off-by: Eric Wheeler <dm-devel@linux.ewheeler.net>
> Cc: Mikulas Patocka <mpatocka@redhat.com>
> Cc: Alasdair Kergon <agk@redhat.com>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Shaohua Li <shli@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: stable@vger.kernel.org
> ---
>  block/bio.c           |  1 +
>  drivers/md/dm-crypt.c | 11 +++++++++--
>  include/linux/bio.h   | 23 +++++++++++++++++++++++
>  3 files changed, 33 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index db85c57..1a529ff 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -584,6 +584,7 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
>  	bio->bi_iter = bio_src->bi_iter;
>  	bio->bi_io_vec = bio_src->bi_io_vec;
>  
> +	bio_set_prio(bio, bio_prio(bio_src));
>  	bio_clone_blkcg_association(bio, bio_src);
>  }
>  EXPORT_SYMBOL(__bio_clone_fast);
> diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> index 9b99ee9..ea7e102 100644
> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c
> @@ -1133,6 +1133,7 @@ static void clone_init(struct dm_crypt_io *io, struct bio *clone)
>  	clone->bi_private = io;
>  	clone->bi_end_io  = crypt_endio;
>  	clone->bi_bdev    = cc->dev->bdev;
> +	bio_set_prio(clone, bio_prio(io->base_bio));
>  	bio_set_op_attrs(clone, bio_op(io->base_bio), bio_flags(io->base_bio));
>  }
>  
> @@ -2070,10 +2071,16 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
>  	io->ctx.req = (struct skcipher_request *)(io + 1);
>  
>  	if (bio_data_dir(io->base_bio) == READ) {
> -		if (kcryptd_io_read(io, GFP_NOWAIT))
> +		if (kcryptd_io_read(io, GFP_NOWAIT)) {
> +			if (!ioprio_valid(bio_prio(io->base_bio)))
> +				bio_set_task_prio(io->base_bio, current);
>  			kcryptd_queue_read(io);
> -	} else
> +		}
> +	} else {
> +		if (!ioprio_valid(bio_prio(io->base_bio)))
> +			bio_set_task_prio(io->base_bio, current);
>  		kcryptd_queue_crypt(io);
> +	}
>  
>  	return DM_MAPIO_SUBMITTED;
>  }
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 97cb48f..0b4f8bb 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -62,6 +62,29 @@
>  #define bio_sectors(bio)	((bio)->bi_iter.bi_size >> 9)
>  #define bio_end_sector(bio)	((bio)->bi_iter.bi_sector + bio_sectors((bio)))
>  
> +/* Set the bio's ioprio to that of the task's io_context->ioprio, if any.
> + * Always returns io_context->ioprio (or 0 if none); bio can be NULL.
> + */
> +static inline unsigned short bio_set_task_prio(
> +	struct bio *bio, struct task_struct *task)
> +{
> +	struct io_context *ioc;
> +	unsigned short ioprio = 0;
> +
> +	ioc = get_task_io_context(current, GFP_NOIO, NUMA_NO_NODE);
> +	if (ioc) {
> +		if (ioprio_valid(ioc->ioprio)) {
> +			ioprio = ioc->ioprio;
> +			put_io_context(ioc);
> +		}
> +
> +		if (bio != NULL && ioprio_valid(ioprio))
> +			bio_set_prio(bio, ioc->ioprio);
> +	}
> +
> +	return ioprio;
> +}
> +
>  /*
>   * Check whether this bio carries any data or not. A NULL bio is allowed.
>   */
> -- 
> 1.8.3.1
> 
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
> 
