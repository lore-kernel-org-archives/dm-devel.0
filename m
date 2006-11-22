From: Alasdair G Kergon <agk@redhat.com>
Subject: [PATCH 01/11] dm io: fix bi_max_vecs
Date: Wed, 22 Nov 2006 18:59:36 +0000
Message-ID: <20061122185936.GR6993@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@osdl.org>
Cc: Heinz Mauelshagen <hjm@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com
List-Id: dm-devel.ids

From: Heinz Mauelshagen <hjm@redhat.com>

The existing code allocates an extra slot in bi_io_vec[] and uses it to
store the region number.

This patch hides the extra slot from bio_add_page() so the region number
can't get overwritten.

Also remove a hard-coded SECTOR_SHIFT and fix a typo in a comment.

Signed-off-by: Heinz Mauelshagen <hjm@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
Cc: dm-devel@redhat.com

Index: linux-2.6.19-rc6/drivers/md/dm-io.c
===================================================================
--- linux-2.6.19-rc6.orig/drivers/md/dm-io.c	2006-11-22 17:26:47.000000000 +0000
+++ linux-2.6.19-rc6/drivers/md/dm-io.c	2006-11-22 17:26:53.000000000 +0000
@@ -92,12 +92,12 @@ void dm_io_put(unsigned int num_pages)
  *---------------------------------------------------------------*/
 static inline void bio_set_region(struct bio *bio, unsigned region)
 {
-	bio->bi_io_vec[bio->bi_max_vecs - 1].bv_len = region;
+	bio->bi_io_vec[bio->bi_max_vecs].bv_len = region;
 }
 
 static inline unsigned bio_get_region(struct bio *bio)
 {
-	return bio->bi_io_vec[bio->bi_max_vecs - 1].bv_len;
+	return bio->bi_io_vec[bio->bi_max_vecs].bv_len;
 }
 
 /*-----------------------------------------------------------------
@@ -136,6 +136,7 @@ static int endio(struct bio *bio, unsign
 		zero_fill_bio(bio);
 
 	dec_count(io, bio_get_region(bio), error);
+	bio->bi_max_vecs++;
 	bio_put(bio);
 
 	return 0;
@@ -250,16 +251,18 @@ static void do_region(int rw, unsigned i
 
 	while (remaining) {
 		/*
-		 * Allocate a suitably sized bio, we add an extra
-		 * bvec for bio_get/set_region().
+		 * Allocate a suitably sized-bio: we add an extra
+		 * bvec for bio_get/set_region() and decrement bi_max_vecs
+		 * to hide it from bio_add_page().
 		 */
-		num_bvecs = (remaining / (PAGE_SIZE >> 9)) + 2;
+		num_bvecs = (remaining / (PAGE_SIZE >> SECTOR_SHIFT)) + 2;
 		bio = bio_alloc_bioset(GFP_NOIO, num_bvecs, _bios);
 		bio->bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
 		bio->bi_end_io = endio;
 		bio->bi_private = io;
 		bio->bi_destructor = dm_bio_destructor;
+		bio->bi_max_vecs--;
 		bio_set_region(bio, region);
 
 		/*
@@ -302,7 +305,7 @@ static void dispatch_io(int rw, unsigned
 	}
 
 	/*
-	 * Drop the extra refence that we were holding to avoid
+	 * Drop the extra reference that we were holding to avoid
 	 * the io being completed too early.
 	 */
 	dec_count(io, 0, 0);
