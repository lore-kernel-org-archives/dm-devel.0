From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm snapshot: revise snapshot_resume's exception
	handover
Date: Wed,  4 Nov 2009 16:45:40 -0500
Message-ID: <1257371140-18483-1-git-send-email-snitzer@redhat.com>
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

Until now snapshot_resume only allowed the resuming snapshot to get the
exception store from another snapshot.

Revise snapshot_resume's exception handover to allow a snapshot to
handover its exceptions to another snapshot prior to resuming.

This is needed to accomodate the following sequence:
new_snapshot->ctr
old_snapshot->suspend
old_snapshot->resume
new_snapshot->resume

lvm2 relies on this sequence if 'lvchange --refresh' is used to start a
snapshot merge that was deferred until both origin and snapshot were not
in use.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

Index: linux-2.6-dev/drivers/md/dm-snap.c
===================================================================
--- linux-2.6-dev.orig/drivers/md/dm-snap.c
+++ linux-2.6-dev/drivers/md/dm-snap.c
@@ -1268,16 +1268,27 @@ static void snapshot_resume(struct dm_ta
 	struct dm_snapshot *s = ti->private;
 
 	down_write(&s->lock);
-	if (s->handover) {
-		/* Get exception store from another snapshot */
+	if (s->handover_snap) {
+		/*
+		 * Initially assumes this snapshot will get
+		 * exception store from another snapshot
+		 */
 		struct dm_snapshot *old_snap = s->handover_snap;
-		BUG_ON(!old_snap);
-		down_write_nested(&old_snap->lock, SINGLE_DEPTH_NESTING);
-		handover_exceptions(old_snap, s);
-		up_write(&old_snap->lock);
+		struct dm_snapshot *new_snap = s;
+		struct dm_snapshot *lock_snap = old_snap;
+		if (!s->handover) {
+			/* Handover exceptions to another snapshot */
+			old_snap = s;
+			new_snap = s->handover_snap;
+			lock_snap = new_snap;
+		}
+		down_write_nested(&lock_snap->lock,
+				  SINGLE_DEPTH_NESTING);
+		handover_exceptions(old_snap, new_snap);
+		up_write(&lock_snap->lock);
 	}
 	/* An incomplete exception handover is not allowed */
-	BUG_ON(s->handover || s->handover_snap);
+	BUG_ON(s->handover_snap);
 	s->active = 1;
 	s->suspended = 0;
 	up_write(&s->lock);
