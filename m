From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm snapshot: support barriers in snapshot-merge
	target
Date: Tue,  8 Dec 2009 16:02:06 -0500
Message-ID: <1260306126-20574-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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

Sets num_flush_requests=2 to support flushing both the origin and cow
devices used by the snapshot-merge target.

Also, snapshot_ctr() now gets the origin device using FMODE_WRITE if the
target is snapshot-merge (which writes to the origin device).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
NOTE: this patch is made to follow:
v5-05-13-dm-snapshot-merge-target-should-not-allocate-new-exceptions.patch 
---
 drivers/md/dm-snap.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -704,7 +704,8 @@ static int snapshot_ctr(struct dm_target
 	int i;
 	int r = -EINVAL;
 	char *origin_path, *cow_path;
-	unsigned args_used;
+	unsigned args_used, num_flush_requests = 1;
+	fmode_t origin_mode = FMODE_READ;
 
 	if (argc != 4) {
 		ti->error = "requires exactly 4 arguments";
@@ -712,6 +713,11 @@ static int snapshot_ctr(struct dm_target
 		goto bad;
 	}
 
+	if (dm_target_is_snapshot_merge(ti)) {
+		num_flush_requests = 2;
+		origin_mode = FMODE_WRITE;
+	}
+
 	origin_path = argv[0];
 	argv++;
 	argc--;
@@ -745,7 +751,7 @@ static int snapshot_ctr(struct dm_target
 	argv += args_used;
 	argc -= args_used;
 
-	r = dm_get_device(ti, origin_path, 0, ti->len, FMODE_READ, &s->origin);
+	r = dm_get_device(ti, origin_path, 0, ti->len, origin_mode, &s->origin);
 	if (r) {
 		ti->error = "Cannot get origin device";
 		goto bad_origin;
@@ -796,7 +802,7 @@ static int snapshot_ctr(struct dm_target
 	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
 
 	ti->private = s;
-	ti->num_flush_requests = 1;
+	ti->num_flush_requests = num_flush_requests;
 
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
@@ -1322,6 +1328,14 @@ static int snapshot_merge_map(struct dm_
 	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
 
+	if (unlikely(bio_empty_barrier(bio))) {
+		if (map_context->flush_request == 0)
+			bio->bi_bdev = s->origin->bdev;
+		else if (map_context->flush_request == 1)
+			bio->bi_bdev = s->cow->bdev;
+		return DM_MAPIO_REMAPPED;
+	}
+
 	chunk = sector_to_chunk(s->store, bio->bi_sector);
 
 	down_read(&s->lock);
