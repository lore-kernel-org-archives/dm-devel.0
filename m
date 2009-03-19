From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 21 of 30] DM Exception Store: rename drop_snapshot
Date: Thu, 19 Mar 2009 16:36:08 -0500
Message-ID: <200903192136.n2JLa8mN007910@hydrogen.msp.redhat.com>
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

Patch name: dm-exception-store-rename-drop_snapshot.patch

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

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

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
@@ -61,15 +64,22 @@ struct dm_exception_store_type {
 				 chunk_t old, chunk_t *new_chunk,
 				 int can_block);
 
-	/*
-	 * The snapshot is invalid, note this in the metadata.
-	 */
-	void (*drop_snapshot) (struct dm_exception_store *store);
-
 	int (*status) (struct dm_exception_store *store, status_type_t status,
 		       char *result, unsigned int maxlen);
 
 	/*
+	 * There are certain messages that are required by the (permanent)
+	 * exception store implementations:
+	 *  "ES_INVALIDATE": exception store is now invalid (but not deleted)
+	 *  "ES_DESTROY"   : Permanently remove store upon suspend/dtr.
+	 *
+	 * Exception store implementations are free to implement other
+	 * functions too.
+	 */
+	int (*message) (struct dm_exception_store *store,
+			unsigned argc, char **argv);
+
+	/*
 	 * Return how full the snapshot is.
 	 */
 	void (*fraction_full) (struct dm_exception_store *store,
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -366,14 +366,17 @@ bad:
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
@@ -563,7 +566,7 @@ static int persistent_resume(struct dm_e
 	 * Do we need to setup a new snapshot ?
 	 */
 	if (new_snapshot) {
-		r = write_header(ps);
+		r = write_header(ps, 0);
 		if (r) {
 			DMWARN("write_header failed");
 			return r;
@@ -722,15 +725,6 @@ static int persistent_lookup_exception(s
 	return 0;
 }
 
-static void persistent_drop_snapshot(struct dm_exception_store *store)
-{
-	struct pstore *ps = get_info(store);
-
-	ps->valid = 0;
-	if (write_header(ps))
-		DMWARN("write header failed");
-}
-
 static int persistent_ctr(struct dm_exception_store *store,
 			  unsigned argc, char **argv)
 {
@@ -805,6 +799,25 @@ static int persistent_status(struct dm_e
 	return sz;
 }
 
+static int persistent_message(struct dm_exception_store *store,
+			      unsigned argc, char **argv)
+{
+	struct pstore *ps = get_info(store);
+
+	if (argc != 1)
+		return -EINVAL;
+
+	if (!strcmp("ES_INVALIDATE", argv[0])) {
+		ps->valid = 0;
+		return write_header(ps, 0);
+	}
+
+	if (!strcmp("ES_DESTROY", argv[0]))
+		return write_header(ps, 1);
+
+	return -ENOSYS;
+}
+
 static struct dm_exception_store_type _persistent_type = {
 	.name = "persistent",
 	.module = THIS_MODULE,
@@ -814,9 +827,9 @@ static struct dm_exception_store_type _p
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
 	.lookup_exception = persistent_lookup_exception,
-	.drop_snapshot = persistent_drop_snapshot,
 	.fraction_full = persistent_fraction_full,
 	.status = persistent_status,
+	.message = persistent_message,
 };
 
 static struct dm_exception_store_type _persistent_compat_type = {
@@ -828,9 +841,9 @@ static struct dm_exception_store_type _p
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
 	.lookup_exception = persistent_lookup_exception,
-	.drop_snapshot = persistent_drop_snapshot,
 	.fraction_full = persistent_fraction_full,
 	.status = persistent_status,
+	.message = persistent_message,
 };
 
 int dm_persistent_snapshot_init(void)
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -684,6 +684,8 @@ static void error_bios(struct bio *bio)
 
 static void __invalidate_snapshot(struct dm_snapshot *s, int err)
 {
+	char *tmp_str = "ES_INVALIDATE";
+
 	if (!s->valid)
 		return;
 
@@ -692,8 +694,8 @@ static void __invalidate_snapshot(struct
 	else if (err == -ENOMEM)
 		DMERR("Invalidating snapshot: Unable to allocate exception.");
 
-	if (s->store->type->drop_snapshot)
-		s->store->type->drop_snapshot(s->store);
+	if (s->store->type->message)
+		s->store->type->message(s->store, 1, &tmp_str);
 
 	s->valid = 0;
 
@@ -1057,6 +1059,17 @@ static int snapshot_status(struct dm_tar
 	return 0;
 }
 
+static int snapshot_message(struct dm_target *ti, unsigned argc, char **argv)
+{
+	int r = 0;
+	struct dm_snapshot *s = ti->private;
+
+	if (s->store->type->message)
+		r = s->store->type->message(s->store, argc, argv);
+
+	return r;
+}
+
 /*-----------------------------------------------------------------
  * Origin methods
  *---------------------------------------------------------------*/
@@ -1299,6 +1312,7 @@ static struct target_type snapshot_targe
 	.presuspend = snapshot_presuspend,
 	.postsuspend = snapshot_postsuspend,
 	.status  = snapshot_status,
+	.message = snapshot_message,
 };
 
 static int __init dm_snapshot_init(void)
