From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [2.6.22-rc1-mm1 PATCH]
	dm-raid1-clear-region-outside-spinlock.patch
Date: Mon, 21 May 2007 11:25:50 -0500
Message-ID: <1179764750.13913.3.camel@hydrogen.msp.redhat.com>
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

From drivers/md/dm-log.h:
        /*
         * Mark an area as clean or dirty.  These functions may
         * block, though for performance reasons blocking should
         * be extremely rare (eg, allocating another chunk of
         * memory for some reason).
         */
        void (*mark_region)(struct dirty_log *log, region_t region);
        void (*clear_region)(struct dirty_log *log, region_t region);

These function rarely block, but they could.  Would be a good idea
to move the clear_region call in rh_update_states outside the
spin lock.

Index: linux-2.6.21-mm1/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.21-mm1.orig/drivers/md/dm-raid1.c
+++ linux-2.6.21-mm1/drivers/md/dm-raid1.c
@@ -378,10 +378,8 @@ static void rh_update_states(struct regi
 		list_splice(&rh->clean_regions, &clean);
 		INIT_LIST_HEAD(&rh->clean_regions);
 
-		list_for_each_entry (reg, &clean, list) {
-			rh->log->type->clear_region(rh->log, reg->key);
+		list_for_each_entry (reg, &clean, list)
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
+	list_for_each_entry_safe (reg, next, &clean, list) {
+		rh->log->type->clear_region(rh->log, reg->key);
 		mempool_free(reg, rh->region_pool);
+	}
+
+	rh->log->type->flush(rh->log);
 }
 
 static void rh_inc(struct region_hash *rh, region_t region)
