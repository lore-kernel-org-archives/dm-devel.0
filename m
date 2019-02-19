From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 8/8] dm mpath: add support for dm_noclone and its
	per-bio-data
Date: Tue, 19 Feb 2019 17:17:21 -0500
Message-ID: <20190219221721.29830-9-snitzer@redhat.com>
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

Update multipath_init_per_bio_data() to allocate a dm_mpath_per_bio_data
structure and associate it with the noclone bio using the dm_noclone
structure's 'noclone_private' member.

If kmem_cache_alloc() fails to allocate a struct dm_mpath_per_bio_data,
DM_MAPIO_NOCLONE_FAILED is returned from ->map and DM core falls back to
using traditional bio-based DM's bio cloning.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c | 65 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 55 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 2ee5e357a0a7..ac7ca5334796 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -30,6 +30,8 @@
 #define DM_PG_INIT_DELAY_MSECS 2000
 #define DM_PG_INIT_DELAY_DEFAULT ((unsigned) -1)
 
+static struct kmem_cache *_noclone_per_bio_data_cache;
+
 /* Path properties */
 struct pgpath {
 	struct list_head list;
@@ -101,6 +103,11 @@ struct dm_mpath_io {
 	size_t nr_bytes;
 };
 
+struct dm_mpath_per_bio_data {
+	struct dm_mpath_io mpio;
+	struct dm_bio_details bio_details;
+};
+
 typedef int (*action_fn) (struct pgpath *pgpath);
 
 static struct workqueue_struct *kmultipathd, *kmpath_handlerd;
@@ -250,11 +257,16 @@ static struct dm_mpath_io *get_mpio(union map_info *info)
 
 static size_t multipath_per_bio_data_size(void)
 {
-	return sizeof(struct dm_mpath_io) + sizeof(struct dm_bio_details);
+	return sizeof(struct dm_mpath_per_bio_data);
 }
 
 static struct dm_mpath_io *get_mpio_from_bio(struct bio *bio)
 {
+	struct dm_noclone *noclone = dm_get_noclone_from_bio(bio);
+
+	if (noclone)
+		return noclone->noclone_private;
+
 	return dm_per_bio_data(bio, multipath_per_bio_data_size());
 }
 
@@ -265,16 +277,29 @@ static struct dm_bio_details *get_bio_details_from_mpio(struct dm_mpath_io *mpio
 	return bio_details;
 }
 
-static void multipath_init_per_bio_data(struct bio *bio, struct dm_mpath_io **mpio_p)
+static bool multipath_init_per_bio_data(struct dm_target *ti, struct bio *bio,
+					struct dm_mpath_io **mpio_p)
 {
-	struct dm_mpath_io *mpio = get_mpio_from_bio(bio);
-	struct dm_bio_details *bio_details = get_bio_details_from_mpio(mpio);
+	struct dm_mpath_io *mpio;
+	struct dm_bio_details *bio_details;
+	struct dm_noclone *noclone = dm_get_noclone_from_bio(bio);
+
+	if (noclone) {
+		noclone->noclone_private =
+			kmem_cache_alloc(_noclone_per_bio_data_cache, GFP_NOWAIT);
+		if (unlikely(!noclone->noclone_private))
+			return false;
+	}
+
+	mpio = get_mpio_from_bio(bio);
+	bio_details = get_bio_details_from_mpio(mpio);
 
 	mpio->nr_bytes = bio->bi_iter.bi_size;
 	mpio->pgpath = NULL;
 	*mpio_p = mpio;
 
 	dm_bio_record(bio_details, bio);
+	return true;
 }
 
 /*-----------------------------------------------
@@ -652,7 +677,9 @@ static int multipath_map_bio(struct dm_target *ti, struct bio *bio)
 	struct multipath *m = ti->private;
 	struct dm_mpath_io *mpio = NULL;
 
-	multipath_init_per_bio_data(bio, &mpio);
+	if (!multipath_init_per_bio_data(ti, bio, &mpio))
+		return DM_MAPIO_NOCLONE_FAILED;
+
 	return __multipath_map_bio(m, bio, mpio);
 }
 
@@ -1178,9 +1205,10 @@ static int multipath_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->num_discard_bios = 1;
 	ti->num_write_same_bios = 1;
 	ti->num_write_zeroes_bios = 1;
-	if (m->queue_mode == DM_TYPE_BIO_BASED)
+	if (m->queue_mode == DM_TYPE_BIO_BASED) {
+		ti->no_clone = true;
 		ti->per_io_data_size = multipath_per_bio_data_size();
-	else
+	} else
 		ti->per_io_data_size = sizeof(struct dm_mpath_io);
 
 	return 0;
@@ -1584,12 +1612,13 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 	return r;
 }
 
-static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
+static int multipath_end_io_bio(struct dm_target *ti, struct bio *bio,
 				blk_status_t *error)
 {
 	struct multipath *m = ti->private;
-	struct dm_mpath_io *mpio = get_mpio_from_bio(clone);
+	struct dm_mpath_io *mpio = get_mpio_from_bio(bio);
 	struct pgpath *pgpath = mpio->pgpath;
+	struct dm_noclone *noclone = NULL;
 	unsigned long flags;
 	int r = DM_ENDIO_DONE;
 
@@ -1611,7 +1640,7 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 	}
 
 	spin_lock_irqsave(&m->lock, flags);
-	bio_list_add(&m->queued_bios, clone);
+	bio_list_add(&m->queued_bios, bio);
 	spin_unlock_irqrestore(&m->lock, flags);
 	if (!test_bit(MPATHF_QUEUE_IO, &m->flags))
 		queue_work(kmultipathd, &m->process_queued_bios);
@@ -1625,6 +1654,12 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
 	}
 
+	if (r != DM_ENDIO_INCOMPLETE) {
+		noclone = dm_get_noclone_from_bio(bio);
+		if (noclone)
+			kmem_cache_free(_noclone_per_bio_data_cache, noclone->noclone_private);
+	}
+
 	return r;
 }
 
@@ -2057,6 +2092,13 @@ static int __init dm_multipath_init(void)
 		goto bad_alloc_kmpath_handlerd;
 	}
 
+	_noclone_per_bio_data_cache = KMEM_CACHE(dm_mpath_per_bio_data, 0);
+	if (!_noclone_per_bio_data_cache) {
+		DMERR("failed to create noclone_per_bio_data_cache");
+		r = -ENOMEM;
+		goto bad_noclone_pbd;
+	}
+
 	r = dm_register_target(&multipath_target);
 	if (r < 0) {
 		DMERR("request-based register failed %d", r);
@@ -2067,6 +2109,8 @@ static int __init dm_multipath_init(void)
 	return 0;
 
 bad_register_target:
+	kmem_cache_destroy(_noclone_per_bio_data_cache);
+bad_noclone_pbd:
 	destroy_workqueue(kmpath_handlerd);
 bad_alloc_kmpath_handlerd:
 	destroy_workqueue(kmultipathd);
@@ -2078,6 +2122,7 @@ static void __exit dm_multipath_exit(void)
 {
 	destroy_workqueue(kmpath_handlerd);
 	destroy_workqueue(kmultipathd);
+	kmem_cache_destroy(_noclone_per_bio_data_cache);
 
 	dm_unregister_target(&multipath_target);
 }
-- 
2.15.0
