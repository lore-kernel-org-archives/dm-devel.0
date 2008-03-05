From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 02/13] dm headers: Adjust dm-[io, kcopyd,
	log}.h by prefixing identifiers with "dm_"
Date: Wed,  5 Mar 2008 19:55:53 +0100
Message-ID: <1204743364-3248-3-git-send-email-hjm@redhat.com>
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
 include/linux/dm-io.h     |    9 +++++--
 include/linux/dm-kcopyd.h |   39 +++++++++++++++++--------------
 include/linux/dm-log.h    |   55 +++++++++++++++++++++++---------------------
 3 files changed, 56 insertions(+), 47 deletions(-)

diff --git linux-2.6.25-rc4.orig/include/linux/dm-io.h linux-2.6.25-rc4/include/linux/dm-io.h
index f647e2c..6018e62 100644
--- linux-2.6.25-rc4.orig/include/linux/dm-io.h
+++ linux-2.6.25-rc4/include/linux/dm-io.h
@@ -1,5 +1,8 @@
 /*
  * Copyright (C) 2003 Sistina Software
+ * Copyright (C) 2004-2008 Red Hat GmbH
+ *
+ * Device-Mapper low-level I/O.
  *
  * This file is released under the GPL.
  */
@@ -7,9 +10,9 @@
 #ifndef _DM_IO_H
 #define _DM_IO_H
 
-#include "dm.h"
+#include <linux/types.h>
 
-struct io_region {
+struct dm_io_region {
 	struct block_device *bdev;
 	sector_t sector;
 	sector_t count;		/* If this is zero the region is ignored. */
@@ -74,6 +77,6 @@ void dm_io_client_destroy(struct dm_io_client *client);
  * error occurred doing io to the corresponding region.
  */
 int dm_io(struct dm_io_request *io_req, unsigned num_regions,
-	  struct io_region *region, unsigned long *sync_error_bits);
+	  struct dm_io_region *region, unsigned long *sync_error_bits);
 
 #endif
diff --git linux-2.6.25-rc4.orig/include/linux/dm-kcopyd.h linux-2.6.25-rc4/include/linux/dm-kcopyd.h
index 4621ea0..ce17760 100644
--- linux-2.6.25-rc4.orig/include/linux/dm-kcopyd.h
+++ linux-2.6.25-rc4/include/linux/dm-kcopyd.h
@@ -1,42 +1,45 @@
 /*
- * Copyright (C) 2001 Sistina Software
+ * Copyright (C) 2001-2003 Sistina Software
+ * Copyright (C) 2004-2008 Red Hat GmbH
+ *
+ * dm-kcopyd provides a simple interface for copying an area of one
+ * block-device to one or more other block-devices, either synchronous
+ * or with an asynchronous completion notification.
  *
  * This file is released under the GPL.
  *
- * Kcopyd provides a simple interface for copying an area of one
- * block-device to one or more other block-devices, with an asynchronous
- * completion notification.
  */
 
 #ifndef DM_KCOPYD_H
 #define DM_KCOPYD_H
 
-#include "dm-io.h"
+#include <linux/dm-io.h>
 
 /* FIXME: make this configurable */
-#define KCOPYD_MAX_REGIONS 8
+#define DM_KCOPYD_MAX_REGIONS 8
 
-#define KCOPYD_IGNORE_ERROR 1
+#define DM_KCOPYD_IGNORE_ERROR 1
 
 /*
- * To use kcopyd you must first create a kcopyd client object.
+ * To use dm-kcopyd you must first create a kcopyd client object.
  */
-struct kcopyd_client;
-int kcopyd_client_create(unsigned int num_pages, struct kcopyd_client **result);
-void kcopyd_client_destroy(struct kcopyd_client *kc);
+struct dm_kcopyd_client;
+int dm_kcopyd_client_create(unsigned int num_pages,
+			    struct dm_kcopyd_client **result);
+void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc);
 
 /*
- * Submit a copy job to kcopyd.  This is built on top of the
+ * Submit a copy job to dm-kcopyd.  This is built on top of the
  * previous three fns.
  *
  * read_err is a boolean,
- * write_err is a bitset, with 1 bit for each destination region
+ * write_err is a bitset, with 1 bit for each destination region.
  */
-typedef void (*kcopyd_notify_fn)(int read_err,
-				 unsigned int write_err, void *context);
+typedef void (*dm_kcopyd_notify_fn)(int read_err,
+				    unsigned int write_err, void *context);
 
-int kcopyd_copy(struct kcopyd_client *kc, struct io_region *from,
-		unsigned int num_dests, struct io_region *dests,
-		unsigned int flags, kcopyd_notify_fn fn, void *context);
+int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
+		   unsigned int num_dests, struct dm_io_region *dests,
+		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context);
 
 #endif
diff --git linux-2.6.25-rc4.orig/include/linux/dm-log.h linux-2.6.25-rc4/include/linux/dm-log.h
index 3fae87e..e0d9a18 100644
--- linux-2.6.25-rc4.orig/include/linux/dm-log.h
+++ linux-2.6.25-rc4/include/linux/dm-log.h
@@ -1,5 +1,8 @@
 /*
  * Copyright (C) 2003 Sistina Software
+ * Copyright (C) 2004-2008 Red Hat GmbH
+ *
+ * Device-Mapper dirty region log.
  *
  * This file is released under the LGPL.
  */
