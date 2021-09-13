Return-Path: <SRS0=4gQq=OD=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33229C433F5
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 01:42:13 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id B575E610A6
	for <dm-devel@archiver.kernel.org>; Mon, 13 Sep 2021 01:42:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B575E610A6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-19-g7PYXYy2PlCYVjAtXeeRIw-1; Sun, 12 Sep 2021 21:42:09 -0400
X-MC-Unique: g7PYXYy2PlCYVjAtXeeRIw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6F56B835DE0;
	Mon, 13 Sep 2021 01:42:05 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 54C9060583;
	Mon, 13 Sep 2021 01:42:05 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 0137A1805986;
	Mon, 13 Sep 2021 01:42:05 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
	[10.11.54.3])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 18D1fe5V003386 for <dm-devel@listman.util.phx.redhat.com>;
	Sun, 12 Sep 2021 21:41:40 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 1D4191111425; Mon, 13 Sep 2021 01:41:40 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 18DD51111420
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 01:41:36 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
	bits)) (No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DB577185A7A4
	for <dm-devel@redhat.com>; Mon, 13 Sep 2021 01:41:35 +0000 (UTC)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99]) (Using TLS)
	by relay.mimecast.com with ESMTP id us-mta-549-1nd0KhL3O82tySRxJMc77Q-1;
	Sun, 12 Sep 2021 21:41:34 -0400
X-MC-Unique: 1nd0KhL3O82tySRxJMc77Q-1
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DF5C61057;
	Mon, 13 Sep 2021 01:35:27 +0000 (UTC)
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org
Date: Sun, 12 Sep 2021 18:31:32 -0700
Message-Id: <20210913013135.102404-3-ebiggers@kernel.org>
In-Reply-To: <20210913013135.102404-1-ebiggers@kernel.org>
References: <20210913013135.102404-1-ebiggers@kernel.org>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-loop: dm-devel@redhat.com
Cc: Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
	linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [dm-devel] [PATCH 2/5] blk-crypto-fallback: consolidate static
	variables
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://listman.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Eric Biggers <ebiggers@google.com>

blk-crypto-fallback.c has many static variables with inconsistent names,
e.g. "blk_crypto_*", "crypto_*", and some unprefixed names.  This is
confusing.  Consolidate them all into a struct named
"blk_crypto_fallback" so that it's clear what they are.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/blk-crypto-fallback.c | 251 +++++++++++++++++++-----------------
 1 file changed, 136 insertions(+), 115 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 82b302597b474..a4a444c83fb3c 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -21,20 +21,10 @@
 
 #include "blk-crypto-internal.h"
 
-static unsigned int num_prealloc_bounce_pg = 32;
-module_param(num_prealloc_bounce_pg, uint, 0);
-MODULE_PARM_DESC(num_prealloc_bounce_pg,
-		 "Number of preallocated bounce pages for the blk-crypto crypto API fallback");
-
-static unsigned int blk_crypto_num_keyslots = 100;
-module_param_named(num_keyslots, blk_crypto_num_keyslots, uint, 0);
-MODULE_PARM_DESC(num_keyslots,
-		 "Number of keyslots for the blk-crypto crypto API fallback");
-
-static unsigned int num_prealloc_fallback_crypt_ctxs = 128;
-module_param(num_prealloc_fallback_crypt_ctxs, uint, 0);
-MODULE_PARM_DESC(num_prealloc_crypt_fallback_ctxs,
-		 "Number of preallocated bio fallback crypto contexts for blk-crypto to use during crypto API fallback");
+struct blk_crypto_fallback_keyslot {
+	enum blk_crypto_mode_num crypto_mode;
+	struct crypto_skcipher *tfms[BLK_ENCRYPTION_MODE_MAX];
+};
 
 struct bio_fallback_crypt_ctx {
 	struct bio_crypt_ctx crypt_ctx;
@@ -57,47 +47,80 @@ struct bio_fallback_crypt_ctx {
 	};
 };
 
