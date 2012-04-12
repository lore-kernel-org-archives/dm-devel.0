From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2] dm thin: fix memory leak of singleton
	bio-prison cell
Date: Thu, 12 Apr 2012 18:34:34 -0400
Message-ID: <1334270075-11699-1-git-send-email-snitzer@redhat.com>
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
To: dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

Add missing mempool_free() to __cell_release_singleton().

This is a pretty significant leak that will accumulate to over 2GB of
leaked memory just from running the full thinp-test-suite.  Leak was
known to exist but the kmalloc_pool which was used for prison cell
allocation caused all leaked memory to be attributed to the "size-128"
cache.  kmemleak proved useful in identifying the source of this
illusive leak.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-thin.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-thin.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin.c
+++ linux-2.6/drivers/md/dm-thin.c
@@ -279,8 +279,10 @@ static void __cell_release(struct cell *
 
 	hlist_del(&cell->list);
 
-	bio_list_add(inmates, cell->holder);
-	bio_list_merge(inmates, &cell->bios);
+	if (inmates) {
+		bio_list_add(inmates, cell->holder);
+		bio_list_merge(inmates, &cell->bios);
+	}
 
 	mempool_free(cell, prison->cell_pool);
 }
@@ -303,9 +305,10 @@ static void cell_release(struct cell *ce
  */
 static void __cell_release_singleton(struct cell *cell, struct bio *bio)
 {
-	hlist_del(&cell->list);
 	BUG_ON(cell->holder != bio);
 	BUG_ON(!bio_list_empty(&cell->bios));
+
+	__cell_release(cell, NULL);
 }
 
 static void cell_release_singleton(struct cell *cell, struct bio *bio)
