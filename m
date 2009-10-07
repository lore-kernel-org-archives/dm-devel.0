From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 2/4] dm-snapshot-refactor-associations
Date: Wed, 7 Oct 2009 14:24:33 -0400
Message-ID: <20091007182433.GB29197@redhat.com>
References: <1254769231-12053-1-git-send-email-snitzer@redhat.com>
	<1254769231-12053-3-git-send-email-snitzer@redhat.com>
	<F284D478-E4DA-4410-AF2B-5343FC4246BB@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <F284D478-E4DA-4410-AF2B-5343FC4246BB@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

On Wed, Oct 07 2009 at  1:38pm -0400,
Jonathan Brassow <jbrassow@redhat.com> wrote:

> If this is really something that we have to do, then fine.  However, it 
> appears that you are doing this to pull out 'ti' and 'cow'... things that 
> are separate by structure from the underlying exception store... which is 
> ultimately what you want to hand over.  It seems to me that there is 
> probably a better/cleaner way to do this, while simultaneously leaving 
> 'ti' and 'cow' in their current place.

Yes, both 'ti' and 'cow' are seperate structures within the exception store.
Yes, we want to handover the exception store itself (but keeping 'ti' and
'cow' fixed).

So you're saying have the handover be:
1) swap the 'complete' exception_table
2) swap the 'cow' and 'ti' in the 2 exception stores
3) swap the exception stores

Something like the following?:

static void handover_exceptions(struct dm_snapshot *old,
                                struct dm_snapshot *new)
{
        union {
                struct exception_table table_swap;
                struct dm_target *ti_swap;
                struct dm_dev *cow_swap;
                struct dm_exception_store *store_swap;
        } u;

        u.table_swap = new->complete;
        new->complete = old->complete;
        old->complete = u.table_swap;

        u.ti_swap = new->store->ti;
        new->store->ti = old->store->ti;
        old->store->ti = u.ti_swap;

        u.cow_swap = new->store->cow;
        new->store->cow = old->store->cow;
        old->store->cow = u.cow_swap;

        u.store_swap = new->store;
        new->store = old->store;
        old->store = u.store_swap;

        new->store->snap = new;
        old->store->snap = old;

        old->active = 0;
        new->handover = 0;
}

Mike


