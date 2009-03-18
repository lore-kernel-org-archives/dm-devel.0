From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 6/8] block: add gfp_mask parameter to
	bio_integrity_clone()
Date: Wed, 18 Mar 2009 17:56:39 +0900
Message-ID: <49C0B747.3060802@ct.jp.nec.com>
References: <49C0B474.4000204@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <49C0B474.4000204@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, martin.petersen@oracle.com, jens.axboe@oracle.com
List-Id: dm-devel.ids

This patch adds gfp_mask parameter to bio_integrity_clone().

Stricter gfp_mask might be required for clone allocation.
For example, request-based dm may clone bio in interrupt disabled
context, so it has to use GFP_ATOMIC.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 fs/bio-integrity.c  |    5 +++--
 fs/bio.c            |    2 +-
 include/linux/bio.h |    5 +++--
 3 files changed, 7 insertions(+), 5 deletions(-)

Index: 2.6.29-rc8/fs/bio-integrity.c
===================================================================
--- 2.6.29-rc8.orig/fs/bio-integrity.c
+++ 2.6.29-rc8/fs/bio-integrity.c
@@ -685,19 +685,20 @@ EXPORT_SYMBOL(bio_integrity_split);
  * bio_integrity_clone - Callback for cloning bios with integrity metadata
  * @bio:	New bio
  * @bio_src:	Original bio
+ * @gfp_mask:	Memory allocation mask
  * @bs:		bio_set to allocate bip from
  *
  * Description:	Called to allocate a bip when cloning a bio
  */
 int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
-			struct bio_set *bs)
+			gfp_t gfp_mask, struct bio_set *bs)
 {
 	struct bio_integrity_payload *bip_src = bio_src->bi_integrity;
 	struct bio_integrity_payload *bip;
 
 	BUG_ON(bip_src == NULL);
 
-	bip = bio_integrity_alloc_bioset(bio, GFP_NOIO, bip_src->bip_vcnt, bs);
+	bip = bio_integrity_alloc_bioset(bio, gfp_mask, bip_src->bip_vcnt, bs);
 
 	if (bip == NULL)
 		return -EIO;
Index: 2.6.29-rc8/fs/bio.c
===================================================================
--- 2.6.29-rc8.orig/fs/bio.c
+++ 2.6.29-rc8/fs/bio.c
@@ -463,7 +463,7 @@ struct bio *bio_clone(struct bio *bio, g
 	if (bio_integrity(bio)) {
 		int ret;
 
-		ret = bio_integrity_clone(b, bio, fs_bio_set);
+		ret = bio_integrity_clone(b, bio, gfp_mask, fs_bio_set);
 
 		if (ret < 0)
 			return NULL;
Index: 2.6.29-rc8/include/linux/bio.h
===================================================================
--- 2.6.29-rc8.orig/include/linux/bio.h
+++ 2.6.29-rc8/include/linux/bio.h
@@ -531,7 +531,8 @@ extern void bio_integrity_endio(struct b
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
 extern void bio_integrity_split(struct bio *, struct bio_pair *, int);
-extern int bio_integrity_clone(struct bio *, struct bio *, struct bio_set *);
+extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t,
+			       struct bio_set *);
 extern int bioset_integrity_create(struct bio_set *, int);
 extern void bioset_integrity_free(struct bio_set *);
 extern void bio_integrity_init_slab(void);
@@ -542,7 +543,7 @@ extern void bio_integrity_init_slab(void
 #define bioset_integrity_create(a, b)	(0)
 #define bio_integrity_prep(a)		(0)
 #define bio_integrity_enabled(a)	(0)
-#define bio_integrity_clone(a, b, c)	(0)
+#define bio_integrity_clone(a, b, c, d)	(0)
 #define bioset_integrity_free(a)	do { } while (0)
 #define bio_integrity_free(a, b)	do { } while (0)
 #define bio_integrity_endio(a, b)	do { } while (0)
