From: Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 4 of 5] dm-exception-store API
Date: Fri, 14 Nov 2008 14:39:09 -0600
Message-ID: <659B786F-B502-45C8-851A-DF9767369AD2@redhat.com>
References: <1226571159.6033.23.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v929.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1226571159.6033.23.camel@hydrogen.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

If this function's purpose is what I'm assuming it to be, then
it will also be necessary for cluster-aware exceptions stores as well.

Using the normal method of preloading exceptions won't be good
enough in a cluster, because node1 will need to be aware of the fact
that node2 caused an exception.

  brassow

On Nov 13, 2008, at 4:12 AM, Jonathan Brassow wrote:

> After twiddling with phillips/tomonori's shared snapshot, I believe  
> the
> addition of the 'lookup_completed_exception' function to the
> exception store API will be useful.  If I understand correctly, it  
> allows
> us to defer populating a snapshot's exception cache up front.  Instead
> allowing us to look them up as necessary.  This is nice, because when
> the exception store is shared, we don't want 60 copies of all the
> exceptions for each snapshot structure.  We just want one copy in the
> exceptions store that we can lookup.
>
> - brassow
>
> Index: linux-2.6/drivers/md/dm-exception-store.h
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-exception-store.h
> +++ linux-2.6/drivers/md/dm-exception-store.h
> @@ -78,6 +78,18 @@ struct dm_exception_store_type {
> 				  void *callback_context);
>
> 	/*
> +	 * An exception store implementation can forgo using the
> +	 * callbacks provided to read_metadata, which would populate
> +	 * all exception data upfront.  Instead, it can choose to
> +	 * look them up as needed via 'lookup_completed_exception'.
> +	 * This is especially useful for shared exception store
> +	 * implementations.
> +	 */
> +	struct dm_snap_exception *
> +	(*lookup_completed_exception)(struct dm_exception_store *store,
> +				      chunk_t chunk);
> +
> +	/*
> 	 * The snapshot is invalid, note this in the metadata.
> 	 */
> 	void (*drop_snapshot) (struct dm_exception_store *store);
> Index: linux-2.6/drivers/md/dm-snap.c
> ===================================================================
> --- linux-2.6.orig/drivers/md/dm-snap.c
> +++ linux-2.6/drivers/md/dm-snap.c
> @@ -417,6 +417,16 @@ static struct dm_snap_exception *lookup_
> 	return NULL;
> }
>
> +static struct dm_snap_exception *
> +lookup_completed_exception(struct dm_snapshot *s, chunk_t chunk)
> +{
> +	if (s->store->type->lookup_completed_exception)
> +		return s->store->type->lookup_completed_exception(s->store,
> +								  chunk);
> +	else
> +		return lookup_exception(&s->complete, chunk);
> +}
> +
> static struct dm_snap_exception *alloc_exception(void)
> {
> 	struct dm_snap_exception *e;
> @@ -905,7 +915,7 @@ static struct bio *put_pending_exception
>
> static void pending_complete(struct dm_snap_pending_exception *pe,  
> int success)
> {
> -	struct dm_snap_exception *e;
> +	struct dm_snap_exception *e = NULL;
> 	struct dm_snapshot *s = pe->snap;
> 	struct bio *origin_bios = NULL;
> 	struct bio *snapshot_bios = NULL;
> @@ -919,18 +929,21 @@ static void pending_complete(struct dm_s
> 		goto out;
> 	}
>
> -	e = alloc_exception();
> -	if (!e) {
> -		down_write(&s->lock);
> -		__invalidate_snapshot(s, -ENOMEM);
> -		error = 1;
> -		goto out;
> +	if (!s->store->type->lookup_completed_exception) {
> +		e = alloc_exception();
> +		if (!e) {
> +			down_write(&s->lock);
> +			__invalidate_snapshot(s, -ENOMEM);
> +			error = 1;
> +			goto out;
> +		}
> +		*e = pe->e;
> 	}
> -	*e = pe->e;
>
> 	down_write(&s->lock);
> 	if (!s->valid) {
> -		free_exception(e);
> +		if (e)
> +			free_exception(e);
> 		error = 1;
> 		goto out;
> 	}
> @@ -946,7 +959,8 @@ static void pending_complete(struct dm_s
> 	 * Add a proper exception, and remove the
> 	 * in-flight exception from the list.
> 	 */
> -	insert_completed_exception(s, e);
> +	if (e)
> +		insert_completed_exception(s, e);
>
>  out:
> 	remove_exception(&pe->e);
> @@ -1113,7 +1127,7 @@ static int snapshot_map(struct dm_target
> 	}
>
> 	/* If the block is already remapped - use that, else remap it */
> -	e = lookup_exception(&s->complete, chunk);
> +	e = lookup_completed_exception(s, chunk);
> 	if (e) {
> 		remap_exception(s, e, bio, chunk);
> 		goto out_unlock;
> @@ -1255,7 +1269,7 @@ static int __origin_write(struct list_he
> 		 * ref_count is initialised to 1 so pending_complete()
> 		 * won't destroy the primary_pe while we're inside this loop.
> 		 */
> -		e = lookup_exception(&snap->complete, chunk);
> +		e = lookup_completed_exception(snap, chunk);
> 		if (e)
> 			goto next_snapshot;
>
>
