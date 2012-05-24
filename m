From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 08/14] block: Kill bi_destructor
Date: Wed, 23 May 2012 17:02:45 -0700
Message-ID: <1337817771-25038-9-git-send-email-koverstreet@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337817771-25038-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, neilb-l3A5Bk7waGM@public.gmane.org, drbd-dev-cunTk1MwBs8qoQakbn7OcQ@public.gmane.org, bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mpatocka-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sage-BnTBU8nroG7k1uMJSBkQmQ@public.gmane.org, yehuda-L5o5AL9CYN0tUFlbccrkMA@public.gmane.org
List-Id: dm-devel.ids

Now that we've got generic code for freeing bios allocated from bio
pools, this isn't needed anymore.

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Change-Id: Iade939e76ff329cb03eef9125e4377ba1e4265c5
---
 Documentation/block/biodoc.txt |    5 -----
 fs/bio.c                       |   25 +++++++++----------------
 include/linux/blk_types.h      |    3 ---
 3 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index e418dc0..8df5e8e 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -465,7 +465,6 @@ struct bio {
        bio_end_io_t	*bi_end_io;  /* bi_end_io (bio) */
        atomic_t		bi_cnt;	     /* pin count: free when it hits zero */
        void             *bi_private;
-       bio_destructor_t *bi_destructor; /* bi_destructor (bio) */
 };
 
 With this multipage bio design:
@@ -647,10 +646,6 @@ for a non-clone bio. There are the 6 pools setup for different size biovecs,
 so bio_alloc(gfp_mask, nr_iovecs) will allocate a vec_list of the
 given size from these slabs.
 
-The bi_destructor() routine takes into account the possibility of the bio
-having originated from a different source (see later discussions on
-n/w to block transfers and kvec_cb)
-
 The bio_get() routine may be used to hold an extra reference on a bio prior
 to i/o submission, if the bio fields are likely to be accessed after the
 i/o is issued (since the bio may otherwise get freed in case i/o completion
diff --git a/fs/bio.c b/fs/bio.c
index 7d8c29d..fc4a168 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -234,6 +234,13 @@ void bio_free(struct bio *bio, struct bio_set *bs)
 {
 	void *p;
 
+	if (!bs) {
+		if (bio_integrity(bio))
+			bio_integrity_free(bio, fs_bio_set);
+		kfree(bio);
+		return;
+	}
+
 	if (bio_has_allocated_vec(bio))
 		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
@@ -343,13 +350,6 @@ struct bio *bio_alloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 }
 EXPORT_SYMBOL(bio_alloc);
 
-static void bio_kmalloc_destructor(struct bio *bio)
-{
-	if (bio_integrity(bio))
-		bio_integrity_free(bio, fs_bio_set);
-	kfree(bio);
-}
-
 /**
  * bio_kmalloc - allocate a bio for I/O using kmalloc()
  * @gfp_mask:   the GFP_ mask given to the slab allocator
@@ -376,7 +376,6 @@ struct bio *bio_kmalloc(gfp_t gfp_mask, unsigned int nr_iovecs)
 	bio->bi_flags |= BIO_POOL_NONE << BIO_POOL_OFFSET;
 	bio->bi_max_vecs = nr_iovecs;
 	bio->bi_io_vec = bio->bi_inline_vecs;
-	bio->bi_destructor = bio_kmalloc_destructor;
 
 	return bio;
 }
@@ -412,14 +411,8 @@ void bio_put(struct bio *bio)
 	/*
 	 * last put frees it
 	 */
-	if (atomic_dec_and_test(&bio->bi_cnt)) {
-		bio->bi_next = NULL;
-
-		if (bio->bi_pool)
-			bio_free(bio, bio->bi_pool);
-		else
-			bio->bi_destructor(bio);
-	}
+	if (atomic_dec_and_test(&bio->bi_cnt))
+		bio_free(bio, bio->bi_pool);
 }
 EXPORT_SYMBOL(bio_put);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 6b7daf3..b6ddbf1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -74,11 +74,8 @@ struct bio {
 	struct bio_integrity_payload *bi_integrity;  /* data integrity */
 #endif
 
-	/* If bi_pool is non NULL, bi_destructor is not called */
 	struct bio_set		*bi_pool;
 
-	bio_destructor_t	*bi_destructor;	/* destructor */
-
 	/*
 	 * We can inline a number of vecs at the end of the bio, to avoid
 	 * double allocations for a small number of bio_vecs. This member
-- 
1.7.9.3.327.g2980b
