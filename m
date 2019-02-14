From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 4/4] dm: implement no-clone optimization
Date: Thu, 14 Feb 2019 16:00:06 +0100
Message-ID: <20190214150106.703894360@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-no-clone-light.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

This patch improves performance of dm-linear and dm-striped targets.
Device mapper copies the whole bio and passes it to the lower layer. This
copying may be avoided in special cases.

This patch changes the logic so that instead of copying the bio we
allocate a structure dm_noclone (it has only 4 entries), save the values
bi_end_io and bi_private in it, overwrite these values in the bio and pass
the bio to the lower block device.

When the bio is finished, the function noclone_endio restores te values
bi_end_io and bi_private and passes the bio to the original bi_end_io
function.

This optimization can only be done by dm-linear and dm-striped targets,
the target can op-in by setting ti->no_clone = true.

Performance improvement:

# modprobe brd rd_size=1048576
# dd if=/dev/zero of=/dev/ram0 bs=1M oflag=direct
# dmsetup create lin --table "0 2097152 linear /dev/ram0 0"
# fio --ioengine=psync --iodepth=1 --rw=read --bs=512 --direct=1 --numjobs=12 --time_based --runtime=10 --group_reporting --name=/dev/mapper/lin

x86-64, 2x six-core
/dev/ram0					2449MiB/s
/dev/mapper/lin 5.0-rc without optimization	1970MiB/s
/dev/mapper/lin 5.0-rc with optimization	2238MiB/s

arm64, quad core:
/dev/ram0					457MiB/s
/dev/mapper/lin 5.0-rc without optimization	325MiB/s
/dev/mapper/lin 5.0-rc with optimization	364MiB/s

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-core.h          |    2 +
 drivers/md/dm-linear.c        |    1 
 drivers/md/dm-stripe.c        |    1 
 drivers/md/dm-table.c         |    5 +++
 drivers/md/dm-zero.c          |    1 
 drivers/md/dm.c               |   70 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/device-mapper.h |    5 +++
 7 files changed, 84 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2019-02-12 15:51:25.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2019-02-13 13:33:03.000000000 +0100
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
@@ -257,6 +269,8 @@ out_free_workqueue:
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
@@ -1731,6 +1746,19 @@ static blk_qc_t dm_process_bio(struct ma
 		return __split_and_process_bio(md, map, bio);
 }
 
