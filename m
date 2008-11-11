From: Jonathan Brassow <jbrassow@redhat.com>
Subject: RFC::  [PATCH 3 of 3] dm-exception-store API - updated
Date: Tue, 11 Nov 2008 17:17:06 -0600
Message-ID: <1226445426.29159.21.camel@hydrogen.msp.redhat.com>
References: <1226357032.22387.21.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1226357032.22387.21.camel@hydrogen.msp.redhat.com>
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

I've tried to make some more progress on this front.  I've added the
'status' function to the API and greatly expanded the possibilities for
the constructor table.  I like this version a lot better, but I've run
into a snag and I need some advice before I proceed.

I've been successful in removing dm-snap.h - which means that there is
no cross referencing between dm-exception-store and dm-snap.  dm-snap
needs dm-exception-store, but not the other way around...  except in one
case.  When the persistent exception store reads metadata, it must
populate the snapshot's cache.  I don't want to reference 'struct
dm_snapshot' in dm_exception_store.c.

So, I can do 3 things:
1) leave dm-snap.h basically for no other reason other than the
'dm_add_exception' function.  Keep all other changes (you'll have to
push pretty hard to make me give up all the advantages gained in the
constructor).

2) Specify a callback function and (void *)snapshot to
'dm_exception_store_create' so that I can generically induce an action
in the snapshot code without having to know anything about it.

3) Push more of the functionality found in dm-snap.c into
dm-exception-store.c - potentially adding more functions to the new API
- to eliminate the need for dm-exception-store to know about dm-snap

Right now, I'm leaning toward #1.  It allows me to change the least
amount of code, while allowing me to defer the decision on #2 and #3 to
later.

