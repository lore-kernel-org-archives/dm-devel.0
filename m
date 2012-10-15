From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 24/26] block: Add an explicit bio flag for bios that own their bvec
Date: Mon, 15 Oct 2012 13:09:27 -0700
Message-ID: <1350331769-14856-54-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org
List-Id: dm-devel.ids

This is for the new bio splitting code. When we split a bio, if the
split occured on a bvec boundry we reuse the bvec for the new bio. But
that means bio_free() can't free it, hence the explicit flag.

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 fs/bio.c                  | 4 +++-
 include/linux/bio.h       | 5 -----
 include/linux/blk_types.h | 1 +
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 65e6eac..5e91e36 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -250,7 +250,7 @@ static void bio_free(struct bio *bio)
 	__bio_free(bio);
 
 	if (bs) {
-		if (bio_has_allocated_vec(bio))
+		if (bio_flagged(bio, BIO_OWNS_VEC))
 			bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
 		/*
@@ -449,6 +449,8 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 
 		if (unlikely(!bvl))
 			goto err_free;
+
+		bio->bi_flags |= 1 << BIO_OWNS_VEC;
 	} else if (nr_iovecs) {
 		bvl = bio->bi_inline_vecs;
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index bd45154..edd66f3 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -85,11 +85,6 @@ static inline void *bio_data(struct bio *bio)
 	return NULL;
 }
 
-static inline int bio_has_allocated_vec(struct bio *bio)
-{
-	return bio->bi_io_vec && bio->bi_io_vec != bio->bi_inline_vecs;
-}
-
 /*
  * will die
  */
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 3eefbb2..e9375cf 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -117,6 +117,7 @@ struct bio {
  * BIO_POOL_IDX()
  */
 #define BIO_RESET_BITS	12
+#define BIO_OWNS_VEC	12	/* bio_free() should free bvec */
 
 #define bio_flagged(bio, flag)	((bio)->bi_flags & (1 << (flag)))
 
-- 
1.7.12
