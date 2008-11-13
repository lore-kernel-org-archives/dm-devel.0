From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 5] dm-exception-store API
Date: Thu, 13 Nov 2008 04:12:22 -0600
Message-ID: <1226571142.6033.20.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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
To: dm-devel@redhat.com, fujita.tomonori@lab.ntt.co.jp
List-Id: dm-devel.ids

 brassow

Creation of dm-exception-store.h

Pull structures that bridge the gap between snapshot and
exception store out of dm-snap.h and put them in a new
.h file - dm-exception-store.h.  This file will define the
API for new exception stores.

Ultimately, dm-snap.h is unnecessary, since only dm-snap.c
should be using it.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.c
+++ linux-2.6/drivers/md/dm-exception-store.c
@@ -7,6 +7,7 @@
  * This file is released under the GPL.
  */
 
+#include "dm-exception-store.h"
 #include "dm-snap.h"
 
 #include <linux/mm.h>
Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- /dev/null
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -0,0 +1,131 @@
+/*
+ * Copyright (C) 2008 Red Hat, Inc.  All rights reserved.
+ *
+ * Device-mapper exception store.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef _LINUX_DM_EXCEPTION_STORE
+#define _LINUX_DM_EXCEPTION_STORE
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
+struct dm_snap_exception {
+	struct list_head hash_list;
+
+	chunk_t old_chunk;
+	chunk_t new_chunk;
+};
+
+/*
+ * Abstraction to handle the meta/layout of exception stores (the
+ * COW device).
+ */
+struct exception_store {
+
+	/*
+	 * Destroys this object when you've finished with it.
+	 */
+	void (*destroy) (struct exception_store *store);
+
+	/*
+	 * The target shouldn't read the COW device until this is
+	 * called.
+	 */
+	int (*read_metadata) (struct exception_store *store);
+
+	/*
+	 * Find somewhere to store the next exception.
+	 */
+	int (*prepare_exception) (struct exception_store *store,
+				  struct dm_snap_exception *e);
+
+	/*
+	 * Update the metadata with this exception.
+	 */
+	void (*commit_exception) (struct exception_store *store,
+				  struct dm_snap_exception *e,
+				  void (*callback) (void *, int success),
+				  void *callback_context);
+
+	/*
+	 * The snapshot is invalid, note this in the metadata.
+	 */
+	void (*drop_snapshot) (struct exception_store *store);
+
+	/*
+	 * Return how full the snapshot is.
+	 */
+	void (*fraction_full) (struct exception_store *store,
+			       sector_t *numerator,
+			       sector_t *denominator);
+
+	struct dm_snapshot *snap;
+	void *context;
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
+static inline unsigned dm_consecutive_chunk_count(struct dm_snap_exception *e)
+{
+	return e->new_chunk >> DM_CHUNK_NUMBER_BITS;
+}
+
+static inline void dm_consecutive_chunk_count_inc(struct dm_snap_exception *e)
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
+static inline unsigned dm_consecutive_chunk_count(struct dm_snap_exception *e)
+{
+	return 0;
+}
+
+static inline void dm_consecutive_chunk_count_inc(struct dm_snap_exception *e)
+{
+}
+
+#  endif
+
+/*
+ * Constructor and destructor for the exception stores
+ */
+int dm_create_persistent(struct exception_store *store);
+
+int dm_create_transient(struct exception_store *store);
+
+#endif /* _LINUX_DM_EXCEPTION_STORE */
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -20,6 +20,7 @@
 #include <linux/log2.h>
 #include <linux/dm-kcopyd.h>
 
+#include "dm-exception-store.h"
 #include "dm-snap.h"
 #include "dm-bio-list.h"
 
Index: linux-2.6/drivers/md/dm-snap.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.h
+++ linux-2.6/drivers/md/dm-snap.h
@@ -20,116 +20,6 @@ struct exception_table {
 	struct list_head *table;
 };
 
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
-struct dm_snap_exception {
-	struct list_head hash_list;
-
-	chunk_t old_chunk;
-	chunk_t new_chunk;
-};
-
-/*
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
-static inline unsigned dm_consecutive_chunk_count(struct dm_snap_exception *e)
-{
-	return e->new_chunk >> DM_CHUNK_NUMBER_BITS;
-}
-
-static inline void dm_consecutive_chunk_count_inc(struct dm_snap_exception *e)
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
-static inline unsigned dm_consecutive_chunk_count(struct dm_snap_exception *e)
-{
-	return 0;
-}
-
-static inline void dm_consecutive_chunk_count_inc(struct dm_snap_exception *e)
-{
-}
-
-#  endif
-
-/*
- * Abstraction to handle the meta/layout of exception stores (the
- * COW device).
- */
-struct exception_store {
-
-	/*
-	 * Destroys this object when you've finished with it.
-	 */
-	void (*destroy) (struct exception_store *store);
-
-	/*
-	 * The target shouldn't read the COW device until this is
-	 * called.
-	 */
-	int (*read_metadata) (struct exception_store *store);
-
-	/*
-	 * Find somewhere to store the next exception.
-	 */
-	int (*prepare_exception) (struct exception_store *store,
-				  struct dm_snap_exception *e);
-
-	/*
-	 * Update the metadata with this exception.
-	 */
-	void (*commit_exception) (struct exception_store *store,
-				  struct dm_snap_exception *e,
-				  void (*callback) (void *, int success),
-				  void *callback_context);
-
-	/*
-	 * The snapshot is invalid, note this in the metadata.
-	 */
-	void (*drop_snapshot) (struct exception_store *store);
-
-	/*
-	 * Return how full the snapshot is.
-	 */
-	void (*fraction_full) (struct exception_store *store,
-			       sector_t *numerator,
-			       sector_t *denominator);
-
-	struct dm_snapshot *snap;
-	void *context;
-};
-
 #define DM_TRACKED_CHUNK_HASH_SIZE	16
 #define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
 					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
@@ -193,14 +83,6 @@ struct dm_snapshot {
 int dm_add_exception(struct dm_snapshot *s, chunk_t old, chunk_t new);
 
 /*
- * Constructor and destructor for the default persistent
- * store.
- */
-int dm_create_persistent(struct exception_store *store);
-
-int dm_create_transient(struct exception_store *store);
-
-/*
  * Return the number of sectors in the device.
  */
 static inline sector_t get_dev_size(struct block_device *bdev)
