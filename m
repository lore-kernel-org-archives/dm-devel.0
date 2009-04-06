From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 15 of 33] DM Snapshot: move exception code to new
	file
Date: Mon, 6 Apr 2009 16:34:58 -0500
Message-ID: <200904062134.n36LYwXD020799@hydrogen.msp.redhat.com>
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
List-Id: dm-devel.ids

Patch name: dm-snap-move-exception-code-to-new-file.patch

Extract exception table/cache code from dm-snap.c so that
it can be used elsewhere.  I've created the new files,
dm-exception.[ch].  I chose against including this code in
this dm-exception-store.[ch] files.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -12,26 +12,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/device-mapper.h>
-
-/*
- * The snapshot code deals with largish chunks of the disk at a
- * time. Typically 32k - 512k.
- */
-typedef sector_t chunk_t;
-
-/*
- * An exception is used where an old chunk of data has been
- * replaced by a new one.
- * If chunk_t is 64 bits in size, the top 8 bits of new_chunk hold the number
- * of chunks that follow contiguously.  Remaining bits hold the number of the
- * chunk within the device.
- */
-struct dm_exception {
-	struct list_head hash_list;
-
-	chunk_t old_chunk;
-	chunk_t new_chunk;
-};
+#include "dm-exception.h"
 
 /*
  * Abstraction to handle the meta/layout of exception stores (the
@@ -109,49 +90,6 @@ struct dm_exception_store {
 };
 
 /*
- * Funtions to manipulate consecutive chunks
- */
-#  if defined(CONFIG_LBD) || (BITS_PER_LONG == 64)
-#    define DM_CHUNK_CONSECUTIVE_BITS 8
-#    define DM_CHUNK_NUMBER_BITS 56
-
-static inline chunk_t dm_chunk_number(chunk_t chunk)
-{
-	return chunk & (chunk_t)((1ULL << DM_CHUNK_NUMBER_BITS) - 1ULL);
-}
-
-static inline unsigned dm_consecutive_chunk_count(struct dm_exception *e)
-{
-	return e->new_chunk >> DM_CHUNK_NUMBER_BITS;
-}
-
-static inline void dm_consecutive_chunk_count_inc(struct dm_exception *e)
-{
-	e->new_chunk += (1ULL << DM_CHUNK_NUMBER_BITS);
-
-	BUG_ON(!dm_consecutive_chunk_count(e));
-}
-
-#  else
-#    define DM_CHUNK_CONSECUTIVE_BITS 0
-
-static inline chunk_t dm_chunk_number(chunk_t chunk)
-{
-	return chunk;
-}
-
-static inline unsigned dm_consecutive_chunk_count(struct dm_exception *e)
-{
-	return 0;
-}
-
-static inline void dm_consecutive_chunk_count_inc(struct dm_exception *e)
-{
-}
-
-#  endif
-
-/*
  * Return the number of sectors in the device.
  */
 static inline sector_t get_dev_size(struct block_device *bdev)
