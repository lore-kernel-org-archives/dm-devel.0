From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 10 of 29]
	dm-snap-exception-function-changes-5.patch
Date: Tue, 17 Mar 2009 09:03:51 -0500
Message-ID: <200903171403.n2HE3pHc017400@hydrogen.msp.redhat.com>
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
@@ -444,6 +444,25 @@ static struct dm_exception *dm_lookup_ex
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
@@ -505,7 +524,7 @@ static void dm_insert_exception(struct d
 		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) +
 					 dm_consecutive_chunk_count(e) + 1)) {
 			dm_consecutive_chunk_count_inc(e);
-			free_completed_exception(new_e, NULL);
+			dm_free_exception(eh, new_e);
 			return;
 		}
 
@@ -515,7 +534,7 @@ static void dm_insert_exception(struct d
 			dm_consecutive_chunk_count_inc(e);
 			e->old_chunk--;
 			e->new_chunk--;
-			free_completed_exception(new_e, NULL);
+			dm_free_exception(eh, new_e);
 			return;
 		}
 
@@ -536,7 +555,7 @@ static int dm_add_exception(void *contex
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
-	e = alloc_completed_exception(NULL);
+	e = dm_alloc_exception(s->complete);
 	if (!e)
 		return -ENOMEM;
 
@@ -967,7 +986,7 @@ static void pending_complete(struct dm_s
 		goto out;
 	}
 
-	e = alloc_completed_exception(NULL);
+	e = dm_alloc_exception(s->complete);
 	if (!e) {
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
@@ -978,7 +997,7 @@ static void pending_complete(struct dm_s
 
 	down_write(&s->lock);
 	if (!s->valid) {
-		free_completed_exception(e, NULL);
+		dm_free_exception(s->complete, e);
 		error = 1;
 		goto out;
 	}
