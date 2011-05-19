From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Fix a possible dm-kcopyd deadlock - preallocate
	sub jobs
Date: Thu, 19 May 2011 12:55:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105191250440.17915@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Hi

Here I'm sending some patches for kcopyd. This first one fixes a 
treoretical deadlock, the other patches are a code cleanup (removing some 
"magic" numbers in mempool resrvations).

Later, I will follow with patches that rework page reservations.

Mikulas

---

Fix a possible dm-kcopyd deadlock - preallocate sub jobs

There's a possible theoretical deadlock in dm-kcopyd because multiple
allocations from the same mempool are required to finish a request.

There is a mempool of 512 entries. Each request requires up to 9
entries from the mempool. If we have at least 57 concurrent requests
running, the mempool may overflow and mempool allocations may start
blocking until another entry is freed to the mempool. Because the same
thread is used to free entries to the mempool and allocate entries from
the mempool, this may result in a deadlock.

This patch changes it so that one mempool entry contains all 9 "struct
kcopyd_job" required to fulfill the whole request. The allocation is
done only once in dm_kcopyd_copy and no further mempool allocations are
done during request processing.

If dm_kcopyd_copy is not run in the completion thread, this
implementation is deadlock-free.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

Index: linux-2.6.39-rc7-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-rc7-fast.orig/drivers/md/dm-kcopyd.c	2011-05-18 18:03:13.000000000 +0200
+++ linux-2.6.39-rc7-fast/drivers/md/dm-kcopyd.c	2011-05-18 18:03:31.000000000 +0200
@@ -27,6 +27,9 @@
 
 #include "dm.h"
 
+#define SUB_JOB_SIZE	128
+#define SPLIT_COUNT	8
+
 /*-----------------------------------------------------------------
  * Each kcopyd client has its own little pool of preallocated
  * pages for kcopyd io.
@@ -216,6 +219,8 @@ struct kcopyd_job {
 	struct mutex lock;
 	atomic_t sub_jobs;
 	sector_t progress;
+
+	struct kcopyd_job *master_job;
 };
 
 /* FIXME: this should scale with the number of pages */
@@ -225,7 +230,9 @@ static struct kmem_cache *_job_cache;
 
 int __init dm_kcopyd_init(void)
 {
-	_job_cache = KMEM_CACHE(kcopyd_job, 0);
+	_job_cache = kmem_cache_create("kcopyd_job",
+				sizeof(struct kcopyd_job) * (SPLIT_COUNT + 1),
+				__alignof__(struct kcopyd_job), 0, NULL);
 	if (!_job_cache)
 		return -ENOMEM;
 
@@ -299,7 +306,9 @@ static int run_complete_job(struct kcopy
 
 	if (job->pages)
 		kcopyd_put_pages(kc, job->pages);
-	mempool_free(job, kc->job_pool);
+	/* Do not free sub-jobs */
+	if (context != job)
+		mempool_free(job, kc->job_pool);
 	fn(read_err, write_err, context);
 
 	if (atomic_dec_and_test(&kc->nr_jobs))
@@ -460,14 +469,14 @@ static void dispatch_job(struct kcopyd_j
 	wake(kc);
 }
 
-#define SUB_JOB_SIZE 128
 static void segment_complete(int read_err, unsigned long write_err,
 			     void *context)
 {
 	/* FIXME: tidy this function */
 	sector_t progress = 0;
 	sector_t count = 0;
-	struct kcopyd_job *job = (struct kcopyd_job *) context;
+	struct kcopyd_job *sub_job = (struct kcopyd_job *) context;
+	struct kcopyd_job *job = sub_job->master_job;
 	struct dm_kcopyd_client *kc = job->kc;
 
 	mutex_lock(&job->lock);
@@ -498,10 +507,9 @@ static void segment_complete(int read_er
 
 	if (count) {
 		int i;
-		struct kcopyd_job *sub_job = mempool_alloc(kc->job_pool,
-							   GFP_NOIO);
 
 		*sub_job = *job;
+		sub_job->master_job = job;
 		sub_job->source.sector += progress;
 		sub_job->source.count = count;
 
@@ -511,7 +519,7 @@ static void segment_complete(int read_er
 		}
 
 		sub_job->fn = segment_complete;
-		sub_job->context = job;
+		sub_job->context = sub_job;
 		dispatch_job(sub_job);
 
 	} else if (atomic_dec_and_test(&job->sub_jobs)) {
@@ -534,7 +542,6 @@ static void segment_complete(int read_er
  * Create some little jobs that will do the move between
  * them.
  */
-#define SPLIT_COUNT 8
 static void split_job(struct kcopyd_job *job)
 {
 	int i;
@@ -542,8 +549,10 @@ static void split_job(struct kcopyd_job 
 	atomic_inc(&job->kc->nr_jobs);
 
 	atomic_set(&job->sub_jobs, SPLIT_COUNT);
-	for (i = 0; i < SPLIT_COUNT; i++)
-		segment_complete(0, 0u, job);
+	for (i = 0; i < SPLIT_COUNT; i++) {
+		job[i + 1].master_job = job;
+		segment_complete(0, 0u, &job[i + 1]);
+	}
 }
 
 int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
