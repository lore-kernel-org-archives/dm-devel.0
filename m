From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/4] brd: implement discard
Date: Wed, 26 Oct 2016 16:27:03 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1610261626390.12287@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1610211406290.9197@file01.intranet.prod.int.rdu2.redhat.com> <20161021200022.GA12580@redhat.com> <alpine.LRH.2.02.1610211616450.31606@file01.intranet.prod.int.rdu2.redhat.com> <20161024155756.GA48306@redhat.com>
 <20161025130712.GA12717@infradead.org> <20161025143719.GA51266@redhat.com> <710b07a3-9091-6935-37c4-ea1dcedcab4f@kernel.dk> <alpine.LRH.2.02.1610261624100.12287@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.02.1610261624100.12287@file01.intranet.prod.int.rdu2.redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Implement page discard using rcu. Each page has built-in entry rcu_head
that could be used to free the page from rcu.

Regarding the commant that "re-allocating the pages can result in
writeback deadlocks under heavy load" - if the user is in the risk of such
deadlocks, he should mount the filesystem without "-o discard".

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/block/brd.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -137,6 +137,12 @@ static struct page *brd_insert_page(stru
 	return page;
 }
 
+static void brd_free_page_rcu(struct rcu_head *head)
+{
+	struct page *page = container_of(head, struct page, rcu_head);
+	__free_page(page);
+}
+
 static void brd_free_page(struct brd_device *brd, sector_t sector)
 {
 	struct page *page;
@@ -147,7 +153,7 @@ static void brd_free_page(struct brd_dev
 	page = radix_tree_delete(&brd->brd_pages, idx);
 	spin_unlock(&brd->brd_lock);
 	if (page)
-		__free_page(page);
+		call_rcu(&page->rcu_head, brd_free_page_rcu);
 }
 
 static void brd_zero_page(struct brd_device *brd, sector_t sector)
@@ -233,7 +239,7 @@ static void discard_from_brd(struct brd_
 		 * re-allocating the pages can result in writeback
 		 * deadlocks under heavy load.
 		 */
-		if (0)
+		if (1)
 			brd_free_page(brd, sector);
 		else
 			brd_zero_page(brd, sector);
@@ -257,22 +263,22 @@ static void copy_to_brd(struct brd_devic
 
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	page = brd_lookup_page(brd, sector);
-	BUG_ON(!page);
-
-	dst = kmap_atomic(page);
-	memcpy(dst + offset, src, copy);
-	kunmap_atomic(dst);
+	if (page) {
+		dst = kmap_atomic(page);
+		memcpy(dst + offset, src, copy);
+		kunmap_atomic(dst);
+	}
 
 	if (copy < n) {
 		src += copy;
 		sector += copy >> SECTOR_SHIFT;
 		copy = n - copy;
 		page = brd_lookup_page(brd, sector);
-		BUG_ON(!page);
-
-		dst = kmap_atomic(page);
-		memcpy(dst, src, copy);
-		kunmap_atomic(dst);
+		if (page) {
+			dst = kmap_atomic(page);
+			memcpy(dst, src, copy);
+			kunmap_atomic(dst);
+		}
 	}
 
 	rcu_read_unlock();

