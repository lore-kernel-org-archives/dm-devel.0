From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: clustered snapshots
Date: Sat, 3 Oct 2009 23:48:44 -0400
Message-ID: <20091004034843.GC25374@redhat.com>
References: <Pine.LNX.4.64.0909281906510.16904@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0909291734020.12870@hs20-bc2-1.build.redhat.com>
	<20091002172656.GA13491@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20091002172656.GA13491@redhat.com>
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

On Fri, Oct 02 2009 at  1:26pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> I have updated the following quilt tree and folded Mikulas' clustered
> snapshots patches into the end:
> http://people.redhat.com/msnitzer/patches/snapshot-merge/kernel/2.6.31/
...
> I have done some light snapshot-merge testing to verify that this
> updated snapshot-merge quilt tree builds and works as expected.  I'll be
> testing more extensively shortly (particularly back-merge).

Mikulas,

I had the harddrive die in the server I was using for snapshot-merge
testing so my "more extensive testing" was delayed until today.

In testing it was quite clear that back-merge was not working at all.  I
had to get creative with how to make back-merging work with the
older-style snapshot-merge (which doesn't have jon's work to fold the
'complete' hashtable into the store; that really helped snapshot-merge
support back-merges).

I have updated my people page's quilt tree to include the following
patch; I've now tested snapshot-merge to _really_ work with both just
the snapshot-merge patches and also with your clustered snapshot patches
ontop.

Also, I'll be folding these changes into the appropriate snapshot-merge
patches; the dm-snapshot-merge-support-insert-before-existing-chunk.patch
at the end of the snapshot-merge patches is just a means to get all the
working snapshot-merge bits in place.

All things considered I think the following is about as clean as we can
hope for but I welcome your (and others') review.  


Subject: [PATCH] Add clear_exception callback to the dm_exception_store_type's ->commit_merge

This callback is used to clear in-core exceptions during the exception
store's commit_merge.  One _must_ clear the in-core exceptions prior to
the on-disk exceptions.  But this clearing of exceptions must be done
fine-grained.  One cannot clear all in-core exceptions and then clear
all on-disk exceptions and arrive a a solution that is actually stable
and works.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-exception-store.h |    5 ++
 drivers/md/dm-snap-persistent.c |   30 ++++++++++-------
 drivers/md/dm-snap.c            |   69 +++++++++++++++++++++++++---------------
 3 files changed, 66 insertions(+), 38 deletions(-)

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -91,8 +91,11 @@ struct dm_exception_store_type {
 	/*
 	 * Clear the last n exceptions.
 	 * n must be <= the value returned by prepare_merge.
+	 * callback is used to clear in-core exceptions.
 	 */
-	int (*commit_merge) (struct dm_exception_store *store, int n);
+	int (*commit_merge) (struct dm_exception_store *store, int n,
+			     int (*callback) (void *, chunk_t old, chunk_t new),
+			     void *callback_context);
 
 	/*
 	 * The snapshot is invalid, note this in the metadata.
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -410,15 +410,6 @@ static void write_exception(struct pstor
 	e->new_chunk = cpu_to_le64(de->new_chunk);
 }
 
-static void clear_exception(struct pstore *ps, uint32_t index)
-{
-	struct disk_exception *e = get_exception(ps, index);
-
-	/* clear it */
-	e->old_chunk = 0;
-	e->new_chunk = 0;
-}
-
 /*
  * Registers the exceptions that are present in the current area.
  * 'full' is filled in to indicate if the area has been
@@ -726,15 +717,30 @@ static int persistent_prepare_merge(stru
 	return i;
 }
 
-static int persistent_commit_merge(struct dm_exception_store *store, int n)
+static int persistent_commit_merge(struct dm_exception_store *store, int n,
+				   int (*callback) (void *,
+						    chunk_t old, chunk_t new),
+				   void *callback_context)
 {
 	int r, i;
 	struct pstore *ps = get_info(store);
 
 	BUG_ON(n > ps->current_committed);
+	BUG_ON(!callback);
 
-	for (i = 0; i < n; i++)
-		clear_exception(ps, ps->current_committed - 1 - i);
+	for (i = 0; i < n; i++) {
+		struct disk_exception *de =
+			get_exception(ps, ps->current_committed - 1 - i);
+
+		/* clear in-core exception */
+		r = callback(callback_context, de->old_chunk, de->new_chunk);
+		if (r < 0)
+			return r;
+
+		/* clear disk exception */
+		de->old_chunk = 0;
+		de->new_chunk = 0;
+	}
 
 	r = area_io(ps, WRITE);
 	if (r < 0)
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -764,11 +764,50 @@ static inline void release_write_interlo
 		error_bios(b);
 }
 
+static int clear_merged_exception(struct dm_snap_exception *e,
+				  chunk_t old_chunk, chunk_t new_chunk)
+{
+	if (dm_consecutive_chunk_count(e)) {
+		if ((old_chunk == e->old_chunk) &&
+		    (new_chunk == dm_chunk_number(e->new_chunk))) {
+			e->old_chunk++;
+			e->new_chunk++;
+		} else if (old_chunk != e->old_chunk +
+			   dm_consecutive_chunk_count(e) &&
+			   new_chunk != dm_chunk_number(e->new_chunk) +
+			   dm_consecutive_chunk_count(e)) {
+			DMERR("merge from the middle of a chunk range");
+			return -1;
+		}
+		dm_consecutive_chunk_count_dec(e);
+	} else {
+		remove_exception(e);
+		free_exception(e);
+	}
+
+	return 0;
+}
+
+static int merge_clear_exception_callback(void *context,
+					  chunk_t old_chunk, chunk_t new_chunk)
+{
+	struct dm_snap_exception *e;
+	struct exception_table *complete_et = context;
+
+	e = lookup_exception(complete_et, old_chunk);
+	if (!e) {
+		DMERR("exception for block %llu is on disk but not in memory",
+		      (unsigned long long)old_chunk);
+		return -1;
+	}
+
+	return clear_merged_exception(e, old_chunk, new_chunk);
+}
+
 static void merge_callback(int read_err, unsigned long write_err, void *context)
 {
-	int r, i;
+	int r;
 	struct dm_snapshot *s = context;
-	struct dm_snap_exception *e;
 
 	if (read_err || write_err) {
 		if (read_err)
@@ -778,35 +817,15 @@ static void merge_callback(int read_err,
 		goto shut;
 	}
 
-	r = s->store->type->commit_merge(s->store, s->merge_write_interlock_n);
+	r = s->store->type->commit_merge(s->store, s->merge_write_interlock_n,
+					 merge_clear_exception_callback,
+					 &s->complete);
 	if (r < 0) {
 		DMERR("Write error in exception store, shutting down merge");
 		goto shut;
 	}
 
 	down_write(&s->lock);
-	/*
-	 * Must process chunks (and associated exceptions) in reverse
-	 * so that dm_consecutive_chunk_count_dec() accounting works
-	 */
-	for (i = s->merge_write_interlock_n - 1; i >= 0; i--) {
-		e = lookup_exception(&s->complete,
-				     s->merge_write_interlock + i);
-		if (!e) {
-			DMERR("exception for block %llu is on "
-			      "disk but not in memory",
-			      (unsigned long long)
-			      s->merge_write_interlock + i);
-			up_write(&s->lock);
-			goto shut;
-		}
-		if (dm_consecutive_chunk_count(e)) {
-			dm_consecutive_chunk_count_dec(e);
-		} else {
-			remove_exception(e);
-			free_exception(e);
-		}
-	}
 	release_write_interlock(s, 0);
 
 	snapshot_merge_process(s);
