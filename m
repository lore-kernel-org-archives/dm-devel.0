From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
Subject: [PATCH] dm: Fix possible NULL dereferences
Date: Mon, 20 Sep 2010 02:01:52 +0200
Message-ID: <20100920000152.GA1855@rere.qmqm.pl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

bio_alloc_bioset() might return NULL. Or maybe passed
bio_sets are guaranteed to have enough free bios?

Signed-off-by: Micha=B3 Miros=B3aw <mirq-linux@rere.qmqm.pl>
---
 drivers/md/dm.c |   48 ++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ac384b2..60cfacd 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1129,6 +1129,9 @@ static struct bio *split_bvec(struct bio *bio, sector=
_t sector,
 	struct bio_vec *bv =3D bio->bi_io_vec + idx;
 =

 	clone =3D bio_alloc_bioset(GFP_NOIO, 1, bs);
+	if (unlikely(!clone))
+		return NULL;
+
 	clone->bi_destructor =3D dm_bio_destructor;
 	*clone->bi_io_vec =3D *bv;
 =

@@ -1142,7 +1145,10 @@ static struct bio *split_bvec(struct bio *bio, secto=
r_t sector,
 	clone->bi_flags |=3D 1 << BIO_CLONED;
 =

 	if (bio_integrity(bio)) {
-		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
+		if (bio_integrity_clone(clone, bio, GFP_NOIO, bs) < 0) {
+			bio_put(clone);
+			return NULL;
+		}
 		bio_integrity_trim(clone,
 				   bio_sector_offset(bio, idx, offset), len);
 	}
@@ -1160,6 +1166,9 @@ static struct bio *clone_bio(struct bio *bio, sector_=
t sector,
 	struct bio *clone;
 =

 	clone =3D bio_alloc_bioset(GFP_NOIO, bio->bi_max_vecs, bs);
+	if (unlikely(!clone))
+		return NULL;
+
 	__bio_clone(clone, bio);
 	clone->bi_rw &=3D ~REQ_HARDBARRIER;
 	clone->bi_destructor =3D dm_bio_destructor;
@@ -1170,7 +1179,10 @@ static struct bio *clone_bio(struct bio *bio, sector=
_t sector,
 	clone->bi_flags &=3D ~(1 << BIO_SEG_VALID);
 =

 	if (bio_integrity(bio)) {
-		bio_integrity_clone(clone, bio, GFP_NOIO, bs);
+		if (bio_integrity_clone(clone, bio, GFP_NOIO, bs) < 0) {
+			bio_put(clone);
+			return NULL;
+		}
 =

 		if (idx !=3D bio->bi_idx || clone->bi_size < bio->bi_size)
 			bio_integrity_trim(clone,
@@ -1192,7 +1204,7 @@ static struct dm_target_io *alloc_tio(struct clone_in=
fo *ci,
 	return tio;
 }
 =

-static void __issue_target_request(struct clone_info *ci, struct dm_target=
 *ti,
+static int __issue_target_request(struct clone_info *ci, struct dm_target =
*ti,
 				   unsigned request_nr, sector_t len)
 {
 	struct dm_target_io *tio =3D alloc_tio(ci, ti);
@@ -1206,6 +1218,9 @@ static void __issue_target_request(struct clone_info =
*ci, struct dm_target *ti,
 	 * and discard, so no need for concern about wasted bvec allocations.
 	 */
 	clone =3D bio_alloc_bioset(GFP_NOIO, ci->bio->bi_max_vecs, ci->md->bs);
+	if (unlikely(!clone))
+		return -EIO;
+
 	__bio_clone(clone, ci->bio);
 	clone->bi_destructor =3D dm_bio_destructor;
 	if (len) {
@@ -1214,15 +1229,18 @@ static void __issue_target_request(struct clone_inf=
o *ci, struct dm_target *ti,
 	}
 =

 	__map_bio(ti, clone, tio);
+	return 0;
 }
 =

-static void __issue_target_requests(struct clone_info *ci, struct dm_targe=
t *ti,
+static int __issue_target_requests(struct clone_info *ci, struct dm_target=
 *ti,
 				    unsigned num_requests, sector_t len)
 {
 	unsigned request_nr;
 =

 	for (request_nr =3D 0; request_nr < num_requests; request_nr++)
-		__issue_target_request(ci, ti, request_nr, len);
+		if (__issue_target_request(ci, ti, request_nr, len) < 0)
+			return -EIO;
+	return 0;
 }
 =

 static int __clone_and_map_empty_barrier(struct clone_info *ci)
@@ -1231,7 +1249,8 @@ static int __clone_and_map_empty_barrier(struct clone=
_info *ci)
 	struct dm_target *ti;
 =

 	while ((ti =3D dm_table_get_target(ci->map, target_nr++)))
-		__issue_target_requests(ci, ti, ti->num_flush_requests, 0);
+		if (__issue_target_requests(ci, ti, ti->num_flush_requests, 0) < 0)
+			return -EIO;
 =

 	ci->sector_count =3D 0;
 =

@@ -1241,7 +1260,7 @@ static int __clone_and_map_empty_barrier(struct clone=
_info *ci)
 /*
  * Perform all io with a single clone.
  */
-static void __clone_and_map_simple(struct clone_info *ci, struct dm_target=
 *ti)
+static int __clone_and_map_simple(struct clone_info *ci, struct dm_target =
*ti)
 {
 	struct bio *clone, *bio =3D ci->bio;
 	struct dm_target_io *tio;
@@ -1250,8 +1269,11 @@ static void __clone_and_map_simple(struct clone_info=
 *ci, struct dm_target *ti)
 	clone =3D clone_bio(bio, ci->sector, ci->idx,
 			  bio->bi_vcnt - ci->idx, ci->sector_count,
 			  ci->md->bs);
+	if (unlikely(!clone))
+		return -EIO;
 	__map_bio(ti, clone, tio);
 	ci->sector_count =3D 0;
+	return 0;
 }
 =

 static int __clone_and_map_discard(struct clone_info *ci)
@@ -1274,7 +1296,8 @@ static int __clone_and_map_discard(struct clone_info =
*ci)
 =

 		len =3D min(ci->sector_count, max_io_len_target_boundary(ci->sector, ti)=
);
 =

-		__issue_target_requests(ci, ti, ti->num_discard_requests, len);
+		if (__issue_target_requests(ci, ti, ti->num_discard_requests, len) < 0)
+			return -EIO;
 =

 		ci->sector +=3D len;
 	} while (ci->sector_count -=3D len);
@@ -1306,7 +1329,7 @@ static int __clone_and_map(struct clone_info *ci)
 		 * Optimise for the simple case where we can do all of
 		 * the remaining io with a single clone.
 		 */
-		__clone_and_map_simple(ci, ti);
+		return __clone_and_map_simple(ci, ti);
 =

 	} else if (to_sector(bio->bi_io_vec[ci->idx].bv_len) <=3D max) {
 		/*
@@ -1330,6 +1353,8 @@ static int __clone_and_map(struct clone_info *ci)
 		tio =3D alloc_tio(ci, ti);
 		clone =3D clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len,
 				  ci->md->bs);
+		if (unlikely(!clone))
+			return -EIO;
 		__map_bio(ti, clone, tio);
 =

 		ci->sector +=3D len;
@@ -1359,7 +1384,8 @@ static int __clone_and_map(struct clone_info *ci)
 			clone =3D split_bvec(bio, ci->sector, ci->idx,
 					   bv->bv_offset + offset, len,
 					   ci->md->bs);
-
+			if (unlikely(!clone))
+				return -EIO;
 			__map_bio(ti, clone, tio);
 =

 			ci->sector +=3D len;
@@ -2510,6 +2536,8 @@ static int dm_rq_barrier(struct mapped_device *md)
 		ti =3D dm_table_get_target(map, i);
 		for (j =3D 0; j < ti->num_flush_requests; j++) {
 			clone =3D clone_rq(md->flush_request, md, GFP_NOIO);
+			if (unlikely(!clone))
+				return -EIO;
 			dm_rq_set_target_request_nr(clone, j);
 			atomic_inc(&md->pending[rq_data_dir(clone)]);
 			map_request(ti, clone, md);
-- =

1.7.1
