From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm-bio-prison-v1: replace spin_lock_irqsave with
 spin_lock_irq
Date: Tue, 15 Oct 2019 08:16:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1910150408480.26857@file01.intranet.prod.int.rdu2.redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, Joe Thornber <thornber@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Replace spin_lock_irqsave/irqrestore with spin_lock_irq/spin_unlock_irq.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bio-prison-v1.c |   27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/md/dm-bio-prison-v1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bio-prison-v1.c	2019-10-10 16:52:03.000000000 +0200
+++ linux-2.6/drivers/md/dm-bio-prison-v1.c	2019-10-11 21:37:00.000000000 +0200
@@ -150,11 +150,10 @@ static int bio_detain(struct dm_bio_pris
 		      struct dm_bio_prison_cell **cell_result)
 {
 	int r;
-	unsigned long flags;
 
-	spin_lock_irqsave(&prison->lock, flags);
+	spin_lock_irq(&prison->lock);
 	r = __bio_detain(prison, key, inmate, cell_prealloc, cell_result);
-	spin_unlock_irqrestore(&prison->lock, flags);
+	spin_unlock_irq(&prison->lock);
 
 	return r;
 }
@@ -198,11 +197,9 @@ void dm_cell_release(struct dm_bio_priso
 		     struct dm_bio_prison_cell *cell,
 		     struct bio_list *bios)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&prison->lock, flags);
+	spin_lock_irq(&prison->lock);
 	__cell_release(prison, cell, bios);
-	spin_unlock_irqrestore(&prison->lock, flags);
+	spin_unlock_irq(&prison->lock);
 }
 EXPORT_SYMBOL_GPL(dm_cell_release);
 
@@ -250,12 +247,10 @@ void dm_cell_visit_release(struct dm_bio
 			   void *context,
 			   struct dm_bio_prison_cell *cell)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&prison->lock, flags);
+	spin_lock_irq(&prison->lock);
 	visit_fn(context, cell);
 	rb_erase(&cell->node, &prison->cells);
-	spin_unlock_irqrestore(&prison->lock, flags);
+	spin_unlock_irq(&prison->lock);
 }
 EXPORT_SYMBOL_GPL(dm_cell_visit_release);
 
@@ -275,11 +270,10 @@ int dm_cell_promote_or_release(struct dm
 			       struct dm_bio_prison_cell *cell)
 {
 	int r;
-	unsigned long flags;
 
-	spin_lock_irqsave(&prison->lock, flags);
+	spin_lock_irq(&prison->lock);
 	r = __promote_or_release(prison, cell);
-	spin_unlock_irqrestore(&prison->lock, flags);
+	spin_unlock_irq(&prison->lock);
 
 	return r;
 }
@@ -379,10 +373,9 @@ EXPORT_SYMBOL_GPL(dm_deferred_entry_dec)
 int dm_deferred_set_add_work(struct dm_deferred_set *ds, struct list_head *work)
 {
 	int r = 1;
-	unsigned long flags;
 	unsigned next_entry;
 
-	spin_lock_irqsave(&ds->lock, flags);
+	spin_lock_irq(&ds->lock);
 	if ((ds->sweeper == ds->current_entry) &&
 	    !ds->entries[ds->current_entry].count)
 		r = 0;
@@ -392,7 +385,7 @@ int dm_deferred_set_add_work(struct dm_d
 		if (!ds->entries[next_entry].count)
 			ds->current_entry = next_entry;
 	}
-	spin_unlock_irqrestore(&ds->lock, flags);
+	spin_unlock_irq(&ds->lock);
 
 	return r;
 }
