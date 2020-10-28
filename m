Return-Path: <SRS0=VcJp=EE=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA04CC55178
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:08:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [216.205.24.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 33BF82076B
	for <dm-devel@archiver.kernel.org>; Thu, 29 Oct 2020 09:08:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33BF82076B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535--kpdtjQeNp2ZkjGVl7S22A-1; Thu, 29 Oct 2020 05:08:02 -0400
X-MC-Unique: -kpdtjQeNp2ZkjGVl7S22A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 810BF1842142;
	Thu, 29 Oct 2020 09:07:57 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 6150A5C1D0;
	Thu, 29 Oct 2020 09:07:57 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 36C8B181A86E;
	Thu, 29 Oct 2020 09:07:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
	[10.11.54.6])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09SCYZUf015948 for <dm-devel@listman.util.phx.redhat.com>;
	Wed, 28 Oct 2020 08:34:35 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id B71D02156708; Wed, 28 Oct 2020 12:34:35 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id B1D99215670A
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 12:34:32 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 881EB811E83
	for <dm-devel@redhat.com>; Wed, 28 Oct 2020 12:34:32 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172]) by
	relay.mimecast.com with ESMTP id us-mta-567-vHJRaPyRPa2dVbRZ-EdKXQ-1;
	Wed, 28 Oct 2020 08:34:28 -0400
X-MC-Unique: vHJRaPyRPa2dVbRZ-EdKXQ-1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C79671764;
	Wed, 28 Oct 2020 05:34:27 -0700 (PDT)
Received: from e110176-lin.kfn.arm.com (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9FC1E3F719;
	Wed, 28 Oct 2020 05:34:25 -0700 (PDT)
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com
Date: Wed, 28 Oct 2020 14:34:16 +0200
Message-Id: <20201028123420.30623-2-gilad@benyossef.com>
In-Reply-To: <20201028123420.30623-1-gilad@benyossef.com>
References: <20201028123420.30623-1-gilad@benyossef.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09SCYZUf015948
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Thu, 29 Oct 2020 05:07:36 -0400
Cc: Eric Biggers <ebiggers@kernel.org>, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
Subject: [dm-devel] [PATCH v2 1/4] crypto: add eboiv as a crypto API template
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.12
Precedence: junk
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Encrypted byte-offset initialization vector (EBOIV) is an IV
generation method that is used in some cases by dm-crypt for
supporting the BitLocker volume encryption used by Windows 8
and onwards as a backwards compatible version in lieu of XTS
support. Support for eboiv was added to dm-crypt in 5.6.

This patch re-implements eboiv as a generic crypto API
template, thus allowing use of a alternative architecture
specific optimzied implementations (as well as saving a
memory allocation along the way).

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig  |  23 ++++
 crypto/Makefile |   1 +
 crypto/eboiv.c  | 271 ++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 295 insertions(+)
 create mode 100644 crypto/eboiv.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 094ef56ab7b4..57676a2de01e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -538,6 +538,29 @@ config CRYPTO_ESSIV
 	  combined with ESSIV the only feasible mode for h/w accelerated
 	  block encryption)
 
+config CRYPTO_EBOIV
+	tristate "EBOIV support for block encryption"
+	default DM_CRYPT
+	select CRYPTO_CBC
+	help
+	  Encrypted byte-offset initialization vector (EBOIV) is an IV
+	  generation method that is used in some cases by dm-crypt for
+	  supporting the BitLocker volume encryption used by Windows 8
+	  and onwards as a backwards compatible version in lieu of XTS
+	  support.
+
+	  It uses the block encryption key as the symmetric key for a
+	  block encryption pass applied to the sector offset of the block.
+	  Additional details can be found at
+	  https://www.jedec.org/sites/default/files/docs/JESD223C.pdf
+
+	  Note that the use of EBOIV is not recommended for new deployments,
+	  and so this only needs to be enabled when interoperability with
+	  existing encrypted volumes of filesystems is required, or when
+	  building for a particular system that requires it (e.g., when
+	  interop with BitLocker encrypted volumes of Windows systems
+	  prior to Windows 10 is required)
+
 comment "Hash modes"
 
 config CRYPTO_CMAC
diff --git a/crypto/Makefile b/crypto/Makefile
index b279483fba50..9f00b2f1ad9c 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -174,6 +174,7 @@ obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_OFB) += ofb.o
 obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
+obj-$(CONFIG_CRYPTO_EBOIV) += eboiv.o
 obj-$(CONFIG_CRYPTO_CURVE25519) += curve25519-generic.o
 
 ecdh_generic-y += ecdh.o
