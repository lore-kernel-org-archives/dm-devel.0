From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 04/10] dm-ingerity: pass size to
	dm_integrity_alloc_page_list
Date: Mon, 29 Apr 2019 14:57:20 +0200
Message-ID: <20190429125740.951884280@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-integrity-alloc-page-list.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>, Heinz Mauelshagen <heinzm@redhat.com>, Milan Broz <mbroz@redhat.com>, Ondrej Kozina <okozina@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Pass size to dm_integrity_alloc_page_list. The following patches will need
a size that is different from ic->journal_pages.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-integrity.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-04-09 14:01:48.000000000 +0200
+++ linux-2.6/drivers/md/dm-integrity.c	2019-04-09 14:01:48.000000000 +0200
@@ -2677,37 +2677,37 @@ static void dm_integrity_set(struct dm_t
 	blk_queue_max_integrity_segments(disk->queue, UINT_MAX);
 }
 
-static void dm_integrity_free_page_list(struct dm_integrity_c *ic, struct page_list *pl)
+static void dm_integrity_free_page_list(struct page_list *pl)
 {
 	unsigned i;
 
 	if (!pl)
 		return;
-	for (i = 0; i < ic->journal_pages; i++)
-		if (pl[i].page)
-			__free_page(pl[i].page);
+	for (i = 0; pl[i].page; i++)
+		__free_page(pl[i].page);
 	kvfree(pl);
 }
 
-static struct page_list *dm_integrity_alloc_page_list(struct dm_integrity_c *ic)
+static struct page_list *dm_integrity_alloc_page_list(unsigned n_pages)
 {
-	size_t page_list_desc_size = ic->journal_pages * sizeof(struct page_list);
 	struct page_list *pl;
 	unsigned i;
 
-	pl = kvmalloc(page_list_desc_size, GFP_KERNEL | __GFP_ZERO);
+	pl = kvmalloc_array(n_pages + 1, sizeof(struct page_list), GFP_KERNEL | __GFP_ZERO);
 	if (!pl)
 		return NULL;
 
-	for (i = 0; i < ic->journal_pages; i++) {
+	for (i = 0; i < n_pages; i++) {
 		pl[i].page = alloc_page(GFP_KERNEL);
 		if (!pl[i].page) {
-			dm_integrity_free_page_list(ic, pl);
+			dm_integrity_free_page_list(pl);
 			return NULL;
 		}
 		if (i)
 			pl[i - 1].next = &pl[i];
 	}
+	pl[i].page = NULL;
+	pl[i].next = NULL;
 
 	return pl;
 }
@@ -2860,7 +2860,7 @@ static int create_journal(struct dm_inte
 	}
 	ic->journal_pages = journal_pages;
 
-	ic->journal = dm_integrity_alloc_page_list(ic);
+	ic->journal = dm_integrity_alloc_page_list(ic->journal_pages);
 	if (!ic->journal) {
 		*error = "Could not allocate memory for journal";
 		r = -ENOMEM;
@@ -2892,7 +2892,7 @@ static int create_journal(struct dm_inte
 		DEBUG_print("cipher %s, block size %u iv size %u\n",
 			    ic->journal_crypt_alg.alg_string, blocksize, ivsize);
 
-		ic->journal_io = dm_integrity_alloc_page_list(ic);
+		ic->journal_io = dm_integrity_alloc_page_list(ic->journal_pages);
 		if (!ic->journal_io) {
 			*error = "Could not allocate memory for journal io";
 			r = -ENOMEM;
@@ -2916,7 +2916,7 @@ static int create_journal(struct dm_inte
 				goto bad;
 			}
 
-			ic->journal_xor = dm_integrity_alloc_page_list(ic);
+			ic->journal_xor = dm_integrity_alloc_page_list(ic->journal_pages);
 			if (!ic->journal_xor) {
 				*error = "Could not allocate memory for journal xor";
 				r = -ENOMEM;
@@ -3571,9 +3571,9 @@ static void dm_integrity_dtr(struct dm_t
 		dm_put_device(ti, ic->dev);
 	if (ic->meta_dev)
 		dm_put_device(ti, ic->meta_dev);
-	dm_integrity_free_page_list(ic, ic->journal);
-	dm_integrity_free_page_list(ic, ic->journal_io);
-	dm_integrity_free_page_list(ic, ic->journal_xor);
+	dm_integrity_free_page_list(ic->journal);
+	dm_integrity_free_page_list(ic->journal_io);
+	dm_integrity_free_page_list(ic->journal_xor);
 	if (ic->journal_scatterlist)
 		dm_integrity_free_journal_scatterlist(ic, ic->journal_scatterlist);
 	if (ic->journal_io_scatterlist)
