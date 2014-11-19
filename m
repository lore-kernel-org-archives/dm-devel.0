From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v3 3/4] dm: enhance internal suspend and
	resume interface
Date: Wed, 19 Nov 2014 11:34:46 -0500
Message-ID: <1416414887-23550-3-git-send-email-snitzer@redhat.com>
References: <1416414887-23550-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1416414887-23550-1-git-send-email-snitzer@redhat.com>
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

Rename dm_internal_{suspend,resume} to dm_internal_{suspend,resume}_fast
-- dm-stats will continue using these methods to avoid all the extra
suspend/resume logic that is not needed in order to quickly flush IO.

Introduce dm_internal_suspend_noflush() variant that actually calls the
mapped_device's target callbacks -- otherwise target-specific hooks are
avoided (e.g. dm-thin's thin_presuspend and thin_postsuspend).  Common
code between dm_internal_{suspend_noflush,resume} and
dm_{suspend,resume} was factored out as __dm_{suspend,resume}.

Update dm_internal_{suspend_noflush,resume} to always take and release
the mapped_device's suspend_lock.  Also update dm_{suspend,resume} to be
aware of potential for DM_INTERNAL_SUSPEND_FLAG to be set and respond
accordingly by interruptibly waiting for the DM_INTERNAL_SUSPEND_FLAG to
be cleared.  Add lockdep annotation to dm_suspend() and dm_resume().

Also add DM_INTERNAL_SUSPEND_FLAG to status report.  This new
DM_INTERNAL_SUSPEND_FLAG state is being tracked/reported to assist with
debugging (e.g. 'dmsetup info' will report an internally suspended
device accordingly).

The existing DM_SUSPEND_FLAG remains unchanged.
DM_INTERNAL_SUSPEND_FLAG is set by dm_internal_suspend_noflush() and
cleared by dm_internal_resume().

Both DM_SUSPEND_FLAG and DM_INTERNAL_SUSPEND_FLAG may be set if a device
was already suspended when dm_internal_suspend_noflush() was called --
this can be thought of as a "nested suspend".  A "nested suspend" can
with legacy userspace dm-thin code that might suspend all active thin
volumes before suspending the pool for resize.

But otherwise, in the normal dm-thin-pool suspend case moving forward:
the thin-pool will have DM_SUSPEND_FLAG set and all active thins from
that thin-pool will have DM_INTERNAL_SUSPEND_FLAG set.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-ioctl.c         |   5 +-
 drivers/md/dm-stats.c         |   2 +-
 drivers/md/dm.c               | 229 +++++++++++++++++++++++++++++++-----------
 drivers/md/dm.h               |   9 ++
 include/uapi/linux/dm-ioctl.h |   5 +
 5 files changed, 192 insertions(+), 58 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 0be9381..73f791b 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -684,11 +684,14 @@ static void __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 	int srcu_idx;
 
 	param->flags &= ~(DM_SUSPEND_FLAG | DM_READONLY_FLAG |
-			  DM_ACTIVE_PRESENT_FLAG);
+			  DM_ACTIVE_PRESENT_FLAG | DM_INTERNAL_SUSPEND_FLAG);
 
 	if (dm_suspended_md(md))
 		param->flags |= DM_SUSPEND_FLAG;
 
+	if (dm_suspended_internally_md(md))
+		param->flags |= DM_INTERNAL_SUSPEND_FLAG;
+
 	if (dm_test_deferred_remove_flag(md))
 		param->flags |= DM_DEFERRED_REMOVE;
 
diff --git a/drivers/md/dm-stats.c b/drivers/md/dm-stats.c
index 28a9012..42a057a 100644
--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -824,7 +824,7 @@ static int message_stats_create(struct mapped_device *md,
 		return 1;
 
 	id = dm_stats_create(dm_get_stats(md), start, end, step, program_id, aux_data,
-			     dm_internal_suspend, dm_internal_resume, md);
+			     dm_internal_suspend_fast, dm_internal_resume_fast, md);
 	if (id < 0)
 		return id;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f84de32..a0ece87 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -19,6 +19,7 @@
 #include <linux/idr.h>
 #include <linux/hdreg.h>
 #include <linux/delay.h>
