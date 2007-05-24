From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [RFC] dm-raid1-mark-and-clear-nosync-writes.patch
Date: Thu, 24 May 2007 15:30:58 -0500
Message-ID: <1180038658.25041.28.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

This is an enabler patch for cluster mirroring.

Mirroring can be used in a cluster if the log is cluster-aware.
However, to properly handle write/recovery conflicts from different
machines we must mark and clear regions that are in the RH_NOSYNC state.

This patch adds that capability.  However, it is possible to get a
situation where a "double mark" happens on a region:
1) mark region in rh_inc
2) rh_dec decrements pending count
3) mark before clear (rh_inc runs before rh_update_states)
The double mark isn't really a problem and is already handled by the
currently logging implementations... but it isn't something that has
happened before.

Comments welcome,
 brassow

Index: linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
@@ -425,8 +425,8 @@ static void rh_update_states(struct regi
 	 * any more locking.
 	 */
 	list_for_each_entry_safe (reg, next, &recovered, list) {
-		rh->log->type->clear_region(rh->log, reg->key);
 		complete_resync_work(reg, 1);
+		rh->log->type->clear_region(rh->log, reg->key);
 		mempool_free(reg, rh->region_pool);
 	}
 
@@ -448,13 +448,14 @@ static void rh_update_states(struct regi
 
 static void rh_inc(struct region_hash *rh, region_t region)
 {
+	int r;
 	struct region *reg;
 
 	read_lock(&rh->hash_lock);
 	reg = __rh_find(rh, region);
 
 	spin_lock_irq(&rh->region_lock);
-	atomic_inc(&reg->pending);
+	r = atomic_inc_return(&reg->pending);
 
 	if (reg->state == RH_CLEAN) {
 		reg->state = RH_DIRTY;
@@ -462,6 +463,11 @@ static void rh_inc(struct region_hash *r
 		spin_unlock_irq(&rh->region_lock);
 
 		rh->log->type->mark_region(rh->log, reg->key);
+	} else if ((reg->state == RH_NOSYNC) && (r == 1)) {
+		list_del_init(&reg->list);	/* take off the clean list */
+		spin_unlock_irq(&rh->region_lock);
+
+		rh->log->type->mark_region(rh->log, reg->key);
 	} else
 		spin_unlock_irq(&rh->region_lock);
 
@@ -493,20 +499,16 @@ static void rh_dec(struct region_hash *r
 		 * There is no pending I/O for this region.
 		 * We can move the region to corresponding list for next action.
 		 * At this point, the region is not yet connected to any list.
-		 *
-		 * If the state is RH_NOSYNC, the region should be kept off
-		 * from clean list.
-		 * The hash entry for RH_NOSYNC will remain in memory
-		 * until the region is recovered or the map is reloaded.
 		 */
 
-		/* do nothing for RH_NOSYNC */
 		if (reg->state == RH_RECOVERING) {
 			list_add_tail(&reg->list, &rh->quiesced_regions);
 		} else if (reg->state == RH_DIRTY) {
 			reg->state = RH_CLEAN;
 			list_add(&reg->list, &rh->clean_regions);
-		}
+		} else if (reg->state == RH_NOSYNC)
+			list_add(&reg->list, &rh->clean_regions);
+
 		should_wake = 1;
 	}
 	spin_unlock_irqrestore(&rh->region_lock, flags);
Index: linux-2.6.22-rc1-mm1/drivers/md/dm-log.c
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-log.c
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-log.c
@@ -579,7 +579,10 @@ static void core_mark_region(struct dirt
 static void core_clear_region(struct dirty_log *log, region_t region)
 {
 	struct log_c *lc = (struct log_c *) log->context;
-	log_set_bit(lc, lc->clean_bits, region);
+
+	/* Only clear the region if it is also in sync */
+	if (log_test_bit(lc->sync_bits, region))
+		log_set_bit(lc, lc->clean_bits, region);
 }
 
 static int core_get_resync_work(struct dirty_log *log, region_t *region)
Index: linux-2.6.22-rc1-mm1/drivers/md/dm-log.h
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-log.h
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-log.h
@@ -72,6 +72,9 @@ struct dirty_log_type {
 	 * block, though for performance reasons blocking should
 	 * be extremely rare (eg, allocating another chunk of
 	 * memory for some reason).
+	 *
+	 * clear_region will only clear the region if it
+	 * is also in-sync.
 	 */
 	void (*mark_region)(struct dirty_log *log, region_t region);
 	void (*clear_region)(struct dirty_log *log, region_t region);
