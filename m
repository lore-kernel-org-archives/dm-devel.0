From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 30] DM Snapshot: rename exception_table to
	dm_exception_table
Date: Thu, 19 Mar 2009 16:32:54 -0500
Message-ID: <200903192132.n2JLWsmN006511@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-rename-exception_table-to-dm_exception_table.patch

Rename exception_table for broader use outside dm-snap.c

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -51,7 +51,7 @@
 #define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
 					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
 
-struct exception_table {
+struct dm_exception_table {
 	uint32_t hash_mask;
 	unsigned hash_shift;
 	struct list_head *table;
@@ -75,8 +75,8 @@ struct dm_snapshot {
 
 	atomic_t pending_exceptions_count;
 
-	struct exception_table pending;
-	struct exception_table complete;
+	struct dm_exception_table pending;
+	struct dm_exception_table complete;
 
 	/*
 	 * pe_lock protects all pending_exception operations and access
@@ -348,7 +348,7 @@ static void unregister_snapshot(struct d
  * The lowest hash_shift bits of the chunk number are ignored, allowing
  * some consecutive chunks to be grouped together.
  */
-static int init_exception_table(struct exception_table *et, uint32_t size,
+static int init_exception_table(struct dm_exception_table *et, uint32_t size,
 				unsigned hash_shift)
 {
 	unsigned int i;
@@ -365,7 +365,7 @@ static int init_exception_table(struct e
 	return 0;
 }
 
-static void exit_exception_table(struct exception_table *et,
+static void exit_exception_table(struct dm_exception_table *et,
 				 struct kmem_cache *mem)
 {
 	struct list_head *slot;
@@ -383,12 +383,12 @@ static void exit_exception_table(struct 
 	vfree(et->table);
 }
 
-static uint32_t exception_hash(struct exception_table *et, chunk_t chunk)
+static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
 {
 	return (chunk >> et->hash_shift) & et->hash_mask;
 }
 
-static void insert_exception(struct exception_table *eh,
+static void insert_exception(struct dm_exception_table *eh,
 			     struct dm_exception *e)
 {
 	struct list_head *l = &eh->table[exception_hash(eh, e->old_chunk)];
@@ -404,7 +404,7 @@ static void remove_exception(struct dm_e
  * Return the exception data for a sector, or NULL if not
  * remapped.
  */
-static struct dm_exception *lookup_exception(struct exception_table *et,
+static struct dm_exception *lookup_exception(struct dm_exception_table *et,
 						  chunk_t chunk)
 {
 	struct list_head *slot;
@@ -458,7 +458,7 @@ static void free_pending_exception(struc
 static void insert_completed_exception(struct dm_snapshot *s,
 				       struct dm_exception *new_e)
 {
-	struct exception_table *eh = &s->complete;
+	struct dm_exception_table *eh = &s->complete;
 	struct list_head *l;
 	struct dm_exception *e = NULL;
 
