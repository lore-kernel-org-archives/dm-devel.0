From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 7 of 12]: dm-snapshot-remove-dm_snap-header.patch
Date: Tue, 20 Jan 2009 14:02:47 -0600
Message-ID: <1232481767.19993.33.camel@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

 brassow

Move some of the last bits from dm-snap.h into dm-snap.c where they
belong and remove dm-snap.h.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.28/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.c	2009-01-08 02:29:30.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap.c	2009-01-08 02:40:56.000000000 +0000
@@ -20,9 +20,9 @@
 #include <linux/vmalloc.h>
 #include <linux/log2.h>
 #include <linux/dm-kcopyd.h>
+#include <linux/workqueue.h>
 
 #include "dm-exception-store.h"
-#include "dm-snap.h"
 #include "dm-bio-list.h"
 
 #define DM_MSG_PREFIX "snapshots"
@@ -47,9 +47,79 @@
  */
 #define MIN_IOS 256
 
+#define DM_TRACKED_CHUNK_HASH_SIZE	16
+#define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
+					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
+
+struct exception_table {
+	uint32_t hash_mask;
+	unsigned hash_shift;
+	struct list_head *table;
+};
+
+struct dm_snapshot {
+	struct rw_semaphore lock;
+
+	struct dm_dev *origin;
+
+	/* List of snapshots per Origin */
+	struct list_head list;
+
+	/* You can't use a snapshot if this is 0 (e.g. if full) */
+	int valid;
+
+	/* Origin writes don't trigger exceptions until this is set */
+	int active;
+
+	/* Used for display of table */
+	char type;
+
+	mempool_t *pending_pool;
+
+	atomic_t pending_exceptions_count;
+
+	struct exception_table pending;
+	struct exception_table complete;
+
+	/*
+	 * pe_lock protects all pending_exception operations and access
+	 * as well as the snapshot_bios list.
+	 */
+	spinlock_t pe_lock;
+
+	/* The on disk metadata handler */
+	struct dm_exception_store *store;
+
+	struct dm_kcopyd_client *kcopyd_client;
+
+	/* Queue of snapshot writes for ksnapd to flush */
+	struct bio_list queued_bios;
+	struct work_struct queued_bios_work;
+
+	/* Chunks with outstanding reads */
+	mempool_t *tracked_chunk_pool;
+	spinlock_t tracked_chunk_lock;
+	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
+};
+
 static struct workqueue_struct *ksnapd;
 static void flush_queued_bios(struct work_struct *work);
 
+static sector_t chunk_to_sector(struct dm_exception_store *store,
+				chunk_t chunk)
+{
+	return chunk << store->chunk_shift;
+}
+
+static int bdev_equal(struct block_device *lhs, struct block_device *rhs)
+{
+	/*
+	 * There is only ever one instance of a particular block
+	 * device so we can compare pointers safely.
+	 */
+	return lhs == rhs;
+}
+
 struct dm_snap_pending_exception {
 	struct dm_snap_exception e;
 
Index: linux-2.6.28/drivers/md/dm-snap.h
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.h	2009-01-08 02:36:13.000000000 +0000
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,86 +0,0 @@
-/*
- * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
- *
- * This file is released under the GPL.
- */
-
-#ifndef DM_SNAPSHOT_H
-#define DM_SNAPSHOT_H
-
-#include <linux/device-mapper.h>
-#include "dm-exception-store.h"
-#include "dm-bio-list.h"
-#include <linux/blkdev.h>
-#include <linux/workqueue.h>
-
-struct exception_table {
-	uint32_t hash_mask;
-	unsigned hash_shift;
-	struct list_head *table;
-};
-
-#define DM_TRACKED_CHUNK_HASH_SIZE	16
-#define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
-					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
-
-struct dm_snapshot {
-	struct rw_semaphore lock;
-
-	struct dm_dev *origin;
-
-	/* List of snapshots per Origin */
-	struct list_head list;
-
-	/* You can't use a snapshot if this is 0 (e.g. if full) */
-	int valid;
-
-	/* Origin writes don't trigger exceptions until this is set */
-	int active;
-
-	/* Used for display of table */
-	char type;
-
-	mempool_t *pending_pool;
-
-	atomic_t pending_exceptions_count;
-
-	struct exception_table pending;
-	struct exception_table complete;
-
-	/*
-	 * pe_lock protects all pending_exception operations and access
-	 * as well as the snapshot_bios list.
-	 */
-	spinlock_t pe_lock;
-
-	/* The on disk metadata handler */
-	struct dm_exception_store *store;
-
-	struct dm_kcopyd_client *kcopyd_client;
-
-	/* Queue of snapshot writes for ksnapd to flush */
-	struct bio_list queued_bios;
-	struct work_struct queued_bios_work;
-
-	/* Chunks with outstanding reads */
-	mempool_t *tracked_chunk_pool;
-	spinlock_t tracked_chunk_lock;
-	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
-};
-
-static inline sector_t chunk_to_sector(struct dm_exception_store *store,
-				      chunk_t chunk)
-{
-	return chunk << store->chunk_shift;
-}
-
-static inline int bdev_equal(struct block_device *lhs, struct block_device *rhs)
-{
-	/*
-	 * There is only ever one instance of a particular block
-	 * device so we can compare pointers safely.
-	 */
-	return lhs == rhs;
-}
-
-#endif
