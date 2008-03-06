From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 3/6] dm headers(2nd): change names of "struct
	dirty_log", dm_create_dirty_log(),
	etc. in dm-log.h to prepare for move of the header to include/linux
	and adjust callers.
Date: Thu,  6 Mar 2008 14:11:42 +0100
Message-ID: <1204809105-22360-4-git-send-email-hjm@redhat.com>
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
Cc: Heinz Mauelshagen <hjm@redhat.com>
List-Id: dm-devel.ids

---
 drivers/md/dm-log.c   |   82 ++++++++++++++++++++++++------------------------
 drivers/md/dm-log.h   |   53 +++++++++++++++++--------------
 drivers/md/dm-raid1.c |   36 +++++++++++-----------
 3 files changed, 88 insertions(+), 83 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-log.c linux-2.6.25-rc4/drivers/md/dm-log.c
index ec73b34..975cf15 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-log.c
+++ linux-2.6.25-rc4/drivers/md/dm-log.c
@@ -18,7 +18,7 @@
 static LIST_HEAD(_log_types);
 static DEFINE_SPINLOCK(_lock);
 
-int dm_register_dirty_log_type(struct dirty_log_type *type)
+int dm_dirty_log_type_register(struct dm_dirty_log_type *type)
 {
 	spin_lock(&_lock);
 	type->use_count = 0;
@@ -28,7 +28,7 @@ int dm_register_dirty_log_type(struct dirty_log_type *type)
 	return 0;
 }
 
-int dm_unregister_dirty_log_type(struct dirty_log_type *type)
+int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type)
 {
 	spin_lock(&_lock);
 
@@ -42,9 +42,9 @@ int dm_unregister_dirty_log_type(struct dirty_log_type *type)
 	return 0;
 }
 
