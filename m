From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2] dm: introduce get_num_duplicates method in
	dm_target
Date: Fri,  7 Dec 2012 18:20:08 -0500
Message-ID: <1354922409-12830-1-git-send-email-snitzer@redhat.com>
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
To: dm-devel@redhat.com
Cc: ejt@redhat.com
List-Id: dm-devel.ids

This allows a target to dynamically tell dm core how many copies of a
bio it needs.  The dm-cache target will make use of this for it's
write-through support.

Introduce __split_and_issue_bio_to_target to allow split_bvec to be used
with get_num_duplicates.

We already have hard coded instances of this (eg, num_flush_requests,
num_discard_requests).  These have been left for now, we can switch
everything over to use get_num_duplicates later.

(Based heavily on Joe's original work; ported to work with Mikulas' new
bio cloning via front padding)

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm.c               |   83 ++++++++++++++++++++++++++++++-----------
 include/linux/device-mapper.h |    8 ++++
 2 files changed, 69 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 08eea14..506c73a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1038,7 +1038,7 @@ struct clone_info {
  */
 static void split_bvec(struct dm_target_io *tio, struct bio *bio,
 		       sector_t sector, unsigned short idx, unsigned int offset,
-		       unsigned int len, struct bio_set *bs)
+		       unsigned int len)
 {
 	struct bio *clone = &tio->clone;
 	struct bio_vec *bv = bio->bi_io_vec + idx;
@@ -1104,6 +1104,20 @@ static struct dm_target_io *alloc_tio(struct clone_info *ci,
 	return tio;
 }
 
+static unsigned num_duplicate_bios_needed(struct dm_target *ti, struct bio *bio)
+{
+	if (bio->bi_rw & REQ_FLUSH)
+		return ti->num_flush_requests;
+
+	if (bio->bi_rw & REQ_DISCARD)
+		return ti->num_discard_requests;
+
+	if (ti->type->get_num_duplicates)
+		return ti->type->get_num_duplicates(ti, bio);
+
+	return 1;
+}
+
 static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
 				   unsigned request_nr, sector_t len)
 {
@@ -1128,12 +1142,12 @@ static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
 }
 
 static void __issue_target_requests(struct clone_info *ci, struct dm_target *ti,
-				    unsigned num_requests, sector_t len)
+				    sector_t len)
 {
-	unsigned request_nr;
+	unsigned i, num_requests = num_duplicate_bios_needed(ti, ci->bio);
 
-	for (request_nr = 0; request_nr < num_requests; request_nr++)
-		__issue_target_request(ci, ti, request_nr, len);
+	for (i = 0; i < num_requests; i++)
+		__issue_target_request(ci, ti, i, len);
 }
 
 static int __clone_and_map_empty_flush(struct clone_info *ci)
@@ -1143,23 +1157,54 @@ static int __clone_and_map_empty_flush(struct clone_info *ci)
 
 	BUG_ON(bio_has_data(ci->bio));
 	while ((ti = dm_table_get_target(ci->map, target_nr++)))
-		__issue_target_requests(ci, ti, ti->num_flush_requests, 0);
+		__issue_target_requests(ci, ti, 0);
 
 	return 0;
 }
 
