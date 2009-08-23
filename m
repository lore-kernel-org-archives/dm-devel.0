From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm snapshot: implement .iterate_devices
Date: Sun, 23 Aug 2009 02:11:07 -0400
Message-ID: <1251007867-13004-1-git-send-email-snitzer@redhat.com>
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
Cc: linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

This patch implements .iterate_devices for the origin and snapshot
targets.  dm-snapshot's lack of .iterate_devices resulted in the
inability to properly establish queue_limits for both targets.  

With 4K sector drives: an unfortunate side-effect of not establishing
proper limits in either targets' DM device was that IO to the devices
would fail even though both had been created without error.

Commit af4874e03ed82f050d5872d8c39ce64bf16b5c38 should have implemented
.iterate_devices for dm-snap.c's origin and snapshot targets.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>

---
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index d573165..57f1bf7 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1176,6 +1176,15 @@ static int snapshot_status(struct dm_target *ti, status_type_t type,
 	return 0;
 }
 
+static int snapshot_iterate_devices(struct dm_target *ti,
+				    iterate_devices_callout_fn fn, void *data)
+{
+	struct dm_snapshot *snap = ti->private;
+
+	return fn(ti, snap->origin, 0, ti->len, data);
+}
+
+
 /*-----------------------------------------------------------------
  * Origin methods
  *---------------------------------------------------------------*/
@@ -1410,20 +1419,29 @@ static int origin_status(struct dm_target *ti, status_type_t type, char *result,
 	return 0;
 }
 
+static int origin_iterate_devices(struct dm_target *ti,
+				  iterate_devices_callout_fn fn, void *data)
+{
+	struct dm_dev *dev = ti->private;
+
+	return fn(ti, dev, 0, ti->len, data);
+}
+
 static struct target_type origin_target = {
 	.name    = "snapshot-origin",
-	.version = {1, 6, 0},
+	.version = {1, 7, 0},
 	.module  = THIS_MODULE,
 	.ctr     = origin_ctr,
 	.dtr     = origin_dtr,
 	.map     = origin_map,
 	.resume  = origin_resume,
 	.status  = origin_status,
+	.iterate_devices = origin_iterate_devices,
 };
 
 static struct target_type snapshot_target = {
 	.name    = "snapshot",
-	.version = {1, 6, 0},
+	.version = {1, 7, 0},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
@@ -1431,6 +1449,7 @@ static struct target_type snapshot_target = {
 	.end_io  = snapshot_end_io,
 	.resume  = snapshot_resume,
 	.status  = snapshot_status,
+	.iterate_devices = snapshot_iterate_devices,
 };
 
 static int __init dm_snapshot_init(void)
