From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/8] dm: implement noclone optimization for
	bio-based
Date: Tue, 19 Feb 2019 17:17:17 -0500
Message-ID: <20190219221721.29830-5-snitzer@redhat.com>
References: <20190219221721.29830-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20190219221721.29830-1-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

From: Mikulas Patocka <mpatocka@redhat.com>

Until now bio-based DM core has always cloned an incoming bio, remapped
the clone bio to a low layer, dealt with the clone's completion and then
finally completed the original bio.  This cloning can be avoided for
READ and WRITE bios if the target opts-in by setting ti->no_clone.

Avoiding cloning for READ and WRITE bios improves performance of targets
that do very little work in response to each bio (e.g. dm-linear and
dm-striped).

The improvement is accomplished by changing DM core to allocate a
'dm_noclone' structure (that is quite small) instead of cloning the bio.
The bio's bi_end_io and bi_private are saved in the 'dm_noclone' before
they are overwritten and the bio passed to the lower block device.

When the bio is finished, the function noclone_endio restores the values
bi_end_io and bi_private and passes the bio to the original bi_end_io
function.

If the allocation of the 'struct dm_noclone' fails then bio-based DM
falls back to the traditional bio cloning IO path that is backed my
mempool reservations.

Performance improvement for dm-linear:

x86-64, 2x six-core
/dev/ram0					2449MiB/s
/dev/mapper/lin 5.0-rc without optimization	1970MiB/s
/dev/mapper/lin 5.0-rc with optimization	2238MiB/s

