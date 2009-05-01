From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 3 of 33] DM Snapshot: shot cleanup
Date: Fri, 1 May 2009 09:16:51 -0500
Message-ID: <200905011416.n41EGpF6028691@hydrogen.msp.redhat.com>
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

Patch name: dm-snapshot-cleanup.patch

From: Jonathan Brassow <jbrassow@redhat.com>

This patch applies on top of the previous 12 just to clean-up some
indenting and such.

 brassow

Indenting and formatting fixes after a long series of patches.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

---
 drivers/md/dm-snap-persistent.c |    4 ++--
 drivers/md/dm-snap.c            |   14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -519,7 +519,7 @@ static int persistent_read_metadata(stru
 	ps->exceptions_per_area = (ps->store->chunk_size << SECTOR_SHIFT) /
 				  sizeof(struct disk_exception);
 	ps->callbacks = dm_vcalloc(ps->exceptions_per_area,
-			sizeof(*ps->callbacks));
+				   sizeof(*ps->callbacks));
 	if (!ps->callbacks)
 		return -ENOMEM;
 
@@ -630,7 +630,7 @@ static void persistent_commit_exception(
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
@@ -364,7 +364,8 @@ static int init_exception_table(struct e
 	return 0;
 }
 
-static void exit_exception_table(struct exception_table *et, struct kmem_cache *mem)
+static void exit_exception_table(struct exception_table *et,
+				 struct kmem_cache *mem)
 {
 	struct list_head *slot;
 	struct dm_snap_exception *ex, *next;
@@ -668,8 +669,7 @@ static int snapshot_ctr(struct dm_target
 
 	s = kmalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
-		ti->error = "Cannot allocate snapshot context private "
-		    "structure";
+		ti->error = "Cannot allocate snapshot private structure";
 		r = -ENOMEM;
 		goto bad_snap;
 	}
@@ -959,7 +959,7 @@ static void pending_complete(struct dm_s
 	 */
 	insert_completed_exception(s, e);
 
- out:
+out:
 	remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
 	origin_bios = put_pending_exception(pe);
@@ -1022,7 +1022,7 @@ static void start_copy(struct dm_snap_pe
 
 	/* Hand over to kcopyd */
 	dm_kcopyd_copy(s->kcopyd_client,
-		    &src, 1, &dest, 0, copy_callback, pe);
+		       &src, 1, &dest, 0, copy_callback, pe);
 }
 
 static struct dm_snap_pending_exception *
@@ -1167,9 +1167,9 @@ static int snapshot_map(struct dm_target
 		map_context->ptr = track_chunk(s, chunk);
 	}
 
- out_unlock:
+out_unlock:
 	up_write(&s->lock);
- out:
+out:
 	return r;
 }
 
