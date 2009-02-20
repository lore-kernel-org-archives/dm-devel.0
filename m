From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 16 of 17]
	dm-exception-store-rename-drop_snapshot.patch
Date: Fri, 20 Feb 2009 17:33:33 -0600
Message-ID: <1235172813.24593.52.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

This patch changes the 'drop_snapshot' function in the
exception store API.  Ignoring the fact that it was already
misnamed (we don't drop the snapshot, we invalidate the
exception store), there are new requirements for altering
exception stores.

In addition to invalidating an exception store, we now need
to be able to specify that a particular exception store be
permanently destroyed (useful especially for "shared"
exception store implementations).

DM_ES_INVALID: Means that the exception store is invalid.
               (Perhaps due to running out of available
               storage.)  However, the exception store is
               is to be left in-place.
DM_ES_DESTROY: Means the exception store is to be permanently
               removed.

DM_ES_DESTROY furthers the case for the suspend functions
added to the API in an earlier patch.  They give the
exception store implementations time to finish removing
a particular instance before being required to suspend
activity.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -14,6 +14,9 @@
 #include <linux/device-mapper.h>
 #include "dm-exception.h"
 
+#define DM_ES_INVALID 0x1
+#define DM_ES_DESTROY 0x2
+
 /*
  * Abstraction to handle the meta/layout of exception stores (the
  * COW device).
@@ -60,9 +63,12 @@ struct dm_exception_store_type {
 				 chunk_t old, int can_block);
 
 	/*
-	 * The snapshot is invalid, note this in the metadata.
+	 * Modify the state of the exception store.
+	 * DM_ES_INVALID: exception store is now invalid (but not deleted)
+	 * DM_ES_DESTROY: Permanently remove store upon suspend/dtr.
 	 */
-	void (*drop_snapshot) (struct dm_exception_store *store);
+	int (*modify_exception_store) (struct dm_exception_store *store,
+				       uint64_t action);
 
 	int (*status) (struct dm_exception_store *store, status_type_t status,
 		       char *result, unsigned int maxlen);
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -363,14 +363,17 @@ bad:
 	return r;
 }
 
-static int write_header(struct pstore *ps)
+static int write_header(struct pstore *ps, int destroy)
 {
 	struct disk_header *dh;
 
 	memset(ps->area, 0, ps->store->chunk_size << SECTOR_SHIFT);
 
 	dh = (struct disk_header *) ps->area;
-	dh->magic = cpu_to_le32(SNAP_MAGIC);
+	if (destroy)
+		dh->magic = 0;
+	else
+		dh->magic = cpu_to_le32(SNAP_MAGIC);
 	dh->valid = cpu_to_le32(ps->valid);
 	dh->version = cpu_to_le32(ps->version);
 	dh->chunk_size = cpu_to_le32(ps->store->chunk_size);
@@ -553,7 +556,7 @@ static int persistent_resume(struct dm_e
 	 * Do we need to setup a new snapshot ?
 	 */
 	if (new_snapshot) {
-		r = write_header(ps);
+		r = write_header(ps, 0);
 		if (r) {
 			DMWARN("write_header failed");
 			return r;
@@ -706,13 +709,15 @@ static int persistent_lookup_exception(s
 	return 0;
 }
 
-static void persistent_drop_snapshot(struct dm_exception_store *store)
+static int persistent_modify_exception_store(struct dm_exception_store *store,
+					     uint64_t action)
 {
 	struct pstore *ps = get_info(store);
 
-	ps->valid = 0;
-	if (write_header(ps))
-		DMWARN("write header failed");
+	if (action | DM_ES_INVALID)
+		ps->valid = 0;
+
+	return write_header(ps, (action | DM_ES_DESTROY));
 }
 
 static int persistent_ctr(struct dm_exception_store *store,
@@ -798,7 +803,7 @@ static struct dm_exception_store_type _p
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
 	.lookup_exception = persistent_lookup_exception,
-	.drop_snapshot = persistent_drop_snapshot,
+	.modify_exception_store = persistent_modify_exception_store,
 	.fraction_full = persistent_fraction_full,
 	.status = persistent_status,
 };
@@ -812,7 +817,7 @@ static struct dm_exception_store_type _p
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
 	.lookup_exception = persistent_lookup_exception,
-	.drop_snapshot = persistent_drop_snapshot,
+	.modify_exception_store = persistent_modify_exception_store,
 	.fraction_full = persistent_fraction_full,
 	.status = persistent_status,
 };
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -692,8 +692,8 @@ static void __invalidate_snapshot(struct
 	else if (err == -ENOMEM)
 		DMERR("Invalidating snapshot: Unable to allocate exception.");
 
-	if (s->store->type->drop_snapshot)
-		s->store->type->drop_snapshot(s->store);
+	if (s->store->type->modify_exception_store)
+		s->store->type->modify_exception_store(s->store, DM_ES_INVALID);
 
 	s->valid = 0;
 
