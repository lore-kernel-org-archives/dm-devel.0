From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 10/18] dm-snapshot-exception-function-changes-3
Date: Tue, 29 Sep 2009 18:53:35 -0400
Message-ID: <1254264823-11538-11-git-send-email-snitzer@redhat.com>
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

This patch adds the 'dm_exception_table_internal' structure.  It is used
to track the [de]allocation functions used for dm_exception's.  This is
necessary because some functions, like dm_insert_exception and
dm_exception_table_destroy must access them to do the right thing when
freeing exceptions.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
---
 drivers/md/dm-snap.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index df8cb32..1a664ec 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -342,6 +342,16 @@ static void unregister_snapshot(struct dm_snapshot *s)
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
@@ -351,12 +361,15 @@ static struct dm_exception_table *
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
@@ -374,10 +387,13 @@ dm_exception_table_create(uint32_t size, unsigned hash_shift)
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
@@ -387,7 +403,7 @@ static void dm_exception_table_destroy(struct dm_exception_table *et,
 	}
 
 	vfree(et->table);
-	kfree(et);
+	kfree(eti);
 }
 
 static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
-- 
1.6.2.5
