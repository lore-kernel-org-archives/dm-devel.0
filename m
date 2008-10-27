From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 5/9] dm snapshot: split snapshot_map and
	sanpshot_end_io
Date: Mon, 27 Oct 2008 21:07:52 +0900
Message-ID: <1225109276-16491-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1225109276-16491-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-2-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-3-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1225109276-16491-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1225109276-16491-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

snapshot_map and sanpshot_end_io are useful for shared exception
snapshot but they assume that dm_target::private is a pointer to
struct dm_snapshot. This removes that restriction.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/md/dm-snap.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 7a4d8e1..30071b8 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1034,11 +1034,10 @@ static void remap_exception(struct dm_snapshot *s, struct dm_snap_exception *e,
 			 (bio->bi_sector & s->chunk_mask);
 }
 
-static int snapshot_map(struct dm_target *ti, struct bio *bio,
-			union map_info *map_context)
+static int do_snapshot_map(struct dm_snapshot *s, struct bio *bio,
+			   union map_info *map_context)
 {
 	struct dm_snap_exception *e;
-	struct dm_snapshot *s = ti->private;
 	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
@@ -1102,18 +1101,32 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 	return r;
 }
 
-static int snapshot_end_io(struct dm_target *ti, struct bio *bio,
-			   int error, union map_info *map_context)
+static int snapshot_map(struct dm_target *ti, struct bio *bio,
+			union map_info *map_context)
 {
 	struct dm_snapshot *s = ti->private;
+
+	return do_snapshot_map(s, bio, map_context);
+}
+
+static int do_snapshot_end_io(struct dm_snapshot *s, struct bio *bio,
+			      int error, union map_info *map_context)
+{
 	struct dm_snap_tracked_chunk *c = map_context->ptr;
 
 	if (c)
 		stop_tracking_chunk(s, c);
-
 	return 0;
 }
 
+static int snapshot_end_io(struct dm_target *ti, struct bio *bio,
+			   int error, union map_info *map_context)
+{
+	struct dm_snapshot *s = ti->private;
+
+	return do_snapshot_end_io(s, bio, error, map_context);
+}
+
 static void snapshot_resume(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
-- 
1.5.5.GIT
