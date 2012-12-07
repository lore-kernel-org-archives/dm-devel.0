From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/2] dm: additional cleanup for clone_bio
Date: Fri,  7 Dec 2012 18:20:09 -0500
Message-ID: <1354922409-12830-2-git-send-email-snitzer@redhat.com>
References: <1354922409-12830-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1354922409-12830-1-git-send-email-snitzer@redhat.com>
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

Port split up of clone_bio as originally coded by Joe (prior to Mikulas'
per-bio patches).  In doing so it became clear there is no need to pass
bio_set to clone_bio.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Joe Thornber <ejt@redhat.com>
---
 drivers/md/dm.c |   62 +++++++++++++++++++++++++++++++-----------------------
 1 files changed, 36 insertions(+), 26 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 506c73a..739fd2b 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1061,23 +1061,23 @@ static void split_bvec(struct dm_target_io *tio, struct bio *bio,
 	}
 }
 
-/*
- * Creates a bio that consists of range of complete bvecs.
- */
-static void clone_bio(struct dm_target_io *tio, struct bio *bio,
-		      sector_t sector, unsigned short idx,
-		      unsigned short bv_count, unsigned int len,
-		      struct bio_set *bs)
+static void bio_setup_sector(struct bio *bio, sector_t sector, sector_t len)
 {
-	struct bio *clone = &tio->clone;
+	bio->bi_sector = sector;
+	bio->bi_size = to_bytes(len);
+}
 
-	__bio_clone(clone, bio);
-	clone->bi_sector = sector;
-	clone->bi_idx = idx;
-	clone->bi_vcnt = idx + bv_count;
-	clone->bi_size = to_bytes(len);
-	clone->bi_flags &= ~(1 << BIO_SEG_VALID);
+static void bio_setup_bv(struct bio *bio, unsigned short idx,
+			 unsigned short bv_count)
+{
+	bio->bi_idx = idx;
+	bio->bi_vcnt = idx + bv_count;
+	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
+}
 
+static void clone_bio_integrity(struct bio *bio, struct bio *clone,
+				unsigned short idx, unsigned int len)
+{
 	if (bio_integrity(bio)) {
 		bio_integrity_clone(clone, bio, GFP_NOIO);
 
@@ -1087,6 +1087,21 @@ static void clone_bio(struct dm_target_io *tio, struct bio *bio,
 	}
 }
 
+/*
+ * Creates a bio that consists of range of complete bvecs.
+ */
+static void clone_bio(struct dm_target_io *tio, struct bio *bio,
+		      sector_t sector, unsigned short idx,
+		      unsigned short bv_count, unsigned int len)
+{
+	struct bio *clone = &tio->clone;
+
+	__bio_clone(clone, bio);
+	bio_setup_sector(clone, sector, len);
+	bio_setup_bv(clone, idx, bv_count);
+	clone_bio_integrity(bio, clone, idx, len);
+}
+
 static struct dm_target_io *alloc_tio(struct clone_info *ci,
 				      struct dm_target *ti, int nr_iovecs)
 {
@@ -1131,13 +1146,9 @@ static void __issue_target_request(struct clone_info *ci, struct dm_target *ti,
 	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
 	 * and discard, so no need for concern about wasted bvec allocations.
 	 */
-
-	 __bio_clone(clone, ci->bio);
-	if (len) {
-		clone->bi_sector = ci->sector;
-		clone->bi_size = to_bytes(len);
-	}
-
+	__bio_clone(clone, ci->bio);
+	if (len)
+		bio_setup_sector(clone, ci->sector, len);
 	__map_bio(ti, tio);
 }
 
@@ -1165,7 +1176,7 @@ static int __clone_and_map_empty_flush(struct clone_info *ci)
 static void __issue_bio_to_target(struct clone_info *ci, struct dm_target *ti,
 				  struct bio *bio, sector_t sector,
 				  unsigned short idx, unsigned bv_count,
-				  unsigned len, struct bio_set *bs)
+				  unsigned len)
 {
 	unsigned i, num_duplicates = num_duplicate_bios_needed(ti, bio);
 	struct dm_target_io *tio;
@@ -1173,7 +1184,7 @@ static void __issue_bio_to_target(struct clone_info *ci, struct dm_target *ti,
 	for (i = 0; i < num_duplicates; i++) {
 		tio = alloc_tio(ci, ti, bio->bi_max_vecs);
 		tio->target_request_nr = i;
-		clone_bio(tio, bio, sector, idx, bv_count, len, bs);
+		clone_bio(tio, bio, sector, idx, bv_count, len);
 		__map_bio(ti, tio);
 	}
 }
@@ -1203,8 +1214,7 @@ static void __clone_and_map_simple(struct clone_info *ci, struct dm_target *ti)
 	struct bio *bio = ci->bio;
 
 	__issue_bio_to_target(ci, ti, bio, ci->sector, ci->idx,
-			      bio->bi_vcnt - ci->idx, ci->sector_count,
-			      ci->md->bs);
+			      bio->bi_vcnt - ci->idx, ci->sector_count);
 	ci->sector_count = 0;
 }
 
@@ -1282,7 +1292,7 @@ static int __clone_and_map(struct clone_info *ci)
 		}
 
 		__issue_bio_to_target(ci, ti, bio, ci->sector, ci->idx,
-				      i - ci->idx, len, ci->md->bs);
+				      i - ci->idx, len);
 
 		ci->sector += len;
 		ci->sector_count -= len;
-- 
1.7.1
