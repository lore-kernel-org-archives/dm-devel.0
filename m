From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: clustered snapshots
Date: Mon, 5 Oct 2009 00:33:35 -0400
Message-ID: <20091005043334.GA27758@redhat.com>
References: <Pine.LNX.4.64.0909281906510.16904@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909291734020.12870@hs20-bc2-1.build.redhat.com>
	<20091002172656.GA13491@redhat.com>
	<20091004034843.GC25374@redhat.com>
	<Pine.LNX.4.64.0910042214530.12074@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0910042214530.12074@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Sun, Oct 04 2009 at 10:25pm -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> I don't understand the purpose of this patch. I think it's useless.

You don't understand it, so you think it's useless.. nice to know where
I'm starting.

> - during merge, nothing except the merge process reads the on-disk 
> exceptions. So it doesn't matter when you clean them. You must clean them 
> before dropping the interlock, but the order is not important.

Sure, I thought the same but quickly realized that in practice order
does matter if you'd like to avoid failing the in-core exception cleanup
(IFF we allow chunks to be inserted before existing chunks; aka
"back-merges").

Your original approach to cleaning all on-disk exceptions then all
in-core has no hope of working for "back-merges".  Your original
snapshot-merge completely eliminated insertions before existing chunks.

I also tried to clean all in-core exceptions and then clean all on-disk
exceptions.  I chose this order because when cleaning in-core exceptions
you need to _know_ the {old,new}_chunk for the on-disk
exception.. Otherwise you can't properly determine whether the in-core's
exception that has consecutive chunks needs e->{old,new}_chunk++ before
dm_consecutive_chunk_count_dec(e).

Even though it was awkward I tried it... code was ugly as hell and
simply didn't work.  Judging the in-core exception's cleanup based on
some exception store's location of the associated on-disk exception
required taking the approach I did with adding a callback to
commit_merge().  The exception stores should not know anything of the
in-core exceptions in the common snapshot code.

Lesson I learned is that the in-core dm_snap_exception's consecutive
chunk accounting is _really_ subtle.  And while I agree there should be
no relation between the proper cleanup of on-disk and in-core
exceptions; doing the cleanup of each in lock-step appears to be the
only way forward (that I found).

> - during merge, the interlock is held for the range to be merged. So there 
> shouldn't be any concurrent writes. Concurrent reads are dispatched to the 
> snapshot area (as long as the exception remains in the table).
> 
> - bug in this patch: merge_clear_exception_callback modifies the hash 
> table outside a lock

Yes I noticed that after having sent the patch.  Pretty trivial to fix
and in practice I fail to see how not taking the lock really matters
considering there was no additional concurrent IO in my merge tests.

BTW, taking the lock before the ->commit_merge only works, without
lockdep issues, if you use nested locking; which you introduced with the
first patch in your clustered locking series.

> I think this patch just hides other bug that you have made. Do you set and 
> test the interlock correctly? If yes, it will block any I/Os to the chunks 
> being merged.

What bug have I made?  Pretty bold assertion only to back it up with
hand-waving and bravado.  I've worked hard to preserve your original work
as closely as possible; yet add the ability to support insertion of
chunks before existing chunks.

Fact of the matter is that snapshot-merge ontop of Jon's patches (which
reworked the exception and exception table code; and in end moved the
'complete' hash table internal to the exception store) gave us a
_working_ model for how to cleanup in-core exceptions that had chunks
that were inserted before others.  I think that how we arrived at that
working model was mostly luck:

1) Jon's patches first enabled dm-snap-persistent's clear_exception() to
clean the in-core exception and associated on-disk exception
symmetrically.

2) Jon, you and I discussed how supporting inserts before existing
chunks _should_ work so long as they are accounted for at the time we 
dm_consecutive_chunk_count_dec(e); Jon and I got that working built on
his patches.. it was really straight forward because of #1.

Fast forward to now; where you don't like Jon's approach to cluster
locking/snapshots.. I'm trying to make the "old-style" snapshot-merge
support back-merges.  It took way too much effort to arrive at the patch
you think is "useless".  That patch is actually quite clean; and also
now gracefully fails rather than using BUG.

But in general I do think that how I got to this patch is anything but
transparent and obvious.  It was after careful study and testing of
Jon's working model that I was able to reproduce the ability to reliably
cleanup the in-core exceptions (when insertion of chunks before existing
is allowed).

