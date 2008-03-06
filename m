From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 4/6] dm headers(2nd): rename kcopyd[ch] to
	dm-kcopyd.[ch], move dm-{io, kcopyd,
	log}.h to include/linux and adjust callers
Date: Thu,  6 Mar 2008 14:11:43 +0100
Message-ID: <1204809105-22360-5-git-send-email-hjm@redhat.com>
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
 drivers/md/Makefile             |    4 +-
 drivers/md/dm-exception-store.c |    4 +-
 drivers/md/dm-io.c              |    3 +-
 drivers/md/dm-io.h              |   82 -----
 drivers/md/dm-kcopyd.c          |  710 +++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-log.c             |    7 +-
 drivers/md/dm-log.h             |  136 --------
 drivers/md/dm-raid1.c           |    6 +-
 drivers/md/dm-snap.c            |    2 +-
 drivers/md/kcopyd.c             |  709 --------------------------------------
 drivers/md/kcopyd.h             |   45 ---
 11 files changed, 724 insertions(+), 984 deletions(-)
 delete mode 100644 drivers/md/dm-io.h
 create mode 100644 drivers/md/dm-kcopyd.c
 delete mode 100644 drivers/md/dm-log.h
 delete mode 100644 drivers/md/kcopyd.c
 delete mode 100644 drivers/md/kcopyd.h

diff --git linux-2.6.25-rc4.orig/drivers/md/Makefile linux-2.6.25-rc4/drivers/md/Makefile
index be4b069..2e86b80 100644
--- linux-2.6.25-rc4.orig/drivers/md/Makefile
+++ linux-2.6.25-rc4/drivers/md/Makefile
@@ -3,7 +3,7 @@
 #
 
 dm-mod-objs	:= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
-		   dm-ioctl.o dm-io.o kcopyd.o
+		   dm-ioctl.o
 dm-multipath-objs := dm-hw-handler.o dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception-store.o
 dm-mirror-objs	:= dm-raid1.o
@@ -39,7 +39,7 @@ obj-$(CONFIG_DM_MULTIPATH_EMC)	+= dm-emc.o
 obj-$(CONFIG_DM_MULTIPATH_HP)	+= dm-hp-sw.o
 obj-$(CONFIG_DM_MULTIPATH_RDAC)	+= dm-rdac.o
 obj-$(CONFIG_DM_SNAPSHOT)	+= dm-snapshot.o
-obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o
+obj-$(CONFIG_DM_MIRROR)		+= dm-mirror.o dm-log.o dm-io.o dm-kcopyd.o
 obj-$(CONFIG_DM_ZERO)		+= dm-zero.o
 
 quiet_cmd_unroll = UNROLL  $@
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-exception-store.c linux-2.6.25-rc4/drivers/md/dm-exception-store.c
index b8e210e..17b0f8f 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-exception-store.c
+++ linux-2.6.25-rc4/drivers/md/dm-exception-store.c
@@ -9,9 +9,9 @@
 
 #include "dm.h"
 #include "dm-snap.h"
-#include "dm-io.h"
-#include "kcopyd.h"
 
+#include <linux/dm-io.h>
+#include <linux/dm-kcopyd.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-io.c linux-2.6.25-rc4/drivers/md/dm-io.c
index fa9f4e6..fcf4322 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-io.c
+++ linux-2.6.25-rc4/drivers/md/dm-io.c
@@ -5,8 +5,9 @@
  * This file is released under the GPL.
  */
 
-#include "dm-io.h"
+#include "dm.h"
 
