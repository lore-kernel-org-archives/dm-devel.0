From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 12]:
	dm-exception-store-introduce-registry.patch
Date: Tue, 20 Jan 2009 13:50:53 -0600
Message-ID: <1232481053.19993.15.camel@hydrogen.msp.redhat.com>
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

Move exception stores into a registry.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.c
+++ linux-2.6/drivers/md/dm-exception-store.c
@@ -14,6 +14,173 @@
 
 #define DM_MSG_PREFIX "snapshot exception stores"
 
+static LIST_HEAD(_exception_store_types);
+static DEFINE_SPINLOCK(_lock);
+
+static struct dm_exception_store_type *__find_exception_store_type(const char *name)
+{
+	struct dm_exception_store_type *type;
+
+	list_for_each_entry(type, &_exception_store_types, list)
+		if (!strcmp(name, type->name))
+			return type;
+
+	return NULL;
+}
+
+static struct dm_exception_store_type *_get_exception_store_type(const char *name)
+{
+	struct dm_exception_store_type *type;
+
+	spin_lock(&_lock);
+
+	type = __find_exception_store_type(name);
+
+	if (type && !try_module_get(type->module))
+		type = NULL;
+
+	spin_unlock(&_lock);
+
+	return type;
+}
+
+/*
+ * get_type
+ * @type_name
+ *
+ * Attempt to retrieve the dm_exception_store_type by name.  If not already
+ * available, attempt to load the appropriate module.
+ *
+ * Exstore modules are named "dm-exstore-" followed by the 'type_name'.
+ * Modules may contain multiple types.
+ * This function will first try the module "dm-exstore-<type_name>",
+ * then truncate 'type_name' on the last '-' and try again.
+ *
+ * For example, if type_name was "clustered-shared", it would search
+ * 'dm-exstore-clustered-shared' then 'dm-exstore-clustered'.
+ *
+ * 'dm-exception-store-<type_name>' is too long of a name in my
+ * opinion, which is why I've chosen to have the files
+ * containing exception store implementations be 'dm-exstore-<type_name>'.
+ * If you want your module to be autoloaded, you will follow this
+ * naming convention.
+ *
+ * Returns: dm_exception_store_type* on success, NULL on failure
+ */
+static struct dm_exception_store_type *get_type(const char *type_name)
+{
+	char *p, *type_name_dup;
+	struct dm_exception_store_type *type;
+
+	type = _get_exception_store_type(type_name);
+	if (type)
+		return type;
+
+	type_name_dup = kstrdup(type_name, GFP_KERNEL);
+	if (!type_name_dup) {
+		DMERR("No memory left to attempt load for \"%s\"", type_name);
+		return NULL;
+	}
+
+	while (request_module("dm-exstore-%s", type_name_dup) ||
+	       !(type = _get_exception_store_type(type_name))) {
+		p = strrchr(type_name_dup, '-');
+		if (!p)
+			break;
+		p[0] = '\0';
+	}
+
+	if (!type)
+		DMWARN("Module for exstore type \"%s\" not found.", type_name);
+
+	kfree(type_name_dup);
+
+	return type;
+}
+
+static void put_type(struct dm_exception_store_type *type)
+{
+	spin_lock(&_lock);
+	module_put(type->module);
+	spin_unlock(&_lock);
+}
+
+int dm_exception_store_type_register(struct dm_exception_store_type *type)
+{
+	int r = 0;
+
+	spin_lock(&_lock);
+	if (!__find_exception_store_type(type->name))
+		list_add(&type->list, &_exception_store_types);
+	else
+		r = -EEXIST;
+	spin_unlock(&_lock);
+
+	return r;
+}
+EXPORT_SYMBOL(dm_exception_store_type_register);
+
+int dm_exception_store_type_unregister(struct dm_exception_store_type *type)
+{
+	spin_lock(&_lock);
+
+	if (!__find_exception_store_type(type->name)) {
+		spin_unlock(&_lock);
+		return -EINVAL;
+	}
+
+	if (type->module && module_refcount(type->module)) {
+		spin_unlock(&_lock);
+		return -ETXTBSY;
+	}
+
+	list_del(&type->list);
+
+	spin_unlock(&_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(dm_exception_store_type_unregister);
+
+int dm_exception_store_create(const char *type_name,
+			      struct dm_exception_store **store)
+{
+	int r = 0;
+	struct dm_exception_store_type *type;
+	struct dm_exception_store *tmp_store;
+
+	tmp_store = kmalloc(sizeof(*tmp_store), GFP_KERNEL);
+	if (!tmp_store)
+		return -ENOMEM;
+
+	type = get_type(type_name);
+	if (!type) {
+		kfree(tmp_store);
+		return -EINVAL;
+	}
+
+	tmp_store->type = type;
+
+	r = type->ctr(tmp_store, 0, NULL);
+	if (r) {
+		put_type(type);
+		kfree(tmp_store);
+		return r;
+	}
+
+	*store = tmp_store;
+	return 0;
+}
+EXPORT_SYMBOL(dm_exception_store_create);
+
+void dm_exception_store_destroy(struct dm_exception_store *store)
+{
+	store->type->dtr(store);
+	put_type(store->type);
+	kfree(store);
+}
+EXPORT_SYMBOL(dm_exception_store_destroy);
+
 int dm_exception_store_init(void)
 {
 	int r;
Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -39,6 +39,9 @@ struct dm_snap_exception {
  */
 struct dm_exception_store;
 struct dm_exception_store_type {
+	const char *name;
+	struct module *module;
+
 	int (*ctr) (struct dm_exception_store *store,
 		    unsigned argc, char **argv);
 
@@ -85,10 +88,13 @@ struct dm_exception_store_type {
 	void (*fraction_full) (struct dm_exception_store *store,
 			       sector_t *numerator,
 			       sector_t *denominator);
+
+	/* For internal device-mapper use only. */
+	struct list_head list;
 };
 
 struct dm_exception_store {
-	struct dm_exception_store_type type;
+	struct dm_exception_store_type *type;
 
 	struct dm_snapshot *snap;
 
@@ -138,6 +144,13 @@ static inline void dm_consecutive_chunk_
 
 #  endif
 
+int dm_exception_store_type_register(struct dm_exception_store_type *type);
+int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
+
+int dm_exception_store_create(const char *type_name,
+			      struct dm_exception_store **store);
+void dm_exception_store_destroy(struct dm_exception_store *store);
+
 int dm_exception_store_init(void);
 void dm_exception_store_exit(void);
 
@@ -150,8 +163,4 @@ void dm_persistent_snapshot_exit(void);
 int dm_transient_snapshot_init(void);
 void dm_transient_snapshot_exit(void);
 
-int dm_create_persistent(struct dm_exception_store *store);
-
-int dm_create_transient(struct dm_exception_store *store);
-
 #endif /* _LINUX_DM_EXCEPTION_STORE */
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -478,7 +478,7 @@ static void persistent_fraction_full(str
 	*denominator = get_dev_size(store->snap->cow->bdev);
 }
 
-static void persistent_destroy(struct dm_exception_store *store)
+static void persistent_dtr(struct dm_exception_store *store)
 {
 	struct pstore *ps = get_info(store);
 
@@ -656,7 +656,8 @@ static void persistent_drop_snapshot(str
 		DMWARN("write header failed");
 }
 
-int dm_create_persistent(struct dm_exception_store *store)
+static int persistent_ctr(struct dm_exception_store *store,
+			  unsigned argc, char **argv)
 {
 	struct pstore *ps;
 
@@ -683,23 +684,69 @@ int dm_create_persistent(struct dm_excep
 		return -ENOMEM;
 	}
 
-	store->type.dtr = persistent_destroy;
-	store->type.read_metadata = persistent_read_metadata;
-	store->type.prepare_exception = persistent_prepare_exception;
-	store->type.commit_exception = persistent_commit_exception;
-	store->type.drop_snapshot = persistent_drop_snapshot;
-	store->type.fraction_full = persistent_fraction_full;
-
 	store->context = ps;
 
 	return 0;
 }
 
+static int persistent_status(struct dm_exception_store *store,
+			     status_type_t status, char *result,
+			     unsigned int maxlen)
+{
+	int sz = 0;
+
+	return sz;
+}
+
+static struct dm_exception_store_type _persistent_type = {
+	.name = "persistent",
+	.module = THIS_MODULE,
+	.ctr = persistent_ctr,
+	.dtr = persistent_dtr,
+	.read_metadata = persistent_read_metadata,
+	.prepare_exception = persistent_prepare_exception,
+	.commit_exception = persistent_commit_exception,
+	.drop_snapshot = persistent_drop_snapshot,
+	.fraction_full = persistent_fraction_full,
+	.status = persistent_status,
+};
+
+static struct dm_exception_store_type _persistent_compat_type = {
+	.name = "P",
+	.module = THIS_MODULE,
+	.ctr = persistent_ctr,
+	.dtr = persistent_dtr,
+	.read_metadata = persistent_read_metadata,
+	.prepare_exception = persistent_prepare_exception,
+	.commit_exception = persistent_commit_exception,
+	.drop_snapshot = persistent_drop_snapshot,
+	.fraction_full = persistent_fraction_full,
+	.status = persistent_status,
+};
+
 int dm_persistent_snapshot_init(void)
 {
-	return 0;
+	int r;
+
+	r = dm_exception_store_type_register(&_persistent_type);
+	if (r) {
+		DMERR("Unable to register persistent exception store type");
+		return r;
+	}
+
+	r = dm_exception_store_type_register(&_persistent_compat_type);
+	if (r) {
+		DMERR("Unable to register old-style persistent exception "
+		      "store type");
+		dm_exception_store_type_unregister(&_persistent_type);
+		return r;
+	}
+
+	return r;
 }
 
 void dm_persistent_snapshot_exit(void)
 {
+	dm_exception_store_type_unregister(&_persistent_type);
+	dm_exception_store_type_unregister(&_persistent_compat_type);
 }
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
@@ -23,7 +23,7 @@ struct transient_c {
 	sector_t next_free;
 };
 
-static void transient_destroy(struct dm_exception_store *store)
+static void transient_dtr(struct dm_exception_store *store)
 {
 	kfree(store->context);
 }
@@ -67,17 +67,11 @@ static void transient_fraction_full(stru
 	*denominator = get_dev_size(store->snap->cow->bdev);
 }
 
-int dm_create_transient(struct dm_exception_store *store)
+static int transient_ctr(struct dm_exception_store *store,
+			 unsigned argc, char **argv)
 {
 	struct transient_c *tc;
 
-	store->type.dtr = transient_destroy;
-	store->type.read_metadata = transient_read_metadata;
-	store->type.prepare_exception = transient_prepare_exception;
-	store->type.commit_exception = transient_commit_exception;
-	store->type.drop_snapshot = NULL;
-	store->type.fraction_full = transient_fraction_full;
-
 	tc = kmalloc(sizeof(struct transient_c), GFP_KERNEL);
 	if (!tc)
 		return -ENOMEM;
@@ -88,11 +82,61 @@ int dm_create_transient(struct dm_except
 	return 0;
 }
 
+static int transient_status(struct dm_exception_store *store,
+			    status_type_t status, char *result,
+			    unsigned maxlen)
+{
+	int sz = 0;
+
+	return sz;
+}
+
+static struct dm_exception_store_type _transient_type = {
+	.name = "transient",
+	.module = THIS_MODULE,
+	.ctr = transient_ctr,
+	.dtr = transient_dtr,
+	.read_metadata = transient_read_metadata,
+	.prepare_exception = transient_prepare_exception,
+	.commit_exception = transient_commit_exception,
+	.fraction_full = transient_fraction_full,
+	.status = transient_status,
+};
+
+static struct dm_exception_store_type _transient_compat_type = {
+	.name = "N",
+	.module = THIS_MODULE,
+	.ctr = transient_ctr,
+	.dtr = transient_dtr,
+	.read_metadata = transient_read_metadata,
+	.prepare_exception = transient_prepare_exception,
+	.commit_exception = transient_commit_exception,
+	.fraction_full = transient_fraction_full,
+	.status = transient_status,
+};
+
 int dm_transient_snapshot_init(void)
 {
-	return 0;
+	int r;
+
+	r = dm_exception_store_type_register(&_transient_type);
+	if (r) {
+		DMWARN("Unable to register transient exception store type");
+		return r;
+	}
+
+	r = dm_exception_store_type_register(&_transient_compat_type);
+	if (r) {
+		DMWARN("Unable to register old-style transient exception store type");
+		dm_exception_store_type_unregister(&_transient_type);
+		return r;
+	}
+
+	return r;
 }
 
 void dm_transient_snapshot_exit(void)
 {
+	dm_exception_store_type_unregister(&_transient_type);
+	dm_exception_store_type_unregister(&_transient_compat_type);
 }
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -610,8 +610,6 @@ static int snapshot_ctr(struct dm_target
 	if (r)
 		goto bad3;
 
-	s->type = persistent;
-
 	s->valid = 1;
 	s->active = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
@@ -626,19 +624,15 @@ static int snapshot_ctr(struct dm_target
 		goto bad3;
 	}
 
-	s->store.snap = s;
-
-	if (persistent == 'P')
-		r = dm_create_persistent(&s->store);
-	else
-		r = dm_create_transient(&s->store);
-
+	r = dm_exception_store_create(argv[2], &s->store);
 	if (r) {
 		ti->error = "Couldn't create exception store";
 		r = -EINVAL;
 		goto bad4;
 	}
 
+	s->store->snap = s;
+
 	r = dm_kcopyd_client_create(SNAPSHOT_PAGES, &s->kcopyd_client);
 	if (r) {
 		ti->error = "Could not create kcopyd client";
@@ -665,7 +659,7 @@ static int snapshot_ctr(struct dm_target
 	spin_lock_init(&s->tracked_chunk_lock);
 
 	/* Metadata must only be loaded into one table at once */
-	r = s->store.type.read_metadata(&s->store, dm_add_exception, (void *)s);
+	r = s->store->type->read_metadata(s->store, dm_add_exception, (void *)s);
 	if (r < 0) {
 		ti->error = "Failed to read snapshot metadata";
 		goto bad_load_and_register;
@@ -700,7 +694,7 @@ static int snapshot_ctr(struct dm_target
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 
  bad5:
-	s->store.type.dtr(&s->store);
+	s->store->type->dtr(s->store);
 
  bad4:
 	exit_exception_table(&s->pending, pending_cache);
@@ -725,7 +719,7 @@ static void __free_exceptions(struct dm_
 	exit_exception_table(&s->pending, pending_cache);
 	exit_exception_table(&s->complete, exception_cache);
 
-	s->store.type.dtr(&s->store);
+	s->store->type->dtr(s->store);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -820,8 +814,8 @@ static void __invalidate_snapshot(struct
 	else if (err == -ENOMEM)
 		DMERR("Invalidating snapshot: Unable to allocate exception.");
 
-	if (s->store.type.drop_snapshot)
-		s->store.type.drop_snapshot(&s->store);
+	if (s->store->type->drop_snapshot)
+		s->store->type->drop_snapshot(s->store);
 
 	s->valid = 0;
 
@@ -943,8 +937,8 @@ static void copy_callback(int read_err, 
 
 	else
 		/* Update the metadata if we are persistent */
-		s->store.type.commit_exception(&s->store, &pe->e, commit_callback,
-					  pe);
+		s->store->type->commit_exception(s->store, &pe->e,
+						 commit_callback, pe);
 }
 
 /*
@@ -1024,7 +1018,7 @@ __find_pending_exception(struct dm_snaps
 	atomic_set(&pe->ref_count, 0);
 	pe->started = 0;
 
-	if (s->store.type.prepare_exception(&s->store, &pe->e)) {
+	if (s->store->type->prepare_exception(s->store, &pe->e)) {
 		free_pending_exception(pe);
 		return NULL;
 	}
@@ -1144,11 +1138,11 @@ static int snapshot_status(struct dm_tar
 		if (!snap->valid)
 			snprintf(result, maxlen, "Invalid");
 		else {
-			if (snap->store.type.fraction_full) {
+			if (snap->store->type->fraction_full) {
 				sector_t numerator, denominator;
-				snap->store.type.fraction_full(&snap->store,
-							  &numerator,
-							  &denominator);
+				snap->store->type->fraction_full(snap->store,
+								 &numerator,
+								 &denominator);
 				snprintf(result, maxlen, "%llu/%llu",
 					(unsigned long long)numerator,
 					(unsigned long long)denominator);
@@ -1164,9 +1158,9 @@ static int snapshot_status(struct dm_tar
 		 * to make private copies if the output is to
 		 * make sense.
 		 */
-		snprintf(result, maxlen, "%s %s %c %llu",
+		snprintf(result, maxlen, "%s %s %s %llu",
 			 snap->origin->name, snap->cow->name,
-			 snap->type,
+			 snap->store->type->name,
 			 (unsigned long long)snap->chunk_size);
 		break;
 	}
Index: linux-2.6/drivers/md/dm-snap.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.h
+++ linux-2.6/drivers/md/dm-snap.h
@@ -61,7 +61,7 @@ struct dm_snapshot {
 	spinlock_t pe_lock;
 
 	/* The on disk metadata handler */
-	struct dm_exception_store store;
+	struct dm_exception_store *store;
 
 	struct dm_kcopyd_client *kcopyd_client;
 