Again, your original snapshot-merge completely eliminated insertions
before existing chunks.  I made it work ontop of your orignal
snapshot-merge, but it took careful porting of concepts that we got for
free from Jon's patches (namely symmetric cleanup of in-core and on-disk
exceptions).  I still need to go over it to better understand the "_why_
does it work?".

I encourage you to do the same.  Or come up with an alternative approach
to supporting cleanup of "back-merged" chunks; one that works in practice
and not in theory.

Mike


> On Sat, 3 Oct 2009, Mike Snitzer wrote:
> 
> > Mikulas,
> > 
> > I had the harddrive die in the server I was using for snapshot-merge
> > testing so my "more extensive testing" was delayed until today.
> > 
> > In testing it was quite clear that back-merge was not working at all.  I
> > had to get creative with how to make back-merging work with the
> > older-style snapshot-merge (which doesn't have jon's work to fold the
> > 'complete' hashtable into the store; that really helped snapshot-merge
> > support back-merges).
> > 
> > I have updated my people page's quilt tree to include the following
> > patch; I've now tested snapshot-merge to _really_ work with both just
> > the snapshot-merge patches and also with your clustered snapshot patches
> > ontop.
> > 
> > Also, I'll be folding these changes into the appropriate snapshot-merge
> > patches; the dm-snapshot-merge-support-insert-before-existing-chunk.patch
> > at the end of the snapshot-merge patches is just a means to get all the
> > working snapshot-merge bits in place.
> > 
> > All things considered I think the following is about as clean as we can
> > hope for but I welcome your (and others') review.  
> > 
> > 
> > Subject: [PATCH] Add clear_exception callback to the dm_exception_store_type's ->commit_merge
> > 
> > This callback is used to clear in-core exceptions during the exception
> > store's commit_merge.  One _must_ clear the in-core exceptions prior to
> > the on-disk exceptions.  But this clearing of exceptions must be done
> > fine-grained.  One cannot clear all in-core exceptions and then clear
> > all on-disk exceptions and arrive a a solution that is actually stable
> > and works.
> > 
> > Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  drivers/md/dm-exception-store.h |    5 ++
> >  drivers/md/dm-snap-persistent.c |   30 ++++++++++-------
> >  drivers/md/dm-snap.c            |   69 +++++++++++++++++++++++++---------------
> >  3 files changed, 66 insertions(+), 38 deletions(-)
> > 
> > Index: linux-2.6/drivers/md/dm-exception-store.h
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-exception-store.h
> > +++ linux-2.6/drivers/md/dm-exception-store.h
> > @@ -91,8 +91,11 @@ struct dm_exception_store_type {
> >  	/*
> >  	 * Clear the last n exceptions.
> >  	 * n must be <= the value returned by prepare_merge.
> > +	 * callback is used to clear in-core exceptions.
> >  	 */
> > -	int (*commit_merge) (struct dm_exception_store *store, int n);
> > +	int (*commit_merge) (struct dm_exception_store *store, int n,
> > +			     int (*callback) (void *, chunk_t old, chunk_t new),
> > +			     void *callback_context);
> >  
> >  	/*
> >  	 * The snapshot is invalid, note this in the metadata.
> > Index: linux-2.6/drivers/md/dm-snap-persistent.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-snap-persistent.c
> > +++ linux-2.6/drivers/md/dm-snap-persistent.c
> > @@ -410,15 +410,6 @@ static void write_exception(struct pstor
> >  	e->new_chunk = cpu_to_le64(de->new_chunk);
> >  }
> >  
> > -static void clear_exception(struct pstore *ps, uint32_t index)
> > -{
> > -	struct disk_exception *e = get_exception(ps, index);
> > -
> > -	/* clear it */
> > -	e->old_chunk = 0;
> > -	e->new_chunk = 0;
> > -}
> > -
> >  /*
> >   * Registers the exceptions that are present in the current area.
> >   * 'full' is filled in to indicate if the area has been
> > @@ -726,15 +717,30 @@ static int persistent_prepare_merge(stru
> >  	return i;
> >  }
> >  
> > -static int persistent_commit_merge(struct dm_exception_store *store, int n)
> > +static int persistent_commit_merge(struct dm_exception_store *store, int n,
> > +				   int (*callback) (void *,
> > +						    chunk_t old, chunk_t new),
> > +				   void *callback_context)
> >  {
> >  	int r, i;
> >  	struct pstore *ps = get_info(store);
> >  
> >  	BUG_ON(n > ps->current_committed);
> > +	BUG_ON(!callback);
> >  
> > -	for (i = 0; i < n; i++)
> > -		clear_exception(ps, ps->current_committed - 1 - i);
> > +	for (i = 0; i < n; i++) {
> > +		struct disk_exception *de =
> > +			get_exception(ps, ps->current_committed - 1 - i);
> > +
> > +		/* clear in-core exception */
> > +		r = callback(callback_context, de->old_chunk, de->new_chunk);
> > +		if (r < 0)
> > +			return r;
> > +
> > +		/* clear disk exception */
> > +		de->old_chunk = 0;
> > +		de->new_chunk = 0;
> > +	}
> >  
> >  	r = area_io(ps, WRITE);
> >  	if (r < 0)
> > Index: linux-2.6/drivers/md/dm-snap.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm-snap.c
> > +++ linux-2.6/drivers/md/dm-snap.c
> > @@ -764,11 +764,50 @@ static inline void release_write_interlo
> >  		error_bios(b);
> >  }
> >  
> > +static int clear_merged_exception(struct dm_snap_exception *e,
> > +				  chunk_t old_chunk, chunk_t new_chunk)
> > +{
> > +	if (dm_consecutive_chunk_count(e)) {
> > +		if ((old_chunk == e->old_chunk) &&
> > +		    (new_chunk == dm_chunk_number(e->new_chunk))) {
> > +			e->old_chunk++;
> > +			e->new_chunk++;
> > +		} else if (old_chunk != e->old_chunk +
> > +			   dm_consecutive_chunk_count(e) &&
> > +			   new_chunk != dm_chunk_number(e->new_chunk) +
> > +			   dm_consecutive_chunk_count(e)) {
> > +			DMERR("merge from the middle of a chunk range");
> > +			return -1;
> > +		}
> > +		dm_consecutive_chunk_count_dec(e);
> > +	} else {
> > +		remove_exception(e);
> > +		free_exception(e);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +static int merge_clear_exception_callback(void *context,
> > +					  chunk_t old_chunk, chunk_t new_chunk)
> > +{
> > +	struct dm_snap_exception *e;
> > +	struct exception_table *complete_et = context;
> > +
> > +	e = lookup_exception(complete_et, old_chunk);
> > +	if (!e) {
> > +		DMERR("exception for block %llu is on disk but not in memory",
> > +		      (unsigned long long)old_chunk);
> > +		return -1;
> > +	}
> > +
> > +	return clear_merged_exception(e, old_chunk, new_chunk);
> > +}
> > +
> >  static void merge_callback(int read_err, unsigned long write_err, void *context)
> >  {
> > -	int r, i;
> > +	int r;
> >  	struct dm_snapshot *s = context;
> > -	struct dm_snap_exception *e;
> >  
> >  	if (read_err || write_err) {
> >  		if (read_err)
> > @@ -778,35 +817,15 @@ static void merge_callback(int read_err,
> >  		goto shut;
> >  	}
> >  
> > -	r = s->store->type->commit_merge(s->store, s->merge_write_interlock_n);
> > +	r = s->store->type->commit_merge(s->store, s->merge_write_interlock_n,
> > +					 merge_clear_exception_callback,
> > +					 &s->complete);
> >  	if (r < 0) {
> >  		DMERR("Write error in exception store, shutting down merge");
> >  		goto shut;
> >  	}
> >  
> >  	down_write(&s->lock);
> > -	/*
> > -	 * Must process chunks (and associated exceptions) in reverse
> > -	 * so that dm_consecutive_chunk_count_dec() accounting works
> > -	 */
> > -	for (i = s->merge_write_interlock_n - 1; i >= 0; i--) {
> > -		e = lookup_exception(&s->complete,
> > -				     s->merge_write_interlock + i);
> > -		if (!e) {
> > -			DMERR("exception for block %llu is on "
> > -			      "disk but not in memory",
> > -			      (unsigned long long)
> > -			      s->merge_write_interlock + i);
> > -			up_write(&s->lock);
> > -			goto shut;
> > -		}
> > -		if (dm_consecutive_chunk_count(e)) {
> > -			dm_consecutive_chunk_count_dec(e);
> > -		} else {
> > -			remove_exception(e);
> > -			free_exception(e);
> > -		}
> > -	}
> >  	release_write_interlock(s, 0);
> >  
> >  	snapshot_merge_process(s);
> > 
