From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] a fix for the snapshot deadlock
Date: Wed, 15 Feb 2017 11:26:10 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1702151120080.5572@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, Zdenek Kabelac <zkabelac@redhat.com>
List-Id: dm-devel.ids

Hi

The structure blk_plug contains an entry cb_list and this list can contain 
arbitrary callback functions that are called when the process blocks.

So, if the upstream developers don't allow us to add anything into the 
schedule() function, we can use this cb_list hack to get our function 
called at schedule().

This fixes the snapshot deadlock - if the map method blocks, 
flush_current_bio_list will be called and it redirects bios waiting on 
current->bio_list to apropriate workqueues.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -972,10 +972,61 @@ void dm_accept_partial_bio(struct bio *b
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
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
+	struct dm_offload o;
 	struct bio *clone = &tio->clone;
 	struct dm_target *ti = tio->ti;
 
@@ -988,7 +1039,11 @@ static void __map_bio(struct dm_target_i
 	 */
 	atomic_inc(&tio->io->io_count);
 	sector = clone->bi_iter.bi_sector;
+
+	dm_offload_start(&o);
 	r = ti->type->map(ti, clone);
+	dm_offload_end(&o);
+
 	if (r == DM_MAPIO_REMAPPED) {
 		/* the bio has been remapped so dispatch it */
 
