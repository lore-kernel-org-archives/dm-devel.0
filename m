From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-kcopyd: remove "offset" field from job
	structure
Date: Thu, 2 Jun 2011 15:17:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106021516390.25649@hs20-bc2-1.build.redhat.com>
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

dm-kcopyd: remove "offset" field from job structure

The field is always zero.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-kcopyd.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-kcopyd.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-kcopyd.c	2011-06-02 21:06:10.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-kcopyd.c	2011-06-02 21:06:58.000000000 +0200
@@ -309,7 +309,6 @@ struct kcopyd_job {
 	unsigned int num_dests;
 	struct dm_io_region dests[DM_KCOPYD_MAX_REGIONS];
 
-	sector_t offset;
 	unsigned int nr_pages;
 	struct page_list *pages;
 
@@ -464,7 +463,7 @@ static int run_io_job(struct kcopyd_job 
 		.bi_rw = job->rw,
 		.mem.type = DM_IO_PAGE_LIST,
 		.mem.ptr.pl = job->pages,
-		.mem.offset = job->offset,
+		.mem.offset = 0,
 		.notify.fn = complete_io,
 		.notify.context = job,
 		.client = job->kc->io_client,
@@ -484,8 +483,7 @@ static int run_pages_job(struct kcopyd_j
 {
 	int r;
 
-	job->nr_pages = dm_div_up(job->dests[0].count + job->offset,
-				  PAGE_SIZE >> 9);
+	job->nr_pages = dm_div_up(job->dests[0].count, PAGE_SIZE >> 9);
 	r = kcopyd_get_pages(job->kc, job->nr_pages, &job->pages);
 	if (!r) {
 		/* this job is ready for io */
@@ -689,7 +687,6 @@ int dm_kcopyd_copy(struct dm_kcopyd_clie
 	job->num_dests = num_dests;
 	memcpy(&job->dests, dests, sizeof(*dests) * num_dests);
 
-	job->offset = 0;
 	job->nr_pages = 0;
 	job->pages = NULL;
 