+#include <linux/wait.h>
 
 #include <trace/events/block.h>
 
@@ -117,6 +118,7 @@ EXPORT_SYMBOL_GPL(dm_get_rq_mapinfo);
 #define DMF_NOFLUSH_SUSPENDING 5
 #define DMF_MERGE_IS_OPTIONAL 6
 #define DMF_DEFERRED_REMOVE 7
+#define DMF_SUSPENDED_INTERNALLY 8
 
 /*
  * A dummy definition to make RCU happy.
@@ -2718,36 +2720,18 @@ static void unlock_fs(struct mapped_device *md)
 }
 
 /*
- * We need to be able to change a mapping table under a mounted
- * filesystem.  For example we might want to move some data in
- * the background.  Before the table can be swapped with
- * dm_bind_table, dm_suspend must be called to flush any in
- * flight bios and ensure that any further io gets deferred.
- */
-/*
- * Suspend mechanism in request-based dm.
- *
- * 1. Flush all I/Os by lock_fs() if needed.
- * 2. Stop dispatching any I/O by stopping the request_queue.
- * 3. Wait for all in-flight I/Os to be completed or requeued.
+ * If __dm_suspend returns 0, the device is completely quiescent
+ * now. There is no request-processing activity. All new requests
+ * are being added to md->deferred list.
  *
- * To abort suspend, start the request_queue.
+ * Caller must hold md->suspend_lock
  */
-int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
+static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
+			unsigned suspend_flags, int interruptible)
 {
-	struct dm_table *map = NULL;
-	int r = 0;
-	int do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG ? 1 : 0;
-	int noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG ? 1 : 0;
-
-	mutex_lock(&md->suspend_lock);
-
-	if (dm_suspended_md(md)) {
-		r = -EINVAL;
-		goto out_unlock;
-	}
-
-	map = rcu_dereference(md->map);
+	bool do_lockfs = suspend_flags & DM_SUSPEND_LOCKFS_FLAG;
+	bool noflush = suspend_flags & DM_SUSPEND_NOFLUSH_FLAG;
+	int r;
 
 	/*
 	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
@@ -2772,7 +2756,7 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 		r = lock_fs(md);
 		if (r) {
 			dm_table_presuspend_undo_targets(map);
-			goto out_unlock;
+			return r;
 		}
 	}
 
@@ -2806,7 +2790,7 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 	 * We call dm_wait_for_completion to wait for all existing requests
 	 * to finish.
 	 */
-	r = dm_wait_for_completion(md, TASK_INTERRUPTIBLE);
+	r = dm_wait_for_completion(md, interruptible);
 
 	if (noflush)
 		clear_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
@@ -2822,14 +2806,55 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 
 		unlock_fs(md);
 		dm_table_presuspend_undo_targets(map);
-		goto out_unlock; /* pushback list is already flushed, so skip flush */
+		/* pushback list is already flushed, so skip flush */
 	}
 
