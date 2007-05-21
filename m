From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc1-mm1 PATCH 1/10]
	dm-raid1-handle_resync_failures.patch
Date: Mon, 21 May 2007 16:59:18 -0500
Message-ID: <1179784758.13913.17.camel@hydrogen.msp.redhat.com>
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

 brassow

We used to take a best effort approach to recovery - failures during
a resync were completely ignored.  This meant that regions where
marked 'in-sync' and 'clean' and removed from the hash list.  Future
reads and writes that query the region would incorrectly interpret the
region as in-sync.

This patch handles failures during the recovery process.  If a failure
occurs, the region is marked as 'not-in-sync' (aka RH_NOSYNC) and added
to a new list 'failed_recovered_regions'.

Regions on the 'failed_recovered_regions' list are not marked as 'clean'
upon removal from the list.  Furthermore, if the DM_RAID1_HANDLE_ERRORS
flag is set, the region is marked as 'not-in-sync'.  This action prevents
any future read-balancing from choosing an invalid device because of the
'not-in-sync' status.

Note that if the DM_RAID1_HANDLE_ERRORS flag is not present, the region
will still be marked 'in-sync' (although it remains 'dirty').  This is
to preserve backwards compatibility with user-space tools, such as
'pvmove'.  However, since future read-balancing policies will rely on
the correct sync status of a region, you can not simultaneously have
read-balancing and not have the DM_FEATURE_HANDLE_ERRORS flag.  This
has been noted in a comment.
Index: linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.22-rc1-mm1.orig/drivers/md/dm-raid1.c
+++ linux-2.6.22-rc1-mm1/drivers/md/dm-raid1.c
@@ -85,6 +85,7 @@ struct region_hash {
 	struct list_head clean_regions;
 	struct list_head quiesced_regions;
 	struct list_head recovered_regions;
+	struct list_head failed_recovered_regions;
 };
 
 enum {
@@ -204,6 +205,7 @@ static int rh_init(struct region_hash *r
 	INIT_LIST_HEAD(&rh->clean_regions);
 	INIT_LIST_HEAD(&rh->quiesced_regions);
 	INIT_LIST_HEAD(&rh->recovered_regions);
+	INIT_LIST_HEAD(&rh->failed_recovered_regions);
 
 	rh->region_pool = mempool_create_kmalloc_pool(MIN_REGIONS,
 						      sizeof(struct region));
@@ -368,6 +370,7 @@ static void rh_update_states(struct regi
 
 	LIST_HEAD(clean);
 	LIST_HEAD(recovered);
+	LIST_HEAD(failed_recovered);
 
 	/*
 	 * Quickly grab the lists.
@@ -389,6 +392,15 @@ static void rh_update_states(struct regi
 		list_for_each_entry (reg, &recovered, list)
 			list_del(&reg->hash_list);
 	}
+
+	if (!list_empty(&rh->failed_recovered_regions)) {
+		list_splice(&rh->failed_recovered_regions, &failed_recovered);
+		INIT_LIST_HEAD(&rh->failed_recovered_regions);
+
+		list_for_each_entry (reg, &failed_recovered, list)
+			list_del(&reg->hash_list);
+	}
+
 	spin_unlock(&rh->region_lock);
 	write_unlock_irq(&rh->hash_lock);
 
@@ -403,6 +415,14 @@ static void rh_update_states(struct regi
 		mempool_free(reg, rh->region_pool);
 	}
 
+	list_for_each_entry_safe (reg, next, &failed_recovered, list) {
+		if (rh->ms->features & DM_RAID1_HANDLE_ERRORS)
+			complete_resync_work(reg, 0);
+		else
+			complete_resync_work(reg, 1);
+		mempool_free(reg, rh->region_pool);
+	}
+
 	list_for_each_entry_safe (reg, next, &clean, list) {
 		rh->log->type->clear_region(rh->log, reg->key);
 		mempool_free(reg, rh->region_pool);
@@ -555,13 +575,17 @@ static struct region *rh_recovery_start(
 	return reg;
 }
 
-/* FIXME: success ignored for now */
 static void rh_recovery_end(struct region *reg, int success)
 {
 	struct region_hash *rh = reg->rh;
 
 	spin_lock_irq(&rh->region_lock);
-	list_add(&reg->list, &reg->rh->recovered_regions);
+	if (success)
+		list_add(&reg->list, &reg->rh->recovered_regions);
+	else {
+		reg->state = RH_NOSYNC;
+		list_add(&reg->list, &reg->rh->failed_recovered_regions);
+	}
 	spin_unlock_irq(&rh->region_lock);
 
 	wake(rh->ms);
@@ -633,7 +657,14 @@ static void recovery_complete(int read_e
 {
 	struct region *reg = (struct region *) context;
 
-	/* FIXME: better error handling */
+	if (read_err)
+		/* Read error means the failure of default mirror. */
+		DMERR_LIMIT("Unable to read primary mirror during recovery");
+
+	if (write_err)
+		DMERR_LIMIT("Write error during recovery (error = 0x%x)",
+			    write_err);
+
 	rh_recovery_end(reg, !(read_err || write_err));
 }
 
@@ -1145,6 +1176,15 @@ static int mirror_ctr(struct dm_target *
 	argv += args_used;
 	argc -= args_used;
 
+	/*
+	 * Note:  Any read-balancing addition depends on the
+	 *        DM_RAID1_HANDLE_ERRORS flag being present.
+	 *        This is because the decision to balance depends
+	 *        on the sync state of a region.  If the above
+	 *        flag is not present, we ignore errors; and
+	 *        the sync state may not properly be reflected.
+	 */
+
 	if (argc) {
 		ti->error = "Too many mirror arguments";
 		free_context(ms, ti, ms->nr_mirrors);
