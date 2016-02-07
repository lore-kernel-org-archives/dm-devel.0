From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 09/15] dm: rename target's
	per_bio_data_size to per_io_data_size
Date: Sun,  7 Feb 2016 10:53:31 -0500
Message-ID: <1454860417-3203-10-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
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
Cc: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

Request-based DM will also make use of per_bio_data_size.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-target.c  |  2 +-
 drivers/md/dm-crypt.c         |  2 +-
 drivers/md/dm-delay.c         |  2 +-
 drivers/md/dm-flakey.c        |  2 +-
 drivers/md/dm-log-writes.c    |  2 +-
 drivers/md/dm-raid1.c         |  2 +-
 drivers/md/dm-snap.c          |  2 +-
 drivers/md/dm-table.c         |  6 +++---
 drivers/md/dm-thin.c          |  2 +-
 drivers/md/dm-verity-fec.c    |  2 +-
 drivers/md/dm-verity-target.c | 12 ++++++------
 drivers/md/dm.c               |  8 ++++----
 include/linux/device-mapper.h |  6 +++---
 13 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 5780acc..2238d6f 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2771,7 +2771,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	ti->split_discard_bios = false;
 
 	cache->features = ca->features;
-	ti->per_bio_data_size = get_per_bio_data_size(cache);
+	ti->per_io_data_size = get_per_bio_data_size(cache);
 
 	cache->callbacks.congested_fn = cache_is_congested;
 	dm_table_add_target_callbacks(ti->table, &cache->callbacks);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 3147c8d..5c934b6 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1788,7 +1788,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 		goto bad;
 	}
 
-	cc->per_bio_data_size = ti->per_bio_data_size =
+	cc->per_bio_data_size = ti->per_io_data_size =
 		ALIGN(sizeof(struct dm_crypt_io) + cc->dmreq_start +
 		      sizeof(struct dm_crypt_request) + iv_size_padding + cc->iv_size,
 		      ARCH_KMALLOC_MINALIGN);
diff --git a/drivers/md/dm-delay.c b/drivers/md/dm-delay.c
index b4c356a..cc70871 100644
--- a/drivers/md/dm-delay.c
+++ b/drivers/md/dm-delay.c
@@ -204,7 +204,7 @@ out:
 
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
-	ti->per_bio_data_size = sizeof(struct dm_delay_info);
+	ti->per_io_data_size = sizeof(struct dm_delay_info);
 	ti->private = dc;
 	return 0;
 
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 09e2afc..b7341de 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -220,7 +220,7 @@ static int flakey_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
-	ti->per_bio_data_size = sizeof(struct per_bio_data);
+	ti->per_io_data_size = sizeof(struct per_bio_data);
 	ti->private = fc;
 	return 0;
 
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 624589d..608302e 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -475,7 +475,7 @@ static int log_writes_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->flush_supported = true;
 	ti->num_discard_bios = 1;
 	ti->discards_supported = true;
-	ti->per_bio_data_size = sizeof(struct per_bio_data);
+	ti->per_io_data_size = sizeof(struct per_bio_data);
 	ti->private = lc;
 	return 0;
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index f2a363a..b3ccf1e 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1121,7 +1121,7 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
-	ti->per_bio_data_size = sizeof(struct dm_raid1_bio_record);
+	ti->per_io_data_size = sizeof(struct dm_raid1_bio_record);
 	ti->discard_zeroes_data_unsupported = true;
 
 	ms->kmirrord_wq = alloc_workqueue("kmirrord", WQ_MEM_RECLAIM, 0);
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 376638608..62479ac 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1201,7 +1201,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 
 	ti->private = s;
 	ti->num_flush_bios = num_flush_bios;
-	ti->per_bio_data_size = sizeof(struct dm_snap_tracked_chunk);
+	ti->per_io_data_size = sizeof(struct dm_snap_tracked_chunk);
 
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 89180fd..7210e53 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -957,7 +957,7 @@ bool dm_table_mq_request_based(struct dm_table *t)
 static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *md)
 {
 	unsigned type = dm_table_get_type(t);
-	unsigned per_bio_data_size = 0;
+	unsigned per_io_data_size = 0;
 	struct dm_target *tgt;
 	unsigned i;
 
@@ -969,10 +969,10 @@ static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *
 	if (type == DM_TYPE_BIO_BASED)
 		for (i = 0; i < t->num_targets; i++) {
 			tgt = t->targets + i;
-			per_bio_data_size = max(per_bio_data_size, tgt->per_bio_data_size);
+			per_io_data_size = max(per_io_data_size, tgt->per_io_data_size);
 		}
 
-	t->mempools = dm_alloc_md_mempools(md, type, t->integrity_supported, per_bio_data_size);
+	t->mempools = dm_alloc_md_mempools(md, type, t->integrity_supported, per_io_data_size);
 	if (!t->mempools)
 		return -ENOMEM;
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 72d91f4..4fbbe1f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4037,7 +4037,7 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 
 	ti->num_flush_bios = 1;
 	ti->flush_supported = true;
-	ti->per_bio_data_size = sizeof(struct dm_thin_endio_hook);
+	ti->per_io_data_size = sizeof(struct dm_thin_endio_hook);
 
 	/* In case the pool supports discards, pass them on. */
 	ti->discard_zeroes_data_unsupported = true;
diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 1cc10c4..459a9f8 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -812,7 +812,7 @@ int verity_fec_ctr(struct dm_verity *v)
 	}
 
 	/* Reserve space for our per-bio data */
