From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm snapshot: add optional discard support features
Date: Thu, 11 Jul 2019 16:36:11 -0400
Message-ID: <20190711203611.GA51041@lobo>
References: <20190703162504.GA34397@lobo>
	<fb809628-40e3-245a-dda4-034eee9a931b@arrikto.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <fb809628-40e3-245a-dda4-034eee9a931b@arrikto.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikos Tsironis <ntsironis@arrikto.com>
Cc: dm-devel@redhat.com, John Dorminy <jdorminy@redhat.com>
List-Id: dm-devel.ids

On Fri, Jul 05 2019 at 12:03pm -0400,
Nikos Tsironis <ntsironis@arrikto.com> wrote:

> Hi Mike,
> 
> A question inline.
...
> > diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
> > index 3107f2b1988b..e894302619dd 100644
> > --- a/drivers/md/dm-snap.c
> > +++ b/drivers/md/dm-snap.c
> > @@ -1839,10 +1922,42 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
> >  		goto out_unlock;
> >  	}
> >  
> > +	if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
> > +		if (s->discard_passdown_origin && dm_bio_get_target_bio_nr(bio)) {
> > +			/*
> > +			 * passdown discard to origin (without triggering
> > +			 * snapshot exceptions via do_origin; doing so would
> > +			 * defeat the goal of freeing space in origin that is
> > +			 * implied by the "discard_passdown_origin" feature)
> > +			 */
> > +			bio_set_dev(bio, s->origin->bdev);
> > +			track_chunk(s, bio, chunk);
> > +			goto out_unlock;
> > +		}
> > +		/* discard to snapshot (target_bio_nr == 0) zeroes exceptions */
> > +	}
> > +
> >  	/* If the block is already remapped - use that, else remap it */
> >  	e = dm_lookup_exception(&s->complete, chunk);
> >  	if (e) {
> >  		remap_exception(s, e, bio, chunk);
> > +		if (unlikely(bio_op(bio) == REQ_OP_DISCARD) &&
> > +		    io_overlaps_chunk(s, bio)) {
> > +			dm_exception_table_unlock(&lock);
> > +			up_read(&s->lock);
> > +			zero_exception(s, e, bio, chunk);
> > +			goto out;
> > +		}
> > +		goto out_unlock;
> > +	}
> 
> In case an exception exists for a chunk and we get a discard for it, we
> want to zero the corresponding exception in the exception store.
> 
> The code remaps the discard bio, issues the zeroing operation by calling
> zero_exception() and returns DM_MAPIO_REMAPPED. If I am not missing
> something, device mapper core will then submit the discard bio to the
> COW device, so we end up both zeroing and discarding the chunk in the
> COW device.
> 
> Is this deliberate?

No, it was an oversight.

The following incremental patch fixes it and a couple other bugs I found
while fixing the issue you reported.  I'll post v2 in reply to v1.  Your
timely review would be appreciated.  I'd still like to send this
upstream for the 5.3 merge tomorrow (Friday) by my end of day.  Thanks!

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index e894302619dd..63916e1dc569 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1,6 +1,4 @@
 /*
- * dm-snapshot.c
- *
  * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
  *
  * This file is released under the GPL.
@@ -1865,9 +1863,12 @@ static void remap_exception(struct dm_snapshot *s, struct dm_exception *e,
 
 static void zero_callback(int read_err, unsigned long write_err, void *context)
 {
-	struct dm_snapshot *s = context;
+	struct bio *bio = context;
+	struct dm_snapshot *s = bio->bi_private;
 
 	up(&s->cow_count);
+	bio->bi_status = write_err ? BLK_STS_IOERR : 0;
+	bio_endio(bio);
 }
 
 static void zero_exception(struct dm_snapshot *s, struct dm_exception *e,
@@ -1880,7 +1881,9 @@ static void zero_exception(struct dm_snapshot *s, struct dm_exception *e,
 	dest.count = s->store->chunk_size;
 
 	down(&s->cow_count);
-	dm_kcopyd_zero(s->kcopyd_client, 1, &dest, 0, zero_callback, s);
+	WARN_ON_ONCE(bio->bi_private);
+	bio->bi_private = s;
+	dm_kcopyd_zero(s->kcopyd_client, 1, &dest, 0, zero_callback, bio);
 }
 
 static bool io_overlaps_chunk(struct dm_snapshot *s, struct bio *bio)
@@ -1946,6 +1949,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 			dm_exception_table_unlock(&lock);
 			up_read(&s->lock);
 			zero_exception(s, e, bio, chunk);
+			r = DM_MAPIO_SUBMITTED; /* discard is not issued */
 			goto out;
 		}
 		goto out_unlock;
@@ -2292,8 +2296,8 @@ static void snapshot_status(struct dm_target *ti, status_type_t type,
 		 * make sense.
 		 */
 		DMEMIT("%s %s", snap->origin->name, snap->cow->name);
-		snap->store->type->status(snap->store, type, result + sz,
-					  maxlen - sz);
+		sz += snap->store->type->status(snap->store, type, result + sz,
+						maxlen - sz);
 		num_features = snap->discard_zeroes_cow + snap->discard_passdown_origin;
 		if (num_features) {
 			DMEMIT(" %u", num_features);
@@ -2325,6 +2329,12 @@ static void snapshot_io_hints(struct dm_target *ti, struct queue_limits *limits)
 	struct dm_snapshot *snap = ti->private;
 
 	if (snap->discard_zeroes_cow) {
+		struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
+
+		(void) __find_snapshots_sharing_cow(snap, &snap_src, &snap_dest, NULL);
+		if (snap_src && snap_dest)
+			snap = snap_src;
+
 		/* All discards are split on chunk_size boundary */
 		limits->discard_granularity = snap->store->chunk_size;
 		limits->max_discard_sectors = snap->store->chunk_size;
