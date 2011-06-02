From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd: remove nr_pages field from job
	structure
Date: Thu, 2 Jun 2011 15:18:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106021517270.25649@hs20-bc2-1.build.redhat.com>
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

dm-kcopyd: remove nr_pages field from job structure

This field is never used, except temporarily in function "run_pages_job"
to count the number of required pages. We can use local variable instead.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-06-02 21:08:03.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-06-02 21:08:39.000000000 +0200
@@ -309,7 +309,6 @@ struct kcopyd_job {
 	unsigned int num_dests;
 	struct dm_io_region dests[DM_KCOPYD_MAX_REGIONS];
 
-	unsigned int nr_pages;
 	struct page_list *pages;
 
 	/*
@@ -482,9 +481,9 @@ static int run_io_job(struct kcopyd_job 
 static int run_pages_job(struct kcopyd_job *job)
 {
 	int r;
+	unsigned nr_pages = dm_div_up(job->dests[0].count, PAGE_SIZE >> 9);
 
-	job->nr_pages = dm_div_up(job->dests[0].count, PAGE_SIZE >> 9);
-	r = kcopyd_get_pages(job->kc, job->nr_pages, &job->pages);
+	r = kcopyd_get_pages(job->kc, nr_pages, &job->pages);
 	if (!r) {
 		/* this job is ready for io */
 		push(&job->kc->io_jobs, job);
@@ -687,7 +686,6 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 	job->num_dests = num_dests;
 	memcpy(&job->dests, dests, sizeof(*dests) * num_dests);
 
-	job->nr_pages = 0;
 	job->pages = NULL;
 
 	job->fn = fn;
