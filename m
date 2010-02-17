From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm snapshot: avoid storing private suspended
	state
Date: Wed, 17 Feb 2010 17:39:34 -0500
Message-ID: <1266446374-23771-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Use dm_suspended() rather than having each snapshot target maintain a
private 'suspended' flag in struct dm_snapshot.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   22 +++-------------------
 1 files changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index ee8eb28..72d2bff 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -80,9 +80,6 @@ struct dm_snapshot {
 	/* Origin writes don't trigger exceptions until this is set */
 	int active;
 
-	/* Whether or not owning mapped_device is suspended */
-	int suspended;
-
 	mempool_t *pending_pool;
 
 	atomic_t pending_exceptions_count;
@@ -1107,7 +1104,6 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->ti = ti;
 	s->valid = 1;
 	s->active = 0;
-	s->suspended = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
 	init_rwsem(&s->lock);
 	INIT_LIST_HEAD(&s->list);
@@ -1757,15 +1753,6 @@ static void snapshot_merge_presuspend(struct dm_target *ti)
 	stop_merge(s);
 }
 
-static void snapshot_postsuspend(struct dm_target *ti)
-{
-	struct dm_snapshot *s = ti->private;
-
-	down_write(&s->lock);
-	s->suspended = 1;
-	up_write(&s->lock);
-}
-
 static int snapshot_preresume(struct dm_target *ti)
 {
 	int r = 0;
@@ -1780,7 +1767,7 @@ static int snapshot_preresume(struct dm_target *ti)
 			DMERR("Unable to resume snapshot source until "
 			      "handover completes.");
 			r = -EINVAL;
-		} else if (!snap_src->suspended) {
+		} else if (!dm_suspended(snap_src->ti)) {
 			DMERR("Unable to perform snapshot handover until "
 			      "source is suspended.");
 			r = -EINVAL;
@@ -1813,7 +1800,6 @@ static void snapshot_resume(struct dm_target *ti)
 
 	down_write(&s->lock);
 	s->active = 1;
-	s->suspended = 0;
 	up_write(&s->lock);
 }
 
@@ -2183,13 +2169,12 @@ static struct target_type origin_target = {
 
 static struct target_type snapshot_target = {
 	.name    = "snapshot",
-	.version = {1, 9, 0},
+	.version = {1, 10, 0},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
 	.map     = snapshot_map,
 	.end_io  = snapshot_end_io,
-	.postsuspend = snapshot_postsuspend,
 	.preresume  = snapshot_preresume,
 	.resume  = snapshot_resume,
 	.status  = snapshot_status,
@@ -2198,14 +2183,13 @@ static struct target_type snapshot_target = {
 
 static struct target_type merge_target = {
 	.name    = dm_snapshot_merge_target_name,
-	.version = {1, 0, 0},
+	.version = {1, 1, 0},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
 	.map     = snapshot_merge_map,
 	.end_io  = snapshot_end_io,
 	.presuspend = snapshot_merge_presuspend,
-	.postsuspend = snapshot_postsuspend,
 	.preresume  = snapshot_preresume,
 	.resume  = snapshot_merge_resume,
 	.status  = snapshot_status,
