From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 6 of 33] DM Snapshot: consolidate
	insert_exception functions
Date: Mon, 6 Apr 2009 16:33:27 -0500
Message-ID: <200904062133.n36LXRtw020138@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-consolidate-insert_exception-functions.patch

It is ridiculous to have two 'insert_*exception' functions when one
of the functions already handles both cases.  Consolidating them.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -388,13 +388,6 @@ static uint32_t exception_hash(struct dm
 	return (chunk >> et->hash_shift) & et->hash_mask;
 }
 
-static void insert_exception(struct dm_exception_table *eh,
-			     struct dm_exception *e)
-{
-	struct list_head *l = &eh->table[exception_hash(eh, e->old_chunk)];
-	list_add(&e->hash_list, l);
-}
-
 static void remove_exception(struct dm_exception *e)
 {
 	list_del(&e->hash_list);
@@ -455,10 +448,9 @@ static void free_pending_exception(struc
 	atomic_dec(&s->pending_exceptions_count);
 }
 
-static void insert_completed_exception(struct dm_snapshot *s,
-				       struct dm_exception *new_e)
+static void insert_exception(struct dm_exception_table *eh,
+			     struct dm_exception *new_e)
 {
-	struct dm_exception_table *eh = &s->complete;
 	struct list_head *l;
 	struct dm_exception *e = NULL;
 
@@ -516,7 +508,7 @@ static int dm_add_exception(void *contex
 	/* Consecutive_count is implicitly initialised to zero */
 	e->new_chunk = new;
 
-	insert_completed_exception(s, e);
+	insert_exception(&s->complete, e);
 
 	return 0;
 }
@@ -958,7 +950,7 @@ static void pending_complete(struct dm_s
 	 * Add a proper exception, and remove the
 	 * in-flight exception from the list.
 	 */
-	insert_completed_exception(s, e);
+	insert_exception(&s->complete, e);
 
 out:
 	remove_exception(&pe->e);
