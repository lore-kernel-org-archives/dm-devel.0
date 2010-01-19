From: Takahiro Yasui <tyasui@redhat.com>
Subject: [RFC][PATCH 1/3] dm: introduce a presuspend cancel
	framework
Date: Tue, 19 Jan 2010 15:41:19 -0500
Message-ID: <4B5618EF.3060609@redhat.com>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch introduces a framework to cancel state changes done by
a target specific presuspend function.


Signed-off-by: Takahiro Yasui <tyasui@redhat.com>
---
 drivers/md/dm-table.c         |   36 +++++++++++++++++++++++++++++++-----
 drivers/md/dm.c               |    8 ++++++--
 drivers/md/dm.h               |    1 +
 include/linux/device-mapper.h |    2 ++
 4 files changed, 40 insertions(+), 7 deletions(-)

Index: linux-2.6.33-rc1-dm/drivers/md/dm-table.c
===================================================================
--- linux-2.6.33-rc1-dm.orig/drivers/md/dm-table.c
+++ linux-2.6.33-rc1-dm/drivers/md/dm-table.c
@@ -26,6 +26,13 @@
 #define KEYS_PER_NODE (NODE_SIZE / sizeof(sector_t))
 #define CHILDREN_PER_NODE (KEYS_PER_NODE + 1)
 
+/* Type of suspend */
+enum suspend_action {
+	PRESUSPEND,
+	POSTSUSPEND,
+	CANCEL_PRESUSPEND,
+};
+
 /*
  * The table has always exactly one reference from either mapped_device->map
  * or hash_cell->new_map. This reference is not counted in table->holders.
@@ -1129,17 +1136,28 @@ fmode_t dm_table_get_mode(struct dm_tabl
 	return t->mode;
 }
 
-static void suspend_targets(struct dm_table *t, unsigned postsuspend)
+static void suspend_targets(struct dm_table *t, enum suspend_action action)
 {
 	int i = t->num_targets;
 	struct dm_target *ti = t->targets;
 
 	while (i--) {
-		if (postsuspend) {
+		switch (action) {
+		case PRESUSPEND:
+			if (ti->type->presuspend)
+				ti->type->presuspend(ti);
+			break;
+
+		case POSTSUSPEND:
 			if (ti->type->postsuspend)
 				ti->type->postsuspend(ti);
-		} else if (ti->type->presuspend)
-			ti->type->presuspend(ti);
+			break;
+
+		case CANCEL_PRESUSPEND:
+			if (ti->type->cancel_presuspend)
+				ti->type->cancel_presuspend(ti);
+			break;
+		}
 
 		ti++;
 	}
@@ -1158,7 +1176,15 @@ void dm_table_postsuspend_targets(struct
 	if (!t)
 		return;
 
-	suspend_targets(t, 1);
+	suspend_targets(t, POSTSUSPEND);
+}
+
+void dm_table_cancel_presuspend_targets(struct dm_table *t)
+{
+	if (!t)
+		return;
+
+	suspend_targets(t, CANCEL_PRESUSPEND);
 }
 
 int dm_table_resume_targets(struct dm_table *t)
Index: linux-2.6.33-rc1-dm/drivers/md/dm.c
===================================================================
--- linux-2.6.33-rc1-dm.orig/drivers/md/dm.c
+++ linux-2.6.33-rc1-dm/drivers/md/dm.c
@@ -2475,7 +2475,6 @@ int dm_suspend(struct mapped_device *md,
 	if (noflush)
 		set_bit(DMF_NOFLUSH_SUSPENDING, &md->flags);
 
-	/* This does not get reverted if there's an error later. */
 	dm_table_presuspend_targets(map);
 
 	/*
@@ -2486,8 +2485,10 @@ int dm_suspend(struct mapped_device *md,
 	 */
 	if (!noflush && do_lockfs) {
 		r = lock_fs(md);
-		if (r)
+		if (r) {
+			dm_table_cancel_presuspend_targets(map);
 			goto out;
+		}
 	}
 
 	/*
@@ -2541,6 +2542,9 @@ int dm_suspend(struct mapped_device *md,
 			start_queue(md->queue);
 
 		unlock_fs(md);
+
+		dm_table_cancel_presuspend_targets(map);
+
 		goto out; /* pushback list is already flushed, so skip flush */
 	}
 
Index: linux-2.6.33-rc1-dm/drivers/md/dm.h
===================================================================
--- linux-2.6.33-rc1-dm.orig/drivers/md/dm.h
+++ linux-2.6.33-rc1-dm/drivers/md/dm.h
@@ -56,6 +56,7 @@ void dm_table_set_restrictions(struct dm
 struct list_head *dm_table_get_devices(struct dm_table *t);
 void dm_table_presuspend_targets(struct dm_table *t);
 void dm_table_postsuspend_targets(struct dm_table *t);
+void dm_table_cancel_presuspend_targets(struct dm_table *t);
 int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 int dm_table_any_busy_target(struct dm_table *t);
Index: linux-2.6.33-rc1-dm/include/linux/device-mapper.h
===================================================================
--- linux-2.6.33-rc1-dm.orig/include/linux/device-mapper.h
+++ linux-2.6.33-rc1-dm/include/linux/device-mapper.h
@@ -69,6 +69,7 @@ typedef void (*dm_flush_fn) (struct dm_t
 typedef void (*dm_presuspend_fn) (struct dm_target *ti);
 typedef void (*dm_postsuspend_fn) (struct dm_target *ti);
 typedef int (*dm_preresume_fn) (struct dm_target *ti);
+typedef void (*dm_cancel_presuspend_fn) (struct dm_target *ti);
 typedef void (*dm_resume_fn) (struct dm_target *ti);
 
 typedef int (*dm_status_fn) (struct dm_target *ti, status_type_t status_type,
@@ -146,6 +147,7 @@ struct target_type {
 	dm_flush_fn flush;
 	dm_presuspend_fn presuspend;
 	dm_postsuspend_fn postsuspend;
+	dm_cancel_presuspend_fn cancel_presuspend;
 	dm_preresume_fn preresume;
 	dm_resume_fn resume;
 	dm_status_fn status;

-- 
Takahiro Yasui
Hitachi Computer Products (America), Inc.
