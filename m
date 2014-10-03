From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 3/4] block: add bioset_create_nobvec()
Date: Fri,  3 Oct 2014 17:27:12 -0400
Message-ID: <1412371633-30356-3-git-send-email-snitzer@redhat.com>
References: <1412371633-30356-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1412371633-30356-1-git-send-email-snitzer@redhat.com>
In-Reply-To: <20141003204852.GA14135@redhat.com>
References: <20141003204852.GA14135@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: snitzer@redhat.com, Junichi Nomura <j-nomura@ce.jp.nec.com>, Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, Kent Overstreet <kmo@daterainc.com>
List-Id: dm-devel.ids

From: Junichi Nomura <j-nomura@ce.jp.nec.com>

Users of bio_clone_fast() do not want bios with their own bvecs.
Allocating a bvec mempool as part of the bioset intended for such users
is a waste of memory.

bioset_create_nobvec() creates a bioset that doesn't have the bvec
mempool.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/bio.c         | 61 ++++++++++++++++++++++++++++++++++++++---------------
 include/linux/bio.h |  1 +
 2 files changed, 45 insertions(+), 17 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 3e6331d..3e6e198 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -428,6 +428,9 @@ struct bio *bio_alloc_bioset(gfp_t gfp_mask, int nr_iovecs, struct bio_set *bs)
 		front_pad = 0;
 		inline_vecs = nr_iovecs;
 	} else {
+		/* should not use nobvec bioset for nr_iovecs > 0 */
+		if (WARN_ON_ONCE(!bs->bvec_pool && nr_iovecs > 0))
+			return NULL;
 		/*
 		 * generic_make_request() converts recursion to iteration; this
 		 * means if we're running beneath it, any bios we allocate and
@@ -1900,20 +1903,9 @@ void bioset_free(struct bio_set *bs)
 }
 EXPORT_SYMBOL(bioset_free);
 
-/**
- * bioset_create  - Create a bio_set
- * @pool_size:	Number of bio and bio_vecs to cache in the mempool
- * @front_pad:	Number of bytes to allocate in front of the returned bio
- *
- * Description:
- *    Set up a bio_set to be used with @bio_alloc_bioset. Allows the caller
- *    to ask for a number of bytes to be allocated in front of the bio.
- *    Front pad allocation is useful for embedding the bio inside
- *    another structure, to avoid allocating extra data to go with the bio.
- *    Note that the bio must be embedded at the END of that structure always,
- *    or things will break badly.
- */
-struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
+static struct bio_set *__bioset_create(unsigned int pool_size,
+				       unsigned int front_pad,
+				       bool create_bvec_pool)
 {
 	unsigned int back_pad = BIO_INLINE_VECS * sizeof(struct bio_vec);
 	struct bio_set *bs;
@@ -1938,9 +1930,11 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 	if (!bs->bio_pool)
 		goto bad;
 
-	bs->bvec_pool = biovec_create_pool(pool_size);
-	if (!bs->bvec_pool)
-		goto bad;
+	if (create_bvec_pool) {
+		bs->bvec_pool = biovec_create_pool(pool_size);
+		if (!bs->bvec_pool)
+			goto bad;
+	}
 
 	bs->rescue_workqueue = alloc_workqueue("bioset", WQ_MEM_RECLAIM, 0);
 	if (!bs->rescue_workqueue)
@@ -1951,8 +1945,41 @@ bad:
 	bioset_free(bs);
 	return NULL;
 }
+
+/**
+ * bioset_create  - Create a bio_set
+ * @pool_size:	Number of bio and bio_vecs to cache in the mempool
+ * @front_pad:	Number of bytes to allocate in front of the returned bio
+ *
+ * Description:
+ *    Set up a bio_set to be used with @bio_alloc_bioset. Allows the caller
+ *    to ask for a number of bytes to be allocated in front of the bio.
+ *    Front pad allocation is useful for embedding the bio inside
+ *    another structure, to avoid allocating extra data to go with the bio.
+ *    Note that the bio must be embedded at the END of that structure always,
+ *    or things will break badly.
+ */
+struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
+{
+	return __bioset_create(pool_size, front_pad, true);
+}
 EXPORT_SYMBOL(bioset_create);
 
+/**
+ * bioset_create_nobvec  - Create a bio_set without bio_vec mempool
+ * @pool_size:	Number of bio to cache in the mempool
+ * @front_pad:	Number of bytes to allocate in front of the returned bio
+ *
+ * Description:
+ *    Same functionality as bioset_create() except that mempool is not
+ *    created for bio_vecs. Saving some memory for bio_clone_fast() users.
+ */
+struct bio_set *bioset_create_nobvec(unsigned int pool_size, unsigned int front_pad)
+{
+	return __bioset_create(pool_size, front_pad, false);
+}
+EXPORT_SYMBOL(bioset_create_nobvec);
+
 #ifdef CONFIG_BLK_CGROUP
 /**
  * bio_associate_current - associate a bio with %current
diff --git a/include/linux/bio.h b/include/linux/bio.h
index b39e500..0fd9c96 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -342,6 +342,7 @@ static inline struct bio *bio_next_split(struct bio *bio, int sectors,
 }
 
 extern struct bio_set *bioset_create(unsigned int, unsigned int);
+extern struct bio_set *bioset_create_nobvec(unsigned int, unsigned int);
 extern void bioset_free(struct bio_set *);
 extern mempool_t *biovec_create_pool(int pool_entries);
 
-- 
1.9.3
