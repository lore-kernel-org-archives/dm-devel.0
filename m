From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Subject: [PATCH 1/5] crypto: api - introduce API to (un)register a array of templates
Date: Wed, 18 Jul 2018 15:30:51 +0800
Message-ID: <1531899055-29362-2-git-send-email-wangxiongfeng2@huawei.com>
References: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1531899055-29362-1-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, herbert@gondor.apana.org.au
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com, broonie@kernel.org, arnd@arndb.de, jonathan.cameron@huawei.com
List-Id: dm-devel.ids

The following patch introduce several crypto templates. To simplify the
code, this patch add two APIs to (un)register a array of templates.

Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
---
 crypto/algapi.c         | 27 +++++++++++++++++++++++++++
 include/crypto/algapi.h |  2 ++
 2 files changed, 29 insertions(+)

diff --git a/crypto/algapi.c b/crypto/algapi.c
index c0755cf..08c29e6 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -485,6 +485,24 @@ int crypto_register_template(struct crypto_template *tmpl)
 }
 EXPORT_SYMBOL_GPL(crypto_register_template);
 
+int crypto_register_template_array(struct crypto_template *tmpl, int num)
+{
+	int i, err;
+
+	for (i = 0; i < num; i++) {
+		err = crypto_register_template(&tmpl[i]);
+		if (err)
+			goto out;
+	}
+	return 0;
+
+out:
+	for (i -= 1; i >= 0; i--)
+		crypto_unregister_template(&tmpl[i]);
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_register_template_array);
+
 void crypto_unregister_template(struct crypto_template *tmpl)
 {
 	struct crypto_instance *inst;
@@ -514,6 +532,15 @@ void crypto_unregister_template(struct crypto_template *tmpl)
 }
 EXPORT_SYMBOL_GPL(crypto_unregister_template);
 
+void crypto_unregister_template_array(struct crypto_template *tmpl, int num)
+{
+	int i;
+
+	for (i = 0; i < num; i++)
+		crypto_unregister_template(&tmpl[i]);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_template_array);
+
 static struct crypto_template *__crypto_lookup_template(const char *name)
 {
 	struct crypto_template *q, *tmpl = NULL;
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index bd5e8cc..14bfbe31 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -141,7 +141,9 @@ struct ablkcipher_walk {
 void crypto_mod_put(struct crypto_alg *alg);
 
 int crypto_register_template(struct crypto_template *tmpl);
+int crypto_register_template_array(struct crypto_template *tmpl, int num);
 void crypto_unregister_template(struct crypto_template *tmpl);
+void crypto_unregister_template_array(struct crypto_template *tmpl, int num);
 struct crypto_template *crypto_lookup_template(const char *name);
 
 int crypto_register_instance(struct crypto_template *tmpl,
-- 
1.7.12.4
