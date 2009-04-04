From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/3] kcopyd+snapshots race condition ... updated
Date: Fri, 3 Apr 2009 20:57:58 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904032057200.18977@hs20-bc2-1.build.redhat.com>
References: <20090316190642.GH5098@agk.fab.redhat.com>
	<Pine.LNX.4.64.0903170920000.26754@hs20-bc2-1.build.redhat.com>
	<20090317203838.GQ3063@agk.fab.redhat.com>
	<Pine.LNX.4.64.0903181913260.25113@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0903181914520.25113@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0903181914520.25113@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

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


This patch fixes two problems:

1. job->fn being called from the thread that submitted the job (see above).

- Fix: hand over the completion callback to the kcopyd thread.

2. job->fn(read_err, write_err, job->context); in segment_complete
reports the error of the last subjob, not the union of all errors.

- Fix: pass job->write_err to the callback to report all error bits
  (it is done already in run_complete_job)

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6.29-devel/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.29-devel.orig/drivers/md/dm-kcopyd.c	2009-04-01 03:14:49.000000000 +0200
+++ linux-2.6.29-devel/drivers/md/dm-kcopyd.c	2009-04-04 02:05:02.000000000 +0200
@@ -511,13 +511,16 @@ static void segment_complete(int read_er
 	} else if (atomic_dec_and_test(&job->sub_jobs)) {
 
 		/*
-		 * To avoid a race we must keep the job around
-		 * until after the notify function has completed.
-		 * Otherwise the client may try and stop the job
-		 * after we've completed.
+		 * Queue the completion callback to the kcopyd thread.
+		 *
+		 * Some callers assume that all the completions are called
+		 * from a single thread and don't race with each other.
+		 *
+		 * We must not call the callback directly here because this
+		 * code may not be executing in the thread.
 		 */
-		job->fn(read_err, write_err, job->context);
-		mempool_free(job, job->kc->job_pool);
+		push(&kc->complete_jobs, job);
+		wake(kc);
 	}
 }
 
@@ -530,6 +533,8 @@ static void split_job(struct kcopyd_job 
 {
 	int i;
 
+	atomic_inc(&job->kc->nr_jobs);
+
 	atomic_set(&job->sub_jobs, SPLIT_COUNT);
 	for (i = 0; i < SPLIT_COUNT; i++)
 		segment_complete(0, 0u, job);
