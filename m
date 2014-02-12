From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-io: fix broken i/o to multiple destinations
Date: Wed, 12 Feb 2014 16:37:30 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1402121634320.9304@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Kent Overstreet <kmo@daterainc.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

The patch 003b5c5719f159f4f4bf97511c4702a0638313dd committed to 3.14-rc1
breaks dm-mirror.

dm-io has three possible iterators (DM_IO_PAGE_LIST, DM_IO_BVEC,
DM_IO_VMA) that iterate over pages where the i/o should be performed.

The patch 003b5c5719f159f4f4bf97511c4702a0638313dd changes the DM_IO_BVEC
iterator to DM_IO_BIO. Before the patch the iterator stored the pointer to
bio vector in the structure dpages. The iterator incremented the pointer
in the dpages structure as it advanced over the pages. After the patch,
the DM_IO_BIO iterator stores a pointer to the bio in the dpages structure
and uses bio_advance to change the bio as it advances.

The problem is that the function dispatch_io stores the content of the 
structure dpages into the variable old_pages and restores it before 
issuing I/O to each of the devices. Before the patch, the statement
"*dp = old_pages;" restored the iterator to its starting position. After 
the patch, struct dpages holds a pointer to the bio, thus the statement 
"*dp = old_pages;" doesn't restore the iterator.

Consequently, only the first mirror leg is written correctly, the kernel
locks up when trying to write the other mirror legs because the number of
sectors to write in the where->count variable doesn't match the number of
sectors returned by the iterator.

This patch fixes the bug by partially reverting the original patch - it 
changes the code so that struct dpages holds a pointer to the bio vector, 
so that the statement "*dp = old_pages;" restores the iterator correctly.

The field "context_u" holds the offset from the beginning of the current
bio vector entry, just like the "bio->bi_iter.bi_bvec_done" field.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-io.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

Index: linux-3.14-rc2/drivers/md/dm-io.c
===================================================================
--- linux-3.14-rc2.orig/drivers/md/dm-io.c	2014-02-10 17:47:27.000000000 +0100
+++ linux-3.14-rc2/drivers/md/dm-io.c	2014-02-12 20:48:23.000000000 +0100
@@ -204,26 +204,25 @@ static void list_dp_init(struct dpages *
 static void bio_get_page(struct dpages *dp,
 		  struct page **p, unsigned long *len, unsigned *offset)
 {
-	struct bio *bio = dp->context_ptr;
-	struct bio_vec bvec = bio_iovec(bio);
-	*p = bvec.bv_page;
-	*len = bvec.bv_len;
-	*offset = bvec.bv_offset;
+	struct bio_vec *bvec = (struct bio_vec *) dp->context_ptr;
+	*p = bvec->bv_page;
+	*len = bvec->bv_len - dp->context_u;
+	*offset = bvec->bv_offset + dp->context_u;
 }
 
 static void bio_next_page(struct dpages *dp)
 {
-	struct bio *bio = dp->context_ptr;
-	struct bio_vec bvec = bio_iovec(bio);
-
-	bio_advance(bio, bvec.bv_len);
+	struct bio_vec *bvec = (struct bio_vec *) dp->context_ptr;
+	dp->context_ptr = bvec + 1;
+	dp->context_u = 0;
 }
 
 static void bio_dp_init(struct dpages *dp, struct bio *bio)
 {
 	dp->get_page = bio_get_page;
 	dp->next_page = bio_next_page;
-	dp->context_ptr = bio;
+	dp->context_ptr = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
+	dp->context_u = bio->bi_iter.bi_bvec_done;
 }
 
 /*
