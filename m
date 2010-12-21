From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 6/7] [RFC]dm crypt: add multi-key capability
Date: Tue, 21 Dec 2010 16:28:18 +0100
Message-ID: <7a83b9feae17586e0f54b0d71afe7a49fc5b3daa.1292944625.git.mbroz@redhat.com>
References: <cover.1292944625.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1292944625.git.mbroz@redhat.com>
In-Reply-To: <cover.1292944625.git.mbroz@redhat.com>
References: <cover.1292944625.git.mbroz@redhat.com>
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
Cc: Max Vozeler <max@hinterhof.net>, Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

For supporting multikey mapping we need some way
how to setup more keys in mapping table.

This patch extends mapping table to optional keycount and
implements generic multi-key capability.

With more keys defined the <key> string is divided into
several <keycount> sections and these are used for the tfms.

The tfm is used according to sector offset
(sector 0->tfm[0], sector 1->tfm[1], sector N->tfm[N modulo keycount])
(only power of two values supported for keycount here).

(N.B. This capability is there only to allow legacy support
of loop-aes encryption scheme designed by Jari Ruusu.

There is no third party analysis that multikey scheme increases
security of system in comparison to using just one key and secure
block mode and appropriate IV generator.)

Because of tfms per-cpu allocation, this mode can be take
a lot of memory on large smp systems.

Signed-off-by: Milan Broz <mbroz@redhat.com>
CC: Max Vozeler <max@hinterhof.net>
---
 Documentation/device-mapper/dm-crypt.txt |    7 ++-
 drivers/md/dm-crypt.c                    |  100 +++++++++++++++++++++++------
 2 files changed, 85 insertions(+), 22 deletions(-)

diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
index 524de92..2bee19f 100644
--- a/Documentation/device-mapper/dm-crypt.txt
+++ b/Documentation/device-mapper/dm-crypt.txt
@@ -8,7 +8,7 @@ Parameters: <cipher> <key> <iv_offset> <device path> <offset>
 
 <cipher>
     Encryption cipher and an optional IV generation mode.
-    (In format cipher-chainmode-ivopts:ivmode).
+    (In format cipher[:keycount]-chainmode-ivopts:ivmode).
     Examples:
        des
        aes-cbc-essiv:sha256
@@ -20,6 +20,11 @@ Parameters: <cipher> <key> <iv_offset> <device path> <offset>
     Key used for encryption. It is encoded as a hexadecimal number.
     You can only use key sizes that are valid for the selected cipher.
 
+<keycount>
+    Multi-key compatibility mode - you can define different keys and
+    the sectors are according its offset (sector 0 -> key0, 1 -> key1 etc).
+    Keycount must power of two.
+
 <iv_offset>
     The IV offset is a sector count that is added to the sector number
     before creating the IV.
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 451a743..3b9d3a0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -99,10 +99,9 @@ enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID };
 /* Duplicated per CPU state for cipher */
 struct crypt_cpu {
 	struct ablkcipher_request *req;
-	struct crypto_ablkcipher *tfm;
-
 	/* ESSIV: struct crypto_cipher *essiv_tfm */
 	void *iv_private;
+	struct crypto_ablkcipher *tfms[0];
 };
 
 /*
@@ -141,6 +140,7 @@ struct crypt_config {
 	 * per_cpu_ptr() only.
 	 */
 	struct crypt_cpu __percpu *cpu;
+	unsigned int tfms_count;
 
 	/*
 	 * Layout of each crypto request:
@@ -159,6 +159,7 @@ struct crypt_config {
 
 	unsigned long flags;
 	unsigned int key_size;
+	unsigned int key_parts;
 	u8 key[0];
 };
 
@@ -182,7 +183,7 @@ static struct crypto_ablkcipher *any_tfm(struct crypt_config *cc)
 {
 	struct crypto_ablkcipher *tfm;
 	/* cpu doesn't matter, output is always the same */
-	tfm = __this_cpu_ptr(cc->cpu)->tfm;
+	tfm = __this_cpu_ptr(cc->cpu)->tfms[0];
 	return tfm;
 }
 
@@ -562,13 +563,23 @@ static int crypt_convert_block(struct crypt_config *cc,
 
 static void kcryptd_async_done(struct crypto_async_request *async_req,
 			       int error);
+static struct crypto_ablkcipher *crypt_tfm(struct crypt_config *cc,
+					   struct crypt_cpu *cs,
+					   struct convert_context *ctx)
+{
+	if (cc->tfms_count == 1)
+		return cs->tfms[0];
+	else
+		return cs->tfms[(ctx->sector & (cc->tfms_count - 1))];
+}
+
 static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
 	struct crypt_cpu *cs = crypt_me(cc);
 	if (!cs->req)
 		cs->req = mempool_alloc(cc->req_pool, GFP_NOIO);
-	ablkcipher_request_set_tfm(cs->req, cs->tfm);
+	ablkcipher_request_set_tfm(cs->req, crypt_tfm(cc, cs, ctx));
 	ablkcipher_request_set_callback(cs->req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 					CRYPTO_TFM_REQ_MAY_SLEEP,
 					kcryptd_async_done,
@@ -1095,17 +1106,50 @@ static void crypt_encode_key(char *hex, u8 *key, unsigned int size)
 	}
 }
 
