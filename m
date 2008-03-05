From: Heinz Mauelshagen <hjm@redhat.com>
Subject: [RFC PATCH 06/13] dm headers: adjust dm-kcopyd
	identifiers to have "dm_" prefix
Date: Wed,  5 Mar 2008 19:55:57 +0100
Message-ID: <1204743364-3248-7-git-send-email-hjm@redhat.com>
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


Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
---
 drivers/md/dm-kcopyd.c |   54 ++++++++++++++++++++++++-----------------------
 1 files changed, 28 insertions(+), 26 deletions(-)

diff --git linux-2.6.25-rc4.orig/drivers/md/dm-kcopyd.c linux-2.6.25-rc4/drivers/md/dm-kcopyd.c
index f3831f3..f181f28 100644
--- linux-2.6.25-rc4.orig/drivers/md/dm-kcopyd.c
+++ linux-2.6.25-rc4/drivers/md/dm-kcopyd.c
@@ -9,6 +9,8 @@
  * completion notification.
  */
 
+#include "dm.h"
+
 #include <asm/types.h>
 #include <asm/atomic.h>
 
@@ -23,8 +25,7 @@
 #include <linux/vmalloc.h>
 #include <linux/workqueue.h>
 #include <linux/mutex.h>
-
-#include "kcopyd.h"
+#include <linux/dm-kcopyd.h>
 
 static struct workqueue_struct *_kcopyd_wq;
 static struct work_struct _kcopyd_work;
@@ -38,7 +39,7 @@ static void wake(void)
  * Each kcopyd client has its own little pool of preallocated
  * pages for kcopyd io.
  *---------------------------------------------------------------*/
-struct kcopyd_client {
+struct dm_kcopyd_client {
 	struct list_head list;
 
 	spinlock_t lock;
@@ -75,7 +76,7 @@ static void free_pl(struct page_list *pl)
 	kfree(pl);
 }
 
-static int kcopyd_get_pages(struct kcopyd_client *kc,
+static int kcopyd_get_pages(struct dm_kcopyd_client *kc,
 			    unsigned int nr, struct page_list **pages)
 {
 	struct page_list *pl;
@@ -98,7 +99,7 @@ static int kcopyd_get_pages(struct kcopyd_client *kc,
 	return 0;
 }
 
-static void kcopyd_put_pages(struct kcopyd_client *kc, struct page_list *pl)
+static void kcopyd_put_pages(struct dm_kcopyd_client *kc, struct page_list *pl)
 {
 	struct page_list *cursor;
 
@@ -126,7 +127,7 @@ static void drop_pages(struct page_list *pl)
 	}
 }
 
-static int client_alloc_pages(struct kcopyd_client *kc, unsigned int nr)
+static int client_alloc_pages(struct dm_kcopyd_client *kc, unsigned int nr)
 {
 	unsigned int i;
 	struct page_list *pl = NULL, *next;
@@ -147,7 +148,7 @@ static int client_alloc_pages(struct kcopyd_client *kc, unsigned int nr)
 	return 0;
 }
 
-static void client_free_pages(struct kcopyd_client *kc)
+static void client_free_pages(struct dm_kcopyd_client *kc)
 {
 	BUG_ON(kc->nr_free_pages != kc->nr_pages);
 	drop_pages(kc->pages);
@@ -161,7 +162,7 @@ static void client_free_pages(struct kcopyd_client *kc)
  * ever having to do io (which could cause a deadlock).
  *---------------------------------------------------------------*/
 struct kcopyd_job {
-	struct kcopyd_client *kc;
+	struct dm_kcopyd_client *kc;
 	struct list_head list;
 	unsigned long flags;
 
@@ -175,13 +176,13 @@ struct kcopyd_job {
 	 * Either READ or WRITE
 	 */
 	int rw;
-	struct io_region source;
+	struct dm_io_region source;
 
 	/*
 	 * The destinations for the transfer.
 	 */
 	unsigned int num_dests;
-	struct io_region dests[KCOPYD_MAX_REGIONS];
+	struct dm_io_region dests[DM_KCOPYD_MAX_REGIONS];
 
 	sector_t offset;
 	unsigned int nr_pages;
@@ -191,7 +192,7 @@ struct kcopyd_job {
 	 * Set this to ensure you are notified when the job has
 	 * completed.  'context' is for callback to use.
 	 */
-	kcopyd_notify_fn fn;
+	dm_kcopyd_notify_fn fn;
 	void *context;
 
 	/*
@@ -294,8 +295,8 @@ static int run_complete_job(struct kcopyd_job *job)
 	void *context = job->context;
 	int read_err = job->read_err;
 	unsigned int write_err = job->write_err;
-	kcopyd_notify_fn fn = job->fn;
-	struct kcopyd_client *kc = job->kc;
+	dm_kcopyd_notify_fn fn = job->fn;
+	struct dm_kcopyd_client *kc = job->kc;
 
 	kcopyd_put_pages(kc, job->pages);
 	mempool_free(job, _job_pool);
@@ -317,7 +318,7 @@ static void complete_io(unsigned long error, void *context)
 		else
 			job->read_err = 1;
 
-		if (!test_bit(KCOPYD_IGNORE_ERROR, &job->flags)) {
+		if (!test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
 			push(&_complete_jobs, job);
 			wake();
 			return;
@@ -469,7 +470,7 @@ static void segment_complete(int read_err,
 	 * Only dispatch more work if there hasn't been an error.
 	 */
 	if ((!job->read_err && !job->write_err) ||
-	    test_bit(KCOPYD_IGNORE_ERROR, &job->flags)) {
+	    test_bit(DM_KCOPYD_IGNORE_ERROR, &job->flags)) {
 		/* get the next chunk of work */
 		progress = job->progress;
 		count = job->source.count - progress;
@@ -526,9 +527,9 @@ static void split_job(struct kcopyd_job *job)
 		segment_complete(0, 0u, job);
 }
 
-int kcopyd_copy(struct kcopyd_client *kc, struct io_region *from,
-		unsigned int num_dests, struct io_region *dests,
-		unsigned int flags, kcopyd_notify_fn fn, void *context)
+int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
+		   unsigned int num_dests, struct dm_io_region *dests,
+		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context)
 {
 	struct kcopyd_job *job;
 
@@ -588,14 +589,14 @@ int kcopyd_cancel(struct kcopyd_job *job, int block)
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
@@ -649,10 +650,11 @@ static void kcopyd_exit(void)
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
@@ -691,7 +693,7 @@ int kcopyd_client_create(unsigned int nr_pages, struct kcopyd_client **result)
 	return 0;
 }
 
-void kcopyd_client_destroy(struct kcopyd_client *kc)
+void dm_kcopyd_client_destroy(struct dm_kcopyd_client *kc)
 {
 	/* Wait for completion of all jobs submitted by this client. */
 	wait_event(kc->destroyq, !atomic_read(&kc->nr_jobs));
@@ -703,6 +705,6 @@ void kcopyd_client_destroy(struct kcopyd_client *kc)
 	kcopyd_exit();
 }
 
-EXPORT_SYMBOL(kcopyd_client_create);
-EXPORT_SYMBOL(kcopyd_client_destroy);
-EXPORT_SYMBOL(kcopyd_copy);
+EXPORT_SYMBOL(dm_kcopyd_client_create);
+EXPORT_SYMBOL(dm_kcopyd_client_destroy);
+EXPORT_SYMBOL(dm_kcopyd_copy);
-- 
1.5.4.1
