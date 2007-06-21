From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc4-mm2 PATCH 11/11]
	dm-raid1-mark-and-clear-nosync-writes.patch
Date: Thu, 21 Jun 2007 16:11:13 -0500
Message-ID: <1182460273.13518.37.camel@hydrogen.msp.redhat.com>
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
To: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

 brassow

Upstream Status
===============
RFC dm-devel post:
https://www.redhat.com/archives/dm-devel/2007-May/msg00113.html

Overview
========
This patch causes writes to non-sync'ed mirror regions to be
marked and cleared in the log.

During normal mirror operation (i.e. when the devices are
in-sync), a write is preceded by marking the log and is
followed by clearing the log.  However, when the mirror is
in recovery, the marks and clears are not performed.

For single machine mirroring, this is fine; because the
mirroring code can control conflicts between writes and
re-syncing via the region hashing code.  However, this
is not possible in a cluster.  If a remote machine does not
mark the log for a non-sync'ed write, it is impossible
to tell when/if there will be a conflict with the re-syncing
process.

When this patch is added, the (cluster) logging code can
avoid handing out re-sync work that might conflict with an
outstanding write.  It can also delay writes briefly to
a region that is being resync'ed.

Details
=======
We must change the way clear_region works in order to
implement this correctly.  If a clear_region() is done
on a region that is not in-sync, the logging code should
not clear the bit.  This is because the clean_bits are
written to disk at flush/shutdown time; and might lead
to regions being erroneously interpretted as in-sync the
next time the mirror is activated.  So, we do not set
the clean_bit if the region is not also in-sync.

Given the above change, when recovery is finished, we
can no longer do:
1) clear_region()
2) complete_resync_work()
It must be the other way around or the region will not
actually be cleared.

complete_resync_work() dispatches writes waiting for
recovery to finish.  The writes are processed later by
the same thread which calls complete_resync_work, so we
do not have to worry about the introduction of a race
between the recently move clear_region call and a
mark_region call done by the dispatched writes.

When marking a region which is not in-sync in rh_inc,
we check the (write) pending count to avoid marking
a region after it has been already marked.  There is,
however, a case where multiple marks can happen
before a clear is performed:
THREAD1:1) do_writes -> rh_inc (mark region)
THREAD1:2) rh_update_states
THREAD2:1) rh_dec (dec pending and put on clean list)
THREAD1:3) do_writes -> rh_inc (second mark)
This type of event is already properly handled by
the logging code.  [THREAD1:3 also shows why it is
important to do the list_del_init(&reg->list) in rh_inc
when marking a region not in-sync.]

This patch is necessary to satisfy cluster mirroring
requirements.  However, it affects common code.  The
performance implications should be negligible, given
the unrestricted flow of recovery happening during
the time when this patch has any effect (when regions
are not in-sync).  Additionally, the changes provided
by this patch can allow for various optimizations
during recovery.  [In the case of cluster mirroring,
recovery "works around" the areas that are being
used for normal I/O.]

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc4-mm2/drivers/md/dm-raid1.c
@@ -426,8 +426,8 @@ static void rh_update_states(struct regi
 	 * any more locking.
 	 */
 	list_for_each_entry_safe (reg, next, &recovered, list) {
-		rh->log->type->clear_region(rh->log, reg->key);
 		complete_resync_work(reg, 1);
+		rh->log->type->clear_region(rh->log, reg->key);
 		mempool_free(reg, rh->region_pool);
 	}
 
@@ -446,13 +446,14 @@ static void rh_update_states(struct regi
 
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
@@ -460,6 +461,11 @@ static void rh_inc(struct region_hash *r
 		spin_unlock_irq(&rh->region_lock);
 
 		rh->log->type->mark_region(rh->log, reg->key);
+	} else if ((reg->state == RH_NOSYNC) && (r == 1)) {
+		list_del_init(&reg->list);	/* take off the clean list */
+		spin_unlock_irq(&rh->region_lock);
+
+		rh->log->type->mark_region(rh->log, reg->key);
 	} else
 		spin_unlock_irq(&rh->region_lock);
 
@@ -491,20 +497,16 @@ static void rh_dec(struct region_hash *r
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
Index: linux-2.6.22-rc4-mm2/drivers/md/dm-log.c
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/md/dm-log.c
+++ linux-2.6.22-rc4-mm2/drivers/md/dm-log.c
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
Index: linux-2.6.22-rc4-mm2/drivers/md/dm-log.h
===================================================================
--- linux-2.6.22-rc4-mm2.orig/drivers/md/dm-log.h
+++ linux-2.6.22-rc4-mm2/drivers/md/dm-log.h
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
