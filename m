From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: commit 6d2a78e783416ba99e36beb1d4395b785b34e867 avoids
 dm integrity support
Date: Mon, 30 Mar 2009 15:23:45 +0900
Message-ID: <49D06571.70903@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi Martin, Jens, Alasdair,

I found this commit (6d2a78e783416ba99e36beb1d4395b785b34e867) in the recent
Linus's git makes every block device share single mempool for integrity cloning.
I think that it avoids integrity support for dm, because having only one mempool
in the kernel may cause a deadlock due to no memory while a bio goes down to
a device stack.

So dm needs to prepare own mempool for each device and pass it to
bio_integrity_clone() instead of the shared one.


commit 6d2a78e783416ba99e36beb1d4395b785b34e867
Author: Martin K. Petersen <martin.petersen@oracle.com>
Date:   Tue Mar 10 08:27:39 2009 +0100

    block: add private bio_set for bio integrity allocations
    
    The integrity bio allocation needs its own bio_set to avoid violating
    the mempool allocation rules and risking deadlocks.
    
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index fe2b1aa..31c46a2 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -26,23 +26,23 @@
 #include <linux/workqueue.h>
 
 static struct kmem_cache *bio_integrity_slab __read_mostly;
+static mempool_t *bio_integrity_pool;
+static struct bio_set *integrity_bio_set;
 static struct workqueue_struct *kintegrityd_wq;
 
 /**
- * bio_integrity_alloc_bioset - Allocate integrity payload and attach it to bio
+ * bio_integrity_alloc - Allocate integrity payload and attach it to bio
  * @bio:	bio to attach integrity metadata to
  * @gfp_mask:	Memory allocation mask
  * @nr_vecs:	Number of integrity metadata scatter-gather elements
- * @bs:		bio_set to allocate from
  *
  * Description: This function prepares a bio for attaching integrity
  * metadata.  nr_vecs specifies the maximum number of pages containing
  * integrity metadata that can be attached.
  */
-struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
-							 gfp_t gfp_mask,
-							 unsigned int nr_vecs,
-							 struct bio_set *bs)
+struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
+						  gfp_t gfp_mask,
+						  unsigned int nr_vecs)
 {
 	struct bio_integrity_payload *bip;
 	struct bio_vec *iv;
@@ -50,7 +50,7 @@ struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
 
 	BUG_ON(bio == NULL);
 
-	bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
+	bip = mempool_alloc(bio_integrity_pool, gfp_mask);
 	if (unlikely(bip == NULL)) {
 		printk(KERN_ERR "%s: could not alloc bip\n", __func__);
 		return NULL;
@@ -58,10 +58,10 @@ struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
 
 	memset(bip, 0, sizeof(*bip));
 
-	iv = bvec_alloc_bs(gfp_mask, nr_vecs, &idx, bs);
+	iv = bvec_alloc_bs(gfp_mask, nr_vecs, &idx, integrity_bio_set);
 	if (unlikely(iv == NULL)) {
 		printk(KERN_ERR "%s: could not alloc bip_vec\n", __func__);
-		mempool_free(bip, bs->bio_integrity_pool);
+		mempool_free(bip, bio_integrity_pool);
 		return NULL;
 	}
 
@@ -72,35 +72,16 @@ struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *bio,
 
 	return bip;
 }
-EXPORT_SYMBOL(bio_integrity_alloc_bioset);
-
-/**
- * bio_integrity_alloc - Allocate integrity payload and attach it to bio
- * @bio:	bio to attach integrity metadata to
- * @gfp_mask:	Memory allocation mask
- * @nr_vecs:	Number of integrity metadata scatter-gather elements
- *
- * Description: This function prepares a bio for attaching integrity
- * metadata.  nr_vecs specifies the maximum number of pages containing
- * integrity metadata that can be attached.
- */
-struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
-						  gfp_t gfp_mask,
-						  unsigned int nr_vecs)
-{
-	return bio_integrity_alloc_bioset(bio, gfp_mask, nr_vecs, fs_bio_set);
-}
 EXPORT_SYMBOL(bio_integrity_alloc);
 
 /**
  * bio_integrity_free - Free bio integrity payload
  * @bio:	bio containing bip to be freed
- * @bs:		bio_set this bio was allocated from
  *
  * Description: Used to free the integrity portion of a bio. Usually
  * called from bio_free().
  */
