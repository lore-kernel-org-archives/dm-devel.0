From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 3/7] dm-crypt: Introduce new format of cipher
	with capi: prefix.
Date: Thu, 16 Mar 2017 15:39:40 +0100
Message-ID: <20170316143944.19843-4-gmazyland@gmail.com>
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

For the new authenticated encryption we have to support generic composed
modes (combination of encryption algorithm anf authenticator) because
this is the way how kernel crypto API accesses such algorithms.

To simplify interface, we accept an algorithm directly in crypto API
format.  The new format is recognised by the "capi:" prefix.
The dmcrypt internal IV specification is the same as for the old format.

The crypto API cipher specifications format is:
     capi:cipher_api_spec-ivmode[:ivopts]
Examples:
     capi:cbc(aes)-essiv:sha256 (equivalent to old aes-cbc-essiv:sha256)
     capi:xts(aes)-plain64      (equivalent to old aes-xts-plain64)
Examples of authenticated modes:
     capi:gcm(aes)-random
     capi:authenc(hmac(sha256),xts(aes))-random
     capi:rfc7539(chacha20,poly1305)-random

Authenticated modes can be configured only by the new cipher format.

Authenticated encryption algorithms can be of two types, either
native modes (like GCM) that performs both encryption and authentication
internally, and also composed mode where user can compose AEAD with
separate specification of encryption algorithm and authenticator.

Note that this policy allows user to specify arbitrary combination
that can be insecure. (Policy decision is done in cryptsetup userspace.)

(Note that HMAC composed modes requires following patches in series
that are split for better readability of changes.)

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 Documentation/device-mapper/dm-crypt.txt |  27 +++++--
 drivers/md/dm-crypt.c                    | 134 +++++++++++++++++++++++++------
 2 files changed, 132 insertions(+), 29 deletions(-)

diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
index 058f26ddf875..8140b71f3c54 100644
--- a/Documentation/device-mapper/dm-crypt.txt
+++ b/Documentation/device-mapper/dm-crypt.txt
@@ -11,14 +11,31 @@ Parameters: <cipher> <key> <iv_offset> <device path> \
 	      <offset> [<#opt_params> <opt_params>]
 
 <cipher>
-    Encryption cipher and an optional IV generation mode.
-    (In format cipher[:keycount]-chainmode-ivmode[:ivopts]).
+    Encryption cipher, encryption mode and Initial Vector (IV) generator.
+
+    The cipher specifications format is:
+       cipher[:keycount]-chainmode-ivmode[:ivopts]
     Examples:
-       des
        aes-cbc-essiv:sha256
-       twofish-ecb
+       aes-xts-plain64
+       serpent-xts-plain64
+
+    Cipher format also supports direct specification with kernel crypt API
+    format (selected by capi: prefix). The IV specification is the same
+    as for the first format type.
+    This format is mainly used for specification of authenticated modes.
 
-    /proc/crypto contains supported crypto modes
+    The crypto API cipher specifications format is:
+        capi:cipher_api_spec-ivmode[:ivopts]
+    Examples:
+        capi:cbc(aes)-essiv:sha256
+        capi:xts(aes)-plain64
+    Examples of authenticated modes:
+        capi:gcm(aes)-random
+        capi:authenc(hmac(sha256),xts(aes))-random
+        capi:rfc7539(chacha20,poly1305)-random
+
+    The /proc/crypto contains a list of curently loaded crypto modes.
 
 <key>
     Key used for encryption. It is encoded either as a hexadecimal number
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index faec408dcf50..0c7d07e17b81 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2263,11 +2263,82 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
 	return 0;
 }
 