-	/*
-	 * If dm_wait_for_completion returned 0, the device is completely
-	 * quiescent now. There is no request-processing activity. All new
-	 * requests are being added to md->deferred list.
-	 */
+	return r;
+}
+
+/*
+ * We need to be able to change a mapping table under a mounted
+ * filesystem.  For example we might want to move some data in
+ * the background.  Before the table can be swapped with
+ * dm_bind_table, dm_suspend must be called to flush any in
+ * flight bios and ensure that any further io gets deferred.
+ */
+/*
+ * Suspend mechanism in request-based dm.
+ *
+ * 1. Flush all I/Os by lock_fs() if needed.
+ * 2. Stop dispatching any I/O by stopping the request_queue.
+ * 3. Wait for all in-flight I/Os to be completed or requeued.
+ *
+ * To abort suspend, start the request_queue.
+ */
+int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
+{
+	struct dm_table *map = NULL;
+	int r = 0;
+
+retry:
+	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
+
+	if (dm_suspended_md(md)) {
+		r = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (dm_suspended_internally_md(md)) {
+		/* already internally suspended, wait for internal resume */
+		mutex_unlock(&md->suspend_lock);
+		r = wait_on_bit(&md->flags, DMF_SUSPENDED_INTERNALLY, TASK_INTERRUPTIBLE);
+		if (r)
+			return r;
+		goto retry;
+	}
+
+	map = rcu_dereference(md->map);
+
+	r = __dm_suspend(md, map, suspend_flags, TASK_INTERRUPTIBLE);
+	if (r)
+		goto out_unlock;
 
 	set_bit(DMF_SUSPENDED, &md->flags);
 
@@ -2840,35 +2865,57 @@ out_unlock:
 	return r;
 }
 
+static int __dm_resume(struct mapped_device *md, struct dm_table *map)
+{
+	if (map) {
+		int r = dm_table_resume_targets(map);
+		if (r)
+			return r;
+	}
+
+	dm_queue_flush(md);
+
+	/*
+	 * Flushing deferred I/Os must be done after targets are resumed
+	 * so that mapping of targets can work correctly.
+	 * Request-based dm is queueing the deferred I/Os in its request_queue.
+	 */
+	if (dm_request_based(md))
+		start_queue(md->queue);
+
+	unlock_fs(md);
+
+	return 0;
+}
+
 int dm_resume(struct mapped_device *md)
 {
 	int r = -EINVAL;
 	struct dm_table *map = NULL;
 
-	mutex_lock(&md->suspend_lock);
+retry:
+	mutex_lock_nested(&md->suspend_lock, SINGLE_DEPTH_NESTING);
+
 	if (!dm_suspended_md(md))
 		goto out;
 
+	if (dm_suspended_internally_md(md)) {
+		/* already internally suspended, wait for internal resume */
+		mutex_unlock(&md->suspend_lock);
+		r = wait_on_bit(&md->flags, DMF_SUSPENDED_INTERNALLY, TASK_INTERRUPTIBLE);
+		if (r)
+			return r;
+		goto retry;
+	}
+
 	map = rcu_dereference(md->map);
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
-	r = dm_table_resume_targets(map);
+	r = __dm_resume(md, map);
 	if (r)
 		goto out;
 
-	dm_queue_flush(md);
-
-	/*
-	 * Flushing deferred I/Os must be done after targets are resumed
-	 * so that mapping of targets can work correctly.
-	 * Request-based dm is queueing the deferred I/Os in its request_queue.
-	 */
-	if (dm_request_based(md))
-		start_queue(md->queue);
-
-	unlock_fs(md);
-
 	clear_bit(DMF_SUSPENDED, &md->flags);
 
 	r = 0;
@@ -2882,15 +2929,80 @@ out:
  * Internal suspend/resume works like userspace-driven suspend. It waits
  * until all bios finish and prevents issuing new bios to the target drivers.
  * It may be used only from the kernel.
- *
- * Internal suspend holds md->suspend_lock, which prevents interaction with
- * userspace-driven suspend.
  */
 
-void dm_internal_suspend(struct mapped_device *md)
+static void __dm_internal_suspend(struct mapped_device *md, unsigned suspend_flags)
 {
-	mutex_lock(&md->suspend_lock);
+	struct dm_table *map = NULL;
+
+	if (dm_suspended_internally_md(md))
+		return; /* nested internal suspend */
+
+	if (dm_suspended_md(md)) {
+		set_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);
+		return; /* nest suspend */
+	}
+
+	map = rcu_dereference(md->map);
+
+	/*
+	 * Using TASK_UNINTERRUPTIBLE because only NOFLUSH internal suspend is
+	 * supported.  Properly supporting a TASK_INTERRUPTIBLE internal suspend
+	 * would require changing .presuspend to return an error -- avoid this
+	 * until there is a need for more elaborate variants of internal suspend.
+	 */
+	(void) __dm_suspend(md, map, suspend_flags, TASK_UNINTERRUPTIBLE);
+
+	set_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);
+
+	dm_table_postsuspend_targets(map);
+}
+
+static void __dm_internal_resume(struct mapped_device *md)
+{
+	if (!dm_suspended_internally_md(md))
+		return; /* resume from nested internal suspend */
+
 	if (dm_suspended_md(md))
+		goto done; /* resume from nested suspend */
+
+	/*
+	 * NOTE: existing callers don't need to call dm_table_resume_targets
+	 * (which may fail -- so best to avoid it for now by passing NULL map)
+	 */
+	(void) __dm_resume(md, NULL);
+
+done:
+	clear_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);
+	smp_mb__after_atomic();
+	wake_up_bit(&md->flags, DMF_SUSPENDED_INTERNALLY);
+}
+
+void dm_internal_suspend_noflush(struct mapped_device *md)
+{
+	mutex_lock(&md->suspend_lock);
+	__dm_internal_suspend(md, DM_SUSPEND_NOFLUSH_FLAG);
+	mutex_unlock(&md->suspend_lock);
+}
+EXPORT_SYMBOL_GPL(dm_internal_suspend_noflush);
+
+void dm_internal_resume(struct mapped_device *md)
+{
+	mutex_lock(&md->suspend_lock);
+	__dm_internal_resume(md);
+	mutex_unlock(&md->suspend_lock);
+}
+EXPORT_SYMBOL_GPL(dm_internal_resume);
+
+/*
+ * Fast variants of internal suspend/resume hold md->suspend_lock,
+ * which prevents interaction with userspace-driven suspend.
+ */
+
+void dm_internal_suspend_fast(struct mapped_device *md)
+{
+	mutex_lock(&md->suspend_lock);
+	if (dm_suspended_md(md) || dm_suspended_internally_md(md))
 		return;
 
 	set_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags);
