From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 19 of 29]
	dm-exception-store-remove-read_metadata-from-API.patch
Date: Tue, 17 Mar 2009 09:05:21 -0500
Message-ID: <200903171405.n2HE5LRD017477@hydrogen.msp.redhat.com>
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

Rip out crappy 'read_metadata' function from the exception
store API.  It is no longer needed, since the exception stores
are now responsible for caching exceptions.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -34,16 +34,6 @@ struct dm_exception_store_type {
 	int (*resume) (struct dm_exception_store *store);
 
 	/*
-	 * The target shouldn't read the COW device until this is
-	 * called.  As exceptions are read from the COW, they are
-	 * reported back via the callback.
-	 */
-	int (*read_metadata) (struct dm_exception_store *store,
-			      int (*callback)(void *callback_context,
-					      chunk_t old, chunk_t new),
-			      void *callback_context);
-
-	/*
 	 * Find somewhere to store the next exception.
 	 */
 	int (*prepare_exception) (struct dm_exception_store *store,
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -416,15 +416,11 @@ static void write_exception(struct pstor
  * 'full' is filled in to indicate if the area has been
  * filled.
  */
-static int insert_exceptions(struct pstore *ps,
-			     int (*callback)(void *callback_context,
-					     chunk_t old, chunk_t new),
-			     void *callback_context,
-			     int *full)
+static int insert_exceptions(struct pstore *ps, int *full, int first_read)
 {
-	int r;
 	unsigned int i;
 	struct disk_exception de;
+	struct dm_exception *new;
 
 	/* presume the area is full */
 	*full = 1;
@@ -450,21 +446,30 @@ static int insert_exceptions(struct psto
 		if (ps->next_free <= de.new_chunk)
 			ps->next_free = de.new_chunk + 1;
 
+
 		/*
-		 * Otherwise we add the exception to the snapshot.
+		 * If this is not our first time reading the
+		 * metadata, let's avoid adding duplicates to
+		 * to our cache.
 		 */
-		r = callback(callback_context, de.old_chunk, de.new_chunk);
-		if (r)
-			return r;
+		if (!first_read &&
+		    dm_lookup_exception(ps->table, de.old_chunk))
+			continue;
+
+		new = dm_alloc_exception(ps->table);
+		if (!new)
+			return -ENOMEM;
+
+		new->old_chunk = de.old_chunk;
+		new->new_chunk = de.new_chunk;
+
+		dm_insert_exception(ps->table, new);
 	}
 
 	return 0;
 }
 
-static int read_exceptions(struct pstore *ps,
-			   int (*callback)(void *callback_context, chunk_t old,
-					   chunk_t new),
-			   void *callback_context)
+static int read_exceptions(struct pstore *ps, int first_read)
 {
 	int r, full = 1;
 
@@ -477,7 +482,7 @@ static int read_exceptions(struct pstore
 		if (r)
 			return r;
 
-		r = insert_exceptions(ps, callback, callback_context, &full);
+		r = insert_exceptions(ps, &full, first_read);
 		if (r)
 			return r;
 	}
@@ -518,20 +523,24 @@ static void persistent_dtr(struct dm_exc
 	kfree(ps);
 }
 
-static int persistent_read_metadata(struct dm_exception_store *store,
-				    int (*callback)(void *callback_context,
-						    chunk_t old, chunk_t new),
-				    void *callback_context)
+/*
+ * persistent_resume
+ * @store
+ *
+ * Read metadata of the disk and store in our exception table cache.
+ *
+ * Returns: 0 on success, -Exxx on error
+ */
+static int persistent_resume(struct dm_exception_store *store)
 {
+	int first_read = 1;
 	int r, uninitialized_var(new_snapshot);
 	struct pstore *ps = get_info(store);
 
-	if (ps->callbacks)
-		/*
-		 * Temporary work around for having two different functions
-		 * that get us going... 'read_metadata' and 'resume'.
-		 */
+	if (ps->callbacks) {
+		first_read = 0;
 		goto read_metadata;
+	}
 
 	/*
 	 * Read the snapshot header.
@@ -586,43 +595,11 @@ static int persistent_read_metadata(stru
 	 * Read the metadata.
 	 */
 read_metadata:
-	r = read_exceptions(ps, callback, callback_context);
+	r = read_exceptions(ps, first_read);
 
 	return r;
 }
 
-/* This function is temporary for patch cleanliness */
-static int add_exception(void *context, chunk_t old, chunk_t new)
-{
-	struct dm_exception_store *store = context;
-	struct pstore *ps = get_info(store);
-	struct dm_exception *e;
-
-	e = dm_alloc_exception(ps->table);
-	if (!e)
-		return -ENOMEM;
-
-	e->old_chunk = old;
-	e->new_chunk = new;
-
-	dm_insert_exception(ps->table, e);
-
-        return 0;
-}
-
-/*
- * persistent_resume
- * @store
- *
- * Read metadata of the disk and store in our exception table cache.
- *
- * Returns: 0 on success, -Exxx on error
- */
-static int persistent_resume(struct dm_exception_store *store)
-{
-	return persistent_read_metadata(store, add_exception, store);
-}
-
 static int persistent_prepare_exception(struct dm_exception_store *store,
 					struct dm_exception *e)
 {
@@ -658,6 +635,7 @@ static void persistent_commit_exception(
 	unsigned int i;
 	struct pstore *ps = get_info(store);
 	struct disk_exception de;
+	struct dm_exception *new;
 	struct commit_callback *cb;
 
 	de.old_chunk = e->old_chunk;
@@ -670,7 +648,13 @@ static void persistent_commit_exception(
 	 * to put it in the cache though, the callbacks will have to
 	 * report the failure.
 	 */
-	if (add_exception(store, de.old_chunk, de.new_chunk))
+	new = dm_alloc_exception(ps->table);
+	if (new) {
+		new->old_chunk = de.old_chunk;
+		new->new_chunk = de.new_chunk;
+
+		dm_insert_exception(ps->table, new);
+	} else
 		ps->valid = 0;
 
 	/*
@@ -827,7 +811,6 @@ static struct dm_exception_store_type _p
 	.ctr = persistent_ctr,
 	.dtr = persistent_dtr,
 	.resume = persistent_resume,
-	.read_metadata = persistent_read_metadata,
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
 	.lookup_exception = persistent_lookup_exception,
@@ -842,7 +825,6 @@ static struct dm_exception_store_type _p
 	.ctr = persistent_ctr,
 	.dtr = persistent_dtr,
 	.resume = persistent_resume,
-	.read_metadata = persistent_read_metadata,
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
 	.lookup_exception = persistent_lookup_exception,
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
@@ -44,14 +44,6 @@ static void transient_dtr(struct dm_exce
 	kfree(tc);
 }
 
-static int transient_read_metadata(struct dm_exception_store *store,
-				   int (*callback)(void *callback_context,
-						   chunk_t old, chunk_t new),
-				   void *callback_context)
-{
-	return 0;
-}
-
 static int transient_resume(struct dm_exception_store *store)
 {
 	return 0;
@@ -179,7 +171,6 @@ static struct dm_exception_store_type _t
 	.ctr = transient_ctr,
 	.dtr = transient_dtr,
 	.resume = transient_resume,
-	.read_metadata = transient_read_metadata,
 	.prepare_exception = transient_prepare_exception,
 	.commit_exception = transient_commit_exception,
 	.lookup_exception = transient_lookup_exception,
@@ -193,7 +184,6 @@ static struct dm_exception_store_type _t
 	.ctr = transient_ctr,
 	.dtr = transient_dtr,
 	.resume = transient_resume,
-	.read_metadata = transient_read_metadata,
 	.prepare_exception = transient_prepare_exception,
 	.commit_exception = transient_commit_exception,
 	.lookup_exception = transient_lookup_exception,
