From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 2/6] dm headers(2nd): change names of
	kcopyd_client, kcopyd_copy,
	etc. in kcopyd.h to have "dm_" prefix in order to prepare for move of
	the header to include/linux and adjust callers.
Date: Thu,  6 Mar 2008 14:11:41 +0100
Message-ID: <1204809105-22360-3-git-send-email-hjm@redhat.com>
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
 drivers/md/dm-raid1.c |   16 ++++++++--------
 drivers/md/dm-snap.c  |    8 ++++----
 drivers/md/dm-snap.h  |    2 +-
 drivers/md/kcopyd.c   |   47 ++++++++++++++++++++++++-----------------------
 drivers/md/kcopyd.h   |   37 ++++++++++++++++++++-----------------
 5 files changed, 57 insertions(+), 53 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c linux-2.6.25-rc4/drivers/md/dm-raid1.c
index b594dee..fdb9f5f 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c
+++ linux-2.6.25-rc4/drivers/md/dm-raid1.c
@@ -133,7 +133,7 @@ struct mirror_set {
 	struct dm_target *ti;
 	struct list_head list;
 	struct region_hash rh;
-	struct kcopyd_client *kcopyd_client;
+	struct dm_kcopyd_client *kcopyd_client;
 	uint64_t features;
 
 	spinlock_t lock;	/* protects the lists */
@@ -790,7 +790,7 @@ static int recover(struct mirror_set *ms, struct region *reg)
 {
 	int r;
 	unsigned int i;
-	struct dm_io_region from, to[KCOPYD_MAX_REGIONS], *dest;
+	struct dm_io_region from, to[DM_KCOPYD_MAX_REGIONS], *dest;
 	struct mirror *m;
 	unsigned long flags = 0;
 
@@ -822,9 +822,9 @@ static int recover(struct mirror_set *ms, struct region *reg)
 	}
 
 	/* hand to kcopyd */
-	set_bit(KCOPYD_IGNORE_ERROR, &flags);
-	r = kcopyd_copy(ms->kcopyd_client, &from, ms->nr_mirrors - 1, to, flags,
-			recovery_complete, reg);
+	set_bit(DM_KCOPYD_IGNORE_ERROR, &flags);
+	r = dm_kcopyd_copy(ms->kcopyd_client, &from, ms->nr_mirrors - 1, to,
+			   flags, recovery_complete, reg);
 
 	return r;
 }
@@ -1506,7 +1506,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	argc -= args_used;
 
 	if (!argc || sscanf(argv[0], "%u", &nr_mirrors) != 1 ||
-	    nr_mirrors < 2 || nr_mirrors > KCOPYD_MAX_REGIONS + 1) {
+	    nr_mirrors < 2 || nr_mirrors > DM_KCOPYD_MAX_REGIONS + 1) {
 		ti->error = "Invalid number of mirrors";
 		dm_destroy_dirty_log(dl);
 		return -EINVAL;
@@ -1571,7 +1571,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto err_destroy_wq;
 	}
 
-	r = kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
+	r = dm_kcopyd_client_create(DM_IO_PAGES, &ms->kcopyd_client);
 	if (r)
 		goto err_destroy_wq;
 
@@ -1590,7 +1590,7 @@ static void mirror_dtr(struct dm_target *ti)
 	struct mirror_set *ms = (struct mirror_set *) ti->private;
 
 	flush_workqueue(ms->kmirrord_wq);
-	kcopyd_client_destroy(ms->kcopyd_client);
+	dm_kcopyd_client_destroy(ms->kcopyd_client);
 	destroy_workqueue(ms->kmirrord_wq);
 	free_context(ms, ti, ms->nr_mirrors);
 }
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-snap.c linux-2.6.25-rc4/drivers/md/dm-snap.c
index 7133ecf..3bd62db 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-snap.c
+++ linux-2.6.25-rc4/drivers/md/dm-snap.c
@@ -558,7 +558,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad4;
 	}
 
