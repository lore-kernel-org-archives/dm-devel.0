From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-kcopyd: optionally zero an area instead
	of copying
Date: Thu, 9 Jun 2011 11:36:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106091136040.7642@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1106081753570.7811@hs20-bc2-1.build.redhat.com>
	<20110609100429.GE3152@ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110609100429.GE3152@ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids



On Thu, 9 Jun 2011, Joe Thornber wrote:

> On Wed, Jun 08, 2011 at 05:55:37PM -0400, Mikulas Patocka wrote:
> > Hi
> > 
> > This patch introduces an option to kcopyd to zero requested area instead 
> > of copying. I think Joe may need something like this in his snapshot 
> > store.
> 
> Could we have another function please, rather than overloading the
> existing entry point?
> 
> i.e.,
> 
> int dm_kcopyd_zero(struct dm_kcopyd_client *kc,
> 		   unsigned num_dests, struct dm_io_region *dests,
> 		   unsigned flags, dm_kcopyd_notify_fn fn, void *context);
> 
> Thanks,
> 
> - Joe
> 

Here it is ... but it duplicates some code in dm_kcopyd_copy..

Mikulas

---

dm-kcopyd: optionally zero an area instead of copying

This patch introduces new function "dm_kcopyd_zero" that zeroes a
requested.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c    |   53 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/dm-kcopyd.h |    4 +++
 2 files changed, 56 insertions(+), 1 deletion(-)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-06-09 17:15:34.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-06-09 17:20:30.000000000 +0200
@@ -69,6 +69,8 @@ struct dm_kcopyd_client {
 	struct list_head pages_jobs;
 };
 
+static struct page_list zero_page_list;
+
 static DEFINE_SPINLOCK(throttle_spinlock);
 
 /*
@@ -339,6 +341,9 @@ int __init dm_kcopyd_init(void)
 	if (!_job_cache)
 		return -ENOMEM;
 
+	zero_page_list.next = &zero_page_list;
+	zero_page_list.page = ZERO_PAGE(0);
+
 	return 0;
 }
 
@@ -407,7 +412,7 @@ static int run_complete_job(struct kcopy
 	dm_kcopyd_notify_fn fn = job->fn;
 	struct dm_kcopyd_client *kc = job->kc;
 
-	if (job->pages)
+	if (job->pages && job->pages != &zero_page_list)
 		kcopyd_put_pages(kc, job->pages);
 	/* Do not free sub-jobs */
 	if (context != job)
@@ -570,6 +575,8 @@ static void dispatch_job(struct kcopyd_j
 	atomic_inc(&kc->nr_jobs);
 	if (unlikely(!job->source.count))
 		push(&kc->complete_jobs, job);
+	else if (job->pages == &zero_page_list)
+		push(&kc->io_jobs, job);
 	else
 		push(&kc->pages_jobs, job);
 	wake(kc);
@@ -704,6 +711,50 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 }
 EXPORT_SYMBOL(dm_kcopyd_copy);
 
+int dm_kcopyd_zero(struct dm_kcopyd_client *kc,
+		   unsigned int num_dests, struct dm_io_region *dests,
+		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context)
+{
+	struct kcopyd_job *job;
+
+	/*
+	 * Allocate a new job.
+	 */
+	job = mempool_alloc(kc->job_pool, GFP_NOIO);
+
+	/*
+	 * set up for the write.
+	 */
+	job->kc = kc;
+	job->flags = flags;
+	job->read_err = 0;
+	job->write_err = 0;
+	job->rw = WRITE;
+
+	memset(&job->source, 0, sizeof job->source);
+	job->source.count = dests[0].count;
+
+	job->num_dests = num_dests;
+	memcpy(&job->dests, dests, sizeof(*dests) * num_dests);
+
+	job->pages = &zero_page_list;
+
+	job->fn = fn;
+	job->context = context;
+
+	if (job->source.count <= SUB_JOB_SIZE)
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
+EXPORT_SYMBOL(dm_kcopyd_zero);
+
 /*
  * Cancels a kcopyd job, eg. someone might be deactivating a
  * mirror.
Index: linux-2.6.39-fast/include/linux/dm-kcopyd.h
===================================================================
--- linux-2.6.39-fast.orig/include/linux/dm-kcopyd.h	2011-06-09 17:20:47.000000000 +0200
+++ linux-2.6.39-fast/include/linux/dm-kcopyd.h	2011-06-09 17:21:01.000000000 +0200
@@ -55,5 +55,9 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 		   unsigned num_dests, struct dm_io_region *dests,
 		   unsigned flags, dm_kcopyd_notify_fn fn, void *context);
 
+int dm_kcopyd_zero(struct dm_kcopyd_client *kc,
+		   unsigned num_dests, struct dm_io_region *dests,
+		   unsigned flags, dm_kcopyd_notify_fn fn, void *context);
+
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_DM_KCOPYD_H */
