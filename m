From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 12/18] dm-snapshot-exception-function-changes-5
Date: Tue, 29 Sep 2009 18:53:37 -0400
Message-ID: <1254264823-11538-13-git-send-email-snitzer@redhat.com>
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

This patch introduces the dm_alloc_exception and dm_free_exception
functions.  They are now the official way to [de]allocate exceptions
via the new interface.  These functions call the [de]allocation functions
specified during the creation of the exception table and use the context
provided at that time.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 2ec51b6..fabf833 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -443,6 +443,25 @@ static struct dm_exception *dm_lookup_exception(struct dm_exception_table *et,
 	return NULL;
 }
 
+static struct dm_exception *dm_alloc_exception(struct dm_exception_table *et)
+{
+	struct dm_exception_table_internal *eti;
+
+	eti = container_of(et, struct dm_exception_table_internal, et);
+
+	return eti->alloc_exception(eti->alloc_context);
+}
+
+static void dm_free_exception(struct dm_exception_table *et,
+			      struct dm_exception *e)
+{
+	struct dm_exception_table_internal *eti;
+
+	eti = container_of(et, struct dm_exception_table_internal, et);
+
+	return eti->free_exception(e, eti->free_context);
+}
+
 static struct dm_exception *alloc_completed_exception(void *unused)
 {
 	struct dm_exception *e;
@@ -504,7 +523,7 @@ static void dm_insert_exception(struct dm_exception_table *eh,
 		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) +
 					 dm_consecutive_chunk_count(e) + 1)) {
 			dm_consecutive_chunk_count_inc(e);
-			free_completed_exception(new_e, NULL);
+			dm_free_exception(eh, new_e);
 			return;
 		}
 
@@ -535,7 +554,7 @@ static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
-	e = alloc_completed_exception(NULL);
+	e = dm_alloc_exception(s->complete);
 	if (!e)
 		return -ENOMEM;
 
@@ -985,7 +1004,7 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 		goto out;
 	}
 
-	e = alloc_completed_exception(NULL);
+	e = dm_alloc_exception(s->complete);
 	if (!e) {
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
@@ -996,7 +1015,7 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 
 	down_write(&s->lock);
 	if (!s->valid) {
-		free_completed_exception(e, NULL);
+		dm_free_exception(s->complete, e);
 		error = 1;
 		goto out;
 	}
-- 
1.6.2.5
