From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 08/13] dm headers: adjust dm-log identifiers
	to have "dm_" prefix
Date: Wed,  5 Mar 2008 19:55:59 +0100
Message-ID: <1204743364-3248-9-git-send-email-hjm@redhat.com>
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


Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/dm-log.c |  103 ++++++++++++++++++++++++++-------------------------
 1 files changed, 53 insertions(+), 50 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-log.c linux-2.6.25-rc4/drivers/md/dm-log.c
index 2d3762e..bce26c6 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-log.c
+++ linux-2.6.25-rc4/drivers/md/dm-log.c
@@ -1,24 +1,25 @@
 /*
  * Copyright (C) 2003 Sistina Software
- * Copyright (C) 2004-2008 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2007-2008 Red Hat Inc.
  *
  * This file is released under the LGPL.
  */
 
+#include "dm.h"
+
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
-
-#include "dm-log.h"
-#include "dm-io.h"
+#include <linux/dm-log.h>
+#include <linux/dm-io.h>
 
 #define DM_MSG_PREFIX "dirty region log"
 
 static LIST_HEAD(_log_types);
 static DEFINE_SPINLOCK(_lock);
 
-int dm_register_dirty_log_type(struct dirty_log_type *type)
+int dm_dirty_log_type_register(struct dm_dirty_log_type *type)
 {
 	spin_lock(&_lock);
 	type->use_count = 0;
@@ -28,7 +29,7 @@ int dm_register_dirty_log_type(struct dirty_log_type *type)
 	return 0;
 }
 
-int dm_unregister_dirty_log_type(struct dirty_log_type *type)
+int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type)
 {
 	spin_lock(&_lock);
 
@@ -42,9 +43,9 @@ int dm_unregister_dirty_log_type(struct dirty_log_type *type)
 	return 0;
 }
 
