From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3.10,3.12] dm: flush queued bios when process blocks to avoid
 deadlock
Date: Wed, 15 Mar 2017 16:28:51 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1703151627140.1934@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, Willy Tarreau <w@1wt.eu>
Cc: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is backport of upstream commit 
d67a5f4b5947aba4bfe9a80a2b86079c215ca755. It is suitable for stable 
branches 3.10 and 3.12.

Mikulas


commit d67a5f4b5947aba4bfe9a80a2b86079c215ca755
Author: Mikulas Patocka <mpatocka@redhat.com>
Date:   Wed Feb 15 11:26:10 2017 -0500

    dm: flush queued bios when process blocks to avoid deadlock
    
    Commit df2cb6daa4 ("block: Avoid deadlocks with bio allocation by
    stacking drivers") created a workqueue for every bio set and code
    in bio_alloc_bioset() that tries to resolve some low-memory deadlocks
    by redirecting bios queued on current->bio_list to the workqueue if the
    system is low on memory.  However other deadlocks (see below **) may
    happen, without any low memory condition, because generic_make_request
    is queuing bios to current->bio_list (rather than submitting them).
    
    ** the related dm-snapshot deadlock is detailed here:
    https://www.redhat.com/archives/dm-devel/2016-July/msg00065.html
    
    Fix this deadlock by redirecting any bios on current->bio_list to the
    bio_set's rescue workqueue on every schedule() call.  Consequently,
    when the process blocks on a mutex, the bios queued on
    current->bio_list are dispatched to independent workqueus and they can
    complete without waiting for the mutex to be available.
    
    The structure blk_plug contains an entry cb_list and this list can contain
    arbitrary callback functions that are called when the process blocks.
    To implement this fix DM (ab)uses the onstack plug's cb_list interface
    to get its flush_current_bio_list() called at schedule() time.
    
    This fixes the snapshot deadlock - if the map method blocks,
    flush_current_bio_list() will be called and it redirects bios waiting
    on current->bio_list to appropriate workqueues.
    
    Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1267650
    Depends-on: df2cb6daa4 ("block: Avoid deadlocks with bio allocation by stacking drivers")
    Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
    Signed-off-by: Mike Snitzer <snitzer@redhat.com>

---
 drivers/md/dm.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

Index: linux-stable/drivers/md/dm.c
===================================================================
--- linux-stable.orig/drivers/md/dm.c
+++ linux-stable/drivers/md/dm.c
@@ -1075,11 +1075,62 @@ int dm_set_target_max_io_len(struct dm_t
 }
 EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
 
+/*
+ * Flush current->bio_list when the target map method blocks.
+ * This fixes deadlocks in snapshot and possibly in other targets.
+ */
+struct dm_offload {
+	struct blk_plug plug;
+	struct blk_plug_cb cb;
+};
+
+static void flush_current_bio_list(struct blk_plug_cb *cb, bool from_schedule)
+{
+	struct dm_offload *o = container_of(cb, struct dm_offload, cb);
+	struct bio_list list;
+	struct bio *bio;
+
+	INIT_LIST_HEAD(&o->cb.list);
+
+	if (unlikely(!current->bio_list))
+		return;
+
+	list = *current->bio_list;
+	bio_list_init(current->bio_list);
+
+	while ((bio = bio_list_pop(&list))) {
+		struct bio_set *bs = bio->bi_pool;
+		if (unlikely(!bs) || bs == fs_bio_set) {
+			bio_list_add(current->bio_list, bio);
+			continue;
+		}
+
+		spin_lock(&bs->rescue_lock);
+		bio_list_add(&bs->rescue_list, bio);
+		queue_work(bs->rescue_workqueue, &bs->rescue_work);
+		spin_unlock(&bs->rescue_lock);
+	}
+}
+
+static void dm_offload_start(struct dm_offload *o)
+{
+	blk_start_plug(&o->plug);
+	o->cb.callback = flush_current_bio_list;
+	list_add(&o->cb.list, &current->plug->cb_list);
+}
+
+static void dm_offload_end(struct dm_offload *o)
+{
+	list_del(&o->cb.list);
+	blk_finish_plug(&o->plug);
+}
+
 static void __map_bio(struct dm_target_io *tio)
 {
 	int r;
 	sector_t sector;
 	struct mapped_device *md;
+	struct dm_offload o;
 	struct bio *clone = &tio->clone;
 	struct dm_target *ti = tio->ti;
 
@@ -1093,7 +1144,11 @@ static void __map_bio(struct dm_target_i
 	 */
 	atomic_inc(&tio->io->io_count);
 	sector = clone->bi_sector;
+
+	dm_offload_start(&o);
 	r = ti->type->map(ti, clone);
+	dm_offload_end(&o);
+
 	if (r == DM_MAPIO_REMAPPED) {
 		/* the bio has been remapped so dispatch it */
 
