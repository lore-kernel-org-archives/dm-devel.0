From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Remove the spinlock protecting the pages
	allocation
Date: Thu, 19 May 2011 12:58:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1105191257430.17915@hs20-bc2-1.build.redhat.com>
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

Remove the spinlock protecting the pages allocation

The spinlock is taken in kcopyd_get_pages and kcopyd_put_pages.

kcopyd_get_pages is only called from run_pages_job, which is only
called from process_jobs called from do_work.

kcopyd_put_pages is called from client_alloc_pages (which is initialization
function) or from run_complete_job. run_complete_job is only called from
process_jobs called from do_work.

The spinlock is only taken on initialization or from single-threaded workqueue.
Therefore, the spinlock is useless.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |   11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

Index: linux-2.6.39-rc7-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-rc7-fast.orig/drivers/md/dm-kcopyd.c	2011-05-18 18:17:35.000000000 +0200
+++ linux-2.6.39-rc7-fast/drivers/md/dm-kcopyd.c	2011-05-18 18:19:01.000000000 +0200
@@ -36,7 +36,6 @@
  * pages for kcopyd io.
  *---------------------------------------------------------------*/
 struct dm_kcopyd_client {
-	spinlock_t lock;
 	struct page_list *pages;
 	unsigned int nr_pages;
 	unsigned int nr_free_pages;
@@ -99,11 +98,8 @@ static int kcopyd_get_pages(struct dm_kc
 {
 	struct page_list *pl;
 
-	spin_lock(&kc->lock);
-	if (kc->nr_free_pages < nr) {
-		spin_unlock(&kc->lock);
+	if (kc->nr_free_pages < nr)
 		return -ENOMEM;
-	}
 
 	kc->nr_free_pages -= nr;
 	for (*pages = pl = kc->pages; --nr; pl = pl->next)
@@ -112,8 +108,6 @@ static int kcopyd_get_pages(struct dm_kc
 	kc->pages = pl->next;
 	pl->next = NULL;
 
-	spin_unlock(&kc->lock);
-
 	return 0;
 }
 
@@ -121,14 +115,12 @@ static void kcopyd_put_pages(struct dm_k
 {
 	struct page_list *cursor;
 
-	spin_lock(&kc->lock);
 	for (cursor = pl; cursor->next; cursor = cursor->next)
 		kc->nr_free_pages++;
 
 	kc->nr_free_pages++;
 	cursor->next = kc->pages;
 	kc->pages = pl;
-	spin_unlock(&kc->lock);
 }
 
 /*
@@ -623,7 +615,6 @@ int dm_kcopyd_client_create(unsigned int
 	if (!kc)
 		return -ENOMEM;
 
-	spin_lock_init(&kc->lock);
 	spin_lock_init(&kc->job_lock);
 	INIT_LIST_HEAD(&kc->complete_jobs);
 	INIT_LIST_HEAD(&kc->io_jobs);