-static struct dirty_log_type *_get_type(const char *type_name)
+static struct dm_dirty_log_type *_get_type(const char *type_name)
 {
-	struct dirty_log_type *type;
+	struct dm_dirty_log_type *type;
 
 	spin_lock(&_lock);
 	list_for_each_entry (type, &_log_types, list)
@@ -79,10 +80,10 @@ static struct dirty_log_type *_get_type(const char *type_name)
  *
  * Returns: dirty_log_type* on success, NULL on failure
  */
-static struct dirty_log_type *get_type(const char *type_name)
+static struct dm_dirty_log_type *get_type(const char *type_name)
 {
 	char *p, *type_name_dup;
-	struct dirty_log_type *type;
+	struct dm_dirty_log_type *type;
 
 	type = _get_type(type_name);
 	if (type)
@@ -111,7 +112,7 @@ static struct dirty_log_type *get_type(const char *type_name)
 	return type;
 }
 
-static void put_type(struct dirty_log_type *type)
+static void put_type(struct dm_dirty_log_type *type)
 {
 	spin_lock(&_lock);
 	if (!--type->use_count)
@@ -119,11 +120,12 @@ static void put_type(struct dirty_log_type *type)
 	spin_unlock(&_lock);
 }
 
-struct dirty_log *dm_create_dirty_log(const char *type_name, struct dm_target *ti,
-				      unsigned int argc, char **argv)
+struct dm_dirty_log *
+dm_dirty_log_create(const char *type_name, struct dm_target *ti,
+		    unsigned int argc, char **argv)
 {
-	struct dirty_log_type *type;
-	struct dirty_log *log;
+	struct dm_dirty_log_type *type;
+	struct dm_dirty_log *log;
 
 	log = kmalloc(sizeof(*log), GFP_KERNEL);
 	if (!log)
@@ -145,7 +147,7 @@ struct dirty_log *dm_create_dirty_log(const char *type_name, struct dm_target *t
 	return log;
 }
 
-void dm_destroy_dirty_log(struct dirty_log *log)
+void dm_dirty_log_destroy(struct dm_dirty_log *log)
 {
 	log->type->dtr(log);
 	put_type(log->type);
@@ -208,7 +210,7 @@ struct log_c {
 	struct dm_dev *log_dev;
 	struct log_header header;
 
-	struct io_region header_location;
+	struct dm_io_region header_location;
 	struct log_header *disk_header;
 };
 
@@ -303,7 +305,7 @@ static inline int write_header(struct log_c *log)
  * argv contains region_size followed optionally by [no]sync
  *--------------------------------------------------------------*/
 #define BYTE_SHIFT 3
-static int create_log_context(struct dirty_log *log, struct dm_target *ti,
+static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 			      unsigned int argc, char **argv,
 			      struct dm_dev *dev)
 {
@@ -435,7 +437,7 @@ static int create_log_context(struct dirty_log *log, struct dm_target *ti,
 	return 0;
 }
 
-static int core_ctr(struct dirty_log *log, struct dm_target *ti,
+static int core_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		    unsigned int argc, char **argv)
 {
 	return create_log_context(log, ti, argc, argv, NULL);
@@ -448,7 +450,7 @@ static void destroy_log_context(struct log_c *lc)
 	kfree(lc);
 }
 
-static void core_dtr(struct dirty_log *log)
+static void core_dtr(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 
@@ -461,7 +463,7 @@ static void core_dtr(struct dirty_log *log)
  *
  * argv contains log_device region_size followed optionally by [no]sync
  *--------------------------------------------------------------*/
-static int disk_ctr(struct dirty_log *log, struct dm_target *ti,
+static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		    unsigned int argc, char **argv)
 {
 	int r;
@@ -486,7 +488,7 @@ static int disk_ctr(struct dirty_log *log, struct dm_target *ti,
 	return 0;
 }
 
-static void disk_dtr(struct dirty_log *log)
+static void disk_dtr(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 
@@ -515,7 +517,7 @@ static void fail_log_device(struct log_c *lc)
 	dm_table_event(lc->ti->table);
 }
 
-static int disk_resume(struct dirty_log *log)
+static int disk_resume(struct dm_dirty_log *log)
 {
 	int r;
 	unsigned i;
@@ -571,38 +573,38 @@ static int disk_resume(struct dirty_log *log)
 	return r;
 }
 
-static uint32_t core_get_region_size(struct dirty_log *log)
+static uint32_t core_get_region_size(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	return lc->region_size;
 }
 
-static int core_resume(struct dirty_log *log)
+static int core_resume(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	lc->sync_search = 0;
 	return 0;
 }
 
-static int core_is_clean(struct dirty_log *log, region_t region)
+static int core_is_clean(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	return log_test_bit(lc->clean_bits, region);
 }
 
-static int core_in_sync(struct dirty_log *log, region_t region, int block)
+static int core_in_sync(struct dm_dirty_log *log, region_t region, int block)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	return log_test_bit(lc->sync_bits, region);
 }
 
-static int core_flush(struct dirty_log *log)
+static int core_flush(struct dm_dirty_log *log)
 {
 	/* no op */
 	return 0;
 }
 
-static int disk_flush(struct dirty_log *log)
+static int disk_flush(struct dm_dirty_log *log)
 {
 	int r;
 	struct log_c *lc = (struct log_c *) log->context;
@@ -620,19 +622,19 @@ static int disk_flush(struct dirty_log *log)
 	return r;
 }
 
-static void core_mark_region(struct dirty_log *log, region_t region)
+static void core_mark_region(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	log_clear_bit(lc, lc->clean_bits, region);
 }
 
-static void core_clear_region(struct dirty_log *log, region_t region)
+static void core_clear_region(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	log_set_bit(lc, lc->clean_bits, region);
 }
 
-static int core_get_resync_work(struct dirty_log *log, region_t *region)
+static int core_get_resync_work(struct dm_dirty_log *log, region_t *region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 
@@ -655,7 +657,7 @@ static int core_get_resync_work(struct dirty_log *log, region_t *region)
 	return 1;
 }
 
-static void core_set_region_sync(struct dirty_log *log, region_t region,
+static void core_set_region_sync(struct dm_dirty_log *log, region_t region,
 				 int in_sync)
 {
 	struct log_c *lc = (struct log_c *) log->context;
@@ -670,7 +672,7 @@ static void core_set_region_sync(struct dirty_log *log, region_t region,
 	}
 }
 
-static region_t core_get_sync_count(struct dirty_log *log)
+static region_t core_get_sync_count(struct dm_dirty_log *log)
 {
         struct log_c *lc = (struct log_c *) log->context;
 
@@ -681,7 +683,7 @@ static region_t core_get_sync_count(struct dirty_log *log)
 	if (lc->sync != DEFAULTSYNC) \
 		DMEMIT("%ssync ", lc->sync == NOSYNC ? "no" : "")
 
-static int core_status(struct dirty_log *log, status_type_t status,
+static int core_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
@@ -701,7 +703,7 @@ static int core_status(struct dirty_log *log, status_type_t status,
 	return sz;
 }
 
-static int disk_status(struct dirty_log *log, status_type_t status,
+static int disk_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
@@ -723,7 +725,7 @@ static int disk_status(struct dirty_log *log, status_type_t status,
 	return sz;
 }
 
-static struct dirty_log_type _core_type = {
+static struct dm_dirty_log_type _core_type = {
 	.name = "core",
 	.module = THIS_MODULE,
 	.ctr = core_ctr,
@@ -741,7 +743,7 @@ static struct dirty_log_type _core_type = {
 	.status = core_status,
 };
 
-static struct dirty_log_type _disk_type = {
+static struct dm_dirty_log_type _disk_type = {
 	.name = "disk",
 	.module = THIS_MODULE,
 	.ctr = disk_ctr,
@@ -764,33 +766,34 @@ int __init dm_dirty_log_init(void)
 {
 	int r;
 
-	r = dm_register_dirty_log_type(&_core_type);
+	r = dm_dirty_log_type_register(&_core_type);
 	if (r)
 		DMWARN("couldn't register core log");
 
-	r = dm_register_dirty_log_type(&_disk_type);
+	r = dm_dirty_log_type_register(&_disk_type);
 	if (r) {
 		DMWARN("couldn't register disk type");
-		dm_unregister_dirty_log_type(&_core_type);
+		dm_dirty_log_type_unregister(&_core_type);
 	}
 
 	return r;
 }
 
-void __exit dm_dirty_log_exit(void)
+void dm_dirty_log_exit(void)
 {
-	dm_unregister_dirty_log_type(&_disk_type);
-	dm_unregister_dirty_log_type(&_core_type);
+	dm_dirty_log_type_unregister(&_disk_type);
+	dm_dirty_log_type_unregister(&_core_type);
 }
 
-EXPORT_SYMBOL(dm_register_dirty_log_type);
-EXPORT_SYMBOL(dm_unregister_dirty_log_type);
-EXPORT_SYMBOL(dm_create_dirty_log);
-EXPORT_SYMBOL(dm_destroy_dirty_log);
+EXPORT_SYMBOL(dm_dirty_log_type_register);
+EXPORT_SYMBOL(dm_dirty_log_type_unregister);
+EXPORT_SYMBOL(dm_dirty_log_create);
+EXPORT_SYMBOL(dm_dirty_log_destroy);
 
+/* Module hooks. */
 module_init(dm_dirty_log_init);
 module_exit(dm_dirty_log_exit);
 
-MODULE_DESCRIPTION(DM_NAME " dirty region log");
-MODULE_AUTHOR("Heinz Mauelshagen <hjm@redhat.com>");
+MODULE_DESCRIPTION(DM_NAME " device-mapper dirty region log");
+MODULE_AUTHOR("Joe Thornber, Heinz Mauelshagen <hjm@redhat.de>");
 MODULE_LICENSE("GPL");
-- 
1.5.4.1
