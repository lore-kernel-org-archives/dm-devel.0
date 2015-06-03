From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3.10,3.14] dm snapshot: suspend merging snapshot when doing
 exception handover
Date: Wed, 3 Jun 2015 11:06:18 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506031105050.14129@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is backport of 09ee96b21456883e108c3b00597bb37ec512151b for 3.10 and 
3.14.

commit 09ee96b21456883e108c3b00597bb37ec512151b
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Thu Feb 26 11:41:28 2015 -0500

    dm snapshot: suspend merging snapshot when doing exception handover
    
    The "dm snapshot: suspend origin when doing exception handover" commit
    fixed a exception store handover bug associated with pending exceptions
    to the "snapshot-origin" target.
    
    However, a similar problem exists in snapshot merging.  When snapshot
    merging is in progress, we use the target "snapshot-merge" instead of
    "snapshot-origin".  Consequently, during exception store handover, we
    must find the snapshot-merge target and suspend its associated
    mapped_device.
    
    To avoid lockdep warnings, the target must be suspended and resumed
    without holding _origins_lock.
    
    Introduce a dm_hold() function that grabs a reference on a
    mapped_device, but unlike dm_get(), it doesn't crash if the device has
    the DMF_FREEING flag set, it returns an error in this case.
    
    In snapshot_resume() we grab the reference to the origin device using
    dm_hold() while holding _origins_lock (_origins_lock guarantees that the
    device won't disappear).  Then we release _origins_lock, suspend the
    device and grab _origins_lock again.
    
    NOTE to stable@ people:
    When backporting to kernels 3.18 and older, use dm_internal_suspend and
    dm_internal_resume instead of dm_internal_suspend_fast and
    dm_internal_resume_fast.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Cc: stable@vger.kernel.org

---
 drivers/md/dm-snap.c          |   39 +++++++++++++++++++++++++++++++--------
 drivers/md/dm.c               |   13 +++++++++++++
 include/linux/device-mapper.h |    1 +
 3 files changed, 45 insertions(+), 8 deletions(-)

Index: linux-stable/drivers/md/dm-snap.c
===================================================================
--- linux-stable.orig/drivers/md/dm-snap.c	2015-06-02 18:34:42.000000000 +0200
+++ linux-stable/drivers/md/dm-snap.c	2015-06-02 18:36:01.000000000 +0200
@@ -1895,20 +1895,39 @@ static int snapshot_preresume(struct dm_
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
-	if (origin_md == dm_table_get_md(ti->table))
-		origin_md = NULL;
+	if (!origin_md) {
+		(void) __find_snapshots_sharing_cow(s, NULL, NULL, &snap_merging);
+		if (snap_merging)
+			origin_md = dm_table_get_md(snap_merging->ti->table);
+	}
+ 	if (origin_md == dm_table_get_md(ti->table))
+ 		origin_md = NULL;
+	if (origin_md) {
+		if (dm_hold(origin_md))
+			origin_md = NULL;
+	}
+
+	up_read(&_origins_lock);
 
-	if (origin_md)
+	if (origin_md) {
 		dm_internal_suspend(origin_md);
+		if (snap_merging && test_bit(RUNNING_MERGE, &snap_merging->state_bits)) {
+			must_restart_merging = true;
+			stop_merge(snap_merging);
+		}
+	}
+
+	down_read(&_origins_lock);
 
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest) {
@@ -1919,11 +1938,15 @@ static void snapshot_resume(struct dm_ta
 		up_write(&snap_src->lock);
 	}
 
-	if (origin_md)
-		dm_internal_resume(origin_md);
-
 	up_read(&_origins_lock);
 
+	if (origin_md) {
+		if (must_restart_merging)
+			start_merge(snap_merging);
+		dm_internal_resume(origin_md);
+		dm_put(origin_md);
+	}
+
 	/* Now we have correct chunk size, reregister */
 	reregister_snapshot(s);
 
@@ -2356,7 +2379,7 @@ static struct target_type snapshot_targe
 
 static struct target_type merge_target = {
 	.name    = dm_snapshot_merge_target_name,
-	.version = {1, 2, 0},
+	.version = {1, 3, 0},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
Index: linux-stable/drivers/md/dm.c
===================================================================
--- linux-stable.orig/drivers/md/dm.c	2015-06-02 18:34:42.000000000 +0200
+++ linux-stable/drivers/md/dm.c	2015-06-02 18:35:24.000000000 +0200
@@ -2333,6 +2333,19 @@ void dm_get(struct mapped_device *md)
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
Index: linux-stable/include/linux/device-mapper.h
===================================================================
--- linux-stable.orig/include/linux/device-mapper.h	2015-06-02 18:34:42.000000000 +0200
+++ linux-stable/include/linux/device-mapper.h	2015-06-02 18:35:24.000000000 +0200
@@ -373,6 +373,7 @@ int dm_create(int minor, struct mapped_d
  */
 struct mapped_device *dm_get_md(dev_t dev);
 void dm_get(struct mapped_device *md);
+int dm_hold(struct mapped_device *md);
 void dm_put(struct mapped_device *md);
 
 /*
