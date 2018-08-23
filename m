From: Damien Le Moal <Damien.LeMoal@wdc.com>
Subject: Re: [PATCH 3/3] dm zoned: target: use refcount_t for dm
 zoned reference counters
Date: Thu, 23 Aug 2018 22:12:28 +0000
Message-ID: <BN3PR0401MB16400F7E04FF3E7AF51E1F06E7370@BN3PR0401MB1640.namprd04.prod.outlook.com>
References: <20180823173557.19665-1-jpittman@redhat.com>
	<20180823173557.19665-4-jpittman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: John Pittman <jpittman@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

John,

On 2018/08/23 10:37, John Pittman wrote:
> The API surrounding refcount_t should be used in place of atomic_t
> when variables are being used as reference counters.  This API can
> prevent issues such as counter overflows and use-after-free
> conditions.  Within the dm zoned target stack, the atomic_t API is
> used for bioctx->ref and cw->refcount.  Change these to use
> refcount_t, avoiding the issues mentioned.
> 
> Signed-off-by: John Pittman <jpittman@redhat.com>
> ---
>  drivers/md/dm-zoned-target.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm-zoned-target.c b/drivers/md/dm-zoned-target.c
> index a44183ff4be0..fa36825c1eff 100644
> --- a/drivers/md/dm-zoned-target.c
> +++ b/drivers/md/dm-zoned-target.c
> @@ -19,7 +19,7 @@ struct dmz_bioctx {
>  	struct dmz_target	*target;
>  	struct dm_zone		*zone;
>  	struct bio		*bio;
> -	atomic_t		ref;
> +	refcount_t		ref;
>  	blk_status_t		status;
>  };
>  
> @@ -28,7 +28,7 @@ struct dmz_bioctx {
>   */
>  struct dm_chunk_work {
>  	struct work_struct	work;
> -	atomic_t		refcount;
> +	refcount_t		refcount;
>  	struct dmz_target	*target;
>  	unsigned int		chunk;
>  	struct bio_list		bio_list;
> @@ -115,7 +115,7 @@ static int dmz_submit_read_bio(struct dmz_target *dmz, struct dm_zone *zone,
>  	if (nr_blocks == dmz_bio_blocks(bio)) {
>  		/* Setup and submit the BIO */
>  		bio->bi_iter.bi_sector = sector;
> -		atomic_inc(&bioctx->ref);
> +		refcount_inc(&bioctx->ref);
>  		generic_make_request(bio);
>  		return 0;
>  	}
> @@ -134,7 +134,7 @@ static int dmz_submit_read_bio(struct dmz_target *dmz, struct dm_zone *zone,
>  	bio_advance(bio, clone->bi_iter.bi_size);
>  
>  	/* Submit the clone */
> -	atomic_inc(&bioctx->ref);
> +	refcount_inc(&bioctx->ref);
>  	generic_make_request(clone);
>  
>  	return 0;
> @@ -240,7 +240,7 @@ static void dmz_submit_write_bio(struct dmz_target *dmz, struct dm_zone *zone,
>  	/* Setup and submit the BIO */
>  	bio_set_dev(bio, dmz->dev->bdev);
>  	bio->bi_iter.bi_sector = dmz_start_sect(dmz->metadata, zone) + dmz_blk2sect(chunk_block);
> -	atomic_inc(&bioctx->ref);
> +	refcount_inc(&bioctx->ref);
>  	generic_make_request(bio);
>  
>  	if (dmz_is_seq(zone))
> @@ -456,7 +456,7 @@ static void dmz_handle_bio(struct dmz_target *dmz, struct dm_chunk_work *cw,
>   */
>  static inline void dmz_get_chunk_work(struct dm_chunk_work *cw)
>  {
> -	atomic_inc(&cw->refcount);
> +	refcount_inc(&cw->refcount);
>  }
>  
>  /*
> @@ -465,7 +465,7 @@ static inline void dmz_get_chunk_work(struct dm_chunk_work *cw)
>   */
>  static void dmz_put_chunk_work(struct dm_chunk_work *cw)
>  {
> -	if (atomic_dec_and_test(&cw->refcount)) {
> +	if (refcount_dec_and_test(&cw->refcount)) {
>  		WARN_ON(!bio_list_empty(&cw->bio_list));
>  		radix_tree_delete(&cw->target->chunk_rxtree, cw->chunk);
>  		kfree(cw);
> @@ -546,7 +546,7 @@ static void dmz_queue_chunk_work(struct dmz_target *dmz, struct bio *bio)
>  			goto out;
>  
>  		INIT_WORK(&cw->work, dmz_chunk_work);
> -		atomic_set(&cw->refcount, 0);
> +		refcount_set(&cw->refcount, 0);
>  		cw->target = dmz;
>  		cw->chunk = chunk;
>  		bio_list_init(&cw->bio_list);
> @@ -599,7 +599,7 @@ static int dmz_map(struct dm_target *ti, struct bio *bio)
>  	bioctx->target = dmz;
>  	bioctx->zone = NULL;
>  	bioctx->bio = bio;
> -	atomic_set(&bioctx->ref, 1);
> +	refcount_set(&bioctx->ref, 1);
>  	bioctx->status = BLK_STS_OK;
>  
>  	/* Set the BIO pending in the flush list */
> @@ -633,7 +633,7 @@ static int dmz_end_io(struct dm_target *ti, struct bio *bio, blk_status_t *error
>  	if (bioctx->status == BLK_STS_OK && *error)
>  		bioctx->status = *error;
>  
> -	if (!atomic_dec_and_test(&bioctx->ref))
> +	if (!refcount_dec_and_test(&bioctx->ref))
>  		return DM_ENDIO_INCOMPLETE;
>  
>  	/* Done */
> 

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Tested-by: Damien Le Moal <damien.lemoal@wdc.com>

Thanks !

-- 
Damien Le Moal
Western Digital Research
