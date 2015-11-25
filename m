From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: don't save and restore bi_private
Date: Wed, 25 Nov 2015 16:03:31 -0500 (EST)
Message-ID: <alpine.LRH.2.02.1511251602270.17072@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Device mapper used the field bi_private to point to dm_target_io. However,
since kernel 3.15, the bi_private field is unused, and so the targets do
not need to save and restore this field.

This patch removes code that saves and restores bi_private from dm-cache,
dm-snapshot and dm-verity.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-cache-target.c |    3 ---
 drivers/md/dm-snap.c         |    6 +-----
 drivers/md/dm-verity.c       |    3 ---
 3 files changed, 1 insertion(+), 11 deletions(-)

Index: linux-4.4-rc2/drivers/md/dm-cache-target.c
===================================================================
--- linux-4.4-rc2.orig/drivers/md/dm-cache-target.c	2015-11-24 15:33:56.000000000 +0100
+++ linux-4.4-rc2/drivers/md/dm-cache-target.c	2015-11-24 15:34:35.000000000 +0100
@@ -118,14 +118,12 @@ static void iot_io_end(struct io_tracker
  */
 struct dm_hook_info {
 	bio_end_io_t *bi_end_io;
-	void *bi_private;
 };
 
 static void dm_hook_bio(struct dm_hook_info *h, struct bio *bio,
 			bio_end_io_t *bi_end_io, void *bi_private)
 {
 	h->bi_end_io = bio->bi_end_io;
-	h->bi_private = bio->bi_private;
 
 	bio->bi_end_io = bi_end_io;
 	bio->bi_private = bi_private;
@@ -134,7 +132,6 @@ static void dm_hook_bio(struct dm_hook_i
 static void dm_unhook_bio(struct dm_hook_info *h, struct bio *bio)
 {
 	bio->bi_end_io = h->bi_end_io;
-	bio->bi_private = h->bi_private;
 }
 
 /*----------------------------------------------------------------*/
Index: linux-4.4-rc2/drivers/md/dm-snap.c
===================================================================
--- linux-4.4-rc2.orig/drivers/md/dm-snap.c	2015-11-24 15:34:55.000000000 +0100
+++ linux-4.4-rc2/drivers/md/dm-snap.c	2015-11-24 15:35:32.000000000 +0100
@@ -207,7 +207,6 @@ struct dm_snap_pending_exception {
 	 */
 	struct bio *full_bio;
 	bio_end_io_t *full_bio_end_io;
-	void *full_bio_private;
 };
 
 /*
@@ -1485,10 +1484,8 @@ out:
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
 	origin_bios = bio_list_get(&pe->origin_bios);
 	full_bio = pe->full_bio;
-	if (full_bio) {
+	if (full_bio)
 		full_bio->bi_end_io = pe->full_bio_end_io;
-		full_bio->bi_private = pe->full_bio_private;
-	}
 	increment_pending_exceptions_done_count();
 
 	up_write(&s->lock);
@@ -1605,7 +1602,6 @@ static void start_full_bio(struct dm_sna
 
 	pe->full_bio = bio;
 	pe->full_bio_end_io = bio->bi_end_io;
-	pe->full_bio_private = bio->bi_private;
 
 	callback_data = dm_kcopyd_prepare_callback(s->kcopyd_client,
 						   copy_callback, pe);
Index: linux-4.4-rc2/drivers/md/dm-verity.c
===================================================================
--- linux-4.4-rc2.orig/drivers/md/dm-verity.c	2015-11-24 15:35:40.000000000 +0100
+++ linux-4.4-rc2/drivers/md/dm-verity.c	2015-11-24 15:35:50.000000000 +0100
@@ -85,7 +85,6 @@ struct dm_verity_io {
 
 	/* original values of bio->bi_end_io and bio->bi_private */
 	bio_end_io_t *orig_bi_end_io;
-	void *orig_bi_private;
 
 	sector_t block;
 	unsigned n_blocks;
@@ -453,7 +452,6 @@ static void verity_finish_io(struct dm_v
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_bio_data_size);
 
 	bio->bi_end_io = io->orig_bi_end_io;
-	bio->bi_private = io->orig_bi_private;
 	bio->bi_error = error;
 
 	bio_endio(bio);
@@ -566,7 +564,6 @@ static int verity_map(struct dm_target *
 	io = dm_per_bio_data(bio, ti->per_bio_data_size);
 	io->v = v;
 	io->orig_bi_end_io = bio->bi_end_io;
-	io->orig_bi_private = bio->bi_private;
 	io->block = bio->bi_iter.bi_sector >> (v->data_dev_block_bits - SECTOR_SHIFT);
 	io->n_blocks = bio->bi_iter.bi_size >> v->data_dev_block_bits;
 