arm64, quad core:
/dev/ram0					457MiB/s
/dev/mapper/lin 5.0-rc without optimization	325MiB/s
/dev/mapper/lin 5.0-rc with optimization	364MiB/s

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-core.h          |  1 +
 drivers/md/dm-linear.c        |  1 +
 drivers/md/dm-stripe.c        |  1 +
 drivers/md/dm-table.c         | 11 +++++++
 drivers/md/dm-zero.c          |  1 +
 drivers/md/dm.c               | 71 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm.h               |  1 +
 include/linux/device-mapper.h |  5 +++
 8 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 95c6d86ab5e8..b4832bba9d64 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -87,6 +87,7 @@ struct mapped_device {
 	 */
 	struct bio_set io_bs;
 	struct bio_set bs;
+	struct kmem_cache *noclone_cache;
 
 	/*
 	 * Processing queue (flush)
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index ad980a38fb1e..6e1df9fdfcc8 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_same_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->no_clone = true;
 	ti->private = lc;
 	return 0;
 
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 8547d7594338..32181b7ca34a 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -172,6 +172,7 @@ static int stripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_secure_erase_bios = stripes;
 	ti->num_write_same_bios = stripes;
 	ti->num_write_zeroes_bios = stripes;
+	ti->no_clone = true;
 
 	sc->chunk_size = chunk_size;
 	if (chunk_size & (chunk_size - 1))
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 4b1be754cc41..6a3e23faeb7d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -47,6 +47,7 @@ struct dm_table {
 
 	bool integrity_supported:1;
 	bool singleton:1;
+	bool no_clone:1;
 	unsigned integrity_added:1;
 
 	/*
@@ -191,6 +192,8 @@ int dm_table_create(struct dm_table **result, fmode_t mode,
 	if (!t)
 		return -ENOMEM;
 
+	t->no_clone = true;
+
 	INIT_LIST_HEAD(&t->devices);
 	INIT_LIST_HEAD(&t->target_callbacks);
 
@@ -789,6 +792,9 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 	if (r)
 		goto bad;
 
+	if (!tgt->no_clone)
+		t->no_clone = false;
+
 	t->highs[t->num_targets++] = tgt->begin + tgt->len - 1;
 
 	if (!tgt->num_discard_bios && tgt->discards_supported)
@@ -1376,6 +1382,11 @@ static int count_device(struct dm_target *ti, struct dm_dev *dev,
 	return 0;
 }
 
+bool dm_table_supports_noclone(struct dm_table *table)
+{
+	return table->no_clone;
+}
+
 /*
  * Check whether a table has no data devices attached using each
  * target's iterate_devices method.
diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
index b65ca8dcfbdc..436a5ee89698 100644
--- a/drivers/md/dm-zero.c
+++ b/drivers/md/dm-zero.c
@@ -26,6 +26,7 @@ static int zero_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	 * Silently drop discards, avoiding -EOPNOTSUPP.
 	 */
 	ti->num_discard_bios = 1;
+	ti->no_clone = true;
 
 	return 0;
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1b87d20041e7..cbda11b34635 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -158,8 +158,16 @@ struct table_device {
 	struct dm_dev dm_dev;
 };
 
+struct dm_noclone {
+	struct mapped_device *md;
+	bio_end_io_t *orig_bi_end_io;
+	void *orig_bi_private;
+	unsigned long start_time;
+};
+
 static struct kmem_cache *_rq_tio_cache;
 static struct kmem_cache *_rq_cache;
+static struct kmem_cache *_noclone_cache;
 
 /*
  * Bio-based DM's mempools' reserved IOs set by the user.
@@ -233,9 +241,13 @@ static int __init local_init(void)
 	if (!_rq_cache)
 		goto out_free_rq_tio_cache;
 
+	_noclone_cache = KMEM_CACHE(dm_noclone, 0);
+	if (!_rq_tio_cache)
+		goto out_free_rq_cache;
+
 	r = dm_uevent_init();
 	if (r)
-		goto out_free_rq_cache;
+		goto out_free_noclone_cache;
 
 	deferred_remove_workqueue = alloc_workqueue("kdmremove", WQ_UNBOUND, 1);
 	if (!deferred_remove_workqueue) {
@@ -257,6 +269,8 @@ static int __init local_init(void)
 	destroy_workqueue(deferred_remove_workqueue);
 out_uevent_exit:
 	dm_uevent_exit();
+out_free_noclone_cache:
+	kmem_cache_destroy(_noclone_cache);
 out_free_rq_cache:
 	kmem_cache_destroy(_rq_cache);
 out_free_rq_tio_cache:
@@ -270,6 +284,7 @@ static void local_exit(void)
 	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
+	kmem_cache_destroy(_noclone_cache);
 	kmem_cache_destroy(_rq_cache);
 	kmem_cache_destroy(_rq_tio_cache);
 	unregister_blkdev(_major, _name);
@@ -1009,6 +1024,20 @@ static void clone_endio(struct bio *bio)
 	dec_pending(io, error);
 }
 
+static void noclone_endio(struct bio *bio)
+{
+	struct dm_noclone *noclone = bio->bi_private;
+	struct mapped_device *md = noclone->md;
+
+	end_io_acct(md, bio, noclone->start_time);
+
+	bio->bi_end_io = noclone->orig_bi_end_io;
+	bio->bi_private = noclone->orig_bi_private;
+	kmem_cache_free(_noclone_cache, noclone);
+
+	bio_endio(bio);
+}
+
 /*
  * Return maximum size of I/O possible at the supplied sector up to the current
  * target boundary.
@@ -1774,8 +1803,48 @@ static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 		return ret;
 	}
 
+	if (dm_table_supports_noclone(map) &&
+	    (bio_op(bio) == REQ_OP_READ || bio_op(bio) == REQ_OP_WRITE) &&
+	    likely(!(bio->bi_opf & REQ_PREFLUSH)) &&
+	    !bio_flagged(bio, BIO_CHAIN) &&
+	    likely(!bio_integrity(bio)) &&
+	    likely(!dm_stats_used(&md->stats))) {
+		int r;
+		struct dm_noclone *noclone;
+		struct dm_target *ti = dm_table_find_target(map, bio->bi_iter.bi_sector);
+		if (unlikely(!dm_target_is_valid(ti)))
+			goto no_fast_path;
+		if (unlikely(bio_sectors(bio) > max_io_len(bio->bi_iter.bi_sector, ti)))
+			goto no_fast_path;
+		noclone = kmem_cache_alloc(_noclone_cache, GFP_NOWAIT);
+		if (unlikely(!noclone))
+			goto no_fast_path;
+		noclone->md = md;
+		noclone->start_time = jiffies;
+		noclone->orig_bi_end_io = bio->bi_end_io;
+		noclone->orig_bi_private = bio->bi_private;
+		bio->bi_end_io = noclone_endio;
+		bio->bi_private = noclone;
+		start_io_acct(md, bio);
+		r = ti->type->map(ti, bio);
+		ret = BLK_QC_T_NONE;
+		if (likely(r == DM_MAPIO_REMAPPED)) {
+			ret = generic_make_request(bio);
+		} else if (likely(r == DM_MAPIO_SUBMITTED)) {
+		} else if (r == DM_MAPIO_KILL) {
+			bio->bi_status = BLK_STS_IOERR;
+			noclone_endio(bio);
+		} else {
+			DMWARN("unimplemented target map return value: %d", r);
+			BUG();
+		}
+		goto put_table_ret;
+	}
+
+no_fast_path:
 	ret = dm_process_bio(md, map, bio);
 
+put_table_ret:
 	dm_put_live_table(md, srcu_idx);
 	return ret;
 }
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 2d539b82ec08..c3c78123dfb3 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -53,6 +53,7 @@ void dm_table_event_callback(struct dm_table *t,
 			     void (*fn)(void *), void *context);
 struct dm_target *dm_table_get_target(struct dm_table *t, unsigned int index);
 struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
+bool dm_table_supports_noclone(struct dm_table *t);
 bool dm_table_has_no_data_devices(struct dm_table *table);
 int dm_calculate_queue_limits(struct dm_table *table,
 			      struct queue_limits *limits);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 0f5b3d7c6cb3..4ab2b0f53ae8 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -315,6 +315,11 @@ struct dm_target {
 	 * whether or not its underlying devices have support.
 	 */
 	bool discards_supported:1;
+
+	/*
+	 * The target can process bios without cloning them.
+	 */
+	bool no_clone:1;
 };
 
 /* Each target can link one of these into the table */
-- 
2.15.0