-static struct dirty_log_type *_get_type(const char *type_name)
+static struct dm_dirty_log_type *_get_type(const char *type_name)
 {
-	struct dirty_log_type *type;
+	struct dm_dirty_log_type *type;
 
 	spin_lock(&_lock);
 	list_for_each_entry (type, &_log_types, list)
@@ -79,10 +79,10 @@ static struct dirty_log_type *_get_type(const char *type_name)
  *
  * Returns: dirty_log_type* on success, NULL on failure
  */
-static struct dirty_log_type *get_type(const char *type_name)
+static struct dm_dirty_log_type *get_type(const char *type_name)
 {
 	char *p, *type_name_dup;
-	struct dirty_log_type *type;
+	struct dm_dirty_log_type *type;
 
 	type = _get_type(type_name);
 	if (type)
@@ -111,7 +111,7 @@ static struct dirty_log_type *get_type(const char *type_name)
 	return type;
 }
 
-static void put_type(struct dirty_log_type *type)
+static void put_type(struct dm_dirty_log_type *type)
 {
 	spin_lock(&_lock);
 	if (!--type->use_count)
@@ -119,11 +119,11 @@ static void put_type(struct dirty_log_type *type)
 	spin_unlock(&_lock);
 }
 
-struct dirty_log *dm_create_dirty_log(const char *type_name, struct dm_target *ti,
+struct dm_dirty_log *dm_dirty_log_create(const char *type_name, struct dm_target *ti,
 				      unsigned int argc, char **argv)
 {
-	struct dirty_log_type *type;
-	struct dirty_log *log;
+	struct dm_dirty_log_type *type;
+	struct dm_dirty_log *log;
 
 	log = kmalloc(sizeof(*log), GFP_KERNEL);
 	if (!log)
@@ -145,7 +145,7 @@ struct dirty_log *dm_create_dirty_log(const char *type_name, struct dm_target *t
 	return log;
 }
 
-void dm_destroy_dirty_log(struct dirty_log *log)
+void dm_dirty_log_destroy(struct dm_dirty_log *log)
 {
 	log->type->dtr(log);
 	put_type(log->type);
@@ -303,7 +303,7 @@ static inline int write_header(struct log_c *log)
  * argv contains region_size followed optionally by [no]sync
  *--------------------------------------------------------------*/
 #define BYTE_SHIFT 3
-static int create_log_context(struct dirty_log *log, struct dm_target *ti,
+static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 			      unsigned int argc, char **argv,
 			      struct dm_dev *dev)
 {
@@ -435,7 +435,7 @@ static int create_log_context(struct dirty_log *log, struct dm_target *ti,
 	return 0;
 }
 
-static int core_ctr(struct dirty_log *log, struct dm_target *ti,
+static int core_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		    unsigned int argc, char **argv)
 {
 	return create_log_context(log, ti, argc, argv, NULL);
@@ -448,7 +448,7 @@ static void destroy_log_context(struct log_c *lc)
 	kfree(lc);
 }
 
-static void core_dtr(struct dirty_log *log)
+static void core_dtr(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 
@@ -461,7 +461,7 @@ static void core_dtr(struct dirty_log *log)
  *
  * argv contains log_device region_size followed optionally by [no]sync
  *--------------------------------------------------------------*/
-static int disk_ctr(struct dirty_log *log, struct dm_target *ti,
+static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		    unsigned int argc, char **argv)
 {
 	int r;
@@ -486,7 +486,7 @@ static int disk_ctr(struct dirty_log *log, struct dm_target *ti,
 	return 0;
 }
 
-static void disk_dtr(struct dirty_log *log)
+static void disk_dtr(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 
@@ -515,7 +515,7 @@ static void fail_log_device(struct log_c *lc)
 	dm_table_event(lc->ti->table);
 }
 
-static int disk_resume(struct dirty_log *log)
+static int disk_resume(struct dm_dirty_log *log)
 {
 	int r;
 	unsigned i;
@@ -571,38 +571,38 @@ static int disk_resume(struct dirty_log *log)
 	return r;
 }
 
-static uint32_t core_get_region_size(struct dirty_log *log)
+static uint32_t core_get_region_size(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	return lc->region_size;
 }
 
-static int core_resume(struct dirty_log *log)
+static int core_resume(struct dm_dirty_log *log)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	lc->sync_search = 0;
 	return 0;
 }
 
-static int core_is_clean(struct dirty_log *log, region_t region)
+static int core_is_clean(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	return log_test_bit(lc->clean_bits, region);
 }
 
-static int core_in_sync(struct dirty_log *log, region_t region, int block)
+static int core_in_sync(struct dm_dirty_log *log, region_t region, int block)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	return log_test_bit(lc->sync_bits, region);
 }
 
-static int core_flush(struct dirty_log *log)
+static int core_flush(struct dm_dirty_log *log)
 {
 	/* no op */
 	return 0;
 }
 
-static int disk_flush(struct dirty_log *log)
+static int disk_flush(struct dm_dirty_log *log)
 {
 	int r;
 	struct log_c *lc = (struct log_c *) log->context;
@@ -620,19 +620,19 @@ static int disk_flush(struct dirty_log *log)
 	return r;
 }
 
-static void core_mark_region(struct dirty_log *log, region_t region)
+static void core_mark_region(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	log_clear_bit(lc, lc->clean_bits, region);
 }
 
-static void core_clear_region(struct dirty_log *log, region_t region)
+static void core_clear_region(struct dm_dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 	log_set_bit(lc, lc->clean_bits, region);
 }
 
-static int core_get_resync_work(struct dirty_log *log, region_t *region)
+static int core_get_resync_work(struct dm_dirty_log *log, region_t *region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
 
@@ -655,7 +655,7 @@ static int core_get_resync_work(struct dirty_log *log, region_t *region)
 	return 1;
 }
 
-static void core_set_region_sync(struct dirty_log *log, region_t region,
+static void core_set_region_sync(struct dm_dirty_log *log, region_t region,
 				 int in_sync)
 {
 	struct log_c *lc = (struct log_c *) log->context;
@@ -670,7 +670,7 @@ static void core_set_region_sync(struct dirty_log *log, region_t region,
 	}
 }
 
-static region_t core_get_sync_count(struct dirty_log *log)
+static region_t core_get_sync_count(struct dm_dirty_log *log)
 {
         struct log_c *lc = (struct log_c *) log->context;
 
@@ -681,7 +681,7 @@ static region_t core_get_sync_count(struct dirty_log *log)
 	if (lc->sync != DEFAULTSYNC) \
 		DMEMIT("%ssync ", lc->sync == NOSYNC ? "no" : "")
 
-static int core_status(struct dirty_log *log, status_type_t status,
+static int core_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
@@ -701,7 +701,7 @@ static int core_status(struct dirty_log *log, status_type_t status,
 	return sz;
 }
 
-static int disk_status(struct dirty_log *log, status_type_t status,
+static int disk_status(struct dm_dirty_log *log, status_type_t status,
 		       char *result, unsigned int maxlen)
 {
 	int sz = 0;
@@ -723,7 +723,7 @@ static int disk_status(struct dirty_log *log, status_type_t status,
 	return sz;
 }
 
-static struct dirty_log_type _core_type = {
+static struct dm_dirty_log_type _core_type = {
 	.name = "core",
 	.module = THIS_MODULE,
 	.ctr = core_ctr,
@@ -741,7 +741,7 @@ static struct dirty_log_type _core_type = {
 	.status = core_status,
 };
 
-static struct dirty_log_type _disk_type = {
+static struct dm_dirty_log_type _disk_type = {
 	.name = "disk",
 	.module = THIS_MODULE,
 	.ctr = disk_ctr,
@@ -764,14 +764,14 @@ int __init dm_dirty_log_init(void)
 {
 	int r;
 
-	r = dm_register_dirty_log_type(&_core_type);
+	r = dm_dirty_log_type_register(&_core_type);
 	if (r)
 		DMWARN("couldn't register core log");
 
-	r = dm_register_dirty_log_type(&_disk_type);
+	r = dm_dirty_log_type_register(&_disk_type);
 	if (r) {
 		DMWARN("couldn't register disk type");
-		dm_unregister_dirty_log_type(&_core_type);
+		dm_dirty_log_type_unregister(&_core_type);
 	}
 
 	return r;
@@ -779,14 +779,14 @@ int __init dm_dirty_log_init(void)
 
 void __exit dm_dirty_log_exit(void)
 {
-	dm_unregister_dirty_log_type(&_disk_type);
-	dm_unregister_dirty_log_type(&_core_type);
+	dm_dirty_log_type_unregister(&_disk_type);
+	dm_dirty_log_type_unregister(&_core_type);
 }
 
-EXPORT_SYMBOL(dm_register_dirty_log_type);
-EXPORT_SYMBOL(dm_unregister_dirty_log_type);
-EXPORT_SYMBOL(dm_create_dirty_log);
-EXPORT_SYMBOL(dm_destroy_dirty_log);
+EXPORT_SYMBOL(dm_dirty_log_type_register);
+EXPORT_SYMBOL(dm_dirty_log_type_unregister);
+EXPORT_SYMBOL(dm_dirty_log_create);
+EXPORT_SYMBOL(dm_dirty_log_destroy);
 
 module_init(dm_dirty_log_init);
 module_exit(dm_dirty_log_exit);
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-log.h linux-2.6.25-rc4/drivers/md/dm-log.h
index 3fae87e..66d44b7 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-log.h
+++ linux-2.6.25-rc4/drivers/md/dm-log.h
@@ -1,5 +1,8 @@
 /*
  * Copyright (C) 2003 Sistina Software
+ * Copyright (C) 2004-2008 Red Hat GmbH
+ *
+ * Device-Mapper dirty region log.
  *
  * This file is released under the LGPL.
  */
@@ -11,42 +14,42 @@
 
 typedef sector_t region_t;
 
-struct dirty_log_type;
+struct dm_dirty_log_type;
 
-struct dirty_log {
-	struct dirty_log_type *type;
+struct dm_dirty_log {
+	struct dm_dirty_log_type *type;
 	void *context;
 };
 
-struct dirty_log_type {
+struct dm_dirty_log_type {
 	struct list_head list;
 	const char *name;
 	struct module *module;
 	unsigned int use_count;
 
-	int (*ctr)(struct dirty_log *log, struct dm_target *ti,
+	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
 		   unsigned int argc, char **argv);
-	void (*dtr)(struct dirty_log *log);
+	void (*dtr)(struct dm_dirty_log *log);
 
 	/*
 	 * There are times when we don't want the log to touch
 	 * the disk.
 	 */
-	int (*presuspend)(struct dirty_log *log);
-	int (*postsuspend)(struct dirty_log *log);
-	int (*resume)(struct dirty_log *log);
+	int (*presuspend)(struct dm_dirty_log *log);
+	int (*postsuspend)(struct dm_dirty_log *log);
+	int (*resume)(struct dm_dirty_log *log);
 
 	/*
 	 * Retrieves the smallest size of region that the log can
 	 * deal with.
 	 */
-	uint32_t (*get_region_size)(struct dirty_log *log);
+	uint32_t (*get_region_size)(struct dm_dirty_log *log);
 
         /*
 	 * A predicate to say whether a region is clean or not.
 	 * May block.
 	 */
-	int (*is_clean)(struct dirty_log *log, region_t region);
+	int (*is_clean)(struct dm_dirty_log *log, region_t region);
 
 	/*
 	 *  Returns: 0, 1, -EWOULDBLOCK, < 0
@@ -59,13 +62,14 @@ struct dirty_log_type {
 	 * passed to a daemon to deal with, since a daemon is
 	 * allowed to block.
 	 */
-	int (*in_sync)(struct dirty_log *log, region_t region, int can_block);
+	int (*in_sync)(struct dm_dirty_log *log, region_t region,
+		       int can_block);
 
 	/*
 	 * Flush the current log state (eg, to disk).  This
 	 * function may block.
 	 */
-	int (*flush)(struct dirty_log *log);
+	int (*flush)(struct dm_dirty_log *log);
 
 	/*
 	 * Mark an area as clean or dirty.  These functions may
@@ -73,8 +77,8 @@ struct dirty_log_type {
 	 * be extremely rare (eg, allocating another chunk of
 	 * memory for some reason).
 	 */
-	void (*mark_region)(struct dirty_log *log, region_t region);
-	void (*clear_region)(struct dirty_log *log, region_t region);
+	void (*mark_region)(struct dm_dirty_log *log, region_t region);
+	void (*clear_region)(struct dm_dirty_log *log, region_t region);
 
 	/*
 	 * Returns: <0 (error), 0 (no region), 1 (region)
@@ -88,39 +92,40 @@ struct dirty_log_type {
 	 * tells you if an area is synchronised, the other
 	 * assigns recovery work.
 	*/
-	int (*get_resync_work)(struct dirty_log *log, region_t *region);
+	int (*get_resync_work)(struct dm_dirty_log *log, region_t *region);
 
 	/*
 	 * This notifies the log that the resync status of a region
 	 * has changed.  It also clears the region from the recovering
 	 * list (if present).
 	 */
-	void (*set_region_sync)(struct dirty_log *log,
+	void (*set_region_sync)(struct dm_dirty_log *log,
 				region_t region, int in_sync);
 
         /*
 	 * Returns the number of regions that are in sync.
          */
-        region_t (*get_sync_count)(struct dirty_log *log);
+        region_t (*get_sync_count)(struct dm_dirty_log *log);
 
 	/*
 	 * Support function for mirror status requests.
 	 */
-	int (*status)(struct dirty_log *log, status_type_t status_type,
+	int (*status)(struct dm_dirty_log *log, status_type_t status_type,
 		      char *result, unsigned int maxlen);
 };
 
-int dm_register_dirty_log_type(struct dirty_log_type *type);
-int dm_unregister_dirty_log_type(struct dirty_log_type *type);
+int dm_dirty_log_type_register(struct dm_dirty_log_type *type);
+int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type);
 
 
 /*
  * Make sure you use these two functions, rather than calling
  * type->constructor/destructor() directly.
  */
-struct dirty_log *dm_create_dirty_log(const char *type_name, struct dm_target *ti,
-				      unsigned int argc, char **argv);
-void dm_destroy_dirty_log(struct dirty_log *log);
+struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
+					 struct dm_target *ti,
+					 unsigned int argc, char **argv);
+void dm_dirty_log_destroy(struct dm_dirty_log *log);
 
 /*
  * init/exit functions.
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c linux-2.6.25-rc4/drivers/md/dm-raid1.c
index fdb9f5f..19608cd 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c
+++ linux-2.6.25-rc4/drivers/md/dm-raid1.c
@@ -74,7 +74,7 @@ struct region_hash {
 	unsigned region_shift;
 
 	/* holds persistent region state */
-	struct dirty_log *log;
+	struct dm_dirty_log *log;
 
 	/* hash table */
 	rwlock_t hash_lock;
@@ -184,7 +184,7 @@ static void queue_bio(struct mirror_set *ms, struct bio *bio, int rw);
 #define MIN_REGIONS 64
 #define MAX_RECOVERY 1
 static int rh_init(struct region_hash *rh, struct mirror_set *ms,
-		   struct dirty_log *log, uint32_t region_size,
+		   struct dm_dirty_log *log, uint32_t region_size,
 		   region_t nr_regions)
 {
 	unsigned int nr_buckets, max_buckets;
@@ -249,7 +249,7 @@ static void rh_exit(struct region_hash *rh)
 	}
 
 	if (rh->log)
-		dm_destroy_dirty_log(rh->log);
+		dm_dirty_log_destroy(rh->log);
 	if (rh->region_pool)
 		mempool_destroy(rh->region_pool);
 	vfree(rh->buckets);
@@ -833,7 +833,7 @@ static void do_recovery(struct mirror_set *ms)
 {
 	int r;
 	struct region *reg;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 
 	/*
 	 * Start quiescing some regions.
@@ -1019,7 +1019,7 @@ static void __bio_mark_nosync(struct mirror_set *ms,
 {
 	unsigned long flags;
 	struct region_hash *rh = &ms->rh;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 	struct region *reg;
 	region_t region = bio_to_region(rh, bio);
 	int recovering = 0;
@@ -1303,7 +1303,7 @@ static void do_mirror(struct work_struct *work)
 static struct mirror_set *alloc_context(unsigned int nr_mirrors,
 					uint32_t region_size,
 					struct dm_target *ti,
-					struct dirty_log *dl)
+					struct dm_dirty_log *dl)
 {
 	size_t len;
 	struct mirror_set *ms = NULL;
@@ -1403,12 +1403,12 @@ static int get_mirror(struct mirror_set *ms, struct dm_target *ti,
 /*
  * Create dirty log: log_type #log_params <log_params>
  */
-static struct dirty_log *create_dirty_log(struct dm_target *ti,
+static struct dm_dirty_log *create_dirty_log(struct dm_target *ti,
 					  unsigned int argc, char **argv,
 					  unsigned int *args_used)
 {
 	unsigned int param_count;
-	struct dirty_log *dl;
+	struct dm_dirty_log *dl;
 
 	if (argc < 2) {
 		ti->error = "Insufficient mirror log arguments";
@@ -1427,7 +1427,7 @@ static struct dirty_log *create_dirty_log(struct dm_target *ti,
 		return NULL;
 	}
 
-	dl = dm_create_dirty_log(argv[0], ti, param_count, argv + 2);
+	dl = dm_dirty_log_create(argv[0], ti, param_count, argv + 2);
 	if (!dl) {
 		ti->error = "Error creating mirror dirty log";
 		return NULL;
@@ -1435,7 +1435,7 @@ static struct dirty_log *create_dirty_log(struct dm_target *ti,
 
 	if (!_check_region_size(ti, dl->type->get_region_size(dl))) {
 		ti->error = "Invalid region size";
-		dm_destroy_dirty_log(dl);
+		dm_dirty_log_destroy(dl);
 		return NULL;
 	}
 
@@ -1496,7 +1496,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	int r;
 	unsigned int nr_mirrors, m, args_used;
 	struct mirror_set *ms;
-	struct dirty_log *dl;
+	struct dm_dirty_log *dl;
 
 	dl = create_dirty_log(ti, argc, argv, &args_used);
 	if (!dl)
@@ -1508,7 +1508,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	if (!argc || sscanf(argv[0], "%u", &nr_mirrors) != 1 ||
 	    nr_mirrors < 2 || nr_mirrors > DM_KCOPYD_MAX_REGIONS + 1) {
 		ti->error = "Invalid number of mirrors";
-		dm_destroy_dirty_log(dl);
+		dm_dirty_log_destroy(dl);
 		return -EINVAL;
 	}
 
@@ -1516,13 +1516,13 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	if (argc < nr_mirrors * 2) {
 		ti->error = "Too few mirror arguments";
-		dm_destroy_dirty_log(dl);
+		dm_dirty_log_destroy(dl);
 		return -EINVAL;
 	}
 
 	ms = alloc_context(nr_mirrors, dl->type->get_region_size(dl), ti, dl);
 	if (!ms) {
-		dm_destroy_dirty_log(dl);
+		dm_dirty_log_destroy(dl);
 		return -ENOMEM;
 	}
 
@@ -1734,7 +1734,7 @@ out:
 static void mirror_presuspend(struct dm_target *ti)
 {
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 
 	atomic_set(&ms->suspend, 1);
 
@@ -1763,7 +1763,7 @@ static void mirror_presuspend(struct dm_target *ti)
 static void mirror_postsuspend(struct dm_target *ti)
 {
 	struct mirror_set *ms = ti->private;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 
 	if (log->type->postsuspend && log->type->postsuspend(log))
 		/* FIXME: need better error handling */
@@ -1773,7 +1773,7 @@ static void mirror_postsuspend(struct dm_target *ti)
 static void mirror_resume(struct dm_target *ti)
 {
 	struct mirror_set *ms = ti->private;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 
 	atomic_set(&ms->suspend, 0);
 	if (log->type->resume && log->type->resume(log))
@@ -1811,7 +1811,7 @@ static int mirror_status(struct dm_target *ti, status_type_t type,
 {
 	unsigned int m, sz = 0;
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
-	struct dirty_log *log = ms->rh.log;
+	struct dm_dirty_log *log = ms->rh.log;
 	char buffer[ms->nr_mirrors + 1];
 
 	switch (type) {
-- 
1.5.4.1
