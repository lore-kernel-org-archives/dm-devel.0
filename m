From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/4] brd: handle misaligned discard
Date: Wed, 26 Oct 2016 16:26:15 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1610261625580.12287@file01.intranet.prod.int.rdu2.redhat.com>
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

The brd driver refuses misaligned discard requests with an error. However,
this is suboptimal, misaligned requests could be handled by discarding a
part of the request that is aligned on a page boundary. This patch changes
the code so that it handles misaligned requests.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/block/brd.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -213,9 +213,14 @@ static int copy_to_brd_setup(struct brd_
 }
 
 static void discard_from_brd(struct brd_device *brd,
-			sector_t sector, size_t n)
+			sector_t sector, unsigned n_sectors)
 {
-	while (n >= PAGE_SIZE) {
+	unsigned boundary = -sector & ((PAGE_SIZE >> SECTOR_SHIFT) - 1);
+	if (unlikely(boundary >= n_sectors))
+		return;
+	sector += boundary;
+	n_sectors -= boundary;
+	while (n_sectors >= PAGE_SIZE >> SECTOR_SHIFT) {
 		/*
 		 * Don't want to actually discard pages here because
 		 * re-allocating the pages can result in writeback
@@ -226,7 +231,7 @@ static void discard_from_brd(struct brd_
 		else
 			brd_zero_page(brd, sector);
 		sector += PAGE_SIZE >> SECTOR_SHIFT;
-		n -= PAGE_SIZE;
+		n_sectors -= PAGE_SIZE >> SECTOR_SHIFT;
 	}
 }
 
@@ -339,10 +344,7 @@ static blk_qc_t brd_make_request(struct
 		goto io_error;
 
 	if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
-		if (sector & ((PAGE_SIZE >> SECTOR_SHIFT) - 1) ||
-		    bio->bi_iter.bi_size & ~PAGE_MASK)
-			goto io_error;
-		discard_from_brd(brd, sector, bio->bi_iter.bi_size);
+		discard_from_brd(brd, sector, bio->bi_iter.bi_size >> SECTOR_SHIFT);
 		goto out;
 	}
 