-void bio_integrity_free(struct bio *bio, struct bio_set *bs)
+void bio_integrity_free(struct bio *bio)
 {
 	struct bio_integrity_payload *bip = bio->bi_integrity;
 
@@ -111,8 +92,8 @@ void bio_integrity_free(struct bio *bio, struct bio_set *bs)
 	    && bip->bip_buf != NULL)
 		kfree(bip->bip_buf);
 
-	bvec_free_bs(bs, bip->bip_vec, bip->bip_pool);
-	mempool_free(bip, bs->bio_integrity_pool);
+	bvec_free_bs(integrity_bio_set, bip->bip_vec, bip->bip_pool);
+	mempool_free(bip, bio_integrity_pool);
 
 	bio->bi_integrity = NULL;
 }
@@ -686,19 +667,17 @@ EXPORT_SYMBOL(bio_integrity_split);
  * @bio:	New bio
  * @bio_src:	Original bio
  * @gfp_mask:	Memory allocation mask
- * @bs:		bio_set to allocate bip from
  *
  * Description:	Called to allocate a bip when cloning a bio
  */
-int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
-			gfp_t gfp_mask, struct bio_set *bs)
+int bio_integrity_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp_mask)
 {
 	struct bio_integrity_payload *bip_src = bio_src->bi_integrity;
 	struct bio_integrity_payload *bip;
 
 	BUG_ON(bip_src == NULL);
 
-	bip = bio_integrity_alloc_bioset(bio, gfp_mask, bip_src->bip_vcnt, bs);
+	bip = bio_integrity_alloc(bio, gfp_mask, bip_src->bip_vcnt);
 
 	if (bip == NULL)
 		return -EIO;
@@ -714,37 +693,25 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 }
 EXPORT_SYMBOL(bio_integrity_clone);
 
-int bioset_integrity_create(struct bio_set *bs, int pool_size)
+static int __init bio_integrity_init(void)
 {
-	bs->bio_integrity_pool = mempool_create_slab_pool(pool_size,
-							  bio_integrity_slab);
-	if (!bs->bio_integrity_pool)
-		return -1;
-
-	return 0;
-}
-EXPORT_SYMBOL(bioset_integrity_create);
+	kintegrityd_wq = create_workqueue("kintegrityd");
 
-void bioset_integrity_free(struct bio_set *bs)
-{
-	if (bs->bio_integrity_pool)
-		mempool_destroy(bs->bio_integrity_pool);
-}
-EXPORT_SYMBOL(bioset_integrity_free);
+	if (!kintegrityd_wq)
+		panic("Failed to create kintegrityd\n");
 
-void __init bio_integrity_init_slab(void)
-{
 	bio_integrity_slab = KMEM_CACHE(bio_integrity_payload,
 					SLAB_HWCACHE_ALIGN|SLAB_PANIC);
-}
 
-static int __init integrity_init(void)
-{
-	kintegrityd_wq = create_workqueue("kintegrityd");
+	bio_integrity_pool = mempool_create_slab_pool(BIO_POOL_SIZE,
+						      bio_integrity_slab);
+	if (!bio_integrity_pool)
+		panic("bio_integrity: can't allocate bip pool\n");
 
-	if (!kintegrityd_wq)
-		panic("Failed to create kintegrityd\n");
+	integrity_bio_set = bioset_create(BIO_POOL_SIZE, 0);
+	if (!integrity_bio_set)
+		panic("bio_integrity: can't allocate bio_set\n");
 
 	return 0;
 }
-subsys_initcall(integrity_init);
+subsys_initcall(bio_integrity_init);
diff --git a/fs/bio.c b/fs/bio.c
index 9cc1430..a040cde 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -248,7 +248,7 @@ void bio_free(struct bio *bio, struct bio_set *bs)
 		bvec_free_bs(bs, bio->bi_io_vec, BIO_POOL_IDX(bio));
 
 	if (bio_integrity(bio))
