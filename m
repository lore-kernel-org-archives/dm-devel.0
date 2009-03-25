From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 25 of 33] DM Exception Store:  add shared_uuid
Date: Wed, 25 Mar 2009 16:37:47 -0500
Message-ID: <200903252137.n2PLblqg022419@hydrogen.msp.redhat.com>
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

Patch name: dm-exception-store-add-shared_uuid.patch

This patch adds the shared_uuid to the dm_exception_store structure.
Exception store implementations can set this to a unique non-zero
value if they wish to express that the back-end is optimized for
sharing.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -97,6 +97,16 @@ struct dm_exception_store {
 
 	struct dm_dev *cow;
 
+	/*
+	 * If the underlying exception store implementation is shared,
+	 * it can set 'shared_uuid' to identify which 'dm_exception_store's
+	 * share the same underlying implementation specific store.
+	 *
+	 * The user can use this ID to consolidate work/structures in
+	 * the upper layers.
+	 */
+	uint64_t shared_uuid;
+
 	/* Size of data blocks saved - must be a power of 2 */
 	chunk_t chunk_size;
 	chunk_t chunk_mask;
Index: linux-2.6/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.c
+++ linux-2.6/drivers/md/dm-exception-store.c
@@ -218,6 +218,7 @@ int dm_exception_store_create(const char
 
 	tmp_store->type = type;
 	tmp_store->ti = ti;
+	tmp_store->shared_uuid = 0;
 
 	/*
 	 * COW-dev and chunk_size are common to all types of
