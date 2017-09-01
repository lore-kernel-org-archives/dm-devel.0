From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH/rfc] dm: revise 'rescue' strategy for md->bs
 allocations
Date: Thu, 31 Aug 2017 22:38:09 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1708312233010.32309@file01.intranet.prod.int.rdu2.redhat.com>
References: <878ti0fefq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <878ti0fefq.fsf@notabene.neil.brown.name>
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
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 31 Aug 2017, NeilBrown wrote:

> 
> The md->bs bioset currently needs the BIOSET_NEED_RESCUER flag
> which I hope to deprecate.  It is currently needed because
> __split_and_process_bio() can potentially allocate from the
> bioset multiple times within the one make_request_fn context.
> Subsequent allocations can deadlock waiting for the bio returned
> by the first allocation to complete - but it is stuck on the
> current->bio_list list.
> 
> The bioset is also used in setup_clone() in dm-rq.c, but there a
> non-blocking (GFP_ATOMIC) allocation is used, so there is no risk of
> deadlock.
> 
> dm also provide rescuing for ->map() calls.  If a map call ever blocks,
> any bios already submitted with generic_make_request() will be passed to
> the bioset rescuer thread.
> 
> This patch unifies these two separate needs for rescuing bios into a
> single mechanism, and use the md->wq work queue to do the rescuing.
> 
> A blk_plug_cb is added to 'struct clone_info' so that it is available
> throughout the __split_and_process_bio() process.
> Prior to allocating from the bioset, or calling ->map(),
> dm_offload_check() is called to ensure that the blk_plug_cb is active.
> If either of these operation schedules, the callback is called,
> and any queued bios get passed to the wq.
> 
> Note that only current->bio_list[0] is offloaded.  current->bio_list[1]
> contains bios that were scheduled *before* the current one started, so

These bios need to be offloaded too, otherwise you re-introduce this 
deadlock: https://www.redhat.com/archives/dm-devel/2014-May/msg00089.html

Mikulas

