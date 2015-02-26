From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] dm-snapshot: suspend merging snapshot when
 doing exception handover
Date: Thu, 26 Feb 2015 11:41:28 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502261140380.13050@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

There was a bug when that resulted in a crash when there were pending
exceptions and snapshot exception store handover was performed at the
same time - and there was a patch that fixed it.

However, a similar problem exists in snapshot merging. When snapshot
merging is in progress, we use the target "snapshot-merge" instead of
"snapshot-origin". Consequently, during exception store handover, we must
find the snapshot-merge target and suspend it's associated md.

To avoid lockdep warnings, the target must be suspended and resumed
without holding _origins_lock.

This patch introduces a function dm_hold that grabs a reference on
mapped_device, but unlike dm_get, it doesn't crash if the devices has the
flag DMF_FREEING, it returns and error in this case.

In snapshot_resume we grab the reference to the origin device using
dm_hold while holding _origins_lock (_origins_lock guarantees that the
device won't disappear). Then we release _origins_lock, suspend the
device and grab _origins_lock again.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6-debug/drivers/md/dm-snap.c
===================================================================
--- linux-2.6-debug.orig/drivers/md/dm-snap.c
+++ linux-2.6-debug/drivers/md/dm-snap.c
@@ -1889,20 +1889,39 @@ static int snapshot_preresume(struct dm_
 static void snapshot_resume(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
-	struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
+	struct dm_snapshot *snap_src = NULL, *snap_dest = NULL, *snap_merging = NULL;
 	struct dm_origin *o;
 	struct mapped_device *origin_md = NULL;
+	bool must_restart_merging = false;
 
 	down_read(&_origins_lock);
 
 	o = __lookup_dm_origin(s->origin->bdev);
 	if (o)
 		origin_md = dm_table_get_md(o->ti->table);
+	if (!origin_md) {
+		(void) __find_snapshots_sharing_cow(s, NULL, NULL, &snap_merging);
+		if (snap_merging)
+			origin_md = dm_table_get_md(snap_merging->ti->table);
+	}
 	if (origin_md == dm_table_get_md(ti->table))
 		origin_md = NULL;
+	if (origin_md) {
+		if (dm_hold(origin_md))
+			origin_md = NULL;
+	}
+
+	up_read(&_origins_lock);
+
+	if (origin_md) {
+ 		dm_internal_suspend_fast(origin_md);
+		if (snap_merging && test_bit(RUNNING_MERGE, &snap_merging->state_bits)) {
+			must_restart_merging = true;
+			stop_merge(snap_merging);
+		}
+	}
 
-	if (origin_md)
-		dm_internal_suspend_fast(origin_md);
+	down_read(&_origins_lock);
 
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest) {
@@ -1913,11 +1932,15 @@ static void snapshot_resume(struct dm_ta
 		up_write(&snap_src->lock);
 	}
 
-	if (origin_md)
-		dm_internal_resume_fast(origin_md);
-
 	up_read(&_origins_lock);
 
+	if (origin_md) {
+		if (must_restart_merging)
+			start_merge(snap_merging);
+		dm_internal_resume_fast(origin_md);
+		dm_put(origin_md);
+	}
+
 	/* Now we have correct chunk size, reregister */
 	reregister_snapshot(s);
 
Index: linux-2.6-debug/include/linux/device-mapper.h
===================================================================
--- linux-2.6-debug.orig/include/linux/device-mapper.h
+++ linux-2.6-debug/include/linux/device-mapper.h
@@ -368,6 +368,7 @@ int dm_create(int minor, struct mapped_d
  */
 struct mapped_device *dm_get_md(dev_t dev);
 void dm_get(struct mapped_device *md);
+int dm_hold(struct mapped_device *md);
 void dm_put(struct mapped_device *md);
 
 /*
Index: linux-2.6-debug/drivers/md/dm.c
===================================================================
--- linux-2.6-debug.orig/drivers/md/dm.c
+++ linux-2.6-debug/drivers/md/dm.c
@@ -2507,6 +2507,19 @@ void dm_get(struct mapped_device *md)
 	BUG_ON(test_bit(DMF_FREEING, &md->flags));
 }
 
+int dm_hold(struct mapped_device *md)
+{
+	spin_lock(&_minor_lock);
+	if (test_bit(DMF_FREEING, &md->flags)) {
+		spin_unlock(&_minor_lock);
+		return -EBUSY;
+	}
+	dm_get(md);
+	spin_unlock(&_minor_lock);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_hold);
+
 const char *dm_device_name(struct mapped_device *md)
 {
 	return md->name;
@@ -2526,10 +2539,16 @@ static void __dm_destroy(struct mapped_d
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
+	/*
+	 * Take suspend_lock so that presuspend and postsuspend methods
+	 * do not race with internal suspend.
+	 */
+	mutex_lock(&md->suspend_lock);
 	if (!dm_suspended_md(md)) {
 		dm_table_presuspend_targets(map);
 		dm_table_postsuspend_targets(map);
 	}
+	mutex_unlock(&md->suspend_lock);
 
 	/* dm_put_live_table must be before msleep, otherwise deadlock is possible */
 	dm_put_live_table(md, srcu_idx);
