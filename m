From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] Suspend all active bios when the pool is
 suspended (was: staged dm_internal_{suspend,
 resume} related changes for wider review)
Date: Fri, 7 Nov 2014 18:16:34 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1411071804030.8597@file01.intranet.prod.int.rdu2.redhat.com>
References: <20141028232638.GB29288@redhat.com>
	<20141029002125.GC29288@redhat.com>
	<20141029012256.GF29288@redhat.com>
	<alpine.LRH.2.02.1411031823100.29299@file01.intranet.prod.int.rdu2.redhat.com>
	<CAMM=eLd8iuMDtNr7f4Cu97ZEua3-pOW4pdSdVKji7g02mKXFwQ@mail.gmail.com>
	<20141105011619.GA11411@redhat.com>
	<alpine.LRH.2.02.1411050736410.11912@file01.intranet.prod.int.rdu2.redhat.com>
	<alpine.LRH.2.02.1411050801270.19559@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105141147.GA14285@redhat.com>
	<alpine.LRH.2.02.1411050925450.20317@file01.intranet.prod.int.rdu2.redhat.com>
	<20141105162912.GA17625@redhat.com>
	<alpine.LRH.2.02.1411071047430.21255@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1411071047430.21255@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Bryn M. Reeves" <breeves@redhat.com>, ejt@redhat.com, Alasdair G Kergon <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids



On Fri, 7 Nov 2014, Mikulas Patocka wrote:

> For reasons 1 and 2, I wouldn't really deal with "thin" targets at all - 
> they may be created or deleted independent on pool status. Instead, we 
> should block all active bios inside the pool - the bios are already 
> registered in dm_deferred_set or in the prison, so all you need to do is 
> to set a flag pool's presuspend method that causes all new bios to be 
> queues and the wait until the prison is empty and the counters in 
> deferred_set reach zero.

Here I'm sending a proof-of-concept patch that makes it possible to 
prevent bios from coming into the thin pool when the pool is suspended. It 
doesn't modify any generic dm code.

This patch may not be perfect (I don't know all bio paths in dm-thin in 
detail, so I may have missed something), but it shows that it is possible 
to suspend all bios without modifying the common dm code. I hope Joe 
reviewes it and possibly fixes it.

The patch is for 3.18-rc3, it needs other thin patches, the full patch 
series is at 
http://people.redhat.com/~mpatocka/patches/kernel/dm-thin-suspend/series.html

Mikulas


Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-bio-prison.c |   29 +++++++++++++++++++++++++++
 drivers/md/dm-bio-prison.h |    3 ++
 drivers/md/dm-thin.c       |   47 +++++++++++++++++++++++++++++++++++++++++----
 3 files changed, 75 insertions(+), 4 deletions(-)