@@ -2899,9 +3011,9 @@ void dm_internal_suspend(struct mapped_device *md)
 	dm_wait_for_completion(md, TASK_UNINTERRUPTIBLE);
 }
 
-void dm_internal_resume(struct mapped_device *md)
+void dm_internal_resume_fast(struct mapped_device *md)
 {
-	if (dm_suspended_md(md))
+	if (dm_suspended_md(md) || dm_suspended_internally_md(md))
 		goto done;
 
 	dm_queue_flush(md);
@@ -2987,6 +3099,11 @@ int dm_suspended_md(struct mapped_device *md)
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+int dm_suspended_internally_md(struct mapped_device *md)
+{
+	return test_bit(DMF_SUSPENDED_INTERNALLY, &md->flags);
+}
+
 int dm_test_deferred_remove_flag(struct mapped_device *md)
 {
 	return test_bit(DMF_DEFERRED_REMOVE, &md->flags);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 7819940..84b0f9e4 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -130,6 +130,15 @@ int dm_deleting_md(struct mapped_device *md);
 int dm_suspended_md(struct mapped_device *md);
 
 /*
+ * Internal suspend and resume methods.
+ */
+int dm_suspended_internally_md(struct mapped_device *md);
+void dm_internal_suspend_fast(struct mapped_device *md);
+void dm_internal_resume_fast(struct mapped_device *md);
+void dm_internal_suspend_noflush(struct mapped_device *md);
+void dm_internal_resume(struct mapped_device *md);
+
+/*
  * Test if the device is scheduled for deferred remove.
  */
 int dm_test_deferred_remove_flag(struct mapped_device *md);
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 2be66f4..a570d7b 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -352,4 +352,9 @@ enum {
  */
 #define DM_DEFERRED_REMOVE		(1 << 17) /* In/Out */
 
+/*
+ * If set, the device is suspended internally.
+ */
+#define DM_INTERNAL_SUSPEND_FLAG	(1 << 18) /* Out */
+
 #endif				/* _LINUX_DM_IOCTL_H */
-- 
1.9.3