+#include <linux/dm-io.h>
 #include <linux/bio.h>
 #include <linux/mempool.h>
 #include <linux/module.h>
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-io.h linux-2.6.25-rc4/drivers/md/dm-io.h
deleted file mode 100644
index 765c85c..0000000
--- linux-2.6.25-rc4.orig/drivers/md/dm-io.h
+++ /dev/null
@@ -1,82 +0,0 @@
-/*
- * Copyright (C) 2003 Sistina Software
- * Copyright (C) 2004-2008 Red Hat GmbH
- *
- * Device-Mapper low-level I/O.
- *
- * This file is released under the GPL.
- */
-
-#ifndef _DM_IO_H
-#define _DM_IO_H
-
-#include "dm.h"
-
-struct dm_io_region {
-	struct block_device *bdev;
-	sector_t sector;
-	sector_t count;		/* If this is zero the region is ignored. */
-};
-
-struct page_list {
-	struct page_list *next;
-	struct page *page;
-};
-
-typedef void (*io_notify_fn)(unsigned long error, void *context);
-
-enum dm_io_mem_type {
-	DM_IO_PAGE_LIST,/* Page list */
-	DM_IO_BVEC,	/* Bio vector */
-	DM_IO_VMA,	/* Virtual memory area */
-	DM_IO_KMEM,	/* Kernel memory */
-};
-
-struct dm_io_memory {
-	enum dm_io_mem_type type;
-
-	union {
-		struct page_list *pl;
-		struct bio_vec *bvec;
-		void *vma;
-		void *addr;
-	} ptr;
-
-	unsigned offset;
-};
-
-struct dm_io_notify {
-	io_notify_fn fn;	/* Callback for asynchronous requests */
-	void *context;		/* Passed to callback */
-};
-
-/*
- * IO request structure
- */
-struct dm_io_client;
-struct dm_io_request {
-	int bi_rw;			/* READ|WRITE - not READA */
-	struct dm_io_memory mem;	/* Memory to use for io */
-	struct dm_io_notify notify;	/* Synchronous if notify.fn is NULL */
-	struct dm_io_client *client;	/* Client memory handler */
-};
-
-/*
- * For async io calls, users can alternatively use the dm_io() function below
- * and dm_io_client_create() to create private mempools for the client.
- *
- * Create/destroy may block.
- */
-struct dm_io_client *dm_io_client_create(unsigned num_pages);
-int dm_io_client_resize(unsigned num_pages, struct dm_io_client *client);
-void dm_io_client_destroy(struct dm_io_client *client);
-
-/*
- * IO interface using private per-client pools.
- * Each bit in the optional 'sync_error_bits' bitset indicates whether an
- * error occurred doing io to the corresponding region.
- */
-int dm_io(struct dm_io_request *io_req, unsigned num_regions,
-	  struct dm_io_region *region, unsigned long *sync_error_bits);
-
-#endif
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-kcopyd.c linux-2.6.25-rc4/drivers/md/dm-kcopyd.c
new file mode 100644
index 0000000..530929c
--- /dev/null
+++ linux-2.6.25-rc4/drivers/md/dm-kcopyd.c
@@ -0,0 +1,710 @@
+/*
+ * Copyright (C) 2002 Sistina Software (UK) Limited.
+ * Copyright (C) 2006 Red Hat GmbH
+ *
+ * This file is released under the GPL.
+ *
+ * Kcopyd provides a simple interface for copying an area of one
+ * block-device to one or more other block-devices, with an asynchronous
+ * completion notification.
+ */
+
+#include "dm.h"
+
+#include <asm/types.h>
+#include <asm/atomic.h>
+
+#include <linux/dm-kcopyd.h>
+#include <linux/blkdev.h>
+#include <linux/fs.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/mempool.h>
+#include <linux/module.h>
+#include <linux/pagemap.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+#include <linux/mutex.h>
+
+static struct workqueue_struct *_kcopyd_wq;
+static struct work_struct _kcopyd_work;
+
+static void wake(void)
+{
+	queue_work(_kcopyd_wq, &_kcopyd_work);
+}
+
+/*-----------------------------------------------------------------
+ * Each kcopyd client has its own little pool of preallocated
+ * pages for kcopyd io.
+ *---------------------------------------------------------------*/
+struct dm_kcopyd_client {
+	struct list_head list;
+
+	spinlock_t lock;
+	struct page_list *pages;
+	unsigned int nr_pages;
+	unsigned int nr_free_pages;
+
+	struct dm_io_client *io_client;
+
+	wait_queue_head_t destroyq;
+	atomic_t nr_jobs;
+};
+
+static struct page_list *alloc_pl(void)
+{
+	struct page_list *pl;
+
+	pl = kmalloc(sizeof(*pl), GFP_KERNEL);
+	if (!pl)
+		return NULL;
+
+	pl->page = alloc_page(GFP_KERNEL);
+	if (!pl->page) {
+		kfree(pl);
+		return NULL;
+	}
+
+	return pl;
+}
+
+static void free_pl(struct page_list *pl)
+{
+	__free_page(pl->page);
+	kfree(pl);
+}
+
+static int kcopyd_get_pages(struct dm_kcopyd_client *kc,
+			    unsigned int nr, struct page_list **pages)
+{
+	struct page_list *pl;
+
+	spin_lock(&kc->lock);
+	if (kc->nr_free_pages < nr) {
+		spin_unlock(&kc->lock);
+		return -ENOMEM;
+	}
+
+	kc->nr_free_pages -= nr;
+	for (*pages = pl = kc->pages; --nr; pl = pl->next)
+		;
+
+	kc->pages = pl->next;
+	pl->next = NULL;
+
+	spin_unlock(&kc->lock);
+
+	return 0;
+}
+
+static void kcopyd_put_pages(struct dm_kcopyd_client *kc, struct page_list *pl)
+{
+	struct page_list *cursor;
+
+	spin_lock(&kc->lock);
+	for (cursor = pl; cursor->next; cursor = cursor->next)
+		kc->nr_free_pages++;
+
+	kc->nr_free_pages++;
+	cursor->next = kc->pages;
+	kc->pages = pl;
+	spin_unlock(&kc->lock);
+}
+
+/*
+ * These three functions resize the page pool.
+ */
+static void drop_pages(struct page_list *pl)
+{
+	struct page_list *next;
+
+	while (pl) {
+		next = pl->next;
+		free_pl(pl);
+		pl = next;
+	}
+}
+
+static int client_alloc_pages(struct dm_kcopyd_client *kc, unsigned int nr)
+{
+	unsigned int i;
+	struct page_list *pl = NULL, *next;
+
+	for (i = 0; i < nr; i++) {
+		next = alloc_pl();
+		if (!next) {
+			if (pl)
+				drop_pages(pl);
+			return -ENOMEM;
+		}
+		next->next = pl;
+		pl = next;
+	}
+
+	kcopyd_put_pages(kc, pl);
+	kc->nr_pages += nr;
+	return 0;
+}
+
+static void client_free_pages(struct dm_kcopyd_client *kc)
+{
+	BUG_ON(kc->nr_free_pages != kc->nr_pages);
+	drop_pages(kc->pages);
+	kc->pages = NULL;
+	kc->nr_free_pages = kc->nr_pages = 0;
+}
+
+/*-----------------------------------------------------------------
+ * kcopyd_jobs need to be allocated by the *clients* of kcopyd,
+ * for this reason we use a mempool to prevent the client from
+ * ever having to do io (which could cause a deadlock).
+ *---------------------------------------------------------------*/
+struct kcopyd_job {
+	struct dm_kcopyd_client *kc;
+	struct list_head list;
+	unsigned long flags;
+
+	/*
+	 * Error state of the job.
+	 */
+	int read_err;
+	unsigned int write_err;
+
+	/*
+	 * Either READ or WRITE
+	 */
+	int rw;
+	struct dm_io_region source;
+
+	/*
+	 * The destinations for the transfer.
+	 */
+	unsigned int num_dests;
+	struct dm_io_region dests[DM_KCOPYD_MAX_REGIONS];
+
+	sector_t offset;
+	unsigned int nr_pages;
+	struct page_list *pages;
+
+	/*
+	 * Set this to ensure you are notified when the job has
+	 * completed.  'context' is for callback to use.
+	 */
+	dm_kcopyd_notify_fn fn;
+	void *context;
+
+	/*
+	 * These fields are only used if the job has been split
+	 * into more manageable parts.
+	 */
+	struct mutex lock;
+	atomic_t sub_jobs;
+	sector_t progress;
+};
+
+/* FIXME: this should scale with the number of pages */
+#define MIN_JOBS 512
+
+static struct kmem_cache *_job_cache;
+static mempool_t *_job_pool;
+
+/*
+ * We maintain three lists of jobs:
+ *
+ * i)   jobs waiting for pages
+ * ii)  jobs that have pages, and are waiting for the io to be issued.
+ * iii) jobs that have completed.
+ *
+ * All three of these are protected by job_lock.
+ */
+static DEFINE_SPINLOCK(_job_lock);
+
+static LIST_HEAD(_complete_jobs);
+static LIST_HEAD(_io_jobs);
+static LIST_HEAD(_pages_jobs);
+
+static int jobs_init(void)
+{
+	_job_cache = KMEM_CACHE(kcopyd_job, 0);
+	if (!_job_cache)
+		return -ENOMEM;
+
+	_job_pool = mempool_create_slab_pool(MIN_JOBS, _job_cache);
+	if (!_job_pool) {
+		kmem_cache_destroy(_job_cache);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void jobs_exit(void)
+{
+	BUG_ON(!list_empty(&_complete_jobs));
+	BUG_ON(!list_empty(&_io_jobs));
+	BUG_ON(!list_empty(&_pages_jobs));
+
+	mempool_destroy(_job_pool);
+	kmem_cache_destroy(_job_cache);
+	_job_pool = NULL;
+	_job_cache = NULL;
+}
+
+/*
+ * Functions to push and pop a job onto the head of a given job
+ * list.
+ */
+static struct kcopyd_job *pop(struct list_head *jobs)
+{
+	struct kcopyd_job *job = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&_job_lock, flags);
+
+	if (!list_empty(jobs)) {
+		job = list_entry(jobs->next, struct kcopyd_job, list);
+		list_del(&job->list);
+	}
+	spin_unlock_irqrestore(&_job_lock, flags);
+
+	return job;
+}
+
+static void push(struct list_head *jobs, struct kcopyd_job *job)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&_job_lock, flags);
+	list_add_tail(&job->list, jobs);
+	spin_unlock_irqrestore(&_job_lock, flags);
+}
+
+/*
+ * These three functions process 1 item from the corresponding
+ * job list.
+ *
+ * They return:
+ * < 0: error
+ *   0: success
+ * > 0: can't process yet.
+ */
+static int run_complete_job(struct kcopyd_job *job)
+{
+	void *context = job->context;
+	int read_err = job->read_err;
+	unsigned int write_err = job->write_err;
+	dm_kcopyd_notify_fn fn = job->fn;
+	struct dm_kcopyd_client *kc = job->kc;
+
+	kcopyd_put_pages(kc, job->pages);
+	mempool_free(job, _job_pool);
+	fn(read_err, write_err, context);
+
+	if (atomic_dec_and_test(&kc->nr_jobs))
+		wake_up(&kc->destroyq);
+
+	return 0;
+}
+
+static void complete_io(unsigned long error, void *context)
+{
+	struct kcopyd_job *job = (struct kcopyd_job *) context;
+
+	if (error) {
+		if (job->rw == WRITE)
+			job->write_err |= error;
+		else
+			job->read_err = 1;
+
+		if (!test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
+			push(&_complete_jobs, job);
+			wake();
+			return;
+		}
+	}
+
+	if (job->rw == WRITE)
+		push(&_complete_jobs, job);
+
+	else {
+		job->rw = WRITE;
+		push(&_io_jobs, job);
+	}
+
+	wake();
+}
+
+/*
+ * Request io on as many buffer heads as we can currently get for
+ * a particular job.
+ */
+static int run_io_job(struct kcopyd_job *job)
+{
+	int r;
+	struct dm_io_request io_req = {
+		.bi_rw = job->rw,
+		.mem.type = DM_IO_PAGE_LIST,
+		.mem.ptr.pl = job->pages,
+		.mem.offset = job->offset,
+		.notify.fn = complete_io,
+		.notify.context = job,
+		.client = job->kc->io_client,
+	};
+
+	if (job->rw == READ)
+		r = dm_io(&io_req, 1, &job->source, NULL);
+	else
+		r = dm_io(&io_req, job->num_dests, job->dests, NULL);
+
+	return r;
+}
+
+static int run_pages_job(struct kcopyd_job *job)
+{
+	int r;
+
+	job->nr_pages = dm_div_up(job->dests[0].count + job->offset,
+				  PAGE_SIZE >> 9);
+	r = kcopyd_get_pages(job->kc, job->nr_pages, &job->pages);
+	if (!r) {
+		/* this job is ready for io */
+		push(&_io_jobs, job);
+		return 0;
+	}
+
+	if (r == -ENOMEM)
+		/* can't complete now */
+		return 1;
+
+	return r;
+}
+
+/*
+ * Run through a list for as long as possible.  Returns the count
+ * of successful jobs.
+ */
+static int process_jobs(struct list_head *jobs, int (*fn) (struct kcopyd_job *))
+{
+	struct kcopyd_job *job;
+	int r, count = 0;
+
+	while ((job = pop(jobs))) {
+
+		r = fn(job);
+
+		if (r < 0) {
+			/* error this rogue job */
+			if (job->rw == WRITE)
+				job->write_err = (unsigned int) -1;
+			else
+				job->read_err = 1;
+			push(&_complete_jobs, job);
+			break;
+		}
+
+		if (r > 0) {
+			/*
+			 * We couldn't service this job ATM, so
+			 * push this job back onto the list.
+			 */
+			push(jobs, job);
+			break;
+		}
+
+		count++;
+	}
+
+	return count;
+}
+
+/*
+ * kcopyd does this every time it's woken up.
+ */
+static void do_work(struct work_struct *ignored)
+{
+	/*
+	 * The order that these are called is *very* important.
+	 * complete jobs can free some pages for pages jobs.
+	 * Pages jobs when successful will jump onto the io jobs
+	 * list.  io jobs call wake when they complete and it all
+	 * starts again.
+	 */
+	process_jobs(&_complete_jobs, run_complete_job);
+	process_jobs(&_pages_jobs, run_pages_job);
+	process_jobs(&_io_jobs, run_io_job);
+}
+
+/*
+ * If we are copying a small region we just dispatch a single job
+ * to do the copy, otherwise the io has to be split up into many
+ * jobs.
+ */
+static void dispatch_job(struct kcopyd_job *job)
+{
+	atomic_inc(&job->kc->nr_jobs);
+	push(&_pages_jobs, job);
+	wake();
+}
+
+#define SUB_JOB_SIZE 128
+static void segment_complete(int read_err,
+			     unsigned int write_err, void *context)
+{
+	/* FIXME: tidy this function */
+	sector_t progress = 0;
+	sector_t count = 0;
+	struct kcopyd_job *job = (struct kcopyd_job *) context;
+
+	mutex_lock(&job->lock);
+
+	/* update the error */
+	if (read_err)
+		job->read_err = 1;
+
+	if (write_err)
+		job->write_err |= write_err;
+
+	/*
+	 * Only dispatch more work if there hasn't been an error.
+	 */
+	if ((!job->read_err && !job->write_err) ||
+	    test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
+		/* get the next chunk of work */
+		progress = job->progress;
+		count = job->source.count - progress;
+		if (count) {
+			if (count > SUB_JOB_SIZE)
+				count = SUB_JOB_SIZE;
+
+			job->progress += count;
+		}
+	}
+	mutex_unlock(&job->lock);
+
+	if (count) {
+		int i;
+		struct kcopyd_job *sub_job = mempool_alloc(_job_pool, GFP_NOIO);
+
+		*sub_job = *job;
+		sub_job->source.sector += progress;
+		sub_job->source.count = count;
+
+		for (i = 0; i < job->num_dests; i++) {
+			sub_job->dests[i].sector += progress;
+			sub_job->dests[i].count = count;
+		}
+
+		sub_job->fn = segment_complete;
+		sub_job->context = job;
+		dispatch_job(sub_job);
+
+	} else if (atomic_dec_and_test(&job->sub_jobs)) {
+
+		/*
+		 * To avoid a race we must keep the job around
+		 * until after the notify function has completed.
+		 * Otherwise the client may try and stop the job
+		 * after we've completed.
+		 */
+		job->fn(read_err, write_err, job->context);
+		mempool_free(job, _job_pool);
+	}
+}
+
+/*
+ * Create some little jobs that will do the move between
+ * them.
+ */
+#define SPLIT_COUNT 8
+static void split_job(struct kcopyd_job *job)
+{
+	int i;
+
+	atomic_set(&job->sub_jobs, SPLIT_COUNT);
+	for (i = 0; i < SPLIT_COUNT; i++)
+		segment_complete(0, 0u, job);
+}
+
+int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
+		   unsigned int num_dests, struct dm_io_region *dests,
+		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context)
+{
+	struct kcopyd_job *job;
+
+	/*
+	 * Allocate a new job.
+	 */
+	job = mempool_alloc(_job_pool, GFP_NOIO);
+
+	/*
+	 * set up for the read.
+	 */
+	job->kc = kc;
+	job->flags = flags;
+	job->read_err = 0;
+	job->write_err = 0;
+	job->rw = READ;
+
+	job->source = *from;
+
+	job->num_dests = num_dests;
+	memcpy(&job->dests, dests, sizeof(*dests) * num_dests);
+
+	job->offset = 0;
+	job->nr_pages = 0;
+	job->pages = NULL;
+
+	job->fn = fn;
+	job->context = context;
+
+	if (job->source.count < SUB_JOB_SIZE)
+		dispatch_job(job);
+
+	else {
+		mutex_init(&job->lock);
+		job->progress = 0;
+		split_job(job);
+	}
+
+	return 0;
+}
+
+/*
+ * Cancels a kcopyd job, eg. someone might be deactivating a
+ * mirror.
+ */
+#if 0
+int kcopyd_cancel(struct kcopyd_job *job, int block)
+{
+	/* FIXME: finish */
+	return -1;
+}
+#endif  /*  0  */
+
+/*-----------------------------------------------------------------
+ * Unit setup
+ *---------------------------------------------------------------*/
+static DEFINE_MUTEX(_client_lock);
+static LIST_HEAD(_clients);
+
+static void client_add(struct dm_kcopyd_client *kc)
+{
+	mutex_lock(&_client_lock);
+	list_add(&kc->list, &_clients);
+	mutex_unlock(&_client_lock);
+}
+
+static void client_del(struct dm_kcopyd_client *kc)
+{
+	mutex_lock(&_client_lock);
+	list_del(&kc->list);
+	mutex_unlock(&_client_lock);
+}
+
+static DEFINE_MUTEX(kcopyd_init_lock);
+static int kcopyd_clients = 0;
+
+static int kcopyd_init(void)
+{
+	int r;
+
+	mutex_lock(&kcopyd_init_lock);
+
+	if (kcopyd_clients) {
+		/* Already initialized. */
+		kcopyd_clients++;
+		mutex_unlock(&kcopyd_init_lock);
+		return 0;
+	}
+
+	r = jobs_init();
+	if (r) {
+		mutex_unlock(&kcopyd_init_lock);
+		return r;
+	}
+
+	_kcopyd_wq = create_singlethread_workqueue("kcopyd");
+	if (!_kcopyd_wq) {
+		jobs_exit();
+		mutex_unlock(&kcopyd_init_lock);
+		return -ENOMEM;
+	}
+
+	kcopyd_clients++;
+	INIT_WORK(&_kcopyd_work, do_work);
+	mutex_unlock(&kcopyd_init_lock);
+	return 0;
+}
+
+static void kcopyd_exit(void)
+{
+	mutex_lock(&kcopyd_init_lock);
+	kcopyd_clients--;
+	if (!kcopyd_clients) {
+		jobs_exit();
+		destroy_workqueue(_kcopyd_wq);
+		_kcopyd_wq = NULL;
+	}
+	mutex_unlock(&kcopyd_init_lock);
+}
+
+int dm_kcopyd_client_create(unsigned int nr_pages,
+			    struct dm_kcopyd_client **result)
+{
+	int r = 0;
+	struct dm_kcopyd_client *kc;
+
+	r = kcopyd_init();
+	if (r)
+		return r;
+
+	kc = kmalloc(sizeof(*kc), GFP_KERNEL);
+	if (!kc) {
+		kcopyd_exit();
+		return -ENOMEM;
+	}
+
+	spin_lock_init(&kc->lock);
+	kc->pages = NULL;
+	kc->nr_pages = kc->nr_free_pages = 0;
+	r = client_alloc_pages(kc, nr_pages);
+	if (r) {
+		kfree(kc);
+		kcopyd_exit();
+		return r;
+	}
+
+	kc->io_client = dm_io_client_create(nr_pages);
+	if (IS_ERR(kc->io_client)) {
+		r = PTR_ERR(kc->io_client);
+		client_free_pages(kc);
+		kfree(kc);
+		kcopyd_exit();
+		return r;
+	}
+
+	init_waitqueue_head(&kc->destroyq);
+	atomic_set(&kc->nr_jobs, 0);
+
+	client_add(kc);
+	*result = kc;
+	return 0;
+}
+
+void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc)
+{
+	/* Wait for completion of all jobs submitted by this client. */
+	wait_event(kc->destroyq, !atomic_read(&kc->nr_jobs));
+
+	dm_io_client_destroy(kc->io_client);
+	client_free_pages(kc);
+	client_del(kc);
+	kfree(kc);
+	kcopyd_exit();
+}
+
+EXPORT_SYMBOL(dm_kcopyd_client_create);
+EXPORT_SYMBOL(dm_kcopyd_client_destroy);
+EXPORT_SYMBOL(dm_kcopyd_copy);
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-log.c linux-2.6.25-rc4/drivers/md/dm-log.c
index 975cf15..f52b840 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-log.c
+++ linux-2.6.25-rc4/drivers/md/dm-log.c
@@ -5,14 +5,15 @@
  * This file is released under the LGPL.
  */
 
