From: Greg KH <gregkh@suse.de>
Subject: [patch 04/73] dm crypt: use bio_add_page
Date: Wed, 6 Feb 2008 15:50:58 -0800
Message-ID: <20080206235058.GE13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764275AbYBFXz5@vger.kernel.org>
Content-Disposition: inline; filename="dm-crypt-use-bio_add_page.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, dm-crypt@saout.de, dm-devel@redhat.com, Milan Broz <mbroz@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids


2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Milan Broz <mbroz@redhat.com>

patch 91e106259214b40e992a58fb9417da46868e19b2 in mainline.

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

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/dm-crypt.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -399,7 +399,8 @@ static struct bio *crypt_alloc_buffer(st
 	struct bio *clone;
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	gfp_t gfp_mask = GFP_NOIO | __GFP_HIGHMEM;
-	unsigned int i;
+	unsigned i, len;
+	struct page *page;
 
 	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, cc->bs);
 	if (!clone)
@@ -408,10 +409,8 @@ static struct bio *crypt_alloc_buffer(st
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
@@ -422,15 +421,14 @@ static struct bio *crypt_alloc_buffer(st
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

-- 
