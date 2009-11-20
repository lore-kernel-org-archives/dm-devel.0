From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v4 11/13] dm snapshot: make exceptions in other
	snapshots when merging
Date: Fri, 20 Nov 2009 15:27:51 -0500
Message-ID: <1258748873-24185-12-git-send-email-snitzer@redhat.com>
References: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

When there is one merging snapshot and other non-merging snapshots,
snapshot_merge_process() must make exceptions in the non-merging
snapshots.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   32 +++++++++++++++++++++++++++++++-
 1 files changed, 31 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index e41be70..2b5b083 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -255,6 +255,8 @@ struct origin {
 static struct list_head *_origins;
 static struct rw_semaphore _origins_lock;
 
+static DECLARE_WAIT_QUEUE_HEAD(_pending_exception_done);
+
 static int init_origin_hash(void)
 {
 	int i;
@@ -742,13 +744,18 @@ static int init_hash_tables(struct dm_snapshot *s)
 static void flush_bios(struct bio *bio);
 static void error_bios(struct bio *bio);
 
+static int __origin_write(struct list_head *snapshots,
+			  sector_t sector, struct bio *bio);
+
 static void merge_callback(int read_err, unsigned long write_err,
 			   void *context);
 
 static void snapshot_merge_process(struct dm_snapshot *s)
 {
 	int r;
-	chunk_t old_chunk, new_chunk;
+	chunk_t old_chunk, new_chunk, n;
+	struct origin *o;
+	int must_wait;
 	struct dm_io_region src, dest;
 
 	BUG_ON(!s->merge_running);
@@ -779,6 +786,27 @@ static void snapshot_merge_process(struct dm_snapshot *s)
 	src.sector = chunk_to_sector(s->store, new_chunk);
 	src.count = dest.count;
 
+test_again:
+	/* Reallocate other snapshots */
+	must_wait = 0;
+	/*
+	 * Merging snapshot already has the origin's __minimum_chunk_size()
+	 * stored in split_io (see: snapshot_merge_resume); avoid rediscovery
+	 */
+	BUG_ON(!s->ti->split_io);
+	down_read(&_origins_lock);
+	o = __lookup_origin(s->origin->bdev);
+	for (n = 0; n < s->store->chunk_size; n += s->ti->split_io) {
+		r = __origin_write(&o->snapshots, dest.sector + n, NULL);
+		if (r == DM_MAPIO_SUBMITTED)
+			must_wait = 1;
+	}
+	up_read(&_origins_lock);
+	if (must_wait) {
+		sleep_on_timeout(&_pending_exception_done, HZ / 100 + 1);
+		goto test_again;
+	}
+
 	down_write(&s->lock);
 	s->merge_write_interlock = old_chunk;
 	s->merge_write_interlock_n = 1;
@@ -1301,6 +1329,8 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 	origin_bios = bio_list_get(&pe->origin_bios);
 	free_pending_exception(pe);
 
+	wake_up_all(&_pending_exception_done);
+
 	up_write(&s->lock);
 
 	/* Submit any pending write bios */
-- 
1.6.5.2
