From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 2 of 2] DM Snapshot:  drop unneeded and
Date: Wed, 23 Sep 2009 09:58:09 -0500
Message-ID: <200909231458.n8NEw9NZ027175@hydrogen.msp.redhat.com>
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

Patch name: dm-snapshot-drop-unneeded-and.patch

Removed unneeded 'and' masking --- right shift discards the lower bits anyway,
so there is no need to clear them.

This is also needed for the correctness of the following patch
dm-snapshot-32bit-chunk-size.patch, that makes chunk_mask 32-bit.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
Reviewed-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -162,7 +162,7 @@ static inline sector_t get_dev_size(stru
 static inline chunk_t sector_to_chunk(struct dm_exception_store *store,
 				      sector_t sector)
 {
-	return (sector & ~store->chunk_mask) >> store->chunk_shift;
+	return sector >> store->chunk_shift;
 }
 
 int dm_exception_store_type_register(struct dm_exception_store_type *type);
