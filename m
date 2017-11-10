From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] brd: remove unused brd_mutex
Date: Fri, 10 Nov 2017 12:29:34 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1711101228030.15978@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org
Cc: Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com
List-Id: dm-devel.ids

Remove unused mutex brd_mutex. It is unused since the commit ff26956875c2
("brd: remove support for BLKFLSBUF").

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/block/brd.c |    1 -
 1 file changed, 1 deletion(-)

Index: linux-2.6/drivers/block/brd.c
===================================================================
--- linux-2.6.orig/drivers/block/brd.c
+++ linux-2.6/drivers/block/brd.c
@@ -60,7 +60,6 @@ struct brd_device {
 /*
  * Look up and return a brd's page for a given sector.
  */
-static DEFINE_MUTEX(brd_mutex);
 static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 {
 	pgoff_t idx;