@@ -7,46 +10,44 @@
 #ifndef DM_DIRTY_LOG
 #define DM_DIRTY_LOG
 
-#include "dm.h"
-
 typedef sector_t region_t;
 
-struct dirty_log_type;
+struct dm_dirty_log_type;
 
-struct dirty_log {
-	struct dirty_log_type *type;
+struct dm_dirty_log {
+	struct dm_dirty_log_type *type;
 	void *context;
 };
 
-struct dirty_log_type {
+struct dm_dirty_log_type {
 	struct list_head list;
 	const char *name;
 	struct module *module;
 	unsigned int use_count;
 
-	int (*ctr)(struct dirty_log *log, struct dm_target *ti,
+	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
 		   unsigned int argc, char **argv);
-	void (*dtr)(struct dirty_log *log);
+	void (*dtr)(struct dm_dirty_log *log);
 
 	/*
 	 * There are times when we don't want the log to touch
 	 * the disk.
 	 */
-	int (*presuspend)(struct dirty_log *log);
-	int (*postsuspend)(struct dirty_log *log);
-	int (*resume)(struct dirty_log *log);
+	int (*presuspend)(struct dm_dirty_log *log);
+	int (*postsuspend)(struct dm_dirty_log *log);
+	int (*resume)(struct dm_dirty_log *log);
 
 	/*
 	 * Retrieves the smallest size of region that the log can
 	 * deal with.
 	 */
-	uint32_t (*get_region_size)(struct dirty_log *log);
+	uint32_t (*get_region_size)(struct dm_dirty_log *log);
 
         /*
 	 * A predicate to say whether a region is clean or not.
 	 * May block.
 	 */
-	int (*is_clean)(struct dirty_log *log, region_t region);
+	int (*is_clean)(struct dm_dirty_log *log, region_t region);
 
 	/*
 	 *  Returns: 0, 1, -EWOULDBLOCK, < 0
@@ -59,13 +60,14 @@ struct dirty_log_type {
 	 * passed to a daemon to deal with, since a daemon is
 	 * allowed to block.
 	 */
-	int (*in_sync)(struct dirty_log *log, region_t region, int can_block);
+	int (*in_sync)(struct dm_dirty_log *log, region_t region,
+		       int can_block);
 
 	/*
 	 * Flush the current log state (eg, to disk).  This
 	 * function may block.
 	 */
-	int (*flush)(struct dirty_log *log);
+	int (*flush)(struct dm_dirty_log *log);
 
 	/*
 	 * Mark an area as clean or dirty.  These functions may
@@ -73,8 +75,8 @@ struct dirty_log_type {
 	 * be extremely rare (eg, allocating another chunk of
 	 * memory for some reason).
 	 */
-	void (*mark_region)(struct dirty_log *log, region_t region);
-	void (*clear_region)(struct dirty_log *log, region_t region);
+	void (*mark_region)(struct dm_dirty_log *log, region_t region);
+	void (*clear_region)(struct dm_dirty_log *log, region_t region);
 
 	/*
 	 * Returns: <0 (error), 0 (no region), 1 (region)
@@ -88,39 +90,40 @@ struct dirty_log_type {
 	 * tells you if an area is synchronised, the other
 	 * assigns recovery work.
 	*/
-	int (*get_resync_work)(struct dirty_log *log, region_t *region);
+	int (*get_resync_work)(struct dm_dirty_log *log, region_t *region);
 
 	/*
 	 * This notifies the log that the resync status of a region
 	 * has changed.  It also clears the region from the recovering
 	 * list (if present).
 	 */
-	void (*set_region_sync)(struct dirty_log *log,
+	void (*set_region_sync)(struct dm_dirty_log *log,
 				region_t region, int in_sync);
 
         /*
 	 * Returns the number of regions that are in sync.
          */
-        region_t (*get_sync_count)(struct dirty_log *log);
+        region_t (*get_sync_count)(struct dm_dirty_log *log);
 
 	/*
 	 * Support function for mirror status requests.
 	 */
-	int (*status)(struct dirty_log *log, status_type_t status_type,
+	int (*status)(struct dm_dirty_log *log, status_type_t status_type,
 		      char *result, unsigned int maxlen);
 };
 
-int dm_register_dirty_log_type(struct dirty_log_type *type);
-int dm_unregister_dirty_log_type(struct dirty_log_type *type);
+int dm_dirty_log_type_register(struct dm_dirty_log_type *type);
+int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type);
 
 
 /*
  * Make sure you use these two functions, rather than calling
  * type->constructor/destructor() directly.
  */
-struct dirty_log *dm_create_dirty_log(const char *type_name, struct dm_target *ti,
-				      unsigned int argc, char **argv);
-void dm_destroy_dirty_log(struct dirty_log *log);
+struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
+					 struct dm_target *ti,
+					 unsigned int argc, char **argv);
+void dm_dirty_log_destroy(struct dm_dirty_log *log);
 
 /*
  * init/exit functions.
-- 
1.5.4.1
