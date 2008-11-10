From: Jonathan Brassow <jbrassow@redhat.com>
Subject: RFC::  [PATCH 3 of 3] dm-exception-store API
Date: Mon, 10 Nov 2008 16:43:52 -0600
Message-ID: <1226357032.22387.21.camel@hydrogen.msp.redhat.com>
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

Create exception store API.  This is probably the minimum
requirement to make the current set of exceptions stores
work.

We still need to create the 'status' functions in the
dm_exception_store_type, because future exception store
types will need more arguments to the table line and will
need a way of printing them.

I would also like to see dm-snap.h go away... but this would
require a bit more restructuring that isn't absolutely
necessary.

We may also wish to consider bumping the version number and
providing an additional table interface.  (In fact, we could
easily provide both the old and new interface.)

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -75,16 +75,20 @@ static inline void dm_consecutive_chunk_
 
 #  endif
 
-/*
- * Abstraction to handle the meta/layout of exception stores (the
- * COW device).
- */
+struct dm_exception_store_type;
 struct dm_exception_store {
+	struct dm_exception_store_type *type;
+	struct dm_snapshot *snap;
+	void *context;
+};
 
-	/*
-	 * Destroys this object when you've finished with it.
-	 */
-	void (*destroy) (struct dm_exception_store *store);
+struct dm_exception_store_type {
+	const char *name;
+	struct module *module;
+
+	int (*ctr) (struct dm_exception_store *store,
+		    unsigned argc, char **argv);
+	void (*dtr) (struct dm_exception_store *store);
 
 	/*
 	 * The target shouldn't read the COW device until this is
@@ -117,17 +121,18 @@ struct dm_exception_store {
 	void (*fraction_full) (struct dm_exception_store *store,
 			       sector_t *numerator,
 			       sector_t *denominator);
-
-	struct dm_snapshot *snap;
-	void *context;
 };
 
-/*
- * Constructor and destructor for the exception stores
- */
-int dm_create_persistent(struct dm_exception_store *store);
+int dm_exception_store_type_register(struct dm_exception_store_type *type);
+int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
+
+struct dm_exception_store *dm_exception_store_create(const char *type_name,
+						     struct dm_snapshot *s,
+						     unsigned argc, char **argv);
+void dm_exception_store_destroy(struct dm_exception_store *store);
 
-int dm_create_transient(struct dm_exception_store *store);
+int dm_exception_store_init(void);
+void dm_exception_store_exit(void);
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.c
+++ linux-2.6/drivers/md/dm-exception-store.c
@@ -17,9 +17,254 @@
 #include <linux/dm-io.h>
 #include <linux/dm-kcopyd.h>
 
-#define DM_MSG_PREFIX "snapshots"
+#define DM_MSG_PREFIX "dm-exception-store"
 #define DM_CHUNK_SIZE_DEFAULT_SECTORS 32	/* 16KB */
 
+struct dm_exception_store_internal {
+	struct dm_exception_store_type *type;
+
+	struct list_head list;
+	long use;
+};
+
+static LIST_HEAD(_exception_store_types);
+static DEFINE_SPINLOCK(_lock);
+
+static struct dm_exception_store_internal *
+__find_exception_store_type(const char *name)
+{
+	struct dm_exception_store_internal *internal_type;
+
+	list_for_each_entry(internal_type, &_exception_store_types, list)
+		if (!strcmp(name, internal_type->type->name))
+			return internal_type;
+
+	return NULL;
+}
+
+static struct dm_exception_store_internal *
+_get_exception_store_type(const char *name)
+{
+	struct dm_exception_store_internal *internal_type;
+
+	spin_lock(&_lock);
+
+	internal_type = __find_exception_store_type(name);
+	if (internal_type) {
+		if (!internal_type->use &&
+		    !try_module_get(internal_type->type->module))
+			internal_type = NULL;
+		else
+			internal_type->use++;
+	}
+
+	spin_unlock(&_lock);
+
+	return internal_type;
+}
+
+/*
+ * FIXME:
+ * FIXME:
+ * FIXME:
+ *
+ * 'dm-exception-store-<module>' is too long of a name in my
+ * opinion, which is why I've chosen to have the files
+ * containing exception store implementations be 'dm-exstore-<module>'
+ *
+ * This is your chance to disagree....
+ *
+ * FIXME:
+ * FIXME:
+ * FIXME: (You see this by now, right? :)
+ */
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
+ * Returns: dm_exception_store_type* on success, NULL on failure
+ */
+static struct dm_exception_store_type *get_type(const char *type_name)
+{
+	char *p, *type_name_dup;
+	struct dm_exception_store_internal *internal_type;
+
+	if (!type_name)
+		return NULL;
+
+	internal_type = _get_exception_store_type(type_name);
+	if (internal_type)
+		return internal_type->type;
+
+	type_name_dup = kstrdup(type_name, GFP_KERNEL);
+	if (!type_name_dup) {
+		DMWARN("No memory left to attempt load for \"%s\"",
+		       type_name);
+		return NULL;
+	}
+
+	while (request_module("dm-exstore-%s", type_name_dup) ||
+	       !(internal_type = _get_exception_store_type(type_name))) {
+		p = strrchr(type_name_dup, '-');
+		if (!p)
+			break;
+		p[0] = '\0';
+	}
+
+	if (!internal_type)
+		DMWARN("Module for exstore type \"%s\" found.", type_name);
+
+	kfree(type_name_dup);
+
+	return internal_type ? internal_type->type : NULL;
+}
+
+static void put_type(struct dm_exception_store_type *type)
+{
+	struct dm_exception_store_internal *internal_type;
+
+	if (!type)
+		return;
+
+	spin_lock(&_lock);
+	internal_type = __find_exception_store_type(type->name);
+	if (!internal_type)
+		goto out;
+
+	if (!--internal_type->use)
+		module_put(type->module);
+
+	BUG_ON(internal_type->use < 0);
+
+out:
+	spin_unlock(&_lock);
+}
+
+static struct dm_exception_store_internal *
+_alloc_exception_store_type(struct dm_exception_store_type *type)
+{
+	struct dm_exception_store_internal *internal_type;
+
+	internal_type = kzalloc(sizeof(*internal_type), GFP_KERNEL);
+
+	if (internal_type)
+		internal_type->type = type;
+
+	return internal_type;
+}
+
+int dm_exception_store_type_register(struct dm_exception_store_type *type)
+{
+	struct dm_exception_store_internal *internal_type;
+	int r = 0;
+
+	internal_type = _alloc_exception_store_type(type);
+
+	if (!internal_type)
+		return -ENOMEM;
+
+	spin_lock(&_lock);
+	if (!__find_exception_store_type(type->name))
+		list_add(&internal_type->list, &_exception_store_types);
+	else {
+		kfree(internal_type);
+		r = -EEXIST;
+	}
+	spin_unlock(&_lock);
+
+	return r;
+}
+EXPORT_SYMBOL(dm_exception_store_type_register);
+
+int dm_exception_store_type_unregister(struct dm_exception_store_type *type)
+{
+	struct dm_exception_store_internal *internal_type;
+
+	spin_lock(&_lock);
+
+	internal_type = __find_exception_store_type(type->name);
+	if (!internal_type) {
+		spin_unlock(&_lock);
+		return -EINVAL;
+	}
+
+	if (internal_type->use) {
+		spin_unlock(&_lock);
+		return -ETXTBSY;
+	}
+
+	list_del(&internal_type->list);
+
+	spin_unlock(&_lock);
+	kfree(internal_type);
+
+	return 0;
+}
+EXPORT_SYMBOL(dm_exception_store_type_unregister);
+
+struct dm_exception_store *
+dm_exception_store_create(const char *type_name, struct dm_snapshot *s,
+			  unsigned int argc, char **argv)
+{
+	unsigned int my_argc = 0;
+	char **my_argv = NULL;
+	struct dm_exception_store_type *type;
+	struct dm_exception_store *store;
+
+	store = kmalloc(sizeof(*store), GFP_KERNEL);
+	if (!store)
+		return NULL;
+
+	/*
+	 * Unfortunately, we need to do some type_name and argument
+	 * adjusting for backwards compatibility.
+	 */
+	if (!strcasecmp("p", type_name))
+		type = get_type("persistent");
+	else if (!strcasecmp("n", type_name))
+		type = get_type("transient");
+	else {
+		my_argc = argc;
+		my_argv = argv;
+		type = get_type(type_name);
+	}
+	if (!type) {
+		kfree(store);
+		return NULL;
+	}
+
+	store->type = type;
+	store->snap = s;
+	if (type->ctr(store, my_argc, my_argv)) {
+		kfree(store);
+		put_type(type);
+		return NULL;
+	}
+
+	return store;
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
 /*-----------------------------------------------------------------
  * Persistent snapshots, by persistent we mean that the snapshot
  * will survive a reboot.
@@ -474,7 +719,40 @@ static void persistent_fraction_full(str
 	*denominator = get_dev_size(store->snap->cow->bdev);
 }
 
-static void persistent_destroy(struct dm_exception_store *store)
+static int persistent_ctr(struct dm_exception_store *store,
+			  unsigned argc, char **argv)
+{
+	struct pstore *ps;
+
+	/* allocate the pstore */
+	ps = kmalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		return -ENOMEM;
+
+	ps->snap = store->snap;
+	ps->valid = 1;
+	ps->version = SNAPSHOT_DISK_VERSION;
+	ps->area = NULL;
+	ps->next_free = 2;	/* skipping the header and first area */
+	ps->current_committed = 0;
+
+	ps->callback_count = 0;
+	atomic_set(&ps->pending_count, 0);
+	ps->callbacks = NULL;
+
+	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
+	if (!ps->metadata_wq) {
+		kfree(ps);
+		DMERR("couldn't start header metadata update thread");
+		return -ENOMEM;
+	}
+
+	store->context = ps;
+
+	return 0;
+}
+
+static void persistent_dtr(struct dm_exception_store *store)
 {
 	struct pstore *ps = get_info(store);
 
@@ -551,8 +829,8 @@ static int persistent_read_metadata(stru
 	return 0;
 }
 
-static int persistent_prepare(struct dm_exception_store *store,
-			      struct dm_snap_exception *e)
+static int persistent_prepare_exception(struct dm_exception_store *store,
+					struct dm_snap_exception *e)
 {
 	struct pstore *ps = get_info(store);
 	uint32_t stride;
@@ -578,10 +856,10 @@ static int persistent_prepare(struct dm_
 	return 0;
 }
 
-static void persistent_commit(struct dm_exception_store *store,
-			      struct dm_snap_exception *e,
-			      void (*callback) (void *, int success),
-			      void *callback_context)
+static void persistent_commit_exception(struct dm_exception_store *store,
+					struct dm_snap_exception *e,
+					void (*callback) (void *, int success),
+					void *callback_context)
 {
 	unsigned int i;
 	struct pstore *ps = get_info(store);
@@ -640,7 +918,7 @@ static void persistent_commit(struct dm_
 	ps->callback_count = 0;
 }
 
-static void persistent_drop(struct dm_exception_store *store)
+static void persistent_drop_snapshot(struct dm_exception_store *store)
 {
 	struct pstore *ps = get_info(store);
 
@@ -649,52 +927,29 @@ static void persistent_drop(struct dm_ex
 		DMWARN("write header failed");
 }
 
-int dm_create_persistent(struct dm_exception_store *store)
-{
-	struct pstore *ps;
-
-	/* allocate the pstore */
-	ps = kmalloc(sizeof(*ps), GFP_KERNEL);
-	if (!ps)
-		return -ENOMEM;
-
-	ps->snap = store->snap;
-	ps->valid = 1;
-	ps->version = SNAPSHOT_DISK_VERSION;
-	ps->area = NULL;
-	ps->next_free = 2;	/* skipping the header and first area */
-	ps->current_committed = 0;
+/*-----------------------------------------------------------------
+ * Implementation of the store for non-persistent snapshots.
+ *---------------------------------------------------------------*/
+struct transient_c {
+	sector_t next_free;
+};
 
-	ps->callback_count = 0;
-	atomic_set(&ps->pending_count, 0);
-	ps->callbacks = NULL;
+static int transient_ctr(struct dm_exception_store *store,
+			 unsigned argc, char **argv)
+{
+	struct transient_c *tc;
 
-	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
-	if (!ps->metadata_wq) {
-		kfree(ps);
-		DMERR("couldn't start header metadata update thread");
+	tc = kmalloc(sizeof(struct transient_c), GFP_KERNEL);
+	if (!tc)
 		return -ENOMEM;
-	}
 
-	store->destroy = persistent_destroy;
-	store->read_metadata = persistent_read_metadata;
-	store->prepare_exception = persistent_prepare;
-	store->commit_exception = persistent_commit;
-	store->drop_snapshot = persistent_drop;
-	store->fraction_full = persistent_fraction_full;
-	store->context = ps;
+	tc->next_free = 0;
+	store->context = tc;
 
 	return 0;
 }
 
-/*-----------------------------------------------------------------
- * Implementation of the store for non-persistent snapshots.
- *---------------------------------------------------------------*/
-struct transient_c {
-	sector_t next_free;
-};
-
-static void transient_destroy(struct dm_exception_store *store)
+static void transient_dtr(struct dm_exception_store *store)
 {
 	kfree(store->context);
 }
@@ -704,8 +959,8 @@ static int transient_read_metadata(struc
 	return 0;
 }
 
-static int transient_prepare(struct dm_exception_store *store,
-			     struct dm_snap_exception *e)
+static int transient_prepare_exception(struct dm_exception_store *store,
+				       struct dm_snap_exception *e)
 {
 	struct transient_c *tc = (struct transient_c *) store->context;
 	sector_t size = get_dev_size(store->snap->cow->bdev);
@@ -719,10 +974,10 @@ static int transient_prepare(struct dm_e
 	return 0;
 }
 
-static void transient_commit(struct dm_exception_store *store,
-			     struct dm_snap_exception *e,
-			     void (*callback) (void *, int success),
-			     void *callback_context)
+static void transient_commit_exception(struct dm_exception_store *store,
+				       struct dm_snap_exception *e,
+				       void (*callback) (void *, int success),
+				       void *callback_context)
 {
 	/* Just succeed */
 	callback(callback_context, 1);
@@ -735,23 +990,60 @@ static void transient_fraction_full(stru
 	*denominator = get_dev_size(store->snap->cow->bdev);
 }
 
-int dm_create_transient(struct dm_exception_store *store)
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
+};
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
+};
+
+int dm_exception_store_init(void)
 {
-	struct transient_c *tc;
+	int r;
 
-	store->destroy = transient_destroy;
-	store->read_metadata = transient_read_metadata;
-	store->prepare_exception = transient_prepare;
-	store->commit_exception = transient_commit;
-	store->drop_snapshot = NULL;
-	store->fraction_full = transient_fraction_full;
+	/* Register the standard old-school types */
+	r = dm_exception_store_type_register(&_transient_type);
+	if (r) {
+		DMWARN("Unable to register transient exception store type");
+		return r;
+	}
 
-	tc = kmalloc(sizeof(struct transient_c), GFP_KERNEL);
-	if (!tc)
-		return -ENOMEM;
+	r = dm_exception_store_type_register(&_persistent_type);
+	if (r) {
+		DMWARN("Unable to register presistent exception store type");
+		dm_exception_store_type_unregister(&_transient_type);
+	}
 
-	tc->next_free = 0;
-	store->context = tc;
+	return r;
+}
 
-	return 0;
+void dm_exception_store_exit(void)
+{
+	dm_exception_store_type_unregister(&_transient_type);
+	dm_exception_store_type_unregister(&_persistent_type);
 }
+
+/*
+ * We could easily make this a module, but I think we'd like
+ * the snapshot module to load the initial exception stores.
+ *
+MODULE_DESCRIPTION(DM_NAME " exception store");
+MODULE_AUTHOR("<dm-devel@redhat.com>");
+MODULE_LICENCE("GPL");
+*/
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -551,60 +551,69 @@ static int set_chunk_size(struct dm_snap
 }
 
 /*
- * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
+ * snapshot_ctr
+ * @ti
+ * @argc
+ * @argv
+ *
+ * Construct a snapshot mapping.  Possible mapping tables include:
+ *	<origin_dev> <COW-dev> <p/n> <chunk-size>
+ *	<origin_dev> <COW-dev> <exception store args> <chunk-size>
+ * where <exception store args> is:
+ *	<exception store type> <arg count> <arg1> ... <argN>
+ *  Ex1: shared 1 UUID
+ *  Ex2: clustered_shared 1 UUID
+ *  Ex3: persistent 0
+ *
+ * Returns: 0 on success, -XXX on error
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct dm_snapshot *s;
-	int i;
+	int i = 0;
 	int r = -EINVAL;
-	char persistent;
-	char *origin_path;
 	char *cow_path;
+	char *origin_path;
 
-	if (argc != 4) {
-		ti->error = "requires exactly 4 arguments";
-		r = -EINVAL;
-		goto bad1;
+	if (argc < 4) {
+		ti->error = "too few arguments";
+		return -EINVAL;
 	}
 
 	origin_path = argv[0];
 	cow_path = argv[1];
-	persistent = toupper(*argv[2]);
-
-	if (persistent != 'P' && persistent != 'N') {
-		ti->error = "Persistent flag is not P or N";
-		r = -EINVAL;
-		goto bad1;
-	}
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (s == NULL) {
 		ti->error = "Cannot allocate snapshot context private "
 		    "structure";
-		r = -ENOMEM;
-		goto bad1;
+		return -ENOMEM;
 	}
 
 	r = dm_get_device(ti, origin_path, 0, ti->len, FMODE_READ, &s->origin);
 	if (r) {
 		ti->error = "Cannot get origin device";
-		goto bad2;
+		kfree(s);
+		return r;
 	}
 
 	r = dm_get_device(ti, cow_path, 0, 0,
 			  FMODE_READ | FMODE_WRITE, &s->cow);
 	if (r) {
-		dm_put_device(ti, s->origin);
 		ti->error = "Cannot get COW device";
-		goto bad2;
+		goto bad1;
 	}
 
 	r = set_chunk_size(s, argv[3], &ti->error);
 	if (r)
-		goto bad3;
+		goto bad2;
 
-	s->type = persistent;
+	s->store = dm_exception_store_create(argv[2], s, argc - 3, argv + 3);
+	if (!s->store) {
+		ti->error = "Unable to create exception store";
+		/* r == ENOMEM?   No way to tell with this method */
+		goto bad3;
+	}
 
 	s->valid = 1;
 	s->active = 0;
@@ -617,19 +626,6 @@ static int snapshot_ctr(struct dm_target
 	if (init_hash_tables(s)) {
 		ti->error = "Unable to allocate hash table space";
 		r = -ENOMEM;
-		goto bad3;
-	}
-
-	s->store.snap = s;
-
-	if (persistent == 'P')
-		r = dm_create_persistent(&s->store);
-	else
-		r = dm_create_transient(&s->store);
-
-	if (r) {
-		ti->error = "Couldn't create exception store";
-		r = -EINVAL;
 		goto bad4;
 	}
 
@@ -650,7 +646,7 @@ static int snapshot_ctr(struct dm_target
 	if (!s->tracked_chunk_pool) {
 		ti->error = "Could not allocate tracked_chunk mempool for "
 			    "tracking reads";
-		goto bad_tracked_chunk_pool;
+		goto bad7;
 	}
 
 	for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
@@ -659,10 +655,10 @@ static int snapshot_ctr(struct dm_target
 	spin_lock_init(&s->tracked_chunk_lock);
 
 	/* Metadata must only be loaded into one table at once */
-	r = s->store.read_metadata(&s->store);
+	r = s->store->type->read_metadata(s->store);
 	if (r < 0) {
 		ti->error = "Failed to read snapshot metadata";
-		goto bad_load_and_register;
+		goto bad8;
 	} else if (r > 0) {
 		s->valid = 0;
 		DMWARN("Snapshot is marked invalid.");
@@ -676,7 +672,7 @@ static int snapshot_ctr(struct dm_target
 	if (register_snapshot(s)) {
 		r = -EINVAL;
 		ti->error = "Cannot register snapshot origin";
-		goto bad_load_and_register;
+		goto bad8;
 	}
 
 	ti->private = s;
@@ -684,30 +680,23 @@ static int snapshot_ctr(struct dm_target
 
 	return 0;
 
- bad_load_and_register:
+bad8:
 	mempool_destroy(s->tracked_chunk_pool);
-
- bad_tracked_chunk_pool:
+bad7:
 	mempool_destroy(s->pending_pool);
-
- bad6:
+bad6:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
-
- bad5:
-	s->store.destroy(&s->store);
-
- bad4:
+bad5:
 	exit_exception_table(&s->pending, pending_cache);
 	exit_exception_table(&s->complete, exception_cache);
-
- bad3:
+bad4:
+	dm_exception_store_destroy(s->store);
+bad3:
+bad2:
 	dm_put_device(ti, s->cow);
+bad1:
 	dm_put_device(ti, s->origin);
-
- bad2:
 	kfree(s);
-
- bad1:
 	return r;
 }
 
@@ -719,7 +708,7 @@ static void __free_exceptions(struct dm_
 	exit_exception_table(&s->pending, pending_cache);
 	exit_exception_table(&s->complete, exception_cache);
 
-	s->store.destroy(&s->store);
+	s->store->type->dtr(s->store);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -814,8 +803,8 @@ static void __invalidate_snapshot(struct
 	else if (err == -ENOMEM)
 		DMERR("Invalidating snapshot: Unable to allocate exception.");
 
-	if (s->store.drop_snapshot)
-		s->store.drop_snapshot(&s->store);
+	if (s->store->type->drop_snapshot)
+		s->store->type->drop_snapshot(s->store);
 
 	s->valid = 0;
 
@@ -937,8 +926,8 @@ static void copy_callback(int read_err, 
 
 	else
 		/* Update the metadata if we are persistent */
-		s->store.commit_exception(&s->store, &pe->e, commit_callback,
-					  pe);
+		s->store->type->commit_exception(s->store, &pe->e,
+						 commit_callback, pe);
 }
 
 /*
@@ -1018,7 +1007,7 @@ __find_pending_exception(struct dm_snaps
 	atomic_set(&pe->ref_count, 0);
 	pe->started = 0;
 
-	if (s->store.prepare_exception(&s->store, &pe->e)) {
+	if (s->store->type->prepare_exception(s->store, &pe->e)) {
 		free_pending_exception(pe);
 		return NULL;
 	}
@@ -1138,11 +1127,11 @@ static int snapshot_status(struct dm_tar
 		if (!snap->valid)
 			snprintf(result, maxlen, "Invalid");
 		else {
-			if (snap->store.fraction_full) {
+			if (snap->store->type->fraction_full) {
 				sector_t numerator, denominator;
-				snap->store.fraction_full(&snap->store,
-							  &numerator,
-							  &denominator);
+				snap->store->type->fraction_full(snap->store,
+								 &numerator,
+								 &denominator);
 				snprintf(result, maxlen, "%llu/%llu",
 					(unsigned long long)numerator,
 					(unsigned long long)denominator);
@@ -1405,10 +1394,16 @@ static int __init dm_snapshot_init(void)
 {
 	int r;
 
+	r = dm_exception_store_init();
+	if (r) {
+		DMERR("Failed to initialize exception stores");
+		return r;
+	}
+
 	r = dm_register_target(&snapshot_target);
 	if (r) {
 		DMERR("snapshot target register failed %d", r);
-		return r;
+		goto bad0;
 	}
 
 	r = dm_register_target(&origin_target);
@@ -1465,6 +1460,8 @@ static int __init dm_snapshot_init(void)
 	dm_unregister_target(&origin_target);
       bad1:
 	dm_unregister_target(&snapshot_target);
+      bad0:
+	dm_exception_store_exit();
 	return r;
 }
 
@@ -1486,6 +1483,8 @@ static void __exit dm_snapshot_exit(void
 	kmem_cache_destroy(pending_cache);
 	kmem_cache_destroy(exception_cache);
 	kmem_cache_destroy(tracked_chunk_cache);
+
+	dm_exception_store_exit();
 }
 
 /* Module hooks */
Index: linux-2.6/drivers/md/dm-snap.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.h
+++ linux-2.6/drivers/md/dm-snap.h
@@ -62,7 +62,7 @@ struct dm_snapshot {
 	spinlock_t pe_lock;
 
 	/* The on disk metadata handler */
-	struct dm_exception_store store;
+	struct dm_exception_store *store;
 
 	struct dm_kcopyd_client *kcopyd_client;
 
