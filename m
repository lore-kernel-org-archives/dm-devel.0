From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3.10] dm snapshot: suspend origin when doing exception
 handover
Date: Wed, 3 Jun 2015 11:04:58 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1506031103530.14129@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is backport of b735fede8d957d9d255e9c5cf3964cfa59799637 for 3.10 
kernel.

commit b735fede8d957d9d255e9c5cf3964cfa59799637
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Thu Feb 26 11:40:35 2015 -0500

    dm snapshot: suspend origin when doing exception handover
    
    In the function snapshot_resume we perform exception store handover.  If
    there is another active snapshot target, the exception store is moved
    from this target to the target that is being resumed.
    
    The problem is that if there is some pending exception, it will point to
    an incorrect exception store after that handover, causing a crash due to
    dm-snap-persistent.c:get_exception()'s BUG_ON.
    
    This bug can be triggered by repeatedly changing snapshot permissions
    with "lvchange -p r" and "lvchange -p rw" while there are writes on the
    associated origin device.
    
    To fix this bug, we must suspend the origin device when doing the
    exception store handover to make sure that there are no pending
    exceptions:
    - introduce _origin_hash that keeps track of dm_origin structures.
    - introduce functions __lookup_dm_origin, __insert_dm_origin and
      __remove_dm_origin that manipulate the origin hash.
    - modify snapshot_resume so that it calls dm_internal_suspend_fast() and
      dm_internal_resume_fast() on the origin device.
    
    NOTE to stable@ people:
    
    When backporting to kernels 3.12-3.18, use dm_internal_suspend and
    dm_internal_resume instead of dm_internal_suspend_fast and
    dm_internal_resume_fast.
    
    When backporting to kernels older than 3.12, you need to pick functions
    dm_internal_suspend and dm_internal_resume from the commit
    fd2ed4d252701d3bbed4cd3e3d267ad469bb832a.
    
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>
    Cc: stable@vger.kernel.org

---
 drivers/md/dm-snap.c |   89 ++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/dm.c      |    2 +
 2 files changed, 84 insertions(+), 7 deletions(-)

Index: linux-stable/drivers/md/dm-snap.c
===================================================================
--- linux-stable.orig/drivers/md/dm-snap.c	2015-06-03 16:40:21.000000000 +0200
+++ linux-stable/drivers/md/dm-snap.c	2015-06-03 16:41:00.000000000 +0200
@@ -20,6 +20,8 @@
 #include <linux/log2.h>
 #include <linux/dm-kcopyd.h>
 
+#include "dm.h"
+
 #include "dm-exception-store.h"
 
 #define DM_MSG_PREFIX "snapshots"
@@ -271,12 +273,22 @@ struct origin {
 };
 
 /*
+ * This structure is allocated for each origin target
+ */
+struct dm_origin {
+	struct dm_dev *dev;
+	struct dm_target *ti;
+	struct list_head hash_list;
+};
+
+/*
  * Size of the hash table for origin volumes. If we make this
  * the size of the minors list then it should be nearly perfect
  */
 #define ORIGIN_HASH_SIZE 256
 #define ORIGIN_MASK      0xFF
 static struct list_head *_origins;
+static struct list_head *_dm_origins;
 static struct rw_semaphore _origins_lock;
 
 static DECLARE_WAIT_QUEUE_HEAD(_pending_exceptions_done);
@@ -290,12 +302,22 @@ static int init_origin_hash(void)
 	_origins = kmalloc(ORIGIN_HASH_SIZE * sizeof(struct list_head),
 			   GFP_KERNEL);
 	if (!_origins) {
-		DMERR("unable to allocate memory");
+		DMERR("unable to allocate memory for _origins");
 		return -ENOMEM;
 	}
-
 	for (i = 0; i < ORIGIN_HASH_SIZE; i++)
 		INIT_LIST_HEAD(_origins + i);
+
+	_dm_origins = kmalloc(ORIGIN_HASH_SIZE * sizeof(struct list_head),
+			      GFP_KERNEL);
+	if (!_dm_origins) {
+		DMERR("unable to allocate memory for _dm_origins");
+		kfree(_origins);
+		return -ENOMEM;
+	}
+	for (i = 0; i < ORIGIN_HASH_SIZE; i++)
+		INIT_LIST_HEAD(_dm_origins + i);
+
 	init_rwsem(&_origins_lock);
 
 	return 0;
@@ -304,6 +326,7 @@ static int init_origin_hash(void)
 static void exit_origin_hash(void)
 {
 	kfree(_origins);
+	kfree(_dm_origins);
 }
 
 static unsigned origin_hash(struct block_device *bdev)
@@ -330,6 +353,30 @@ static void __insert_origin(struct origi
 	list_add_tail(&o->hash_list, sl);
 }
 
