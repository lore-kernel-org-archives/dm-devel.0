From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: Don't install merge function if not needed
Date: Tue, 21 Jun 2011 16:08:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1106211604110.22545@hs20-bc2-1.build.redhat.com>
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
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

This is the patch that allows larger bios to snapshots and improve 
snapshot performance.

The logic and reason is explained in the patch header.

Note that providing a merge function on a snapshot target doesn't work, 
the target merge function doesn't know where the bio will go, thus it 
cannot call underlying merge function accurately. Guessing is not 
possible, because the merge function must be obeyed.

This patch may also improve CPU consumption a little bit by not providing 
a merge function on linear devices, where it is not needed.

Mikulas

---

dm: Don't install merge function if not needed

This patch changes dm to not install merge function when not needed.
Merge functions is installed when the table needs it. It is never
uninstalled --- uninstalling it is not thread-safe.


The reason for this change is this:


The specification for allowed bio size is this:
* a bio containing just one page is always allowed
* if the bio contains more pages, it must conform to queue limits and
  the merge function. The bio must not be larger than the size allowed
  by the queue's merge function.

The limit set by the "merge" function must be obeyed. If we don't obey
this limit, "md" driver doesn't process the bio and returns an error.


The snapshot target can provide its own merge function, but when this
merge function is called, it is unclear to which location the bio will go.
We would know where the bio will go in case of already reallocated chunk,
but in case of read or write to not-yet-reallocated chunk, it is impossible
to say where this chunk will be eventually reallocated.

"Guessing" where the bio will go is not allowed, because the guess will
eventually go wrong. Incorrect guess could allow too large bio to
be created. When such large bio is passed to "md" driver, the "md" driver
rejects it with an error.


Consequently --- if the snapshot "cow" device has a merge function,
we must not allow bios larger than a page to go to that snapshot.

Therefore, we could allow bios larger than a page and improve snapshot
performance by not setting a merge function for a "cow" device.

The "cow" device is device mapper device, it is usually composed of
one or more linear targets, these targets do not need merge function
if the underlying disk doesn't have a merge function.

This patch introduces this logic:
* the device mapper provides a merge function for its device
  if one of the underlying devices have a merge function OR
  if one of the targets have nonzero "split_io".

Consequently, if the "cow" device is a linear target and if the underlying disk
doesn't have a merge function, the "cow" device doesn't have a merge function
either. Thus, the snapshot target can allow bios larger than a page.

This patch (together with the previous patch to not copy on full chunk write)
improves performance when writing to ext2 filesystem created on a sparse device
with 8k chunk from 22MB/s (before the patch) to 40MB/s (after the patch).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-table.c |   36 ++++++++++++++++++++++++++++++++++++
 drivers/md/dm.c       |    6 ++----
 drivers/md/dm.h       |    3 +++
 3 files changed, 41 insertions(+), 4 deletions(-)

Index: linux-2.6.39-fast/drivers/md/dm-table.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm-table.c	2011-06-21 21:18:48.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm-table.c	2011-06-21 21:32:55.000000000 +0200
@@ -1152,6 +1152,39 @@ combine_limits:
 	return validate_hardware_logical_block_alignment(table, limits);
 }
 
+static int device_needs_merge(struct dm_target *ti, struct dm_dev *dev,
+			      sector_t start, sector_t len, void *data)
+{
+	struct block_device *bdev = dev->bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (q->merge_bvec_fn)
+		return 1;
+
+	return 0;
+}
+
+static int dm_table_needs_merge(struct dm_table *t)
+{
+	unsigned i = 0;
+	while (i < dm_table_get_num_targets(t)) {
+		struct dm_target *ti;
+
+		ti = dm_table_get_target(t, i++);
+
+		if (ti->split_io)
+			return 1;
+
+		if (!ti->type->iterate_devices)
+			continue;
+
+		if (ti->type->iterate_devices(ti, device_needs_merge,
+					      NULL))
+			return 1;
+	}
+	return 0;
+}
+
 /*
  * Set the integrity profile for this device if all devices used have
  * matching profiles.  We're quite deep in the resume path but still
@@ -1185,6 +1218,9 @@ void dm_table_set_restrictions(struct dm
 	 */
 	q->limits = *limits;
 
+	if (dm_table_needs_merge(t))
+		blk_queue_merge_bvec(q, dm_merge_bvec);
+
 	if (!dm_table_supports_discards(t))
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
 	else
Index: linux-2.6.39-fast/drivers/md/dm.c
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm.c	2011-06-21 21:17:05.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm.c	2011-06-21 21:33:31.000000000 +0200
@@ -1320,9 +1320,8 @@ static void __split_and_process_bio(stru
  * CRUD END
  *---------------------------------------------------------------*/
 
-static int dm_merge_bvec(struct request_queue *q,
-			 struct bvec_merge_data *bvm,
-			 struct bio_vec *biovec)
+int dm_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm,
+		  struct bio_vec *biovec)
 {
 	struct mapped_device *md = q->queuedata;
 	struct dm_table *map = dm_get_live_table(md);
@@ -1799,7 +1798,6 @@ static void dm_init_md_queue(struct mapp
 	md->queue->backing_dev_info.congested_data = md;
 	blk_queue_make_request(md->queue, dm_request);
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
-	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
 	blk_queue_flush(md->queue, REQ_FLUSH | REQ_FUA);
 }
 
Index: linux-2.6.39-fast/drivers/md/dm.h
===================================================================
--- linux-2.6.39-fast.orig/drivers/md/dm.h	2011-06-21 21:19:26.000000000 +0200
+++ linux-2.6.39-fast/drivers/md/dm.h	2011-06-21 21:22:03.000000000 +0200
@@ -41,6 +41,9 @@ struct dm_dev_internal {
 struct dm_table;
 struct dm_md_mempools;
 
+int dm_merge_bvec(struct request_queue *q, struct bvec_merge_data *bvm,
+		  struct bio_vec *biovec);
+
 /*-----------------------------------------------------------------
  * Internal table functions.
  *---------------------------------------------------------------*/
