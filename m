From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm snapshot: avoid storing private suspended
	state
Date: Fri,  7 Jan 2011 13:21:36 -0500
Message-ID: <1294424496-4810-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

Use dm_suspended() rather than having each snapshot target maintain a
private 'suspended' flag in struct dm_snapshot.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -80,9 +80,6 @@ struct dm_snapshot {
 	/* Origin writes don't trigger exceptions until this is set */
 	int active;
 
-	/* Whether or not owning mapped_device is suspended */
-	int suspended;
-
 	atomic_t pending_exceptions_count;
 
 	mempool_t *pending_pool;
@@ -1110,7 +1107,6 @@ static int snapshot_ctr(struct dm_target
 	s->ti = ti;
 	s->valid = 1;
 	s->active = 0;
-	s->suspended = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
 	init_rwsem(&s->lock);
 	INIT_LIST_HEAD(&s->list);
@@ -1760,15 +1756,6 @@ static void snapshot_merge_presuspend(st
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
@@ -1783,7 +1770,7 @@ static int snapshot_preresume(struct dm_
 			DMERR("Unable to resume snapshot source until "
 			      "handover completes.");
 			r = -EINVAL;
-		} else if (!snap_src->suspended) {
+		} else if (!dm_suspended(snap_src->ti)) {
 			DMERR("Unable to perform snapshot handover until "
 			      "source is suspended.");
 			r = -EINVAL;
@@ -1816,7 +1803,6 @@ static void snapshot_resume(struct dm_ta
 
 	down_write(&s->lock);
 	s->active = 1;
-	s->suspended = 0;
 	up_write(&s->lock);
 }
 
@@ -2207,13 +2193,12 @@ static struct target_type origin_target 
 
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
@@ -2222,14 +2207,13 @@ static struct target_type snapshot_targe
 
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
