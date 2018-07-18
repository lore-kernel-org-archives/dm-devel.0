From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: [PATCH 2/5] crypto: ccm - use template array registering API to simplify the code
Date: Wed, 18 Jul 2018 15:30:52 +0800
Message-ID: <1531899055-29362-3-git-send-email-wangxiongfeng2@huawei.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, herbert@gondor.apana.org.au
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com, broonie@kernel.org, arnd@arndb.de, jonathan.cameron@huawei.com
List-Id: dm-devel.ids

Use crypto template array registering API to simplify the code.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 crypto/ccm.c | 82 ++++++++++++++++++++----------------------------------------
 1 file changed, 27 insertions(+), 55 deletions(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 0a08334..1742d41 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -586,12 +586,6 @@ static int crypto_ccm_create(struct crypto_template *tmpl, struct rtattr **tb)
 					mac_name);
 }
 
-static struct crypto_template crypto_ccm_tmpl = {
-	.name = "ccm",
-	.create = crypto_ccm_create,
-	.module = THIS_MODULE,
-};
-
 static int crypto_ccm_base_create(struct crypto_template *tmpl,
 				  struct rtattr **tb)
 {
@@ -615,12 +609,6 @@ static int crypto_ccm_base_create(struct crypto_template *tmpl,
 					cipher_name);
 }
 
-static struct crypto_template crypto_ccm_base_tmpl = {
-	.name = "ccm_base",
-	.create = crypto_ccm_base_create,
-	.module = THIS_MODULE,
-};
-
 static int crypto_rfc4309_setkey(struct crypto_aead *parent, const u8 *key,
 				 unsigned int keylen)
 {
@@ -851,12 +839,6 @@ static int crypto_rfc4309_create(struct crypto_template *tmpl,
 	goto out;
 }
 
-static struct crypto_template crypto_rfc4309_tmpl = {
-	.name = "rfc4309",
-	.create = crypto_rfc4309_create,
-	.module = THIS_MODULE,
-};
-
 static int crypto_cbcmac_digest_setkey(struct crypto_shash *parent,
 				     const u8 *inkey, unsigned int keylen)
 {
@@ -996,51 +978,41 @@ static int cbcmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	return err;
 }
 
-static struct crypto_template crypto_cbcmac_tmpl = {
-	.name = "cbcmac",
-	.create = cbcmac_create,
-	.free = shash_free_instance,
-	.module = THIS_MODULE,
+#define CCM_TEMPLATE_NUM 4
+
+static struct crypto_template crypto_ccm_tmpl[CCM_TEMPLATE_NUM] = {
+	{
+		.name = "cbcmac",
+		.create = cbcmac_create,
+		.free = shash_free_instance,
+		.module = THIS_MODULE,
+	},
+	{
+		.name = "ccm_base",
+		.create = crypto_ccm_base_create,
+		.module = THIS_MODULE,
+	},
+	{
+		.name = "ccm",
+		.create = crypto_ccm_create,
+		.module = THIS_MODULE,
+	},
+	{
+		.name = "rfc4309",
+		.create = crypto_rfc4309_create,
+		.module = THIS_MODULE,
+	},
 };
 
 static int __init crypto_ccm_module_init(void)
 {
-	int err;
-
-	err = crypto_register_template(&crypto_cbcmac_tmpl);
-	if (err)
-		goto out;
-
-	err = crypto_register_template(&crypto_ccm_base_tmpl);
-	if (err)
-		goto out_undo_cbcmac;
-
-	err = crypto_register_template(&crypto_ccm_tmpl);
-	if (err)
-		goto out_undo_base;
-
-	err = crypto_register_template(&crypto_rfc4309_tmpl);
-	if (err)
-		goto out_undo_ccm;
-
-out:
-	return err;
-
-out_undo_ccm:
-	crypto_unregister_template(&crypto_ccm_tmpl);
-out_undo_base:
-	crypto_unregister_template(&crypto_ccm_base_tmpl);
-out_undo_cbcmac:
-	crypto_register_template(&crypto_cbcmac_tmpl);
-	goto out;
+	return crypto_register_template_array(crypto_ccm_tmpl,
+			CCM_TEMPLATE_NUM);
 }
 
 static void __exit crypto_ccm_module_exit(void)
 {
-	crypto_unregister_template(&crypto_rfc4309_tmpl);
-	crypto_unregister_template(&crypto_ccm_tmpl);
-	crypto_unregister_template(&crypto_ccm_base_tmpl);
-	crypto_unregister_template(&crypto_cbcmac_tmpl);
+	crypto_unregister_template_array(crypto_ccm_tmpl, CCM_TEMPLATE_NUM);
 }
 
 module_init(crypto_ccm_module_init);
-- 
1.7.12.4
