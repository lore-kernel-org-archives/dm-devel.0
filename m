From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [PATCH 1/1] dm-log: cleanup dity log external interface
	from members with only internal scope
Date: Fri, 14 Mar 2008 13:47:47 +0100
Message-ID: <1205498867-31225-1-git-send-email-hjm@redhat.com>
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

Alasdair,

this patch cleans the dirty log external interface up from members
with only internal scope, such as list, name, module, ctr, dtr.

Please apply,
Heinz


Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/dm-log.c |  130 ++++++++++++++++++++++++++++++++-------------------
 drivers/md/dm-log.h |   12 -----
 2 files changed, 81 insertions(+), 61 deletions(-)

diff --git linux-2.6.25-rc5.orig/drivers/md/dm-log.c linux-2.6.25-rc5/drivers/md/dm-log.c
index ab14ec3..e6662db 100644
--- linux-2.6.25-rc5.orig/drivers/md/dm-log.c
+++ linux-2.6.25-rc5/drivers/md/dm-log.c
@@ -19,7 +19,21 @@
 static LIST_HEAD(_log_types);
 static DEFINE_SPINLOCK(_lock);
 
-int dm_dirty_log_type_register(struct dm_dirty_log_type *type)
+struct dirty_log_type {
+	struct list_head list;
+	const char *name;
+	struct module *module;
+	unsigned use_count;
+
+	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
+		   unsigned argc, char **argv);
+	void (*dtr)(struct dm_dirty_log *log);
+
+	struct dm_dirty_log_type ext;
+};
+
+
+static int dirty_log_type_register(struct dirty_log_type *type)
 {
 	spin_lock(&_lock);
 	type->use_count = 0;
@@ -28,9 +42,8 @@ int dm_dirty_log_type_register(struct dm_dirty_log_type *type)
 
 	return 0;
 }
-EXPORT_SYMBOL(dm_dirty_log_type_register);
 
-int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type)
+static int dirty_log_type_unregister(struct dirty_log_type *type)
 {
 	spin_lock(&_lock);
 
@@ -43,11 +56,10 @@ int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type)
 
 	return 0;
 }
-EXPORT_SYMBOL(dm_dirty_log_type_unregister);
 
-static struct dm_dirty_log_type *_get_type(const char *type_name)
+static struct dirty_log_type *_get_type(const char *type_name)
 {
-	struct dm_dirty_log_type *type;
+	struct dirty_log_type *type;
 
 	spin_lock(&_lock);
 	list_for_each_entry (type, &_log_types, list)
@@ -56,6 +68,7 @@ static struct dm_dirty_log_type *_get_type(const char *type_name)
 				spin_unlock(&_lock);
 				return NULL;
 			}
+
 			type->use_count++;
 			spin_unlock(&_lock);
 			return type;
@@ -82,10 +95,10 @@ static struct dm_dirty_log_type *_get_type(const char *type_name)
  *
  * Returns: dirty_log_type* on success, NULL on failure
  */
-static struct dm_dirty_log_type *get_type(const char *type_name)
+static struct dirty_log_type *get_type(const char *type_name)
 {
 	char *p, *type_name_dup;
-	struct dm_dirty_log_type *type;
+	struct dirty_log_type *type;
 
 	type = _get_type(type_name);
 	if (type)
@@ -114,7 +127,7 @@ static struct dm_dirty_log_type *get_type(const char *type_name)
 	return type;
 }
 
