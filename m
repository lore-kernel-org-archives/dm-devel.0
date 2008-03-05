From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 01/13] dm headers: move headers of modules
	dm-io, dm-log and kcopyd to include/linux to allow for sharing;
	rename kcopyd.h to dm-kcopyd.h to be consistent with other dm header
	prefixes
Date: Wed,  5 Mar 2008 19:55:52 +0100
Message-ID: <1204743364-3248-2-git-send-email-hjm@redhat.com>
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
 drivers/md/dm-io.h        |   79 ---------------------------
 drivers/md/dm-log.h       |  131 ---------------------------------------------
 drivers/md/kcopyd.h       |   42 --------------
 include/linux/dm-io.h     |   79 +++++++++++++++++++++++++++
 include/linux/dm-kcopyd.h |   42 ++++++++++++++
 include/linux/dm-log.h    |  131 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 252 insertions(+), 252 deletions(-)
 delete mode 100644 drivers/md/dm-io.h
 delete mode 100644 drivers/md/dm-log.h
 delete mode 100644 drivers/md/kcopyd.h
 create mode 100644 include/linux/dm-io.h
 create mode 100644 include/linux/dm-kcopyd.h
 create mode 100644 include/linux/dm-log.h

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-io.h linux-2.6.25-rc4/drivers/md/dm-io.h
deleted file mode 100644
index f647e2c..0000000
--- linux-2.6.25-rc4.orig/drivers/md/dm-io.h
+++ /dev/null
@@ -1,79 +0,0 @@
-/*
- * Copyright (C) 2003 Sistina Software
- *
- * This file is released under the GPL.
- */
-
-#ifndef _DM_IO_H
-#define _DM_IO_H
-
-#include "dm.h"
-
-struct io_region {
-	struct block_device *bdev;
-	sector_t sector;
-	sector_t count;		/* If this is zero the region is ignored. */
-};
-
-struct page_list {
-	struct page_list *next;
-	struct page *page;
-};
-
-typedef void (*io_notify_fn)(unsigned long error, void *context);
-
-enum dm_io_mem_type {
-	DM_IO_PAGE_LIST,/* Page list */
-	DM_IO_BVEC,	/* Bio vector */
-	DM_IO_VMA,	/* Virtual memory area */
-	DM_IO_KMEM,	/* Kernel memory */
-};
-
-struct dm_io_memory {
-	enum dm_io_mem_type type;
-
-	union {
-		struct page_list *pl;
-		struct bio_vec *bvec;
-		void *vma;
-		void *addr;
-	} ptr;
-
-	unsigned offset;
-};
-
-struct dm_io_notify {
-	io_notify_fn fn;	/* Callback for asynchronous requests */
-	void *context;		/* Passed to callback */
-};
-
-/*
- * IO request structure
- */
-struct dm_io_client;
-struct dm_io_request {
-	int bi_rw;			/* READ|WRITE - not READA */
-	struct dm_io_memory mem;	/* Memory to use for io */
-	struct dm_io_notify notify;	/* Synchronous if notify.fn is NULL */
-	struct dm_io_client *client;	/* Client memory handler */
-};
-
-/*
- * For async io calls, users can alternatively use the dm_io() function below
- * and dm_io_client_create() to create private mempools for the client.
- *
- * Create/destroy may block.
- */
-struct dm_io_client *dm_io_client_create(unsigned num_pages);
-int dm_io_client_resize(unsigned num_pages, struct dm_io_client *client);
-void dm_io_client_destroy(struct dm_io_client *client);
-
-/*
- * IO interface using private per-client pools.
- * Each bit in the optional 'sync_error_bits' bitset indicates whether an
- * error occurred doing io to the corresponding region.
- */
-int dm_io(struct dm_io_request *io_req, unsigned num_regions,
-	  struct io_region *region, unsigned long *sync_error_bits);
-
-#endif
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-log.h linux-2.6.25-rc4/drivers/md/dm-log.h
deleted file mode 100644
index 3fae87e..0000000
--- linux-2.6.25-rc4.orig/drivers/md/dm-log.h
+++ /dev/null
@@ -1,131 +0,0 @@
-/*
- * Copyright (C) 2003 Sistina Software
- *
- * This file is released under the LGPL.
- */
-
-#ifndef DM_DIRTY_LOG
-#define DM_DIRTY_LOG
-
-#include "dm.h"
-
-typedef sector_t region_t;
-
-struct dirty_log_type;
-
-struct dirty_log {
-	struct dirty_log_type *type;
-	void *context;
-};
-
-struct dirty_log_type {
-	struct list_head list;
-	const char *name;
-	struct module *module;
-	unsigned int use_count;
-
-	int (*ctr)(struct dirty_log *log, struct dm_target *ti,
-		   unsigned int argc, char **argv);
-	void (*dtr)(struct dirty_log *log);
-
-	/*
-	 * There are times when we don't want the log to touch
-	 * the disk.
-	 */
-	int (*presuspend)(struct dirty_log *log);
-	int (*postsuspend)(struct dirty_log *log);
-	int (*resume)(struct dirty_log *log);
-
-	/*
-	 * Retrieves the smallest size of region that the log can
-	 * deal with.
-	 */
-	uint32_t (*get_region_size)(struct dirty_log *log);
-
-        /*
-	 * A predicate to say whether a region is clean or not.
-	 * May block.
-	 */
-	int (*is_clean)(struct dirty_log *log, region_t region);
-
-	/*
-	 *  Returns: 0, 1, -EWOULDBLOCK, < 0
-	 *
-	 * A predicate function to check the area given by
-	 * [sector, sector + len) is in sync.
-	 *
-	 * If -EWOULDBLOCK is returned the state of the region is
-	 * unknown, typically this will result in a read being
-	 * passed to a daemon to deal with, since a daemon is
-	 * allowed to block.
-	 */
-	int (*in_sync)(struct dirty_log *log, region_t region, int can_block);
-
-	/*
-	 * Flush the current log state (eg, to disk).  This
-	 * function may block.
-	 */
-	int (*flush)(struct dirty_log *log);
-
-	/*
-	 * Mark an area as clean or dirty.  These functions may
-	 * block, though for performance reasons blocking should
-	 * be extremely rare (eg, allocating another chunk of
-	 * memory for some reason).
-	 */
-	void (*mark_region)(struct dirty_log *log, region_t region);
-	void (*clear_region)(struct dirty_log *log, region_t region);
-
-	/*
-	 * Returns: <0 (error), 0 (no region), 1 (region)
-	 *
-	 * The mirrord will need perform recovery on regions of
-	 * the mirror that are in the NOSYNC state.  This
-	 * function asks the log to tell the caller about the
-	 * next region that this machine should recover.
-	 *
-	 * Do not confuse this function with 'in_sync()', one
-	 * tells you if an area is synchronised, the other
-	 * assigns recovery work.
-	*/
-	int (*get_resync_work)(struct dirty_log *log, region_t *region);
-
-	/*
-	 * This notifies the log that the resync status of a region
-	 * has changed.  It also clears the region from the recovering
-	 * list (if present).
-	 */
-	void (*set_region_sync)(struct dirty_log *log,
-				region_t region, int in_sync);
-
-        /*
-	 * Returns the number of regions that are in sync.
-         */
-        region_t (*get_sync_count)(struct dirty_log *log);
-
-	/*
-	 * Support function for mirror status requests.
-	 */
-	int (*status)(struct dirty_log *log, status_type_t status_type,
-		      char *result, unsigned int maxlen);
-};
-
-int dm_register_dirty_log_type(struct dirty_log_type *type);
-int dm_unregister_dirty_log_type(struct dirty_log_type *type);
-
-
-/*
- * Make sure you use these two functions, rather than calling
- * type->constructor/destructor() directly.
- */
-struct dirty_log *dm_create_dirty_log(const char *type_name, struct dm_target *ti,
-				      unsigned int argc, char **argv);
-void dm_destroy_dirty_log(struct dirty_log *log);
-
-/*
- * init/exit functions.
- */
-int dm_dirty_log_init(void);
-void dm_dirty_log_exit(void);
-
-#endif
diff --git linux-2.6.25-rc4.orig/drivers/md/kcopyd.h linux-2.6.25-rc4/drivers/md/kcopyd.h
deleted file mode 100644
index 4621ea0..0000000
--- linux-2.6.25-rc4.orig/drivers/md/kcopyd.h
+++ /dev/null
@@ -1,42 +0,0 @@
-/*
- * Copyright (C) 2001 Sistina Software
- *
- * This file is released under the GPL.
- *
- * Kcopyd provides a simple interface for copying an area of one
- * block-device to one or more other block-devices, with an asynchronous
- * completion notification.
- */
-
-#ifndef DM_KCOPYD_H
-#define DM_KCOPYD_H
-
-#include "dm-io.h"
-
-/* FIXME: make this configurable */
-#define KCOPYD_MAX_REGIONS 8
-
-#define KCOPYD_IGNORE_ERROR 1
-
-/*
- * To use kcopyd you must first create a kcopyd client object.
- */
-struct kcopyd_client;
-int kcopyd_client_create(unsigned int num_pages, struct kcopyd_client **result);
-void kcopyd_client_destroy(struct kcopyd_client *kc);
-
-/*
- * Submit a copy job to kcopyd.  This is built on top of the
- * previous three fns.
- *
- * read_err is a boolean,
- * write_err is a bitset, with 1 bit for each destination region
- */
-typedef void (*kcopyd_notify_fn)(int read_err,
-				 unsigned int write_err, void *context);
-
-int kcopyd_copy(struct kcopyd_client *kc, struct io_region *from,
-		unsigned int num_dests, struct io_region *dests,
-		unsigned int flags, kcopyd_notify_fn fn, void *context);
-
-#endif
diff --git linux-2.6.25-rc4.orig/include/linux/dm-io.h linux-2.6.25-rc4/include/linux/dm-io.h
new file mode 100644
index 0000000..f647e2c
--- /dev/null
+++ linux-2.6.25-rc4/include/linux/dm-io.h
@@ -0,0 +1,79 @@
+/*
+ * Copyright (C) 2003 Sistina Software
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef _DM_IO_H
+#define _DM_IO_H
+
+#include "dm.h"
+
+struct io_region {
+	struct block_device *bdev;
+	sector_t sector;
+	sector_t count;		/* If this is zero the region is ignored. */
+};
+
+struct page_list {
+	struct page_list *next;
+	struct page *page;
+};
+
+typedef void (*io_notify_fn)(unsigned long error, void *context);
+
+enum dm_io_mem_type {
+	DM_IO_PAGE_LIST,/* Page list */
+	DM_IO_BVEC,	/* Bio vector */
+	DM_IO_VMA,	/* Virtual memory area */
+	DM_IO_KMEM,	/* Kernel memory */
+};
+
+struct dm_io_memory {
+	enum dm_io_mem_type type;
+
+	union {
+		struct page_list *pl;
+		struct bio_vec *bvec;
+		void *vma;
+		void *addr;
+	} ptr;
+
+	unsigned offset;
+};
+
+struct dm_io_notify {
+	io_notify_fn fn;	/* Callback for asynchronous requests */
+	void *context;		/* Passed to callback */
+};
+
+/*
+ * IO request structure
+ */
+struct dm_io_client;
+struct dm_io_request {
+	int bi_rw;			/* READ|WRITE - not READA */
+	struct dm_io_memory mem;	/* Memory to use for io */
+	struct dm_io_notify notify;	/* Synchronous if notify.fn is NULL */
+	struct dm_io_client *client;	/* Client memory handler */
+};
+
+/*
+ * For async io calls, users can alternatively use the dm_io() function below
+ * and dm_io_client_create() to create private mempools for the client.
+ *
+ * Create/destroy may block.
+ */
+struct dm_io_client *dm_io_client_create(unsigned num_pages);
+int dm_io_client_resize(unsigned num_pages, struct dm_io_client *client);
+void dm_io_client_destroy(struct dm_io_client *client);
+
+/*
+ * IO interface using private per-client pools.
+ * Each bit in the optional 'sync_error_bits' bitset indicates whether an
+ * error occurred doing io to the corresponding region.
+ */
+int dm_io(struct dm_io_request *io_req, unsigned num_regions,
+	  struct io_region *region, unsigned long *sync_error_bits);
+
+#endif
diff --git linux-2.6.25-rc4.orig/include/linux/dm-kcopyd.h linux-2.6.25-rc4/include/linux/dm-kcopyd.h
new file mode 100644
index 0000000..4621ea0
--- /dev/null
+++ linux-2.6.25-rc4/include/linux/dm-kcopyd.h
@@ -0,0 +1,42 @@
+/*
+ * Copyright (C) 2001 Sistina Software
+ *
+ * This file is released under the GPL.
+ *
+ * Kcopyd provides a simple interface for copying an area of one
+ * block-device to one or more other block-devices, with an asynchronous
+ * completion notification.
+ */
+
+#ifndef DM_KCOPYD_H
+#define DM_KCOPYD_H
+
+#include "dm-io.h"
+
+/* FIXME: make this configurable */
+#define KCOPYD_MAX_REGIONS 8
+
+#define KCOPYD_IGNORE_ERROR 1
+
+/*
+ * To use kcopyd you must first create a kcopyd client object.
+ */
+struct kcopyd_client;
+int kcopyd_client_create(unsigned int num_pages, struct kcopyd_client **result);
+void kcopyd_client_destroy(struct kcopyd_client *kc);
+
+/*
+ * Submit a copy job to kcopyd.  This is built on top of the
+ * previous three fns.
+ *
+ * read_err is a boolean,
+ * write_err is a bitset, with 1 bit for each destination region
+ */
+typedef void (*kcopyd_notify_fn)(int read_err,
+				 unsigned int write_err, void *context);
+
+int kcopyd_copy(struct kcopyd_client *kc, struct io_region *from,
+		unsigned int num_dests, struct io_region *dests,
+		unsigned int flags, kcopyd_notify_fn fn, void *context);
+
+#endif
diff --git linux-2.6.25-rc4.orig/include/linux/dm-log.h linux-2.6.25-rc4/include/linux/dm-log.h
new file mode 100644
index 0000000..3fae87e
--- /dev/null
+++ linux-2.6.25-rc4/include/linux/dm-log.h
@@ -0,0 +1,131 @@
+/*
+ * Copyright (C) 2003 Sistina Software
+ *
+ * This file is released under the LGPL.
+ */
+
+#ifndef DM_DIRTY_LOG
+#define DM_DIRTY_LOG
+
+#include "dm.h"
+
+typedef sector_t region_t;
+
+struct dirty_log_type;
+
+struct dirty_log {
+	struct dirty_log_type *type;
+	void *context;
+};
+
+struct dirty_log_type {
+	struct list_head list;
+	const char *name;
+	struct module *module;
+	unsigned int use_count;
+
+	int (*ctr)(struct dirty_log *log, struct dm_target *ti,
+		   unsigned int argc, char **argv);
+	void (*dtr)(struct dirty_log *log);
+
+	/*
+	 * There are times when we don't want the log to touch
+	 * the disk.
+	 */
+	int (*presuspend)(struct dirty_log *log);
+	int (*postsuspend)(struct dirty_log *log);
+	int (*resume)(struct dirty_log *log);
+
+	/*
+	 * Retrieves the smallest size of region that the log can
+	 * deal with.
+	 */
+	uint32_t (*get_region_size)(struct dirty_log *log);
+
+        /*
+	 * A predicate to say whether a region is clean or not.
+	 * May block.
+	 */
+	int (*is_clean)(struct dirty_log *log, region_t region);
+
+	/*
+	 *  Returns: 0, 1, -EWOULDBLOCK, < 0
+	 *
+	 * A predicate function to check the area given by
+	 * [sector, sector + len) is in sync.
+	 *
+	 * If -EWOULDBLOCK is returned the state of the region is
+	 * unknown, typically this will result in a read being
+	 * passed to a daemon to deal with, since a daemon is
+	 * allowed to block.
+	 */
+	int (*in_sync)(struct dirty_log *log, region_t region, int can_block);
+
+	/*
+	 * Flush the current log state (eg, to disk).  This
+	 * function may block.
+	 */
+	int (*flush)(struct dirty_log *log);
+
+	/*
+	 * Mark an area as clean or dirty.  These functions may
+	 * block, though for performance reasons blocking should
+	 * be extremely rare (eg, allocating another chunk of
+	 * memory for some reason).
+	 */
+	void (*mark_region)(struct dirty_log *log, region_t region);
+	void (*clear_region)(struct dirty_log *log, region_t region);
+
+	/*
+	 * Returns: <0 (error), 0 (no region), 1 (region)
+	 *
+	 * The mirrord will need perform recovery on regions of
+	 * the mirror that are in the NOSYNC state.  This
+	 * function asks the log to tell the caller about the
+	 * next region that this machine should recover.
+	 *
+	 * Do not confuse this function with 'in_sync()', one
+	 * tells you if an area is synchronised, the other
+	 * assigns recovery work.
+	*/
+	int (*get_resync_work)(struct dirty_log *log, region_t *region);
+
+	/*
+	 * This notifies the log that the resync status of a region
+	 * has changed.  It also clears the region from the recovering
+	 * list (if present).
+	 */
+	void (*set_region_sync)(struct dirty_log *log,
+				region_t region, int in_sync);
+
+        /*
+	 * Returns the number of regions that are in sync.
+         */
+        region_t (*get_sync_count)(struct dirty_log *log);
+
+	/*
+	 * Support function for mirror status requests.
+	 */
+	int (*status)(struct dirty_log *log, status_type_t status_type,
+		      char *result, unsigned int maxlen);
+};
+
+int dm_register_dirty_log_type(struct dirty_log_type *type);
+int dm_unregister_dirty_log_type(struct dirty_log_type *type);
+
+
+/*
+ * Make sure you use these two functions, rather than calling
+ * type->constructor/destructor() directly.
+ */
+struct dirty_log *dm_create_dirty_log(const char *type_name, struct dm_target *ti,
+				      unsigned int argc, char **argv);
+void dm_destroy_dirty_log(struct dirty_log *log);
+
+/*
+ * init/exit functions.
+ */
+int dm_dirty_log_init(void);
+void dm_dirty_log_exit(void);
+
+#endif
-- 
1.5.4.1