-	ti->per_bio_data_size += sizeof(struct dm_verity_fec_io);
+	ti->per_io_data_size += sizeof(struct dm_verity_fec_io);
 
 	return 0;
 }
diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 5c5d30c..0aba34a 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -354,7 +354,7 @@ int verity_for_bv_block(struct dm_verity *v, struct dm_verity_io *io,
 				       size_t len))
 {
 	unsigned todo = 1 << v->data_dev_block_bits;
-	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_bio_data_size);
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	do {
 		int r;
@@ -460,7 +460,7 @@ static int verity_verify_io(struct dm_verity_io *io)
 static void verity_finish_io(struct dm_verity_io *io, int error)
 {
 	struct dm_verity *v = io->v;
-	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_bio_data_size);
+	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_error = error;
@@ -574,7 +574,7 @@ static int verity_map(struct dm_target *ti, struct bio *bio)
 	if (bio_data_dir(bio) == WRITE)
 		return -EIO;
 
-	io = dm_per_bio_data(bio, ti->per_bio_data_size);
+	io = dm_per_bio_data(bio, ti->per_io_data_size);
 	io->v = v;
 	io->orig_bi_end_io = bio->bi_end_io;
 	io->block = bio->bi_iter.bi_sector >> (v->data_dev_block_bits - SECTOR_SHIFT);
@@ -1036,15 +1036,15 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto bad;
 	}
 
-	ti->per_bio_data_size = sizeof(struct dm_verity_io) +
+	ti->per_io_data_size = sizeof(struct dm_verity_io) +
 				v->shash_descsize + v->digest_size * 2;
 
 	r = verity_fec_ctr(v);
 	if (r)
 		goto bad;
 
-	ti->per_bio_data_size = roundup(ti->per_bio_data_size,
-					__alignof__(struct dm_verity_io));
+	ti->per_io_data_size = roundup(ti->per_io_data_size,
+				       __alignof__(struct dm_verity_io));
 
 	return 0;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 1fab790..8bc798c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3476,7 +3476,7 @@ int dm_noflush_suspending(struct dm_target *ti)
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
 struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned type,
-					    unsigned integrity, unsigned per_bio_data_size)
+					    unsigned integrity, unsigned per_io_data_size)
 {
 	struct dm_md_mempools *pools = kzalloc(sizeof(*pools), GFP_KERNEL);
 	struct kmem_cache *cachep = NULL;
@@ -3492,7 +3492,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned t
 	case DM_TYPE_BIO_BASED:
 		cachep = _io_cache;
 		pool_size = dm_get_reserved_bio_based_ios();
-		front_pad = roundup(per_bio_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
+		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
 		break;
 	case DM_TYPE_REQUEST_BASED:
 		cachep = _rq_tio_cache;
@@ -3505,8 +3505,8 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned t
 		if (!pool_size)
 			pool_size = dm_get_reserved_rq_based_ios();
 		front_pad = offsetof(struct dm_rq_clone_bio_info, clone);
-		/* per_bio_data_size is not used. See __bind_mempools(). */
-		WARN_ON(per_bio_data_size != 0);
+		/* per_io_data_size is not used. */
+		WARN_ON(per_io_data_size != 0);
 		break;
 	default:
 		BUG();
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 87d50ec..82ae3b5 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -238,10 +238,10 @@ struct dm_target {
 	unsigned num_write_same_bios;
 
 	/*
-	 * The minimum number of extra bytes allocated in each bio for the
-	 * target to use.  dm_per_bio_data returns the data location.
+	 * The minimum number of extra bytes allocated in each io for the
+	 * target to use.
 	 */
-	unsigned per_bio_data_size;
+	unsigned per_io_data_size;
 
 	/*
 	 * If defined, this function is called to find out how many
-- 
2.5.4 (Apple Git-61)
