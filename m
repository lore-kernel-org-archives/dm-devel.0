From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH] dm crypt: remove obsolete references to per-CPU
	state
Date: Thu, 30 Mar 2017 22:18:48 -0700
Message-ID: <20170331051848.7845-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>
List-Id: dm-devel.ids

From: Eric Biggers <ebiggers@google.com>

dm-crypt used to use separate crypto transforms for each CPU, but this
is no longer the case.  To avoid confusion, fix up obsolete comments and
rename setup_essiv_cpu().

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 drivers/md/dm-crypt.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 389a3637ffcc..a57cb41f000e 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -191,7 +191,7 @@ static void kcryptd_queue_crypt(struct dm_crypt_io *io);
 static u8 *iv_of_dmreq(struct crypt_config *cc, struct dm_crypt_request *dmreq);
 
 /*
- * Use this to access cipher attributes that are the same for each CPU.
+ * Use this to access cipher attributes that are independent of the key.
  */
 static struct crypto_skcipher *any_tfm(struct crypt_config *cc)
 {
@@ -310,10 +310,11 @@ static int crypt_iv_essiv_wipe(struct crypt_config *cc)
 	return err;
 }
 
-/* Set up per cpu cipher state */
-static struct crypto_cipher *setup_essiv_cpu(struct crypt_config *cc,
-					     struct dm_target *ti,
-					     u8 *salt, unsigned saltsize)
+/* Allocate the cipher for ESSIV */
+static struct crypto_cipher *alloc_essiv_cipher(struct crypt_config *cc,
+						struct dm_target *ti,
+						const u8 *salt,
+						unsigned int saltsize)
 {
 	struct crypto_cipher *essiv_tfm;
 	int err;
@@ -393,8 +394,8 @@ static int crypt_iv_essiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	cc->iv_gen_private.essiv.salt = salt;
 	cc->iv_gen_private.essiv.hash_tfm = hash_tfm;
 
-	essiv_tfm = setup_essiv_cpu(cc, ti, salt,
-				crypto_ahash_digestsize(hash_tfm));
+	essiv_tfm = alloc_essiv_cipher(cc, ti, salt,
+				       crypto_ahash_digestsize(hash_tfm));
 	if (IS_ERR(essiv_tfm)) {
 		crypt_iv_essiv_dtr(cc);
 		return PTR_ERR(essiv_tfm);
-- 
2.12.1
