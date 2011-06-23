From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] dm-kcopyd: optionally zero an area instead
 of copying
Date: Thu, 23 Jun 2011 11:24:19 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106231121540.31431@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1106081753570.7811@hs20-bc2-1.build.redhat.com>
	<20110609100429.GE3152@ubuntu>
	<Pine.LNX.4.64.1106091136040.7642@hs20-bc2-1.build.redhat.com>
	<20110623143401.GE7497@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110623143401.GE7497@agk-dp.fab.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Joe Thornber <thornber@redhat.com>
List-Id: dm-devel.ids



On Thu, 23 Jun 2011, Alasdair G Kergon wrote:

> On Thu, Jun 09, 2011 at 11:36:44AM -0400, Mikulas Patocka wrote:
> > Here it is ... but it duplicates some code in dm_kcopyd_copy..
>  
> Obviously I don't want the duplication:)
> 
> Presumably a wrapper function with the first patch will suffice?
> 
> Alasdair

Hi

So you can use this patch that adds a new function, but internaly works as 
passing NULL from to dm_kcopyd_copy.

Mikulas

---

dm-kcopyd: optionally zero an area instead of copying

This patch introduces new function "dm_kcopyd_zero" that zeroes a
requested.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c    |   31 ++++++++++++++++++++++++++-----
 include/linux/dm-kcopyd.h |    3 +++
 2 files changed, 29 insertions(+), 5 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-06-23 16:58:49.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-06-23 17:02:47.000000000 +0200
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
@@ -679,14 +686,20 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 	job->flags = flags;
 	job->read_err = 0;
 	job->write_err = 0;
-	job->rw = READ;
-
-	job->source = *from;
 
 	job->num_dests = num_dests;
 	memcpy(&job->dests, dests, sizeof(*dests) * num_dests);
 
-	job->pages = NULL;
+	if (from) {
+		job->source = *from;
+		job->pages = NULL;
+		job->rw = READ;
+	} else {
+		memset(&job->source, 0, sizeof job->source);
+		job->source.count = job->dests[0].count;
+		job->pages = &zero_page_list;
+		job->rw = WRITE;
+	}
 
 	job->fn = fn;
 	job->context = context;
@@ -704,6 +717,14 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 }
 EXPORT_SYMBOL(dm_kcopyd_copy);
 
+int dm_kcopyd_zero(struct dm_kcopyd_client *kc,
+		   unsigned int num_dests, struct dm_io_region *dests,
+		   unsigned int flags, dm_kcopyd_notify_fn fn, void *context)
+{
+	return dm_kcopyd_copy(kc, NULL, num_dests, dests, flags, fn, context);
+}
+EXPORT_SYMBOL(dm_kcopyd_zero);
+
 /*
  * Cancels a kcopyd job, eg. someone might be deactivating a
  * mirror.
Index: linux-2.6.39-fast/include/linux/dm-kcopyd.h
===================================================================
--- linux-2.6.39-fast.orig/include/linux/dm-kcopyd.h	2011-06-23 17:00:16.000000000 +0200
+++ linux-2.6.39-fast/include/linux/dm-kcopyd.h	2011-06-23 17:00:42.000000000 +0200
@@ -54,6 +54,9 @@ typedef void (*dm_kcopyd_notify_fn)(int 
 int dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 		   unsigned num_dests, struct dm_io_region *dests,
 		   unsigned flags, dm_kcopyd_notify_fn fn, void *context);
+int dm_kcopyd_zero(struct dm_kcopyd_client *kc,
+		   unsigned num_dests, struct dm_io_region *dests,
+		   unsigned flags, dm_kcopyd_notify_fn fn, void *context);
 
 #endif	/* __KERNEL__ */
 #endif	/* _LINUX_DM_KCOPYD_H */