Index: linux-2.6/drivers/md/dm-exception.c
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-exception.c
@@ -0,0 +1,163 @@
+#include <linux/device-mapper.h>
+#include "dm-exception.h"
+
+struct dm_exception_table_internal {
+	struct dm_exception_table et;
+
+	struct dm_exception *(*alloc_exception)(void *context);
+	void *alloc_context;
+
+	void (*free_exception)(struct dm_exception *e, void *context);
+	void *free_context;
+};
+
+/*
+ * Implementation of the exception hash tables.
+ * The lowest hash_shift bits of the chunk number are ignored, allowing
+ * some consecutive chunks to be grouped together.
+ */
+struct dm_exception_table *
+dm_exception_table_create(uint32_t size, unsigned hash_shift,
+			  struct dm_exception *(*alloc_exception)(void *),
+			  void *alloc_context,
+			  void (*free_exception)(struct dm_exception *e, void *),
+			  void *free_context)
+{
+	unsigned int i;
+	struct dm_exception_table_internal *eti;
+	struct dm_exception_table *et;
+
+	eti = kmalloc(sizeof(*eti), GFP_KERNEL);
+	if (!eti)
+		return NULL;
+
+	et = &eti->et;
+
+	et->hash_shift = hash_shift;
+	et->hash_mask = size - 1;
+	et->table = dm_vcalloc(size, sizeof(struct list_head));
+	if (!et->table) {
+		kfree(et);
+		return NULL;
+	}
+
+	eti->alloc_exception = alloc_exception;
+	eti->alloc_context = alloc_context;
+	eti->free_exception = free_exception;
+	eti->free_context = free_context;
+
+	for (i = 0; i < size; i++)
+		INIT_LIST_HEAD(et->table + i);
+
+	return et;
+}
+
+void dm_exception_table_destroy(struct dm_exception_table *et)
+{
+	struct dm_exception_table_internal *eti;
+	struct list_head *slot;
+	struct dm_exception *ex, *next;
+	int i, size;
+
+	eti = container_of(et, struct dm_exception_table_internal, et);
+
+	size = et->hash_mask + 1;
+	for (i = 0; i < size; i++) {
+		slot = et->table + i;
+
+		list_for_each_entry_safe(ex, next, slot, hash_list)
+			eti->free_exception(ex, eti->free_context);
+	}
+
+	vfree(et->table);
+	kfree(eti);
+}
+
+static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
+{
+	return (chunk >> et->hash_shift) & et->hash_mask;
+}
+
+void dm_insert_exception(struct dm_exception_table *eh,
+			 struct dm_exception *new_e)
+{
+	struct list_head *l;
+	struct dm_exception *e = NULL;
+
+	l = &eh->table[exception_hash(eh, new_e->old_chunk)];
+
+	/* Add immediately if this table doesn't support consecutive chunks */
+	if (!eh->hash_shift)
+		goto out;
+
+	/* List is ordered by old_chunk */
+	list_for_each_entry_reverse(e, l, hash_list) {
+		/* Insert after an existing chunk? */
+		if (new_e->old_chunk == (e->old_chunk +
+					 dm_consecutive_chunk_count(e) + 1) &&
+		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) +
+					 dm_consecutive_chunk_count(e) + 1)) {
+			dm_consecutive_chunk_count_inc(e);
+			dm_free_exception(eh, new_e);
+			return;
+		}
+
+		/* Insert before an existing chunk? */
+		if (new_e->old_chunk == (e->old_chunk - 1) &&
+		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) - 1)) {
+			dm_consecutive_chunk_count_inc(e);
+			e->old_chunk--;
+			e->new_chunk--;
+			dm_free_exception(eh, new_e);
+			return;
+		}
+
+		if (new_e->old_chunk > e->old_chunk)
+			break;
+	}
+
+out:
+	list_add(&new_e->hash_list, e ? &e->hash_list : l);
+}
+
+void dm_remove_exception(struct dm_exception *e)
+{
+	list_del(&e->hash_list);
+}
+
+/*
+ * Return the exception data for a sector, or NULL if not
+ * remapped.
+ */
+struct dm_exception *dm_lookup_exception(struct dm_exception_table *et,
+					 chunk_t chunk)
+{
+	struct list_head *slot;
+	struct dm_exception *e;
+
+	slot = &et->table[exception_hash(et, chunk)];
+	list_for_each_entry(e, slot, hash_list)
+		if (chunk >= e->old_chunk &&
+		    chunk <= e->old_chunk + dm_consecutive_chunk_count(e))
+			return e;
+
+	return NULL;
+}
+
+struct dm_exception *dm_alloc_exception(struct dm_exception_table *et)
+{
+	struct dm_exception_table_internal *eti;
+
+	eti = container_of(et, struct dm_exception_table_internal, et);
+
+	return eti->alloc_exception(eti->alloc_context);
+}
+
+void dm_free_exception(struct dm_exception_table *et, struct dm_exception *e)
+{
+	struct dm_exception_table_internal *eti;
+
+	eti = container_of(et, struct dm_exception_table_internal, et);
+
+	return eti->free_exception(e, eti->free_context);
+}
Index: linux-2.6/drivers/md/dm-exception.h
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-exception.h
@@ -0,0 +1,104 @@
+/*
+ * Copyright (C) 2009 Red Hat, Inc. All rights reserved.
+ *
+ * Device-mapper exception structure and associated functions.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef __LINUX_DM_EXCEPTION__
+#define __LINUX_DM_EXCEPTION__
+
+#include <linux/blkdev.h>
+
+/*
+ * The snapshot code deals with largish chunks of the disk at a
+ * time. Typically 32k - 512k.
+ */
+typedef sector_t chunk_t;
+
+/*
+ * An exception is used where an old chunk of data has been
+ * replaced by a new one.
+ * If chunk_t is 64 bits in size, the top 8 bits of new_chunk hold the number
+ * of chunks that follow contiguously.  Remaining bits hold the number of the
+ * chunk within the device.
+ */
+struct dm_exception {
+	struct list_head hash_list;
+
+	chunk_t old_chunk;
+	chunk_t new_chunk;
+};
+
+struct dm_exception_table {
+	uint32_t hash_mask;
+	unsigned hash_shift;
+	struct list_head *table;
+};
+
+/*
+ * Funtions to manipulate consecutive chunks
+ */
+#  if defined(CONFIG_LBD) || (BITS_PER_LONG == 64)
+#    define DM_CHUNK_CONSECUTIVE_BITS 8
+#    define DM_CHUNK_NUMBER_BITS 56
+
+static inline chunk_t dm_chunk_number(chunk_t chunk)
+{
+	return chunk & (chunk_t)((1ULL << DM_CHUNK_NUMBER_BITS) - 1ULL);
+}
+
+static inline unsigned dm_consecutive_chunk_count(struct dm_exception *e)
+{
+	return e->new_chunk >> DM_CHUNK_NUMBER_BITS;
+}
+
+static inline void dm_consecutive_chunk_count_inc(struct dm_exception *e)
+{
+	e->new_chunk += (1ULL << DM_CHUNK_NUMBER_BITS);
+
+	BUG_ON(!dm_consecutive_chunk_count(e));
+}
+
+#  else
+#    define DM_CHUNK_CONSECUTIVE_BITS 0
+
+static inline chunk_t dm_chunk_number(chunk_t chunk)
+{
+	return chunk;
+}
+
+static inline unsigned dm_consecutive_chunk_count(struct dm_exception *e)
+{
+	return 0;
+}
+
+static inline void dm_consecutive_chunk_count_inc(struct dm_exception *e)
+{
+}
+
+#  endif
+
+struct dm_exception_table *
+dm_exception_table_create(uint32_t size, unsigned hash_shift,
+			  struct dm_exception *(*alloc_exception)(void *),
+			  void *alloc_context,
+			  void (*free_exception)(struct dm_exception *e, void *),
+			  void *free_context);
+
+void dm_exception_table_destroy(struct dm_exception_table *et);
+
+void dm_insert_exception(struct dm_exception_table *eh,
+			 struct dm_exception *e);
+
+void dm_remove_exception(struct dm_exception *e);
+
+struct dm_exception *dm_lookup_exception(struct dm_exception_table *et,
+					 chunk_t chunk);
+
+struct dm_exception *dm_alloc_exception(struct dm_exception_table *et);
+
+void dm_free_exception(struct dm_exception_table *et, struct dm_exception *e);
+
+#endif /* __LINUX_DM_EXCEPTION__ */
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -51,12 +51,6 @@
 #define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
 					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
 
