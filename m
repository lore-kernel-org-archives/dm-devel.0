From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 20/22] dm: Don't save bvec anymore
Date: Wed, 27 Mar 2013 10:39:50 -0700
Message-ID: <1364405992-28424-21-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Now that drivers have been converted to the bvec_iter primitives, they
shouldn't be modifying the biovec anymore and thus saving it is
unnecessary.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
---
 drivers/md/dm-bio-record.h | 25 -------------------------
 1 file changed, 25 deletions(-)

diff --git a/drivers/md/dm-bio-record.h b/drivers/md/dm-bio-record.h
index 4f46e8e..dd36461 100644
--- a/drivers/md/dm-bio-record.h
+++ b/drivers/md/dm-bio-record.h
@@ -17,49 +17,24 @@
  * original bio state.
  */
 
-struct dm_bio_vec_details {
-#if PAGE_SIZE < 65536
-	__u16 bv_len;
-	__u16 bv_offset;
-#else
-	unsigned bv_len;
-	unsigned bv_offset;
-#endif
-};
-
 struct dm_bio_details {
 	struct block_device *bi_bdev;
 	unsigned long bi_flags;
 	struct bvec_iter bi_iter;
-	struct dm_bio_vec_details bi_io_vec[BIO_MAX_PAGES];
 };
 
 static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
 {
-	unsigned i;
-
 	bd->bi_bdev = bio->bi_bdev;
 	bd->bi_flags = bio->bi_flags;
 	bd->bi_iter = bio->bi_iter;
-
-	for (i = 0; i < bio->bi_vcnt; i++) {
-		bd->bi_io_vec[i].bv_len = bio->bi_io_vec[i].bv_len;
-		bd->bi_io_vec[i].bv_offset = bio->bi_io_vec[i].bv_offset;
-	}
 }
 
 static inline void dm_bio_restore(struct dm_bio_details *bd, struct bio *bio)
 {
-	unsigned i;
-
 	bio->bi_bdev = bd->bi_bdev;
 	bio->bi_flags = bd->bi_flags;
 	bio->bi_iter = bd->bi_iter;
-
-	for (i = 0; i < bio->bi_vcnt; i++) {
-		bio->bi_io_vec[i].bv_len = bd->bi_io_vec[i].bv_len;
-		bio->bi_io_vec[i].bv_offset = bd->bi_io_vec[i].bv_offset;
-	}
 }
 
 #endif
-- 
1.8.1.3