+static struct dm_origin *__lookup_dm_origin(struct block_device *origin)
+{
+	struct list_head *ol;
+	struct dm_origin *o;
+
+	ol = &_dm_origins[origin_hash(origin)];
+	list_for_each_entry (o, ol, hash_list)
+		if (bdev_equal(o->dev->bdev, origin))
+			return o;
+
+	return NULL;
+}
+
+static void __insert_dm_origin(struct dm_origin *o)
+{
+	struct list_head *sl = &_dm_origins[origin_hash(o->dev->bdev)];
+	list_add_tail(&o->hash_list, sl);
+}
+
+static void __remove_dm_origin(struct dm_origin *o)
+{
+	list_del(&o->hash_list);
+}
+
 /*
  * _origins_lock must be held when calling this function.
  * Returns number of snapshots registered using the supplied cow device, plus:
@@ -1792,8 +1839,20 @@ static void snapshot_resume(struct dm_ta
 {
 	struct dm_snapshot *s = ti->private;
 	struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
+	struct dm_origin *o;
+	struct mapped_device *origin_md = NULL;
 
 	down_read(&_origins_lock);
+
+	o = __lookup_dm_origin(s->origin->bdev);
+	if (o)
+		origin_md = dm_table_get_md(o->ti->table);
+	if (origin_md == dm_table_get_md(ti->table))
+		origin_md = NULL;
+
+	if (origin_md)
+		dm_internal_suspend(origin_md);
+
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest) {
 		down_write(&snap_src->lock);
@@ -1802,6 +1861,10 @@ static void snapshot_resume(struct dm_ta
 		up_write(&snap_dest->lock);
 		up_write(&snap_src->lock);
 	}
+
+	if (origin_md)
+		dm_internal_resume(origin_md);
+
 	up_read(&_origins_lock);
 
 	/* Now we have correct chunk size, reregister */
@@ -2084,10 +2147,6 @@ static int origin_write_extent(struct dm
  * Origin: maps a linear range of a device, with hooks for snapshotting.
  */
 
-struct dm_origin {
-	struct dm_dev *dev;
-};
-
 /*
  * Construct an origin mapping: <dev_path>
  * The context for an origin is merely a 'struct dm_dev *'
@@ -2116,6 +2175,7 @@ static int origin_ctr(struct dm_target *
 		goto bad_open;
 	}
 
+	o->ti = ti;
 	ti->private = o;
 	ti->num_flush_bios = 1;
 
@@ -2130,6 +2190,7 @@ bad_alloc:
 static void origin_dtr(struct dm_target *ti)
 {
 	struct dm_origin *o = ti->private;
+
 	dm_put_device(ti, o->dev);
 	kfree(o);
 }
@@ -2155,6 +2216,19 @@ static void origin_resume(struct dm_targ
 	struct dm_origin *o = ti->private;
 
 	ti->max_io_len = get_origin_minimum_chunksize(o->dev->bdev);
+
+	down_write(&_origins_lock);
+	__insert_dm_origin(o);
+	up_write(&_origins_lock);
+}
+
+static void origin_postsuspend(struct dm_target *ti)
+{
+	struct dm_origin *o = ti->private;
+
+	down_write(&_origins_lock);
+	__remove_dm_origin(o);
+	up_write(&_origins_lock);
 }
 
 static void origin_status(struct dm_target *ti, status_type_t type,
@@ -2197,12 +2271,13 @@ static int origin_iterate_devices(struct
 
 static struct target_type origin_target = {
 	.name    = "snapshot-origin",
-	.version = {1, 8, 1},
+	.version = {1, 9, 0},
 	.module  = THIS_MODULE,
 	.ctr     = origin_ctr,
 	.dtr     = origin_dtr,
 	.map     = origin_map,
 	.resume  = origin_resume,
+	.postsuspend = origin_postsuspend,
 	.status  = origin_status,
 	.merge	 = origin_merge,
 	.iterate_devices = origin_iterate_devices,
Index: linux-stable/drivers/md/dm.c
===================================================================
--- linux-stable.orig/drivers/md/dm.c	2015-06-03 16:40:23.000000000 +0200
+++ linux-stable/drivers/md/dm.c	2015-06-03 16:41:00.000000000 +0200
@@ -2682,6 +2682,7 @@ void dm_internal_suspend(struct mapped_d
 	flush_workqueue(md->wq);
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
 }
+EXPORT_SYMBOL_GPL(dm_internal_suspend);
 
 void dm_internal_resume(struct mapped_device *md)
 {
@@ -2693,6 +2694,7 @@ void dm_internal_resume(struct mapped_de
 done:
 	mutex_unlock(&md->suspend_lock);
 }
+EXPORT_SYMBOL_GPL(dm_internal_resume);
 
 /*-----------------------------------------------------------------
  * Event notification.
