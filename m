From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: [PATCH 1/4] dm: remove nr_iovecs parameter from
	alloc_tio()
Date: Fri, 3 Oct 2014 11:55:16 +0000
Message-ID: <542E8EA4.2010704@ce.jp.nec.com>
References: <542E8CF9.6000609@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <542E8CF9.6000609@ce.jp.nec.com>
Content-Language: ja-JP
Content-ID: <7D67CBFB1F67B14597FE2A62CC226E8D@gisp.nec.co.jp>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>
List-Id: dm-devel.ids

alloc_tio() allocates a bio for clone. It takes the number of
bvecs to allocate for the clone-bio.
However, with the introduction of bio_clone_fast() in v3.14,
we no longer need to allocate bvecs and nr_iovecs is always 0.

__clone_and_map_simple_bio() looks like passing non-zero
nr_iovecs, but its value is always within the range of
inline bvecs and no allocation actually happens.
If allocation happened, BUG_ON() in __bio_clone_fast() would
trigger.

This patch removes the nr_iovecs parameter from alloc_tio()
to prevent possible future mis-use of the interface.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/md/dm.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 32b958d..4210b3c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1249,13 +1249,13 @@ static void clone_bio(struct dm_target_io *tio, struct bio *bio,
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
@@ -1269,16 +1269,11 @@ static void __clone_and_map_simple_bio(struct clone_info *ci,
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
 	 __bio_clone_fast(clone, ci->bio);
 	if (len)
 		bio_setup_sector(clone, ci->sector, *len);
@@ -1322,7 +1317,7 @@ static void __clone_and_map_data_bio(struct clone_info *ci, struct dm_target *ti
 		num_target_bios = ti->num_write_bios(ti, bio);
 
 	for (target_bio_nr = 0; target_bio_nr < num_target_bios; target_bio_nr++) {
-		tio = alloc_tio(ci, ti, 0, target_bio_nr);
+		tio = alloc_tio(ci, ti, target_bio_nr);
 		tio->len_ptr = len;
 		clone_bio(tio, bio, sector, *len);
 		__map_bio(tio);
-- 
1.9.3
