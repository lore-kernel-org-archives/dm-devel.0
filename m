From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] bio-integrity: revert "stop abusing bi_end_io"
Date: Thu, 3 Aug 2017 10:10:55 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1708030938110.21391@file01.intranet.prod.int.rdu2.redhat.com>
References: <20170802122750.12216-1-gmazyland@gmail.com> <20170802125509.GA18977@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170802125509.GA18977@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Milan Broz <gmazyland@gmail.com>, linux-block@vger.kernel.org, axboe@kernel.dk, dm-devel@redhat.com, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids



On Wed, 2 Aug 2017, Christoph Hellwig wrote:

> On Wed, Aug 02, 2017 at 02:27:50PM +0200, Milan Broz wrote:
> > In dm-integrity target we register integrity profile that have
> > both generate_fn and verify_fn callbacks set to NULL.
> > 
> > This is used if dm-integrity is stacked under a dm-crypt device
> > for authenticated encryption (integrity payload contains authentication
> > tag and IV seed).
> > 
> > In this case the verification is done through own crypto API
> > processing inside dm-crypt; integrity profile is only holder
> > of these data. (And memory is owned by dm-crypt as well.)
> 
> Maybe that's where the problem lies?  You're abusing the integrity
> payload for something that is not end to end data integrity at all
> and then wonder why it breaks?  Also the commit that introduced your
> code had absolutely no review by Martin or any of the core block
> folks.
> 
> The right fix is to revert the dm-crypt commit.

That dm-crypt commit that uses bio integrity payload came 3 months before 
7c20f11680a441df09de7235206f70115fbf6290 and it was already present in 
4.12.

The patch 7c20f11680a441df09de7235206f70115fbf6290 not only breaks 
dm-crypt and dm-integrity. It also breaks regular integrity payload usage 
when stacking drivers are used.

Suppose that a bio goes the through the device mapper stack. At each level 
a clone bio is allocated and forwarded to a lower level. It eventually 
reaches the request-based physical disk driver.

In the kernel 4.12, when the bio reaches the request-based driver, the 
function blk_queue_bio is called, it calls bio_integrity_prep, 
bio_integrity_prep saves the bio->bi_end_io in the structure 
bio_integrity_payload and sets bio->bi_end_io = bio_integrity_endio. When 
the bio is finished, bio_integrity_endio is called, it performs the 
verification (a call to bio_integrity_verify_fn), restores bio->bi_end_io 
and calls it.

The patch 7c20f11680a441df09de7235206f70115fbf6290 changes it so that 
bio->bi_end_io is not changed and bio_integrity_endio is called directly 
from bio_endio if the bio has integrity payload. The unintended 
consequence of this change is that when a request with integrity payload 
is finished and bio_endio is called for each cloned bio, the verification 
routine bio_integrity_verify_fn is called for every level in the stack (it 
used to be called only for the lowest level in 4.12). At different levels 
in the stack, the bio may have different bi_sector value, so the repeated 
verification can't succeed.

I think the patch 7c20f11680a441df09de7235206f70115fbf6290 should be 
reverted and it should be reworked for the next merge window, so that it 
calls bio_integrity_verify_fn only for the lowest level.

Mikulas



From: Mikulas Patocka <mpatocka@redhat.co>

The patch 7c20f11680a441df09de7235206f70115fbf6290 ("bio-integrity: stop 
abusing bi_end_io") changes the code so that it doesn't replace 
bio_end_io with bio_integrity_endio and calls bio_integrity_endio directly 
from bio_endio.

The unintended consequence of this change is that when a bio with 
integrity payload is passed through the device stack, bio_integrity_endio 
is called for each level of the stack (it used to be called only for the 
lowest level before).

This breaks dm-integrity and dm-crypt and it also causes verification 
errors when a bio with regular integrity payload is passed through the 
device mapper stack.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index f733beab6ca2..8df4eb103ba9 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -102,7 +102,7 @@ EXPORT_SYMBOL(bio_integrity_alloc);
  * Description: Used to free the integrity portion of a bio. Usually
  * called from bio_free().
  */
-static void bio_integrity_free(struct bio *bio)
+void bio_integrity_free(struct bio *bio)
 {
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 	struct bio_set *bs = bio->bi_pool;
@@ -120,8 +120,8 @@ static void bio_integrity_free(struct bio *bio)
 	}
 
 	bio->bi_integrity = NULL;
-	bio->bi_opf &= ~REQ_INTEGRITY;
 }
