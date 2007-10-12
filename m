From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 19/25] dm crypt: tidy whitespace
Date: Fri, 12 Oct 2007 18:21:15 +0100
Message-ID: <20071012172115.GE24157@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Milan Broz <mbroz@redhat.com>

Clean up, convert some spaces to tabs. 

No functional change here.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

Index: linux-2.6.23/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-crypt.c	2007-10-12 15:03:21.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-crypt.c	2007-10-12 15:03:23.000000000 +0100
@@ -56,7 +56,7 @@ struct crypt_config;
 
 struct crypt_iv_operations {
 	int (*ctr)(struct crypt_config *cc, struct dm_target *ti,
-	           const char *opts);
+		   const char *opts);
 	void (*dtr)(struct crypt_config *cc);
 	const char *(*status)(struct crypt_config *cc);
 	int (*generator)(struct crypt_config *cc, u8 *iv, sector_t sector);
@@ -138,7 +138,7 @@ static int crypt_iv_plain_gen(struct cry
 }
 
 static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
-	                      const char *opts)
+			      const char *opts)
 {
 	struct crypto_cipher *essiv_tfm;
 	struct crypto_hash *hash_tfm;
@@ -190,7 +190,7 @@ static int crypt_iv_essiv_ctr(struct cry
 	if (crypto_cipher_blocksize(essiv_tfm) !=
 	    crypto_blkcipher_ivsize(cc->tfm)) {
 		ti->error = "Block size of ESSIV cipher does "
-			        "not match IV size of block cipher";
+			    "not match IV size of block cipher";
 		crypto_free_cipher(essiv_tfm);
 		kfree(salt);
 		return -EINVAL;
@@ -321,10 +321,10 @@ crypt_convert_scatterlist(struct crypt_c
 	return r;
 }
 
-static void
-crypt_convert_init(struct crypt_config *cc, struct convert_context *ctx,
-                   struct bio *bio_out, struct bio *bio_in,
-                   sector_t sector, int write)
+static void crypt_convert_init(struct crypt_config *cc,
+			       struct convert_context *ctx,
+			       struct bio *bio_out, struct bio *bio_in,
+			       sector_t sector, int write)
 {
 	ctx->bio_in = bio_in;
 	ctx->bio_out = bio_out;
@@ -340,7 +340,7 @@ crypt_convert_init(struct crypt_config *
  * Encrypt / decrypt data from one bio to another one (can be the same one)
  */
 static int crypt_convert(struct crypt_config *cc,
-                         struct convert_context *ctx)
+			 struct convert_context *ctx)
 {
 	int r = 0;
 
@@ -372,7 +372,7 @@ static int crypt_convert(struct crypt_co
 		}
 
 		r = crypt_convert_scatterlist(cc, &sg_out, &sg_in, sg_in.length,
-		                              ctx->write, ctx->sector);
+					      ctx->write, ctx->sector);
 		if (r < 0)
 			break;
 
@@ -382,13 +382,13 @@ static int crypt_convert(struct crypt_co
 	return r;
 }
 
- static void dm_crypt_bio_destructor(struct bio *bio)
- {
+static void dm_crypt_bio_destructor(struct bio *bio)
+{
 	struct dm_crypt_io *io = bio->bi_private;
 	struct crypt_config *cc = io->target->private;
 
 	bio_free(bio, cc->bs);
- }
+}
 
 /*
  * Generate a new unfragmented bio with the given size
@@ -444,7 +444,7 @@ static struct bio *crypt_alloc_buffer(st
 }
 
 static void crypt_free_buffer_pages(struct crypt_config *cc,
-                                    struct bio *clone, unsigned int bytes)
+				    struct bio *clone, unsigned int bytes)
 {
 	unsigned int i, start, end;
 	struct bio_vec *bv;
@@ -736,7 +736,7 @@ static int crypt_set_key(struct crypt_co
 	cc->key_size = key_size; /* initial settings */
 
 	if ((!key_size && strcmp(key, "-")) ||
-	    (key_size && crypt_decode_key(cc->key, key, key_size) < 0))
+	   (key_size && crypt_decode_key(cc->key, key, key_size) < 0))
 		return -EINVAL;
 
 	set_bit(DM_CRYPT_KEY_VALID, &cc->flags);
@@ -806,8 +806,8 @@ static int crypt_ctr(struct dm_target *t
 		goto bad1;
 	}
 
-	if (snprintf(cc->cipher, CRYPTO_MAX_ALG_NAME, "%s(%s)", chainmode, 
-		     cipher) >= CRYPTO_MAX_ALG_NAME) {
+	if (snprintf(cc->cipher, CRYPTO_MAX_ALG_NAME, "%s(%s)",
+		     chainmode, cipher) >= CRYPTO_MAX_ALG_NAME) {
 		ti->error = "Chain mode + cipher name is too long";
 		goto bad1;
 	}
@@ -850,7 +850,7 @@ static int crypt_ctr(struct dm_target *t
 	if (cc->iv_size)
 		/* at least a 64 bit sector number should fit in our buffer */
 		cc->iv_size = max(cc->iv_size,
-		                  (unsigned int)(sizeof(u64) / sizeof(u8)));
+				  (unsigned int)(sizeof(u64) / sizeof(u8)));
 	else {
 		if (cc->iv_gen_ops) {
 			DMWARN("Selected cipher does not support IVs");
@@ -896,7 +896,7 @@ static int crypt_ctr(struct dm_target *t
 	cc->start = tmpll;
 
 	if (dm_get_device(ti, argv[3], cc->start, ti->len,
-	                  dm_table_get_mode(ti->table), &cc->dev)) {
+			  dm_table_get_mode(ti->table), &cc->dev)) {
 		ti->error = "Device lookup failed";
 		goto bad5;
 	}
