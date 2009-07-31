From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [RFC] Optimize ROW snapshot writes
Date: Fri, 31 Jul 2009 17:33:57 -0500
Message-ID: <1249079637.15327.5.camel@hydrogen.msp.redhat.com>
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

If a write to a snapshot will cover an entire chunk, then there is no
reason to copy the chunk from the origin first.  This can give a 2x
speedup in write performance to snapshots.

Be warned though, I did a quick test on this patch using 'dd' to perform
writes smaller than the size of a chunk or offset into a chunk, and
bio->bi_size was always 4096 anyway and always aligned on a chunk
boundary.  I don't know if this was the application or the kernel, but
if not done write this could be a security hole.  (Because old contents
from the snapshot device could be read if not overwritten by a copy if
necessary.)

 brassow

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -85,6 +85,9 @@ struct dm_snapshot {
 	/* The on disk metadata handler */
 	struct dm_exception_store *store;
 
+	struct work_struct skip_copy;
+	struct list_head skip_copy_list;
+
 	struct dm_kcopyd_client *kcopyd_client;
 
 	/* Queue of snapshot writes for ksnapd to flush */
@@ -127,6 +130,11 @@ struct dm_snap_pending_exception {
 
 	/*
 	 * Short-term queue of pending exceptions prior to submission.
+	 *
+	 * *or* part of list of exceptions whose copy can be skipped.
+	 * We can do this because pe->started gets set before adding
+	 * this to the skip_copy_list, so it will never interfer with
+	 * the nominal use in __origin_write.
 	 */
 	struct list_head list;
 
@@ -572,6 +580,7 @@ static int init_hash_tables(struct dm_sn
 /*
  * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
  */
+static void skip_copy(struct work_struct *work);
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	struct dm_snapshot *s;
@@ -622,6 +631,9 @@ static int snapshot_ctr(struct dm_target
 	init_rwsem(&s->lock);
 	spin_lock_init(&s->pe_lock);
 
+	INIT_WORK(&s->skip_copy, skip_copy);
+	INIT_LIST_HEAD(&s->skip_copy_list);
+
 	/* Allocate hash table for COW data */
 	if (init_hash_tables(s)) {
 		ti->error = "Unable to allocate hash table space";
@@ -937,6 +949,19 @@ static void copy_callback(int read_err, 
 						 commit_callback, pe);
 }
 
+static void skip_copy(struct work_struct *work)
+{
+	struct dm_snap_pending_exception *pe, *n;
+	struct dm_snapshot *s = container_of(work, struct dm_snapshot, skip_copy);
+
+	list_for_each_entry_safe(pe, n, &s->skip_copy_list, list) {
+		list_del_init(&pe->list);
+
+		s->store->type->commit_exception(s->store, &pe->e,
+						 commit_callback, pe);
+	}
+}
+
 /*
  * Dispatches the copy operation to kcopyd.
  */
@@ -1097,13 +1122,26 @@ static int snapshot_map(struct dm_target
 
 		r = DM_MAPIO_SUBMITTED;
 
-		if (!pe->started) {
-			/* this is protected by snap->lock */
-			pe->started = 1;
+		if (pe->started)
+			goto out_unlock;
+		pe->started = 1;
+
+		/*
+		 * If the bio would overwrite the entire chunk anyway,
+		 * then there is no need to copy the origin contents
+		 * to it first.
+		 */
+		if (!(bio->bi_sector & s->store->chunk_mask) &&
+		    (bio->bi_size >= (s->store->chunk_size << 9))) {
+			list_add(&pe->list, &s->skip_copy_list);
+			up_write(&s->lock);
+			schedule_work(&s->skip_copy);
+		} else {
 			up_write(&s->lock);
 			start_copy(pe);
-			goto out;
 		}
+
+		goto out;
 	} else {
 		bio->bi_bdev = s->origin->bdev;
 		map_context->ptr = track_chunk(s, chunk);