-static int crypt_ctr_cipher(struct dm_target *ti,
-			    char *cipher_in, char *key)
+/*
+ * Workaround to parse cipher algorithm from crypto API spec.
+ * The cc->cipher is currently used only in ESSIV.
+ * This should be probably done by crypto-api calls (once available...)
+ */
+static int crypt_ctr_blkdev_cipher(struct crypt_config *cc)
+{
+	const char *alg_name = crypto_tfm_alg_name(crypto_skcipher_tfm(any_tfm(cc)));
+	char *start, *end;
+
+	start = strchr(alg_name, '(');
+	end = strchr(alg_name, ')');
+
+	if (!start && !end) {
+		cc->cipher = kstrdup(alg_name, GFP_KERNEL);
+		return cc->cipher ? 0 : -ENOMEM;
+	}
+
+	if (!start || !end || ++start >= end)
+		return -EINVAL;
+
+	cc->cipher = kzalloc(end - start + 1, GFP_KERNEL);
+	if (!cc->cipher)
+		return -ENOMEM;
+
+	strncpy(cc->cipher, start, end - start);
+
+	return 0;
+}
+
+static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key,
+				char **ivmode, char **ivopts)
 {
 	struct crypt_config *cc = ti->private;
-	char *tmp, *cipher, *chainmode, *ivmode, *ivopts, *keycount;
+	char *tmp, *cipher_api;
+	int ret = -EINVAL;
+
+	cc->tfms_count = 1;
+
+	/*
+	 * New format (capi: prefix)
+	 * capi:cipher_api_spec-iv:ivopts
+	 */
+	tmp = &cipher_in[strlen("capi:")];
+	cipher_api = strsep(&tmp, "-");
+	*ivmode = strsep(&tmp, ":");
+	*ivopts = tmp;
+
+	if (*ivmode && !strcmp(*ivmode, "lmk"))
+		cc->tfms_count = 64;
+
+	cc->key_parts = cc->tfms_count;
+
+	/* Allocate cipher */
+	ret = crypt_alloc_tfms(cc, cipher_api);
+	if (ret < 0) {
+		ti->error = "Error allocating crypto tfm";
+		return ret;
+	}
+
+	cc->iv_size = crypto_skcipher_ivsize(any_tfm(cc));
+
+	ret = crypt_ctr_blkdev_cipher(cc);
+	if (ret < 0) {
+		ti->error = "Cannot allocate cipher string";
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key,
+				char **ivmode, char **ivopts)
+{
+	struct crypt_config *cc = ti->private;
+	char *tmp, *cipher, *chainmode, *keycount;
 	char *cipher_api = NULL;
 	int ret = -EINVAL;
 	char dummy;
@@ -2277,10 +2348,6 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	cc->cipher_string = kstrdup(cipher_in, GFP_KERNEL);
-	if (!cc->cipher_string)
-		goto bad_mem;
-
 	/*
 	 * Legacy dm-crypt cipher specification
 	 * cipher[:keycount]-mode-iv:ivopts
@@ -2303,8 +2370,8 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		goto bad_mem;
 
 	chainmode = strsep(&tmp, "-");
-	ivopts = strsep(&tmp, "-");
-	ivmode = strsep(&ivopts, ":");
+	*ivopts = strsep(&tmp, "-");
+	*ivmode = strsep(&*ivopts, ":");
 
 	if (tmp)
 		DMWARN("Ignoring unexpected additional cipher options");
@@ -2313,12 +2380,12 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	 * For compatibility with the original dm-crypt mapping format, if
 	 * only the cipher name is supplied, use cbc-plain.
 	 */
-	if (!chainmode || (!strcmp(chainmode, "plain") && !ivmode)) {
+	if (!chainmode || (!strcmp(chainmode, "plain") && !*ivmode)) {
 		chainmode = "cbc";
-		ivmode = "plain";
+		*ivmode = "plain";
 	}
 
-	if (strcmp(chainmode, "ecb") && !ivmode) {
+	if (strcmp(chainmode, "ecb") && !*ivmode) {
 		ti->error = "IV mechanism required";
 		return -EINVAL;
 	}
@@ -2338,19 +2405,45 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	ret = crypt_alloc_tfms(cc, cipher_api);
 	if (ret < 0) {
 		ti->error = "Error allocating crypto tfm";
-		goto bad;
+		kfree(cipher_api);
+		return ret;
 	}
 
+	return 0;
+bad_mem:
+	ti->error = "Cannot allocate cipher strings";
+	return -ENOMEM;
+}
+
+static int crypt_ctr_cipher(struct dm_target *ti, char *cipher_in, char *key)
+{
+	struct crypt_config *cc = ti->private;
+	char *ivmode = NULL, *ivopts = NULL;
+	int ret;
+
+	cc->cipher_string = kstrdup(cipher_in, GFP_KERNEL);
+	if (!cc->cipher_string) {
+		ti->error = "Cannot allocate cipher strings";
+		return -ENOMEM;
+	}
+
+	if (strstarts(cipher_in, "capi:"))
+		ret = crypt_ctr_cipher_new(ti, cipher_in, key, &ivmode, &ivopts);
+	else
+		ret = crypt_ctr_cipher_old(ti, cipher_in, key, &ivmode, &ivopts);
+	if (ret)
+		return ret;
+
 	/* Initialize IV */
 	ret = crypt_ctr_ivmode(ti, ivmode);
 	if (ret < 0)
-		goto bad;
+		return ret;
 
 	/* Initialize and set key */
 	ret = crypt_set_key(cc, key);
 	if (ret < 0) {
 		ti->error = "Error decoding and setting key";
-		goto bad;
+		return ret;
 	}
 
 	/* Allocate IV */
@@ -2358,7 +2451,7 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		ret = cc->iv_gen_ops->ctr(cc, ti, ivopts);
 		if (ret < 0) {
 			ti->error = "Error creating IV";
-			goto bad;
+			return ret;
 		}
 	}
 
@@ -2367,18 +2460,11 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		ret = cc->iv_gen_ops->init(cc);
 		if (ret < 0) {
 			ti->error = "Error initialising IV";
-			goto bad;
+			return ret;
 		}
 	}
 
-	ret = 0;
-bad:
-	kfree(cipher_api);
 	return ret;
-
-bad_mem:
-	ti->error = "Cannot allocate cipher strings";
-	return -ENOMEM;
 }
 
 static int crypt_ctr_optional(struct dm_target *ti, unsigned int argc, char **argv)
-- 
2.11.0