-		bio_integrity_free(bio, bs);
+		bio_integrity_free(bio);
 
 	/*
 	 * If we have front padding, adjust the bio pointer before freeing
@@ -466,7 +466,7 @@ struct bio *bio_clone(struct bio *bio, gfp_t gfp_mask)
 	if (bio_integrity(bio)) {
 		int ret;
 
-		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
+		ret = bio_integrity_clone(b, bio, gfp_mask);
 
 		if (ret < 0) {
 			bio_put(b);
@@ -1529,7 +1529,6 @@ void bioset_free(struct bio_set *bs)
 	if (bs->bio_pool)
 		mempool_destroy(bs->bio_pool);
 
-	bioset_integrity_free(bs);
 	biovec_free_pools(bs);
 	bio_put_slab(bs);
 
@@ -1570,9 +1569,6 @@ struct bio_set *bioset_create(unsigned int pool_size, unsigned int front_pad)
 	if (!bs->bio_pool)
 		goto bad;
 
-	if (bioset_integrity_create(bs, pool_size))
-		goto bad;
-
 	if (!biovec_create_pools(bs, pool_size))
 		return bs;
 
@@ -1610,7 +1606,6 @@ static int __init init_bio(void)
 	if (!bio_slabs)
 		panic("bio: can't allocate bios\n");
 
-	bio_integrity_init_slab();
 	biovec_init_slabs();
 
 	fs_bio_set = bioset_create(BIO_POOL_SIZE, 0);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index d8bd43b..b05b1d4 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -426,9 +426,6 @@ struct bio_set {
 	unsigned int front_pad;
 
 	mempool_t *bio_pool;
-#if defined(CONFIG_BLK_DEV_INTEGRITY)
-	mempool_t *bio_integrity_pool;
-#endif
 	mempool_t *bvec_pool;
 };
 
@@ -519,9 +516,8 @@ static inline int bio_has_data(struct bio *bio)
 
 #define bio_integrity(bio) (bio->bi_integrity != NULL)
 
-extern struct bio_integrity_payload *bio_integrity_alloc_bioset(struct bio *, gfp_t, unsigned int, struct bio_set *);
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
-extern void bio_integrity_free(struct bio *, struct bio_set *);
+extern void bio_integrity_free(struct bio *);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern int bio_integrity_enabled(struct bio *bio);
 extern int bio_integrity_set_tag(struct bio *, void *, unsigned int);
@@ -531,27 +527,21 @@ extern void bio_integrity_endio(struct bio *, int);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
 extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
-extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t, struct bio_set *);
-extern int bioset_integrity_create(struct bio_set *, int);
-extern void bioset_integrity_free(struct bio_set *);
-extern void bio_integrity_init_slab(void);
+extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
 
 #else /* CONFIG_BLK_DEV_INTEGRITY */
 
 #define bio_integrity(a)		(0)
-#define bioset_integrity_create(a, b)	(0)
 #define bio_integrity_prep(a)		(0)
 #define bio_integrity_enabled(a)	(0)
-#define bio_integrity_clone(a, b, c,d )	(0)
-#define bioset_integrity_free(a)	do { } while (0)
-#define bio_integrity_free(a, b)	do { } while (0)
+#define bio_integrity_clone(a, b, c)	(0)
+#define bio_integrity_free(a)		do { } while (0)
 #define bio_integrity_endio(a, b)	do { } while (0)
 #define bio_integrity_advance(a, b)	do { } while (0)
 #define bio_integrity_trim(a, b, c)	do { } while (0)
 #define bio_integrity_split(a, b, c)	do { } while (0)
 #define bio_integrity_set_tag(a, b, c)	do { } while (0)
 #define bio_integrity_get_tag(a, b, c)	do { } while (0)
-#define bio_integrity_init_slab(a)	do { } while (0)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
Thanks,
Kiyoshi Ueda
