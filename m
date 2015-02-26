From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/2] dm-snapshot: suspend origin when doing
 exception handover
Date: Thu, 26 Feb 2015 11:40:35 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1502261137120.13050@file01.intranet.prod.int.rdu2.redhat.com>
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

In the function snapshot_resume we perform exception store handover. If
there is another active snapshot target, the exception store is moved from
this target to the target that is being resume.

The problem is that if there is some pending exception, it will point to
an incorrect exception store after that handover, causing crash in BUG in
dm-snap-persistent.c:get_exception - see bug 1177389.

This bug can be triggered by repeatedly changing snapshot permissions with
"lvchange -p r" and "lvchange -p rw" while there are writes on the
associated origin device.

To fix this bug, we must suspend the origin device when doing the
exception store handover to make sure that there is no pending exception.

This patch:
- introdices _origin_hash that keeps track of dm_origin structures.
- introduces function __lookup_dm_origin, __insert_dm_origin and
  __remove_dm_origin that manipulate the origin hash.
- modifies snapshot_resume so that it calls dm_internal_suspend_fast and
  dm_internal_resume_fast on the origin device.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   70 ++++++++++++++++++++++++++++++++++++++++++++++-----
 drivers/md/dm.c      |    2 +
 2 files changed, 66 insertions(+), 6 deletions(-)

Index: linux-2.6-debug/drivers/md/dm-snap.c
===================================================================
--- linux-2.6-debug.orig/drivers/md/dm-snap.c
+++ linux-2.6-debug/drivers/md/dm-snap.c
@@ -20,6 +20,8 @@
 #include <linux/log2.h>
 #include <linux/dm-kcopyd.h>
 
+#include "dm.h"
+
 #include "dm-exception-store.h"
 
 #define DM_MSG_PREFIX "snapshots"
@@ -291,12 +293,23 @@ struct origin {
 };
 
 /*
+ * This structure is allocated for each origin target
+ */
+struct dm_origin {
+	struct dm_dev *dev;
+	struct dm_target *ti;
+	unsigned split_boundary;
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
@@ -313,9 +326,20 @@ static int init_origin_hash(void)
 		DMERR("unable to allocate memory");
 		return -ENOMEM;
 	}
-
 	for (i = 0; i < ORIGIN_HASH_SIZE; i++)
 		INIT_LIST_HEAD(_origins + i);
+
+	_dm_origins = kmalloc(ORIGIN_HASH_SIZE * sizeof(struct list_head),
+			   GFP_KERNEL);
+	if (!_dm_origins) {
+		DMERR("unable to allocate memory");
+		kfree(_origins);
+		return -ENOMEM;
+	}
+	for (i = 0; i < ORIGIN_HASH_SIZE; i++)
+		INIT_LIST_HEAD(_dm_origins + i);
+
+
 	init_rwsem(&_origins_lock);
 
 	return 0;
@@ -324,6 +348,7 @@ static int init_origin_hash(void)
 static void exit_origin_hash(void)
 {
 	kfree(_origins);
+	kfree(_dm_origins);
 }
 
 static unsigned origin_hash(struct block_device *bdev)
@@ -350,6 +375,30 @@ static void __insert_origin(struct origi
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
@@ -1841,8 +1890,20 @@ static void snapshot_resume(struct dm_ta
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
+		dm_internal_suspend_fast(origin_md);
+
 	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest, NULL);
 	if (snap_src && snap_dest) {
 		down_write(&snap_src->lock);
@@ -1851,6 +1912,10 @@ static void snapshot_resume(struct dm_ta
 		up_write(&snap_dest->lock);
 		up_write(&snap_src->lock);
 	}
+
+	if (origin_md)
+		dm_internal_resume_fast(origin_md);
+
 	up_read(&_origins_lock);
 
 	/* Now we have correct chunk size, reregister */
@@ -2133,11 +2198,6 @@ static int origin_write_extent(struct dm
  * Origin: maps a linear range of a device, with hooks for snapshotting.
  */
 
-struct dm_origin {
-	struct dm_dev *dev;
-	unsigned split_boundary;
-};
-
 /*
  * Construct an origin mapping: <dev_path>
  * The context for an origin is merely a 'struct dm_dev *'
@@ -2166,6 +2226,7 @@ static int origin_ctr(struct dm_target *
 		goto bad_open;
 	}
 
+	o->ti = ti;
 	ti->private = o;
 	ti->num_flush_bios = 1;
 
@@ -2180,6 +2241,7 @@ bad_alloc:
 static void origin_dtr(struct dm_target *ti)
 {
 	struct dm_origin *o = ti->private;
+
 	dm_put_device(ti, o->dev);
 	kfree(o);
 }
@@ -2216,6 +2278,19 @@ static void origin_resume(struct dm_targ
 	struct dm_origin *o = ti->private;
 
 	o->split_boundary = get_origin_minimum_chunksize(o->dev->bdev);
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
@@ -2264,6 +2339,7 @@ static struct target_type origin_target
 	.dtr     = origin_dtr,
 	.map     = origin_map,
 	.resume  = origin_resume,
+	.postsuspend = origin_postsuspend,
 	.status  = origin_status,
 	.merge	 = origin_merge,
 	.iterate_devices = origin_iterate_devices,
Index: linux-2.6-debug/drivers/md/dm.c
===================================================================
--- linux-2.6-debug.orig/drivers/md/dm.c
+++ linux-2.6-debug/drivers/md/dm.c
@@ -3001,6 +3001,7 @@ void dm_internal_suspend_fast(struct map
 	flush_workqueue(md->wq);
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
 }
+EXPORT_SYMBOL_GPL(dm_internal_suspend_fast);
 
 void dm_internal_resume_fast(struct mapped_device *md)
 {
@@ -3012,6 +3013,7 @@ void dm_internal_resume_fast(struct mapp
 done:
 	mutex_unlock(&md->suspend_lock);
 }
+EXPORT_SYMBOL_GPL(dm_internal_resume_fast);
 
 /*-----------------------------------------------------------------
  * Event notification.
