From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [CRYPTO] Use CRYPTO_TFM_REQ_MAY_SLEEP where appropriate
Date: Sat, 20 Aug 2005 17:19:11 +1000
Message-ID: <20050820071911.GB8367@gondor.apana.org.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ZfOjI3PrQbgiZnxM"
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
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: mike@halcrow.us, dm-devel@redhat.com, neilb@cse.unsw.edu.au, hallyn@cs.wm.edu
List-Id: dm-devel.ids


--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi:

For a long time the crypto layer used in_atomic() to determine whether
it's allowed to sleep while performing crypto operations.  This has
turned out to be insufficient because people need to use it in process
context with spin locks held.  As a result a new crypto_tfm flag has been
introduced that tells the crypto layer whether operations performed on
this tfm is allowed to sleep or not.

Here is a patch which sets the the flag for all the users that I could
find which can sleep.  Please have a look over this to see if any one
of them are incorrectly marked.  That is, if any of these tfms are used
in contexts where sleeping is not allowed then please yell.

[CRYPTO] Use CRYPTO_TFM_REQ_MAY_SLEEP where appropriate

This patch goes through the current users of the crypto layer and sets
CRYPTO_TFM_REQ_MAY_SLEEP at crypto_alloc_tfm() where all crypto operations
are performed in process context.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="p2.patch"

diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -57,9 +57,11 @@ cryptoloop_init(struct loop_device *lo, 
 	mode = strsep(&cmsp, "-");
 
 	if (mode == NULL || strcmp(mode, "cbc") == 0)
-		tfm = crypto_alloc_tfm(cipher, CRYPTO_TFM_MODE_CBC);
+		tfm = crypto_alloc_tfm(cipher, CRYPTO_TFM_MODE_CBC |
+					       CRYPTO_TFM_REQ_MAY_SLEEP);
 	else if (strcmp(mode, "ecb") == 0)
-		tfm = crypto_alloc_tfm(cipher, CRYPTO_TFM_MODE_ECB);
+		tfm = crypto_alloc_tfm(cipher, CRYPTO_TFM_MODE_ECB |
+					       CRYPTO_TFM_REQ_MAY_SLEEP);
 	if (tfm == NULL)
 		return -EINVAL;
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -144,7 +144,7 @@ static int crypt_iv_essiv_ctr(struct cry
 	}
 
 	/* Hash the cipher key with the given hash algorithm */
-	hash_tfm = crypto_alloc_tfm(opts, 0);
+	hash_tfm = crypto_alloc_tfm(opts, CRYPTO_TFM_REQ_MAY_SLEEP);
 	if (hash_tfm == NULL) {
 		ti->error = PFX "Error initializing ESSIV hash";
 		return -EINVAL;
@@ -172,7 +172,8 @@ static int crypt_iv_essiv_ctr(struct cry
 
 	/* Setup the essiv_tfm with the given salt */
 	essiv_tfm = crypto_alloc_tfm(crypto_tfm_alg_name(cc->tfm),
-	                             CRYPTO_TFM_MODE_ECB);
+	                             CRYPTO_TFM_MODE_ECB |
+	                             CRYPTO_TFM_REQ_MAY_SLEEP);
 	if (essiv_tfm == NULL) {
 		ti->error = PFX "Error allocating crypto tfm for ESSIV";
 		kfree(salt);
@@ -587,7 +588,7 @@ static int crypt_ctr(struct dm_target *t
 		goto bad1;
 	}
 
-	tfm = crypto_alloc_tfm(cipher, crypto_flags);
+	tfm = crypto_alloc_tfm(cipher, crypto_flags | CRYPTO_TFM_REQ_MAY_SLEEP);
 	if (!tfm) {
 		ti->error = PFX "Error allocating crypto tfm";
 		goto bad1;
diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -1301,7 +1301,7 @@ static int micsetup(struct airo_info *ai
 	int i;
 
 	if (ai->tfm == NULL)
-	        ai->tfm = crypto_alloc_tfm("aes", 0);
+	        ai->tfm = crypto_alloc_tfm("aes", CRYPTO_TFM_REQ_MAY_SLEEP);
 
         if (ai->tfm == NULL) {
                 printk(KERN_ERR "airo: failed to load transform for AES\n");
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -93,7 +93,7 @@ nfs4_make_rec_clidname(char *dname, stru
 
 	dprintk("NFSD: nfs4_make_rec_clidname for %.*s\n",
 			clname->len, clname->data);
-	tfm = crypto_alloc_tfm("md5", 0);
+	tfm = crypto_alloc_tfm("md5", CRYPTO_TFM_REQ_MAY_SLEEP);
 	if (tfm == NULL)
 		goto out;
 	cksum.len = crypto_tfm_alg_digestsize(tfm);
diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -160,7 +160,7 @@ make_checksum(s32 cksumtype, char *heade
 				" unsupported checksum %d", cksumtype);
 			goto out;
 	}
-	if (!(tfm = crypto_alloc_tfm(cksumname, 0)))
+	if (!(tfm = crypto_alloc_tfm(cksumname, CRYPTO_TFM_REQ_MAY_SLEEP)))
 		goto out;
 	cksum->len = crypto_tfm_alg_digestsize(tfm);
 	if ((cksum->data = kmalloc(cksum->len, GFP_KERNEL)) == NULL)
diff --git a/security/seclvl.c b/security/seclvl.c
--- a/security/seclvl.c
+++ b/security/seclvl.c
@@ -321,7 +321,7 @@ plaintext_to_sha1(unsigned char *hash, c
 			      "bytes.\n", len, PAGE_SIZE);
 		return -ENOMEM;
 	}
-	tfm = crypto_alloc_tfm("sha1", 0);
+	tfm = crypto_alloc_tfm("sha1", CRYPTO_TFM_REQ_MAY_SLEEP);
 	if (tfm == NULL) {
 		seclvl_printk(0, KERN_ERR,
 			      "Failed to load transform for SHA1\n");

--ZfOjI3PrQbgiZnxM
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--ZfOjI3PrQbgiZnxM--