diff --git a/crypto/eboiv.c b/crypto/eboiv.c
new file mode 100644
index 000000000000..28b9e349b458
--- /dev/null
+++ b/crypto/eboiv.c
@@ -0,0 +1,271 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * EBOIV skcipher template for block encryption
+ *
+ * This template encapsulates the  Encrypted byte-offset IV generation algorithm
+ * used in Bitlocker in CBC mode by dm-crypt, which converts the initial vector
+ * for the skcipher used for block encryption, by encrypting it using the same
+ * skcipher key as encryption key. Usually, the input IV is a 64-bit sector
+ * offset (the byte offset of the start of the sector) in LE representation
+ * zero-padded to the size of the IV, but this * is not assumed by this driver.
+ *
+ * The typical use of this template is to instantiate the skcipher
+ * 'eboiv(cbc(aes))', which is the only instantiation used by
+ * dm-crypt for supporting BitLocker AES-CBC mode as specified in
+ * https://www.jedec.org/sites/default/files/docs/JESD223C.pdf
+ *
+ * Copyright (C) 2020 ARM Limited or its affiliates.
+ * Written by Gilad Ben-Yossef <gilad@benyossef.com>
+ *
+ * Heavily based on:
+ *
+ * ESSIV skcipher and aead template for block encryption
+ * Copyright (c) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
+ *
+ * and
+ *
+ * dm-crypt eboiv code
+ * by Milan Broz <gmazyland@gmail.com> and Ard Biesheuvel <ardb@kernel.org>
+ *
+ */
+
+#include <crypto/internal/skcipher.h>
+#include <crypto/scatterwalk.h>
+#include <linux/module.h>
+
+#include "internal.h"
+
+struct eboiv_instance_ctx {
+	struct crypto_skcipher_spawn skcipher_spawn;
+};
+
+struct eboiv_tfm_ctx {
+	struct crypto_skcipher *skcipher;
+};
+
+struct eboiv_req_ctx {
+	struct skcipher_request *req;
+	bool enc;
+	struct scatterlist src;
+	struct scatterlist dst;
+	u8 iv[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
+	struct skcipher_request subreq;
+};
+
+static int eboiv_skcipher_setkey(struct crypto_skcipher *tfm,
+				 const u8 *key, unsigned int keylen)
+{
+	struct eboiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+
+	crypto_skcipher_clear_flags(tctx->skcipher, CRYPTO_TFM_REQ_MASK);
+	crypto_skcipher_set_flags(tctx->skcipher,
+				  crypto_skcipher_get_flags(tfm) &
+				  CRYPTO_TFM_REQ_MASK);
+	return crypto_skcipher_setkey(tctx->skcipher, key, keylen);
+}
+
+static void eboiv_skcipher_done(struct crypto_async_request *areq, int err)
+{
+	struct skcipher_request *req = areq->data;
+
+	if (err == -EINPROGRESS)
+		return;
+
+	skcipher_request_complete(req, err);
+}
+
+static int eboiv_skcipher_do_crypt(struct skcipher_request *req, bool enc)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct eboiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+	struct eboiv_req_ctx *req_ctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq = &req_ctx->subreq;
+
+	skcipher_request_set_tfm(subreq, tctx->skcipher);
+	skcipher_request_set_crypt(subreq, req->src, req->dst, req->cryptlen, req_ctx->iv);
+	skcipher_request_set_callback(subreq, skcipher_request_flags(req), eboiv_skcipher_done,
+				      req);
+
+	return enc ? crypto_skcipher_encrypt(subreq) :
+		     crypto_skcipher_decrypt(subreq);
+}
+
+static void eboiv_skcipher_iv_done(struct crypto_async_request *areq, int err)
+{
+	struct eboiv_req_ctx *req_ctx = areq->data;
+	struct skcipher_request *req = req_ctx->req;
+
+	if (!err) {
+
+		err = eboiv_skcipher_do_crypt(req, req_ctx->enc);
+
+		if ((err == -EINPROGRESS) || (err == -EBUSY))
+			return;
+	}
+
+	skcipher_request_complete(req, err);
+}
+
+static int eboiv_skcipher_crypt(struct skcipher_request *req, bool enc)
+{
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	const struct eboiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+	struct eboiv_req_ctx *req_ctx = skcipher_request_ctx(req);
+	struct skcipher_request *subreq = &req_ctx->subreq;
+	size_t iv_size = crypto_skcipher_ivsize(tfm);
+	int ret;
+
+	/* The supplied IV is assumed to be in sector offset format (though
+	 * we don't enforce it) - encrypt it.
+	 */
+	sg_init_one(&req_ctx->src, page_address(ZERO_PAGE(0)), iv_size);
+	sg_init_one(&req_ctx->dst, req_ctx->iv, iv_size);
+	skcipher_request_set_tfm(subreq, tctx->skcipher);
+	skcipher_request_set_crypt(subreq, &req_ctx->src, &req_ctx->dst, iv_size, req->iv);
+
+	req_ctx->req = req;
+	req_ctx->enc = enc;
+
+	skcipher_request_set_callback(subreq, skcipher_request_flags(req), eboiv_skcipher_iv_done,
+				      req_ctx);
+
+	ret = crypto_skcipher_encrypt(subreq);
+
+	if (ret)
+		return ret;
+
+	return eboiv_skcipher_do_crypt(req, enc);
+
+}
+
+static int eboiv_skcipher_encrypt(struct skcipher_request *req)
+{
+	return eboiv_skcipher_crypt(req, true);
+}
+
+static int eboiv_skcipher_decrypt(struct skcipher_request *req)
+{
+	return eboiv_skcipher_crypt(req, false);
+}
+
+static int eboiv_skcipher_init_tfm(struct crypto_skcipher *tfm)
+{
+	struct skcipher_instance *inst = skcipher_alg_instance(tfm);
+	struct eboiv_instance_ctx *ictx = skcipher_instance_ctx(inst);
+	struct eboiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+	struct crypto_skcipher *skcipher;
+
+	skcipher = crypto_spawn_skcipher(&ictx->skcipher_spawn);
+	if (IS_ERR(skcipher))
+		return PTR_ERR(skcipher);
+
+	crypto_skcipher_set_reqsize(tfm, sizeof(struct eboiv_req_ctx) +
+				    crypto_skcipher_reqsize(skcipher));
+
+	tctx->skcipher = skcipher;
+	return 0;
+}
+
+static void eboiv_skcipher_exit_tfm(struct crypto_skcipher *tfm)
+{
+	struct eboiv_tfm_ctx *tctx = crypto_skcipher_ctx(tfm);
+
+	crypto_free_skcipher(tctx->skcipher);
+}
+
+static void eboiv_skcipher_free_instance(struct skcipher_instance *inst)
+{
+	struct eboiv_instance_ctx *ictx = skcipher_instance_ctx(inst);
+
+	crypto_drop_skcipher(&ictx->skcipher_spawn);
+	kfree(inst);
+}
+
+static int eboiv_create(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	struct skcipher_instance *inst;
+	struct eboiv_instance_ctx *ictx;
+	struct skcipher_alg *alg;
+	u32 mask;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mask);
+	if (err)
+		return err;
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+
+	ictx = skcipher_instance_ctx(inst);
+
+	err = crypto_grab_skcipher(&ictx->skcipher_spawn, skcipher_crypto_instance(inst),
+				   crypto_attr_alg_name(tb[1]), 0, mask);
+	if (err)
+		goto err_free_inst;
+	alg = crypto_spawn_skcipher_alg(&ictx->skcipher_spawn);
+
+	err = -EINVAL;
+	if (strncmp(alg->base.cra_name, "cbc(", 4) ||
+	    crypto_skcipher_alg_ivsize(alg) != alg->base.cra_blocksize)
+		goto err_free_inst;
+
+	err = -ENAMETOOLONG;
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME, "eboiv(%s)",
+		     alg->base.cra_name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+
+	if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "eboiv(%s)", alg->base.cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
+		goto err_free_inst;
+
+	inst->alg.base.cra_blocksize	= alg->base.cra_blocksize;
+	inst->alg.base.cra_ctxsize	= sizeof(struct eboiv_tfm_ctx);
+	inst->alg.base.cra_alignmask	= alg->base.cra_alignmask;
+	inst->alg.base.cra_priority	= alg->base.cra_priority;
+
+	inst->alg.setkey	= eboiv_skcipher_setkey;
+	inst->alg.encrypt	= eboiv_skcipher_encrypt;
+	inst->alg.decrypt	= eboiv_skcipher_decrypt;
+	inst->alg.init		= eboiv_skcipher_init_tfm;
+	inst->alg.exit		= eboiv_skcipher_exit_tfm;
+
+	inst->alg.min_keysize	= crypto_skcipher_alg_min_keysize(alg);
+	inst->alg.max_keysize	= crypto_skcipher_alg_max_keysize(alg);
+	inst->alg.ivsize	= crypto_skcipher_alg_ivsize(alg);
+
+	inst->free		= eboiv_skcipher_free_instance;
+
+	err = skcipher_register_instance(tmpl, inst);
+
+	if (err) {
+err_free_inst:
+		eboiv_skcipher_free_instance(inst);
+	}
+
+	return err;
+}
+
+/* eboiv(cipher_name) */
+static struct crypto_template eboiv_tmpl = {
+	.name	= "eboiv",
+	.create	= eboiv_create,
+	.module	= THIS_MODULE,
+};
+
+static int __init eboiv_module_init(void)
+{
+	return crypto_register_template(&eboiv_tmpl);
+}
+
+static void __exit eboiv_module_exit(void)
+{
+	crypto_unregister_template(&eboiv_tmpl);
+}
+
+subsys_initcall(eboiv_module_init);
+module_exit(eboiv_module_exit);
+
+MODULE_DESCRIPTION("EBOIV (BitLocker) skcipher wrapper for block encryption");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS_CRYPTO("eboiv");
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

