From: hjm@redhat.com
Subject: [PATCH 1/1] dm-log(2nd): cleanup dirty log external
	interface from members with only internal scope
Date: Mon, 17 Mar 2008 13:43:42 +0100
Message-ID: <1205757822-4786-1-git-send-email-hjm@redhat.com>
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
Cc: Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <hjm@redhat.com>

Alasdair,

this patch (overhauled based on our discussion) cleans the dirty log
external interface up from members with only internal scope, such as
list, name, module, ctr, dtr. It is based on your 'editing' header patches.

In order to keep the above members out of dm-log.h, I created a header
dm-log-internal.h, which shall stay in drivers/md to be included by any
external dirty log module, whereas dm-log.h shall be moved to include/linux.

Please apply,
Heinz

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/dm-log-internal.h |   52 ++++++++
 drivers/md/dm-log.c          |  264 +++++++++++++++++++++++++++---------------
 drivers/md/dm-log.h          |   33 ++----
 drivers/md/dm-raid1.c        |   42 ++++----
 4 files changed, 254 insertions(+), 137 deletions(-)
 create mode 100644 drivers/md/dm-log-internal.h

diff --git 2.6.25-rc5.orig/drivers/md/dm-log-internal.h 2.6.25-rc5/drivers/md/dm-log-internal.h
new file mode 100644
index 0000000..e82affc
--- /dev/null
+++ 2.6.25-rc5/drivers/md/dm-log-internal.h
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2008 Red Hat, Inc. All rights reserved.
+ *
+ * Device-Mapper dirty region log internal structures and uinterface.
+ *
+ * This file is released under the LGPL.
+ */
+
+#ifndef _LINUX_DM_DIRTY_LOG_INTERNAL_H
+#define _LINUX_DM_DIRTY_LOG_INTERNAL_H
+
+#ifdef __KERNEL__
+
+#include <linux/types.h>
+#include <linux/device-mapper.h>
+#include "dm-log.h"
+
+/* Operations for dirty log creation/destruction. */
+struct dm_dirty_log_type_ops {
+	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
+		   unsigned argc, char **argv);
+	void (*dtr)(struct dm_dirty_log *log);
+};
+
+/* Registration relevant data. */
+struct dm_registry_type {
+	struct list_head list;
+	const char *name;
+	struct module *module;
+	unsigned use_count;
+};
+
+/*
+ * Internal dirty log type representation.
+ */
+struct dirty_log_type {
+	struct dm_registry_type	registry;
+
+	/* Internal type operations (i.e. ctr and dtr). */
+	struct dm_dirty_log_type_ops t_ops;
+
+	/* External operations. */
+	struct dm_dirty_log_ops l_ops;
+};
+
+/* Register/unregister a dirty log handler. */
+int dm_dirty_log_type_register(struct dirty_log_type *type);
+int dm_dirty_log_type_unregister(const char *type_name);
+
+
+#endif	/* __KERNEL__ */
+#endif	/* _LINUX_DM_DIRTY_LOG_INTERNAL_H */
diff --git 2.6.25-rc5.orig/drivers/md/dm-log.c 2.6.25-rc5/drivers/md/dm-log.c
index ab14ec3..9311829 100644
--- 2.6.25-rc5.orig/drivers/md/dm-log.c
+++ 2.6.25-rc5/drivers/md/dm-log.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 
+#include "dm-log-internal.h"
 #include "dm-log.h"
 #include "dm-io.h"
 #include "dm.h"
@@ -19,50 +20,95 @@
 static LIST_HEAD(_log_types);
 static DEFINE_SPINLOCK(_lock);
 
-int dm_dirty_log_type_register(struct dm_dirty_log_type *type)
+/*
+ * Find dirty log type in _log_types list.
+ *
+ * Caller must take _lock out.
+ */
+static struct dirty_log_type *_get_type(const char *type_name)
 {
+	struct dirty_log_type *type;
+
+	list_for_each_entry(type, &_log_types, registry.list) {
+		if (!strcmp(type_name, type->registry.name))
+			return type;
+	}
+
+	return NULL;
+}
+
+/*
+ * dm_log_type_register
+ * @type
+ *
+ * Register a dirty log type.
+ */
+int dm_dirty_log_type_register(struct dirty_log_type *type)
+{
+	int r;
+
 	spin_lock(&_lock);
-	type->use_count = 0;
-	list_add(&type->list, &_log_types);
+	type = _get_type(type->registry.name);
+	if (type) {
+		DMERR("Attempt to register an already registered type %s",
+		      type->registry.name);
+		r = -EEXIST;
+	} else {
+		type->registry.use_count = 0;
+		list_add(&type->registry.list, &_log_types);
+		r = 0;
+	}
 	spin_unlock(&_lock);
 
-	return 0;
+	return r;
 }
 EXPORT_SYMBOL(dm_dirty_log_type_register);
 
