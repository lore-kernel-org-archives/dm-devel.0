From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 20/25] dm crypt: tidy labels
Date: Fri, 12 Oct 2007 18:21:36 +0100
Message-ID: <20071012172136.GF24157@agk.fab.redhat.com>
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

Replace numbers with names in labels in error paths, to avoid confusion
when new one get added between existing ones.

Signed-off-by: Milan Broz <mbroz@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-crypt.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

Index: linux-2.6.23/drivers/md/dm-crypt.c
===================================================================
--- linux-2.6.23.orig/drivers/md/dm-crypt.c	2007-10-12 15:03:23.000000000 +0100
+++ linux-2.6.23/drivers/md/dm-crypt.c	2007-10-12 15:03:26.000000000 +0100
@@ -792,7 +792,7 @@ static int crypt_ctr(struct dm_target *t
 
  	if (crypt_set_key(cc, argv[1])) {
 		ti->error = "Error decoding key";
-		goto bad1;
+		goto bad_cipher;
 	}
 
 	/* Compatiblity mode for old dm-crypt cipher strings */
@@ -803,19 +803,19 @@ static int crypt_ctr(struct dm_target *t
 
 	if (strcmp(chainmode, "ecb") && !ivmode) {
 		ti->error = "This chaining mode requires an IV mechanism";
-		goto bad1;
+		goto bad_cipher;
 	}
 
 	if (snprintf(cc->cipher, CRYPTO_MAX_ALG_NAME, "%s(%s)",
 		     chainmode, cipher) >= CRYPTO_MAX_ALG_NAME) {
 		ti->error = "Chain mode + cipher name is too long";
-		goto bad1;
+		goto bad_cipher;
 	}
 
 	tfm = crypto_alloc_blkcipher(cc->cipher, 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(tfm)) {
 		ti->error = "Error allocating crypto tfm";
-		goto bad1;
+		goto bad_cipher;
 	}
 
 	strcpy(cc->cipher, cipher);
@@ -839,12 +839,12 @@ static int crypt_ctr(struct dm_target *t
 		cc->iv_gen_ops = &crypt_iv_null_ops;
 	else {
 		ti->error = "Invalid IV mode";
-		goto bad2;
+		goto bad_ivmode;
 	}
 
 	if (cc->iv_gen_ops && cc->iv_gen_ops->ctr &&
 	    cc->iv_gen_ops->ctr(cc, ti, ivopts) < 0)
-		goto bad2;
+		goto bad_ivmode;
 
 	cc->iv_size = crypto_blkcipher_ivsize(tfm);
 	if (cc->iv_size)
@@ -863,13 +863,13 @@ static int crypt_ctr(struct dm_target *t
 	cc->io_pool = mempool_create_slab_pool(MIN_IOS, _crypt_io_pool);
 	if (!cc->io_pool) {
 		ti->error = "Cannot allocate crypt io mempool";
-		goto bad3;
+		goto bad_slab_pool;
 	}
 
 	cc->page_pool = mempool_create_page_pool(MIN_POOL_PAGES, 0);
 	if (!cc->page_pool) {
 		ti->error = "Cannot allocate page mempool";
-		goto bad4;
+		goto bad_page_pool;
 	}
 
 	cc->bs = bioset_create(MIN_IOS, MIN_IOS);
@@ -880,25 +880,25 @@ static int crypt_ctr(struct dm_target *t
 
 	if (crypto_blkcipher_setkey(tfm, cc->key, key_size) < 0) {
 		ti->error = "Error setting key";
-		goto bad5;
+		goto bad_device;
 	}
 
 	if (sscanf(argv[2], "%llu", &tmpll) != 1) {
 		ti->error = "Invalid iv_offset sector";
-		goto bad5;
+		goto bad_device;
 	}
 	cc->iv_offset = tmpll;
 
 	if (sscanf(argv[4], "%llu", &tmpll) != 1) {
 		ti->error = "Invalid device sector";
-		goto bad5;
+		goto bad_device;
 	}
 	cc->start = tmpll;
 
 	if (dm_get_device(ti, argv[3], cc->start, ti->len,
 			  dm_table_get_mode(ti->table), &cc->dev)) {
 		ti->error = "Device lookup failed";
-		goto bad5;
+		goto bad_device;
 	}
 
 	if (ivmode && cc->iv_gen_ops) {
@@ -907,7 +907,7 @@ static int crypt_ctr(struct dm_target *t
 		cc->iv_mode = kmalloc(strlen(ivmode) + 1, GFP_KERNEL);
 		if (!cc->iv_mode) {
 			ti->error = "Error kmallocing iv_mode string";
-			goto bad_iv_mode;
+			goto bad_ivmode_string;
 		}
 		strcpy(cc->iv_mode, ivmode);
 	} else
@@ -932,20 +932,20 @@ bad_crypt_queue:
 	destroy_workqueue(cc->io_queue);
 bad_io_queue:
 	kfree(cc->iv_mode);
-bad_iv_mode:
+bad_ivmode_string:
 	dm_put_device(ti, cc->dev);
-bad5:
+bad_device:
 	bioset_free(cc->bs);
 bad_bs:
 	mempool_destroy(cc->page_pool);
-bad4:
+bad_page_pool:
 	mempool_destroy(cc->io_pool);
-bad3:
+bad_slab_pool:
 	if (cc->iv_gen_ops && cc->iv_gen_ops->dtr)
 		cc->iv_gen_ops->dtr(cc);
-bad2:
+bad_ivmode:
 	crypto_free_blkcipher(tfm);
-bad1:
+bad_cipher:
 	/* Must zero key material before freeing */
 	memset(cc, 0, sizeof(*cc) + cc->key_size * sizeof(u8));
 	kfree(cc);
