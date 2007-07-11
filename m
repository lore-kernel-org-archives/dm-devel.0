From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.23 PATCH 10/18] dm raid1: clear region outside
	spinlock
Date: Wed, 11 Jul 2007 21:59:56 +0100
Message-ID: <20070711205956.GB24114@agk.fab.redhat.com>
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
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Jonathan Brassow <jbrassow@redhat.com>

A clear_region function is permitted to block (in practice, rare) but gets
called in rh_update_states() with a spinlock held.

The bits being marked and cleared by the above functions are used
to update the on-disk log, but are never read directly.  We can
perform these operations outside the spinlock since the
bits are only changed within one thread viz.
   - mark_region in rh_inc()
   - clear_region in rh_update_states().

So, we grab the clean_regions list items via list_splice() within the
spinlock and defer clear_region() until we iterate over the list for
deletion - similar to how the recovered_regions list is already handled.
We then move the flush() call down to ensure it encapsulates the changes
which are done by the later calls to clear_region().

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-raid1.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

Index: linux/drivers/md/dm-raid1.c
===================================================================
--- linux.orig/drivers/md/dm-raid1.c	2007-07-11 21:37:42.000000000 +0100
+++ linux/drivers/md/dm-raid1.c	2007-07-11 21:37:46.000000000 +0100
@@ -378,10 +378,8 @@ static void rh_update_states(struct regi
 		list_splice(&rh->clean_regions, &clean);
 		INIT_LIST_HEAD(&rh->clean_regions);
 
-		list_for_each_entry (reg, &clean, list) {
-			rh->log->type->clear_region(rh->log, reg->key);
+		list_for_each_entry(reg, &clean, list)
 			list_del(&reg->hash_list);
-		}
 	}
 
 	if (!list_empty(&rh->recovered_regions)) {
@@ -405,10 +403,12 @@ static void rh_update_states(struct regi
 		mempool_free(reg, rh->region_pool);
 	}
 
-	rh->log->type->flush(rh->log);
-
-	list_for_each_entry_safe (reg, next, &clean, list)
+	list_for_each_entry_safe(reg, next, &clean, list) {
+		rh->log->type->clear_region(rh->log, reg->key);
 		mempool_free(reg, rh->region_pool);
+	}
+
+	rh->log->type->flush(rh->log);
 }
 
 static void rh_inc(struct region_hash *rh, region_t region)
