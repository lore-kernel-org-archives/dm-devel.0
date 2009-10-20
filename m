From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 02/17] dm snapshot: add suspended flag to
	dm_snapshot
Date: Tue, 20 Oct 2009 18:46:50 -0400
Message-ID: <1256078825-11331-3-git-send-email-snitzer@redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
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

Allow the snapshot target to be able to verify its state relative to a
requested operation.  Allows for invalid operations to be prevented,
e.g. an attempt handover an "old" snapshot's exceptions without it
having been suspended first.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 6181878..be37439 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -72,6 +72,9 @@ struct dm_snapshot {
 	/* Origin writes don't trigger exceptions until this is set */
 	int active;
 
+	/* Set if the parent device is suspended */
+	int suspended;
+
 	mempool_t *pending_pool;
 
 	atomic_t pending_exceptions_count;
@@ -632,6 +635,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	s->ti = ti;
 	s->valid = 1;
 	s->active = 0;
+	s->suspended = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
 	init_rwsem(&s->lock);
 	spin_lock_init(&s->pe_lock);
@@ -1138,12 +1142,22 @@ static int snapshot_end_io(struct dm_target *ti, struct bio *bio,
 	return 0;
 }
 
+static void snapshot_presuspend(struct dm_target *ti)
+{
+	struct dm_snapshot *s = ti->private;
+
+	down_write(&s->lock);
+	s->suspended = 1;
+	up_write(&s->lock);
+}
+
 static void snapshot_resume(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
 
 	down_write(&s->lock);
 	s->active = 1;
+	s->suspended = 0;
 	up_write(&s->lock);
 }
 
@@ -1434,12 +1448,13 @@ static struct target_type origin_target = {
 
 static struct target_type snapshot_target = {
 	.name    = "snapshot",
-	.version = {1, 8, 0},
+	.version = {1, 9, 0},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
 	.map     = snapshot_map,
 	.end_io  = snapshot_end_io,
+	.presuspend = snapshot_presuspend,
 	.resume  = snapshot_resume,
 	.status  = snapshot_status,
 	.iterate_devices = snapshot_iterate_devices,
-- 
1.6.5.rc2