+#include "dm.h"
+
+#include <linux/dm-io.h>
+#include <linux/dm-log.h>
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
 
-#include "dm-log.h"
-#include "dm-io.h"
-
 #define DM_MSG_PREFIX "dirty region log"
 
 static LIST_HEAD(_log_types);
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-log.h linux-2.6.25-rc4/drivers/md/dm-log.h
deleted file mode 100644
index 66d44b7..0000000
--- linux-2.6.25-rc4.orig/drivers/md/dm-log.h
+++ /dev/null
@@ -1,136 +0,0 @@
-/*
- * Copyright (C) 2003 Sistina Software
- * Copyright (C) 2004-2008 Red Hat GmbH
- *
- * Device-Mapper dirty region log.
- *
- * This file is released under the LGPL.
- */
-
-#ifndef DM_DIRTY_LOG
-#define DM_DIRTY_LOG
-
-#include "dm.h"
-
-typedef sector_t region_t;
-
-struct dm_dirty_log_type;
-
-struct dm_dirty_log {
-	struct dm_dirty_log_type *type;
-	void *context;
-};
-
-struct dm_dirty_log_type {
-	struct list_head list;
-	const char *name;
-	struct module *module;
-	unsigned int use_count;
-
-	int (*ctr)(struct dm_dirty_log *log, struct dm_target *ti,
-		   unsigned int argc, char **argv);
-	void (*dtr)(struct dm_dirty_log *log);
-
-	/*
-	 * There are times when we don't want the log to touch
-	 * the disk.
-	 */
-	int (*presuspend)(struct dm_dirty_log *log);
-	int (*postsuspend)(struct dm_dirty_log *log);
-	int (*resume)(struct dm_dirty_log *log);
-
-	/*
-	 * Retrieves the smallest size of region that the log can
-	 * deal with.
-	 */
-	uint32_t (*get_region_size)(struct dm_dirty_log *log);
-
-        /*
-	 * A predicate to say whether a region is clean or not.
-	 * May block.
-	 */
-	int (*is_clean)(struct dm_dirty_log *log, region_t region);
-
-	/*
-	 *  Returns: 0, 1, -EWOULDBLOCK, < 0
-	 *
-	 * A predicate function to check the area given by
-	 * [sector, sector + len) is in sync.
-	 *
-	 * If -EWOULDBLOCK is returned the state of the region is
-	 * unknown, typically this will result in a read being
-	 * passed to a daemon to deal with, since a daemon is
-	 * allowed to block.
-	 */
-	int (*in_sync)(struct dm_dirty_log *log, region_t region,
-		       int can_block);
-
-	/*
-	 * Flush the current log state (eg, to disk).  This
-	 * function may block.
-	 */
-	int (*flush)(struct dm_dirty_log *log);
-
-	/*
-	 * Mark an area as clean or dirty.  These functions may
-	 * block, though for performance reasons blocking should
-	 * be extremely rare (eg, allocating another chunk of
-	 * memory for some reason).
-	 */
-	void (*mark_region)(struct dm_dirty_log *log, region_t region);
-	void (*clear_region)(struct dm_dirty_log *log, region_t region);
-
-	/*
-	 * Returns: <0 (error), 0 (no region), 1 (region)
-	 *
-	 * The mirrord will need perform recovery on regions of
-	 * the mirror that are in the NOSYNC state.  This
-	 * function asks the log to tell the caller about the
-	 * next region that this machine should recover.
-	 *
-	 * Do not confuse this function with 'in_sync()', one
-	 * tells you if an area is synchronised, the other
-	 * assigns recovery work.
-	*/
-	int (*get_resync_work)(struct dm_dirty_log *log, region_t *region);
-
-	/*
-	 * This notifies the log that the resync status of a region
-	 * has changed.  It also clears the region from the recovering
-	 * list (if present).
-	 */
-	void (*set_region_sync)(struct dm_dirty_log *log,
-				region_t region, int in_sync);
-
-        /*
-	 * Returns the number of regions that are in sync.
-         */
-        region_t (*get_sync_count)(struct dm_dirty_log *log);
-
-	/*
-	 * Support function for mirror status requests.
-	 */
-	int (*status)(struct dm_dirty_log *log, status_type_t status_type,
-		      char *result, unsigned int maxlen);
-};
-
-int dm_dirty_log_type_register(struct dm_dirty_log_type *type);
-int dm_dirty_log_type_unregister(struct dm_dirty_log_type *type);
-
-
-/*
- * Make sure you use these two functions, rather than calling
- * type->constructor/destructor() directly.
- */
-struct dm_dirty_log *dm_dirty_log_create(const char *type_name,
-					 struct dm_target *ti,
-					 unsigned int argc, char **argv);
-void dm_dirty_log_destroy(struct dm_dirty_log *log);
-
-/*
- * init/exit functions.
- */
-int dm_dirty_log_init(void);
-void dm_dirty_log_exit(void);
-
-#endif
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c linux-2.6.25-rc4/drivers/md/dm-raid1.c
index 19608cd..aec42ea 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-raid1.c
+++ linux-2.6.25-rc4/drivers/md/dm-raid1.c
@@ -7,10 +7,10 @@
 #include "dm.h"
 #include "dm-bio-list.h"
 #include "dm-bio-record.h"