-int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type)
+/*
+ * dm_log_type_unregoster
+ * @type_name
+ *
+ * Unregister a dirty log type by name.
+ * Function will succeed if type is unused.
+ */
+int dm_dirty_log_type_unregister(const char *type_name)
 {
-	spin_lock(&_lock);
+	int r = 0;
+	struct dirty_log_type *type;
 
-	if (type->use_count)
-		DMWARN("Attempt to unregister a log type that is still in use");
-	else
-		list_del(&type->list);
+	spin_lock(&_lock);
+	type = _get_type(type_name);
+	if (type) {
+		if (type->registry.use_count) {
+			DMWARN("Attempt to unregister log type %s "
+			       "that is still in use", type_name);
+			r = -EPERM;
+		} else
+			list_del(&type->registry.list);
+	}
 
 	spin_unlock(&_lock);
-
-	return 0;
+	return r;
 }
 EXPORT_SYMBOL(dm_dirty_log_type_unregister);
 
-static struct dm_dirty_log_type *_get_type(const char *type_name)
+/* Get dirty log type. */
+static struct dirty_log_type *_get_module(const char *type_name)
 {
-	struct dm_dirty_log_type *type;
+	struct dirty_log_type *type;
 
 	spin_lock(&_lock);
-	list_for_each_entry (type, &_log_types, list)
-		if (!strcmp(type_name, type->name)) {
-			if (!type->use_count && !try_module_get(type->module)){
-				spin_unlock(&_lock);
-				return NULL;
-			}
-			type->use_count++;
-			spin_unlock(&_lock);
-			return type;
-		}
+	type = _get_type(type_name);
+	if (type) {
+		if (!type->registry.use_count &&
+		    !try_module_get(type->registry.module))
+			type = NULL;
+		else
+			type->registry.use_count++;
+	}
 
 	spin_unlock(&_lock);
-	return NULL;
+	return type;
 }
 
 /*
@@ -82,15 +128,16 @@ static struct dm_dirty_log_type *_get_type(const char *type_name)
  *
  * Returns: dirty_log_type* on success, NULL on failure
  */
