From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH 02/22] dm: Use bvec_iter for dm_bio_record()
Date: Wed, 27 Mar 2013 10:39:32 -0700
Message-ID: <1364405992-28424-3-git-send-email-koverstreet@google.com>
References: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1364405992-28424-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@vger.kernel.org
Cc: tj@kernel.org, neilb@suse.de, Kent Overstreet <koverstreet@google.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

CC: Alasdair Kergon <agk@redhat.com>
CC: dm-devel@redhat.com
Signed-off-by: Kent Overstreet <koverstreet@google.com>
---
 drivers/md/dm-bio-record.h | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-bio-record.h b/drivers/md/dm-bio-record.h
index 5ace48e..4f46e8e 100644
--- a/drivers/md/dm-bio-record.h
+++ b/drivers/md/dm-bio-record.h
@@ -28,11 +28,9 @@ struct dm_bio_vec_details {
 };
 
 struct dm_bio_details {
-	sector_t bi_sector;
 	struct block_device *bi_bdev;
-	unsigned int bi_size;
-	unsigned short bi_idx;
 	unsigned long bi_flags;
+	struct bvec_iter bi_iter;
 	struct dm_bio_vec_details bi_io_vec[BIO_MAX_PAGES];
 };
 
@@ -40,11 +38,9 @@ static inline void dm_bio_record(struct dm_bio_details *bd, struct bio *bio)
 {
 	unsigned i;
 
-	bd->bi_sector = bio->bi_iter.bi_sector;
 	bd->bi_bdev = bio->bi_bdev;
-	bd->bi_size = bio->bi_iter.bi_size;
-	bd->bi_idx = bio->bi_iter.bi_idx;
 	bd->bi_flags = bio->bi_flags;
+	bd->bi_iter = bio->bi_iter;
 
 	for (i = 0; i < bio->bi_vcnt; i++) {
 		bd->bi_io_vec[i].bv_len = bio->bi_io_vec[i].bv_len;
@@ -56,11 +52,9 @@ static inline void dm_bio_restore(struct dm_bio_details *bd, struct bio *bio)
 {
 	unsigned i;
 
-	bio->bi_iter.bi_sector = bd->bi_sector;
 	bio->bi_bdev = bd->bi_bdev;
-	bio->bi_iter.bi_size = bd->bi_size;
-	bio->bi_iter.bi_idx = bd->bi_idx;
 	bio->bi_flags = bd->bi_flags;
+	bio->bi_iter = bd->bi_iter;
 
 	for (i = 0; i < bio->bi_vcnt; i++) {
 		bio->bi_io_vec[i].bv_len = bd->bi_io_vec[i].bv_len;
-- 
1.8.1.3
