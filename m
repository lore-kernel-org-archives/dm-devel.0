From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 22 of 29] dm-exception-store-add-shared_uuid.patch
Date: Tue, 17 Mar 2009 09:05:51 -0500
Message-ID: <200903171405.n2HE5pJs017501@hydrogen.msp.redhat.com>
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

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -96,6 +96,16 @@ struct dm_exception_store {
 
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
@@ -223,6 +223,7 @@ int dm_exception_store_create(const char
 
 	tmp_store->type = type;
 	tmp_store->ti = ti;
+	tmp_store->shared_uuid = 0;
 
 	/*
 	 * COW-dev and chunk_size are common to all types of