-#include "dm-io.h"
-#include "dm-log.h"
-#include "kcopyd.h"
 
+#include <linux/dm-io.h>
+#include <linux/dm-log.h>
+#include <linux/dm-kcopyd.h>
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/mempool.h>
diff --git linux-2.6.25-rc4.orig/drivers/md/dm-snap.c linux-2.6.25-rc4/drivers/md/dm-snap.c
index 3bd62db..c9c0c41 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-snap.c
+++ linux-2.6.25-rc4/drivers/md/dm-snap.c
@@ -18,10 +18,10 @@
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/log2.h>
+#include <linux/dm-kcopyd.h>
 
 #include "dm-snap.h"
 #include "dm-bio-list.h"
-#include "kcopyd.h"
 
 #define DM_MSG_PREFIX "snapshots"
 
diff --git linux-2.6.25-rc4.orig/drivers/md/kcopyd.c linux-2.6.25-rc4/drivers/md/kcopyd.c
deleted file mode 100644
index aa1fbda..0000000
--- linux-2.6.25-rc4.orig/drivers/md/kcopyd.c
+++ /dev/null
@@ -1,709 +0,0 @@
-/*
- * Copyright (C) 2002 Sistina Software (UK) Limited.
- * Copyright (C) 2006 Red Hat GmbH
- *
- * This file is released under the GPL.
- *
- * Kcopyd provides a simple interface for copying an area of one
- * block-device to one or more other block-devices, with an asynchronous
- * completion notification.
- */
-
-#include <asm/types.h>
-#include <asm/atomic.h>
-
-#include <linux/blkdev.h>
-#include <linux/fs.h>
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/mempool.h>
-#include <linux/module.h>
-#include <linux/pagemap.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/workqueue.h>
-#include <linux/mutex.h>
-
-#include "kcopyd.h"
-
-static struct workqueue_struct *_kcopyd_wq;
-static struct work_struct _kcopyd_work;
-
-static void wake(void)
-{
-	queue_work(_kcopyd_wq, &_kcopyd_work);
-}
-
-/*-----------------------------------------------------------------
- * Each kcopyd client has its own little pool of preallocated
- * pages for kcopyd io.
- *---------------------------------------------------------------*/
-struct dm_kcopyd_client {
-	struct list_head list;
-
-	spinlock_t lock;
-	struct page_list *pages;
-	unsigned int nr_pages;
-	unsigned int nr_free_pages;
-
-	struct dm_io_client *io_client;
-
-	wait_queue_head_t destroyq;
-	atomic_t nr_jobs;
-};
-
-static struct page_list *alloc_pl(void)
-{
-	struct page_list *pl;
-
-	pl = kmalloc(sizeof(*pl), GFP_KERNEL);
-	if (!pl)
-		return NULL;
-
-	pl->page = alloc_page(GFP_KERNEL);
-	if (!pl->page) {
-		kfree(pl);
-		return NULL;
-	}
-
-	return pl;
-}
-
-static void free_pl(struct page_list *pl)
-{
-	__free_page(pl->page);
-	kfree(pl);
-}
-
-static int kcopyd_get_pages(struct dm_kcopyd_client *kc,
-			    unsigned int nr, struct page_list **pages)
-{
-	struct page_list *pl;
-
-	spin_lock(&kc->lock);
-	if (kc->nr_free_pages < nr) {
-		spin_unlock(&kc->lock);
-		return -ENOMEM;
-	}
-
-	kc->nr_free_pages -= nr;
-	for (*pages = pl = kc->pages; --nr; pl = pl->next)
-		;
-
-	kc->pages = pl->next;
-	pl->next = NULL;
-
-	spin_unlock(&kc->lock);
-
-	return 0;
-}
-
-static void kcopyd_put_pages(struct dm_kcopyd_client *kc, struct page_list *pl)
-{
-	struct page_list *cursor;
-
-	spin_lock(&kc->lock);
-	for (cursor = pl; cursor->next; cursor = cursor->next)
-		kc->nr_free_pages++;
-
-	kc->nr_free_pages++;
-	cursor->next = kc->pages;
-	kc->pages = pl;
-	spin_unlock(&kc->lock);
-}
-
-/*
- * These three functions resize the page pool.
- */
-static void drop_pages(struct page_list *pl)
-{
-	struct page_list *next;
-
-	while (pl) {
-		next = pl->next;
-		free_pl(pl);
-		pl = next;
-	}
-}
-
-static int client_alloc_pages(struct dm_kcopyd_client *kc, unsigned int nr)
-{
-	unsigned int i;
-	struct page_list *pl = NULL, *next;
-
-	for (i = 0; i < nr; i++) {
-		next = alloc_pl();
-		if (!next) {
-			if (pl)
-				drop_pages(pl);
-			return -ENOMEM;
-		}
-		next->next = pl;
-		pl = next;
-	}
-
-	kcopyd_put_pages(kc, pl);
-	kc->nr_pages += nr;
-	return 0;
-}
-
-static void client_free_pages(struct dm_kcopyd_client *kc)
-{
-	BUG_ON(kc->nr_free_pages != kc->nr_pages);
-	drop_pages(kc->pages);
-	kc->pages = NULL;
-	kc->nr_free_pages = kc->nr_pages = 0;
-}
-
-/*-----------------------------------------------------------------
- * kcopyd_jobs need to be allocated by the *clients* of kcopyd,
- * for this reason we use a mempool to prevent the client from
- * ever having to do io (which could cause a deadlock).
- *---------------------------------------------------------------*/
-struct kcopyd_job {
-	struct dm_kcopyd_client *kc;
-	struct list_head list;
-	unsigned long flags;
-
-	/*
-	 * Error state of the job.
-	 */
-	int read_err;
-	unsigned int write_err;
-
-	/*
-	 * Either READ or WRITE
-	 */
-	int rw;
-	struct dm_io_region source;
-
-	/*
-	 * The destinations for the transfer.
-	 */
-	unsigned int num_dests;
-	struct dm_io_region dests[DM_KCOPYD_MAX_REGIONS];
-
-	sector_t offset;
-	unsigned int nr_pages;
-	struct page_list *pages;
-
-	/*
-	 * Set this to ensure you are notified when the job has
-	 * completed.  'context' is for callback to use.
-	 */
-	dm_kcopyd_notify_fn fn;
-	void *context;
-
-	/*
-	 * These fields are only used if the job has been split
-	 * into more manageable parts.
-	 */
-	struct mutex lock;
-	atomic_t sub_jobs;
-	sector_t progress;
-};
-
-/* FIXME: this should scale with the number of pages */
-#define MIN_JOBS 512
-
-static struct kmem_cache *_job_cache;
-static mempool_t *_job_pool;
-
-/*
- * We maintain three lists of jobs:
- *
- * i)   jobs waiting for pages
- * ii)  jobs that have pages, and are waiting for the io to be issued.
- * iii) jobs that have completed.
- *
- * All three of these are protected by job_lock.
- */
-static DEFINE_SPINLOCK(_job_lock);
-
-static LIST_HEAD(_complete_jobs);
-static LIST_HEAD(_io_jobs);
-static LIST_HEAD(_pages_jobs);
-
-static int jobs_init(void)
-{
-	_job_cache = KMEM_CACHE(kcopyd_job, 0);
-	if (!_job_cache)
-		return -ENOMEM;
-
-	_job_pool = mempool_create_slab_pool(MIN_JOBS, _job_cache);
-	if (!_job_pool) {
-		kmem_cache_destroy(_job_cache);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void jobs_exit(void)
-{
-	BUG_ON(!list_empty(&_complete_jobs));
-	BUG_ON(!list_empty(&_io_jobs));
-	BUG_ON(!list_empty(&_pages_jobs));
-
-	mempool_destroy(_job_pool);
-	kmem_cache_destroy(_job_cache);
-	_job_pool = NULL;
-	_job_cache = NULL;
-}
-
-/*
- * Functions to push and pop a job onto the head of a given job
- * list.
- */
-static struct kcopyd_job *pop(struct list_head *jobs)
-{
-	struct kcopyd_job *job = NULL;
-	unsigned long flags;
-
-	spin_lock_irqsave(&_job_lock, flags);
-
-	if (!list_empty(jobs)) {
-		job = list_entry(jobs->next, struct kcopyd_job, list);
-		list_del(&job->list);
-	}
-	spin_unlock_irqrestore(&_job_lock, flags);
-
-	return job;
-}
-
-static void push(struct list_head *jobs, struct kcopyd_job *job)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&_job_lock, flags);
-	list_add_tail(&job->list, jobs);
-	spin_unlock_irqrestore(&_job_lock, flags);
-}
-
-/*
- * These three functions process 1 item from the corresponding
- * job list.
- *
- * They return:
- * < 0: error
- *   0: success
- * > 0: can't process yet.
- */
-static int run_complete_job(struct kcopyd_job *job)
-{
-	void *context = job->context;
-	int read_err = job->read_err;
-	unsigned int write_err = job->write_err;
-	dm_kcopyd_notify_fn fn = job->fn;
-	struct dm_kcopyd_client *kc = job->kc;
-
-	kcopyd_put_pages(kc, job->pages);
-	mempool_free(job, _job_pool);
-	fn(read_err, write_err, context);
-
-	if (atomic_dec_and_test(&kc->nr_jobs))
-		wake_up(&kc->destroyq);
-
-	return 0;
-}
-
-static void complete_io(unsigned long error, void *context)
-{
-	struct kcopyd_job *job = (struct kcopyd_job *) context;
-
-	if (error) {
-		if (job->rw == WRITE)
-			job->write_err |= error;
-		else
-			job->read_err = 1;
-
-		if (!test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
-			push(&_complete_jobs, job);
-			wake();
-			return;
-		}
-	}
-
-	if (job->rw == WRITE)
-		push(&_complete_jobs, job);
-
-	else {
-		job->rw = WRITE;
-		push(&_io_jobs, job);
-	}
-
-	wake();
-}
-
-/*
- * Request io on as many buffer heads as we can currently get for
- * a particular job.
- */
-static int run_io_job(struct kcopyd_job *job)
-{
-	int r;
-	struct dm_io_request io_req = {
-		.bi_rw = job->rw,
-		.mem.type = DM_IO_PAGE_LIST,
-		.mem.ptr.pl = job->pages,
-		.mem.offset = job->offset,
-		.notify.fn = complete_io,
-		.notify.context = job,
-		.client = job->kc->io_client,
-	};
-
-	if (job->rw == READ)
-		r = dm_io(&io_req, 1, &job->source, NULL);
-	else
-		r = dm_io(&io_req, job->num_dests, job->dests, NULL);
-
-	return r;
-}
-
-static int run_pages_job(struct kcopyd_job *job)
-{
-	int r;
-
-	job->nr_pages = dm_div_up(job->dests[0].count + job->offset,
-				  PAGE_SIZE >> 9);
-	r = kcopyd_get_pages(job->kc, job->nr_pages, &job->pages);
-	if (!r) {
-		/* this job is ready for io */
-		push(&_io_jobs, job);
-		return 0;
-	}
-
-	if (r == -ENOMEM)
-		/* can't complete now */
-		return 1;
-
-	return r;
-}
-
-/*
- * Run through a list for as long as possible.  Returns the count
- * of successful jobs.
- */
-static int process_jobs(struct list_head *jobs, int (*fn) (struct kcopyd_job *))
-{
-	struct kcopyd_job *job;
-	int r, count = 0;
-
-	while ((job = pop(jobs))) {
-
-		r = fn(job);
-
-		if (r < 0) {
-			/* error this rogue job */
-			if (job->rw == WRITE)
-				job->write_err = (unsigned int) -1;
-			else
-				job->read_err = 1;
-			push(&_complete_jobs, job);
-			break;
-		}
-
-		if (r > 0) {
-			/*
-			 * We couldn't service this job ATM, so
-			 * push this job back onto the list.
-			 */
-			push(jobs, job);
-			break;
-		}
-
-		count++;
-	}
-
-	return count;
-}
-
-/*
- * kcopyd does this every time it's woken up.
- */
-static void do_work(struct work_struct *ignored)
-{
-	/*
-	 * The order that these are called is *very* important.
-	 * complete jobs can free some pages for pages jobs.
-	 * Pages jobs when successful will jump onto the io jobs
-	 * list.  io jobs call wake when they complete and it all
-	 * starts again.
-	 */
-	process_jobs(&_complete_jobs, run_complete_job);
-	process_jobs(&_pages_jobs, run_pages_job);
-	process_jobs(&_io_jobs, run_io_job);
-}
-
-/*
- * If we are copying a small region we just dispatch a single job
- * to do the copy, otherwise the io has to be split up into many
- * jobs.
- */
-static void dispatch_job(struct kcopyd_job *job)
-{
-	atomic_inc(&job->kc->nr_jobs);
-	push(&_pages_jobs, job);
-	wake();
-}
-
-#define SUB_JOB_SIZE 128
-static void segment_complete(int read_err,
-			     unsigned int write_err, void *context)
-{
-	/* FIXME: tidy this function */
-	sector_t progress = 0;
-	sector_t count = 0;
-	struct kcopyd_job *job = (struct kcopyd_job *) context;
-
-	mutex_lock(&job->lock);
-
-	/* update the error */
-	if (read_err)
-		job->read_err = 1;
-
-	if (write_err)
-		job->write_err |= write_err;
-
-	/*
-	 * Only dispatch more work if there hasn't been an error.
-	 */
-	if ((!job->read_err && !job->write_err) ||
-	    test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
-		/* get the next chunk of work */
-		progress = job->progress;
-		count = job->source.count - progress;
-		if (count) {
-			if (count > SUB_JOB_SIZE)
-				count = SUB_JOB_SIZE;
-
-			job->progress += count;
-		}
-	}
-	mutex_unlock(&job->lock);
-
-	if (count) {
-		int i;
-		struct kcopyd_job *sub_job = mempool_alloc(_job_pool, GFP_NOIO);
-
-		*sub_job = *job;
-		sub_job->source.sector += progress;
-		sub_job->source.count = count;
-
-		for (i = 0; i < job->num_dests; i++) {
-			sub_job->dests[i].sector += progress;
-			sub_job->dests[i].count = count;
-		}
-
-		sub_job->fn = segment_complete;
-		sub_job->context = job;
-		dispatch_job(sub_job);
-
-	} else if (atomic_dec_and_test(&job->sub_jobs)) {
-
-		/*
-		 * To avoid a race we must keep the job around
-		 * until after the notify function has completed.
-		 * Otherwise the client may try and stop the job
-		 * after we've completed.
-		 */
-		job->fn(read_err, write_err, job->context);
-		mempool_free(job, _job_pool);
-	}
-}
-
-/*
- * Create some little jobs that will do the move between
- * them.
- */
-#define SPLIT_COUNT 8
-static void split_job(struct kcopyd_job *job)
-{
-	int i;
-
-	atomic_set(&job->sub_jobs, SPLIT_COUNT);
-	for (i = 0; i < SPLIT_COUNT; i++)
-		segment_complete(0, 0u, job);
-}
-
-int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
-		   unsigned int num_dests, struct dm_io_region *dests,
-		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context)
-{
-	struct kcopyd_job *job;
-
-	/*
-	 * Allocate a new job.
-	 */
-	job = mempool_alloc(_job_pool, GFP_NOIO);
-
-	/*
-	 * set up for the read.
-	 */
-	job->kc = kc;
-	job->flags = flags;
-	job->read_err = 0;
-	job->write_err = 0;
-	job->rw = READ;
-
-	job->source = *from;
-
-	job->num_dests = num_dests;
-	memcpy(&job->dests, dests, sizeof(*dests) * num_dests);
-
-	job->offset = 0;
-	job->nr_pages = 0;
-	job->pages = NULL;
-
-	job->fn = fn;
-	job->context = context;
-
-	if (job->source.count < SUB_JOB_SIZE)
-		dispatch_job(job);
-
-	else {
-		mutex_init(&job->lock);
-		job->progress = 0;
-		split_job(job);
-	}
-
-	return 0;
-}
-
-/*
- * Cancels a kcopyd job, eg. someone might be deactivating a
- * mirror.
- */
-#if 0
-int kcopyd_cancel(struct kcopyd_job *job, int block)
-{
-	/* FIXME: finish */
-	return -1;
-}
-#endif  /*  0  */
-
-/*-----------------------------------------------------------------
- * Unit setup
- *---------------------------------------------------------------*/
-static DEFINE_MUTEX(_client_lock);
-static LIST_HEAD(_clients);
-
-static void client_add(struct dm_kcopyd_client *kc)
-{
-	mutex_lock(&_client_lock);
-	list_add(&kc->list, &_clients);
-	mutex_unlock(&_client_lock);
-}
-
-static void client_del(struct dm_kcopyd_client *kc)
-{
-	mutex_lock(&_client_lock);
-	list_del(&kc->list);
-	mutex_unlock(&_client_lock);
-}
-
-static DEFINE_MUTEX(kcopyd_init_lock);
-static int kcopyd_clients = 0;
-
-static int kcopyd_init(void)
-{
-	int r;
-
-	mutex_lock(&kcopyd_init_lock);
-
-	if (kcopyd_clients) {
-		/* Already initialized. */
-		kcopyd_clients++;
-		mutex_unlock(&kcopyd_init_lock);
-		return 0;
-	}
-
-	r = jobs_init();
-	if (r) {
-		mutex_unlock(&kcopyd_init_lock);
-		return r;
-	}
-
-	_kcopyd_wq = create_singlethread_workqueue("kcopyd");
-	if (!_kcopyd_wq) {
-		jobs_exit();
-		mutex_unlock(&kcopyd_init_lock);
-		return -ENOMEM;
-	}
-
-	kcopyd_clients++;
-	INIT_WORK(&_kcopyd_work, do_work);
-	mutex_unlock(&kcopyd_init_lock);
-	return 0;
-}
-
-static void kcopyd_exit(void)
-{
-	mutex_lock(&kcopyd_init_lock);
-	kcopyd_clients--;
-	if (!kcopyd_clients) {
-		jobs_exit();
-		destroy_workqueue(_kcopyd_wq);
-		_kcopyd_wq = NULL;
-	}
-	mutex_unlock(&kcopyd_init_lock);
-}
-
-int dm_kcopyd_client_create(unsigned int nr_pages,
-			    struct dm_kcopyd_client **result)
-{
-	int r = 0;
-	struct dm_kcopyd_client *kc;
-
-	r = kcopyd_init();
-	if (r)
-		return r;
-
-	kc = kmalloc(sizeof(*kc), GFP_KERNEL);
-	if (!kc) {
-		kcopyd_exit();
-		return -ENOMEM;
-	}
-
-	spin_lock_init(&kc->lock);
-	kc->pages = NULL;
-	kc->nr_pages = kc->nr_free_pages = 0;
-	r = client_alloc_pages(kc, nr_pages);
-	if (r) {
-		kfree(kc);
-		kcopyd_exit();
-		return r;
-	}
-
-	kc->io_client = dm_io_client_create(nr_pages);
-	if (IS_ERR(kc->io_client)) {
-		r = PTR_ERR(kc->io_client);
-		client_free_pages(kc);
-		kfree(kc);
-		kcopyd_exit();
-		return r;
-	}
-
-	init_waitqueue_head(&kc->destroyq);
-	atomic_set(&kc->nr_jobs, 0);
-
-	client_add(kc);
-	*result = kc;
-	return 0;
-}
-
-void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc)
-{
-	/* Wait for completion of all jobs submitted by this client. */
-	wait_event(kc->destroyq, !atomic_read(&kc->nr_jobs));
-
-	dm_io_client_destroy(kc->io_client);
-	client_free_pages(kc);
-	client_del(kc);
-	kfree(kc);
-	kcopyd_exit();
-}
-
-EXPORT_SYMBOL(dm_kcopyd_client_create);
-EXPORT_SYMBOL(dm_kcopyd_client_destroy);
-EXPORT_SYMBOL(dm_kcopyd_copy);
diff --git linux-2.6.25-rc4.orig/drivers/md/kcopyd.h linux-2.6.25-rc4/drivers/md/kcopyd.h
deleted file mode 100644
index eb998c0..0000000
--- linux-2.6.25-rc4.orig/drivers/md/kcopyd.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/*
- * Copyright (C) 2001-2003 Sistina Software
- * Copyright (C) 2004-2008 Red Hat GmbH
- *
- * dm-kcopyd provides a simple interface for copying an area of one
- * block-device to one or more other block-devices, either synchronous
- * or with an asynchronous completion notification.
- *
- * This file is released under the GPL.
- *
- */
-
-#ifndef DM_KCOPYD_H
-#define DM_KCOPYD_H
-
-#include "dm-io.h"
-
-/* FIXME: make this configurable */
-#define DM_KCOPYD_MAX_REGIONS 8
-
-#define DM_KCOPYD_IGNORE_ERROR 1
-
-/*
- * To use dm-kcopyd you must first create a kcopyd client object.
- */
-struct dm_kcopyd_client;
-int dm_kcopyd_client_create(unsigned int num_pages,
-			    struct dm_kcopyd_client **result);
-void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc);
-
-/*
- * Submit a copy job to dm-kcopyd.  This is built on top of the
- * previous three fns.
- *
- * read_err is a boolean,
- * write_err is a bitset, with 1 bit for each destination region.
- */
-typedef void (*dm_kcopyd_notify_fn)(int read_err,
-				    unsigned int write_err, void *context);
-
-int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
-		   unsigned int num_dests, struct dm_io_region *dests,
-		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context);
-
-#endif
-- 
1.5.4.1