+static void crypt_free_tfms(struct crypt_config *cc, int cpu)
+{
+	struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
+	int i;
+
+	for (i = 0; i < cc->tfms_count; i++)
+		if (cs->tfms[i] && !IS_ERR(cs->tfms[i])) {
+			crypto_free_ablkcipher(cs->tfms[i]);
+			cs->tfms[i] = NULL;
+		}
+}
+
+static int crypt_alloc_tfms(struct crypt_config *cc, int cpu, char *ciphermode)
+{
+	struct crypt_cpu *cs = per_cpu_ptr(cc->cpu, cpu);
+	int i, err;
+
+	for (i = 0; i < cc->tfms_count; i++) {
+		cs->tfms[i] = crypto_alloc_ablkcipher(ciphermode, 0, 0);
+		if (IS_ERR(cs->tfms[i])) {
+			err = PTR_ERR(cs->tfms[i]);
+			crypt_free_tfms(cc, cpu);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
 static int crypt_setkey_allcpus(struct crypt_config *cc)
 {
 	struct crypt_cpu *cs;
-	int cpu, n, err;
+	int cpu, i, n, err;
+	unsigned subkey_size = cc->key_size / cc->tfms_count;
 
 	err = 0;
 	for_each_possible_cpu(cpu) {
 		cs = per_cpu_ptr(cc->cpu, cpu);
-		n = crypto_ablkcipher_setkey(cs->tfm, cc->key, cc->key_size);
-		if (n)
-			err = n;
+		for (i = 0; i < cc->tfms_count; i++) {
+			n = crypto_ablkcipher_setkey(cs->tfms[i],
+				cc->key + (i * subkey_size), subkey_size);
+			if (n)
+				err = n;
+		}
 	}
 	return err;
 }
@@ -1154,8 +1198,7 @@ static void crypt_dtr(struct dm_target *ti)
 			cs = per_cpu_ptr(cc->cpu, cpu);
 			if (cs->req)
 				mempool_free(cs->req, cc->req_pool);
-			if (cs->tfm)
-				crypto_free_ablkcipher(cs->tfm);
+			crypt_free_tfms(cc, cpu);
 		}
 
 	if (cc->bs)
@@ -1188,8 +1231,7 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 			    char *cipher_in, char *key)
 {
 	struct crypt_config *cc = ti->private;
-	struct crypto_ablkcipher *tfm;
-	char *tmp, *cipher, *chainmode, *ivmode, *ivopts;
+	char *tmp, *cipher, *chainmode, *ivmode, *ivopts, *keycount;
 	char *cipher_api = NULL;
 	int cpu, ret = -EINVAL;
 
@@ -1201,11 +1243,23 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 
 	/*
 	 * Legacy dm-crypt cipher specification
-	 * cipher-mode-iv:ivopts
+	 * cipher[:keycount]-mode-iv:ivopts
 	 */
 	tmp = cipher_in;
 	cipher = strsep(&tmp, "-");
 
+	keycount = cipher;
+	cipher = strsep(&keycount, ":");
+
+	if (!keycount)
+		cc->tfms_count = 1;
+	else if (sscanf(keycount, "%u", &cc->tfms_count) != 1 ||
+		 !is_power_of_2(cc->tfms_count)) {
+		ti->error = "Bad cipher key count specification";
+		return -EINVAL;
+	}
+	cc->key_parts = cc->tfms_count;
+
 	cc->cipher = kstrdup(cipher, GFP_KERNEL);
 	if (!cc->cipher)
 		goto bad_mem;
@@ -1223,7 +1277,9 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	if (tmp)
 		DMWARN("Ignoring unexpected additional cipher options");
 
-	cc->cpu = alloc_percpu(struct crypt_cpu);
+	cc->cpu = __alloc_percpu(sizeof(*(cc->cpu)) +
+				 cc->tfms_count * sizeof(*(cc->cpu->tfms)),
+				 __alignof__(struct crypt_cpu));
 	if (!cc->cpu) {
 		ti->error = "Cannot allocate per cpu state";
 		goto bad_mem;
@@ -1255,14 +1311,12 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 
 	/* Allocate cipher */
 	for_each_possible_cpu (cpu) {
-		tfm = crypto_alloc_ablkcipher(cipher_api, 0, 0);
-		if (IS_ERR(tfm)) {
-			ret = PTR_ERR(tfm);
+		ret = crypt_alloc_tfms(cc, cpu, cipher_api);
+		if (ret < 0) {
 			ti->error = "Error allocating crypto tfm";
 			goto bad;
 		}
-		per_cpu_ptr(cc->cpu, cpu)->tfm = tfm;
- 	}
+	}
 
 	/* Initialize and set key */
 	ret = crypt_set_key(cc, key);
@@ -1472,7 +1526,11 @@ static int crypt_status(struct dm_target *ti, status_type_t type,
 		break;
 
 	case STATUSTYPE_TABLE:
-		DMEMIT("%s-%s ", cc->cipher, cc->cipher_mode);
+		if (cc->tfms_count == 1)
+			DMEMIT("%s-%s ", cc->cipher, cc->cipher_mode);
+		else
+			DMEMIT("%s:%d-%s ", cc->cipher, cc->tfms_count,
+			       cc->cipher_mode);
 
 		if (cc->key_size > 0) {
 			if ((maxlen - sz) < ((cc->key_size << 1) + 1))
@@ -1584,7 +1642,7 @@ static int crypt_iterate_devices(struct dm_target *ti,
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 7, 0},
+	.version = {1, 8, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-- 
1.7.2.3
