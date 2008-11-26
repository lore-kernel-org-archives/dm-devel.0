From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 6/9] dm snapshot: add snapshot id argument to
	prepare_exception and lookup_completed_exception
Date: Thu, 27 Nov 2008 01:17:36 +0900
Message-ID: <1227716259-31952-7-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1227716259-31952-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1227716259-31952-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1227716259-31952-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1227716259-31952-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1227716259-31952-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1227716259-31952-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1227716259-31952-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
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
Cc: agk@redhat.com
List-Id: dm-devel.ids

With the current two exception store implementations (persistent and
transient), snapshots are independent. Each snapshot has own cow disk
and dm_snapshot struct.

With shared exception store code, snapshots are not independent. They
are stored in a single cow disk and has only one dm_snapshot struct.
So the shared exception store code needs to identify snapshot in
prepare_exception() and lookup_completed_exception().

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-exception-store.c |    4 ++--
 drivers/md/dm-snap.c            |   22 ++++++++++++----------
 drivers/md/dm-snap.h            |    6 ++++--
 3 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index 6c5ea26..122e2f9 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -552,7 +552,7 @@ static int persistent_read_metadata(struct exception_store *store)
 }
 
 static int persistent_prepare(struct exception_store *store,
-			      struct dm_snap_exception *e)
+			      struct dm_snap_exception *e, u64 snapid)
 {
 	struct pstore *ps = get_info(store);
 	uint32_t stride;
@@ -705,7 +705,7 @@ static int transient_read_metadata(struct exception_store *store)
 }
 
 static int transient_prepare(struct exception_store *store,
-			     struct dm_snap_exception *e)
+			     struct dm_snap_exception *e, u64 snapid)
 {
 	struct transient_c *tc = (struct transient_c *) store->context;
 	sector_t size = get_dev_size(store->snap->cow->bdev);
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 270f7b2..604f5c4 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -350,10 +350,12 @@ static struct dm_snap_exception *lookup_exception(struct exception_table *et,
 }
 
 struct dm_snap_exception *lookup_complete_exception(struct dm_snapshot *s,
-						    chunk_t chunk)
+						    chunk_t chunk,
+						    u64 snapid)
 {
 	if (s->store.lookup_completed_exception)
-		return s->store.lookup_completed_exception(&s->store, chunk);
+		return s->store.lookup_completed_exception(&s->store, chunk,
+							   snapid);
 	else
 		return lookup_exception(&s->complete, chunk);
 }
@@ -986,7 +988,7 @@ static void start_copy(struct dm_snap_pending_exception *pe)
  * this.
  */
 static struct dm_snap_pending_exception *
-__find_pending_exception(struct dm_snapshot *s, struct bio *bio)
+__find_pending_exception(struct dm_snapshot *s, struct bio *bio, u64 snapid)
 {
 	struct dm_snap_exception *e;
 	struct dm_snap_pending_exception *pe;
@@ -1029,7 +1031,7 @@ __find_pending_exception(struct dm_snapshot *s, struct bio *bio)
 	atomic_set(&pe->ref_count, 0);
 	pe->started = 0;
 
-	if (s->store.prepare_exception(&s->store, &pe->e)) {
+	if (s->store.prepare_exception(&s->store, &pe->e, snapid)) {
 		free_pending_exception(pe);
 		return NULL;
 	}
@@ -1051,7 +1053,7 @@ static void remap_exception(struct dm_snapshot *s, struct dm_snap_exception *e,
 }
 
 static int do_snapshot_map(struct dm_snapshot *s, struct bio *bio,
-			   union map_info *map_context)
+			   union map_info *map_context, u64 snapid)
 {
 	struct dm_snap_exception *e;
 	int r = DM_MAPIO_REMAPPED;
@@ -1075,7 +1077,7 @@ static int do_snapshot_map(struct dm_snapshot *s, struct bio *bio,
 	}
 
 	/* If the block is already remapped - use that, else remap it */
-	e = lookup_complete_exception(s, chunk);
+	e = lookup_complete_exception(s, chunk, snapid);
 	if (e) {
 		remap_exception(s, e, bio, chunk);
 		goto out_unlock;
@@ -1087,7 +1089,7 @@ static int do_snapshot_map(struct dm_snapshot *s, struct bio *bio,
 	 * writeable.
 	 */
 	if (bio_rw(bio) == WRITE) {
-		pe = __find_pending_exception(s, bio);
+		pe = __find_pending_exception(s, bio, snapid);
 		if (!pe) {
 			__invalidate_snapshot(s, -ENOMEM);
 			r = -EIO;
@@ -1122,7 +1124,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 {
 	struct dm_snapshot *s = ti->private;
 
-	return do_snapshot_map(s, bio, map_context);
+	return do_snapshot_map(s, bio, map_context, 0);
 }
 
 static int do_snapshot_end_io(struct dm_snapshot *s, struct bio *bio,
@@ -1231,11 +1233,11 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 		 * ref_count is initialised to 1 so pending_complete()
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
-		e = lookup_complete_exception(snap, chunk);
+		e = lookup_complete_exception(snap, chunk, ORIGIN_SNAPID);
 		if (e)
 			goto next_snapshot;
 
-		pe = __find_pending_exception(snap, bio);
+		pe = __find_pending_exception(snap, bio, ORIGIN_SNAPID);
 		if (!pe) {
 			__invalidate_snapshot(snap, -ENOMEM);
 			goto next_snapshot;
diff --git a/drivers/md/dm-snap.h b/drivers/md/dm-snap.h
index 8a0ae7f..accc218 100644
--- a/drivers/md/dm-snap.h
+++ b/drivers/md/dm-snap.h
@@ -83,6 +83,8 @@ static inline void dm_consecutive_chunk_count_inc(struct dm_snap_exception *e)
 
 #  endif
 
+#define ORIGIN_SNAPID ULLONG_MAX
+
 /*
  * Abstraction to handle the meta/layout of exception stores (the
  * COW device).
@@ -104,7 +106,7 @@ struct exception_store {
 	 * Find somewhere to store the next exception.
 	 */
 	int (*prepare_exception) (struct exception_store *store,
-				  struct dm_snap_exception *e);
+				  struct dm_snap_exception *e, u64 snapid);
 
 	/*
 	 * Update the metadata with this exception.
@@ -130,7 +132,7 @@ struct exception_store {
 	 * look up if a chunk is in completed exception.
 	 */
 	struct dm_snap_exception *(*lookup_completed_exception)
-	(struct exception_store *store, chunk_t chunk);
+	(struct exception_store *store, chunk_t chunk, u64 snapid);
 
 	/*
 	 * let exception store code to handle the message hook in
-- 
1.5.5.GIT
