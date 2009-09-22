From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 1 of 2] DM Snapshot:  minor style fixes
Date: Tue, 22 Sep 2009 16:17:21 -0500
Message-ID: <200909222117.n8MLHLf5008935@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-minor-style-fixes.patch

Coding style fixes only to dm-snap[-persistent].c

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -535,7 +535,7 @@ static int persistent_read_metadata(stru
 	ps->exceptions_per_area = (ps->store->chunk_size << SECTOR_SHIFT) /
 				  sizeof(struct disk_exception);
 	ps->callbacks = dm_vcalloc(ps->exceptions_per_area,
-			sizeof(*ps->callbacks));
+				   sizeof(*ps->callbacks));
 	if (!ps->callbacks)
 		return -ENOMEM;
 
@@ -646,7 +646,7 @@ static void persistent_commit_exception(
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
@@ -363,7 +363,8 @@ static int init_exception_table(struct e
 	return 0;
 }
 
-static void exit_exception_table(struct exception_table *et, struct kmem_cache *mem)
+static void exit_exception_table(struct exception_table *et,
+				 struct kmem_cache *mem)
 {
 	struct list_head *slot;
 	struct dm_snap_exception *ex, *next;
@@ -603,8 +604,7 @@ static int snapshot_ctr(struct dm_target
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
-		ti->error = "Cannot allocate snapshot context private "
-		    "structure";
+		ti->error = "Cannot allocate snapshot private structure";
 		r = -ENOMEM;
 		goto bad_snap;
 	}
@@ -896,7 +896,7 @@ static void pending_complete(struct dm_s
 	 */
 	insert_completed_exception(s, e);
 
- out:
+out:
 	remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
 	origin_bios = put_pending_exception(pe);
@@ -959,7 +959,7 @@ static void start_copy(struct dm_snap_pe
 
 	/* Hand over to kcopyd */
 	dm_kcopyd_copy(s->kcopyd_client,
-		    &src, 1, &dest, 0, copy_callback, pe);
+		       &src, 1, &dest, 0, copy_callback, pe);
 }
 
 static struct dm_snap_pending_exception *
@@ -1109,9 +1109,9 @@ static int snapshot_map(struct dm_target
 		map_context->ptr = track_chunk(s, chunk);
 	}
 
- out_unlock:
+out_unlock:
 	up_write(&s->lock);
- out:
+out:
 	return r;
 }
 
