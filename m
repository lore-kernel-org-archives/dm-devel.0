From: Kent Overstreet <koverstreet@google.com>
Subject: [PATCH v2 22/26] block: Add bio_alloc_pages()
Date: Mon, 15 Oct 2012 13:09:25 -0700
Message-ID: <1350331769-14856-52-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk, neilb@suse.de
List-Id: dm-devel.ids

More utility code to replace stuff that's getting open coded.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c            | 28 ++++++++++++++++++++++++++++
 include/linux/bio.h |  1 +
 2 files changed, 29 insertions(+)

diff --git a/fs/bio.c b/fs/bio.c
index d88ad77..65e6eac 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -828,6 +828,34 @@ void bio_advance(struct bio *bio, unsigned bytes)
 EXPORT_SYMBOL(bio_advance);
 
 /**
+ * bio_alloc_pages - allocates a single page for each bvec in a bio
+ * @bio: bio to allocate pages for
+ * @gfp_mask: flags for allocation
+ *
+ * Allocates pages up to @bio->bi_vcnt.
+ *
+ * Returns 0 on success, -ENOMEM on failure. On failure, any allocated pages are
+ * freed.
+ */
+int bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
+{
+	int i;
+	struct bio_vec *bv;
+
+	bio_for_each_segment_all(bv, bio, i) {
+		bv->bv_page = alloc_page(gfp_mask);
+		if (!bv->bv_page) {
+			while (bv-- != bio->bi_io_vec)
+				__free_page(bv->bv_page);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(bio_alloc_pages);
+
+/**
  * bio_copy_data - copy contents of data buffers from one chain of bios to
  * another
  * @src: source bio list
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b433ff8..bd45154 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -289,6 +289,7 @@ static inline void bio_flush_dcache_pages(struct bio *bi)
 #endif
 
 extern void bio_copy_data(struct bio *dst, struct bio *src);
+extern int bio_alloc_pages(struct bio *bio, gfp_t gfp);
 
 extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
 				 unsigned long, unsigned int, int, gfp_t);
-- 
1.7.12
