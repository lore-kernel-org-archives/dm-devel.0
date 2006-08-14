From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: [PATCH] device-mapper core should use private bioset
Date: Mon, 14 Aug 2006 14:13:32 +0200
Message-ID: <44E068EC.20906@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050400040703030003010802"
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
To: dm-devel@redhat.com, agk@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------050400040703030003010802
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Alasdair,

I found a problem within device-mapper that occurs in low-mem
situations. It was found using a mirror target but I think in theory it
would hit any setup that stacks device-mapper devices (like LVM on top
of multipath).
Since device-mapper core uses the common fs_bioset it is possible that
the filesystem and the first level target successfully get bios but the
lower level target doesn't because there is no more memory and the pool
was drained by upper layers. So the remapping will be stuck forever.
To solve this device-mapper core would have to use its own bioset. The
following patch is against RHEL4-U4 but for head I guess only the stuff
for dm.c (without hunk 1) and probably dm-io.c (if the bioset stuff
there hasn't been replaced by the kernel built-in code, yet).

Regards,
Stefan Bader

--------------050400040703030003010802
Content-Type: text/plain;
 name="dm-add-bioset.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-add-bioset.diff"

diff -Nurp linux-RHEL4-U4/drivers/md/dm.c linux-RHEL4-U4-bioset/drivers/md/dm.c
--- linux-RHEL4-U4/drivers/md/dm.c	2006-05-03 19:22:11.000000000 +0200
+++ linux-RHEL4-U4-bioset/drivers/md/dm.c	2006-08-14 13:45:17.000000000 +0200
@@ -6,6 +6,7 @@
 
 #include "dm.h"
 #include "dm-bio-list.h"
+#include "dm-compat-bioset.h"
 
 #include <linux/init.h>
 #include <linux/module.h>
@@ -103,6 +104,11 @@ struct mapped_device {
 	 */
 	struct super_block *frozen_sb;
 	struct block_device *suspended_bdev;
+
+	/*
+	 * Allocate bios from private pool not the global one.
+	 */
+	struct bio_set *bs;
 };
 
 #define MIN_IOS 256
@@ -376,9 +382,13 @@ static int clone_endio(struct bio *bio, 
 			return 1;
 	}
 
-	free_tio(io->md, tio);
 	dec_pending(io, error);
+	/*
+	 * First release bio because destructor needs valid reference to
+	 * target_io to find the correct bio_set.
+	 */
 	bio_put(bio);
+	free_tio(io->md, tio);
 	return r;
 }
 
@@ -429,9 +439,13 @@ static void __map_bio(struct dm_target *
 	else if (r < 0) {
 		/* error the io and bail out */
 		struct dm_io *io = tio->io;
-		free_tio(tio->io->md, tio);
 		dec_pending(io, r);
+		/*
+		 * First release bio because destructor needs valid reference
+		 * to target_io to find the correct bio_set.
+		 */
 		bio_put(clone);
+		free_tio(tio->io->md, tio);
 	}
 }
 
@@ -445,19 +459,29 @@ struct clone_info {
 	unsigned short idx;
 };
 
+void dm_bio_destructor(struct bio *bio)
+{
+	struct target_io *	tio = bio->bi_private;
+
+	BUG_ON(!tio);
+
+	bio_free(bio, tio->io->md->bs);
+}
+
 /*
  * Creates a little bio that is just does part of a bvec.
  */
 static struct bio *split_bvec(struct bio *bio, sector_t sector,
 			      unsigned short idx, unsigned int offset,
-			      unsigned int len)
+			      unsigned int len, struct bio_set *bs)
 {
 	struct bio *clone;
 	struct bio_vec *bv = bio->bi_io_vec + idx;
 
-	clone = bio_alloc(GFP_NOIO, 1);
+	clone = bio_alloc_bioset(GFP_NOIO, 1, bs);
 	*clone->bi_io_vec = *bv;
 
+	clone->bi_destructor = dm_bio_destructor;
 	clone->bi_sector = sector;
 	clone->bi_bdev = bio->bi_bdev;
 	clone->bi_rw = bio->bi_rw;
@@ -474,11 +498,13 @@ static struct bio *split_bvec(struct bio
  */
 static struct bio *clone_bio(struct bio *bio, sector_t sector,
 			     unsigned short idx, unsigned short bv_count,
-			     unsigned int len)
+			     unsigned int len, struct bio_set *bs)
 {
 	struct bio *clone;
 
-	clone = bio_clone(bio, GFP_NOIO);
+	clone = bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
+	__bio_clone(clone, bio);
+	clone->bi_destructor = dm_bio_destructor;
 	clone->bi_sector = sector;
 	clone->bi_idx = idx;
 	clone->bi_vcnt = idx + bv_count;
@@ -509,7 +535,8 @@ static void __clone_and_map(struct clone
 		 * the remaining io with a single clone.
 		 */
 		clone = clone_bio(bio, ci->sector, ci->idx,
-				  bio->bi_vcnt - ci->idx, ci->sector_count);
+				  bio->bi_vcnt - ci->idx, ci->sector_count,
+				  ci->md->bs);
 		__map_bio(ti, clone, tio);
 		ci->sector_count = 0;
 
@@ -532,7 +559,8 @@ static void __clone_and_map(struct clone
 			len += bv_len;
 		}
 
-		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len);
+		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len,
+				  ci->md->bs);
 		__map_bio(ti, clone, tio);
 
 		ci->sector += len;
