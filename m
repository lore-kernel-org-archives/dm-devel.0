From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 12/12] dm snapshot: merge a linear region of
	chunks using one large IO
Date: Tue, 17 Nov 2009 11:12:24 -0500
Message-ID: <1258474344-10886-13-git-send-email-snitzer@redhat.com>
References: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1258474344-10886-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

s->store->type->prepare_merge returns the number of chunks that can be
linearly copied starting from the returned chunk number backward. (but
the caller is allowed to copy less, and the caller puts the number of
copied chunks to s->store->type->commit_merge)

I.e. if returned chunk numbers are old_chunk == 10 and new_chunk == 20
and returned value is 3, then chunk 20 can be copied to 10, chunk 19 to
9 and 18 to 8.

s->merge_write_interlock_n has now been allowed to be increased up to
the full range of chunks returned from s->store->type->prepare_merge.
Until now kcopyd was only ever allowed to copy one chunk at a time;
as a result snapshot-merge performance was extremely slow.

Also, snapshot_merge_process() needs to delay the merging of _all_
chunks that have in-progress writes; not just the first chunk in the
region that is to be merged.

snapshot-merge performance is now very respectible.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-snap.c |   35 +++++++++++++++++++++++------------
 1 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3d214f4..34d8c3f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -685,12 +685,13 @@ static void merge_callback(int read_err, unsigned long write_err,
 
 static void snapshot_merge_process(struct dm_snapshot *s)
 {
-	int r;
+	int r, i, linear_chunks;
 	chunk_t old_chunk, new_chunk;
 	struct origin *o;
 	chunk_t min_chunksize;
 	int must_wait;
 	struct dm_io_region src, dest;
+	sector_t io_size;
 
 	BUG_ON(!s->merge_running);
 	if (s->merge_shutdown)
@@ -701,34 +702,41 @@ static void snapshot_merge_process(struct dm_snapshot *s)
 		goto shut;
 	}
 
-	r = s->store->type->prepare_merge(s->store, &old_chunk, &new_chunk);
-	if (r <= 0) {
-		if (r < 0)
+	linear_chunks = s->store->type->prepare_merge(s->store,
+						      &old_chunk, &new_chunk);
+	if (linear_chunks <= 0) {
+		if (linear_chunks < 0)
 			DMERR("Read error in exception store, "
 			      "shutting down merge");
 		goto shut;
 	}
+	/* Adjust old_chunk and new_chunk to reflect start of linear region */
+	old_chunk = old_chunk + 1 - linear_chunks;
+	new_chunk = new_chunk + 1 - linear_chunks;
 
-	/* TODO: use larger I/O size once we verify that kcopyd handles it */
+	/*
+	 * Use one (potentially large) I/O to copy all 'linear_chunks'
+	 * from the exception store to the origin
+	 */
+	io_size = linear_chunks * s->store->chunk_size;
 
 	dest.bdev = s->origin->bdev;
 	dest.sector = chunk_to_sector(s->store, old_chunk);
-	dest.count = min((sector_t)s->store->chunk_size,
-			 get_dev_size(dest.bdev) - dest.sector);
+	dest.count = min(io_size, get_dev_size(dest.bdev) - dest.sector);
 
 	src.bdev = s->cow->bdev;
 	src.sector = chunk_to_sector(s->store, new_chunk);
 	src.count = dest.count;
 
 test_again:
-	/* Reallocate other snapshots */
+	/* Reallocate other snapshots; must account for all 'linear_chunks' */
 	down_read(&_origins_lock);
 	o = __lookup_origin(s->origin->bdev);
 	must_wait = 0;
 	min_chunksize = __minimum_chunk_size(o);
 	if (min_chunksize) {
 		chunk_t n;
-		for (n = 0; n < s->store->chunk_size; n += min_chunksize) {
+		for (n = 0; n < io_size; n += min_chunksize) {
 			r = __origin_write(&o->snapshots, dest.sector + n,
 					   NULL);
 			if (r == DM_MAPIO_SUBMITTED)
@@ -743,11 +751,14 @@ test_again:
 
 	down_write(&s->lock);
 	s->merge_write_interlock = old_chunk;
-	s->merge_write_interlock_n = 1;
+	s->merge_write_interlock_n = linear_chunks;
 	up_write(&s->lock);
 
-	while (__chunk_is_tracked(s, old_chunk))
-		msleep(1);
+	/* Wait until writes to all 'linear_chunks' drain */
+	for (i = 0; i < linear_chunks; i++) {
+		while (__chunk_is_tracked(s, old_chunk + i))
+			msleep(1);
+	}
 
 	dm_kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0, merge_callback, s);
 	return;
-- 
1.6.5.2
