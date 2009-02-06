From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: Re: 2.6.28.2 & dm-snapshot or kcopyd Oops
Date: Thu, 5 Feb 2009 22:26:33 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902052218040.5380@hs20-bc2-1.build.redhat.com>
References: <200901231836184950432@163.com>,
	<Pine.LNX.4.64.0901231514590.9877@hs20-bc2-1.build.redhat.com>,
	<200901301800149019891@163.com>,
	<Pine.LNX.4.64.0901301533390.5744@hs20-bc2-1.build.redhat.com>,
	<200901311416111648168@163.com>,
	<Pine.LNX.4.64.0902031505180.28433@hs20-bc2-1.build.redhat.com>
	<200902051113011850587@163.com>
	<Pine.LNX.4.64.0902051749150.5515@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0902051749150.5515@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>, Jacky Kim <jcy_2008@163.com>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

> +		push(&job->kc->complete_jobs, job);
> +		wake(job->kc);

I still found one bug with my patch. When I push the job to complete_jobs 
queue, it may be immediatelly taken and cease to exist. So job->kc 
dereference is wrong.

A new patch:



Under specific circumstances, kcopyd callback could be called from
the thread that called dm_kcopyd_copy not from kcopyd workqueue.

dm_kcopyd_copy -> split_job -> segment_complete -> job->fn()

This code path is taken if thread calling dm_kcopyd_copy is delayed due to
scheduling inside split_job/segment_complete and the subjobs complete before
the loop in split_job completes.

Snapshots depend on the fact that callbacks are called from the singlethreaded
kcopyd workqueue and expect that there is no racing between individual
callbacks. The racing between callbacks can lead to corruption of exception
store and it can also cause that exception store callbacks are called twice
for the same exception --- a likely reason for crashes inside
pending_complete() / remove_exception().


When I reviewed kcopyd further, I found four total problems:

1. job->fn being called from the thread that submitted the job (see above).

2. job->fn(read_err, write_err, job->context); in segment_complete
reports the error of the last subjob, not the union of all errors.

3. This comment is bogus (the jobs are not cancelable), plus the code
is prone to deadlock because the callback may allocate another job from
the same mempool.
/*
 * To avoid a race we must keep the job around
 * until after the notify function has completed.
 * Otherwise the client may try and stop the job
 * after we've completed.
 */
job->fn(read_err, write_err, job->context);
mempool_free(job, job->kc->job_pool);

4. Master jobs and subjobs are allocated from the same mempool.
Completion and freeing of a master job depends on successful allocation of
all subjobs -> deadlock.


This patch moves completion of master jobs to run_complete_job (being called
from the kcopyd workqueue). The patch fixes problems 1, 2, 3.

Problem 4 will need more changes and another patch.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

Index: linux-2.6.29-rc3-devel/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.29-rc3-devel.orig/drivers/md/dm-kcopyd.c	2009-02-05 23:01:50.000000000 +0100
+++ linux-2.6.29-rc3-devel/drivers/md/dm-kcopyd.c	2009-02-06 04:15:52.000000000 +0100
@@ -297,7 +297,8 @@ static int run_complete_job(struct kcopy
 	dm_kcopyd_notify_fn fn = job->fn;
 	struct dm_kcopyd_client *kc = job->kc;
 
-	kcopyd_put_pages(kc, job->pages);
+	if (job->pages)
+		kcopyd_put_pages(kc, job->pages);
 	mempool_free(job, kc->job_pool);
 	fn(read_err, write_err, context);
 
@@ -461,6 +462,7 @@ static void segment_complete(int read_er
 	sector_t progress = 0;
 	sector_t count = 0;
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
+	struct dm_kcopyd_client *kc = job->kc;
 
 	mutex_lock(&job->lock);
 
@@ -490,7 +492,7 @@ static void segment_complete(int read_er
 
 	if (count) {
 		int i;
-		struct kcopyd_job *sub_job = mempool_alloc(job->kc->job_pool,
+		struct kcopyd_job *sub_job = mempool_alloc(kc->job_pool,
 							   GFP_NOIO);
 
 		*sub_job = *job;
@@ -508,14 +510,8 @@ static void segment_complete(int read_er
 
 	} else if (atomic_dec_and_test(&job->sub_jobs)) {
 
-		/*
-		 * To avoid a race we must keep the job around
-		 * until after the notify function has completed.
-		 * Otherwise the client may try and stop the job
-		 * after we've completed.
-		 */
-		job->fn(read_err, write_err, job->context);
-		mempool_free(job, job->kc->job_pool);
+		push(&kc->complete_jobs, job);
+		wake(kc);
 	}
 }
 
@@ -528,6 +524,8 @@ static void split_job(struct kcopyd_job 
 {
 	int i;
 
+	atomic_inc(&job->kc->nr_jobs);
+
 	atomic_set(&job->sub_jobs, SPLIT_COUNT);
 	for (i = 0; i < SPLIT_COUNT; i++)
 		segment_complete(0, 0u, job);