-static struct dm_dirty_log_type *get_type(const char *type_name)
+static struct dirty_log_type *get_type(const char *type_name)
 {
 	char *p, *type_name_dup;
-	struct dm_dirty_log_type *type;
+	struct dirty_log_type *type;
 
-	type = _get_type(type_name);
+	type = _get_module(type_name);
 	if (type)
 		return type;
 
+	/* Duplicate type name to be able to vary it. */
 	type_name_dup = kstrdup(type_name, GFP_KERNEL);
 	if (!type_name_dup) {
 		DMWARN("No memory left to attempt log module load for \"%s\"",
@@ -98,12 +145,14 @@ static struct dm_dirty_log_type *get_type(const char *type_name)
 		return NULL;
 	}
 
+	/* Request module load varying names as explained above. */
 	while (request_module("dm-log-%s", type_name_dup) ||
-	       !(type = _get_type(type_name))) {
+	       !(type = _get_module(type_name))) {
 		p = strrchr(type_name_dup, '-');
-		if (!p)
+		if (p)
+			*p = '\0';
+		else
 			break;
-		p[0] = '\0';
 	}
 
 	if (!type)
@@ -114,18 +163,21 @@ static struct dm_dirty_log_type *get_type(const char *type_name)
 	return type;
 }
 
-static void put_type(struct dm_dirty_log_type *type)
+/* Release a dirty log type reference. */
+static void put_type(struct dirty_log_type *type)
 {
 	spin_lock(&_lock);
-	if (!--type->use_count)
-		module_put(type->module);
+	if (!--type->registry.use_count)
+		module_put(type->registry.module);
 	spin_unlock(&_lock);
 }
 
-struct dm_dirty_log *dm_dirty_log_create(const char *type_name, struct dm_target *ti,
-				      unsigned int argc, char **argv)
+/* Create a dirty log. */
+struct dm_dirty_log *
+dm_dirty_log_create(const char *type_name, struct dm_target *ti,
+		    unsigned int argc, char **argv)
 {
-	struct dm_dirty_log_type *type;
+	struct dirty_log_type *type;
 	struct dm_dirty_log *log;
 
 	log = kmalloc(sizeof(*log), GFP_KERNEL);
@@ -138,8 +190,8 @@ struct dm_dirty_log *dm_dirty_log_create(const char *type_name, struct dm_target
 		return NULL;
 	}
 
-	log->type = type;
-	if (type->ctr(log, ti, argc, argv)) {
+	log->l_ops = &type->l_ops;
+	if (type->t_ops.ctr(log, ti, argc, argv)) {
 		kfree(log);
 		put_type(type);
 		return NULL;
@@ -151,8 +203,11 @@ EXPORT_SYMBOL(dm_dirty_log_create);
 
 void dm_dirty_log_destroy(struct dm_dirty_log *log)
 {
-	log->type->dtr(log);
-	put_type(log->type);
+	struct dirty_log_type *type =
+		container_of(log->l_ops, struct dirty_log_type, l_ops);
+
+	type->t_ops.dtr(log);
+	put_type(type);
 	kfree(log);
 }
 EXPORT_SYMBOL(dm_dirty_log_destroy);
@@ -162,14 +217,14 @@ EXPORT_SYMBOL(dm_dirty_log_destroy);
  * FIXME: need a reload method to be called from a resume
  *---------------------------------------------------------------*/
 /*
- * Magic for persistent mirrors: "MiRr"
+ * Magic for persistent dirty logs: "MiRr"
  */
-#define MIRROR_MAGIC 0x4D695272
+#define DIRTY_LOG_MAGIC 0x4D695272
 
 /*
  * The on-disk version of the metadata.
  */
-#define MIRROR_DISK_VERSION 2
+#define DIRTY_LOG_DISK_VERSION 2
 #define LOG_OFFSET 2
 
 struct log_header {
@@ -277,9 +332,9 @@ static int read_header(struct log_c *log)
 	header_from_disk(&log->header, log->disk_header);
 
 	/* New log required? */
-	if (log->sync != DEFAULTSYNC || log->header.magic != MIRROR_MAGIC) {
-		log->header.magic = MIRROR_MAGIC;
-		log->header.version = MIRROR_DISK_VERSION;
+	if (log->sync != DEFAULTSYNC || log->header.magic != DIRTY_LOG_MAGIC) {
+		log->header.magic = DIRTY_LOG_MAGIC;
+		log->header.version = DIRTY_LOG_DISK_VERSION;
 		log->header.nr_regions = 0;
 	}
 
@@ -288,7 +343,7 @@ static int read_header(struct log_c *log)
 		log->header.version = 2;
 #endif
 
-	if (log->header.version != MIRROR_DISK_VERSION) {
+	if (log->header.version != DIRTY_LOG_DISK_VERSION) {
 		DMWARN("incompatible disk log version");
 		return -EINVAL;
 	}
@@ -505,9 +560,9 @@ static int count_bits32(uint32_t *addr, unsigned size)
 {
 	int count = 0, i;
 
-	for (i = 0; i < size; i++) {
+	for (i = 0; i < size; i++)
 		count += hweight32(*(addr+i));
-	}
+
 	return count;
 }
 
@@ -585,6 +640,7 @@ static uint32_t core_get_region_size(struct dm_dirty_log *log)
 static int core_resume(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
 	lc->sync_search = 0;
 	return 0;
 }
@@ -592,12 +648,14 @@ static int core_resume(struct dm_dirty_log *log)
 static int core_is_clean(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
 	return log_test_bit(lc->clean_bits, region);
 }
 
 static int core_in_sync(struct dm_dirty_log *log, region_t region, int block)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
 	return log_test_bit(lc->sync_bits, region);
 }
 
@@ -612,7 +670,7 @@ static int disk_flush(struct dm_dirty_log *log)
 	int r;
 	struct log_c *lc = (struct log_c *) log->context;
 
-	/* only write if the log has changed */
+	/* only write if the log has changed. */
 	if (!lc->touched)
 		return 0;
 
@@ -628,12 +686,14 @@ static int disk_flush(struct dm_dirty_log *log)
 static void core_mark_region(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
 	log_clear_bit(lc, lc->clean_bits, region);
 }
 
 static void core_clear_region(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
+
 	log_set_bit(lc, lc->clean_bits, region);
 }
 
@@ -690,15 +750,17 @@ static int core_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
+	struct dirty_log_type *type =
+		container_of(log->l_ops, struct dirty_log_type, l_ops);
 	struct log_c *lc = log->context;
 
 	switch(status) {
 	case STATUSTYPE_INFO:
-		DMEMIT("1 %s", log->type->name);
+		DMEMIT("1 %s", type->registry.name);
 		break;
 
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s %u %u ", log->type->name,
+		DMEMIT("%s %u %u ", type->registry.name,
 		       lc->sync == DEFAULTSYNC ? 1 : 2, lc->region_size);
 		DMEMIT_SYNC;
 	}
@@ -710,16 +772,18 @@ static int disk_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
+	struct dirty_log_type *type =
+		container_of(log->l_ops, struct dirty_log_type, l_ops);
 	struct log_c *lc = log->context;
 
 	switch(status) {
 	case STATUSTYPE_INFO:
-		DMEMIT("3 %s %s %c", log->type->name, lc->log_dev->name,
+		DMEMIT("3 %s %s %c", type->registry.name, lc->log_dev->name,
 		       lc->log_dev_failed ? 'D' : 'A');
 		break;
 
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s %u %s %u ", log->type->name,
+		DMEMIT("%s %u %s %u ", type->registry.name,
 		       lc->sync == DEFAULTSYNC ? 2 : 3, lc->log_dev->name,
 		       lc->region_size);
 		DMEMIT_SYNC;
@@ -728,41 +792,59 @@ static int disk_status(struct dm_dirty_log *log, status_type_t status,
 	return sz;
 }
 
-static struct dm_dirty_log_type _core_type = {
-	.name = "core",
-	.module = THIS_MODULE,
-	.ctr = core_ctr,
-	.dtr = core_dtr,
-	.resume = core_resume,
-	.get_region_size = core_get_region_size,
-	.is_clean = core_is_clean,
-	.in_sync = core_in_sync,
-	.flush = core_flush,
-	.mark_region = core_mark_region,
-	.clear_region = core_clear_region,
-	.get_resync_work = core_get_resync_work,
-	.set_region_sync = core_set_region_sync,
-	.get_sync_count = core_get_sync_count,
-	.status = core_status,
+static struct dirty_log_type _core_type = {
+	/* Internal members. */
+	.registry = {
+		.name = "core",
+		.module = THIS_MODULE,
+	},
+	/* Internal interface. */
+	.t_ops = {
+		.ctr = core_ctr,
+		.dtr = core_dtr,
+	},
+	/* External interface. */
+	.l_ops = {
+		.resume = core_resume,
+		.get_region_size = core_get_region_size,
+		.is_clean = core_is_clean,
+		.in_sync = core_in_sync,
+		.flush = core_flush,
+		.mark_region = core_mark_region,
+		.clear_region = core_clear_region,
+		.get_resync_work = core_get_resync_work,
+		.set_region_sync = core_set_region_sync,
+		.get_sync_count = core_get_sync_count,
+		.status = core_status,
+	}
 };
 
-static struct dm_dirty_log_type _disk_type = {
-	.name = "disk",
-	.module = THIS_MODULE,
-	.ctr = disk_ctr,
-	.dtr = disk_dtr,
-	.postsuspend = disk_flush,
-	.resume = disk_resume,
-	.get_region_size = core_get_region_size,
-	.is_clean = core_is_clean,
-	.in_sync = core_in_sync,
-	.flush = disk_flush,
-	.mark_region = core_mark_region,
-	.clear_region = core_clear_region,
-	.get_resync_work = core_get_resync_work,
-	.set_region_sync = core_set_region_sync,
-	.get_sync_count = core_get_sync_count,
-	.status = disk_status,
+static struct dirty_log_type _disk_type = {
+	/* Internal members. */
+	.registry = {
+		.name = "disk",
+		.module = THIS_MODULE,
+	},
+	/* External interface. */
+	.t_ops = {
+		.ctr = disk_ctr,
+		.dtr = disk_dtr,
+	},
+	/* External interface. */
+	.l_ops = {
+		.postsuspend = disk_flush,
+		.resume = disk_resume,
+		.get_region_size = core_get_region_size,
+		.is_clean = core_is_clean,
+		.in_sync = core_in_sync,
+		.flush = disk_flush,
+		.mark_region = core_mark_region,
+		.clear_region = core_clear_region,
+		.get_resync_work = core_get_resync_work,
+		.set_region_sync = core_set_region_sync,
+		.get_sync_count = core_get_sync_count,
+		.status = disk_status,
+	}
 };
 
 int __init dm_dirty_log_init(void)
@@ -776,7 +858,7 @@ int __init dm_dirty_log_init(void)
 	r = dm_dirty_log_type_register(&_disk_type);
 	if (r) {
 		DMWARN("couldn't register disk type");
-		dm_dirty_log_type_unregister(&_core_type);
+		dm_dirty_log_type_unregister(_core_type.registry.name);
 	}
 
 	return r;
@@ -784,8 +866,8 @@ int __init dm_dirty_log_init(void)
 
 void __exit dm_dirty_log_exit(void)
 {
-	dm_dirty_log_type_unregister(&_disk_type);
-	dm_dirty_log_type_unregister(&_core_type);
+	dm_dirty_log_type_unregister(_disk_type.registry.name);
+	dm_dirty_log_type_unregister(_core_type.registry.name);
 }
 
 module_init(dm_dirty_log_init);
diff --git 2.6.25-rc5.orig/drivers/md/dm-log.h 2.6.25-rc5/drivers/md/dm-log.h
index a47a28d..c35698a 100644
--- 2.6.25-rc5.orig/drivers/md/dm-log.h
+++ 2.6.25-rc5/drivers/md/dm-log.h
@@ -2,13 +2,13 @@
  * Copyright (C) 2003 Sistina Software
  * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
  *
- * Device-Mapper dirty region log.
+ * Device-Mapper dirty region log external structure and interface.
  *
  * This file is released under the LGPL.
  */
 
-#ifndef _LINUX_DM_DIRTY_LOG
-#define _LINUX_DM_DIRTY_LOG
+#ifndef _LINUX_DM_DIRTY_LOG_H
+#define _LINUX_DM_DIRTY_LOG_H
 
 #ifdef __KERNEL__
 
@@ -17,23 +17,15 @@
 
 typedef sector_t region_t;
 
-struct dm_dirty_log_type;
-
+/* A dirty log handle. */
 struct dm_dirty_log {
-	struct dm_dirty_log_type *type;
+	struct dm_dirty_log_ops *l_ops;
 	void *context;
 };
 
-struct dm_dirty_log_type {
-	struct list_head list;
-	const char *name;
-	struct module *module;
-	unsigned use_count;
-
-	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
-		   unsigned argc, char **argv);
-	void (*dtr)(struct dm_dirty_log *log);
 
+/* Operations of a dirty log handler type. */
+struct dm_dirty_log_ops {
 	/*
 	 * There are times when we don't want the log to touch
 	 * the disk.
@@ -117,23 +109,14 @@ struct dm_dirty_log_type {
 		      char *result, unsigned maxlen);
 };
 
-int dm_dirty_log_type_register(struct dm_dirty_log_type *type);
-int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type);
-
 /*
  * Make sure you use these two functions, rather than calling
- * type->constructor/destructor() directly.
+ * type_ops->ctr/dtr() directly.
  */
 struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
 					 struct dm_target *ti,
 					 unsigned argc, char **argv);
 void dm_dirty_log_destroy(struct dm_dirty_log *log);
 
-/*
- * init/exit functions.
- */
-int dm_dirty_log_init(void);
-void dm_dirty_log_exit(void);
-
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_DM_DIRTY_LOG_H */
diff --git 2.6.25-rc5.orig/drivers/md/dm-raid1.c 2.6.25-rc5/drivers/md/dm-raid1.c
index e104014..b1f4680 100644
--- 2.6.25-rc5.orig/drivers/md/dm-raid1.c
+++ 2.6.25-rc5/drivers/md/dm-raid1.c
@@ -287,7 +287,7 @@ static struct region *__rh_alloc(struct region_hash *rh, region_t region)
 	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
 	if (unlikely(!nreg))
 		nreg = kmalloc(sizeof(struct region), GFP_NOIO);
-	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
+	nreg->state = rh->log->l_ops->in_sync(rh->log, region, 1) ?
 		RH_CLEAN : RH_NOSYNC;
 	nreg->rh = rh;
 	nreg->key = region;
@@ -345,7 +345,7 @@ static int rh_state(struct region_hash *rh, region_t region, int may_block)
 	 * The region wasn't in the hash, so we fall back to the
 	 * dirty log.
 	 */
-	r = rh->log->type->in_sync(rh->log, region, may_block);
+	r = rh->log->l_ops->in_sync(rh->log, region, may_block);
 
 	/*
 	 * Any error from the dirty log (eg. -EWOULDBLOCK) gets
@@ -374,7 +374,7 @@ static void complete_resync_work(struct region *reg, int success)
 {
 	struct region_hash *rh = reg->rh;
 
-	rh->log->type->set_region_sync(rh->log, reg->key, success);
+	rh->log->l_ops->set_region_sync(rh->log, reg->key, success);
 
 	/*
 	 * Dispatch the bios before we call 'wake_up_all'.
@@ -437,7 +437,7 @@ static void rh_update_states(struct region_hash *rh)
 	 * any more locking.
 	 */
 	list_for_each_entry_safe (reg, next, &recovered, list) {
-		rh->log->type->clear_region(rh->log, reg->key);
+		rh->log->l_ops->clear_region(rh->log, reg->key);
 		complete_resync_work(reg, 1);
 		mempool_free(reg, rh->region_pool);
 	}
@@ -448,11 +448,11 @@ static void rh_update_states(struct region_hash *rh)
 	}
 
 	list_for_each_entry_safe(reg, next, &clean, list) {
-		rh->log->type->clear_region(rh->log, reg->key);
+		rh->log->l_ops->clear_region(rh->log, reg->key);
 		mempool_free(reg, rh->region_pool);
 	}
 
-	rh->log->type->flush(rh->log);
+	rh->log->l_ops->flush(rh->log);
 }
 
 static void rh_inc(struct region_hash *rh, region_t region)
@@ -470,7 +470,7 @@ static void rh_inc(struct region_hash *rh, region_t region)
 		list_del_init(&reg->list);	/* take off the clean list */
 		spin_unlock_irq(&rh->region_lock);
 
-		rh->log->type->mark_region(rh->log, reg->key);
+		rh->log->l_ops->mark_region(rh->log, reg->key);
 	} else
 		spin_unlock_irq(&rh->region_lock);
 
@@ -536,7 +536,7 @@ static int __rh_recovery_prepare(struct region_hash *rh)
 	/*
 	 * Ask the dirty log what's next.
 	 */
-	r = rh->log->type->get_resync_work(rh->log, &region);
+	r = rh->log->l_ops->get_resync_work(rh->log, &region);
 	if (r <= 0)
 		return r;
 
@@ -617,7 +617,7 @@ static void rh_recovery_end(struct region *reg, int success)
 
 static int rh_flush(struct region_hash *rh)
 {
-	return rh->log->type->flush(rh->log);
+	return rh->log->l_ops->flush(rh->log);
 }
 
 static void rh_delay(struct region_hash *rh, struct bio *bio)
@@ -853,7 +853,7 @@ static void do_recovery(struct mirror_set *ms)
 	 * Update the in sync flag.
 	 */
 	if (!ms->in_sync &&
-	    (log->type->get_sync_count(log) == ms->nr_regions)) {
+	    (log->l_ops->get_sync_count(log) == ms->nr_regions)) {
 		/* the sync is complete */
 		dm_table_event(ms->ti->table);
 		ms->in_sync = 1;
@@ -889,7 +889,7 @@ static int mirror_available(struct mirror_set *ms, struct bio *bio)
 {
 	region_t region = bio_to_region(&ms->rh, bio);
 
-	if (ms->rh.log->type->in_sync(ms->rh.log, region, 0))
+	if (ms->rh.log->l_ops->in_sync(ms->rh.log, region, 0))
 		return choose_mirror(ms,  bio->bi_sector) ? 1 : 0;
 
 	return 0;
@@ -1025,7 +1025,7 @@ static void __bio_mark_nosync(struct mirror_set *ms,
 	int recovering = 0;
 
 	/* We must inform the log that the sync count has changed. */
-	log->type->set_region_sync(log, region, 0);
+	log->l_ops->set_region_sync(log, region, 0);
 	ms->in_sync = 0;
 
 	read_lock(&rh->hash_lock);
@@ -1433,7 +1433,7 @@ static struct dm_dirty_log *create_dirty_log(struct dm_target *ti,
 		return NULL;
 	}
 
-	if (!_check_region_size(ti, dl->type->get_region_size(dl))) {
+	if (!_check_region_size(ti, dl->l_ops->get_region_size(dl))) {
 		ti->error = "Invalid region size";
 		dm_dirty_log_destroy(dl);
 		return NULL;
@@ -1520,7 +1520,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		return -EINVAL;
 	}
 
-	ms = alloc_context(nr_mirrors, dl->type->get_region_size(dl), ti, dl);
+	ms = alloc_context(nr_mirrors, dl->l_ops->get_region_size(dl), ti, dl);
 	if (!ms) {
 		dm_dirty_log_destroy(dl);
 		return -ENOMEM;
@@ -1629,7 +1629,7 @@ static int mirror_map(struct dm_target *ti, struct bio *bio,
 		return DM_MAPIO_SUBMITTED;
 	}
 
-	r = ms->rh.log->type->in_sync(ms->rh.log,
+	r = ms->rh.log->l_ops->in_sync(ms->rh.log,
 				      bio_to_region(&ms->rh, bio), 0);
 	if (r < 0 && r != -EWOULDBLOCK)
 		return r;
@@ -1747,7 +1747,7 @@ static void mirror_presuspend(struct dm_target *ti)
 	wait_event(_kmirrord_recovery_stopped,
 		   !atomic_read(&ms->rh.recovery_in_flight));
 
-	if (log->type->presuspend && log->type->presuspend(log))
+	if (log->l_ops->presuspend && log->l_ops->presuspend(log))
 		/* FIXME: need better error handling */
 		DMWARN("log presuspend failed");
 
@@ -1765,7 +1765,7 @@ static void mirror_postsuspend(struct dm_target *ti)
 	struct mirror_set *ms = ti->private;
 	struct dm_dirty_log *log = ms->rh.log;
 
-	if (log->type->postsuspend && log->type->postsuspend(log))
+	if (log->l_ops->postsuspend && log->l_ops->postsuspend(log))
 		/* FIXME: need better error handling */
 		DMWARN("log postsuspend failed");
 }
@@ -1776,7 +1776,7 @@ static void mirror_resume(struct dm_target *ti)
 	struct dm_dirty_log *log = ms->rh.log;
 
 	atomic_set(&ms->suspend, 0);
-	if (log->type->resume && log->type->resume(log))
+	if (log->l_ops->resume && log->l_ops->resume(log))
 		/* FIXME: need better error handling */
 		DMWARN("log resume failed");
 	rh_start_recovery(&ms->rh);
@@ -1824,15 +1824,15 @@ static int mirror_status(struct dm_target *ti, status_type_t type,
 		buffer[m] = '\0';
 
 		DMEMIT("%llu/%llu 1 %s ",
-		      (unsigned long long)log->type->get_sync_count(ms->rh.log),
+		      (unsigned long long)log->l_ops->get_sync_count(ms->rh.log),
 		      (unsigned long long)ms->nr_regions, buffer);
 
-		sz += log->type->status(ms->rh.log, type, result+sz, maxlen-sz);
+		sz += log->l_ops->status(ms->rh.log, type, result+sz, maxlen-sz);
 
 		break;
 
 	case STATUSTYPE_TABLE:
-		sz = log->type->status(ms->rh.log, type, result, maxlen);
+		sz = log->l_ops->status(ms->rh.log, type, result, maxlen);
 
 		DMEMIT("%d", ms->nr_mirrors);
 		for (m = 0; m < ms->nr_mirrors; m++)
-- 
1.5.4.1
