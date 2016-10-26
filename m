From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/4] brd: extend rcu read sections
Date: Wed, 26 Oct 2016 16:26:35 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1610261626190.12287@file01.intranet.prod.int.rdu2.redhat.com>
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

This patch extends rcu read sections, so that all manipulations of the
page and its data are within read sections.

This patch is a prerequisite for discarding pages using rcu.

Note that the page pointer escapes the rcu section in the function
brd_direct_access, however, direct access is not supposed to race with
discard.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/block/brd.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -71,10 +71,8 @@ static struct page *brd_lookup_page(stru
 	 * safe here (we don't have total exclusion from radix tree updates
 	 * here, only deletes).
 	 */
-	rcu_read_lock();
 	idx = sector >> PAGE_SECTORS_SHIFT; /* sector to page index */
 	page = radix_tree_lookup(&brd->brd_pages, idx);
-	rcu_read_unlock();
 
 	BUG_ON(page && page->index != idx);
 
@@ -92,7 +90,12 @@ static struct page *brd_insert_page(stru
 	struct page *page;
 	gfp_t gfp_flags;
 
+	rcu_read_lock();
+
 	page = brd_lookup_page(brd, sector);
+
+	rcu_read_unlock();
+
 	if (page)
 		return page;
 
@@ -151,9 +154,13 @@ static void brd_zero_page(struct brd_dev
 {
 	struct page *page;
 
+	rcu_read_lock();
+
 	page = brd_lookup_page(brd, sector);
 	if (page)
 		clear_highpage(page);
+
+	rcu_read_unlock();
 }
 
 /*
@@ -246,6 +253,8 @@ static void copy_to_brd(struct brd_devic
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 
+	rcu_read_lock();
+
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	page = brd_lookup_page(brd, sector);
 	BUG_ON(!page);
@@ -265,6 +274,8 @@ static void copy_to_brd(struct brd_devic
 		memcpy(dst, src, copy);
 		kunmap_atomic(dst);
 	}
+
+	rcu_read_unlock();
 }
 
 /*
@@ -278,6 +289,8 @@ static void copy_from_brd(void *dst, str
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
 
+	rcu_read_lock();
+
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	page = brd_lookup_page(brd, sector);
 	if (page) {
@@ -299,6 +312,8 @@ static void copy_from_brd(void *dst, str
 		} else
 			memset(dst, 0, copy);
 	}
+
+	rcu_read_unlock();
 }
 
 /*