+static void noclone_endio(struct bio *bio)
+{
+	struct dm_noclone *dn = bio->bi_private;
+	struct mapped_device *md = dn->md;
+
+	bio->bi_end_io = dn->orig_bi_end_io;
+	bio->bi_private = dn->orig_bi_private;
+
+	end_io_acct(md, bio, jiffies - dn->start_time);
+	kmem_cache_free(_noclone_cache, dn);
+	bio_endio(bio);
+}
+
 static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
 {
 	struct mapped_device *md = q->queuedata;
@@ -1751,8 +1779,48 @@ static blk_qc_t dm_make_request(struct r
 		return ret;
 	}
 
+	if (map->no_clone &&
+	    (bio_op(bio) == REQ_OP_READ || bio_op(bio) == REQ_OP_WRITE) &&
+	    likely(!(bio->bi_opf & REQ_PREFLUSH)) &&
+	    !bio_flagged(bio, BIO_CHAIN) &&
+	    likely(!bio_integrity(bio)) &&
+	    likely(!dm_stats_used(&md->stats))) {
+		int r;
+		struct dm_noclone *dn;
+		struct dm_target *ti = dm_table_find_target(map, bio->bi_iter.bi_sector);
+		if (unlikely(!dm_target_is_valid(ti)))
+			goto no_fast_path;
+		if (unlikely(bio_sectors(bio) > max_io_len(bio->bi_iter.bi_sector, ti)))
+			goto no_fast_path;
+		dn = kmem_cache_alloc(_noclone_cache, GFP_NOWAIT);
+		if (unlikely(!dn))
+			goto no_fast_path;
+		dn->md = md;
+		dn->start_time = jiffies;
+		dn->orig_bi_end_io = bio->bi_end_io;
+		dn->orig_bi_private = bio->bi_private;
+		bio->bi_end_io = noclone_endio;
+		bio->bi_private = dn;
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
Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2019-02-12 15:51:25.000000000 +0100
+++ linux-2.6/drivers/md/dm-core.h	2019-02-12 15:51:25.000000000 +0100
@@ -87,6 +87,7 @@ struct mapped_device {
 	 */
 	struct bio_set io_bs;
 	struct bio_set bs;
+	struct kmem_cache *noclone_cache;
 
 	/*
 	 * Processing queue (flush)
@@ -139,6 +140,7 @@ struct dm_table {
 	bool integrity_supported:1;
 	bool singleton:1;
 	unsigned integrity_added:1;
+	bool no_clone:1;
 
 	/*
 	 * Indicates the rw permissions for the new logical
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2019-02-12 15:51:25.000000000 +0100
+++ linux-2.6/drivers/md/dm-table.c	2019-02-12 16:02:03.000000000 +0100
@@ -147,6 +147,8 @@ int dm_table_create(struct dm_table **re
 	if (!t)
 		return -ENOMEM;
 
+	t->no_clone = true;
+
 	INIT_LIST_HEAD(&t->devices);
 	INIT_LIST_HEAD(&t->target_callbacks);
 
@@ -745,6 +747,9 @@ int dm_table_add_target(struct dm_table
 	if (r)
 		goto bad;
 
+	if (!tgt->no_clone)
+		t->no_clone = false;
+
 	t->highs[t->num_targets++] = tgt->begin + tgt->len - 1;
 
 	if (!tgt->num_discard_bios && tgt->discards_supported)
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h	2019-02-12 15:51:25.000000000 +0100
+++ linux-2.6/include/linux/device-mapper.h	2019-02-12 15:51:25.000000000 +0100
@@ -321,6 +321,11 @@ struct dm_target {
 	 * on max_io_len boundary.
 	 */
 	bool split_discard_bios:1;
+
+	/*
+	 * The target can process bios without cloning them.
+	 */
+	bool no_clone:1;
 };
 
 /* Each target can link one of these into the table */
Index: linux-2.6/drivers/md/dm-linear.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-linear.c	2019-01-12 16:48:32.000000000 +0100
+++ linux-2.6/drivers/md/dm-linear.c	2019-02-12 16:03:54.000000000 +0100
@@ -62,6 +62,7 @@ static int linear_ctr(struct dm_target *
 	ti->num_secure_erase_bios = 1;
 	ti->num_write_same_bios = 1;
 	ti->num_write_zeroes_bios = 1;
+	ti->no_clone = true;
 	ti->private = lc;
 	return 0;
 
Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c	2019-01-12 16:48:32.000000000 +0100
+++ linux-2.6/drivers/md/dm-stripe.c	2019-02-12 16:04:31.000000000 +0100
@@ -172,6 +172,7 @@ static int stripe_ctr(struct dm_target *
 	ti->num_secure_erase_bios = stripes;
 	ti->num_write_same_bios = stripes;
 	ti->num_write_zeroes_bios = stripes;
+	ti->no_clone = true;
 
 	sc->chunk_size = chunk_size;
 	if (chunk_size & (chunk_size - 1))
Index: linux-2.6/drivers/md/dm-zero.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-zero.c	2019-01-12 16:48:32.000000000 +0100
+++ linux-2.6/drivers/md/dm-zero.c	2019-02-12 16:06:54.000000000 +0100
@@ -26,6 +26,7 @@ static int zero_ctr(struct dm_target *ti
 	 * Silently drop discards, avoiding -EOPNOTSUPP.
 	 */
 	ti->num_discard_bios = 1;
+	ti->no_clone = true;
 
 	return 0;
 }