> they must have been submitted from higher up the stack, and we cannot be
> waiting for them here.  Also, we now rescue *all* bios on the list as
> there is nothing to be gained by being more selective.
>
> This allows us to remove BIOSET_NEED_RESCUER when allocating this
> bioset.
> It also keeps all the mechanics of rescuing inside dm, so dm can
> be in full control.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
> 
> Hi,
>  I have only tested this lightly as I don't have any test infrastructure
>  for dm and don't know how to reproduce the expected deadlocks.
>  I'm keen to know your thoughts on this approach if you find a few spare
>  moment to have a look.
> 
> Thanks,
> NeilBrown
> 
>  
>  drivers/md/dm-core.h |  1 +
>  drivers/md/dm.c      | 99 ++++++++++++++++++++++++++--------------------------
>  2 files changed, 51 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
> index 24eddbdf2ab4..cb060dd6d3ca 100644
> --- a/drivers/md/dm-core.h
> +++ b/drivers/md/dm-core.h
> @@ -71,6 +71,7 @@ struct mapped_device {
>  	struct work_struct work;
>  	spinlock_t deferred_lock;
>  	struct bio_list deferred;
> +	struct bio_list rescued;
>  
>  	/*
>  	 * Event handling.
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 2edbcc2d7d3f..774dd71cb49a 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1134,65 +1134,63 @@ void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
>  }
>  EXPORT_SYMBOL_GPL(dm_remap_zone_report);
>  
> +struct clone_info {
> +	struct mapped_device *md;
> +	struct dm_table *map;
> +	struct bio *bio;
> +	struct dm_io *io;
> +	sector_t sector;
> +	unsigned sector_count;
> +	struct blk_plug plug;
> +	struct blk_plug_cb cb;
> +};
> +
>  /*
>   * Flush current->bio_list when the target map method blocks.
>   * This fixes deadlocks in snapshot and possibly in other targets.
>   */
> -struct dm_offload {
> -	struct blk_plug plug;
> -	struct blk_plug_cb cb;
> -};
>  
>  static void flush_current_bio_list(struct blk_plug_cb *cb, bool from_schedule)
>  {
> -	struct dm_offload *o = container_of(cb, struct dm_offload, cb);
> +	struct clone_info *ci = container_of(cb, struct clone_info, cb);
>  	struct bio_list list;
> -	struct bio *bio;
> -	int i;
>  
> -	INIT_LIST_HEAD(&o->cb.list);
> +	INIT_LIST_HEAD(&cb->list);
>  
> -	if (unlikely(!current->bio_list))
> +	if (unlikely(!current->bio_list || bio_list_empty(&current->bio_list[0])))
>  		return;
>  
> -	for (i = 0; i < 2; i++) {
> -		list = current->bio_list[i];
> -		bio_list_init(&current->bio_list[i]);
> -
> -		while ((bio = bio_list_pop(&list))) {
> -			struct bio_set *bs = bio->bi_pool;
> -			if (unlikely(!bs) || bs == fs_bio_set ||
> -			    !bs->rescue_workqueue) {
> -				bio_list_add(&current->bio_list[i], bio);
> -				continue;
> -			}
> +	list = current->bio_list[0];
> +	bio_list_init(&current->bio_list[0]);
> +	spin_lock(&ci->md->deferred_lock);
> +	bio_list_merge(&ci->md->rescued, &list);
> +	spin_unlock(&ci->md->deferred_lock);
> +	queue_work(ci->md->wq, &ci->md->work);
> +}
>  
> -			spin_lock(&bs->rescue_lock);
> -			bio_list_add(&bs->rescue_list, bio);
> -			queue_work(bs->rescue_workqueue, &bs->rescue_work);
> -			spin_unlock(&bs->rescue_lock);
> -		}
> -	}
> +static void dm_offload_start(struct clone_info *ci)
> +{
> +	blk_start_plug(&ci->plug);
> +	INIT_LIST_HEAD(&ci->cb.list);
> +	ci->cb.callback = flush_current_bio_list;
>  }
>  
> -static void dm_offload_start(struct dm_offload *o)
> +static void dm_offload_end(struct clone_info *ci)
>  {
> -	blk_start_plug(&o->plug);
> -	o->cb.callback = flush_current_bio_list;
> -	list_add(&o->cb.list, &current->plug->cb_list);
> +	list_del(&ci->cb.list);
> +	blk_finish_plug(&ci->plug);
>  }
>  
> -static void dm_offload_end(struct dm_offload *o)
> +static void dm_offload_check(struct clone_info *ci)
>  {
> -	list_del(&o->cb.list);
> -	blk_finish_plug(&o->plug);
> +	if (list_empty(&ci->cb.list))
> +		list_add(&ci->cb.list, &current->plug->cb_list);
>  }
>  
> -static void __map_bio(struct dm_target_io *tio)
> +static void __map_bio(struct clone_info *ci, struct dm_target_io *tio)
>  {
>  	int r;
>  	sector_t sector;
> -	struct dm_offload o;
>  	struct bio *clone = &tio->clone;
>  	struct dm_target *ti = tio->ti;
>  
> @@ -1206,9 +1204,8 @@ static void __map_bio(struct dm_target_io *tio)
>  	atomic_inc(&tio->io->io_count);
>  	sector = clone->bi_iter.bi_sector;
>  
> -	dm_offload_start(&o);
> +	dm_offload_check(ci);
>  	r = ti->type->map(ti, clone);
> -	dm_offload_end(&o);
>  
>  	switch (r) {
>  	case DM_MAPIO_SUBMITTED:
> @@ -1233,15 +1230,6 @@ static void __map_bio(struct dm_target_io *tio)
>  	}
>  }
>  
> -struct clone_info {
> -	struct mapped_device *md;
> -	struct dm_table *map;
> -	struct bio *bio;
> -	struct dm_io *io;
> -	sector_t sector;
> -	unsigned sector_count;
> -};
> -
>  static void bio_setup_sector(struct bio *bio, sector_t sector, unsigned len)
>  {
>  	bio->bi_iter.bi_sector = sector;
> @@ -1291,6 +1279,7 @@ static struct dm_target_io *alloc_tio(struct clone_info *ci,
>  	struct dm_target_io *tio;
>  	struct bio *clone;
>  
> +	dm_offload_check(ci);
>  	clone = bio_alloc_bioset(GFP_NOIO, 0, ci->md->bs);
>  	tio = container_of(clone, struct dm_target_io, clone);
>  
> @@ -1314,7 +1303,7 @@ static void __clone_and_map_simple_bio(struct clone_info *ci,
>  	if (len)
>  		bio_setup_sector(clone, ci->sector, *len);
>  
> -	__map_bio(tio);
> +	__map_bio(ci, tio);
>  }
>  
>  static void __send_duplicate_bios(struct clone_info *ci, struct dm_target *ti,
> @@ -1361,7 +1350,7 @@ static int __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti,
>  			free_tio(tio);
>  			break;
>  		}
> -		__map_bio(tio);
> +		__map_bio(ci, tio);
>  	}
>  
>  	return r;
> @@ -1493,6 +1482,7 @@ static void __split_and_process_bio(struct mapped_device *md,
>  		bio_io_error(bio);
>  		return;
>  	}
> +	dm_offload_start(&ci);
>  
>  	ci.map = map;
>  	ci.md = md;
> @@ -1521,6 +1511,7 @@ static void __split_and_process_bio(struct mapped_device *md,
>  		while (ci.sector_count && !error)
>  			error = __split_and_process_non_flush(&ci);
>  	}
> +	dm_offload_end(&ci);
>  
>  	/* drop the extra reference count */
>  	dec_pending(ci.io, error);
> @@ -2248,6 +2239,16 @@ static void dm_wq_work(struct work_struct *work)
>  	int srcu_idx;
>  	struct dm_table *map;
>  
> +	if (!bio_list_empty(&md->rescued)) {
> +		struct bio_list list;
> +		spin_lock_irq(&md->deferred_lock);
> +		list = md->deferred;
> +		bio_list_init(&md->deferred);
> +		spin_unlock_irq(&md->deferred_lock);
> +		while ((c = bio_list_pop(&md->deferred)) != NULL)
> +			generic_make_request(c);
> +	}
> +
>  	map = dm_get_live_table(md, &srcu_idx);
>  
>  	while (!test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) {
> @@ -2796,7 +2797,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, enum dm_qu
>  		BUG();
>  	}
>  
> -	pools->bs = bioset_create(pool_size, front_pad, BIOSET_NEED_RESCUER);
> +	pools->bs = bioset_create(pool_size, front_pad, 0);
>  	if (!pools->bs)
>  		goto out;
>  
> -- 
> 2.14.0.rc0.dirty
> 
> 
