From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/8] raid1 barriers
Date: Mon, 27 Apr 2009 07:45:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0904270745190.18227@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0904270701250.12459@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270743540.18227@hs20-bc2-1.build.redhat.com>
	<Pine.LNX.4.64.0904270744220.18227@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0904270744220.18227@hs20-bc2-1.build.redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Flush support for dm-raid1.

When it receives an empty barrier, submit it to al the devices via dm-io.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-raid1.c       |   13 +++++++++++--
 drivers/md/dm-region-hash.c |   27 +++++++++++++++++++++++++--
 2 files changed, 36 insertions(+), 4 deletions(-)

Index: linux-2.6.30-rc2-devel/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-raid1.c	2009-04-24 09:38:19.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-raid1.c	2009-04-24 09:47:08.000000000 +0200
@@ -396,6 +396,8 @@ static int mirror_available(struct mirro
  */
 static sector_t map_sector(struct mirror *m, struct bio *bio)
 {
+	if (unlikely(!bio->bi_size))
+		return 0;
 	return m->offset + (bio->bi_sector - m->ms->ti->begin);
 }
 
@@ -562,7 +564,7 @@ static void do_write(struct mirror_set *
 	struct dm_io_region io[ms->nr_mirrors], *dest = io;
 	struct mirror *m;
 	struct dm_io_request io_req = {
-		.bi_rw = WRITE,
+		.bi_rw = WRITE | (bio->bi_rw & WRITE_BARRIER),
 		.mem.type = DM_IO_BVEC,
 		.mem.ptr.bvec = bio->bi_io_vec + bio->bi_idx,
 		.notify.fn = write_callback,
@@ -603,6 +605,11 @@ static void do_writes(struct mirror_set 
 	bio_list_init(&requeue);
 
 	while ((bio = bio_list_pop(writes))) {
+		if (unlikely(bio_empty_barrier(bio))) {
+			bio_list_add(&sync, bio);
+			continue;
+		}
+
 		region = dm_rh_bio_to_region(ms->rh, bio);
 
 		if (log->type->is_remote_recovering &&
@@ -988,6 +995,7 @@ static int mirror_ctr(struct dm_target *
 
 	ti->private = ms;
 	ti->split_io = dm_rh_get_region_size(ms->rh);
+	ti->num_flush_requests = 1;
 
 	ms->kmirrord_wq = create_singlethread_workqueue("kmirrord");
 	if (!ms->kmirrord_wq) {
@@ -1115,7 +1123,8 @@ static int mirror_end_io(struct dm_targe
 	 * We need to dec pending if this was a write.
 	 */
 	if (rw == WRITE) {
-		dm_rh_dec(ms->rh, map_context->ll);
+		if (likely(!bio_empty_barrier(bio)))
+			dm_rh_dec(ms->rh, map_context->ll);
 		return error;
 	}
 
Index: linux-2.6.30-rc2-devel/drivers/md/dm-region-hash.c
===================================================================
--- linux-2.6.30-rc2-devel.orig/drivers/md/dm-region-hash.c	2009-04-24 09:39:56.000000000 +0200
+++ linux-2.6.30-rc2-devel/drivers/md/dm-region-hash.c	2009-04-24 10:15:54.000000000 +0200
@@ -79,6 +79,9 @@ struct dm_region_hash {
 	struct list_head recovered_regions;
 	struct list_head failed_recovered_regions;
 
+	/* There was a barrier failure => no regions can be marked clean */
+	int barrier_failure;
+
 	void *context;
 	sector_t target_begin;
 
@@ -220,6 +223,7 @@ struct dm_region_hash *dm_region_hash_cr
 	INIT_LIST_HEAD(&rh->quiesced_regions);
 	INIT_LIST_HEAD(&rh->recovered_regions);
 	INIT_LIST_HEAD(&rh->failed_recovered_regions);
+	rh->barrier_failure = 0;
 
 	rh->region_pool = mempool_create_kmalloc_pool(MIN_REGIONS,
 						      sizeof(struct dm_region));
@@ -404,6 +408,11 @@ void dm_rh_mark_nosync(struct dm_region_
 	region_t region = dm_rh_bio_to_region(rh, bio);
 	int recovering = 0;
 
+	if (bio_empty_barrier(bio)) {
+		rh->barrier_failure = 1;
+		return;
+	}
+
 	/* We must inform the log that the sync count has changed. */
 	log->type->set_region_sync(log, region, 0);
 
@@ -524,8 +533,11 @@ void dm_rh_inc_pending(struct dm_region_
 {
 	struct bio *bio;
 
-	for (bio = bios->head; bio; bio = bio->bi_next)
+	for (bio = bios->head; bio; bio = bio->bi_next) {
+		if (bio_empty_barrier(bio))
+			continue;
 		rh_inc(rh, dm_rh_bio_to_region(rh, bio));
+	}
 }
 EXPORT_SYMBOL_GPL(dm_rh_inc_pending);
 
@@ -553,7 +565,18 @@ void dm_rh_dec(struct dm_region_hash *rh
 		 */
 
 		/* do nothing for DM_RH_NOSYNC */
-		if (reg->state == DM_RH_RECOVERING) {
+
+		if (unlikely(rh->barrier_failure)) {
+			/*
+			 * If write barrier failed some time ago, we don't
+			 * know if this write made it to the disk or not.
+			 *
+			 * So mark it as NOSYNC. The only way how to get
+			 * out of this "rh->barrier_failure" state, just
+			 * reload the table and start recovery.
+			 */
+			reg->state = DM_RH_NOSYNC;
+		} else if (reg->state == DM_RH_RECOVERING) {
 			list_add_tail(&reg->list, &rh->quiesced_regions);
 		} else if (reg->state == DM_RH_DIRTY) {
 			reg->state = DM_RH_CLEAN;
