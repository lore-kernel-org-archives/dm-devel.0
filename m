From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH] device-mapper snaphot: fix kcopyd destructor
Date: Tue, 7 Feb 2006 16:22:13 +0000
Message-ID: <20060207162213.GQ4724@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Before removing a snapshot, wait for the completion of any kcopyd jobs
using it.  Without this patch, the snapshot structures get freed while
there could still be kcopyd jobs referencing them, which leads to a
crash.  To see this, all you have to do is create a new snapshot of an
LV, start a large write to the LV and then attempt to remove the
snapshot before the write you issued to the origin has finished.

The patch maintains a count (nr_jobs) of how many outstanding jobs
each kcopyd_client has.

The snapshot destructor first unregisters the snapshot so that no
new kcopyd jobs (created by writes to the origin) will reference 
that particular snapshot.   kcopyd_client_destroy() is now run next
to wait for the completion of any outstanding jobs before the snapshot
exception structures (that those jobs reference) are freed.


Comments?


Signed-Off-By: Alasdair G Kergon <agk@redhat.com>

Index: linux-2.6.16-rc1/drivers/md/kcopyd.c
===================================================================
--- linux-2.6.16-rc1.orig/drivers/md/kcopyd.c	2006-02-07 15:49:28.000000000 +0000
+++ linux-2.6.16-rc1/drivers/md/kcopyd.c	2006-02-07 15:49:38.000000000 +0000
@@ -43,6 +43,9 @@ struct kcopyd_client {
 	struct page_list *pages;
 	unsigned int nr_pages;
 	unsigned int nr_free_pages;
+
+	wait_queue_head_t destroyq;
+	atomic_t nr_jobs;
 };
 
 static struct page_list *alloc_pl(void)
@@ -292,10 +295,15 @@ static int run_complete_job(struct kcopy
 	int read_err = job->read_err;
 	unsigned int write_err = job->write_err;
 	kcopyd_notify_fn fn = job->fn;
+	struct kcopyd_client *kc = job->kc;
 
-	kcopyd_put_pages(job->kc, job->pages);
+	kcopyd_put_pages(kc, job->pages);
 	mempool_free(job, _job_pool);
 	fn(read_err, write_err, context);
+
+	if (atomic_dec_and_test(&kc->nr_jobs))
+		wake_up(&kc->destroyq);
+
 	return 0;
 }
 
@@ -430,6 +438,7 @@ static void do_work(void *ignored)
  */
 static void dispatch_job(struct kcopyd_job *job)
 {
+	atomic_inc(&job->kc->nr_jobs);
 	push(&_pages_jobs, job);
 	wake();
 }
@@ -442,6 +451,7 @@ static void segment_complete(int read_er
 	sector_t progress = 0;
 	sector_t count = 0;
 	struct kcopyd_job *job = (struct kcopyd_job *) context;
+	struct kcopyd_client *kc = job->kc;
 
 	down(&job->lock);
 
@@ -496,6 +506,8 @@ static void segment_complete(int read_er
 		 */
 		job->fn(read_err, write_err, job->context);
 		mempool_free(job, _job_pool);
+		if (atomic_dec_and_test(&kc->nr_jobs))
+			wake_up(&kc->destroyq);
 	}
 }
 
@@ -669,6 +681,9 @@ int kcopyd_client_create(unsigned int nr
 		return r;
 	}
 
+	init_waitqueue_head(&kc->destroyq);
+	atomic_set(&kc->nr_jobs, 0);
+
 	client_add(kc);
 	*result = kc;
 	return 0;
@@ -676,6 +691,9 @@ int kcopyd_client_create(unsigned int nr
 
 void kcopyd_client_destroy(struct kcopyd_client *kc)
 {
+	/* Wait for completion of all jobs submitted by this client. */
+	wait_event(kc->destroyq, !atomic_read(&kc->nr_jobs));
+
 	dm_io_put(kc->nr_pages);
 	client_free_pages(kc);
 	client_del(kc);
Index: linux-2.6.16-rc1/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.16-rc1.orig/drivers/md/dm-snap.c	2006-02-07 15:49:28.000000000 +0000
+++ linux-2.6.16-rc1/drivers/md/dm-snap.c	2006-02-07 15:49:38.000000000 +0000
@@ -559,8 +559,12 @@ static void snapshot_dtr(struct dm_targe
 {
 	struct dm_snapshot *s = (struct dm_snapshot *) ti->private;
 
+	/* Prevent further origin writes from using this snapshot. */
+	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
 
+	kcopyd_client_destroy(s->kcopyd_client);
+
 	exit_exception_table(&s->pending, pending_cache);
 	exit_exception_table(&s->complete, exception_cache);
 
@@ -569,7 +573,7 @@ static void snapshot_dtr(struct dm_targe
 
 	dm_put_device(ti, s->origin);
 	dm_put_device(ti, s->cow);
-	kcopyd_client_destroy(s->kcopyd_client);
+
 	kfree(s);
 }
 
