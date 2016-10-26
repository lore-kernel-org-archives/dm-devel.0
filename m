From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] brd: remove unused brd_zero_page
Date: Wed, 26 Oct 2016 16:27:57 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1610261627070.12287@file01.intranet.prod.int.rdu2.redhat.com>
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

Remove the function brd_zero_page. This function was used to zero a page
when the discard request came in.

The discard request is used for performance or space optimization, it
makes no sense to zero pages on discard request, as it neither improves
performance nor saves memory.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/block/brd.c |   23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -156,19 +156,6 @@ static void brd_free_page(struct brd_dev
 		call_rcu(&page->rcu_head, brd_free_page_rcu);
 }
 
-static void brd_zero_page(struct brd_device *brd, sector_t sector)
-{
-	struct page *page;
-
-	rcu_read_lock();
-
-	page = brd_lookup_page(brd, sector);
-	if (page)
-		clear_highpage(page);
-
-	rcu_read_unlock();
-}
-
 /*
  * Free all backing store pages and radix tree. This must only be called when
  * there are no other users of the device.
@@ -234,15 +221,7 @@ static void discard_from_brd(struct brd_
 	sector += boundary;
 	n_sectors -= boundary;
 	while (n_sectors >= PAGE_SIZE >> SECTOR_SHIFT) {
-		/*
-		 * Don't want to actually discard pages here because
-		 * re-allocating the pages can result in writeback
-		 * deadlocks under heavy load.
-		 */
-		if (1)
-			brd_free_page(brd, sector);
-		else
-			brd_zero_page(brd, sector);
+		brd_free_page(brd, sector);
 		sector += PAGE_SIZE >> SECTOR_SHIFT;
 		n_sectors -= PAGE_SIZE >> SECTOR_SHIFT;
 	}