Please provide feedback.  (Even if that just means you are looking at
it... otherwise, I will simply proceed with #1.)

 brassow

Create exception store API.

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -11,6 +11,7 @@
 #ifdef __KERNEL__
 
 #include <linux/blkdev.h>
+#include <linux/device-mapper.h>
 
 /*
  * The snapshot code deals with largish chunks of the disk at a
@@ -76,15 +77,42 @@ static inline void dm_consecutive_chunk_
 #  endif
 
 /*
- * Abstraction to handle the meta/layout of exception stores (the
- * COW device).
+ * Return the number of sectors in the device.
  */
+static inline sector_t get_dev_size(struct block_device *bdev)
+{
+	return bdev->bd_inode->i_size >> SECTOR_SHIFT;
+}
+
+
+struct dm_exception_store_type;
 struct dm_exception_store {
+	struct dm_exception_store_type *type;
+	struct dm_target *ti;
 
-	/*
-	 * Destroys this object when you've finished with it.
-	 */
-	void (*destroy) (struct dm_exception_store *store);
+	struct dm_dev *cow;
+
+	/* Size of data blocks saved - must be a power of 2 */
+	chunk_t chunk_size;
+	chunk_t chunk_mask;
+	chunk_t chunk_shift;
+
+	void *context;
+};
+
+static inline chunk_t sector_to_chunk(struct dm_exception_store *store,
+				      sector_t sector)
+{
+	return (sector & ~store->chunk_mask) >> store->chunk_shift;
+}
+
+struct dm_exception_store_type {
+	const char *name;
+	struct module *module;
+
+	int (*ctr) (struct dm_exception_store *store,
+		    unsigned argc, char **argv);
+	void (*dtr) (struct dm_exception_store *store);
 
 	/*
 	 * The target shouldn't read the COW device until this is
@@ -118,16 +146,20 @@ struct dm_exception_store {
 			       sector_t *numerator,
 			       sector_t *denominator);
 
-	struct dm_snapshot *snap;
-	void *context;
+	int (*status) (struct dm_exception_store *store, status_type_t status,
+		       char *result, unsigned int maxlen);
 };
 
-/*
- * Constructor and destructor for the exception stores
- */
-int dm_create_persistent(struct dm_exception_store *store);
+int dm_exception_store_type_register(struct dm_exception_store_type *type);
+int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
+
+int dm_exception_store_create(const char *type_name, struct dm_target *ti,
+			      unsigned argc, char **argv,
+			      struct dm_exception_store **store);
+void dm_exception_store_destroy(struct dm_exception_store *store);
 
-int dm_create_transient(struct dm_exception_store *store);
+int dm_exception_store_init(void);
+void dm_exception_store_exit(void);
 
 #endif /* __KERNEL__ */
 
Index: linux-2.6/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.c
+++ linux-2.6/drivers/md/dm-exception-store.c
@@ -8,7 +8,6 @@
  */
 
 #include "dm-exception-store.h"
-#include "dm-snap.h"
 
 #include <linux/mm.h>
 #include <linux/pagemap.h>
@@ -17,9 +16,329 @@
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
+/*
+ * Round a number up to the nearest 'size' boundary.  size must
+ * be a power of 2.
+ */
+static ulong round_up(ulong n, ulong size)
+{
+	size--;
+	return (n + size) & ~size;
+}
+
+static int set_chunk_size(struct dm_exception_store *store,
+			  const char *chunk_size_arg, char **error)
+{
+	unsigned long chunk_size;
+	char *value;
+
+	chunk_size = simple_strtoul(chunk_size_arg, &value, 10);
+	if (*chunk_size_arg == '\0' || *value != '\0') {
+		*error = "Invalid chunk size";
+		return -EINVAL;
+	}
+
+	if (!chunk_size) {
+		store->chunk_size = store->chunk_mask = store->chunk_shift = 0;
+		return 0;
+	}
+
+	/*
+	 * Chunk size must be multiple of page size.  Silently
+	 * round up if it's not.
+	 */
+	chunk_size = round_up(chunk_size, PAGE_SIZE >> 9);
+
+	/* Check chunk_size is a power of 2 */
+	if (!is_power_of_2(chunk_size)) {
+		*error = "Chunk size is not a power of 2";
+		return -EINVAL;
+	}
+
+	/* Validate the chunk size against the device block size */
+	if (chunk_size % (bdev_hardsect_size(store->cow->bdev) >> 9)) {
+		*error = "Chunk size is not a multiple of device blocksize";
+		return -EINVAL;
+	}
+
+	store->chunk_size = chunk_size;
+	store->chunk_mask = chunk_size - 1;
+	store->chunk_shift = ffs(chunk_size) - 1;
+
+	return 0;
+}
+
+int dm_exception_store_create(const char *type_name, struct dm_target *ti,
+			      unsigned int argc, char **argv,
+			      struct dm_exception_store **store)
+{
+	int r = 0;
+	struct dm_exception_store_type *type;
+	struct dm_exception_store *tmp_store;
+
+	if (argc < 2) {
+		ti->error = "Insufficient exception store arguments";
+		return -EINVAL;
+	}
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
+	tmp_store->ti = ti;
+
+	r = dm_get_device(ti, argv[0], 0, 0,
+			  FMODE_READ | FMODE_WRITE, &tmp_store->cow);
+	if (r) {
+		ti->error = "Cannot get COW device";
+		put_type(type);
+		kfree(tmp_store);
+		return r;
+	}
+
+	r = set_chunk_size(tmp_store, argv[1], &ti->error);
+	if (r) {
+		dm_put_device(ti, tmp_store->cow);
+		put_type(type);
+		kfree(tmp_store);
+		return r;
+	}
+
+	/*
+	 * COW-dev and chunk_size are common to all types of
+	 * exception stores and are stored directly in the
+	 * dm_exception_store and not passed on to the
+	 * constructor for the dm_exception_store_type
+	 */
+	argc -= 2;
+	argv += 2;
+
+	r = type->ctr(tmp_store, argc, argv);
+	if (r) {
+		dm_put_device(ti, tmp_store->cow);
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
+	dm_put_device(store->ti, store->cow);
+	put_type(store->type);
+	kfree(store);
+}
+EXPORT_SYMBOL(dm_exception_store_destroy);
+
 /*-----------------------------------------------------------------
  * Persistent snapshots, by persistent we mean that the snapshot
  * will survive a reboot.
@@ -92,7 +411,7 @@ struct commit_callback {
  * The top level structure for a persistent exception store.
  */
 struct pstore {
-	struct dm_snapshot *snap;	/* up pointer to my snapshot */
+	struct dm_exception_store *store;
 	int version;
 	int valid;
 	uint32_t exceptions_per_area;
@@ -144,7 +463,7 @@ static int alloc_area(struct pstore *ps)
 	int r = -ENOMEM;
 	size_t len;
 
-	len = ps->snap->chunk_size << SECTOR_SHIFT;
+	len = ps->store->chunk_size << SECTOR_SHIFT;
 
 	/*
 	 * Allocate the chunk_size block of memory that will hold
@@ -192,9 +511,9 @@ static void do_metadata(struct work_stru
 static int chunk_io(struct pstore *ps, chunk_t chunk, int rw, int metadata)
 {
 	struct dm_io_region where = {
-		.bdev = ps->snap->cow->bdev,
-		.sector = ps->snap->chunk_size * chunk,
-		.count = ps->snap->chunk_size,
+		.bdev = ps->store->cow->bdev,
+		.sector = ps->store->chunk_size * chunk,
+		.count = ps->store->chunk_size,
 	};
 	struct dm_io_request io_req = {
 		.bi_rw = rw,
@@ -250,15 +569,15 @@ static int area_io(struct pstore *ps, in
 
 static void zero_memory_area(struct pstore *ps)
 {
-	memset(ps->area, 0, ps->snap->chunk_size << SECTOR_SHIFT);
+	memset(ps->area, 0, ps->store->chunk_size << SECTOR_SHIFT);
 }
 
 static int zero_disk_area(struct pstore *ps, chunk_t area)
 {
 	struct dm_io_region where = {
-		.bdev = ps->snap->cow->bdev,
-		.sector = ps->snap->chunk_size * area_location(ps, area),
-		.count = ps->snap->chunk_size,
+		.bdev = ps->store->cow->bdev,
+		.sector = ps->store->chunk_size * area_location(ps, area),
+		.count = ps->store->chunk_size,
 	};
 	struct dm_io_request io_req = {
 		.bi_rw = WRITE,
@@ -281,15 +600,15 @@ static int read_header(struct pstore *ps
 	/*
 	 * Use default chunk size (or hardsect_size, if larger) if none supplied
 	 */
-	if (!ps->snap->chunk_size) {
-        	ps->snap->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
-		    bdev_hardsect_size(ps->snap->cow->bdev) >> 9);
-		ps->snap->chunk_mask = ps->snap->chunk_size - 1;
-		ps->snap->chunk_shift = ffs(ps->snap->chunk_size) - 1;
+	if (!ps->store->chunk_size) {
+        	ps->store->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
+		    bdev_hardsect_size(ps->store->cow->bdev) >> 9);
+		ps->store->chunk_mask = ps->store->chunk_size - 1;
+		ps->store->chunk_shift = ffs(ps->store->chunk_size) - 1;
 		chunk_size_supplied = 0;
 	}
 
-	ps->io_client = dm_io_client_create(sectors_to_pages(ps->snap->
+	ps->io_client = dm_io_client_create(sectors_to_pages(ps->store->
 							     chunk_size));
 	if (IS_ERR(ps->io_client))
 		return PTR_ERR(ps->io_client);
@@ -320,22 +639,22 @@ static int read_header(struct pstore *ps
 	ps->version = le32_to_cpu(dh->version);
 	chunk_size = le32_to_cpu(dh->chunk_size);
 
-	if (!chunk_size_supplied || ps->snap->chunk_size == chunk_size)
+	if (!chunk_size_supplied || ps->store->chunk_size == chunk_size)
 		return 0;
 
 	DMWARN("chunk size %llu in device metadata overrides "
 	       "table chunk size of %llu.",
 	       (unsigned long long)chunk_size,
-	       (unsigned long long)ps->snap->chunk_size);
+	       (unsigned long long)ps->store->chunk_size);
 
 	/* We had a bogus chunk_size. Fix stuff up. */
 	free_area(ps);
 
-	ps->snap->chunk_size = chunk_size;
-	ps->snap->chunk_mask = chunk_size - 1;
-	ps->snap->chunk_shift = ffs(chunk_size) - 1;
+	ps->store->chunk_size = chunk_size;
+	ps->store->chunk_mask = chunk_size - 1;
+	ps->store->chunk_shift = ffs(chunk_size) - 1;
 
-	r = dm_io_client_resize(sectors_to_pages(ps->snap->chunk_size),
+	r = dm_io_client_resize(sectors_to_pages(ps->store->chunk_size),
 				ps->io_client);
 	if (r)
 		return r;
@@ -352,13 +671,13 @@ static int write_header(struct pstore *p
 {
 	struct disk_header *dh;
 
-	memset(ps->area, 0, ps->snap->chunk_size << SECTOR_SHIFT);
+	memset(ps->area, 0, ps->store->chunk_size << SECTOR_SHIFT);
 
 	dh = (struct disk_header *) ps->area;
 	dh->magic = cpu_to_le32(SNAP_MAGIC);
 	dh->valid = cpu_to_le32(ps->valid);
 	dh->version = cpu_to_le32(ps->version);
-	dh->chunk_size = cpu_to_le32(ps->snap->chunk_size);
+	dh->chunk_size = cpu_to_le32(ps->store->chunk_size);
 
 	return chunk_io(ps, 0, WRITE, 1);
 }
@@ -470,11 +789,44 @@ static struct pstore *get_info(struct dm
 static void persistent_fraction_full(struct dm_exception_store *store,
 				     sector_t *numerator, sector_t *denominator)
 {
-	*numerator = get_info(store)->next_free * store->snap->chunk_size;
-	*denominator = get_dev_size(store->snap->cow->bdev);
+	*numerator = get_info(store)->next_free * store->chunk_size;
+	*denominator = get_dev_size(store->cow->bdev);
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
+	ps->store = store;
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
 
@@ -500,7 +852,7 @@ static int persistent_read_metadata(stru
 	/*
 	 * Now we know correct chunk_size, complete the initialisation.
 	 */
-	ps->exceptions_per_area = (ps->snap->chunk_size << SECTOR_SHIFT) /
+	ps->exceptions_per_area = (ps->store->chunk_size << SECTOR_SHIFT) /
 				  sizeof(struct disk_exception);
 	ps->callbacks = dm_vcalloc(ps->exceptions_per_area,
 			sizeof(*ps->callbacks));
@@ -551,16 +903,16 @@ static int persistent_read_metadata(stru
 	return 0;
 }
 
-static int persistent_prepare(struct dm_exception_store *store,
-			      struct dm_snap_exception *e)
+static int persistent_prepare_exception(struct dm_exception_store *store,
+					struct dm_snap_exception *e)
 {
 	struct pstore *ps = get_info(store);
 	uint32_t stride;
 	chunk_t next_free;
-	sector_t size = get_dev_size(store->snap->cow->bdev);
+	sector_t size = get_dev_size(store->cow->bdev);
 
 	/* Is there enough room ? */
-	if (size < ((ps->next_free + 1) * store->snap->chunk_size))
+	if (size < ((ps->next_free + 1) * store->chunk_size))
 		return -ENOSPC;
 
 	e->new_chunk = ps->next_free;
@@ -578,10 +930,10 @@ static int persistent_prepare(struct dm_
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
@@ -640,7 +992,7 @@ static void persistent_commit(struct dm_
 	ps->callback_count = 0;
 }
 
-static void persistent_drop(struct dm_exception_store *store)
+static void persistent_drop_snapshot(struct dm_exception_store *store)
 {
 	struct pstore *ps = get_info(store);
 
@@ -649,44 +1001,41 @@ static void persistent_drop(struct dm_ex
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
+static int persistent_status(struct dm_exception_store *store,
+			     status_type_t status, char *result,
+			     unsigned int maxlen)
+{
+	int sz = 0;
+
+	switch(status) {
+	case STATUSTYPE_INFO:
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT("persistent 2 %s %llu", store->cow->name,
+		       (unsigned long long)store->chunk_size);
+	}
 
-	ps->snap = store->snap;
-	ps->valid = 1;
-	ps->version = SNAPSHOT_DISK_VERSION;
-	ps->area = NULL;
-	ps->next_free = 2;	/* skipping the header and first area */
-	ps->current_committed = 0;
+	return sz;
+}
 
-	ps->callback_count = 0;
-	atomic_set(&ps->pending_count, 0);
-	ps->callbacks = NULL;
+static int persistent_status_bc(struct dm_exception_store *store,
+				status_type_t status, char *result,
+				unsigned int maxlen)
+{
+	int sz = 0;
 
-	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
-	if (!ps->metadata_wq) {
-		kfree(ps);
-		DMERR("couldn't start header metadata update thread");
-		return -ENOMEM;
+	switch(status) {
+	case STATUSTYPE_INFO:
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s p %llu", store->cow->name,
+		       (unsigned long long)store->chunk_size);
 	}
 
-	store->destroy = persistent_destroy;
-	store->read_metadata = persistent_read_metadata;
-	store->prepare_exception = persistent_prepare;
-	store->commit_exception = persistent_commit;
-	store->drop_snapshot = persistent_drop;
-	store->fraction_full = persistent_fraction_full;
-	store->context = ps;
-
-	return 0;
+	return sz;
 }
 
+
 /*-----------------------------------------------------------------
  * Implementation of the store for non-persistent snapshots.
  *---------------------------------------------------------------*/
@@ -694,7 +1043,31 @@ struct transient_c {
 	sector_t next_free;
 };
 
-static void transient_destroy(struct dm_exception_store *store)
+/*
+ * transient_ctr
+ * @store
+ * @argc
+ * @argv:  Always <COW-dev> <chunk-size>
+ *
+ * Returns: 0 on success, -Exxx on error
+ */
+static int transient_ctr(struct dm_exception_store *store,
+			 unsigned argc, char **argv)
+{
+	struct transient_c *tc;
+
+	tc = kmalloc(sizeof(struct transient_c), GFP_KERNEL);
+	if (!tc)
+		return -ENOMEM;
+
+	tc->next_free = 0;
+	store->context = tc;
+
+	return 0;
+
+}
+
+static void transient_dtr(struct dm_exception_store *store)
 {
 	kfree(store->context);
 }
@@ -704,25 +1077,25 @@ static int transient_read_metadata(struc
 	return 0;
 }
 
-static int transient_prepare(struct dm_exception_store *store,
-			     struct dm_snap_exception *e)
+static int transient_prepare_exception(struct dm_exception_store *store,
+				       struct dm_snap_exception *e)
 {
 	struct transient_c *tc = (struct transient_c *) store->context;
-	sector_t size = get_dev_size(store->snap->cow->bdev);
+	sector_t size = get_dev_size(store->cow->bdev);
 
-	if (size < (tc->next_free + store->snap->chunk_size))
+	if (size < (tc->next_free + store->chunk_size))
 		return -1;
 
-	e->new_chunk = sector_to_chunk(store->snap, tc->next_free);
-	tc->next_free += store->snap->chunk_size;
+	e->new_chunk = sector_to_chunk(store, tc->next_free);
+	tc->next_free += store->chunk_size;
 
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
@@ -732,26 +1105,145 @@ static void transient_fraction_full(stru
 				    sector_t *numerator, sector_t *denominator)
 {
 	*numerator = ((struct transient_c *) store->context)->next_free;
-	*denominator = get_dev_size(store->snap->cow->bdev);
+	*denominator = get_dev_size(store->cow->bdev);
 }
 
-int dm_create_transient(struct dm_exception_store *store)
+static int transient_status(struct dm_exception_store *store,
+			    status_type_t status, char *result,
+			    unsigned int maxlen)
 {
-	struct transient_c *tc;
+	int sz = 0;
 
-	store->destroy = transient_destroy;
-	store->read_metadata = transient_read_metadata;
-	store->prepare_exception = transient_prepare;
-	store->commit_exception = transient_commit;
-	store->drop_snapshot = NULL;
-	store->fraction_full = transient_fraction_full;
+	switch(status) {
+	case STATUSTYPE_INFO:
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT("transient 2 %s %llu", store->cow->name,
+		       (unsigned long long)store->chunk_size);
+	}
 
-	tc = kmalloc(sizeof(struct transient_c), GFP_KERNEL);
-	if (!tc)
-		return -ENOMEM;
+	return sz;
+}
 
-	tc->next_free = 0;
-	store->context = tc;
+static int transient_status_bc(struct dm_exception_store *store,
+			       status_type_t status, char *result,
+			       unsigned int maxlen)
+{
+	int sz = 0;
 
-	return 0;
+	switch(status) {
+	case STATUSTYPE_INFO:
+		break;
+	case STATUSTYPE_TABLE:
+		DMEMIT("%s n %llu", store->cow->name,
+		       (unsigned long long)store->chunk_size);
+	}
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
+/* This structure for backwards compatibility */
+static struct dm_exception_store_type _persistent_type_bc = {
+	.name = "p",
+	.module = THIS_MODULE,
+	.ctr = persistent_ctr,
+	.dtr = persistent_dtr,
+	.read_metadata = persistent_read_metadata,
+	.prepare_exception = persistent_prepare_exception,
+	.commit_exception = persistent_commit_exception,
+	.drop_snapshot = persistent_drop_snapshot,
+	.fraction_full = persistent_fraction_full,
+	.status = persistent_status_bc,
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
+	.status = transient_status,
+};
+
+/* This structure for backwards compatibility */
+static struct dm_exception_store_type _transient_type_bc = {
+	.name = "t",
+	.module = THIS_MODULE,
+	.ctr = transient_ctr,
+	.dtr = transient_dtr,
+	.read_metadata = transient_read_metadata,
+	.prepare_exception = transient_prepare_exception,
+	.commit_exception = transient_commit_exception,
+	.fraction_full = transient_fraction_full,
+	.status = transient_status_bc,
+};
+
+int dm_exception_store_init(void)
+{
+	int r;
+
+	/* Register the standard old-school types */
+	r = dm_exception_store_type_register(&_transient_type);
+	if (r) {
+		DMWARN("Unable to register transient exception store type");
+		return r;
+	}
+
+	r = dm_exception_store_type_register(&_transient_type_bc);
+	if (r) {
+		DMWARN("Unable to register transient exception store type");
+		dm_exception_store_type_unregister(&_transient_type);
+		return r;
+	}
+
+	r = dm_exception_store_type_register(&_persistent_type);
+	if (r) {
+		DMWARN("Unable to register presistent exception store type");
+		dm_exception_store_type_unregister(&_transient_type);
+		dm_exception_store_type_unregister(&_transient_type_bc);
+		return r;
+	}
+
+	r = dm_exception_store_type_register(&_persistent_type_bc);
+	if (r) {
+		DMWARN("Unable to register presistent exception store type");
+		dm_exception_store_type_unregister(&_transient_type);
+		dm_exception_store_type_unregister(&_transient_type_bc);
+		dm_exception_store_type_unregister(&_persistent_type);
+	}
+
+	return r;
+}
+
+void dm_exception_store_exit(void)
+{
+	dm_exception_store_type_unregister(&_transient_type);
+	dm_exception_store_type_unregister(&_transient_type_bc);
+	dm_exception_store_type_unregister(&_persistent_type);
+	dm_exception_store_type_unregister(&_persistent_type_bc);
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
@@ -19,9 +19,9 @@
 #include <linux/vmalloc.h>
 #include <linux/log2.h>
 #include <linux/dm-kcopyd.h>
+#include <linux/workqueue.h>
 
 #include "dm-exception-store.h"
-#include "dm-snap.h"
 #include "dm-bio-list.h"
 
 #define DM_MSG_PREFIX "snapshots"
@@ -46,9 +46,82 @@
  */
 #define MIN_IOS 256
 
+#define DM_TRACKED_CHUNK_HASH_SIZE	16
+#define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
+					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
+
+struct exception_table {
+	uint32_t hash_mask;
+	unsigned hash_shift;
+	struct list_head *table;
+};
+
+struct dm_snapshot {
+	struct rw_semaphore lock;
+	struct dm_target *ti;
+
+	struct dm_dev *origin;
+
+	/* List of snapshots per Origin */
+	struct list_head list;
+
+	/* You can't use a snapshot if this is 0 (e.g. if full) */
+	int valid;
+
+	/* Origin writes don't trigger exceptions until this is set */
+	int active;
+
+	mempool_t *pending_pool;
+
+	atomic_t pending_exceptions_count;
+
+	struct exception_table pending;
+	struct exception_table complete;
+
+	/*
+	 * pe_lock protects all pending_exception operations and access
+	 * as well as the snapshot_bios list.
+	 */
+	spinlock_t pe_lock;
+
+	/* The on disk metadata handler */
+	struct dm_exception_store *store;
+
+	struct dm_kcopyd_client *kcopyd_client;
+
+	/* Queue of snapshot writes for ksnapd to flush */
+	struct bio_list queued_bios;
+	struct work_struct queued_bios_work;
+
+	/* Chunks with outstanding reads */
+	mempool_t *tracked_chunk_pool;
+	spinlock_t tracked_chunk_lock;
+	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
+};
+
 static struct workqueue_struct *ksnapd;
 static void flush_queued_bios(struct work_struct *work);
 
+/*
+ * Used by the exception stores to load exceptions hen
+ * initialising.
+ */
+int dm_add_exception(struct dm_snapshot *s, chunk_t old, chunk_t new);
+
+static inline sector_t chunk_to_sector(struct dm_snapshot *s, chunk_t chunk)
+{
+	return chunk << s->store->chunk_shift;
+}
+
+static inline int bdev_equal(struct block_device *lhs, struct block_device *rhs)
+{
+	/*
+	 * There is only ever one instance of a particular block
+	 * device so we can compare pointers safely.
+	 */
+	return lhs == rhs;
+}
+
 struct dm_snap_pending_exception {
 	struct dm_snap_exception e;
 
@@ -470,11 +543,11 @@ static int init_hash_tables(struct dm_sn
 	 * Calculate based on the size of the original volume or
 	 * the COW volume...
 	 */
-	cow_dev_size = get_dev_size(s->cow->bdev);
+	cow_dev_size = get_dev_size(s->store->cow->bdev);
 	origin_dev_size = get_dev_size(s->origin->bdev);
 	max_buckets = calc_max_buckets();
 
-	hash_size = min(origin_dev_size, cow_dev_size) >> s->chunk_shift;
+	hash_size = min(origin_dev_size, cow_dev_size) >> s->store->chunk_shift;
 	hash_size = min(hash_size, max_buckets);
 
 	hash_size = rounddown_pow_of_two(hash_size);
@@ -499,113 +572,112 @@ static int init_hash_tables(struct dm_sn
 }
 
 /*
- * Round a number up to the nearest 'size' boundary.  size must
- * be a power of 2.
+ * create_exception_store
+ * @ti
+ * @argc
+ * @argv
+ * @args_used
+ * @store: contains newly allocated dm_exception_store
+ *
+ * Possible formats for argv::
+ * Backwards compatibility mode:
+ *	<COW-dev> p/n <chunk-size>
+ * Current format:
+ *	<store type> <arg count> <COW> <chunk-size> [other args]
+ *
+ * Returns: 0 on success, -Exxx on error
  */
-static ulong round_up(ulong n, ulong size)
+static int create_exception_store(struct dm_target *ti, unsigned argc,
+				  char **argv, unsigned *args_used,
+				  struct dm_exception_store **store)
 {
-	size--;
-	return (n + size) & ~size;
-}
+	unsigned param_count;
+	char *tmp_argv[2];
 
-static int set_chunk_size(struct dm_snapshot *s, const char *chunk_size_arg,
-			  char **error)
-{
-	unsigned long chunk_size;
-	char *value;
+	*store = NULL;
 
-	chunk_size = simple_strtoul(chunk_size_arg, &value, 10);
-	if (*chunk_size_arg == '\0' || *value != '\0') {
-		*error = "Invalid chunk size";
-		return -EINVAL;
-	}
+	if (!strcasecmp("p", argv[1]) || !strcasecmp("t", argv[1])) {
+		/* backwards compatibility translation */
 
-	if (!chunk_size) {
-		s->chunk_size = s->chunk_mask = s->chunk_shift = 0;
-		return 0;
-	}
+		if (argc < 3) {
+			ti->error = "Insufficient exception store arguments";
+			return -EINVAL;
+		}
 
-	/*
-	 * Chunk size must be multiple of page size.  Silently
-	 * round up if it's not.
-	 */
-	chunk_size = round_up(chunk_size, PAGE_SIZE >> 9);
+		tmp_argv[0] = argv[0];  /* COW dev */
+		tmp_argv[1] = argv[2];  /* chunk size */
 
-	/* Check chunk_size is a power of 2 */
-	if (!is_power_of_2(chunk_size)) {
-		*error = "Chunk size is not a power of 2";
-		return -EINVAL;
+		*args_used = 3;
+
+		return dm_exception_store_create(argv[1], ti, 2, tmp_argv, store);
 	}
 
-	/* Validate the chunk size against the device block size */
-	if (chunk_size % (bdev_hardsect_size(s->cow->bdev) >> 9)) {
-		*error = "Chunk size is not a multiple of device blocksize";
+	if (sscanf(argv[1], "%u", &param_count) != 1) {
+		ti->error = "Invalid exception store argument count";
 		return -EINVAL;
 	}
 
-	s->chunk_size = chunk_size;
-	s->chunk_mask = chunk_size - 1;
-	s->chunk_shift = ffs(chunk_size) - 1;
+	*args_used = 2 + param_count;
 
-	return 0;
+	if (argc < *args_used) {
+		ti->error = "Insufficient exception store arguments";
+		return -EINVAL;
+	}
+
+	return dm_exception_store_create(argv[0], ti, param_count, argv + 2, store);
 }
 
 /*
- * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
+ * snapshot_ctr
+ * @ti
+ * @argc
+ * @argv
+ *
+ * Construct a snapshot mapping.  Possible mapping tables include:
+ *	<origin_dev> <exception store args> <feature args>
+ * See 'create_exception_store' for format of <exception store args>.
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
 	char *origin_path;
-	char *cow_path;
+	unsigned args_used;
+	struct dm_exception_store *store;
 
-	if (argc != 4) {
-		ti->error = "requires exactly 4 arguments";
-		r = -EINVAL;
-		goto bad1;
+	if (argc < 4) {
+		ti->error = "too few arguments";
+		return -EINVAL;
 	}
 
 	origin_path = argv[0];
-	cow_path = argv[1];
-	persistent = toupper(*argv[2]);
+	argv++;
+	argc--;
+	r = create_exception_store(ti, argc, argv, &args_used, &store);
+	if (r)
+		return r;
 
-	if (persistent != 'P' && persistent != 'N') {
-		ti->error = "Persistent flag is not P or N";
-		r = -EINVAL;
-		goto bad1;
-	}
+	argc -= args_used;
+	argv += args_used;
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (s == NULL) {
-		ti->error = "Cannot allocate snapshot context private "
-		    "structure";
+		ti->error = "Cannot allocate snapshot private structure";
 		r = -ENOMEM;
 		goto bad1;
 	}
 
+	s->store = store;
+
 	r = dm_get_device(ti, origin_path, 0, ti->len, FMODE_READ, &s->origin);
 	if (r) {
 		ti->error = "Cannot get origin device";
 		goto bad2;
 	}
 
-	r = dm_get_device(ti, cow_path, 0, 0,
-			  FMODE_READ | FMODE_WRITE, &s->cow);
-	if (r) {
-		dm_put_device(ti, s->origin);
-		ti->error = "Cannot get COW device";
-		goto bad2;
-	}
-
-	r = set_chunk_size(s, argv[3], &ti->error);
-	if (r)
-		goto bad3;
-
-	s->type = persistent;
-
 	s->valid = 1;
 	s->active = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
@@ -620,29 +692,16 @@ static int snapshot_ctr(struct dm_target
 		goto bad3;
 	}
 
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
-		goto bad4;
-	}
-
 	r = dm_kcopyd_client_create(SNAPSHOT_PAGES, &s->kcopyd_client);
 	if (r) {
 		ti->error = "Could not create kcopyd client";
-		goto bad5;
+		goto bad4;
 	}
 
 	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
 	if (!s->pending_pool) {
 		ti->error = "Could not allocate mempool for pending exceptions";
-		goto bad6;
+		goto bad5;
 	}
 
 	s->tracked_chunk_pool = mempool_create_slab_pool(MIN_IOS,
@@ -650,7 +709,7 @@ static int snapshot_ctr(struct dm_target
 	if (!s->tracked_chunk_pool) {
 		ti->error = "Could not allocate tracked_chunk mempool for "
 			    "tracking reads";
-		goto bad_tracked_chunk_pool;
+		goto bad6;
 	}
 
 	for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
@@ -659,10 +718,10 @@ static int snapshot_ctr(struct dm_target
 	spin_lock_init(&s->tracked_chunk_lock);
 
 	/* Metadata must only be loaded into one table at once */
-	r = s->store.read_metadata(&s->store);
+	r = s->store->type->read_metadata(s->store);
 	if (r < 0) {
 		ti->error = "Failed to read snapshot metadata";
-		goto bad_load_and_register;
+		goto bad7;
 	} else if (r > 0) {
 		s->valid = 0;
 		DMWARN("Snapshot is marked invalid.");
@@ -676,38 +735,29 @@ static int snapshot_ctr(struct dm_target
 	if (register_snapshot(s)) {
 		r = -EINVAL;
 		ti->error = "Cannot register snapshot origin";
-		goto bad_load_and_register;
+		goto bad7;
 	}
 
 	ti->private = s;
-	ti->split_io = s->chunk_size;
+	ti->split_io = s->store->chunk_size;
 
 	return 0;
 
- bad_load_and_register:
+bad7:
 	mempool_destroy(s->tracked_chunk_pool);
-
- bad_tracked_chunk_pool:
+bad6:
 	mempool_destroy(s->pending_pool);
-
- bad6:
+bad5:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
-
- bad5:
-	s->store.destroy(&s->store);
-
- bad4:
+bad4:
 	exit_exception_table(&s->pending, pending_cache);
 	exit_exception_table(&s->complete, exception_cache);
-
- bad3:
-	dm_put_device(ti, s->cow);
+bad3:
 	dm_put_device(ti, s->origin);
-
- bad2:
+bad2:
 	kfree(s);
-
- bad1:
+bad1:
+	dm_exception_store_destroy(s->store);
 	return r;
 }
 
@@ -719,7 +769,7 @@ static void __free_exceptions(struct dm_
 	exit_exception_table(&s->pending, pending_cache);
 	exit_exception_table(&s->complete, exception_cache);
 
-	s->store.destroy(&s->store);
+	s->store->type->dtr(s->store);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -755,7 +805,6 @@ static void snapshot_dtr(struct dm_targe
 	mempool_destroy(s->pending_pool);
 
 	dm_put_device(ti, s->origin);
-	dm_put_device(ti, s->cow);
 
 	kfree(s);
 }
@@ -814,8 +863,8 @@ static void __invalidate_snapshot(struct
 	else if (err == -ENOMEM)
 		DMERR("Invalidating snapshot: Unable to allocate exception.");
 
-	if (s->store.drop_snapshot)
-		s->store.drop_snapshot(&s->store);
+	if (s->store->type->drop_snapshot)
+		s->store->type->drop_snapshot(s->store);
 
 	s->valid = 0;
 
@@ -937,8 +986,8 @@ static void copy_callback(int read_err, 
 
 	else
 		/* Update the metadata if we are persistent */
-		s->store.commit_exception(&s->store, &pe->e, commit_callback,
-					  pe);
+		s->store->type->commit_exception(s->store, &pe->e,
+						 commit_callback, pe);
 }
 
 /*
@@ -955,9 +1004,9 @@ static void start_copy(struct dm_snap_pe
 
 	src.bdev = bdev;
 	src.sector = chunk_to_sector(s, pe->e.old_chunk);
-	src.count = min(s->chunk_size, dev_size - src.sector);
+	src.count = min(s->store->chunk_size, dev_size - src.sector);
 
-	dest.bdev = s->cow->bdev;
+	dest.bdev = s->store->cow->bdev;
 	dest.sector = chunk_to_sector(s, pe->e.new_chunk);
 	dest.count = src.count;
 
@@ -979,7 +1028,7 @@ __find_pending_exception(struct dm_snaps
 {
 	struct dm_snap_exception *e;
 	struct dm_snap_pending_exception *pe;
-	chunk_t chunk = sector_to_chunk(s, bio->bi_sector);
+	chunk_t chunk = sector_to_chunk(s->store, bio->bi_sector);
 
 	/*
 	 * Is there a pending exception for this already ?
@@ -1018,7 +1067,7 @@ __find_pending_exception(struct dm_snaps
 	atomic_set(&pe->ref_count, 0);
 	pe->started = 0;
 
-	if (s->store.prepare_exception(&s->store, &pe->e)) {
+	if (s->store->type->prepare_exception(s->store, &pe->e)) {
 		free_pending_exception(pe);
 		return NULL;
 	}
@@ -1033,10 +1082,10 @@ __find_pending_exception(struct dm_snaps
 static void remap_exception(struct dm_snapshot *s, struct dm_snap_exception *e,
 			    struct bio *bio, chunk_t chunk)
 {
-	bio->bi_bdev = s->cow->bdev;
+	bio->bi_bdev = s->store->cow->bdev;
 	bio->bi_sector = chunk_to_sector(s, dm_chunk_number(e->new_chunk) +
 			 (chunk - e->old_chunk)) +
-			 (bio->bi_sector & s->chunk_mask);
+			 (bio->bi_sector & s->store->chunk_mask);
 }
 
 static int snapshot_map(struct dm_target *ti, struct bio *bio,
@@ -1048,7 +1097,7 @@ static int snapshot_map(struct dm_target
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
-	chunk = sector_to_chunk(s, bio->bi_sector);
+	chunk = sector_to_chunk(s->store, bio->bi_sector);
 
 	/* Full snapshots are not usable */
 	/* To get here the table must be live so s->active is always set. */
@@ -1131,24 +1180,25 @@ static void snapshot_resume(struct dm_ta
 static int snapshot_status(struct dm_target *ti, status_type_t type,
 			   char *result, unsigned int maxlen)
 {
+	int sz = 0;
 	struct dm_snapshot *snap = ti->private;
 
 	switch (type) {
 	case STATUSTYPE_INFO:
 		if (!snap->valid)
-			snprintf(result, maxlen, "Invalid");
+			DMEMIT("Invalid");
 		else {
-			if (snap->store.fraction_full) {
+			if (snap->store->type->fraction_full) {
 				sector_t numerator, denominator;
-				snap->store.fraction_full(&snap->store,
-							  &numerator,
-							  &denominator);
-				snprintf(result, maxlen, "%llu/%llu",
-					(unsigned long long)numerator,
-					(unsigned long long)denominator);
+				snap->store->type->fraction_full(snap->store,
+								 &numerator,
+								 &denominator);
+				DMEMIT("%llu/%llu",
+				       (unsigned long long)numerator,
+				       (unsigned long long)denominator);
 			}
 			else
-				snprintf(result, maxlen, "Unknown");
+				DMEMIT("Unknown");
 		}
 		break;
 
@@ -1158,10 +1208,9 @@ static int snapshot_status(struct dm_tar
 		 * to make private copies if the output is to
 		 * make sense.
 		 */
-		snprintf(result, maxlen, "%s %s %c %llu",
-			 snap->origin->name, snap->cow->name,
-			 snap->type,
-			 (unsigned long long)snap->chunk_size);
+		DMEMIT("%s", snap->origin->name);
+		snap->store->type->status(snap->store, type, result, maxlen);
+
 		break;
 	}
 
@@ -1197,7 +1246,7 @@ static int __origin_write(struct list_he
 		 * Remember, different snapshots can have
 		 * different chunk sizes.
 		 */
-		chunk = sector_to_chunk(snap, bio->bi_sector);
+		chunk = sector_to_chunk(snap->store, bio->bi_sector);
 
 		/*
 		 * Check exception table to see if block
@@ -1354,7 +1403,7 @@ static void origin_resume(struct dm_targ
 	o = __lookup_origin(dev->bdev);
 	if (o)
 		list_for_each_entry (snap, &o->snapshots, list)
-			chunk_size = min_not_zero(chunk_size, snap->chunk_size);
+			chunk_size = min_not_zero(chunk_size, snap->store->chunk_size);
 	up_read(&_origins_lock);
 
 	ti->split_io = chunk_size;
@@ -1405,10 +1454,16 @@ static int __init dm_snapshot_init(void)
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
@@ -1465,6 +1520,8 @@ static int __init dm_snapshot_init(void)
 	dm_unregister_target(&origin_target);
       bad1:
 	dm_unregister_target(&snapshot_target);
+      bad0:
+	dm_exception_store_exit();
 	return r;
 }
 
@@ -1486,6 +1543,8 @@ static void __exit dm_snapshot_exit(void
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
+++ /dev/null
@@ -1,112 +0,0 @@
-/*
- * dm-snapshot.c
- *
- * Copyright (C) 2001-2002 Sistina Software (UK) Limited.
- *
- * This file is released under the GPL.
- */
-
-#ifndef DM_SNAPSHOT_H
-#define DM_SNAPSHOT_H
-
-#include <linux/device-mapper.h>
-#include "dm-bio-list.h"
-#include <linux/blkdev.h>
-#include <linux/workqueue.h>
-
-struct exception_table {
-	uint32_t hash_mask;
-	unsigned hash_shift;
-	struct list_head *table;
-};
-
-#define DM_TRACKED_CHUNK_HASH_SIZE	16
-#define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
-					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
-
-struct dm_snapshot {
-	struct rw_semaphore lock;
-	struct dm_target *ti;
-
-	struct dm_dev *origin;
-	struct dm_dev *cow;
-
-	/* List of snapshots per Origin */
-	struct list_head list;
-
-	/* Size of data blocks saved - must be a power of 2 */
-	chunk_t chunk_size;
-	chunk_t chunk_mask;
-	chunk_t chunk_shift;
-
-	/* You can't use a snapshot if this is 0 (e.g. if full) */
-	int valid;
-
-	/* Origin writes don't trigger exceptions until this is set */
-	int active;
-
-	/* Used for display of table */
-	char type;
-
-	mempool_t *pending_pool;
-
-	atomic_t pending_exceptions_count;
-
-	struct exception_table pending;
-	struct exception_table complete;
-
-	/*
-	 * pe_lock protects all pending_exception operations and access
-	 * as well as the snapshot_bios list.
-	 */
-	spinlock_t pe_lock;
-
-	/* The on disk metadata handler */
-	struct dm_exception_store store;
-
-	struct dm_kcopyd_client *kcopyd_client;
-
-	/* Queue of snapshot writes for ksnapd to flush */
-	struct bio_list queued_bios;
-	struct work_struct queued_bios_work;
-
-	/* Chunks with outstanding reads */
-	mempool_t *tracked_chunk_pool;
-	spinlock_t tracked_chunk_lock;
-	struct hlist_head tracked_chunk_hash[DM_TRACKED_CHUNK_HASH_SIZE];
-};
-
-/*
- * Used by the exception stores to load exceptions hen
- * initialising.
- */
-int dm_add_exception(struct dm_snapshot *s, chunk_t old, chunk_t new);
-
-/*
- * Return the number of sectors in the device.
- */
-static inline sector_t get_dev_size(struct block_device *bdev)
-{
-	return bdev->bd_inode->i_size >> SECTOR_SHIFT;
-}
-
-static inline chunk_t sector_to_chunk(struct dm_snapshot *s, sector_t sector)
-{
-	return (sector & ~s->chunk_mask) >> s->chunk_shift;
-}
-
-static inline sector_t chunk_to_sector(struct dm_snapshot *s, chunk_t chunk)
-{
-	return chunk << s->chunk_shift;
-}
-
-static inline int bdev_equal(struct block_device *lhs, struct block_device *rhs)
-{
-	/*
-	 * There is only ever one instance of a particular block
-	 * device so we can compare pointers safely.
-	 */
-	return lhs == rhs;
-}
-
-#endif
