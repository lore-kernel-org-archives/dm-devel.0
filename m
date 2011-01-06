From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH 2/3] dm crypt: add multi-key capability
Date: Thu,  6 Jan 2011 21:04:01 +0100
Message-ID: <0c5d8390ede21657d3dab5ec412ed2fa4c1cdbac.1294344057.git.mbroz@redhat.com>
References: <cover.1294344057.git.mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <cover.1294344057.git.mbroz@redhat.com>
In-Reply-To: <cover.1294344057.git.mbroz@redhat.com>
References: <cover.1294344057.git.mbroz@redhat.com>
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

This patch adds generic multikey handling to be used
in following patch for Loop-AES mode compatibility.

This patch extends mapping table to optional keycount and
implements generic multi-key capability.

With more keys defined the <key> string is divided into
several <keycount> sections and these are used for tfms.

The tfm is used according to sector offset
(sector 0->tfm[0], sector 1->tfm[1], sector N->tfm[N modulo keycount])
(only power of two values supported for keycount here).

Because of tfms per-cpu allocation, this mode can be take
a lot of memory on large smp systems.

Signed-off-by: Milan Broz <mbroz@redhat.com>
CC: Max Vozeler <max@hinterhof.net>
---
 Documentation/device-mapper/dm-crypt.txt |    7 ++-
 drivers/md/dm-crypt.c                    |   85 +++++++++++++++++++++++-------
 2 files changed, 71 insertions(+), 21 deletions(-)

diff --git a/Documentation/device-mapper/dm-crypt.txt b/Documentation/device-mapper/dm-crypt.txt
index 524de92..6ed2312 100644
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
+    Keycount value must be power of two.
+
 <iv_offset>
     The IV offset is a sector count that is added to the sector number
     before creating the IV.
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 9678701..eba9b43 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -101,10 +101,9 @@ enum flags { DM_CRYPT_SUSPENDED, DM_CRYPT_KEY_VALID };
  */
 struct crypt_cpu {
 	struct ablkcipher_request *req;
-	struct crypto_ablkcipher *tfm;
-
 	/* ESSIV: struct crypto_cipher *essiv_tfm */
 	void *iv_private;
+	struct crypto_ablkcipher *tfms[0];
 };
 
 /*
@@ -143,6 +142,7 @@ struct crypt_config {
 	 * per_cpu_ptr() only.
 	 */
 	struct crypt_cpu __percpu *cpu;
