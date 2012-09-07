From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] block: Reorder struct bio_set
Date: Fri,  7 Sep 2012 15:12:52 -0700
Message-ID: <1347055973-11581-2-git-send-email-koverstreet@google.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
Return-path: <linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1347055973-11581-1-git-send-email-koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-bcache-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-bcache-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
List-Id: dm-devel.ids

This is prep work for the next patch, which embeds a struct bio_list in
struct bio_set.

Signed-off-by: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
CC: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
---
 include/linux/bio.h | 66 ++++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 52b9cbc..a2bfe3a 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -298,39 +298,6 @@ static inline int bio_associate_current(struct bio *bio) { return -ENOENT; }
 static inline void bio_disassociate_task(struct bio *bio) { }
 #endif	/* CONFIG_BLK_CGROUP */
 
-/*
- * bio_set is used to allow other portions of the IO system to
- * allocate their own private memory pools for bio and iovec structures.
- * These memory pools in turn all allocate from the bio_slab
- * and the bvec_slabs[].
- */
-#define BIO_POOL_SIZE 2
-#define BIOVEC_NR_POOLS 6
-#define BIOVEC_MAX_IDX	(BIOVEC_NR_POOLS - 1)
-
-struct bio_set {
-	struct kmem_cache *bio_slab;
-	unsigned int front_pad;
-
-	mempool_t *bio_pool;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-	mempool_t *bio_integrity_pool;
-#endif
-	mempool_t *bvec_pool;
-};
-
-struct biovec_slab {
-	int nr_vecs;
-	char *name;
-	struct kmem_cache *slab;
-};
-
-/*
- * a small number of entries is fine, not going to be performance critical.
- * basically we just need to survive
- */
-#define BIO_SPLIT_ENTRIES 2
-
 #ifdef CONFIG_HIGHMEM
 /*
  * remember never ever reenable interrupts between a bvec_kmap_irq and
@@ -505,6 +472,39 @@ static inline struct bio *bio_list_get(struct bio_list *bl)
 	return bio;
 }
 
+/*
+ * bio_set is used to allow other portions of the IO system to
+ * allocate their own private memory pools for bio and iovec structures.
+ * These memory pools in turn all allocate from the bio_slab
+ * and the bvec_slabs[].
+ */
+#define BIO_POOL_SIZE 2
+#define BIOVEC_NR_POOLS 6
+#define BIOVEC_MAX_IDX	(BIOVEC_NR_POOLS - 1)
+
+struct bio_set {
+	struct kmem_cache *bio_slab;
+	unsigned int front_pad;
+
+	mempool_t *bio_pool;
+#if defined(CONFIG_BLK_DEV_INTEGRITY)
+	mempool_t *bio_integrity_pool;
+#endif
+	mempool_t *bvec_pool;
+};
+
+struct biovec_slab {
+	int nr_vecs;
+	char *name;
+	struct kmem_cache *slab;
+};
+
+/*
+ * a small number of entries is fine, not going to be performance critical.
+ * basically we just need to survive
+ */
+#define BIO_SPLIT_ENTRIES 2
+
 #if defined(CONFIG_BLK_DEV_INTEGRITY)
 
 #define bip_vec_idx(bip, idx)	(&(bip->bip_vec[(idx)]))
-- 
1.7.12
