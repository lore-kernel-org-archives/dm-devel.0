From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 11/18] dm-snapshot-exception-function-changes-4
Date: Tue, 29 Sep 2009 18:53:36 -0400
Message-ID: <1254264823-11538-12-git-send-email-snitzer@redhat.com>
References: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
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

From: Jon Brassow <jbrassow@redhat.com>

This patch alters the dm_exception_table_create and dm_exception_table_destroy
functions to take in the function pointers for the exception [de]allocation
functions.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   34 +++++++++++++++++++++++-----------
 1 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 1a664ec..2ec51b6 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -358,7 +358,11 @@ struct dm_exception_table_internal {
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
@@ -378,14 +382,18 @@ dm_exception_table_create(uint32_t size, unsigned hash_shift)
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
@@ -399,7 +407,7 @@ static void dm_exception_table_destroy(struct dm_exception_table *et,
 		slot = et->table + i;
 
 		list_for_each_entry_safe (ex, next, slot, hash_list)
-			kmem_cache_free(mem, ex);
+			eti->free_exception(ex, eti->free_context);
 	}
 
 	vfree(et->table);
@@ -593,7 +601,9 @@ static int init_hash_tables(struct dm_snapshot *s)
 	hash_size = rounddown_pow_of_two(hash_size);
 
 	s->complete = dm_exception_table_create(hash_size,
-						DM_CHUNK_CONSECUTIVE_BITS);
+						DM_CHUNK_CONSECUTIVE_BITS,
+						alloc_completed_exception, NULL,
+						free_completed_exception, NULL);
 	if (!s->complete)
 		return -ENOMEM;
 
@@ -605,9 +615,11 @@ static int init_hash_tables(struct dm_snapshot *s)
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
 
@@ -799,8 +811,8 @@ bad_pending_pool:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 
 bad_kcopyd:
-	dm_exception_table_destroy(s->pending, pending_cache);
-	dm_exception_table_destroy(s->complete, exception_cache);
+	dm_exception_table_destroy(s->pending);
+	dm_exception_table_destroy(s->complete);
 
 bad_hash_tables:
 	dm_put_device(ti, s->origin);
@@ -819,8 +831,8 @@ static void __free_exceptions(struct dm_snapshot *s)
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 	s->kcopyd_client = NULL;
 
-	dm_exception_table_destroy(s->pending, pending_cache);
-	dm_exception_table_destroy(s->complete, exception_cache);
+	dm_exception_table_destroy(s->pending);
+	dm_exception_table_destroy(s->complete);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
-- 
1.6.2.5
