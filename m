From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd: optionally zero an area instead of
	copying
Date: Wed, 8 Jun 2011 17:55:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106081753570.7811@hs20-bc2-1.build.redhat.com>
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
To: Edward Thornber <thornber@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This patch introduces an option to kcopyd to zero requested area instead 
of copying. I think Joe may need something like this in his snapshot 
store.

Mikulas

---

dm-kcopyd: optionally zero an area instead of copying

This patch causes kcopyd to zero a requested area instead of copying
if "from" parameter is set to zero.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-06-08 17:07:43.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-06-08 17:18:02.000000000 +0200
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
@@ -681,12 +688,18 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 	job->write_err = 0;
 	job->rw = READ;
 
-	job->source = *from;
-
 	job->num_dests = num_dests;
 	memcpy(&job->dests, dests, sizeof(*dests) * num_dests);
 
-	job->pages = NULL;
+	if (from) {
+		job->source = *from;
+		job->pages = NULL;
+	} else {
+		memset(&job->source, 0, sizeof job->source);
+		job->source.count = job->dests[0].count;
+		job->pages = &zero_page_list;
+		job->rw = WRITE;
+	}
 
 	job->fn = fn;
 	job->context = context;
