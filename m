From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH]: dm-snapshot-cleanup.patch
Date: Tue, 20 Jan 2009 14:26:51 -0600
Message-ID: <1232483211.19993.52.camel@hydrogen.msp.redhat.com>
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

This patch applies on top of the previous 12 just to clean-up some
indenting and such.

 brassow

Indenting and formatting fixes after a long series of patches.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -509,7 +509,7 @@ static int persistent_read_metadata(stru
 	ps->exceptions_per_area = (ps->store->chunk_size << SECTOR_SHIFT) /
 				  sizeof(struct disk_exception);
 	ps->callbacks = dm_vcalloc(ps->exceptions_per_area,
-			sizeof(*ps->callbacks));
+				   sizeof(*ps->callbacks));
 	if (!ps->callbacks)
 		return -ENOMEM;
 
@@ -620,7 +620,7 @@ static void persistent_commit_exception(
 	 * If we completely filled the current area, then wipe the next one.
 	 */
 	if ((ps->current_committed == ps->exceptions_per_area) &&
-	     zero_disk_area(ps, ps->current_area + 1))
+	    zero_disk_area(ps, ps->current_area + 1))
 		ps->valid = 0;
 
 	/*
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -365,7 +365,8 @@ static int init_exception_table(struct e
 	return 0;
 }
 
-static void exit_exception_table(struct exception_table *et, struct kmem_cache *mem)
+static void exit_exception_table(struct exception_table *et,
+				 struct kmem_cache *mem)
 {
 	struct list_head *slot;
 	struct dm_snap_exception *ex, *next;
@@ -588,8 +589,8 @@ static int init_hash_tables(struct dm_sn
  * Returns: 0 on success, -Exxx on error
  */
 static int create_exception_store(struct dm_target *ti, unsigned argc,
-                                 char **argv, unsigned *args_used,
-                                 struct dm_exception_store **store)
+				  char **argv, unsigned *args_used,
+				  struct dm_exception_store **store)
 {
 	unsigned param_count;
 	char *tmp_argv[2];
@@ -667,8 +668,7 @@ static int snapshot_ctr(struct dm_target
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
-		ti->error = "Cannot allocate snapshot context private "
-		    "structure";
+		ti->error = "Cannot allocate snapshot private structure";
 		r = -ENOMEM;
 		goto bad_snap;
 	}
@@ -719,7 +719,8 @@ static int snapshot_ctr(struct dm_target
 	spin_lock_init(&s->tracked_chunk_lock);
 
 	/* Metadata must only be loaded into one table at once */
-	r = s->store->type->read_metadata(s->store, dm_add_exception, (void *)s);
+	r = s->store->type->read_metadata(s->store, dm_add_exception,
+					  (void *)s);
 	if (r < 0) {
 		ti->error = "Failed to read snapshot metadata";
 		goto bad_load_and_register;
@@ -957,7 +958,7 @@ static void pending_complete(struct dm_s
 	 */
 	insert_completed_exception(s, e);
 
- out:
+out:
 	remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
 	origin_bios = put_pending_exception(pe);
@@ -1020,7 +1021,7 @@ static void start_copy(struct dm_snap_pe
 
 	/* Hand over to kcopyd */
 	dm_kcopyd_copy(s->kcopyd_client,
-		    &src, 1, &dest, 0, copy_callback, pe);
+		       &src, 1, &dest, 0, copy_callback, pe);
 }
 
 /*
@@ -1083,7 +1084,7 @@ __find_pending_exception(struct dm_snaps
 	get_pending_exception(pe);
 	insert_exception(&s->pending, &pe->e);
 
- out:
+out:
 	return pe;
 }
 
@@ -1091,8 +1092,9 @@ static void remap_exception(struct dm_sn
 			    struct bio *bio, chunk_t chunk)
 {
 	bio->bi_bdev = s->store->cow->bdev;
-	bio->bi_sector = chunk_to_sector(s->store, dm_chunk_number(e->new_chunk) +
-			 (chunk - e->old_chunk)) +
+	bio->bi_sector = chunk_to_sector(s->store,
+					 dm_chunk_number(e->new_chunk) +
+					 (chunk - e->old_chunk)) +
 			 (bio->bi_sector & s->store->chunk_mask);
 }
 
@@ -1158,9 +1160,9 @@ static int snapshot_map(struct dm_target
 		map_context->ptr = track_chunk(s, chunk);
 	}
 
- out_unlock:
+out_unlock:
 	up_write(&s->lock);
- out:
+out:
 	return r;
 }
 
@@ -1300,7 +1302,7 @@ static int __origin_write(struct list_he
 			list_add_tail(&pe->list, &pe_queue);
 		}
 
- next_snapshot:
+	next_snapshot:
 		up_write(&snap->lock);
 	}
 