@@ -561,7 +589,8 @@ static void __clone_and_map(struct clone
 			len = (max > remaining) ? remaining : max;
 
 			clone = split_bvec(bio, ci->sector, ci->idx,
-					   bv->bv_offset + offset, len);
+					   bv->bv_offset + offset, len,
+					   ci->md->bs);
 
 			__map_bio(ti, clone, tio);
 
@@ -831,6 +860,10 @@ static struct mapped_device *alloc_dev(u
 	if (!md->tio_pool)
 		goto bad3;
 
+	md->bs = bioset_create(256, 32, 4);
+	if (!md->bs)
+		goto bad_no_bioset;
+
 	md->disk = alloc_disk(1);
 	if (!md->disk)
 		goto bad4;
@@ -857,6 +890,8 @@ static struct mapped_device *alloc_dev(u
 	return md;
 
  bad4:
+	bioset_free(md->bs);
+ bad_no_bioset:
 	mempool_destroy(md->tio_pool);
  bad3:
 	mempool_destroy(md->io_pool);
@@ -880,6 +915,7 @@ static void free_dev(struct mapped_devic
 	}
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
+	bioset_free(md->bs);
 	del_gendisk(md->disk);
 	free_minor(minor);
 
diff -Nurp linux-RHEL4-U4/drivers/md/dm-compat-bioset.c linux-RHEL4-U4-bioset/drivers/md/dm-compat-bioset.c
--- linux-RHEL4-U4/drivers/md/dm-compat-bioset.c	1970-01-01 01:00:00.000000000 +0100
+++ linux-RHEL4-U4-bioset/drivers/md/dm-compat-bioset.c	2006-08-14 13:05:42.000000000 +0200
@@ -0,0 +1,264 @@
+/*===========================================================================*/
+/*=========================== COMPAT START ==================================*/
+/* COMPAT: This is only required for older kernels that do not have bioset   */
+/*         functions exported by bio.h.                                      */
+/*===========================================================================*/
+#include <asm/semaphore.h>
+#include <linux/slab.h>
+
+#include "dm.h"
+#include "dm-compat-bioset.h"
+
+DECLARE_MUTEX(bs_compat_lock);
+unsigned long	bs_compat_count		= 0L;
+kmem_cache_t *	bs_compat_bio_slab	= NULL;
+
+struct biovec_slab {
+	int		nr_vecs;
+	char *		name;
+	kmem_cache_t *	slab;
+};
+
+#define BV(x) { .nr_vecs = x, .name = "dm-bvec-"__stringify(x) }
+static struct biovec_slab bs_compat_bvec_slabs[BIOVEC_NR_POOLS] = {
+		BV(1),
+		BV(4),
+		BV(16),
+		BV(64),
+		BV(128),
+		BV(BIO_MAX_PAGES),
+};
+#undef BV
+
+static void _bs_compat_exit(void)
+{
+	int	i;
+
+	for(i = 0; i < BIOVEC_NR_POOLS; i++) {
+		struct biovec_slab *bvs = bs_compat_bvec_slabs + i;
+
+		if (bvs->slab)
+			kmem_cache_destroy(bvs->slab);
+		bvs->slab = NULL;
+	}
+
+	if (bs_compat_bio_slab)
+		kmem_cache_destroy(bs_compat_bio_slab);
+	bs_compat_bio_slab = NULL;
+
+	bs_compat_count = 0;
+}
+
+static void bs_compat_exit(void)
+{
+	down(&bs_compat_lock);
+	if (--bs_compat_count == 0)
+		_bs_compat_exit();
+	up(&bs_compat_lock);
+}
+
+static int bs_compat_init(void)
+{
+	int		i;
+
+	down(&bs_compat_lock);
+	bs_compat_count++;
+
+	if (bs_compat_count > 1) {
+		up(&bs_compat_lock);
+		return 0;
+	}
+
+	bs_compat_bio_slab = kmem_cache_create(
+				"dm-bio", sizeof(struct bio), 0,
+				SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL, NULL);
+	if (!bs_compat_bio_slab) {
+		DMERR("failed to initialize bio slab cache");
+		goto failed;
+	}
+	for (i = 0; i < BIOVEC_NR_POOLS; i++) {
+		int size;
+		struct biovec_slab *bvs = bs_compat_bvec_slabs + i;
+
+		size = bvs->nr_vecs * sizeof(struct bio_vec);
+		bvs->slab = kmem_cache_create(bvs->name, size, 0,
+				SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL, NULL);
+		if (!bvs->slab) {
+			DMERR("failed to initialize biovec slab cache");
+			goto failed;
+		}
+	}
+
+	up(&bs_compat_lock);
+	return 0;
+
+failed:
+	_bs_compat_exit();
+	up(&bs_compat_lock);
+	return -ENOMEM;
+}
+
+struct bio_set {
+	mempool_t *	bio_pool;
+	mempool_t *	bvec_pools[BIOVEC_NR_POOLS];
+};
+
+static void biovec_free_pools(struct bio_set *bs)
+{
+	int	i;
+
+	for (i = 0; i < BIOVEC_NR_POOLS; i++) {
+		mempool_t *	bvp = bs->bvec_pools[i];
+
+		if (bvp)
+			mempool_destroy(bvp);
+	}
+}
+
+static int biovec_create_pools(struct bio_set *bs, int pool_entries, int scale)
+{
+	int	i;
+
+	for (i = 0; i < BIOVEC_NR_POOLS; i++) {
+		struct biovec_slab *	bp  = bs_compat_bvec_slabs + i;
+		mempool_t **		bvp = bs->bvec_pools + i;
+
+		if (i >= scale)
+			pool_entries >>= 1;
+
+		*bvp = mempool_create(pool_entries, mempool_alloc_slab,
+				mempool_free_slab, bp->slab);
+
+		if (!*bvp)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void bioset_free(struct bio_set *bs)
+{
+	if (!bs)
+		return;
+
+	biovec_free_pools(bs);
+
+	if (bs->bio_pool)
+		mempool_destroy(bs->bio_pool);
+
+	kfree(bs);
+	bs_compat_exit();
+}
+EXPORT_SYMBOL(bioset_free);
+
+struct bio_set *bioset_create(int bio_pool_size, int bvec_pool_size, int scale)
+{
+	struct bio_set *	bs;
+
+	if (bs_compat_init())
+		return NULL;
+
+	bs = kzalloc(sizeof(*bs), GFP_KERNEL);
+	if (!bs) {
+		bs_compat_exit();
+		return NULL;
+	}
+
+	bs->bio_pool = mempool_create(bio_pool_size, mempool_alloc_slab,
+				mempool_free_slab, bs_compat_bio_slab);
+	if (!bs->bio_pool)
+		goto bad;
+
+	if (!biovec_create_pools(bs, bvec_pool_size, scale))
+		return bs;
+
+bad:
+	bioset_free(bs);
+	return NULL;
+}
+EXPORT_SYMBOL(bioset_create);
+
+static inline struct bio_vec *bvec_alloc_bs(
+	gfp_t		gfp_mask,
+	int		nr,
+	unsigned long *	idx,
+	struct bio_set *bs)
+{
+	struct bio_vec *	bvl;
+	struct biovec_slab *	bp;
+
+        switch (nr) {
+		case   1        : *idx = 0; break;
+		case   2 ...   4: *idx = 1; break;
+		case   5 ...  16: *idx = 2; break;
+		case  17 ...  64: *idx = 3; break;
+		case  65 ... 128: *idx = 4; break;
+		case 129 ... BIO_MAX_PAGES: *idx = 5; break;
+		default:
+			return NULL;
+	}
+
+	bp  = bs_compat_bvec_slabs + *idx;
+	bvl = mempool_alloc(bs->bvec_pools[*idx], gfp_mask);
+	if (bvl)
+		memset(bvl, 0, bp->nr_vecs * sizeof(struct bio_vec));
+
+	return bvl;
+}
+
+void bio_free(struct bio *bio, struct bio_set *bio_set)
+{
+	const int pool_idx = BIO_POOL_IDX(bio);
+
+	BIO_BUG_ON(pool_idx >= BIOVEC_NR_POOLS);
+
+	mempool_free(bio->bi_io_vec, bio_set->bvec_pools[pool_idx]);
+	mempool_free(bio, bio_set->bio_pool);
+}
+EXPORT_SYMBOL(bio_free);
+
+void bio_init(struct bio *bio)
+{
+	bio->bi_next = NULL;
+	bio->bi_flags = 1 << BIO_UPTODATE;
+	bio->bi_rw = 0;
+	bio->bi_vcnt = 0;
+	bio->bi_idx = 0;
+	bio->bi_phys_segments = 0;
+	bio->bi_hw_segments = 0;
+	bio->bi_hw_front_size = 0;
+	bio->bi_hw_back_size = 0;
+	bio->bi_size = 0;
+	bio->bi_max_vecs = 0;
+	bio->bi_end_io = NULL;
+	atomic_set(&bio->bi_cnt, 1);
+	bio->bi_private = NULL;
+}
+
+struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
+{
+        struct bio *bio = mempool_alloc(bs->bio_pool, gfp_mask);
+
+        if (likely(bio)) {
+		struct bio_vec *bvl = NULL;
+
+		bio_init(bio);
+		if (likely(nr_iovecs)) {
+			unsigned long idx;
+
+			bvl = bvec_alloc_bs(gfp_mask, nr_iovecs, &idx, bs);
+			if (unlikely(!bvl)) {
+				mempool_free(bio, bs->bio_pool);
+				bio = NULL;
+				goto out;
+			}
+			bio->bi_flags |= idx << BIO_POOL_OFFSET;
+			bio->bi_max_vecs = bs_compat_bvec_slabs[idx].nr_vecs;
+		}
+		bio->bi_io_vec = bvl;
+	}
+out:
+	return bio;
+}
+EXPORT_SYMBOL(bio_alloc_bioset);
+
diff -Nurp linux-RHEL4-U4/drivers/md/dm-compat-bioset.h linux-RHEL4-U4-bioset/drivers/md/dm-compat-bioset.h
--- linux-RHEL4-U4/drivers/md/dm-compat-bioset.h	1970-01-01 01:00:00.000000000 +0100
+++ linux-RHEL4-U4-bioset/drivers/md/dm-compat-bioset.h	2006-08-14 13:05:42.000000000 +0200
@@ -0,0 +1,26 @@
+/*===========================================================================*/
+/*=========================== COMPAT START ==================================*/
+/* COMPAT: This is only required for older kernels that do not have bioset   */
+/*         functions exported by bio.h.                                      */
+/*===========================================================================*/
+#ifndef __DM_COMPAT_BIOSET_H__
+#define __DM_COMPAT_BIOSET_H__
+
+#include <linux/bio.h>
+#include <linux/mempool.h>
+
+#define BIOVEC_NR_POOLS	6
+
+struct bio_set;
+
+extern struct bio_set *bioset_create(int bio_pool_size, int bvec_pool_size,
+					int scale);
+extern void bioset_free(struct bio_set *bs);
+
+extern struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs,
+					struct bio_set *bs);
+
+extern void bio_free(struct bio *bio, struct bio_set *bio_set);
+
+#endif /* __DM_COMPAT_BIOSET_H__ */
+
diff -Nurp linux-RHEL4-U4/drivers/md/dm-io.c linux-RHEL4-U4-bioset/drivers/md/dm-io.c
--- linux-RHEL4-U4/drivers/md/dm-io.c	2005-07-08 12:32:59.000000000 +0200
+++ linux-RHEL4-U4-bioset/drivers/md/dm-io.c	2006-08-14 13:16:21.000000000 +0200
@@ -5,6 +5,7 @@
  */
 
 #include "dm-io.h"
+#include "dm-compat-bioset.h"
 
 #include <linux/bio.h>
 #include <linux/mempool.h>
@@ -12,207 +13,10 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 
-#define BIO_POOL_SIZE 256
-
-
-/*-----------------------------------------------------------------
- * Bio set, move this to bio.c
- *---------------------------------------------------------------*/
-#define BV_NAME_SIZE 16
-struct biovec_pool {
-	int nr_vecs;
-	char name[BV_NAME_SIZE];
-	kmem_cache_t *slab;
-	mempool_t *pool;
-	atomic_t allocated;	/* FIXME: debug */
-};
-
-#define BIOVEC_NR_POOLS 6
-struct bio_set {
-	char name[BV_NAME_SIZE];
-	kmem_cache_t *bio_slab;
-	mempool_t *bio_pool;
-	struct biovec_pool pools[BIOVEC_NR_POOLS];
-};
-
-static void bio_set_exit(struct bio_set *bs)
-{
-	unsigned i;
-	struct biovec_pool *bp;
-
-	if (bs->bio_pool)
-		mempool_destroy(bs->bio_pool);
-
-	if (bs->bio_slab)
-		kmem_cache_destroy(bs->bio_slab);
-
-	for (i = 0; i < BIOVEC_NR_POOLS; i++) {
-		bp = bs->pools + i;
-		if (bp->pool)
-			mempool_destroy(bp->pool);
-
-		if (bp->slab)
-			kmem_cache_destroy(bp->slab);
-	}
-}
-
-static void mk_name(char *str, size_t len, const char *prefix, unsigned count)
-{
-	snprintf(str, len, "%s-%u", prefix, count);
-}
-
-static int bio_set_init(struct bio_set *bs, const char *slab_prefix,
-			 unsigned pool_entries, unsigned scale)
-{
-	/* FIXME: this must match bvec_index(), why not go the
-	 * whole hog and have a pool per power of 2 ? */
-	static unsigned _vec_lengths[BIOVEC_NR_POOLS] = {
-		1, 4, 16, 64, 128, BIO_MAX_PAGES
-	};
-
-
-	unsigned i, size;
-	struct biovec_pool *bp;
-
-	/* zero the bs so we can tear down properly on error */
-	memset(bs, 0, sizeof(*bs));
-
-	/*
-	 * Set up the bio pool.
-	 */
-	snprintf(bs->name, sizeof(bs->name), "%s-bio", slab_prefix);
-
-	bs->bio_slab = kmem_cache_create(bs->name, sizeof(struct bio), 0,
-					 SLAB_HWCACHE_ALIGN, NULL, NULL);
-	if (!bs->bio_slab) {
-		DMWARN("can't init bio slab");
-		goto bad;
-	}
-
-	bs->bio_pool = mempool_create(pool_entries, mempool_alloc_slab,
-				      mempool_free_slab, bs->bio_slab);
-	if (!bs->bio_pool) {
-		DMWARN("can't init bio pool");
-		goto bad;
-	}
-
-	/*
-	 * Set up the biovec pools.
-	 */
-	for (i = 0; i < BIOVEC_NR_POOLS; i++) {
-		bp = bs->pools + i;
-		bp->nr_vecs = _vec_lengths[i];
-		atomic_set(&bp->allocated, 1); /* FIXME: debug */
-
-
-		size = bp->nr_vecs * sizeof(struct bio_vec);
-
-		mk_name(bp->name, sizeof(bp->name), slab_prefix, i);
-		bp->slab = kmem_cache_create(bp->name, size, 0,
-					     SLAB_HWCACHE_ALIGN, NULL, NULL);
-		if (!bp->slab) {
-			DMWARN("can't init biovec slab cache");
-			goto bad;
-		}
-
-		if (i >= scale)
-			pool_entries >>= 1;
-
-		bp->pool = mempool_create(pool_entries, mempool_alloc_slab,
-					  mempool_free_slab, bp->slab);
-		if (!bp->pool) {
-			DMWARN("can't init biovec mempool");
-			goto bad;
-		}
-	}
-
-	return 0;
-
- bad:
-	bio_set_exit(bs);
-	return -ENOMEM;
-}
-
-/* FIXME: blech */
-static inline unsigned bvec_index(unsigned nr)
-{
-	switch (nr) {
-	case 1:		return 0;
-	case 2 ... 4: 	return 1;
-	case 5 ... 16:	return 2;
-	case 17 ... 64:	return 3;
-	case 65 ... 128:return 4;
-	case 129 ... BIO_MAX_PAGES: return 5;
-	}
-
-	BUG();
-	return 0;
-}
-
-static inline void bs_bio_init(struct bio *bio)
-{
-	bio->bi_next = NULL;
-	bio->bi_flags = 1 << BIO_UPTODATE;
-	bio->bi_rw = 0;
-	bio->bi_vcnt = 0;
-	bio->bi_idx = 0;
-	bio->bi_phys_segments = 0;
-	bio->bi_hw_segments = 0;
-	bio->bi_size = 0;
-	bio->bi_max_vecs = 0;
-	bio->bi_end_io = NULL;
-	atomic_set(&bio->bi_cnt, 1);
-	bio->bi_private = NULL;
-}
-
-static unsigned _bio_count = 0;
-struct bio *bio_set_alloc(struct bio_set *bs, int gfp_mask, int nr_iovecs)
-{
-	struct biovec_pool *bp;
-	struct bio_vec *bv = NULL;
-	unsigned long idx;
-	struct bio *bio;
-
-	bio = mempool_alloc(bs->bio_pool, gfp_mask);
-	if (unlikely(!bio))
-		return NULL;
-
-	bio_init(bio);
-
-	if (likely(nr_iovecs)) {
-		idx = bvec_index(nr_iovecs);
-		bp = bs->pools + idx;
-		bv = mempool_alloc(bp->pool, gfp_mask);
-		if (!bv) {
-			mempool_free(bio, bs->bio_pool);
-			return NULL;
-		}
-
-		memset(bv, 0, bp->nr_vecs * sizeof(*bv));
-		bio->bi_flags |= idx << BIO_POOL_OFFSET;
-		bio->bi_max_vecs = bp->nr_vecs;
-		atomic_inc(&bp->allocated);
-	}
-
-	bio->bi_io_vec = bv;
-	return bio;
-}
-
-static void bio_set_free(struct bio_set *bs, struct bio *bio)
-{
-	struct biovec_pool *bp = bs->pools + BIO_POOL_IDX(bio);
-
-	if (atomic_dec_and_test(&bp->allocated))
-		BUG();
-
-	mempool_free(bio->bi_io_vec, bp->pool);
-	mempool_free(bio, bs->bio_pool);
-}
-
 /*-----------------------------------------------------------------
  * dm-io proper
  *---------------------------------------------------------------*/
-static struct bio_set _bios;
+static struct bio_set *_bios;
 
 /* FIXME: can we shrink this ? */
 struct io {
@@ -256,7 +60,8 @@ static int resize_pool(unsigned int new_
 			/* free off the pool */
 			mempool_destroy(_io_pool);
 			_io_pool = NULL;
-			bio_set_exit(&_bios);
+			bioset_free(_bios);
+			_bios = NULL;
 
 		} else {
 			/* resize the pool */
@@ -269,8 +74,8 @@ static int resize_pool(unsigned int new_
 		if (!_io_pool)
 			return -ENOMEM;
 
-		r = bio_set_init(&_bios, "dm-io", 512, 1);
-		if (r) {
+		_bios = bioset_create(256, 32, 4);
+		if (!_bios) {
 			mempool_destroy(_io_pool);
 			_io_pool = NULL;
 		}
@@ -365,8 +170,7 @@ static int endio(struct bio *bio, unsign
 
 static void bio_dtr(struct bio *bio)
 {
-	_bio_count--;
-	bio_set_free(&_bios, bio);
+	bio_free(bio, _bios);
 }
 
 /*-----------------------------------------------------------------
@@ -477,8 +281,7 @@ static void do_region(int rw, unsigned i
 		 * bvec for bio_get/set_region().
 		 */
 		num_bvecs = (remaining / (PAGE_SIZE >> 9)) + 2;
-		_bio_count++;
-		bio = bio_set_alloc(&_bios, GFP_NOIO, num_bvecs);
+		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, _bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
 		bio->bi_end_io = endio;
diff -Nurp linux-RHEL4-U4/drivers/md/Makefile linux-RHEL4-U4-bioset/drivers/md/Makefile
--- linux-RHEL4-U4/drivers/md/Makefile	2006-06-06 11:21:35.000000000 +0200
+++ linux-RHEL4-U4-bioset/drivers/md/Makefile	2006-08-14 13:05:28.000000000 +0200
@@ -3,7 +3,7 @@
 #
 
 dm-mod-objs	:= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
-		   dm-ioctl.o dm-io.o kcopyd.o
+		   dm-ioctl.o dm-io.o kcopyd.o dm-compat-bioset.c
 dm-multipath-objs := dm-hw-handler.o dm-path-selector.o dm-mpath.o
 dm-snapshot-objs := dm-snap.o dm-exception-store.o
 dm-mirror-objs	:= dm-log.o dm-raid1.o

--------------050400040703030003010802
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050400040703030003010802--
