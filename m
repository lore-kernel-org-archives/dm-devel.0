From: Jonathan Brassow <jbrassow@redhat.com>
Subject: RFC::  [PATCH 2 of 3] dm-exception-store API
Date: Mon, 10 Nov 2008 16:43:45 -0600
Message-ID: <1226357025.22387.20.camel@hydrogen.msp.redhat.com>
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

If the exception store API ever becomes as popular as the
dm-dirty-log.h API, then we should make the name of the
exception store structure a little more official.

s/exception_store/dm_exception_store/


Index: linux-2.6/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.c
+++ linux-2.6/drivers/md/dm-exception-store.c
@@ -462,19 +462,19 @@ static int read_exceptions(struct pstore
 	return 0;
 }
 
-static struct pstore *get_info(struct exception_store *store)
+static struct pstore *get_info(struct dm_exception_store *store)
 {
 	return (struct pstore *) store->context;
 }
 
-static void persistent_fraction_full(struct exception_store *store,
+static void persistent_fraction_full(struct dm_exception_store *store,
 				     sector_t *numerator, sector_t *denominator)
 {
 	*numerator = get_info(store)->next_free * store->snap->chunk_size;
 	*denominator = get_dev_size(store->snap->cow->bdev);
 }
 
-static void persistent_destroy(struct exception_store *store)
+static void persistent_destroy(struct dm_exception_store *store)
 {
 	struct pstore *ps = get_info(store);
 
@@ -485,7 +485,7 @@ static void persistent_destroy(struct ex
 	kfree(ps);
 }
 
-static int persistent_read_metadata(struct exception_store *store)
+static int persistent_read_metadata(struct dm_exception_store *store)
 {
 	int r, uninitialized_var(new_snapshot);
 	struct pstore *ps = get_info(store);
@@ -551,7 +551,7 @@ static int persistent_read_metadata(stru
 	return 0;
 }
 
-static int persistent_prepare(struct exception_store *store,
+static int persistent_prepare(struct dm_exception_store *store,
 			      struct dm_snap_exception *e)
 {
 	struct pstore *ps = get_info(store);
@@ -578,7 +578,7 @@ static int persistent_prepare(struct exc
 	return 0;
 }
 
-static void persistent_commit(struct exception_store *store,
+static void persistent_commit(struct dm_exception_store *store,
 			      struct dm_snap_exception *e,
 			      void (*callback) (void *, int success),
 			      void *callback_context)
@@ -640,7 +640,7 @@ static void persistent_commit(struct exc
 	ps->callback_count = 0;
 }
 
-static void persistent_drop(struct exception_store *store)
+static void persistent_drop(struct dm_exception_store *store)
 {
 	struct pstore *ps = get_info(store);
 
@@ -649,7 +649,7 @@ static void persistent_drop(struct excep
 		DMWARN("write header failed");
 }
 
-int dm_create_persistent(struct exception_store *store)
+int dm_create_persistent(struct dm_exception_store *store)
 {
 	struct pstore *ps;
 
@@ -694,17 +694,17 @@ struct transient_c {
 	sector_t next_free;
 };
 
-static void transient_destroy(struct exception_store *store)
+static void transient_destroy(struct dm_exception_store *store)
 {
 	kfree(store->context);
 }
 
-static int transient_read_metadata(struct exception_store *store)
+static int transient_read_metadata(struct dm_exception_store *store)
 {
 	return 0;
 }
 
-static int transient_prepare(struct exception_store *store,
+static int transient_prepare(struct dm_exception_store *store,
 			     struct dm_snap_exception *e)
 {
 	struct transient_c *tc = (struct transient_c *) store->context;
@@ -719,7 +719,7 @@ static int transient_prepare(struct exce
 	return 0;
 }
 
-static void transient_commit(struct exception_store *store,
+static void transient_commit(struct dm_exception_store *store,
 			     struct dm_snap_exception *e,
 			     void (*callback) (void *, int success),
 			     void *callback_context)
@@ -728,14 +728,14 @@ static void transient_commit(struct exce
 	callback(callback_context, 1);
 }
 
-static void transient_fraction_full(struct exception_store *store,
+static void transient_fraction_full(struct dm_exception_store *store,
 				    sector_t *numerator, sector_t *denominator)
 {
 	*numerator = ((struct transient_c *) store->context)->next_free;
 	*denominator = get_dev_size(store->snap->cow->bdev);
 }
 
-int dm_create_transient(struct exception_store *store)
+int dm_create_transient(struct dm_exception_store *store)
 {
 	struct transient_c *tc;
 
Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -79,29 +79,29 @@ static inline void dm_consecutive_chunk_
  * Abstraction to handle the meta/layout of exception stores (the
  * COW device).
  */
-struct exception_store {
+struct dm_exception_store {
 
 	/*
 	 * Destroys this object when you've finished with it.
 	 */
-	void (*destroy) (struct exception_store *store);
+	void (*destroy) (struct dm_exception_store *store);
 
 	/*
 	 * The target shouldn't read the COW device until this is
 	 * called.
 	 */
-	int (*read_metadata) (struct exception_store *store);
+	int (*read_metadata) (struct dm_exception_store *store);
 
 	/*
 	 * Find somewhere to store the next exception.
 	 */
-	int (*prepare_exception) (struct exception_store *store,
+	int (*prepare_exception) (struct dm_exception_store *store,
 				  struct dm_snap_exception *e);
 
 	/*
 	 * Update the metadata with this exception.
 	 */
-	void (*commit_exception) (struct exception_store *store,
+	void (*commit_exception) (struct dm_exception_store *store,
 				  struct dm_snap_exception *e,
 				  void (*callback) (void *, int success),
 				  void *callback_context);
@@ -109,12 +109,12 @@ struct exception_store {
 	/*
 	 * The snapshot is invalid, note this in the metadata.
 	 */
-	void (*drop_snapshot) (struct exception_store *store);
+	void (*drop_snapshot) (struct dm_exception_store *store);
 
 	/*
 	 * Return how full the snapshot is.
 	 */
-	void (*fraction_full) (struct exception_store *store,
+	void (*fraction_full) (struct dm_exception_store *store,
 			       sector_t *numerator,
 			       sector_t *denominator);
 
@@ -125,9 +125,9 @@ struct exception_store {
 /*
  * Constructor and destructor for the exception stores
  */
-int dm_create_persistent(struct exception_store *store);
+int dm_create_persistent(struct dm_exception_store *store);
 
-int dm_create_transient(struct exception_store *store);
+int dm_create_transient(struct dm_exception_store *store);
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/drivers/md/dm-snap.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.h
+++ linux-2.6/drivers/md/dm-snap.h
@@ -62,7 +62,7 @@ struct dm_snapshot {
 	spinlock_t pe_lock;
 
 	/* The on disk metadata handler */
-	struct exception_store store;
+	struct dm_exception_store store;
 
 	struct dm_kcopyd_client *kcopyd_client;
 
