From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.29 PATCH 02/02] dm target: remove struct tt_internal
Date: Wed, 7 Jan 2009 20:42:21 +0000
Message-ID: <20090107204221.GS3512@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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
Cc: Cheng Renquan <crquan@gmail.com>
List-Id: dm-devel.ids

From: Cheng Renquan <crquan@gmail.com>

The tt_internal is really just a list_head to manage registered target_type
in a double linked list,

Here embed the list_head into target_type directly,
1. to avoid kmalloc/kfree;
2. then tt_internal is really unneeded;

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Reviewed-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-target.c        |   90 ++++++++++++++----------------------------
 drivers/md/dm.h               |    2 
 include/linux/device-mapper.h |    3 +
 3 files changed, 34 insertions(+), 61 deletions(-)

Index: linux-2.6.28/drivers/md/dm-target.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-target.c	2009-01-07 20:30:57.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-target.c	2009-01-07 20:35:22.000000000 +0000
@@ -14,40 +14,34 @@
 
 #define DM_MSG_PREFIX "target"
 
-struct tt_internal {
-	struct target_type tt;
-
-	struct list_head list;
-};
-
 static LIST_HEAD(_targets);
 static DECLARE_RWSEM(_lock);
 
 #define DM_MOD_NAME_SIZE 32
 
-static inline struct tt_internal *__find_target_type(const char *name)
+static inline struct target_type *__find_target_type(const char *name)
 {
-	struct tt_internal *ti;
+	struct target_type *tt;
 
-	list_for_each_entry (ti, &_targets, list)
-		if (!strcmp(name, ti->tt.name))
-			return ti;
+	list_for_each_entry(tt, &_targets, list)
+		if (!strcmp(name, tt->name))
+			return tt;
 
 	return NULL;
 }
 
-static struct tt_internal *get_target_type(const char *name)
+static struct target_type *get_target_type(const char *name)
 {
-	struct tt_internal *ti;
+	struct target_type *tt;
 
 	down_read(&_lock);
 
-	ti = __find_target_type(name);
-	if (ti && !try_module_get(ti->tt.module))
-		ti = NULL;
+	tt = __find_target_type(name);
+	if (tt && !try_module_get(tt->module))
+		tt = NULL;
 
 	up_read(&_lock);
-	return ti;
+	return tt;
 }
 
 static void load_module(const char *name)
@@ -57,83 +51,59 @@ static void load_module(const char *name
 
 struct target_type *dm_get_target_type(const char *name)
 {
-	struct tt_internal *ti = get_target_type(name);
+	struct target_type *tt = get_target_type(name);
 
-	if (!ti) {
+	if (!tt) {
 		load_module(name);
-		ti = get_target_type(name);
+		tt = get_target_type(name);
 	}
 
-	return ti ? &ti->tt : NULL;
+	return tt;
 }
 
-void dm_put_target_type(struct target_type *t)
+void dm_put_target_type(struct target_type *tt)
 {
-	struct tt_internal *ti = (struct tt_internal *) t;
-
 	down_read(&_lock);
-	module_put(ti->tt.module);
+	module_put(tt->module);
 	up_read(&_lock);
-
-	return;
 }
 
-static struct tt_internal *alloc_target(struct target_type *t)
-{
-	struct tt_internal *ti = kzalloc(sizeof(*ti), GFP_KERNEL);
-
-	if (ti)
-		ti->tt = *t;
-
-	return ti;
-}
-
-
 int dm_target_iterate(void (*iter_func)(struct target_type *tt,
 					void *param), void *param)
 {
-	struct tt_internal *ti;
+	struct target_type *tt;
 
 	down_read(&_lock);
-	list_for_each_entry (ti, &_targets, list)
-		iter_func(&ti->tt, param);
+	list_for_each_entry(tt, &_targets, list)
+		iter_func(tt, param);
 	up_read(&_lock);
 
 	return 0;
 }
 
-int dm_register_target(struct target_type *t)
+int dm_register_target(struct target_type *tt)
 {
 	int rv = 0;
-	struct tt_internal *ti = alloc_target(t);
-
-	if (!ti)
-		return -ENOMEM;
 
 	down_write(&_lock);
-	if (__find_target_type(t->name))
+	if (__find_target_type(tt->name))
 		rv = -EEXIST;
 	else
-		list_add(&ti->list, &_targets);
+		list_add(&tt->list, &_targets);
 
 	up_write(&_lock);
-	if (rv)
-		kfree(ti);
 	return rv;
 }
 
-void dm_unregister_target(struct target_type *t)
+void dm_unregister_target(struct target_type *tt)
 {
-	struct tt_internal *ti;
-
 	down_write(&_lock);
-	if (!(ti = __find_target_type(t->name))) {
-		DMCRIT("Unregistering unrecognised target: %s", t->name);
+	if (!__find_target_type(tt->name)) {
+		DMCRIT("Unregistering unrecognised target: %s", tt->name);
 		BUG();
 	}
 
-	list_del(&ti->list);
-	kfree(ti);
+	list_del(&tt->list);
 
 	up_write(&_lock);
 }
@@ -142,17 +112,17 @@ void dm_unregister_target(struct target_
  * io-err: always fails an io, useful for bringing
  * up LVs that have holes in them.
  */
-static int io_err_ctr(struct dm_target *ti, unsigned int argc, char **args)
+static int io_err_ctr(struct dm_target *tt, unsigned int argc, char **args)
 {
 	return 0;
 }
 
-static void io_err_dtr(struct dm_target *ti)
+static void io_err_dtr(struct dm_target *tt)
 {
 	/* empty */
 }
 
-static int io_err_map(struct dm_target *ti, struct bio *bio,
+static int io_err_map(struct dm_target *tt, struct bio *bio,
 		      union map_info *map_context)
 {
 	return -EIO;
Index: linux-2.6.28/drivers/md/dm.h
===================================================================
--- linux-2.6.28.orig/drivers/md/dm.h	2009-01-07 20:19:02.000000000 +0000
+++ linux-2.6.28/drivers/md/dm.h	2009-01-07 20:32:48.000000000 +0000
@@ -60,7 +60,7 @@ int dm_table_barrier_ok(struct dm_table 
 int dm_target_init(void);
 void dm_target_exit(void);
 struct target_type *dm_get_target_type(const char *name);
-void dm_put_target_type(struct target_type *t);
+void dm_put_target_type(struct target_type *tt);
 int dm_target_iterate(void (*iter_func)(struct target_type *tt,
 					void *param), void *param);
 
Index: linux-2.6.28/include/linux/device-mapper.h
===================================================================
--- linux-2.6.28.orig/include/linux/device-mapper.h	2009-01-07 20:19:02.000000000 +0000
+++ linux-2.6.28/include/linux/device-mapper.h	2009-01-07 20:32:48.000000000 +0000
@@ -139,6 +139,9 @@ struct target_type {
 	dm_ioctl_fn ioctl;
 	dm_merge_fn merge;
 	dm_busy_fn busy;
+
+	/* For internal device-mapper use. */
+	struct list_head list;
 };
 
 struct io_restrictions {
