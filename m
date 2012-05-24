From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 05/14] block: Only clone bio vecs that are in use
Date: Wed, 23 May 2012 17:02:42 -0700
Message-ID: <1337817771-25038-6-git-send-email-koverstreet@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337817771-25038-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

bcache creates large bios internally, and then splits them according to
the device requirements before it sends them down. If a lower level
device tries to clone the bio, and the original bio had more than
BIO_MAX_PAGES, the clone will fail unecessarily.

We can fix this by only cloning the bio vecs that are actually in use.

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/bio.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index e2c0970..de0733e 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -435,8 +435,9 @@ EXPORT_SYMBOL(bio_phys_segments);
  */
 void __bio_clone(struct bio *bio, struct bio *bio_src)
 {
-	memcpy(bio->bi_io_vec, bio_src->bi_io_vec,
-		bio_src->bi_max_vecs * sizeof(struct bio_vec));
+	memcpy(bio->bi_io_vec,
+	       bio_iovec(bio_src),
+	       bio_segments(bio_src) * sizeof(struct bio_vec));
 
 	/*
 	 * most users will be overriding ->bi_bdev with a new target,
@@ -445,10 +446,10 @@ void __bio_clone(struct bio *bio, struct bio *bio_src)
 	bio->bi_sector = bio_src->bi_sector;
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio->bi_flags |= 1 << BIO_CLONED;
+	bio->bi_flags &= ~(1 << BIO_SEG_VALID);
 	bio->bi_rw = bio_src->bi_rw;
-	bio->bi_vcnt = bio_src->bi_vcnt;
+	bio->bi_vcnt = bio_segments(bio_src);
 	bio->bi_size = bio_src->bi_size;
-	bio->bi_idx = bio_src->bi_idx;
 }
 EXPORT_SYMBOL(__bio_clone);
 
@@ -463,7 +464,7 @@ EXPORT_SYMBOL(__bio_clone);
 struct bio *bio_clone_bioset(struct bio *bio, gfp_t gfp_mask,
 			     struct bio_set *bs)
 {
-	struct bio *b = bio_alloc_bioset(gfp_mask, bio->bi_max_vecs, bs);
+	struct bio *b = bio_alloc_bioset(gfp_mask, bio_segments(bio), bs);
 
 	if (!b)
 		return NULL;
@@ -493,7 +494,7 @@ EXPORT_SYMBOL(bio_clone);
 
 struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
 {
-	struct bio *b = bio_kmalloc(gfp_mask, bio->bi_max_vecs);
+	struct bio *b = bio_kmalloc(gfp_mask, bio_segments(bio));
 
 	if (!b)
 		return NULL;
-- 
1.7.9.3.327.g2980b
