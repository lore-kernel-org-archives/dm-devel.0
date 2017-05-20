From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-integrity: use the kvmalloc function
Date: Sat, 20 May 2017 14:56:21 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1705201455530.1841@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Use the kvmalloc function instead of dm_integrity_kvmalloc.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c
+++ linux-2.6/drivers/md/dm-integrity.c
@@ -2374,21 +2374,6 @@ static void dm_integrity_set(struct dm_t
 	blk_queue_max_integrity_segments(disk->queue, UINT_MAX);
 }
 
-/* FIXME: use new kvmalloc */
-static void *dm_integrity_kvmalloc(size_t size, gfp_t gfp)
-{
-	void *ptr = NULL;
-
-	if (size <= PAGE_SIZE)
-		ptr = kmalloc(size, GFP_KERNEL | gfp);
-	if (!ptr && size <= KMALLOC_MAX_SIZE)
-		ptr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY | gfp);
-	if (!ptr)
-		ptr = __vmalloc(size, GFP_KERNEL | gfp, PAGE_KERNEL);
-
-	return ptr;
-}
-
 static void dm_integrity_free_page_list(struct dm_integrity_c *ic, struct page_list *pl)
 {
 	unsigned i;
@@ -2407,7 +2392,7 @@ static struct page_list *dm_integrity_al
 	struct page_list *pl;
 	unsigned i;
 
-	pl = dm_integrity_kvmalloc(page_list_desc_size, __GFP_ZERO);
+	pl = kvmalloc(page_list_desc_size, GFP_KERNEL | __GFP_ZERO);
 	if (!pl)
 		return NULL;
 
@@ -2437,7 +2422,7 @@ static struct scatterlist **dm_integrity
 	struct scatterlist **sl;
 	unsigned i;
 
-	sl = dm_integrity_kvmalloc(ic->journal_sections * sizeof(struct scatterlist *), __GFP_ZERO);
+	sl = kvmalloc(ic->journal_sections * sizeof(struct scatterlist *), GFP_KERNEL | __GFP_ZERO);
 	if (!sl)
 		return NULL;
 
@@ -2453,7 +2438,7 @@ static struct scatterlist **dm_integrity
 
 		n_pages = (end_index - start_index + 1);
 
-		s = dm_integrity_kvmalloc(n_pages * sizeof(struct scatterlist), 0);
+		s = kvmalloc(n_pages * sizeof(struct scatterlist), GFP_KERNEL);
 		if (!s) {
 			dm_integrity_free_journal_scatterlist(ic, sl);
 			return NULL;
@@ -2617,7 +2602,7 @@ static int create_journal(struct dm_inte
 				goto bad;
 			}
 
-			sg = dm_integrity_kvmalloc((ic->journal_pages + 1) * sizeof(struct scatterlist), 0);
+			sg = kvmalloc((ic->journal_pages + 1) * sizeof(struct scatterlist), GFP_KERNEL);
 			if (!sg) {
 				*error = "Unable to allocate sg list";
 				r = -ENOMEM;
@@ -2673,7 +2658,7 @@ static int create_journal(struct dm_inte
 				r = -ENOMEM;
 				goto bad;
 			}
-			ic->sk_requests = dm_integrity_kvmalloc(ic->journal_sections * sizeof(struct skcipher_request *), __GFP_ZERO);
+			ic->sk_requests = kvmalloc(ic->journal_sections * sizeof(struct skcipher_request *), GFP_KERNEL | __GFP_ZERO);
 			if (!ic->sk_requests) {
 				*error = "Unable to allocate sk requests";
 				r = -ENOMEM;
@@ -2740,7 +2725,7 @@ retest_commit_id:
 		r = -ENOMEM;
 		goto bad;
 	}
-	ic->journal_tree = dm_integrity_kvmalloc(journal_tree_size, 0);
+	ic->journal_tree = kvmalloc(journal_tree_size, GFP_KERNEL);
 	if (!ic->journal_tree) {
 		*error = "Could not allocate memory for journal tree";
 		r = -ENOMEM;
