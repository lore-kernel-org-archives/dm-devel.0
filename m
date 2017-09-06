From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH/rfc] dm: revise 'rescue' strategy for md->bs
 allocations
Date: Wed, 6 Sep 2017 18:57:47 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1709061853240.19771@file01.intranet.prod.int.rdu2.redhat.com>
References: <878ti0fefq.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1708312233010.32309@file01.intranet.prod.int.rdu2.redhat.com>
	<87inh3dqp3.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1709011947200.22293@file01.intranet.prod.int.rdu2.redhat.com>
	<87a82be2zf.fsf@notabene.neil.brown.name>
	<alpine.LRH.2.02.1709041249100.9535@file01.intranet.prod.int.rdu2.redhat.com>
	<874lsgd84f.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <874lsgd84f.fsf@notabene.neil.brown.name>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: NeilBrown <neilb@suse.com>
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids



On Wed, 6 Sep 2017, NeilBrown wrote:

> Thanks for the extra explanation.  I've thought some more about this I can
> see a way forward that I am comfortable with.  Please let me know what
> you think.
> I haven't tested this patch yet, but I believe that applying it first will
> clear the way for my other patch to work without reintroducing
> deadlocks.
> 
> Thanks,
> NeilBrown

What's the purpose of this patch? If the current code that offloads bios 
on current->bio_list to a rescue thread works, why do you want to change 
it?

Mikulas

> From: NeilBrown <neilb@suse.com>
> Date: Wed, 6 Sep 2017 09:14:52 +1000
> Subject: [PATCH] dm: ensure bio submission follows a depth-first tree walk.
> 
> A dm device can, in general, represent a tree of targets,
> each of which handles a sub-range of the range of blocks handled
> by the parent.
> 
> The bio sequencing managed by generic_make_request() requires that bios
> are generated and handled in a depth-first manner.  Each call to a
> make_request_fn() may submit bios to a single member device, and may
> submit bios for a reduced region of the same device as the
> make_request_fn.
> 
> In particular, any bios submitted to member devices must be expected to
> be processed in order, so a later one must never wait for an earlier
> one.
> 
> This ordering is usually achieved by using bio_split() to reduce a bio
> to a size that can be completely handled by one target, and resubmitting
> the remainder to the originating device. bio_queue_split() shows the canonical
> approach.
> 
> dm doesn't follow this approach, largely because it has needed to split
> bios since long before bio_split() was available.  It currently can
> submit bios to separate targets within the one dm_make_request() call.
> Dependencies between these targets, as can happen with dm-snap, can
> cause deadlocks if either bios gets stuck behind the other in the queues
> managed by generic_make_request().  This requires the 'rescue'
> functionality provided by dm_offload*.
> 
> Some of this requirement can be removed by changing the order of bio
> submission to follow the canonical approach.  That is, if dm finds that
> it needs to split a bio, the remainder should be sent to
> generic_make_request() rather than being handled immediately.  This delays
> the handling until the first part is completely processed, so the
> deadlock problems do not occur.
> 
> __split_and_process_bio() can be called both from dm_make_request() and
> from dm_wq_work().  When called from dm_wq_work() the current approach
> is perfectly satisfactory as each bio will be processed immediately.
> When called from dm_make_request, current->bio_list will be non-NULL,
> and in this case it is best to create a separate "clone" bio for the
> remainder.
> 
> To provide the clone bio when splitting, we use q->bio_split().  This
> was previously being freed to avoid having excess rescuer threads.  As
> bio_split bio sets no longer create rescuer threads, there is little
> cost and much gain from leaving the ->bio_split bio set in place.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/md/dm.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index d669fddd9290..81395f7550c0 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1007,7 +1007,7 @@ static void dm_dax_flush(struct dax_device *dax_dev, pgoff_t pgoff, void *addr,
>  
>  /*
>   * A target may call dm_accept_partial_bio only from the map routine.  It is
> - * allowed for all bio types except REQ_PREFLUSH.
> + * allowed for all bio types except REQ_PREFLUSH and REQ_OP_ZONE_RESET.
>   *
>   * dm_accept_partial_bio informs the dm that the target only wants to process
>   * additional n_sectors sectors of the bio and the rest of the data should be
> @@ -1508,8 +1508,21 @@ static void __split_and_process_bio(struct mapped_device *md,
>  	} else {
>  		ci.bio = bio;
>  		ci.sector_count = bio_sectors(bio);
> -		while (ci.sector_count && !error)
> +		while (ci.sector_count && !error) {
>  			error = __split_and_process_non_flush(&ci);
> +			if (current->bio_list && ci.sector_count && !error) {
> +				/* Remainder must be passed to generic_make_request()
> +				 * so that it gets handled *after* bios already submitted
> +				 * have been completely processed.
> +				 */
> +				struct bio *b = bio_clone_bioset(bio, GFP_NOIO,
> +								 md->queue->bio_split);
> +				bio_advance(b, (bio_sectors(b) - ci.sector_count) << 9);
> +				bio_chain(b, bio);
> +				generic_make_request(b);
> +				break;
> +			}
> +		}
>  	}
>  
>  	/* drop the extra reference count */
> @@ -1520,8 +1533,8 @@ static void __split_and_process_bio(struct mapped_device *md,
>   *---------------------------------------------------------------*/
>  
>  /*
> - * The request function that just remaps the bio built up by
> - * dm_merge_bvec.
> + * The request function that remaps the bio to one target and
> + * splits off any remainder.
>   */
>  static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
>  {
> @@ -2056,12 +2069,6 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
>  	case DM_TYPE_DAX_BIO_BASED:
>  		dm_init_normal_md_queue(md);
>  		blk_queue_make_request(md->queue, dm_make_request);
> -		/*
> -		 * DM handles splitting bios as needed.  Free the bio_split bioset
> -		 * since it won't be used (saves 1 process per bio-based DM device).
> -		 */
> -		bioset_free(md->queue->bio_split);
> -		md->queue->bio_split = NULL;
>  
>  		if (type == DM_TYPE_DAX_BIO_BASED)
>  			queue_flag_set_unlocked(QUEUE_FLAG_DAX, md->queue);
> -- 
> 2.14.0
> 
> 