-static struct kmem_cache *bio_fallback_crypt_ctx_cache;
-static mempool_t *bio_fallback_crypt_ctx_pool;
+/* All state for blk-crypto-fallback */
+static struct blk_crypto_fallback {
+	unsigned int num_prealloc_bounce_pg;
+	unsigned int num_keyslots;
+	unsigned int num_prealloc_crypt_ctxs;
 
-/*
- * Allocating a crypto tfm during I/O can deadlock, so we have to preallocate
- * all of a mode's tfms when that mode starts being used. Since each mode may
- * need all the keyslots at some point, each mode needs its own tfm for each
- * keyslot; thus, a keyslot may contain tfms for multiple modes.  However, to
- * match the behavior of real inline encryption hardware (which only supports a
- * single encryption context per keyslot), we only allow one tfm per keyslot to
- * be used at a time - the rest of the unused tfms have their keys cleared.
- */
-static DEFINE_MUTEX(tfms_init_lock);
-static bool tfms_inited[BLK_ENCRYPTION_MODE_MAX];
+	bool initialized;
 
-static struct blk_crypto_fallback_keyslot {
-	enum blk_crypto_mode_num crypto_mode;
-	struct crypto_skcipher *tfms[BLK_ENCRYPTION_MODE_MAX];
-} *blk_crypto_keyslots;
+	/*
+	 * This is the key we set when evicting a keyslot. This *should* be the
+	 * all 0's key, but AES-XTS rejects that key, so we use some random
+	 * bytes instead.
+	 */
+	u8 blank_key[BLK_CRYPTO_MAX_KEY_SIZE];
 
-static struct blk_keyslot_manager blk_crypto_ksm;
-static struct workqueue_struct *blk_crypto_wq;
-static mempool_t *blk_crypto_bounce_page_pool;
-static struct bio_set crypto_bio_split;
+	struct bio_set bio_split;
 
-/*
- * This is the key we set when evicting a keyslot. This *should* be the all 0's
- * key, but AES-XTS rejects that key, so we use some random bytes instead.
- */
-static u8 blank_key[BLK_CRYPTO_MAX_KEY_SIZE];
+	struct blk_keyslot_manager ksm;
+
+	struct workqueue_struct *decrypt_wq;
+
+	struct blk_crypto_fallback_keyslot *keyslots;
+
+	mempool_t *bounce_page_pool;
+	struct kmem_cache *crypt_ctx_cache;
+	mempool_t *crypt_ctx_pool;
+
+	/*
+	 * Allocating a crypto tfm during I/O can deadlock, so we have to
+	 * preallocate all of a mode's tfms when that mode starts being used.
+	 * Since each mode may need all the keyslots at some point, each mode
+	 * needs its own tfm for each keyslot; thus, a keyslot may contain tfms
+	 * for multiple modes.  However, to match the behavior of real inline
+	 * encryption hardware (which only supports a single encryption context
+	 * per keyslot), we only allow one tfm per keyslot to be used at a time
+	 * - the rest of the unused tfms have their keys cleared.
+	 */
+	struct mutex tfms_init_lock;
+	bool tfms_inited[BLK_ENCRYPTION_MODE_MAX];
+
+} blk_crypto_fallback = {
+	.num_prealloc_bounce_pg = 32,
+	.num_keyslots = 100,
+	.num_prealloc_crypt_ctxs = 128,
+	.tfms_init_lock =
+		__MUTEX_INITIALIZER(blk_crypto_fallback.tfms_init_lock),
+};
+
+module_param_named(num_prealloc_bounce_pg,
+		   blk_crypto_fallback.num_prealloc_bounce_pg, uint, 0);
+MODULE_PARM_DESC(num_prealloc_bounce_pg,
+		 "Number of preallocated bounce pages for the blk-crypto crypto API fallback");
+
+module_param_named(num_keyslots, blk_crypto_fallback.num_keyslots, uint, 0);
+MODULE_PARM_DESC(num_keyslots,
+		 "Number of keyslots for the blk-crypto crypto API fallback");
+
+module_param_named(num_prealloc_fallback_crypt_ctxs,
+		   blk_crypto_fallback.num_prealloc_crypt_ctxs, uint, 0);
+MODULE_PARM_DESC(num_prealloc_crypt_fallback_ctxs,
+		 "Number of preallocated bio fallback crypto contexts for blk-crypto to use during crypto API fallback");
 
 static void blk_crypto_fallback_evict_keyslot(unsigned int slot)
 {
-	struct blk_crypto_fallback_keyslot *slotp = &blk_crypto_keyslots[slot];
+	struct blk_crypto_fallback *fallback = &blk_crypto_fallback;
+	struct blk_crypto_fallback_keyslot *slotp = &fallback->keyslots[slot];
 	enum blk_crypto_mode_num crypto_mode = slotp->crypto_mode;
 	int err;
 
 	WARN_ON(slotp->crypto_mode == BLK_ENCRYPTION_MODE_INVALID);
 
 	/* Clear the key in the skcipher */
-	err = crypto_skcipher_setkey(slotp->tfms[crypto_mode], blank_key,
+	err = crypto_skcipher_setkey(slotp->tfms[crypto_mode],
+				     fallback->blank_key,
 				     blk_crypto_modes[crypto_mode].keysize);
 	WARN_ON(err);
 	slotp->crypto_mode = BLK_ENCRYPTION_MODE_INVALID;
@@ -107,7 +130,8 @@ static int blk_crypto_fallback_keyslot_program(struct blk_keyslot_manager *ksm,
 					       const struct blk_crypto_key *key,
 					       unsigned int slot)
 {
-	struct blk_crypto_fallback_keyslot *slotp = &blk_crypto_keyslots[slot];
+	struct blk_crypto_fallback *fallback = &blk_crypto_fallback;
+	struct blk_crypto_fallback_keyslot *slotp = &fallback->keyslots[slot];
 	const enum blk_crypto_mode_num crypto_mode =
 						key->crypto_cfg.crypto_mode;
 	int err;
@@ -134,16 +158,6 @@ static int blk_crypto_fallback_keyslot_evict(struct blk_keyslot_manager *ksm,
 	return 0;
 }
 
-/*
- * The crypto API fallback KSM ops - only used for a bio when it specifies a
- * blk_crypto_key that was not supported by the device's inline encryption
- * hardware.
- */
-static const struct blk_ksm_ll_ops blk_crypto_ksm_ll_ops = {
-	.keyslot_program	= blk_crypto_fallback_keyslot_program,
-	.keyslot_evict		= blk_crypto_fallback_keyslot_evict,
-};
-
 static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
 {
 	struct bio *src_bio = enc_bio->bi_private;
@@ -151,7 +165,7 @@ static void blk_crypto_fallback_encrypt_endio(struct bio *enc_bio)
 
 	for (i = 0; i < enc_bio->bi_vcnt; i++)
 		mempool_free(enc_bio->bi_io_vec[i].bv_page,
-			     blk_crypto_bounce_page_pool);
+			     blk_crypto_fallback.bounce_page_pool);
 
 	src_bio->bi_status = enc_bio->bi_status;
 
@@ -195,7 +209,7 @@ blk_crypto_fallback_alloc_cipher_req(struct blk_ksm_keyslot *slot,
 	const struct blk_crypto_fallback_keyslot *slotp;
 	int keyslot_idx = blk_ksm_get_slot_idx(slot);
 
-	slotp = &blk_crypto_keyslots[keyslot_idx];
+	slotp = &blk_crypto_fallback.keyslots[keyslot_idx];
 	ciph_req = skcipher_request_alloc(slotp->tfms[slotp->crypto_mode],
 					  GFP_NOIO);
 	if (!ciph_req)
@@ -227,7 +241,7 @@ static bool blk_crypto_fallback_split_bio_if_needed(struct bio **bio_ptr)
 		struct bio *split_bio;
 
 		split_bio = bio_split(bio, num_sectors, GFP_NOIO,
-				      &crypto_bio_split);
+				      &blk_crypto_fallback.bio_split);
 		if (!split_bio) {
 			bio->bi_status = BLK_STS_RESOURCE;
 			return false;
@@ -263,6 +277,7 @@ static void blk_crypto_dun_to_iv(const u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE],
  */
 static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 {
+	struct blk_crypto_fallback *fallback = &blk_crypto_fallback;
 	struct bio *src_bio, *enc_bio;
 	struct bio_crypt_ctx *bc;
 	struct blk_ksm_keyslot *slot;
@@ -295,7 +310,7 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 	 * Use the crypto API fallback keyslot manager to get a crypto_skcipher
 	 * for the algorithm and key specified for this bio.
 	 */
-	blk_st = blk_ksm_get_slot_for_key(&blk_crypto_ksm, bc->bc_key, &slot);
+	blk_st = blk_ksm_get_slot_for_key(&fallback->ksm, bc->bc_key, &slot);
 	if (blk_st != BLK_STS_OK) {
 		src_bio->bi_status = blk_st;
 		goto out_put_enc_bio;
@@ -319,7 +334,7 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 		struct bio_vec *enc_bvec = &enc_bio->bi_io_vec[i];
 		struct page *plaintext_page = enc_bvec->bv_page;
 		struct page *ciphertext_page =
-			mempool_alloc(blk_crypto_bounce_page_pool, GFP_NOIO);
+			mempool_alloc(fallback->bounce_page_pool, GFP_NOIO);
 
 		enc_bvec->bv_page = ciphertext_page;
 
@@ -359,7 +374,7 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
 out_free_bounce_pages:
 	while (i > 0)
 		mempool_free(enc_bio->bi_io_vec[--i].bv_page,
-			     blk_crypto_bounce_page_pool);
+			     fallback->bounce_page_pool);
 out_free_ciph_req:
 	skcipher_request_free(ciph_req);
 out_release_keyslot:
@@ -377,6 +392,7 @@ static bool blk_crypto_fallback_encrypt_bio(struct bio **bio_ptr)
  */
 static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 {
+	struct blk_crypto_fallback *fallback = &blk_crypto_fallback;
 	struct bio_fallback_crypt_ctx *f_ctx =
 		container_of(work, struct bio_fallback_crypt_ctx, work);
 	struct bio *bio = f_ctx->bio;
@@ -397,7 +413,7 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 	 * Use the crypto API fallback keyslot manager to get a crypto_skcipher
 	 * for the algorithm and key specified for this bio.
 	 */
-	blk_st = blk_ksm_get_slot_for_key(&blk_crypto_ksm, bc->bc_key, &slot);
+	blk_st = blk_ksm_get_slot_for_key(&fallback->ksm, bc->bc_key, &slot);
 	if (blk_st != BLK_STS_OK) {
 		bio->bi_status = blk_st;
 		goto out_no_keyslot;
@@ -437,7 +453,7 @@ static void blk_crypto_fallback_decrypt_bio(struct work_struct *work)
 	skcipher_request_free(ciph_req);
 	blk_ksm_put_slot(slot);
 out_no_keyslot:
-	mempool_free(f_ctx, bio_fallback_crypt_ctx_pool);
+	mempool_free(f_ctx, fallback->crypt_ctx_pool);
 	bio_endio(bio);
 }
 
@@ -458,14 +474,14 @@ static void blk_crypto_fallback_decrypt_endio(struct bio *bio)
 
 	/* If there was an IO error, don't queue for decrypt. */
 	if (bio->bi_status) {
-		mempool_free(f_ctx, bio_fallback_crypt_ctx_pool);
+		mempool_free(f_ctx, blk_crypto_fallback.crypt_ctx_pool);
 		bio_endio(bio);
 		return;
 	}
 
 	INIT_WORK(&f_ctx->work, blk_crypto_fallback_decrypt_bio);
 	f_ctx->bio = bio;
-	queue_work(blk_crypto_wq, &f_ctx->work);
+	queue_work(blk_crypto_fallback.decrypt_wq, &f_ctx->work);
 }
 
 /**
@@ -490,17 +506,19 @@ static void blk_crypto_fallback_decrypt_endio(struct bio *bio)
  */
 bool blk_crypto_fallback_bio_prep(struct bio **bio_ptr)
 {
+	struct blk_crypto_fallback *fallback = &blk_crypto_fallback;
 	struct bio *bio = *bio_ptr;
 	struct bio_crypt_ctx *bc = bio->bi_crypt_context;
 	struct bio_fallback_crypt_ctx *f_ctx;
 
-	if (WARN_ON_ONCE(!tfms_inited[bc->bc_key->crypto_cfg.crypto_mode])) {
+	if (WARN_ON_ONCE(!fallback->tfms_inited[
+				bc->bc_key->crypto_cfg.crypto_mode])) {
 		/* User didn't call blk_crypto_start_using_key() first */
 		bio->bi_status = BLK_STS_IOERR;
 		return false;
 	}
 
-	if (!blk_ksm_crypto_cfg_supported(&blk_crypto_ksm,
+	if (!blk_ksm_crypto_cfg_supported(&fallback->ksm,
 					  &bc->bc_key->crypto_cfg)) {
 		bio->bi_status = BLK_STS_NOTSUPP;
 		return false;
@@ -513,7 +531,7 @@ bool blk_crypto_fallback_bio_prep(struct bio **bio_ptr)
 	 * bio READ case: Set up a f_ctx in the bio's bi_private and set the
 	 * bi_end_io appropriately to trigger decryption when the bio is ended.
 	 */
-	f_ctx = mempool_alloc(bio_fallback_crypt_ctx_pool, GFP_NOIO);
+	f_ctx = mempool_alloc(fallback->crypt_ctx_pool, GFP_NOIO);
 	f_ctx->crypt_ctx = *bc;
 	f_ctx->crypt_iter = bio->bi_iter;
 	f_ctx->bi_private_orig = bio->bi_private;
@@ -527,79 +545,82 @@ bool blk_crypto_fallback_bio_prep(struct bio **bio_ptr)
 
 int blk_crypto_fallback_evict_key(const struct blk_crypto_key *key)
 {
-	return blk_ksm_evict_key(&blk_crypto_ksm, key);
+	return blk_ksm_evict_key(&blk_crypto_fallback.ksm, key);
 }
 
-static bool blk_crypto_fallback_inited;
 static int blk_crypto_fallback_init(void)
 {
+	struct blk_crypto_fallback *fallback = &blk_crypto_fallback;
 	int i;
 	int err;
 
-	if (blk_crypto_fallback_inited)
+	if (fallback->initialized)
 		return 0;
 
-	prandom_bytes(blank_key, BLK_CRYPTO_MAX_KEY_SIZE);
+	prandom_bytes(fallback->blank_key, BLK_CRYPTO_MAX_KEY_SIZE);
 
-	err = bioset_init(&crypto_bio_split, 64, 0, 0);
+	err = bioset_init(&fallback->bio_split, 64, 0, 0);
 	if (err)
 		goto out;
 
-	err = blk_ksm_init(&blk_crypto_ksm, blk_crypto_num_keyslots);
+	err = blk_ksm_init(&fallback->ksm, fallback->num_keyslots);
 	if (err)
 		goto fail_free_bioset;
 	err = -ENOMEM;
 
-	blk_crypto_ksm.ksm_ll_ops = blk_crypto_ksm_ll_ops;
-	blk_crypto_ksm.max_dun_bytes_supported = BLK_CRYPTO_MAX_IV_SIZE;
+	fallback->ksm.ksm_ll_ops.keyslot_program =
+		blk_crypto_fallback_keyslot_program;
+	fallback->ksm.ksm_ll_ops.keyslot_evict =
+		blk_crypto_fallback_keyslot_evict;
+	fallback->ksm.max_dun_bytes_supported = BLK_CRYPTO_MAX_IV_SIZE;
 
 	/* All blk-crypto modes have a crypto API fallback. */
 	for (i = 0; i < BLK_ENCRYPTION_MODE_MAX; i++)
-		blk_crypto_ksm.crypto_modes_supported[i] = 0xFFFFFFFF;
-	blk_crypto_ksm.crypto_modes_supported[BLK_ENCRYPTION_MODE_INVALID] = 0;
-
-	blk_crypto_wq = alloc_workqueue("blk_crypto_wq",
-					WQ_UNBOUND | WQ_HIGHPRI |
-					WQ_MEM_RECLAIM, num_online_cpus());
-	if (!blk_crypto_wq)
+		fallback->ksm.crypto_modes_supported[i] = 0xFFFFFFFF;
+	fallback->ksm.crypto_modes_supported[BLK_ENCRYPTION_MODE_INVALID] = 0;
+
+	fallback->decrypt_wq = alloc_workqueue("blk_crypto_fallback_wq",
+					       WQ_UNBOUND | WQ_HIGHPRI |
+					       WQ_MEM_RECLAIM,
+					       num_online_cpus());
+	if (!fallback->decrypt_wq)
 		goto fail_free_ksm;
 
-	blk_crypto_keyslots = kcalloc(blk_crypto_num_keyslots,
-				      sizeof(blk_crypto_keyslots[0]),
-				      GFP_KERNEL);
-	if (!blk_crypto_keyslots)
+	fallback->keyslots = kcalloc(fallback->num_keyslots,
+				     sizeof(fallback->keyslots[0]), GFP_KERNEL);
+	if (!fallback->keyslots)
 		goto fail_free_wq;
 
-	blk_crypto_bounce_page_pool =
-		mempool_create_page_pool(num_prealloc_bounce_pg, 0);
-	if (!blk_crypto_bounce_page_pool)
+	fallback->bounce_page_pool =
+		mempool_create_page_pool(fallback->num_prealloc_bounce_pg, 0);
+	if (!fallback->bounce_page_pool)
 		goto fail_free_keyslots;
 
-	bio_fallback_crypt_ctx_cache = KMEM_CACHE(bio_fallback_crypt_ctx, 0);
-	if (!bio_fallback_crypt_ctx_cache)
+	fallback->crypt_ctx_cache = KMEM_CACHE(bio_fallback_crypt_ctx, 0);
+	if (!fallback->crypt_ctx_cache)
 		goto fail_free_bounce_page_pool;
 
-	bio_fallback_crypt_ctx_pool =
-		mempool_create_slab_pool(num_prealloc_fallback_crypt_ctxs,
-					 bio_fallback_crypt_ctx_cache);
-	if (!bio_fallback_crypt_ctx_pool)
+	fallback->crypt_ctx_pool =
+		mempool_create_slab_pool(fallback->num_prealloc_crypt_ctxs,
+					 fallback->crypt_ctx_cache);
+	if (!fallback->crypt_ctx_pool)
 		goto fail_free_crypt_ctx_cache;
 
-	blk_crypto_fallback_inited = true;
+	fallback->initialized = true;
 
 	return 0;
 fail_free_crypt_ctx_cache:
-	kmem_cache_destroy(bio_fallback_crypt_ctx_cache);
+	kmem_cache_destroy(fallback->crypt_ctx_cache);
 fail_free_bounce_page_pool:
-	mempool_destroy(blk_crypto_bounce_page_pool);
+	mempool_destroy(fallback->bounce_page_pool);
 fail_free_keyslots:
-	kfree(blk_crypto_keyslots);
+	kfree(fallback->keyslots);
 fail_free_wq:
-	destroy_workqueue(blk_crypto_wq);
+	destroy_workqueue(fallback->decrypt_wq);
 fail_free_ksm:
-	blk_ksm_destroy(&blk_crypto_ksm);
+	blk_ksm_destroy(&fallback->ksm);
 fail_free_bioset:
-	bioset_exit(&crypto_bio_split);
+	bioset_exit(&fallback->bio_split);
 out:
 	return err;
 }
@@ -610,29 +631,29 @@ static int blk_crypto_fallback_init(void)
  */
 int blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num)
 {
+	struct blk_crypto_fallback *fallback = &blk_crypto_fallback;
 	const char *cipher_str = blk_crypto_modes[mode_num].cipher_str;
 	struct blk_crypto_fallback_keyslot *slotp;
 	unsigned int i;
 	int err = 0;
 
 	/*
-	 * Fast path
-	 * Ensure that updates to blk_crypto_keyslots[i].tfms[mode_num]
-	 * for each i are visible before we try to access them.
+	 * Fast path.  Ensure that updates to keyslots[i].tfms[mode_num] for
+	 * each i are visible before we try to access them.
 	 */
-	if (likely(smp_load_acquire(&tfms_inited[mode_num])))
+	if (likely(smp_load_acquire(&fallback->tfms_inited[mode_num])))
 		return 0;
 
-	mutex_lock(&tfms_init_lock);
-	if (tfms_inited[mode_num])
+	mutex_lock(&fallback->tfms_init_lock);
+	if (fallback->tfms_inited[mode_num])
 		goto out;
 
 	err = blk_crypto_fallback_init();
 	if (err)
 		goto out;
 
-	for (i = 0; i < blk_crypto_num_keyslots; i++) {
-		slotp = &blk_crypto_keyslots[i];
+	for (i = 0; i < fallback->num_keyslots; i++) {
+		slotp = &fallback->keyslots[i];
 		slotp->tfms[mode_num] = crypto_alloc_skcipher(cipher_str, 0, 0);
 		if (IS_ERR(slotp->tfms[mode_num])) {
 			err = PTR_ERR(slotp->tfms[mode_num]);
@@ -650,19 +671,19 @@ int blk_crypto_fallback_start_using_mode(enum blk_crypto_mode_num mode_num)
 	}
 
 	/*
-	 * Ensure that updates to blk_crypto_keyslots[i].tfms[mode_num]
-	 * for each i are visible before we set tfms_inited[mode_num].
+	 * Ensure that updates to keyslots[i].tfms[mode_num] for each i are
+	 * visible before we set tfms_inited[mode_num].
 	 */
-	smp_store_release(&tfms_inited[mode_num], true);
+	smp_store_release(&fallback->tfms_inited[mode_num], true);
 	goto out;
 
 out_free_tfms:
-	for (i = 0; i < blk_crypto_num_keyslots; i++) {
-		slotp = &blk_crypto_keyslots[i];
+	for (i = 0; i < fallback->num_keyslots; i++) {
+		slotp = &fallback->keyslots[i];
 		crypto_free_skcipher(slotp->tfms[mode_num]);
 		slotp->tfms[mode_num] = NULL;
 	}
 out:
-	mutex_unlock(&tfms_init_lock);
+	mutex_unlock(&fallback->tfms_init_lock);
 	return err;
 }
-- 
2.33.0

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

