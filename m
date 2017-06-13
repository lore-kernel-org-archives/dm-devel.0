From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: Re: rebased dm-zoned changes on jens/for-4.13/block
 [was: Re: dm-zoned: Fix overflow in exposed capacity]
Date: Tue, 13 Jun 2017 16:30:51 -0700
Message-ID: <60833e67-eeac-023d-93d8-8c428263cff6@wdc.com>
References: <20170609040605.4340-1-damien.lemoal@wdc.com>
	<20170609120339.GB11110@redhat.com> <20170612212816.GA83518@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170612212816.GA83518@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Mike,

Thank you. I just posted a follow up patch with a fix for a
reference-after-free (see below). I tested without problems.

On 6/12/17 14:28, Mike Snitzer wrote:
> On Fri, Jun 09 2017 at  8:03P -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>  
>> I've pushed to linux-dm.git's 'for-next' to get more test coverage;
>> doesn't mean that I consider dm-zoned's review complete.
> 
> I rebased ontop of Jens' latest 'for-4.13/block' to pull in all of
> Christoph's error code rework.
> 
> I had to fix various commits in your dm-zoned series.  Please
> review/retest dm-zoned to verify I didn't break anything.
> 
> Thanks,
> Mike
> 
> FYI, here is the incremental diff for the dm-zoned commit:
> 
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Mon, 12 Jun 2017 16:44:50 -0400
> Subject: [PATCH] dm zoned: switch over to 4.13 error codes
> 
> ---
>  drivers/md/dm-zoned-metadata.c |  6 +++---
>  drivers/md/dm-zoned-target.c   | 37 ++++++++++++++++++-------------------
>  drivers/md/dm-zoned.h          |  2 +-
>  3 files changed, 22 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-metadata.c b/drivers/md/dm-zoned-metadata.c
> index 4618441c..b8f7d1d 100644
> --- a/drivers/md/dm-zoned-metadata.c
> +++ b/drivers/md/dm-zoned-metadata.c
> @@ -691,14 +691,14 @@ static int dmz_log_dirty_mblocks(struct dmz_metadata *zmd,
>  /*
>   * Flush dirty metadata blocks.
>   */
> -int dmz_flush_metadata(struct dmz_metadata *zmd)
> +blk_status_t dmz_flush_metadata(struct dmz_metadata *zmd)
>  {
>  	struct dmz_mblock *mblk;
>  	struct list_head write_list;
>  	int ret;
>  
>  	if (WARN_ON(!zmd))
> -		return 0;
> +		return BLK_STS_OK;
>  
>  	INIT_LIST_HEAD(&write_list);
>  
> @@ -769,7 +769,7 @@ int dmz_flush_metadata(struct dmz_metadata *zmd)
>  	dmz_unlock_flush(zmd);
>  	up_write(&zmd->mblk_sem);
>  
> -	return ret;
> +	return errno_to_blk_status(ret);
>  }

I changed this back to returning an errno and do the
errno_to_blk_status() conversion when calling dm_zoned_endio(). Doing
so, all other functions in dm-zoned-target.c returning an errno can be
left as is.

>  /*
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index 54055f4..c9fdd02 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -20,7 +20,7 @@ struct dmz_bioctx {
>  	struct dm_zone		*zone;
>  	struct bio		*bio;
>  	atomic_t		ref;
> -	int			error;
> +	blk_status_t		error;
>  };
>  
>  /*
> @@ -74,12 +74,12 @@ struct dmz_target {
>  /*
>   * Target BIO completion.
>   */
> -static inline void dmz_bio_endio(struct bio *bio, int err)
> +static inline void dmz_bio_endio(struct bio *bio, blk_status_t *error)
>  {
>  	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
>  
> -	if (bioctx->error == 0 && err != 0)
> -		bioctx->error = err;
> +	if (bioctx->error == BLK_STS_OK && *error)
> +		bioctx->error = *error;
>  	bio_endio(bio);
>  }

I changed this to "blk_status_t error". No need for a pointer.

>  
> @@ -90,10 +90,9 @@ static inline void dmz_bio_endio(struct bio *bio, int err)
>  static void dmz_read_bio_end_io(struct bio *bio)
>  {
>  	struct dmz_bioctx *bioctx = bio->bi_private;
> -	int err = bio->bi_error;
>  
>  	bio_put(bio);
> -	dmz_bio_endio(bioctx->bio, err);
> +	dmz_bio_endio(bioctx->bio, &bio->bi_status);
>  }

There is a reference after free here. So we need to keep the on stack
status.

>  
>  /*
> @@ -393,7 +392,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
>  	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
>  	struct dmz_metadata *zmd = dmz->metadata;
>  	struct dm_zone *zone;
> -	int ret;
> +	blk_status_t ret;
>  
>  	/*
>  	 * Write may trigger a zone allocation. So make sure the
> @@ -436,7 +435,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
>  	default:
>  		dmz_dev_err(dmz->dev, "Unsupported BIO operation 0x%x",
>  			    bio_op(bio));
> -		ret = -EIO;
> +		ret = BLK_STS_IOERR;
>  	}

The conversion to blk_status_t is done when calling dm_zoned_endio()
after this. So I reverted this change.

>  
>  	/*
> @@ -446,7 +445,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
>  	if (zone)
>  		dmz_put_chunk_mapping(zmd, zone);
>  out:
> -	dmz_bio_endio(bio, ret);
> +	dmz_bio_endio(bio, &ret);
>  
>  	dmz_unlock_metadata(zmd);
>  }
> @@ -504,7 +503,7 @@ static void dmz_flush_work(struct work_struct *work)
>  {
>  	struct dmz_target *dmz = container_of(work, struct dmz_target, flush_work.work);
>  	struct bio *bio;
> -	int ret;
> +	blk_status_t ret;
>  
>  	/* Flush dirty metadata blocks */
>  	ret = dmz_flush_metadata(dmz->metadata);
> @@ -518,7 +517,7 @@ static void dmz_flush_work(struct work_struct *work)
>  		if (!bio)
>  			break;
>  
> -		dmz_bio_endio(bio, ret);
> +		dmz_bio_endio(bio, &ret);
>  	}
>  
>  	queue_delayed_work(dmz->flush_wq, &dmz->flush_work, DMZ_FLUSH_PERIOD);
> @@ -593,14 +592,14 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
>  
>  	/* The BIO should be block aligned */
>  	if ((nr_sectors & DMZ_BLOCK_SECTORS_MASK) || (sector & DMZ_BLOCK_SECTORS_MASK))
> -		return -EIO;
> +		return DM_MAPIO_KILL;
>  
>  	/* Initialize the BIO context */
>  	bioctx->target = dmz;
>  	bioctx->zone = NULL;
>  	bioctx->bio = bio;
>  	atomic_set(&bioctx->ref, 1);
> -	bioctx->error = 0;
> +	bioctx->error = BLK_STS_OK;
>  
>  	/* Set the BIO pending in the flush list */
>  	if (bio_op(bio) == REQ_OP_FLUSH || (!nr_sectors && bio_op(bio) == REQ_OP_WRITE)) {
> @@ -626,30 +625,30 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
>  /*
>   * Completed target BIO processing.
>   */
> -static int dmz_end_io(struct dm_target *ti, struct bio *bio, int err)
> +static int dmz_end_io(struct dm_target *ti, struct bio *bio, blk_status_t *error)
>  {
>  	struct dmz_bioctx *bioctx = dm_per_bio_data(bio, sizeof(struct dmz_bioctx));
>  
> -	if (bioctx->error == 0 && err != 0)
> -		bioctx->error = err;
> +	if (bioctx->error == BLK_STS_OK && *error)
> +		bioctx->error = *error;
>  
>  	if (!atomic_dec_and_test(&bioctx->ref))
>  		return DM_ENDIO_INCOMPLETE;
>  
>  	/* Done */
> -	bio->bi_error = bioctx->error;
> +	bio->bi_status = bioctx->error;
>  
>  	if (bioctx->zone) {
>  		struct dm_zone *zone = bioctx->zone;
>  
> -		if (err && bio_op(bio) == REQ_OP_WRITE) {
> +		if (*error && bio_op(bio) == REQ_OP_WRITE) {
>  			if (dmz_is_seq(zone))
>  				set_bit(DMZ_SEQ_WRITE_ERR, &zone->flags);
>  		}
>  		dmz_deactivate_zone(zone);
>  	}
>  
> -	return bioctx->error;
> +	return DM_ENDIO_DONE;
>  }
>  
>  /*
> diff --git a/drivers/md/dm-zoned.h b/drivers/md/dm-zoned.h
> index 12419f0..76ebcf8 100644
> --- a/drivers/md/dm-zoned.h
> +++ b/drivers/md/dm-zoned.h
> @@ -169,7 +169,7 @@ void dmz_lock_metadata(struct dmz_metadata *zmd);
>  void dmz_unlock_metadata(struct dmz_metadata *zmd);
>  void dmz_lock_flush(struct dmz_metadata *zmd);
>  void dmz_unlock_flush(struct dmz_metadata *zmd);
> -int dmz_flush_metadata(struct dmz_metadata *zmd);
> +blk_status_t dmz_flush_metadata(struct dmz_metadata *zmd);
>  
>  unsigned int dmz_id(struct dmz_metadata *zmd, struct dm_zone *zone);
>  sector_t dmz_start_sect(struct dmz_metadata *zmd, struct dm_zone *zone);
> 

Best regards.

-- 
Damien Le Moal,
Western Digital Research