+EXPORT_SYMBOL(bio_integrity_free);
 
 /**
  * bio_integrity_add_page - Attach integrity metadata
@@ -326,6 +326,12 @@ bool bio_integrity_prep(struct bio *bio)
 		offset = 0;
 	}
 
+	/* Install custom I/O completion handler if read verify is enabled */
+	if (bio_data_dir(bio) == READ) {
+		bip->bip_end_io = bio->bi_end_io;
+		bio->bi_end_io = bio_integrity_endio;
+	}
+
 	/* Auto-generate integrity metadata if this is a write */
 	if (bio_data_dir(bio) == WRITE) {
 		bio_integrity_process(bio, &bio->bi_iter,
@@ -369,12 +375,13 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 		bio->bi_status = BLK_STS_IOERR;
 	}
 
-	bio_integrity_free(bio);
+	/* Restore original bio completion handler */
+	bio->bi_end_io = bip->bip_end_io;
 	bio_endio(bio);
 }
 
 /**
- * __bio_integrity_endio - Integrity I/O completion function
+ * bio_integrity_endio - Integrity I/O completion function
  * @bio:	Protected bio
  * @error:	Pointer to errno
  *
@@ -385,19 +392,27 @@ static void bio_integrity_verify_fn(struct work_struct *work)
  * in process context.	This function postpones completion
  * accordingly.
  */
-bool __bio_integrity_endio(struct bio *bio)
+void bio_integrity_endio(struct bio *bio)
 {
-	if (bio_op(bio) == REQ_OP_READ && !bio->bi_status) {
-		struct bio_integrity_payload *bip = bio_integrity(bio);
+	struct bio_integrity_payload *bip = bio_integrity(bio);
 
-		INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
-		queue_work(kintegrityd_wq, &bip->bip_work);
-		return false;
+	BUG_ON(bip->bip_bio != bio);
+
+	/* In case of an I/O error there is no point in verifying the
+	 * integrity metadata.  Restore original bio end_io handler
+	 * and run it.
+	 */
+	if (bio->bi_status) {
+		bio->bi_end_io = bip->bip_end_io;
+		bio_endio(bio);
+
+		return;
 	}
 
-	bio_integrity_free(bio);
-	return true;
+	INIT_WORK(&bip->bip_work, bio_integrity_verify_fn);
+	queue_work(kintegrityd_wq, &bip->bip_work);
 }
+EXPORT_SYMBOL(bio_integrity_endio);
 
 /**
  * bio_integrity_advance - Advance integrity vector
diff --git a/block/bio.c b/block/bio.c
index 9cabf5d0be20..a6b225324a61 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -243,6 +243,9 @@ struct bio_vec *bvec_alloc(gfp_t gfp_mask, int nr, unsigned long *idx,
 void bio_uninit(struct bio *bio)
 {
 	bio_disassociate_task(bio);
+
+	if (bio_integrity(bio))
+		bio_integrity_free(bio);
 }
 EXPORT_SYMBOL(bio_uninit);
 
@@ -1810,8 +1813,6 @@ void bio_endio(struct bio *bio)
 again:
 	if (!bio_remaining_done(bio))
 		return;
-	if (!bio_integrity_endio(bio))
-		return;
 
 	/*
 	 * Need to have a real endio function for chained bios, otherwise
diff --git a/block/blk.h b/block/blk.h
index 3a3d715bd725..01ebb8185f6b 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -81,21 +81,10 @@ static inline void blk_queue_enter_live(struct request_queue *q)
 
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 void blk_flush_integrity(void);
-bool __bio_integrity_endio(struct bio *);
-static inline bool bio_integrity_endio(struct bio *bio)
-{
-	if (bio_integrity(bio))
-		return __bio_integrity_endio(bio);
-	return true;
-}
 #else
 static inline void blk_flush_integrity(void)
 {
 }
-static inline bool bio_integrity_endio(struct bio *bio)
-{
-	return true;
-}
 #endif
 
 void blk_timeout_work(struct work_struct *work);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 7b1cf4ba0902..1eba19580185 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -320,6 +320,8 @@ struct bio_integrity_payload {
 
 	struct bvec_iter	bip_iter;
 
+	bio_end_io_t		*bip_end_io;	/* saved I/O completion fn */
+
 	unsigned short		bip_slab;	/* slab the bip came from */
 	unsigned short		bip_vcnt;	/* # of integrity bio_vecs */
 	unsigned short		bip_max_vcnt;	/* integrity bio_vec slots */
@@ -737,8 +739,10 @@ struct biovec_slab {
 		bip_for_each_vec(_bvl, _bio->bi_integrity, _iter)
 
 extern struct bio_integrity_payload *bio_integrity_alloc(struct bio *, gfp_t, unsigned int);
+extern void bio_integrity_free(struct bio *);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern bool bio_integrity_prep(struct bio *);
+extern void bio_integrity_endio(struct bio *);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *);
 extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
@@ -768,6 +772,11 @@ static inline bool bio_integrity_prep(struct bio *bio)
 	return true;
 }
 
+static inline void bio_integrity_free(struct bio *bio)
+{
+	return;
+}
+
 static inline int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 				      gfp_t gfp_mask)
 {
