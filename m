From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 06/06] dm crypt: use bio_add_page
Date: Thu, 13 Dec 2007 14:44:18 +0000
Message-ID: <20071213144418.GY24157@agk.fab.redhat.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-crypt@saout.de, stable@kernel.org, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Fix possible max_phys_segments violation in cloned dm-crypt bio.

In write operation dm-crypt needs to allocate new bio request
and run crypto operation on this clone. Cloned request has always
the same size, but number of physical segments can be increased
and violate max_phys_segments restriction.

This can lead to data corruption and serious hardware malfunction.
This was observed when using XFS over dm-crypt and at least
two HBA controller drivers (arcmsr, cciss) recently.

Fix it by using bio_add_page() call (which tests for other
restrictions too) instead of constructing own biovec.

All versions of dm-crypt are affected by this bug.

Cc: stable@kernel.org
Cc:  dm-crypt@saout.de
Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

Index: linux-2.6.24-rc5/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm-crypt.c	2007-12-12 15:43:11.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm-crypt.c	2007-12-12 15:43:15.000000000 +0000
@@ -398,7 +398,8 @@ static struct bio *crypt_alloc_buffer(st
 	struct bio *clone;
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	gfp_t gfp_mask = GFP_NOIO | __GFP_HIGHMEM;
-	unsigned int i;
+	unsigned i, len;
+	struct page *page;
 
 	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
 	if (!clone)
@@ -407,10 +408,8 @@ static struct bio *crypt_alloc_buffer(st
 	clone_init(io, clone);
 
 	for (i = 0; i < nr_iovecs; i++) {
-		struct bio_vec *bv = bio_iovec_idx(clone, i);
-
-		bv->bv_page = mempool_alloc(cc->page_pool, gfp_mask);
-		if (!bv->bv_page)
+		page = mempool_alloc(cc->page_pool, gfp_mask);
+		if (!page)
 			break;
 
 		/*
@@ -421,15 +420,14 @@ static struct bio *crypt_alloc_buffer(st
 		if (i == (MIN_BIO_PAGES - 1))
 			gfp_mask = (gfp_mask | __GFP_NOWARN) & ~__GFP_WAIT;
 
-		bv->bv_offset = 0;
-		if (size > PAGE_SIZE)
-			bv->bv_len = PAGE_SIZE;
-		else
-			bv->bv_len = size;
+		len = (size > PAGE_SIZE) ? PAGE_SIZE : size;
+
+		if (!bio_add_page(clone, page, len, 0)) {
+			mempool_free(page, cc->page_pool);
+			break;
+		}
 
-		clone->bi_size += bv->bv_len;
-		clone->bi_vcnt++;
-		size -= bv->bv_len;
+		size -= len;
 	}
 
 	if (!clone->bi_size) {