+static void __issue_bio_to_target(struct clone_info *ci, struct dm_target *ti,
+				  struct bio *bio, sector_t sector,
+				  unsigned short idx, unsigned bv_count,
+				  unsigned len, struct bio_set *bs)
+{
+	unsigned i, num_duplicates = num_duplicate_bios_needed(ti, bio);
+	struct dm_target_io *tio;
+
+	for (i = 0; i < num_duplicates; i++) {
+		tio = alloc_tio(ci, ti, bio->bi_max_vecs);
+		tio->target_request_nr = i;
+		clone_bio(tio, bio, sector, idx, bv_count, len, bs);
+		__map_bio(ti, tio);
+	}
+}
+
+static void __split_and_issue_bio_to_target(struct clone_info *ci,
+					    struct dm_target *ti,
+					    struct bio *bio, sector_t sector,
+					    unsigned short idx, unsigned bv_count,
+					    unsigned len)
+{
+	unsigned i, num_duplicates = num_duplicate_bios_needed(ti, bio);
+	struct dm_target_io *tio;
+
+	for (i = 0; i < num_duplicates; i++) {
+		tio = alloc_tio(ci, ti, 1);
+		tio->target_request_nr = i;
+		split_bvec(tio, bio, sector, idx, bv_count, len);
+		__map_bio(ti, tio);
+	}
+}
+
 /*
  * Perform all io with a single clone.
  */
 static void __clone_and_map_simple(struct clone_info *ci, struct dm_target *ti)
 {
 	struct bio *bio = ci->bio;
-	struct dm_target_io *tio;
 
-	tio = alloc_tio(ci, ti, bio->bi_max_vecs);
-	clone_bio(tio, bio, ci->sector, ci->idx, bio->bi_vcnt - ci->idx,
-		  ci->sector_count, ci->md->bs);
-	__map_bio(ti, tio);
+	__issue_bio_to_target(ci, ti, bio, ci->sector, ci->idx,
+			      bio->bi_vcnt - ci->idx, ci->sector_count,
+			      ci->md->bs);
 	ci->sector_count = 0;
 }
 
@@ -1187,7 +1232,7 @@ static int __clone_and_map_discard(struct clone_info *ci)
 		else
 			len = min(ci->sector_count, max_io_len(ci->sector, ti));
 
-		__issue_target_requests(ci, ti, ti->num_discard_requests, len);
+		__issue_target_requests(ci, ti, len);
 
 		ci->sector += len;
 	} while (ci->sector_count -= len);
@@ -1200,7 +1245,6 @@ static int __clone_and_map(struct clone_info *ci)
 	struct bio *bio = ci->bio;
 	struct dm_target *ti;
 	sector_t len = 0, max;
-	struct dm_target_io *tio;
 
 	if (unlikely(bio->bi_rw & REQ_DISCARD))
 		return __clone_and_map_discard(ci);
@@ -1237,10 +1281,8 @@ static int __clone_and_map(struct clone_info *ci)
 			len += bv_len;
 		}
 
-		tio = alloc_tio(ci, ti, bio->bi_max_vecs);
-		clone_bio(tio, bio, ci->sector, ci->idx, i - ci->idx, len,
-			  ci->md->bs);
-		__map_bio(ti, tio);
+		__issue_bio_to_target(ci, ti, bio, ci->sector, ci->idx,
+				      i - ci->idx, len, ci->md->bs);
 
 		ci->sector += len;
 		ci->sector_count -= len;
@@ -1265,11 +1307,8 @@ static int __clone_and_map(struct clone_info *ci)
 
 			len = min(remaining, max);
 
-			tio = alloc_tio(ci, ti, 1);
-			split_bvec(tio, bio, ci->sector, ci->idx,
-				   bv->bv_offset + offset, len, ci->md->bs);
-
-			__map_bio(ti, tio);
+			__split_and_issue_bio_to_target(ci, ti, bio, ci->sector, ci->idx,
+							bv->bv_offset + offset, len);
 
 			ci->sector += len;
 			ci->sector_count -= len;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 1687f9e..2d65c70 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -39,6 +39,13 @@ typedef int (*dm_ctr_fn) (struct dm_target *target,
 typedef void (*dm_dtr_fn) (struct dm_target *ti);
 
 /*
+ * Some targets need to process multiple copies of a bio.  For instance a
+ * cache target in 'writethrough' mode will need to issue io to both the
+ * fast and slow devices.
+ */
+typedef unsigned (*dm_get_num_duplicates_fn)(struct dm_target *ti, struct bio *bio);
+
+/*
  * The map function must return:
  * < 0: error
  * = 0: The target will handle the io by resubmitting it later
@@ -131,6 +138,7 @@ struct target_type {
 	unsigned version[3];
 	dm_ctr_fn ctr;
 	dm_dtr_fn dtr;
+	dm_get_num_duplicates_fn get_num_duplicates;
 	dm_map_fn map;
 	dm_map_request_fn map_rq;
 	dm_endio_fn end_io;
-- 
1.7.1
