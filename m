From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] device-mapper core should use private bioset
Date: Mon, 14 Aug 2006 20:30:09 +0100
Message-ID: <20060814193009.GU18633@agk.surrey.redhat.com>
References: <44E068EC.20906@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <44E068EC.20906@de.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Stefan Bader <Stefan.Bader@de.ibm.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Aug 14, 2006 at 02:13:32PM +0200, Stefan Bader wrote:
> I found a problem within device-mapper that occurs in low-mem
> situations. It was found using a mirror target but I think in theory it
> would hit any setup that stacks device-mapper devices (like LVM on top
> of multipath).
> Since device-mapper core uses the common fs_bioset it is possible that
> the filesystem and the first level target successfully get bios but the
> lower level target doesn't because there is no more memory and the pool
> was drained by upper layers. So the remapping will be stuck forever.
> To solve this device-mapper core would have to use its own bioset. The
> following patch is against RHEL4-U4 but for head I guess only the stuff
> for dm.c (without hunk 1) and probably dm-io.c (if the bioset stuff
> there hasn't been replaced by the kernel built-in code, yet).
 
Here's a port of this to an upstream kernel: untested - the reordering
of the dec_pending looks suspicious - io now referenced after it's freed?

Please send patches against upstream kernels where possible, and
remember to add 'Signed-off-by' lines to everything!

Alasdair



From: Stefan Bader <Stefan.Bader@de.ibm.com>

I found a problem within device-mapper that occurs in low-mem
situations. It was found using a mirror target but I think in theory it
would hit any setup that stacks device-mapper devices (like LVM on top
of multipath).

Since device-mapper core uses the common fs_bioset 
[in clone_bio(), and a private, but still global, bio_set in split_bvec()]
it is possible that the filesystem and the first level target successfully
get bios but the lower level target doesn't because there is no more memory
and the pool was drained by upper layers. So the remapping will be stuck
forever.  To solve this device-mapper core [needs to use a private bio_set
for each device].

Index: linux-2.6.17/drivers/md/dm.c
===================================================================
--- linux-2.6.17.orig/drivers/md/dm.c	2006-08-14 19:14:27.000000000 +0100
+++ linux-2.6.17/drivers/md/dm.c	2006-08-14 20:19:01.000000000 +0100
@@ -102,6 +102,8 @@ struct mapped_device {
 	mempool_t *io_pool;
 	mempool_t *tio_pool;
 
+	struct bio_set *bs;
+
 	/*
 	 * Event handling.
 	 */
@@ -122,16 +124,10 @@ struct mapped_device {
 static kmem_cache_t *_io_cache;
 static kmem_cache_t *_tio_cache;
 
-static struct bio_set *dm_set;
-
 static int __init local_init(void)
 {
 	int r;
 
-	dm_set = bioset_create(16, 16, 4);
-	if (!dm_set)
-		return -ENOMEM;
-
 	/* allocate a slab for the dm_ios */
 	_io_cache = kmem_cache_create("dm_io",
 				      sizeof(struct dm_io), 0, 0, NULL, NULL);
@@ -165,8 +161,6 @@ static void local_exit(void)
 	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
 
-	bioset_free(dm_set);
-
 	if (unregister_blkdev(_major, _name) < 0)
 		DMERR("devfs_unregister_blkdev failed");
 
@@ -494,9 +488,9 @@ static int clone_endio(struct bio *bio, 
 			return 1;
 	}
 
-	free_tio(io->md, tio);
 	dec_pending(io, error);
 	bio_put(bio);
+	free_tio(io->md, tio);
 	return r;
 }
 
@@ -555,9 +549,9 @@ static void __map_bio(struct dm_target *
 	else if (r < 0) {
 		/* error the io and bail out */
 		struct dm_io *io = tio->io;
-		free_tio(tio->io->md, tio);
 		dec_pending(io, r);
 		bio_put(clone);
+		free_tio(tio->io->md, tio);
 	}
 }
 
@@ -573,7 +567,9 @@ struct clone_info {
 
 static void dm_bio_destructor(struct bio *bio)
 {
-	bio_free(bio, dm_set);
+	struct target_io *tio = bio->bi_private;
+
+	bio_free(bio, tio->io->md->bs);
 }
 
 /*
@@ -581,12 +577,12 @@ static void dm_bio_destructor(struct bio
  */
 static struct bio *split_bvec(struct bio *bio, sector_t sector,
 			      unsigned short idx, unsigned int offset,
-			      unsigned int len)
+			      unsigned int len, struct bio_set *bs)
 {
 	struct bio *clone;
 	struct bio_vec *bv = bio->bi_io_vec + idx;
 
-	clone = bio_alloc_bioset(GFP_NOIO, 1, dm_set);
+	clone = bio_alloc_bioset(GFP_NOIO, 1, bs);
 	clone->bi_destructor = dm_bio_destructor;
 	*clone->bi_io_vec = *bv;
 
@@ -606,11 +602,13 @@ static struct bio *split_bvec(struct bio
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
@@ -641,7 +639,8 @@ static void __clone_and_map(struct clone
 		 * the remaining io with a single clone.
 		 */
 		clone = clone_bio(bio, ci->sector, ci->idx,
-				  bio->bi_vcnt - ci->idx, ci->sector_count);
+				  bio->bi_vcnt - ci->idx, ci->sector_count,
+				  ci->md->bs);
 		__map_bio(ti, clone, tio);
 		ci->sector_count = 0;
 
@@ -664,7 +663,8 @@ static void __clone_and_map(struct clone
 			len += bv_len;
 		}
 
-		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len);
+		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len,
+				  ci->md->bs);
 		__map_bio(ti, clone, tio);
 
 		ci->sector += len;
@@ -693,7 +693,8 @@ static void __clone_and_map(struct clone
 			len = min(remaining, max);
 
 			clone = split_bvec(bio, ci->sector, ci->idx,
-					   bv->bv_offset + offset, len);
+					   bv->bv_offset + offset, len,
+					   ci->md->bs);
 
 			__map_bio(ti, clone, tio);
 
@@ -961,6 +962,10 @@ static struct mapped_device *alloc_dev(i
 	if (!md->tio_pool)
 		goto bad3;
 
+	md->bs = bioset_create(16, 16, 4);
+	if (!md->bs)
+		goto bad_no_bioset;
+
 	md->disk = alloc_disk(1);
 	if (!md->disk)
 		goto bad4;
@@ -988,6 +993,8 @@ static struct mapped_device *alloc_dev(i
 	return md;
 
  bad4:
+	bioset_free(md->bs);
+ bad_no_bioset:
 	mempool_destroy(md->tio_pool);
  bad3:
 	mempool_destroy(md->io_pool);
@@ -1012,6 +1019,7 @@ static void free_dev(struct mapped_devic
 	}
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
+	bioset_free(md->bs);
 	del_gendisk(md->disk);
 	free_minor(minor);
 
