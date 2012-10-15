From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 03/24] md: Convert md_trim_bio() to use bio_advance()
Date: Mon, 15 Oct 2012 13:08:37 -0700
Message-ID: <1350331769-14856-4-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: dm-devel.ids

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
CC: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
Acked-by: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
---
 drivers/md/md.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7a2b079..404a0ba 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -194,21 +194,12 @@ void md_trim_bio(struct bio *bio, int offset, int size)
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
+	bio->bi_size = size;
+
 	/* avoid any complications with bi_idx being non-zero*/
 	if (bio->bi_idx) {
 		memmove(bio->bi_io_vec, bio->bi_io_vec+bio->bi_idx,
-- 
1.7.12
