From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-3.19 PATCH v3 1/4] dm: add presuspend_undo hook to
	target_type
Date: Wed, 19 Nov 2014 11:34:44 -0500
Message-ID: <1416414887-23550-1-git-send-email-snitzer@redhat.com>
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

The DM thin-pool target now must undo the changes performed during
pool_presuspend() so introduce presuspend_undo hook in target_type.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm-table.c         | 36 +++++++++++++++++++++++++++++-------
 drivers/md/dm.c               | 10 ++++++++--
 drivers/md/dm.h               |  1 +
 include/linux/device-mapper.h |  2 ++
 include/uapi/linux/dm-ioctl.h |  4 ++--
 5 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index b2bd1eb..3afae9e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1521,18 +1521,32 @@ fmode_t dm_table_get_mode(struct dm_table *t)
 }
 EXPORT_SYMBOL(dm_table_get_mode);
 
-static void suspend_targets(struct dm_table *t, unsigned postsuspend)
+enum suspend_mode {
+	PRESUSPEND,
+	PRESUSPEND_UNDO,
+	POSTSUSPEND,
+};
+
+static void suspend_targets(struct dm_table *t, enum suspend_mode mode)
 {
 	int i = t->num_targets;
 	struct dm_target *ti = t->targets;
 
 	while (i--) {
-		if (postsuspend) {
+		switch (mode) {
+		case PRESUSPEND:
+			if (ti->type->presuspend)
+				ti->type->presuspend(ti);
+			break;
+		case PRESUSPEND_UNDO:
+			if (ti->type->presuspend_undo)
+				ti->type->presuspend_undo(ti);
+			break;
+		case POSTSUSPEND:
 			if (ti->type->postsuspend)
 				ti->type->postsuspend(ti);
-		} else if (ti->type->presuspend)
-			ti->type->presuspend(ti);
-
+			break;
+		}
 		ti++;
 	}
 }
@@ -1542,7 +1556,15 @@ void dm_table_presuspend_targets(struct dm_table *t)
 	if (!t)
 		return;
 
-	suspend_targets(t, 0);
+	suspend_targets(t, PRESUSPEND);
+}
+
+void dm_table_presuspend_undo_targets(struct dm_table *t)
+{
+	if (!t)
+		return;
+
+	suspend_targets(t, PRESUSPEND_UNDO);
 }
 
 void dm_table_postsuspend_targets(struct dm_table *t)
@@ -1550,7 +1572,7 @@ void dm_table_postsuspend_targets(struct dm_table *t)
 	if (!t)
 		return;
 
-	suspend_targets(t, 1);
+	suspend_targets(t, POSTSUSPEND);
 }
 
 int dm_table_resume_targets(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f8cdd97..f84de32 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2756,7 +2756,10 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 	if (noflush)
 		set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
 
-	/* This does not get reverted if there's an error later. */
+	/*
+	 * This gets reverted if there's an error later and the targets
+	 * provide the .presuspend_undo hook.
+	 */
 	dm_table_presuspend_targets(map);
 
 	/*
@@ -2767,8 +2770,10 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 	 */
 	if (!noflush && do_lockfs) {
 		r = lock_fs(md);
-		if (r)
+		if (r) {
+			dm_table_presuspend_undo_targets(map);
 			goto out_unlock;
+		}
 	}
 
 	/*
@@ -2816,6 +2821,7 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 			start_queue(md->queue);
 
 		unlock_fs(md);
+		dm_table_presuspend_undo_targets(map);
 		goto out_unlock; /* pushback list is already flushed, so skip flush */
 	}
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 988c7fb..7819940 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -65,6 +65,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits);
 struct list_head *dm_table_get_devices(struct dm_table *t);
 void dm_table_presuspend_targets(struct dm_table *t);
+void dm_table_presuspend_undo_targets(struct dm_table *t);
 void dm_table_postsuspend_targets(struct dm_table *t);
 int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index e1707de..ca6d2ac 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -64,6 +64,7 @@ typedef int (*dm_request_endio_fn) (struct dm_target *ti,
 				    union map_info *map_context);
 
 typedef void (*dm_presuspend_fn) (struct dm_target *ti);
+typedef void (*dm_presuspend_undo_fn) (struct dm_target *ti);
 typedef void (*dm_postsuspend_fn) (struct dm_target *ti);
 typedef int (*dm_preresume_fn) (struct dm_target *ti);
 typedef void (*dm_resume_fn) (struct dm_target *ti);
@@ -145,6 +146,7 @@ struct target_type {
 	dm_endio_fn end_io;
 	dm_request_endio_fn rq_end_io;
 	dm_presuspend_fn presuspend;
+	dm_presuspend_undo_fn presuspend_undo;
 	dm_postsuspend_fn postsuspend;
 	dm_preresume_fn preresume;
 	dm_resume_fn resume;
diff --git a/include/uapi/linux/dm-ioctl.h b/include/uapi/linux/dm-ioctl.h
index 3315ab2..2be66f4 100644
--- a/include/uapi/linux/dm-ioctl.h
+++ b/include/uapi/linux/dm-ioctl.h
@@ -267,9 +267,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	28
+#define DM_VERSION_MINOR	29
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2014-09-17)"
+#define DM_VERSION_EXTRA	"-ioctl (2014-10-28)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
-- 
1.9.3
