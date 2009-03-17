From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 8 of 29]
	dm-snap-exception-function-changes-3.patch
Date: Tue, 17 Mar 2009 09:03:31 -0500
Message-ID: <200903171403.n2HE3VWd017384@hydrogen.msp.redhat.com>
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

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -343,6 +343,16 @@ static void unregister_snapshot(struct d
 	up_write(&_origins_lock);
 }
 
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
 /*
  * Implementation of the exception hash tables.
  * The lowest hash_shift bits of the chunk number are ignored, allowing
@@ -352,12 +362,15 @@ static struct dm_exception_table *
 dm_exception_table_create(uint32_t size, unsigned hash_shift)
 {
 	unsigned int i;
+	struct dm_exception_table_internal *eti;
 	struct dm_exception_table *et;
 
-	et = kmalloc(sizeof(*et), GFP_KERNEL);
-	if (!et)
+	eti = kmalloc(sizeof(*eti), GFP_KERNEL);
+	if (!eti)
 		return NULL;
 
+	et = &eti->et;
+
 	et->hash_shift = hash_shift;
 	et->hash_mask = size - 1;
 	et->table = dm_vcalloc(size, sizeof(struct list_head));
@@ -375,10 +388,13 @@ dm_exception_table_create(uint32_t size,
 static void dm_exception_table_destroy(struct dm_exception_table *et,
 				       struct kmem_cache *mem)
 {
+	struct dm_exception_table_internal *eti;
 	struct list_head *slot;
 	struct dm_exception *ex, *next;
 	int i, size;
 
+	eti = container_of(et, struct dm_exception_table_internal, et);
+
 	size = et->hash_mask + 1;
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
@@ -388,7 +404,7 @@ static void dm_exception_table_destroy(s
 	}
 
 	vfree(et->table);
-	kfree(et);
+	kfree(eti);
 }
 
 static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
