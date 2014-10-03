From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 1/4] dm: remove nr_iovecs parameter from
	alloc_tio()
Date: Fri,  3 Oct 2014 17:27:10 -0400
Message-ID: <1412371633-30356-1-git-send-email-snitzer@redhat.com>
References: <20141003204852.GA14135@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20141003204852.GA14135@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>, Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, Kent Overstreet <kmo@daterainc.com>
List-Id: dm-devel.ids

From: Junichi Nomura <j-nomura@ce.jp.nec.com>

alloc_tio() uses bio_alloc_bioset() to allocate a clone-bio for a bio.
alloc_tio() takes the number of bvecs to allocate for the clone-bio.
However, with v3.14's immutable biovec changes DM now uses
__bio_clone_fast() and no longer needs to allocate bvecs.

In practice, the 'nr_iovecs' passed to alloc_tio() is always effectively
0.  __clone_and_map_simple_bio() looked like it was passing non-zero
nr_iovecs, but its value was always within the range of inline bvecs and
no allocation actually happened.  If allocation happened, the BUG_ON() in
__bio_clone_fast() would've triggered.

Remove the nr_iovecs parameter from alloc_tio() to prevent possible
future bio_alloc_bioset() mis-use of a new bioset interface that will no
longer allow bvecs to be allocated.

Also fix extra whitespace before the __bio_clone_fast() call in
__clone_and_map_simple_bio().

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e1db62c..aaeed99 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1372,13 +1372,13 @@ static void clone_bio(struct dm_target_io *tio, struct bio *bio,
 }
 
 static struct dm_target_io *alloc_tio(struct clone_info *ci,
-				      struct dm_target *ti, int nr_iovecs,
+				      struct dm_target *ti,
 				      unsigned target_bio_nr)
 {
 	struct dm_target_io *tio;
 	struct bio *clone;
 
-	clone = bio_alloc_bioset(GFP_NOIO, nr_iovecs, ci->md->bs);
+	clone = bio_alloc_bioset(GFP_NOIO, 0, ci->md->bs);
 	tio = container_of(clone, struct dm_target_io, clone);
 
 	tio->io = ci->io;
@@ -1392,17 +1392,12 @@ static void __clone_and_map_simple_bio(struct clone_info *ci,
 				       struct dm_target *ti,
 				       unsigned target_bio_nr, unsigned *len)
 {
-	struct dm_target_io *tio = alloc_tio(ci, ti, ci->bio->bi_max_vecs, target_bio_nr);
+	struct dm_target_io *tio = alloc_tio(ci, ti, target_bio_nr);
 	struct bio *clone = &tio->clone;
 
 	tio->len_ptr = len;
 
-	/*
-	 * Discard requests require the bio's inline iovecs be initialized.
-	 * ci->bio->bi_max_vecs is BIO_INLINE_VECS anyway, for both flush
-	 * and discard, so no need for concern about wasted bvec allocations.
-	 */
-	 __bio_clone_fast(clone, ci->bio);
+	__bio_clone_fast(clone, ci->bio);
 	if (len)
 		bio_setup_sector(clone, ci->sector, *len);
 
@@ -1445,7 +1440,7 @@ static void __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti
 		num_target_bios = ti->num_write_bios(ti, bio);
 
 	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
-		tio = alloc_tio(ci, ti, 0, target_bio_nr);
+		tio = alloc_tio(ci, ti, target_bio_nr);
 		tio->len_ptr = len;
 		clone_bio(tio, bio, sector, *len);
 		__map_bio(tio);
-- 
1.9.3