> On Oct 5, 2009, at 2:00 PM, Mike Snitzer wrote:
>
>> Refactor associations between dm_snapshot and dm_exception_store
>>
>> Commit 71fab00a6bef7fb53119271a8abdbaf40970d28a ("dm snapshot: remove
>> dm_snap header use") reflects the  direction Jon Brassow refactored  
>> the
>> dm-exception-store.c code most recently.
>>
>> Unfortunately that refactoring prevented the handover of snapshot
>> exceptions from being possible.  Exception handover's purpose is to  
>> move
>> the exception store from one target to the other.  During exception
>> handover (via snapshot-merge) the user calls contructor on the new
>> target, then suspends the old target, than resumes the new target and
>> then destroys the old target.
>>
>> So the exception store MUST NOT have pointers to things that are
>> target-specific.  So struct dm_exception_store shouldn't reference  
>> these
>> two: 'struct dm_target *ti' and 'struct dm_dev *cow'
>>
>> Because both change during table reload.
>>
>> Changes include:
>> - pulls the dm_get_device/dm_put_device for the cow device out of
>>  dm-exception-store.c and in to dm-snap.c
>> - readds 'struct dm_snapshot' to 'struct dm_exception_store'
>> - 'struct dm_snapshot' now has the 'cow' and 'ti' members that
>>  'struct dm_exception_store' did.
>> - adds dm_snapshot as an arg to the dm_exception_store_create() ABI
>> - exports dm_snap_get_cow() from dm-snap.c
>>
>> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
>> Cc: Jonathan Brassow <jbrassow@redhat.com>
>> Cc: Mikulas Patocka <mpatocka@redhat.com>
>> ---
>> drivers/md/dm-exception-store.c |   31 ++++++----------
>> drivers/md/dm-exception-store.h |    8 +++--
>> drivers/md/dm-snap-persistent.c |   11 +++---
>> drivers/md/dm-snap-transient.c  |    6 ++--
>> drivers/md/dm-snap.c            |   72 +++++++++++++++++++++++++ 
>> +-------------
>> 5 files changed, 74 insertions(+), 54 deletions(-)
>>
>> diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm- 
>> exception-store.c
>> index 4cbf319..37596d9 100644
>> --- a/drivers/md/dm-exception-store.c
>> +++ b/drivers/md/dm-exception-store.c
>> @@ -172,7 +172,9 @@ int dm_exception_store_set_chunk_size(struct  
>> dm_exception_store *store,
>> 	}
>>
>> 	/* Validate the chunk size against the device block size */
>> -	if (chunk_size % (bdev_logical_block_size(store->cow->bdev) >> 9)) {
>> +	if (chunk_size %
>> +	    (bdev_logical_block_size(dm_snap_get_cow(store->snap)->
>> +				     bdev) >> 9)) {
>> 		*error = "Chunk size is not a multiple of device blocksize";
>> 		return -EINVAL;
>> 	}
>> @@ -190,6 +192,7 @@ int dm_exception_store_set_chunk_size(struct  
>> dm_exception_store *store,
>> }
>>
>> int dm_exception_store_create(struct dm_target *ti, int argc, char  
>> **argv,
>> +			      struct dm_snapshot *snap,
>> 			      unsigned *args_used,
>> 			      struct dm_exception_store **store)
>> {
>> @@ -198,7 +201,7 @@ int dm_exception_store_create(struct dm_target  
>> *ti, int argc, char **argv,
>> 	struct dm_exception_store *tmp_store;
>> 	char persistent;
>>
>> -	if (argc < 3) {
>> +	if (argc < 2) {
>> 		ti->error = "Insufficient exception store arguments";
>> 		return -EINVAL;
>> 	}
>> @@ -209,7 +212,7 @@ int dm_exception_store_create(struct dm_target  
>> *ti, int argc, char **argv,
>> 		return -ENOMEM;
>> 	}
>>
>> -	persistent = toupper(*argv[1]);
>> +	persistent = toupper(*argv[0]);
>> 	if (persistent == 'P')
>> 		type = get_type("P");
>> 	else if (persistent == 'N')
>> @@ -226,32 +229,23 @@ int dm_exception_store_create(struct dm_target  
>> *ti, int argc, char **argv,
>> 	}
>>
>> 	tmp_store->type = type;
>> -	tmp_store->ti = ti;
>> +	tmp_store->snap = snap;
>>
>> -	r = dm_get_device(ti, argv[0], 0, 0,
>> -			  FMODE_READ | FMODE_WRITE, &tmp_store->cow);
>> -	if (r) {
>> -		ti->error = "Cannot get COW device";
>> -		goto bad_cow;
>> -	}
>> -
>> -	r = set_chunk_size(tmp_store, argv[2], &ti->error);
>> +	r = set_chunk_size(tmp_store, argv[1], &ti->error);
>> 	if (r)
>> -		goto bad_cow;
>> +		goto bad;
>>
>> 	r = type->ctr(tmp_store, 0, NULL);
>> 	if (r) {
>> 		ti->error = "Exception store type constructor failed";
>> -		goto bad_ctr;
>> +		goto bad;
>> 	}
>>
>> -	*args_used = 3;
>> +	*args_used = 2;
>> 	*store = tmp_store;
>> 	return 0;
>>
>> -bad_ctr:
>> -	dm_put_device(ti, tmp_store->cow);
>> -bad_cow:
>> +bad:
>> 	put_type(type);
>> bad_type:
>> 	kfree(tmp_store);
>> @@ -262,7 +256,6 @@ EXPORT_SYMBOL(dm_exception_store_create);
>> void dm_exception_store_destroy(struct dm_exception_store *store)
>> {
>> 	store->type->dtr(store);
>> -	dm_put_device(store->ti, store->cow);
>> 	put_type(store->type);
>> 	kfree(store);
>> }
>> diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm- 
>> exception-store.h
>> index 5f9315b..4e8086f 100644
>> --- a/drivers/md/dm-exception-store.h
>> +++ b/drivers/md/dm-exception-store.h
>> @@ -94,11 +94,12 @@ struct dm_exception_store_type {
>> 	struct list_head list;
>> };
>>
>> +struct dm_snapshot;
>> +struct dm_dev *dm_snap_get_cow(struct dm_snapshot *);
>> +
>> struct dm_exception_store {
>> 	struct dm_exception_store_type *type;
>> -	struct dm_target *ti;
>> -
>> -	struct dm_dev *cow;
>> +	struct dm_snapshot *snap;
>>
>> 	/* Size of data blocks saved - must be a power of 2 */
>> 	unsigned chunk_size;
>> @@ -173,6 +174,7 @@ int dm_exception_store_set_chunk_size(struct  
>> dm_exception_store *store,
>> 				      char **error);
>>
>> int dm_exception_store_create(struct dm_target *ti, int argc, char  
>> **argv,
>> +			      struct dm_snapshot *snap,
>> 			      unsigned *args_used,
>> 			      struct dm_exception_store **store);
>> void dm_exception_store_destroy(struct dm_exception_store *store);
>> diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap- 
>> persistent.c
>> index 7e855fb..746602b 100644
>> --- a/drivers/md/dm-snap-persistent.c
>> +++ b/drivers/md/dm-snap-persistent.c
>> @@ -214,7 +214,7 @@ static int chunk_io(struct pstore *ps, void *area, 
>> chunk_t chunk, int rw,
>> 		    int metadata)
>> {
>> 	struct dm_io_region where = {
>> -		.bdev = ps->store->cow->bdev,
>> +		.bdev = dm_snap_get_cow(ps->store->snap)->bdev,
>> 		.sector = ps->store->chunk_size * chunk,
>> 		.count = ps->store->chunk_size,
>> 	};
>> @@ -294,7 +294,8 @@ static int read_header(struct pstore *ps, int  
>> *new_snapshot)
>> 	 */
>> 	if (!ps->store->chunk_size) {
>> 		ps->store->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
>> -		    bdev_logical_block_size(ps->store->cow->bdev) >> 9);
>> +		    bdev_logical_block_size(dm_snap_get_cow(ps->store->snap)->
>> +					    bdev) >> 9);
>> 		ps->store->chunk_mask = ps->store->chunk_size - 1;
>> 		ps->store->chunk_shift = ffs(ps->store->chunk_size) - 1;
>> 		chunk_size_supplied = 0;
>> @@ -493,7 +494,7 @@ static void persistent_fraction_full(struct  
>> dm_exception_store *store,
>> 				     sector_t *numerator, sector_t *denominator)
>> {
>> 	*numerator = get_info(store)->next_free * store->chunk_size;
>> -	*denominator = get_dev_size(store->cow->bdev);
>> +	*denominator = get_dev_size(dm_snap_get_cow(store->snap)->bdev);
>> }
>>
>> static void persistent_dtr(struct dm_exception_store *store)
>> @@ -585,7 +586,7 @@ static int persistent_prepare_exception(struct  
>> dm_exception_store *store,
>> 	struct pstore *ps = get_info(store);
>> 	uint32_t stride;
>> 	chunk_t next_free;
>> -	sector_t size = get_dev_size(store->cow->bdev);
>> +	sector_t size = get_dev_size(dm_snap_get_cow(store->snap)->bdev);
>>
>> 	/* Is there enough room ? */
>> 	if (size < ((ps->next_free + 1) * store->chunk_size))
>> @@ -722,7 +723,7 @@ static unsigned persistent_status(struct  
>> dm_exception_store *store,
>> 	case STATUSTYPE_INFO:
>> 		break;
>> 	case STATUSTYPE_TABLE:
>> -		DMEMIT(" %s P %llu", store->cow->name,
>> +		DMEMIT(" %s P %llu", dm_snap_get_cow(store->snap)->name,
>> 		       (unsigned long long)store->chunk_size);
>> 	}
>>
>> diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap- 
>> transient.c
>> index cde5aa5..3d9fd91 100644
>> --- a/drivers/md/dm-snap-transient.c
>> +++ b/drivers/md/dm-snap-transient.c
>> @@ -39,7 +39,7 @@ static int transient_prepare_exception(struct  
>> dm_exception_store *store,
>> 				       struct dm_snap_exception *e)
>> {
>> 	struct transient_c *tc = store->context;
>> -	sector_t size = get_dev_size(store->cow->bdev);
>> +	sector_t size = get_dev_size(dm_snap_get_cow(store->snap)->bdev);
>>
>> 	if (size < (tc->next_free + store->chunk_size))
>> 		return -1;
>> @@ -63,7 +63,7 @@ static void transient_fraction_full(struct  
>> dm_exception_store *store,
>> 				    sector_t *numerator, sector_t *denominator)
>> {
>> 	*numerator = ((struct transient_c *) store->context)->next_free;
>> -	*denominator = get_dev_size(store->cow->bdev);
>> +	*denominator = get_dev_size(dm_snap_get_cow(store->snap)->bdev);
>> }
>>
>> static int transient_ctr(struct dm_exception_store *store,
>> @@ -91,7 +91,7 @@ static unsigned transient_status(struct  
>> dm_exception_store *store,
>> 	case STATUSTYPE_INFO:
>> 		break;
>> 	case STATUSTYPE_TABLE:
>> -		DMEMIT(" %s N %llu", store->cow->name,
>> +		DMEMIT(" %s N %llu", dm_snap_get_cow(store->snap)->name,
>> 		       (unsigned long long)store->chunk_size);
>> 	}
>>
>> diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
>> index b23decb..bdcbfc8 100644
>> --- a/drivers/md/dm-snap.c
>> +++ b/drivers/md/dm-snap.c
>> @@ -59,6 +59,9 @@ struct dm_snapshot {
>> 	struct rw_semaphore lock;
>>
>> 	struct dm_dev *origin;
>> +	struct dm_dev *cow;
>> +
>> +	struct dm_target *ti;
>>
>> 	/* List of snapshots per Origin */
>> 	struct list_head list;
>> @@ -97,6 +100,12 @@ struct dm_snapshot {
>> 	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
>> };
>>
>> +struct dm_dev *dm_snap_get_cow(struct dm_snapshot *s)
>> +{
>> +	return s->cow;
>> +}
>> +EXPORT_SYMBOL(dm_snap_get_cow);
>> +
>> static struct workqueue_struct *ksnapd;
>> static void flush_queued_bios(struct work_struct *work);
>>
>> @@ -538,7 +547,7 @@ static int init_hash_tables(struct dm_snapshot *s)
>> 	 * Calculate based on the size of the original volume or
>> 	 * the COW volume...
>> 	 */
>> -	cow_dev_size = get_dev_size(s->store->cow->bdev);
>> +	cow_dev_size = get_dev_size(s->cow->bdev);
>> 	origin_dev_size = get_dev_size(s->origin->bdev);
>> 	max_buckets = calc_max_buckets();
>>
>> @@ -574,45 +583,55 @@ static int snapshot_ctr(struct dm_target *ti,  
>> unsigned int argc, char **argv)
>> 	struct dm_snapshot *s;
>> 	int i;
>> 	int r = -EINVAL;
>> -	char *origin_path;
>> -	struct dm_exception_store *store;
>> +	char *origin_path, *cow_path;
>> 	unsigned args_used;
>>
>> 	if (argc != 4) {
>> 		ti->error = "requires exactly 4 arguments";
>> 		r = -EINVAL;
>> -		goto bad_args;
>> +		goto bad;
>> 	}
>>
>> 	origin_path = argv[0];
>> 	argv++;
>> 	argc--;
>>
>> -	r = dm_exception_store_create(ti, argc, argv, &args_used, &store);
>> +	s = kmalloc(sizeof(*s), GFP_KERNEL);
>> +	if (!s) {
>> +		ti->error = "Cannot allocate snapshot context private "
>> +		    "structure";
>> +		r = -ENOMEM;
>> +		goto bad;
>> +	}
>> +
>> +	cow_path = argv[0];
>> +	argv++;
>> +	argc--;
>> +
>> +	r = dm_get_device(ti, cow_path, 0, 0,
>> +			  FMODE_READ | FMODE_WRITE, &s->cow);
>> +	if (r) {
>> +		ti->error = "Cannot get COW device";
>> +		goto bad_cow;
>> +	}
>> +
>> +	r = dm_exception_store_create(ti, argc, argv, s, &args_used, &s- 
>> >store);
>> 	if (r) {
>> 		ti->error = "Couldn't create exception store";
>> 		r = -EINVAL;
>> -		goto bad_args;
>> +		goto bad_store;
>> 	}
>>
>> 	argv += args_used;
>> 	argc -= args_used;
>>
>> -	s = kmalloc(sizeof(*s), GFP_KERNEL);
>> -	if (!s) {
>> -		ti->error = "Cannot allocate snapshot context private "
>> -		    "structure";
>> -		r = -ENOMEM;
>> -		goto bad_snap;
>> -	}
>> -
>> 	r = dm_get_device(ti, origin_path, 0, ti->len, FMODE_READ, &s- 
>> >origin);
>> 	if (r) {
>> 		ti->error = "Cannot get origin device";
>> 		goto bad_origin;
>> 	}
>>
>> -	s->store = store;
>> +	s->ti = ti;
>> 	s->valid = 1;
>> 	s->active = 0;
>> 	atomic_set(&s->pending_exceptions_count, 0);
>> @@ -701,12 +720,15 @@ bad_hash_tables:
>> 	dm_put_device(ti, s->origin);
>>
>> bad_origin:
>> -	kfree(s);
>> +	dm_exception_store_destroy(s->store);
>>
>> -bad_snap:
>> -	dm_exception_store_destroy(store);
>> +bad_store:
>> +	dm_put_device(ti, s->cow);
>>
>> -bad_args:
>> +bad_cow:
>> +	kfree(s);
>> +
>> +bad:
>> 	return r;
>> }
>>
>> @@ -755,6 +777,8 @@ static void snapshot_dtr(struct dm_target *ti)
>>
>> 	dm_exception_store_destroy(s->store);
>>
>> +	dm_put_device(ti, s->cow);
>> +
>> 	kfree(s);
>> }
>>
>> @@ -839,7 +863,7 @@ static void __invalidate_snapshot(struct  
>> dm_snapshot *s, int err)
>>
>> 	s->valid = 0;
>>
>> -	dm_table_event(s->store->ti->table);
>> +	dm_table_event(s->ti->table);
>> }
>>
>> static void pending_complete(struct dm_snap_pending_exception *pe, int 
>> success)
>> @@ -945,7 +969,7 @@ static void start_copy(struct  
>> dm_snap_pending_exception *pe)
>> 	src.sector = chunk_to_sector(s->store, pe->e.old_chunk);
>> 	src.count = min((sector_t)s->store->chunk_size, dev_size -  
>> src.sector);
>>
>> -	dest.bdev = s->store->cow->bdev;
>> +	dest.bdev = s->cow->bdev;
>> 	dest.sector = chunk_to_sector(s->store, pe->e.new_chunk);
>> 	dest.count = src.count;
>>
>> @@ -1003,7 +1027,7 @@ __find_pending_exception(struct dm_snapshot *s,
>> static void remap_exception(struct dm_snapshot *s, struct  
>> dm_snap_exception *e,
>> 			    struct bio *bio, chunk_t chunk)
>> {
>> -	bio->bi_bdev = s->store->cow->bdev;
>> +	bio->bi_bdev = s->cow->bdev;
>> 	bio->bi_sector = chunk_to_sector(s->store,
>> 					 dm_chunk_number(e->new_chunk) +
>> 					 (chunk - e->old_chunk)) +
>> @@ -1021,7 +1045,7 @@ static int snapshot_map(struct dm_target *ti,  
>> struct bio *bio,
>> 	struct dm_snap_pending_exception *pe = NULL;
>>
>> 	if (unlikely(bio_empty_barrier(bio))) {
>> -		bio->bi_bdev = s->store->cow->bdev;
>> +		bio->bi_bdev = s->cow->bdev;
>> 		return DM_MAPIO_REMAPPED;
>> 	}
>>
>> @@ -1203,7 +1227,7 @@ static int __origin_write(struct list_head  
>> *snapshots,
>> 			goto next_snapshot;
>>
>> 		/* Nothing to do if writing beyond end of snapshot */
>> -		if (sector >= dm_table_get_size(snap->store->ti->table))
>> +		if (sector >= dm_table_get_size(snap->ti->table))
>> 			goto next_snapshot;
>>
>> 		/*
>> -- 
>> 1.6.2.5
>>
>
