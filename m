From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] DM Exception Store: return zero when empty
Date: Wed, 23 Sep 2009 10:24:58 -0500
Message-ID: <200909231524.n8NFOw03029884@hydrogen.msp.redhat.com>
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
Cc: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

Patch name: dm-exception-store-return-zero-when-empty.patch

When the snapshot is empty, return 0 as the number of allocated sectors.
This will be needed to properly notify userspace that merging is finished.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -492,8 +492,12 @@ static struct pstore *get_info(struct dm
 static void persistent_fraction_full(struct dm_exception_store *store,
 				     sector_t *numerator, sector_t *denominator)
 {
-	*numerator = get_info(store)->next_free * store->chunk_size;
-	*denominator = get_dev_size(store->cow->bdev);
+	/*
+	 * Compensate for the first two chunks that are always allocated.
+	 * Make sure that we return 0 when there are no exceptions.
+	 */
+	*numerator = (get_info(store)->next_free - 2) * store->chunk_size;
+	*denominator = get_dev_size(store->cow->bdev) - 2 * store->chunk_size;
 }
 
 static void persistent_dtr(struct dm_exception_store *store)