-	r = kcopyd_client_create(SNAPSHOT_PAGES, &s->kcopyd_client);
+	r = dm_kcopyd_client_create(SNAPSHOT_PAGES, &s->kcopyd_client);
 	if (r) {
 		ti->error = "Could not create kcopyd client";
 		goto bad5;
@@ -591,7 +591,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	return 0;
 
  bad6:
-	kcopyd_client_destroy(s->kcopyd_client);
+	dm_kcopyd_client_destroy(s->kcopyd_client);
 
  bad5:
 	s->store.destroy(&s->store);
@@ -613,7 +613,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 static void __free_exceptions(struct dm_snapshot *s)
 {
-	kcopyd_client_destroy(s->kcopyd_client);
+	dm_kcopyd_client_destroy(s->kcopyd_client);
 	s->kcopyd_client = NULL;
 
 	exit_exception_table(&s->pending, pending_cache);
@@ -839,7 +839,7 @@ static void start_copy(struct dm_snap_pending_exception *pe)
 	dest.count = src.count;
 
 	/* Hand over to kcopyd */
-	kcopyd_copy(s->kcopyd_client,
+	dm_kcopyd_copy(s->kcopyd_client,
 		    &src, 1, &dest, 0, copy_callback, pe);
 }
 
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-snap.h linux-2.6.25-rc4/drivers/md/dm-snap.h
index 93bce5d..214548e 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-snap.h
+++ linux-2.6.25-rc4/drivers/md/dm-snap.h
@@ -169,7 +169,7 @@ struct dm_snapshot {
 	/* The on disk metadata handler */
 	struct exception_store store;
 
-	struct kcopyd_client *kcopyd_client;
+	struct dm_kcopyd_client *kcopyd_client;
 
 	/* Queue of snapshot writes for ksnapd to flush */
 	struct bio_list queued_bios;
diff --git linux-2.6.25-rc4.orig/drivers/md/kcopyd.c linux-2.6.25-rc4/drivers/md/kcopyd.c
index bbfd7ce..aa1fbda 100644
--- linux-2.6.25-rc4.orig/drivers/md/kcopyd.c
+++ linux-2.6.25-rc4/drivers/md/kcopyd.c
@@ -38,7 +38,7 @@ static void wake(void)
  * Each kcopyd client has its own little pool of preallocated
  * pages for kcopyd io.
  *---------------------------------------------------------------*/
-struct kcopyd_client {
+struct dm_kcopyd_client {
 	struct list_head list;
 
 	spinlock_t lock;
@@ -75,7 +75,7 @@ static void free_pl(struct page_list *pl)
 	kfree(pl);
 }
 
-static int kcopyd_get_pages(struct kcopyd_client *kc,
+static int kcopyd_get_pages(struct dm_kcopyd_client *kc,
 			    unsigned int nr, struct page_list **pages)
 {
 	struct page_list *pl;
@@ -98,7 +98,7 @@ static int kcopyd_get_pages(struct kcopyd_client *kc,
 	return 0;
 }
 
-static void kcopyd_put_pages(struct kcopyd_client *kc, struct page_list *pl)
+static void kcopyd_put_pages(struct dm_kcopyd_client *kc, struct page_list *pl)
 {
 	struct page_list *cursor;
 
@@ -126,7 +126,7 @@ static void drop_pages(struct page_list *pl)
 	}
 }
 
-static int client_alloc_pages(struct kcopyd_client *kc, unsigned int nr)
+static int client_alloc_pages(struct dm_kcopyd_client *kc, unsigned int nr)
 {
 	unsigned int i;
 	struct page_list *pl = NULL, *next;
@@ -147,7 +147,7 @@ static int client_alloc_pages(struct kcopyd_client *kc, unsigned int nr)
 	return 0;
 }
 
-static void client_free_pages(struct kcopyd_client *kc)
+static void client_free_pages(struct dm_kcopyd_client *kc)
 {
 	BUG_ON(kc->nr_free_pages != kc->nr_pages);
 	drop_pages(kc->pages);
@@ -161,7 +161,7 @@ static void client_free_pages(struct kcopyd_client *kc)
  * ever having to do io (which could cause a deadlock).
  *---------------------------------------------------------------*/
 struct kcopyd_job {
-	struct kcopyd_client *kc;
+	struct dm_kcopyd_client *kc;
 	struct list_head list;
 	unsigned long flags;
 
@@ -181,7 +181,7 @@ struct kcopyd_job {
 	 * The destinations for the transfer.
 	 */
 	unsigned int num_dests;
-	struct dm_io_region dests[KCOPYD_MAX_REGIONS];
+	struct dm_io_region dests[DM_KCOPYD_MAX_REGIONS];
 
 	sector_t offset;
 	unsigned int nr_pages;
@@ -191,7 +191,7 @@ struct kcopyd_job {
 	 * Set this to ensure you are notified when the job has
 	 * completed.  'context' is for callback to use.
 	 */
-	kcopyd_notify_fn fn;
+	dm_kcopyd_notify_fn fn;
 	void *context;
 
 	/*
@@ -294,8 +294,8 @@ static int run_complete_job(struct kcopyd_job *job)
 	void *context = job->context;
 	int read_err = job->read_err;
 	unsigned int write_err = job->write_err;
-	kcopyd_notify_fn fn = job->fn;
-	struct kcopyd_client *kc = job->kc;
+	dm_kcopyd_notify_fn fn = job->fn;
+	struct dm_kcopyd_client *kc = job->kc;
 
 	kcopyd_put_pages(kc, job->pages);
 	mempool_free(job, _job_pool);
@@ -317,7 +317,7 @@ static void complete_io(unsigned long error, void *context)
 		else
 			job->read_err = 1;
 
-		if (!test_bit(KCOPYD_IGNORE_ERROR, &job->flags)) {
+		if (!test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
 			push(&_complete_jobs, job);
 			wake();
 			return;
@@ -469,7 +469,7 @@ static void segment_complete(int read_err,
 	 * Only dispatch more work if there hasn't been an error.
 	 */
 	if ((!job->read_err && !job->write_err) ||
-	    test_bit(KCOPYD_IGNORE_ERROR, &job->flags)) {
+	    test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
 		/* get the next chunk of work */
 		progress = job->progress;
 		count = job->source.count - progress;
@@ -526,9 +526,9 @@ static void split_job(struct kcopyd_job *job)
 		segment_complete(0, 0u, job);
 }
 
-int kcopyd_copy(struct kcopyd_client *kc, struct dm_io_region *from,
-		unsigned int num_dests, struct dm_io_region *dests,
-		unsigned int flags, kcopyd_notify_fn fn, void *context)
+int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
+		   unsigned int num_dests, struct dm_io_region *dests,
+		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context)
 {
 	struct kcopyd_job *job;
 
@@ -588,14 +588,14 @@ int kcopyd_cancel(struct kcopyd_job *job, int block)
 static DEFINE_MUTEX(_client_lock);
 static LIST_HEAD(_clients);
 
-static void client_add(struct kcopyd_client *kc)
+static void client_add(struct dm_kcopyd_client *kc)
 {
 	mutex_lock(&_client_lock);
 	list_add(&kc->list, &_clients);
 	mutex_unlock(&_client_lock);
 }
 
-static void client_del(struct kcopyd_client *kc)
+static void client_del(struct dm_kcopyd_client *kc)
 {
 	mutex_lock(&_client_lock);
 	list_del(&kc->list);
@@ -649,10 +649,11 @@ static void kcopyd_exit(void)
 	mutex_unlock(&kcopyd_init_lock);
 }
 
-int kcopyd_client_create(unsigned int nr_pages, struct kcopyd_client **result)
+int dm_kcopyd_client_create(unsigned int nr_pages,
+			    struct dm_kcopyd_client **result)
 {
 	int r = 0;
-	struct kcopyd_client *kc;
+	struct dm_kcopyd_client *kc;
 
 	r = kcopyd_init();
 	if (r)
@@ -691,7 +692,7 @@ int kcopyd_client_create(unsigned int nr_pages, struct kcopyd_client **result)
 	return 0;
 }
 
-void kcopyd_client_destroy(struct kcopyd_client *kc)
+void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc)
 {
 	/* Wait for completion of all jobs submitted by this client. */
 	wait_event(kc->destroyq, !atomic_read(&kc->nr_jobs));
@@ -703,6 +704,6 @@ void kcopyd_client_destroy(struct kcopyd_client *kc)
 	kcopyd_exit();
 }
 
-EXPORT_SYMBOL(kcopyd_client_create);
-EXPORT_SYMBOL(kcopyd_client_destroy);
-EXPORT_SYMBOL(kcopyd_copy);
+EXPORT_SYMBOL(dm_kcopyd_client_create);
+EXPORT_SYMBOL(dm_kcopyd_client_destroy);
+EXPORT_SYMBOL(dm_kcopyd_copy);
diff --git linux-2.6.25-rc4.orig/drivers/md/kcopyd.h linux-2.6.25-rc4/drivers/md/kcopyd.h
index d30a893..eb998c0 100644
--- linux-2.6.25-rc4.orig/drivers/md/kcopyd.h
+++ linux-2.6.25-rc4/drivers/md/kcopyd.h
@@ -1,11 +1,13 @@
 /*
- * Copyright (C) 2001 Sistina Software
+ * Copyright (C) 2001-2003 Sistina Software
+ * Copyright (C) 2004-2008 Red Hat GmbH
+ *
+ * dm-kcopyd provides a simple interface for copying an area of one
+ * block-device to one or more other block-devices, either synchronous
+ * or with an asynchronous completion notification.
  *
  * This file is released under the GPL.
  *
- * Kcopyd provides a simple interface for copying an area of one
- * block-device to one or more other block-devices, with an asynchronous
- * completion notification.
  */
 
 #ifndef DM_KCOPYD_H
@@ -14,29 +16,30 @@
 #include "dm-io.h"
 
 /* FIXME: make this configurable */
-#define KCOPYD_MAX_REGIONS 8
+#define DM_KCOPYD_MAX_REGIONS 8
 
-#define KCOPYD_IGNORE_ERROR 1
+#define DM_KCOPYD_IGNORE_ERROR 1
 
 /*
- * To use kcopyd you must first create a kcopyd client object.
+ * To use dm-kcopyd you must first create a kcopyd client object.
  */
-struct kcopyd_client;
-int kcopyd_client_create(unsigned int num_pages, struct kcopyd_client **result);
-void kcopyd_client_destroy(struct kcopyd_client *kc);
+struct dm_kcopyd_client;
+int dm_kcopyd_client_create(unsigned int num_pages,
+			    struct dm_kcopyd_client **result);
+void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc);
 
 /*
- * Submit a copy job to kcopyd.  This is built on top of the
+ * Submit a copy job to dm-kcopyd.  This is built on top of the
  * previous three fns.
  *
  * read_err is a boolean,
- * write_err is a bitset, with 1 bit for each destination region
+ * write_err is a bitset, with 1 bit for each destination region.
  */
-typedef void (*kcopyd_notify_fn)(int read_err,
-				 unsigned int write_err, void *context);
+typedef void (*dm_kcopyd_notify_fn)(int read_err,
+				    unsigned int write_err, void *context);
 
-int kcopyd_copy(struct kcopyd_client *kc, struct dm_io_region *from,
-		unsigned int num_dests, struct dm_io_region *dests,
-		unsigned int flags, kcopyd_notify_fn fn, void *context);
+int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
+		   unsigned int num_dests, struct dm_io_region *dests,
+		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context);
 
 #endif
-- 
1.5.4.1