-static void put_type(struct dm_dirty_log_type *type)
+static void put_type(struct dirty_log_type *type)
 {
 	spin_lock(&_lock);
 	if (!--type->use_count)
@@ -122,10 +135,12 @@ static void put_type(struct dm_dirty_log_type *type)
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
@@ -138,7 +153,7 @@ struct dm_dirty_log *dm_dirty_log_create(const char *type_name, struct dm_target
 		return NULL;
 	}
 
-	log->type = type;
+	log->type = &type->ext;
 	if (type->ctr(log, ti, argc, argv)) {
 		kfree(log);
 		put_type(type);
@@ -151,8 +166,11 @@ EXPORT_SYMBOL(dm_dirty_log_create);
 
 void dm_dirty_log_destroy(struct dm_dirty_log *log)
 {
-	log->type->dtr(log);
-	put_type(log->type);
+	struct dirty_log_type *type =
+		container_of(log->type, struct dirty_log_type, ext);
+
+	type->dtr(log);
+	put_type(type);
 	kfree(log);
 }
 EXPORT_SYMBOL(dm_dirty_log_destroy);
@@ -690,15 +708,17 @@ static int core_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
+	struct dirty_log_type *type =
+		container_of(log->type, struct dirty_log_type, ext);
 	struct log_c *lc = log->context;
 
 	switch(status) {
 	case STATUSTYPE_INFO:
-		DMEMIT("1 %s", log->type->name);
+		DMEMIT("1 %s", type->name);
 		break;
 
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s %u %u ", log->type->name,
+		DMEMIT("%s %u %u ", type->name,
 		       lc->sync == DEFAULTSYNC ? 1 : 2, lc->region_size);
 		DMEMIT_SYNC;
 	}
@@ -710,16 +730,18 @@ static int disk_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
+	struct dirty_log_type *type =
+		container_of(log->type, struct dirty_log_type, ext);
 	struct log_c *lc = log->context;
 
 	switch(status) {
 	case STATUSTYPE_INFO:
-		DMEMIT("3 %s %s %c", log->type->name, lc->log_dev->name,
+		DMEMIT("3 %s %s %c", type->name, lc->log_dev->name,
 		       lc->log_dev_failed ? 'D' : 'A');
 		break;
 
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s %u %s %u ", log->type->name,
+		DMEMIT("%s %u %s %u ", type->name,
 		       lc->sync == DEFAULTSYNC ? 2 : 3, lc->log_dev->name,
 		       lc->region_size);
 		DMEMIT_SYNC;
@@ -728,55 +750,65 @@ static int disk_status(struct dm_dirty_log *log, status_type_t status,
 	return sz;
 }
 
-static struct dm_dirty_log_type _core_type = {
+static struct dirty_log_type _core_type = {
+	/* Internal members. */
 	.name = "core",
 	.module = THIS_MODULE,
 	.ctr = core_ctr,
 	.dtr = core_dtr,
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
+
+	/* External interface. */
+	.ext = {
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
+static struct dirty_log_type _disk_type = {
+	/* Internal members. */
 	.name = "disk",
 	.module = THIS_MODULE,
 	.ctr = disk_ctr,
 	.dtr = disk_dtr,
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
+
+	/* External interface. */
+	.ext = {
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
 {
 	int r;
 
-	r = dm_dirty_log_type_register(&_core_type);
+	r = dirty_log_type_register(&_core_type);
 	if (r)
 		DMWARN("couldn't register core log");
 
-	r = dm_dirty_log_type_register(&_disk_type);
+	r = dirty_log_type_register(&_disk_type);
 	if (r) {
 		DMWARN("couldn't register disk type");
-		dm_dirty_log_type_unregister(&_core_type);
+		dirty_log_type_unregister(&_core_type);
 	}
 
 	return r;
@@ -784,8 +816,8 @@ int __init dm_dirty_log_init(void)
 
 void __exit dm_dirty_log_exit(void)
 {
-	dm_dirty_log_type_unregister(&_disk_type);
-	dm_dirty_log_type_unregister(&_core_type);
+	dirty_log_type_unregister(&_disk_type);
+	dirty_log_type_unregister(&_core_type);
 }
 
 module_init(dm_dirty_log_init);
diff --git linux-2.6.25-rc5.orig/drivers/md/dm-log.h linux-2.6.25-rc5/drivers/md/dm-log.h
index a47a28d..d58acf0 100644
--- linux-2.6.25-rc5.orig/drivers/md/dm-log.h
+++ linux-2.6.25-rc5/drivers/md/dm-log.h
@@ -25,15 +25,6 @@ struct dm_dirty_log {
 };
 
 struct dm_dirty_log_type {
-	struct list_head list;
-	const char *name;
-	struct module *module;
-	unsigned use_count;
-
-	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
-		   unsigned argc, char **argv);
-	void (*dtr)(struct dm_dirty_log *log);
-
 	/*
 	 * There are times when we don't want the log to touch
 	 * the disk.
@@ -117,9 +108,6 @@ struct dm_dirty_log_type {
 		      char *result, unsigned maxlen);
 };
 
-int dm_dirty_log_type_register(struct dm_dirty_log_type *type);
-int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type);
-
 /*
  * Make sure you use these two functions, rather than calling
  * type->constructor/destructor() directly.
-- 
1.5.4.1