Index: linux-2.6/drivers/md/dm-thin.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin.c	2014-11-08 00:02:42.000000000 +0100
+++ linux-2.6/drivers/md/dm-thin.c	2014-11-08 00:02:42.000000000 +0100
@@ -194,6 +194,8 @@ struct pool {
 	struct dm_thin_new_mapping *next_mapping;
 	mempool_t *mapping_pool;
 
+	atomic_t suspended;
+
 	process_bio_fn process_bio;
 	process_bio_fn process_discard;
 
@@ -1532,6 +1534,9 @@ static void process_thin_deferred_bios(s
 		return;
 	}
 
+	if (unlikely(atomic_read(&pool->suspended)))
+		return;
+
 	bio_list_init(&bios);
 
 	spin_lock_irqsave(&tc->lock, flags);
@@ -1930,7 +1935,8 @@ static int thin_bio_map(struct dm_target
 		return DM_MAPIO_SUBMITTED;
 	}
 
-	if (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA)) {
+	if (bio->bi_rw & (REQ_DISCARD | REQ_FLUSH | REQ_FUA) ||
+	    unlikely(atomic_read(&tc->pool->suspended))) {
 		thin_defer_bio(tc, bio);
 		return DM_MAPIO_SUBMITTED;
 	}
@@ -1943,6 +1949,12 @@ static int thin_bio_map(struct dm_target
 	if (dm_bio_detain(tc->pool->prison, &key, bio, &cell1, &cell_result))
 		return DM_MAPIO_SUBMITTED;
 
+	if (unlikely(atomic_read(&tc->pool->suspended))) {
+		thin_defer_bio(tc, bio);
+		cell_defer_no_holder_no_free(tc, &cell1);
+		return DM_MAPIO_SUBMITTED;
+	}
+
 	r = dm_thin_find_block(td, block, 0, &result);
 
 	/*
@@ -2227,6 +2239,7 @@ static struct pool *pool_create(struct m
 	INIT_LIST_HEAD(&pool->prepared_discards);
 	INIT_LIST_HEAD(&pool->active_thins);
 	pool->low_water_triggered = false;
+	atomic_set(&pool->suspended, 1);
 
 	pool->shared_read_ds = dm_deferred_set_create();
 	if (!pool->shared_read_ds) {
@@ -2772,22 +2785,46 @@ static void pool_resume(struct dm_target
 	spin_lock_irqsave(&pool->lock, flags);
 	pool->low_water_triggered = false;
 	spin_unlock_irqrestore(&pool->lock, flags);
-	requeue_bios(pool);
 
-	do_waker(&pool->waker.work);
+	if (atomic_dec_and_test(&pool->suspended)) {
+		requeue_bios(pool);
+		do_waker(&pool->waker.work);
+	}
 }
 
-static void pool_postsuspend(struct dm_target *ti)
+static void pool_presuspend(struct dm_target *ti)
 {
 	struct pool_c *pt = ti->private;
 	struct pool *pool = pt->pool;
 
+	atomic_inc(&pool->suspended);
+
+	dm_drain_prison(pool->prison);
+
+	dm_drain_deferred_set(pool->shared_read_ds);
+	dm_drain_deferred_set(pool->all_io_ds);
+
 	cancel_delayed_work(&pool->waker);
 	cancel_delayed_work(&pool->no_space_timeout);
 	flush_workqueue(pool->wq);
+
+	/* ??? should this be before or after flush_workqueue ? */
+	dm_drain_deferred_set(pool->shared_read_ds);
+	dm_drain_deferred_set(pool->all_io_ds);
+
 	(void) commit(pool);
 }
 
+static void pool_presuspend_undo(struct dm_target *ti)
+{
+	pool_resume(ti);
+}
+
+static void pool_postsuspend(struct dm_target *ti)
+{
+	/* nothing */
+}
+
 static int check_arg_count(unsigned argc, unsigned args_required)
 {
 	if (argc != args_required) {
@@ -3218,6 +3255,8 @@ static struct target_type pool_target =
 	.ctr = pool_ctr,
 	.dtr = pool_dtr,
 	.map = pool_map,
+	.presuspend = pool_presuspend,
+	.presuspend_undo = pool_presuspend_undo,
 	.postsuspend = pool_postsuspend,
 	.preresume = pool_preresume,
 	.resume = pool_resume,
Index: linux-2.6/drivers/md/dm-bio-prison.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-bio-prison.c	2014-11-08 00:02:42.000000000 +0100
+++ linux-2.6/drivers/md/dm-bio-prison.c	2014-11-08 00:09:40.000000000 +0100
@@ -11,6 +11,7 @@
 #include <linux/mempool.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/delay.h>
 
 /*----------------------------------------------------------------*/
 
@@ -241,6 +242,18 @@ void dm_cell_error(struct dm_bio_prison
 }
 EXPORT_SYMBOL_GPL(dm_cell_error);
 
+void dm_drain_prison(struct dm_bio_prison *prison)
+{
+	spin_lock_irq(&prison->lock);
+	if (!RB_EMPTY_ROOT(&prison->cells)) {
+		spin_unlock_irq(&prison->lock);
+		msleep(1);
+		spin_lock_irq(&prison->lock);
+	}
+	spin_unlock_irq(&prison->lock);
+}
+EXPORT_SYMBOL_GPL(dm_drain_prison);
+
 /*----------------------------------------------------------------*/
 
 #define DEFERRED_SET_SIZE 64
@@ -354,6 +367,22 @@ int dm_deferred_set_add_work(struct dm_d
 }
 EXPORT_SYMBOL_GPL(dm_deferred_set_add_work);
 
+void dm_drain_deferred_set(struct dm_deferred_set *ds)
+{
+	int i;
+retry:
+	spin_lock_irq(&ds->lock);
+	for (i = 0; i < DEFERRED_SET_SIZE; i++) {
+		if (ds->entries[i].count) {
+			spin_unlock_irq(&ds->lock);
+			msleep(1);
+			goto retry;
+		}
+	}
+	spin_unlock_irq(&ds->lock);
+}
+EXPORT_SYMBOL_GPL(dm_drain_deferred_set);
+
 /*----------------------------------------------------------------*/
 
 static int __init dm_bio_prison_init(void)
Index: linux-2.6/drivers/md/dm-bio-prison.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-bio-prison.h	2014-11-08 00:02:42.000000000 +0100
+++ linux-2.6/drivers/md/dm-bio-prison.h	2014-11-08 00:02:42.000000000 +0100
@@ -87,6 +87,7 @@ void dm_cell_release_no_holder(struct dm
 			       struct bio_list *inmates);
 void dm_cell_error(struct dm_bio_prison *prison,
 		   struct dm_bio_prison_cell *cell, int error);
+void dm_drain_prison(struct dm_bio_prison *prison);
 
 /*----------------------------------------------------------------*/
 
@@ -107,6 +108,8 @@ struct dm_deferred_entry *dm_deferred_en
 void dm_deferred_entry_dec(struct dm_deferred_entry *entry, struct list_head *head);
 int dm_deferred_set_add_work(struct dm_deferred_set *ds, struct list_head *work);
 
+void dm_drain_deferred_set(struct dm_deferred_set *ds);
+
 /*----------------------------------------------------------------*/
 
 #endif
