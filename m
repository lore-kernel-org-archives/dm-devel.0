From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 12]:
	dm-exception-store-separate-type-from-instance.patch
Date: Tue, 20 Jan 2009 13:49:33 -0600
Message-ID: <1232480973.19993.13.camel@hydrogen.msp.redhat.com>
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

 brassow

Introduce struct dm_exception_store_type.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.28/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-exception-store.h	2009-01-05 18:18:47.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-exception-store.h	2009-01-05 18:19:03.000000000 +0000
@@ -37,11 +37,15 @@ struct dm_snap_exception {
  * Abstraction to handle the meta/layout of exception stores (the
  * COW device).
  */
-struct dm_exception_store {
+struct dm_exception_store;
+struct dm_exception_store_type {
+	int (*ctr) (struct dm_exception_store *store,
+		    unsigned argc, char **argv);
+
 	/*
 	 * Destroys this object when you've finished with it.
 	 */
-	void (*destroy) (struct dm_exception_store *store);
+	void (*dtr) (struct dm_exception_store *store);
 
 	/*
 	 * The target shouldn't read the COW device until this is
@@ -81,8 +85,13 @@ struct dm_exception_store {
 	void (*fraction_full) (struct dm_exception_store *store,
 			       sector_t *numerator,
 			       sector_t *denominator);
+};
+
+struct dm_exception_store {
+	struct dm_exception_store_type type;
 
 	struct dm_snapshot *snap;
+
 	void *context;
 };
 
Index: linux-2.6.28/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap-persistent.c	2009-01-05 18:18:47.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap-persistent.c	2009-01-05 18:19:03.000000000 +0000
@@ -683,12 +683,13 @@ int dm_create_persistent(struct dm_excep
 		return -ENOMEM;
 	}
 
-	store->destroy = persistent_destroy;
-	store->read_metadata = persistent_read_metadata;
-	store->prepare_exception = persistent_prepare_exception;
-	store->commit_exception = persistent_commit_exception;
-	store->drop_snapshot = persistent_drop_snapshot;
-	store->fraction_full = persistent_fraction_full;
+	store->type.dtr = persistent_destroy;
+	store->type.read_metadata = persistent_read_metadata;
+	store->type.prepare_exception = persistent_prepare_exception;
+	store->type.commit_exception = persistent_commit_exception;
+	store->type.drop_snapshot = persistent_drop_snapshot;
+	store->type.fraction_full = persistent_fraction_full;
+
 	store->context = ps;
 
 	return 0;
Index: linux-2.6.28/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap-transient.c	2009-01-05 18:18:47.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap-transient.c	2009-01-05 18:19:03.000000000 +0000
@@ -39,7 +39,7 @@ static int transient_read_metadata(struc
 static int transient_prepare_exception(struct dm_exception_store *store,
 				       struct dm_snap_exception *e)
 {
-	struct transient_c *tc = (struct transient_c *) store->context;
+	struct transient_c *tc = store->context;
 	sector_t size = get_dev_size(store->snap->cow->bdev);
 
 	if (size < (tc->next_free + store->snap->chunk_size))
@@ -71,12 +71,12 @@ int dm_create_transient(struct dm_except
 {
 	struct transient_c *tc;
 
-	store->destroy = transient_destroy;
-	store->read_metadata = transient_read_metadata;
-	store->prepare_exception = transient_prepare_exception;
-	store->commit_exception = transient_commit_exception;
-	store->drop_snapshot = NULL;
-	store->fraction_full = transient_fraction_full;
+	store->type.dtr = transient_destroy;
+	store->type.read_metadata = transient_read_metadata;
+	store->type.prepare_exception = transient_prepare_exception;
+	store->type.commit_exception = transient_commit_exception;
+	store->type.drop_snapshot = NULL;
+	store->type.fraction_full = transient_fraction_full;
 
 	tc = kmalloc(sizeof(struct transient_c), GFP_KERNEL);
 	if (!tc)
Index: linux-2.6.28/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.c	2009-01-05 18:18:47.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap.c	2009-01-05 18:19:03.000000000 +0000
@@ -665,7 +665,7 @@ static int snapshot_ctr(struct dm_target
 	spin_lock_init(&s->tracked_chunk_lock);
 
 	/* Metadata must only be loaded into one table at once */
-	r = s->store.read_metadata(&s->store, dm_add_exception, (void *)s);
+	r = s->store.type.read_metadata(&s->store, dm_add_exception, (void *)s);
 	if (r < 0) {
 		ti->error = "Failed to read snapshot metadata";
 		goto bad_load_and_register;
@@ -700,7 +700,7 @@ static int snapshot_ctr(struct dm_target
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 
  bad5:
-	s->store.destroy(&s->store);
+	s->store.type.dtr(&s->store);
 
  bad4:
 	exit_exception_table(&s->pending, pending_cache);
@@ -725,7 +725,7 @@ static void __free_exceptions(struct dm_
 	exit_exception_table(&s->pending, pending_cache);
 	exit_exception_table(&s->complete, exception_cache);
 
-	s->store.destroy(&s->store);
+	s->store.type.dtr(&s->store);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -820,8 +820,8 @@ static void __invalidate_snapshot(struct
 	else if (err == -ENOMEM)
 		DMERR("Invalidating snapshot: Unable to allocate exception.");
 
-	if (s->store.drop_snapshot)
-		s->store.drop_snapshot(&s->store);
+	if (s->store.type.drop_snapshot)
+		s->store.type.drop_snapshot(&s->store);
 
 	s->valid = 0;
 
@@ -943,7 +943,7 @@ static void copy_callback(int read_err, 
 
 	else
 		/* Update the metadata if we are persistent */
-		s->store.commit_exception(&s->store, &pe->e, commit_callback,
+		s->store.type.commit_exception(&s->store, &pe->e, commit_callback,
 					  pe);
 }
 
@@ -1024,7 +1024,7 @@ __find_pending_exception(struct dm_snaps
 	atomic_set(&pe->ref_count, 0);
 	pe->started = 0;
 
-	if (s->store.prepare_exception(&s->store, &pe->e)) {
+	if (s->store.type.prepare_exception(&s->store, &pe->e)) {
 		free_pending_exception(pe);
 		return NULL;
 	}
@@ -1144,9 +1144,9 @@ static int snapshot_status(struct dm_tar
 		if (!snap->valid)
 			snprintf(result, maxlen, "Invalid");
 		else {
-			if (snap->store.fraction_full) {
+			if (snap->store.type.fraction_full) {
 				sector_t numerator, denominator;
-				snap->store.fraction_full(&snap->store,
+				snap->store.type.fraction_full(&snap->store,
 							  &numerator,
 							  &denominator);
 				snprintf(result, maxlen, "%llu/%llu",