+	unsigned int tfms_count;
 
 	/*
 	 * Layout of each crypto request:
@@ -161,6 +161,7 @@ struct crypt_config {
 
 	unsigned long flags;
 	unsigned int key_size;
+	unsigned int key_parts;
 	u8 key[0];
 };
 
@@ -184,7 +185,7 @@ static struct crypt_cpu *this_crypt_config(struct crypt_config *cc)
  */
 static struct crypto_ablkcipher *this_tfm(struct crypt_config *cc)
 {
-	return __this_cpu_ptr(cc->cpu)->tfm;
+	return __this_cpu_ptr(cc->cpu)->tfms[0];
 }
 
 /*
@@ -567,11 +568,12 @@ static void crypt_alloc_req(struct crypt_config *cc,
 			    struct convert_context *ctx)
 {
 	struct crypt_cpu *this_cc = this_crypt_config(cc);
+	unsigned key_index = ctx->sector & (cc->tfms_count - 1);
 
 	if (!this_cc->req)
 		this_cc->req = mempool_alloc(cc->req_pool, GFP_NOIO);
 
-	ablkcipher_request_set_tfm(this_cc->req, this_cc->tfm);
+	ablkcipher_request_set_tfm(this_cc->req, this_cc->tfms[key_index]);
 	ablkcipher_request_set_callback(this_cc->req,
 	    CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 	    kcryptd_async_done, dmreq_of_req(cc, this_cc->req));
@@ -1097,15 +1099,48 @@ static void crypt_encode_key(char *hex, u8 *key, unsigned int size)
 	}
 }
 
+static void crypt_free_tfms(struct crypt_config *cc, int cpu)
+{
+	struct crypt_cpu *cpu_cc = per_cpu_ptr(cc->cpu, cpu);
+	int i;
+
+	for (i = 0; i < cc->tfms_count; i++)
+		if (cpu_cc->tfms[i] && !IS_ERR(cpu_cc->tfms[i])) {
+			crypto_free_ablkcipher(cpu_cc->tfms[i]);
+			cpu_cc->tfms[i] = NULL;
+		}
+}
+
+static int crypt_alloc_tfms(struct crypt_config *cc, int cpu, char *ciphermode)
+{
+	struct crypt_cpu *cpu_cc = per_cpu_ptr(cc->cpu, cpu);
+	int i, err;
+
+	for (i = 0; i < cc->tfms_count; i++) {
+		cpu_cc->tfms[i] = crypto_alloc_ablkcipher(ciphermode, 0, 0);
+		if (IS_ERR(cpu_cc->tfms[i])) {
+			err = PTR_ERR(cpu_cc->tfms[i]);
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
-	int cpu, err = 0, r;
+	unsigned subkey_size = cc->key_size >> ilog2(cc->tfms_count);
+	int cpu, err = 0, i, r;
 
 	for_each_possible_cpu(cpu) {
-		r = crypto_ablkcipher_setkey(per_cpu_ptr(cc->cpu, cpu)->tfm,
-					       cc->key, cc->key_size);
-		if (r)
-			err = r;
+		for (i = 0; i < cc->tfms_count; i++) {
+			r = crypto_ablkcipher_setkey(
+				per_cpu_ptr(cc->cpu, cpu)->tfms[i],
+				cc->key + (i * subkey_size), subkey_size);
+			if (r)
+				err = r;
+		}
 	}
 
 	return err;
@@ -1158,8 +1193,7 @@ static void crypt_dtr(struct dm_target *ti)
 			cpu_cc = per_cpu_ptr(cc->cpu, cpu);
 			if (cpu_cc->req)
 				mempool_free(cpu_cc->req, cc->req_pool);
-			if (cpu_cc->tfm)
-				crypto_free_ablkcipher(cpu_cc->tfm);
+			crypt_free_tfms(cc, cpu);
 		}
 
 	if (cc->bs)
@@ -1192,8 +1226,7 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 			    char *cipher_in, char *key)
 {
 	struct crypt_config *cc = ti->private;
-	struct crypto_ablkcipher *tfm;
-	char *tmp, *cipher, *chainmode, *ivmode, *ivopts;
+	char *tmp, *cipher, *chainmode, *ivmode, *ivopts, *keycount;
 	char *cipher_api = NULL;
 	int cpu, ret = -EINVAL;
 
@@ -1209,11 +1242,23 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 
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
@@ -1225,7 +1270,9 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 	if (tmp)
 		DMWARN("Ignoring unexpected additional cipher options");
 
-	cc->cpu = alloc_percpu(struct crypt_cpu);
+	cc->cpu = __alloc_percpu(sizeof(*(cc->cpu)) +
+				 cc->tfms_count * sizeof(*(cc->cpu->tfms)),
+				 __alignof__(struct crypt_cpu));
 	if (!cc->cpu) {
 		ti->error = "Cannot allocate per cpu state";
 		goto bad_mem;
@@ -1258,13 +1305,11 @@ static int crypt_ctr_cipher(struct dm_target *ti,
 
 	/* Allocate cipher */
 	for_each_possible_cpu(cpu) {
-		tfm = crypto_alloc_ablkcipher(cipher_api, 0, 0);
-		if (IS_ERR(tfm)) {
-			ret = PTR_ERR(tfm);
+		ret = crypt_alloc_tfms(cc, cpu, cipher_api);
+		if (ret < 0) {
 			ti->error = "Error allocating crypto tfm";
 			goto bad;
 		}
-		per_cpu_ptr(cc->cpu, cpu)->tfm = tfm;
 	}
 
 	/* Initialize and set key */
@@ -1587,7 +1632,7 @@ static int crypt_iterate_devices(struct dm_target *ti,
 
 static struct target_type crypt_target = {
 	.name   = "crypt",
-	.version = {1, 7, 0},
+	.version = {1, 8, 0},
 	.module = THIS_MODULE,
 	.ctr    = crypt_ctr,
 	.dtr    = crypt_dtr,
-- 
1.7.2.3
