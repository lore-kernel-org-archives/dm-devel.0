From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 01/18]
	dm-snap-consolidate-insert_exception-functions
Date: Tue, 29 Sep 2009 18:53:26 -0400
Message-ID: <1254264823-11538-2-git-send-email-snitzer@redhat.com>
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

Consolidate the insert_*exception functions.  'insert_completed_exception'
already contains all the logic to handle 'insert_exception' (via
check for a hash_shift of 0), so remove redundant function.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index f3473e8..3734289 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -385,13 +385,6 @@ static uint32_t exception_hash(struct exception_table *et, chunk_t chunk)
 	return (chunk >> et->hash_shift) & et->hash_mask;
 }
 
-static void insert_exception(struct exception_table *eh,
-			     struct dm_snap_exception *e)
-{
-	struct list_head *l = &eh->table[exception_hash(eh, e->old_chunk)];
-	list_add(&e->hash_list, l);
-}
-
 static void remove_exception(struct dm_snap_exception *e)
 {
 	list_del(&e->hash_list);
@@ -452,10 +445,9 @@ static void free_pending_exception(struct dm_snap_pending_exception *pe)
 	atomic_dec(&s->pending_exceptions_count);
 }
 
-static void insert_completed_exception(struct dm_snapshot *s,
-				       struct dm_snap_exception *new_e)
+static void insert_exception(struct exception_table *eh,
+			     struct dm_snap_exception *new_e)
 {
-	struct exception_table *eh = &s->complete;
 	struct list_head *l;
 	struct dm_snap_exception *e = NULL;
 
@@ -513,7 +505,7 @@ static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 	/* Consecutive_count is implicitly initialised to zero */
 	e->new_chunk = new;
 
-	insert_completed_exception(s, e);
+	insert_exception(&s->complete, e);
 
 	return 0;
 }
@@ -918,7 +910,7 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 	 * Add a proper exception, and remove the
 	 * in-flight exception from the list.
 	 */
-	insert_completed_exception(s, e);
+	insert_exception(&s->complete, e);
 
  out:
 	remove_exception(&pe->e);
-- 
1.6.2.5