-struct dm_exception_table {
-	uint32_t hash_mask;
-	unsigned hash_shift;
-	struct list_head *table;
-};
-
 struct dm_snapshot {
 	struct rw_semaphore lock;
 
@@ -343,126 +337,6 @@ static void unregister_snapshot(struct d
 	up_write(&_origins_lock);
 }
 
-struct dm_exception_table_internal {
-	struct dm_exception_table et;
-
-	struct dm_exception *(*alloc_exception)(void *context);
-	void *alloc_context;
-
-	void (*free_exception)(struct dm_exception *e, void *context);
-	void *free_context;
-};
-
-/*
- * Implementation of the exception hash tables.
- * The lowest hash_shift bits of the chunk number are ignored, allowing
- * some consecutive chunks to be grouped together.
- */
-static struct dm_exception_table *
-dm_exception_table_create(uint32_t size, unsigned hash_shift,
-			  struct dm_exception *(*alloc_exception)(void *),
-			  void *alloc_context,
-			  void (*free_exception)(struct dm_exception *e, void *),
-			  void *free_context)
-{
-	unsigned int i;
-	struct dm_exception_table_internal *eti;
-	struct dm_exception_table *et;
-
-	eti = kmalloc(sizeof(*eti), GFP_KERNEL);
-	if (!eti)
-		return NULL;
-
-	et = &eti->et;
-
-	et->hash_shift = hash_shift;
-	et->hash_mask = size - 1;
-	et->table = dm_vcalloc(size, sizeof(struct list_head));
-	if (!et->table) {
-		kfree(et);
-		return NULL;
-	}
-
-	eti->alloc_exception = alloc_exception;
-	eti->alloc_context = alloc_context;
-	eti->free_exception = free_exception;
-	eti->free_context = free_context;
-
-	for (i = 0; i < size; i++)
-		INIT_LIST_HEAD(et->table + i);
-
-	return et;
-}
-
-static void dm_exception_table_destroy(struct dm_exception_table *et)
-{
-	struct dm_exception_table_internal *eti;
-	struct list_head *slot;
-	struct dm_exception *ex, *next;
-	int i, size;
-
-	eti = container_of(et, struct dm_exception_table_internal, et);
-
-	size = et->hash_mask + 1;
-	for (i = 0; i < size; i++) {
-		slot = et->table + i;
-
-		list_for_each_entry_safe (ex, next, slot, hash_list)
-			eti->free_exception(ex, eti->free_context);
-	}
-
-	vfree(et->table);
-	kfree(eti);
-}
-
-static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
-{
-	return (chunk >> et->hash_shift) & et->hash_mask;
-}
-
-static void dm_remove_exception(struct dm_exception *e)
-{
-	list_del(&e->hash_list);
-}
-
-/*
- * Return the exception data for a sector, or NULL if not
- * remapped.
- */
-static struct dm_exception *dm_lookup_exception(struct dm_exception_table *et,
-						chunk_t chunk)
-{
-	struct list_head *slot;
-	struct dm_exception *e;
-
-	slot = &et->table[exception_hash(et, chunk)];
-	list_for_each_entry (e, slot, hash_list)
-		if (chunk >= e->old_chunk &&
-		    chunk <= e->old_chunk + dm_consecutive_chunk_count(e))
-			return e;
-
-	return NULL;
-}
-
-static struct dm_exception *dm_alloc_exception(struct dm_exception_table *et)
-{
-	struct dm_exception_table_internal *eti;
-
-	eti = container_of(et, struct dm_exception_table_internal, et);
-
-	return eti->alloc_exception(eti->alloc_context);
-}
-
-static void dm_free_exception(struct dm_exception_table *et,
-			      struct dm_exception *e)
-{
-	struct dm_exception_table_internal *eti;
-
-	eti = container_of(et, struct dm_exception_table_internal, et);
-
-	return eti->free_exception(e, eti->free_context);
-}
-
 static struct dm_exception *alloc_completed_exception(void *unused)
 {
 	struct dm_exception *e;
@@ -504,48 +378,6 @@ static void free_pending_exception(struc
 	atomic_dec(&s->pending_exceptions_count);
 }
 
-static void dm_insert_exception(struct dm_exception_table *eh,
-				struct dm_exception *new_e)
-{
-	struct list_head *l;
-	struct dm_exception *e = NULL;
-
-	l = &eh->table[exception_hash(eh, new_e->old_chunk)];
-
-	/* Add immediately if this table doesn't support consecutive chunks */
-	if (!eh->hash_shift)
-		goto out;
-
-	/* List is ordered by old_chunk */
-	list_for_each_entry_reverse(e, l, hash_list) {
-		/* Insert after an existing chunk? */
-		if (new_e->old_chunk == (e->old_chunk +
-					 dm_consecutive_chunk_count(e) + 1) &&
-		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) +
-					 dm_consecutive_chunk_count(e) + 1)) {
-			dm_consecutive_chunk_count_inc(e);
-			dm_free_exception(eh, new_e);
-			return;
-		}
-
-		/* Insert before an existing chunk? */
-		if (new_e->old_chunk == (e->old_chunk - 1) &&
-		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) - 1)) {
-			dm_consecutive_chunk_count_inc(e);
-			e->old_chunk--;
-			e->new_chunk--;
-			dm_free_exception(eh, new_e);
-			return;
-		}
-
-		if (new_e->old_chunk > e->old_chunk)
-			break;
-	}
-
-out:
-	list_add(&new_e->hash_list, e ? &e->hash_list : l);
-}
-
 /*
  * Callback used by the exception stores to load exceptions when
  * initialising.
Index: linux-2.6/drivers/md/Makefile
===================================================================
--- linux-2.6.orig/drivers/md/Makefile
+++ linux-2.6/drivers/md/Makefile
@@ -5,8 +5,8 @@
 dm-mod-objs	:= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
 		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o
 dm-multipath-objs := dm-path-selector.o dm-mpath.o
-dm-snapshot-objs := dm-snap.o dm-exception-store.o dm-snap-transient.o \
-		    dm-snap-persistent.o
+dm-snapshot-objs := dm-snap.o dm-exception.o dm-exception-store.o \
+		    dm-snap-persistent.o dm-snap-transient.o
 dm-mirror-objs	:= dm-raid1.o
 md-mod-objs     := md.o bitmap.o
 raid456-objs	:= raid5.o raid6algos.o raid6recov.o raid6tables.o \
