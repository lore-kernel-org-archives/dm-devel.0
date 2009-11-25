From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 1] dm raid1 fix cluster mirror corruption
	scenario
Date: Wed, 25 Nov 2009 11:58:01 -0600
Message-ID: <200911251758.nAPHw1nI030560@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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

Patch name: dm-raid1-fix-cluster-mirror-corruption-scenario.patch

This patch fixes a potential corruption issue in DM mirrors.

What Produces:  Failure of any leg + suspend/resume cycle
What is affected:  Cluster mirrors

Description:
After a leg fails and a write returns, '__bio_mark_nosync' is used to mark
the region out-of-sync.  This state is stored in a region structure that
remains in the region hash.  It is not removed from the region hash until
the mirror is destroyed because it never goes on the clean_regions list.
Right now, this is not a problem because when a device fails, the mirror is
destroyed and a new mirror is created w/o the failed device.  In the future,
when we wish to handle transient failures, we would simply suspend and resume
to restart recovery.  In that case, some machines in the cluster would only
write to the primary for regions that are cached as not-in-sync - due to the
'__bio_mark_nosync'.  The fix is to simply clear out the region hash when a
mirror is suspended.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid1.c
+++ linux-2.6/drivers/md/dm-raid1.c
@@ -1209,6 +1209,12 @@ static void mirror_postsuspend(struct dm
 	struct mirror_set *ms = ti->private;
 	struct dm_dirty_log *log = dm_rh_dirty_log(ms->rh);
 
+	/*
+	 * Clear the region cache to prevent stale information
+	 * on the next resume.
+	 */
+	dm_region_hash_clear(ms->rh);
+
 	if (log->type->postsuspend && log->type->postsuspend(log))
 		/* FIXME: need better error handling */
 		DMWARN("log postsuspend failed");
Index: linux-2.6/drivers/md/dm-region-hash.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-region-hash.c
+++ linux-2.6/drivers/md/dm-region-hash.c
@@ -224,7 +224,7 @@ struct dm_region_hash *dm_region_hash_cr
 }
 EXPORT_SYMBOL_GPL(dm_region_hash_create);
 
-void dm_region_hash_destroy(struct dm_region_hash *rh)
+void dm_region_hash_clear(struct dm_region_hash *rh)
 {
 	unsigned h;
 	struct dm_region *reg, *nreg;
@@ -237,6 +237,12 @@ void dm_region_hash_destroy(struct dm_re
 			mempool_free(reg, rh->region_pool);
 		}
 	}
+}
+EXPORT_SYMBOL_GPL(dm_region_hash_clear);
+
+void dm_region_hash_destroy(struct dm_region_hash *rh)
+{
+	dm_region_hash_clear(rh);
 
 	if (rh->log)
 		dm_dirty_log_destroy(rh->log);
Index: linux-2.6/include/linux/dm-region-hash.h
===================================================================
--- linux-2.6.orig/include/linux/dm-region-hash.h
+++ linux-2.6/include/linux/dm-region-hash.h
@@ -29,7 +29,7 @@ enum dm_rh_region_states {
 };
 
 /*
- * Region hash create/destroy.
+ * Region hash create/clear/destroy.
  */
 struct bio_list;
 struct dm_region_hash *dm_region_hash_create(
@@ -40,6 +40,7 @@ struct dm_region_hash *dm_region_hash_cr
 		sector_t target_begin, unsigned max_recovery,
 		struct dm_dirty_log *log, uint32_t region_size,
 		region_t nr_regions);
+void dm_region_hash_clear(struct dm_region_hash *rh);
 void dm_region_hash_destroy(struct dm_region_hash *rh);
 
 struct dm_dirty_log *dm_rh_dirty_log(struct dm_region_hash *rh);
