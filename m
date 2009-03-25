From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 12 of 33] DM Snapshot: exception function changes
	4
Date: Wed, 25 Mar 2009 16:35:34 -0500
Message-ID: <200903252135.n2PLZYaY021430@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-exception-function-changes-4.patch

This patch alters the dm_exception_table_create and dm_exception_table_destroy
functions to take in the function pointers for the exception [de]allocation
functions.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -359,7 +359,11 @@ struct dm_exception_table_internal {
  * some consecutive chunks to be grouped together.
  */
 static struct dm_exception_table *
-dm_exception_table_create(uint32_t size, unsigned hash_shift)
+dm_exception_table_create(uint32_t size, unsigned hash_shift,
+			  struct dm_exception *(*alloc_exception)(void *),
+			  void *alloc_context,
+			  void (*free_exception)(struct dm_exception *e, void *),
+			  void *free_context)
 {
 	unsigned int i;
 	struct dm_exception_table_internal *eti;
@@ -379,14 +383,18 @@ dm_exception_table_create(uint32_t size,
 		return NULL;
 	}
 
+	eti->alloc_exception = alloc_exception;
+	eti->alloc_context = alloc_context;
+	eti->free_exception = free_exception;
+	eti->free_context = free_context;
+
 	for (i = 0; i < size; i++)
 		INIT_LIST_HEAD(et->table + i);
 
 	return et;
 }
 
-static void dm_exception_table_destroy(struct dm_exception_table *et,
-				       struct kmem_cache *mem)
+static void dm_exception_table_destroy(struct dm_exception_table *et)
 {
 	struct dm_exception_table_internal *eti;
 	struct list_head *slot;
@@ -400,7 +408,7 @@ static void dm_exception_table_destroy(s
 		slot = et->table + i;
 
 		list_for_each_entry_safe (ex, next, slot, hash_list)
-			kmem_cache_free(mem, ex);
+			eti->free_exception(ex, eti->free_context);
 	}
 
 	vfree(et->table);
@@ -575,7 +583,9 @@ static int init_hash_tables(struct dm_sn
 	hash_size = rounddown_pow_of_two(hash_size);
 
 	s->complete = dm_exception_table_create(hash_size,
-						DM_CHUNK_CONSECUTIVE_BITS);
+						DM_CHUNK_CONSECUTIVE_BITS,
+						alloc_completed_exception, NULL,
+						free_completed_exception, NULL);
 	if (!s->complete)
 		return -ENOMEM;
 
@@ -587,9 +597,11 @@ static int init_hash_tables(struct dm_sn
 	if (hash_size < 64)
 		hash_size = 64;
 
-	s->pending = dm_exception_table_create(hash_size, 0);
+	s->pending = dm_exception_table_create(hash_size, 0,
+					       alloc_pending_exception, s,
+					       free_pending_exception, NULL);
 	if (!s->pending) {
-		dm_exception_table_destroy(s->complete, exception_cache);
+		dm_exception_table_destroy(s->complete);
 		return -ENOMEM;
 	}
 
@@ -781,8 +793,8 @@ bad_pending_pool:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 
 bad_kcopyd:
-	dm_exception_table_destroy(s->pending, pending_cache);
-	dm_exception_table_destroy(s->complete, exception_cache);
+	dm_exception_table_destroy(s->pending);
+	dm_exception_table_destroy(s->complete);
 
 bad_hash_tables:
 	dm_put_device(ti, s->origin);
@@ -801,8 +813,8 @@ static void __free_exceptions(struct dm_
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 	s->kcopyd_client = NULL;
 
-	dm_exception_table_destroy(s->pending, pending_cache);
-	dm_exception_table_destroy(s->complete, exception_cache);
+	dm_exception_table_destroy(s->pending);
+	dm_exception_table_destroy(s->complete);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
