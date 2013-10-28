From: Milan Broz <gmazyland@gmail.com>
Subject: [PATCH 1/2] dm-crypt: Properly handle extra key string
	in initialization
Date: Mon, 28 Oct 2013 23:21:03 +0100
Message-ID: <1382998864-10380-1-git-send-email-gmazyland@gmail.com>
References: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1382275000-10660-1-git-send-email-gmazyland@gmail.com>
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

Some encryption modes use extra keys (e.g. loopAES has IV seed)
which are not used in block cipher initialization but are part
of key string in table constructor.

Patch adds additional field which described lenght of this extra
keys and substracts it before real key encryption setting.

So the key_size always includes the size of provided key
in mapping table in bytes.

The key_parts descibes how many parts (usually keys) contains
the whole key buffer and key_extra_size contains size in bytes
of additional keys part (this number of bytes must be cut off
because is processed by IV generator).

| K1 | K2 | .... | K64 |      Kiv       |
|----------- key_size ----------------- |
|                      |-key_extra_size-|
|     [64 keys]           [1 key]       | => key_parts = 65

Example where key string contains main key K, whitening key
Kw and IV seed Kiv:

|     K       |   Kiv   |       Kw       |
|--------------- key_size ---------------|
|             |-----key_extra_size-------|
|  [1 key]    | [1 key] |     [1 key]    | => key_parts = 3

Because extra keys are calculated during IV mode setting,
key initialization is moved after this step.

For now, this change has no effect to supported modes
(thanks to ilog2 rounding) but is required by following patch.

Signed-off-by: Milan Broz <gmazyland@gmail.com>
---
 drivers/md/dm-crypt.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0fce0bc..878bda7 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -171,7 +171,8 @@ struct crypt_config {
 
 	unsigned long flags;
 	unsigned int key_size;
-	unsigned int key_parts;
+	unsigned int key_parts;     /* independent parts in key buffer */
+	unsigned int key_extra_size;/* additional keys length */
 	u8 key[0];
 };
 
@@ -1274,9 +1275,12 @@ static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
 
 static int crypt_setkey_allcpus(struct crypt_config *cc)
 {
-	unsigned subkey_size = cc->key_size >> ilog2(cc->tfms_count);
+	unsigned subkey_size;
 	int err = 0, i, r;
 
+	/* Ignore extra keys (which are used for IV etc) */
+	subkey_size = (cc->key_size - cc->key_extra_size) >> ilog2(cc->tfms_count);
+
 	for (i = 0; i < cc->tfms_count; i++) {
 		r = crypto_ablkcipher_setkey(cc->tfms[i],
 					     cc->key + (i * subkey_size),
@@ -1409,6 +1413,7 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		return -EINVAL;
 	}
 	cc->key_parts = cc->tfms_count;
+	cc->key_extra_size = 0;
 
 	cc->cipher = kstrdup(cipher, GFP_KERNEL);
 	if (!cc->cipher)
@@ -1460,13 +1465,6 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		goto bad;
 	}
 
-	/* Initialize and set key */
-	ret = crypt_set_key(cc, key);
-	if (ret < 0) {
-		ti->error = "Error decoding and setting key";
-		goto bad;
-	}
-
 	/* Initialize IV */
 	cc->iv_size = crypto_ablkcipher_ivsize(any_tfm(cc));
 	if (cc->iv_size)
@@ -1497,14 +1495,23 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 		 * to length of provided multi-key string.
 		 * If present (version 3), last key is used as IV seed.
 		 */
-		if (cc->key_size % cc->key_parts)
+		if (cc->key_size % cc->key_parts) {
 			cc->key_parts++;
+			cc->key_extra_size = cc->key_size / cc->key_parts;
+		}
 	} else {
 		ret = -EINVAL;
 		ti->error = "Invalid IV mode";
 		goto bad;
 	}
 
+	/* Initialize and set key */
+	ret = crypt_set_key(cc, key);
+	if (ret < 0) {
+		ti->error = "Error decoding and setting key";
+		goto bad;
+	}
+
 	/* Allocate IV */
 	if (cc->iv_gen_ops && cc->iv_gen_ops->ctr) {
 		ret = cc->iv_gen_ops->ctr(cc, ti, ivopts);
-- 
1.8.4.rc3
