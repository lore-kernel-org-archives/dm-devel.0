From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 3 of 12]:
	dm-exception-store-move-dm_target-pointer.patch
Date: Tue, 20 Jan 2009 13:53:26 -0600
Message-ID: <1232481206.19993.19.camel@hydrogen.msp.redhat.com>
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

Move target pointer from snapshot to exception store.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6.28/drivers/md/dm-exception-store.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-exception-store.c	2009-01-07 23:41:24.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-exception-store.c	2009-01-07 23:44:44.000000000 +0000
@@ -142,7 +142,7 @@ int dm_exception_store_type_unregister(s
 }
 EXPORT_SYMBOL(dm_exception_store_type_unregister);
 
-int dm_exception_store_create(const char *type_name,
+int dm_exception_store_create(const char *type_name, struct dm_target *ti,
 			      struct dm_exception_store **store)
 {
 	int r = 0;
@@ -160,6 +160,7 @@ int dm_exception_store_create(const char
 	}
 
 	tmp_store->type = type;
+	tmp_store->ti = ti;
 
 	r = type->ctr(tmp_store, 0, NULL);
 	if (r) {
Index: linux-2.6.28/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-exception-store.h	2009-01-07 23:41:24.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-exception-store.h	2009-01-07 23:44:10.000000000 +0000
@@ -95,6 +95,7 @@ struct dm_exception_store_type {
 
 struct dm_exception_store {
 	struct dm_exception_store_type *type;
+	struct dm_target *ti;
 
 	struct dm_snapshot *snap;
 
@@ -147,7 +148,7 @@ static inline void dm_consecutive_chunk_
 int dm_exception_store_type_register(struct dm_exception_store_type *type);
 int dm_exception_store_type_unregister(struct dm_exception_store_type *type);
 
-int dm_exception_store_create(const char *type_name,
+int dm_exception_store_create(const char *type_name, struct dm_target *ti,
 			      struct dm_exception_store **store);
 void dm_exception_store_destroy(struct dm_exception_store *store);
 
Index: linux-2.6.28/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.c	2009-01-07 23:41:24.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap.c	2009-01-07 23:45:16.000000000 +0000
@@ -615,7 +615,6 @@ static int snapshot_ctr(struct dm_target
 	atomic_set(&s->pending_exceptions_count, 0);
 	init_rwsem(&s->lock);
 	spin_lock_init(&s->pe_lock);
-	s->ti = ti;
 
 	/* Allocate hash table for COW data */
 	if (init_hash_tables(s)) {
@@ -624,7 +623,7 @@ static int snapshot_ctr(struct dm_target
 		goto bad3;
 	}
 
-	r = dm_exception_store_create(argv[2], &s->store);
+	r = dm_exception_store_create(argv[2], ti, &s->store);
 	if (r) {
 		ti->error = "Couldn't create exception store";
 		r = -EINVAL;
@@ -819,7 +818,7 @@ static void __invalidate_snapshot(struct
 
 	s->valid = 0;
 
-	dm_table_event(s->ti->table);
+	dm_table_event(s->store->ti->table);
 }
 
 static void get_pending_exception(struct dm_snap_pending_exception *pe)
@@ -1190,7 +1189,7 @@ static int __origin_write(struct list_he
 			goto next_snapshot;
 
 		/* Nothing to do if writing beyond end of snapshot */
-		if (bio->bi_sector >= dm_table_get_size(snap->ti->table))
+		if (bio->bi_sector >= dm_table_get_size(snap->store->ti->table))
 			goto next_snapshot;
 
 		/*
Index: linux-2.6.28/drivers/md/dm-snap.h
===================================================================
--- linux-2.6.28.orig/drivers/md/dm-snap.h	2009-01-07 23:41:38.000000000 +0000
+++ linux-2.6.28/drivers/md/dm-snap.h	2009-01-07 23:42:31.000000000 +0000
@@ -25,7 +25,6 @@ struct exception_table {
 
 struct dm_snapshot {
 	struct rw_semaphore lock;
-	struct dm_target *ti;
 
 	struct dm_dev *origin;
 	struct dm_dev *cow;
