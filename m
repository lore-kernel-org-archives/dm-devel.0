From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 05/18]
	dm-snapshot-rename-exception_table-to-dm_exception_table
Date: Tue, 29 Sep 2009 18:53:30 -0400
Message-ID: <1254264823-11538-6-git-send-email-snitzer@redhat.com>
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

Rename exception_table for broader use outside dm-snap.c

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 2da5b2b..69fc1f5 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -50,7 +50,7 @@
 #define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
 					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
 
-struct exception_table {
+struct dm_exception_table {
 	uint32_t hash_mask;
 	unsigned hash_shift;
 	struct list_head *table;
@@ -74,8 +74,8 @@ struct dm_snapshot {
 
 	atomic_t pending_exceptions_count;
 
-	struct exception_table pending;
-	struct exception_table complete;
+	struct dm_exception_table pending;
+	struct dm_exception_table complete;
 
 	/*
 	 * pe_lock protects all pending_exception operations and access
@@ -347,7 +347,7 @@ static void unregister_snapshot(struct dm_snapshot *s)
  * The lowest hash_shift bits of the chunk number are ignored, allowing
  * some consecutive chunks to be grouped together.
  */
-static int init_exception_table(struct exception_table *et, uint32_t size,
+static int init_exception_table(struct dm_exception_table *et, uint32_t size,
 				unsigned hash_shift)
 {
 	unsigned int i;
@@ -364,7 +364,8 @@ static int init_exception_table(struct exception_table *et, uint32_t size,
 	return 0;
 }
 
-static void exit_exception_table(struct exception_table *et, struct kmem_cache *mem)
+static void exit_exception_table(struct dm_exception_table *et,
+				 struct kmem_cache *mem)
 {
 	struct list_head *slot;
 	struct dm_exception *ex, *next;
@@ -381,7 +382,7 @@ static void exit_exception_table(struct exception_table *et, struct kmem_cache *
 	vfree(et->table);
 }
 
-static uint32_t exception_hash(struct exception_table *et, chunk_t chunk)
+static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
 {
 	return (chunk >> et->hash_shift) & et->hash_mask;
 }
@@ -395,7 +396,7 @@ static void remove_exception(struct dm_exception *e)
  * Return the exception data for a sector, or NULL if not
  * remapped.
  */
-static struct dm_exception *lookup_exception(struct exception_table *et,
+static struct dm_exception *lookup_exception(struct dm_exception_table *et,
 						  chunk_t chunk)
 {
 	struct list_head *slot;
@@ -446,7 +447,7 @@ static void free_pending_exception(struct dm_snap_pending_exception *pe)
 	atomic_dec(&s->pending_exceptions_count);
 }
 
-static void insert_exception(struct exception_table *eh,
+static void insert_exception(struct dm_exception_table *eh,
 			     struct dm_exception *new_e)
 {
 	struct list_head *l;
-- 
1.6.2.5
