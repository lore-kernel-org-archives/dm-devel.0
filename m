From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 4/7] dm-crypt: Compute HMAC key size in a
	separate function.
Date: Thu, 16 Mar 2017 15:39:41 +0100
Message-ID: <20170316143944.19843-5-gmazyland@gmail.com>
References: <20170316143944.19843-1-gmazyland@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170316143944.19843-1-gmazyland@gmail.com>
In-Reply-To: <cover.1483551181.git.gmazyland@gmail.com>
References: <cover.1483551181.git.gmazyland@gmail.com>
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
Cc: Milan Broz <gmazyland@gmail.com>
List-Id: dm-devel.ids

For composed authenticated modes with HMAC (length-preserving encryption
mode like a XTS and HMAC as an authenticator) we have to calculate
HMAC digest size (the separate authentication key is as the same size
as the HMAC digest).

This patch introduces workaround to parse crypto API string to get
HMAC algorithm and retrieve digest size from it.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0c7d07e17b81..48e8dfe91c53 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2293,6 +2293,45 @@ static int crypt_ctr_blkdev_cipher(struct crypt_config *cc)
 	return 0;
 }
 
+/*
+ * Workaround to parse HMAC algorithm from AEAD crypto API spec.
+ * The HMAC is needed to calculate tag size (HMAC digest size).
+ * This should be probably done by crypto-api calls (once available...)
+ */
+static int crypt_ctr_auth_cipher(struct crypt_config *cc, char *cipher_api)
+{
+	char *start, *end, *mac_alg = NULL;
+	struct crypto_ahash *mac;
+
+	if (!strstarts(cipher_api, "authenc("))
+		return 0;
+
+	start = strchr(cipher_api, '(');
+	end = strchr(cipher_api, ',');
+	if (!start || !end || ++start > end)
+		return -EINVAL;
+
+	mac_alg = kzalloc(end - start + 1, GFP_KERNEL);
+	if (!mac_alg)
+		return -ENOMEM;
+	strncpy(mac_alg, start, end - start);
+
+	mac = crypto_alloc_ahash(mac_alg, 0, 0);
+	kfree(mac_alg);
+
+	if (IS_ERR(mac))
+		return PTR_ERR(mac);
+
+	cc->key_mac_size = crypto_ahash_digestsize(mac);
+	crypto_free_ahash(mac);
+
+	cc->authenc_key = kmalloc(crypt_authenckey_size(cc), GFP_KERNEL);
+	if (!cc->authenc_key)
+		return -ENOMEM;
+
+	return 0;
+}
+
 static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key,
 				char **ivmode, char **ivopts)
 {
@@ -2323,7 +2362,16 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 		return ret;
 	}
 
-	cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
+	/* Alloc AEAD, can be used only in new format. */
+	if (crypt_integrity_aead(cc)) {
+		ret = crypt_ctr_auth_cipher(cc, cipher_api);
+		if (ret < 0) {
+			ti->error = "Invalid AEAD cipher spec";
+			return -ENOMEM;
+		}
+		cc->iv_size = crypto_aead_ivsize(any_tfm_aead(cc));
+	} else
+		cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
 
 	ret = crypt_ctr_blkdev_cipher(cc);
 	if (ret < 0) {
-- 
2.11.0
