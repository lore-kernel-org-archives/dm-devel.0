From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/9] md: Convert md_trim_bio() to use bio_advance()
Date: Fri,  7 Sep 2012 15:59:15 -0700
Message-ID: <1347058760-30794-5-git-send-email-koverstreet@google.com>
References: <1347058760-30794-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1347058760-30794-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
List-Id: dm-devel.ids

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
---
 drivers/md/md.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7a2b079..51ce48c 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -190,25 +190,16 @@ void md_trim_bio(struct bio *bio, int offset, int size)
 	struct bio_vec *bvec;
 	int sofar = 0;
 
-	size <<= 9;
 	if (offset == 0 && size == bio->bi_size)
 		return;
 
-	bio->bi_sector += offset;
-	bio->bi_size = size;
-	offset <<= 9;
 	clear_bit(BIO_SEG_VALID, &bio->bi_flags);
 
-	while (bio->bi_idx < bio->bi_vcnt &&
-	       bio->bi_io_vec[bio->bi_idx].bv_len <= offset) {
-		/* remove this whole bio_vec */
-		offset -= bio->bi_io_vec[bio->bi_idx].bv_len;
-		bio->bi_idx++;
-	}
-	if (bio->bi_idx < bio->bi_vcnt) {
-		bio->bi_io_vec[bio->bi_idx].bv_offset += offset;
-		bio->bi_io_vec[bio->bi_idx].bv_len -= offset;
-	}
+	bio_advance(bio, offset << 9);
+
+	size <<= 9;
+	bio->bi_size = size;
+
 	/* avoid any complications with bi_idx being non-zero*/
 	if (bio->bi_idx) {
 		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,
-- 
1.7.12
