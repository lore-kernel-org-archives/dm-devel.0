From: Stefan Bader <Stefan.Bader@de.ibm.com>
Subject: Re: Re: [PATCH] device-mapper core should use private
	bioset
Date: Tue, 15 Aug 2006 17:03:34 +0200
Message-ID: <44E1E246.2000608@de.ibm.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080602070204090602070500"
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
To: dm-devel@redhat.com
Cc: agk@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------080602070204090602070500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


> Here's a port of this to an upstream kernel: untested - the reordering
> of the dec_pending looks suspicious - io now referenced after it's
> freed?

Right, I think now everything is done in the right order. Though I had
to add another field to target_io.

> Please send patches against upstream kernels where possible, and
> remember to add 'Signed-off-by' lines to everything!
>
>Alasdair

I reworked the patch against the 2.6.17 kernel and did a quick test run
with a simple target. In the upstream kernel the bioset stuff has only
to be modified to be local to each mapped device instead of one for all.

Stefan


Signed-off-by: Stefan Bader <shbader@ibm.com>



--------------080602070204090602070500
Content-Type: text/plain;
 name="dm-move-bioset.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dm-move-bioset.diff"

diff -Nurp linux-2.6.17/drivers/md/dm.c linux-2.6.17-new/drivers/md/dm.c
--- linux-2.6.17/drivers/md/dm.c	2006-06-19 14:01:40.000000000 +0200
+++ linux-2.6.17-new/drivers/md/dm.c	2006-08-15 16:21:30.000000000 +0200
@@ -44,6 +44,7 @@ struct dm_io {
 struct target_io {
 	struct dm_io *io;
 	struct dm_target *ti;
+	struct bio_set *bs;
 	union map_info info;
 };
 
@@ -92,6 +93,11 @@ struct mapped_device {
 	 */
 	mempool_t *io_pool;
 	mempool_t *tio_pool;
+	/*
+	 * Bio objects are allocated from this private pool instead of the
+	 * global one.
+	 */
+	struct bio_set *bio_pool;
 
 	/*
 	 * Event handling.
@@ -113,16 +119,10 @@ struct mapped_device {
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
@@ -156,8 +156,6 @@ static void local_exit(void)
 	kmem_cache_destroy(_tio_cache);
 	kmem_cache_destroy(_io_cache);
 
-	bioset_free(dm_set);
-
 	if (unregister_blkdev(_major, _name) < 0)
 		DMERR("devfs_unregister_blkdev failed");
 
@@ -386,7 +384,7 @@ static int clone_endio(struct bio *bio, 
 {
 	int r = 0;
 	struct target_io *tio = bio->bi_private;
-	struct dm_io *io = tio->io;
+	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
 	if (bio->bi_size)
@@ -405,9 +403,13 @@ static int clone_endio(struct bio *bio, 
 			return 1;
 	}
 
-	free_tio(io->md, tio);
-	dec_pending(io, error);
+	dec_pending(tio->io, error);
+	/*
+	 * First release bio because destructor needs valid reference to
+	 * target_io to find the correct bio_set.
+	 */
 	bio_put(bio);
+	free_tio(md, tio);
 	return r;
 }
 
@@ -465,10 +467,14 @@ static void __map_bio(struct dm_target *
 
 	else if (r < 0) {
 		/* error the io and bail out */
-		struct dm_io *io = tio->io;
-		free_tio(tio->io->md, tio);
-		dec_pending(io, r);
+		struct mapped_device *md = tio->io->md;
+		dec_pending(tio->io, r);
+		/*
+		 * First release bio because destructor needs valid reference
+		 * to target_io to find the correct bio_set.
+		 */
 		bio_put(clone);
+		free_tio(md, tio);
 	}
 }
 
@@ -484,7 +490,11 @@ struct clone_info {
 
 static void dm_bio_destructor(struct bio *bio)
 {
-	bio_free(bio, dm_set);
+	struct target_io *tio = bio->bi_private;
+
+	BUG_ON(!tio);
+
+	bio_free(bio, tio->bs);
 }
 
 /*
@@ -492,12 +502,12 @@ static void dm_bio_destructor(struct bio
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
 
@@ -517,11 +527,13 @@ static struct bio *split_bvec(struct bio
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
@@ -544,6 +556,7 @@ static void __clone_and_map(struct clone
 	tio = alloc_tio(ci->md);
 	tio->io = ci->io;
 	tio->ti = ti;
+	tio->bs = ci->md->bio_pool;
 	memset(&tio->info, 0, sizeof(tio->info));
 
 	if (ci->sector_count <= max) {
@@ -552,7 +565,8 @@ static void __clone_and_map(struct clone
 		 * the remaining io with a single clone.
 		 */
 		clone = clone_bio(bio, ci->sector, ci->idx,
-				  bio->bi_vcnt - ci->idx, ci->sector_count);
+				  bio->bi_vcnt - ci->idx, ci->sector_count,
+				  tio->bs);
 		__map_bio(ti, clone, tio);
 		ci->sector_count = 0;
 
@@ -575,7 +589,8 @@ static void __clone_and_map(struct clone
 			len += bv_len;
 		}
 
-		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len);
+		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len,
+				  tio->bs);
 		__map_bio(ti, clone, tio);
 
 		ci->sector += len;
@@ -598,13 +613,15 @@ static void __clone_and_map(struct clone
 				tio = alloc_tio(ci->md);
 				tio->io = ci->io;
 				tio->ti = ti;
+				tio->bs = ci->md->bio_pool;
 				memset(&tio->info, 0, sizeof(tio->info));
 			}
 
 			len = min(remaining, max);
 
 			clone = split_bvec(bio, ci->sector, ci->idx,
-					   bv->bv_offset + offset, len);
+					   bv->bv_offset + offset, len,
+					   tio->bs);
 
 			__map_bio(ti, clone, tio);
 
@@ -871,6 +888,10 @@ static struct mapped_device *alloc_dev(u
 	if (!md->tio_pool)
 		goto bad3;
 
+	md->bio_pool = bioset_create(16, 16, 4);
+	if (!md->bio_pool)
+		goto bad_no_bioset;
+
 	md->disk = alloc_disk(1);
 	if (!md->disk)
 		goto bad4;
@@ -891,6 +912,8 @@ static struct mapped_device *alloc_dev(u
 	return md;
 
  bad4:
+	bioset_free(md->bio_pool);
+ bad_no_bioset:
 	mempool_destroy(md->tio_pool);
  bad3:
 	mempool_destroy(md->io_pool);
@@ -912,6 +935,7 @@ static void free_dev(struct mapped_devic
 	}
 	mempool_destroy(md->tio_pool);
 	mempool_destroy(md->io_pool);
+	bioset_free(md->bio_pool);
 	del_gendisk(md->disk);
 	free_minor(minor);
 	put_disk(md->disk);

--------------080602070204090602070500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------080602070204090602070500--
