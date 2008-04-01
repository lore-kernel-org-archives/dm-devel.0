From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 05/10] dm snapshot: Split up origin_resume()
Date: Tue,  1 Apr 2008 09:32:52 +0200
Message-ID: <1207035177-7156-6-git-send-email-markmc@redhat.com>
References: <1207035177-7156-1-git-send-email-markmc@redhat.com>
	<1207035177-7156-2-git-send-email-markmc@redhat.com>
	<1207035177-7156-3-git-send-email-markmc@redhat.com>
	<1207035177-7156-4-git-send-email-markmc@redhat.com>
	<1207035177-7156-5-git-send-email-markmc@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1207035177-7156-5-git-send-email-markmc@redhat.com>
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
Cc: Mark McLoughlin <markmc@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Split the origin_resume() code which calculates the minimum chunk size
of all related snapshots into a separate function, min_chunk_size().

This function will be used by the resume() function for the merged
target.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/md/dm-snap.c |   20 +++++++++++++-------
 1 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 20f12a8..7684f8f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1275,13 +1275,8 @@ static int origin_map(struct dm_target *ti, struct bio *bio,
 
 #define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
 
-/*
- * Set the target "split_io" field to the minimum of all the snapshots'
- * chunk sizes.
- */
-static void origin_resume(struct dm_target *ti)
+static chunk_t min_chunk_size(struct dm_dev *dev)
 {
-	struct dm_dev *dev = ti->private;
 	struct dm_snapshot *snap;
 	struct origin *o;
 	chunk_t chunk_size = 0;
@@ -1293,7 +1288,18 @@ static void origin_resume(struct dm_target *ti)
 			chunk_size = min_not_zero(chunk_size, snap->chunk_size);
 	up_read(&_origins_lock);
 
-	ti->split_io = chunk_size;
+	return chunk_size;
+}
+
+/*
+ * Set the target "split_io" field to the minimum of all the snapshots'
+ * chunk sizes.
+ */
+static void origin_resume(struct dm_target *ti)
+{
+	struct dm_dev *dev = ti->private;
+
+	ti->split_io = min_chunk_size(dev);
 }
 
 static int origin_status(struct dm_target *ti, status_type_t type, char *result,
-- 
1.5.4.1
