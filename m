Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1306C55179
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 09:04:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0BB3320870
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 09:04:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0BB3320870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-592-rg6M_BFOODqW75nSTRu3Aw-1; Tue, 27 Oct 2020 05:04:18 -0400
X-MC-Unique: rg6M_BFOODqW75nSTRu3Aw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D741804B84;
	Tue, 27 Oct 2020 09:04:14 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id CBED05C1BD;
	Tue, 27 Oct 2020 09:04:13 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id 59D121832FB7;
	Tue, 27 Oct 2020 09:04:13 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QDCHYD030591 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 09:12:17 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 8D8EA2011542; Mon, 26 Oct 2020 13:12:17 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 874E8200BA9E
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 13:12:14 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
	[205.139.110.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6CCDD185A78B
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 13:12:14 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172]) by
	relay.mimecast.com with ESMTP id us-mta-6-XpWooIWNPa-bElJ_Ktk9YA-1;
	Mon, 26 Oct 2020 09:12:10 -0400
X-MC-Unique: XpWooIWNPa-bElJ_Ktk9YA-1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A9F391529;
	Mon, 26 Oct 2020 06:05:22 -0700 (PDT)
Received: from e110176-lin.arm.com (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 32EB83F68F;
	Mon, 26 Oct 2020 06:05:20 -0700 (PDT)
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Song Liu <song@kernel.org>
Date: Mon, 26 Oct 2020 15:04:47 +0200
Message-Id: <20201026130450.6947-5-gilad@benyossef.com>
In-Reply-To: <20201026130450.6947-1-gilad@benyossef.com>
References: <20201026130450.6947-1-gilad@benyossef.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
	Definition; Similar Internal Domain=false;
	Similar Monitored External Domain=false;
	Custom External Domain=false; Mimecast External Domain=false;
	Newly Observed Domain=false; Internal User Name=false;
	Custom Display Name List=false; Reply-to Address Mismatch=false;
	Targeted Threat Dictionary=false;
	Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-MIME-Autoconverted: from quoted-printable to 8bit by
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09QDCHYD030591
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 27 Oct 2020 04:42:30 -0400
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
Subject: [dm-devel] [PATCH 4/4] crypto: ccree: re-introduce ccree eboiv
	support
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

BitLocker eboiv support, which was removed in
commit 1d8b41ff6991 ("crypto: ccree - remove bitlocker cipher")
is reintroduced based on the crypto API new support for
eboiv.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Fixes: 1d8b41ff6991 ("crypto: ccree - remove bitlocker cipher")
---
 drivers/crypto/ccree/cc_cipher.c     | 130 +++++++++++++++++++--------
 drivers/crypto/ccree/cc_crypto_ctx.h |   1 +
 2 files changed, 94 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index b5568de86ca4..23407063bd40 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -95,10 +95,14 @@ static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 	case S_DIN_to_AES:
 		switch (size) {
 		case CC_AES_128_BIT_KEY_SIZE:
-		case CC_AES_192_BIT_KEY_SIZE:
 			if (ctx_p->cipher_mode != DRV_CIPHER_XTS)
 				return 0;
 			break;
+		case CC_AES_192_BIT_KEY_SIZE:
+			if (ctx_p->cipher_mode != DRV_CIPHER_XTS &&
+			    ctx_p->cipher_mode != DRV_CIPHER_BITLOCKER)
+				return 0;
+			break;
 		case CC_AES_256_BIT_KEY_SIZE:
 			return 0;
 		case (CC_AES_192_BIT_KEY_SIZE * 2):
@@ -141,6 +145,7 @@ static int validate_data_size(struct cc_cipher_ctx *ctx_p,
 		case DRV_CIPHER_ECB:
 		case DRV_CIPHER_CBC:
 		case DRV_CIPHER_ESSIV:
+		case DRV_CIPHER_BITLOCKER:
 			if (IS_ALIGNED(size, AES_BLOCK_SIZE))
 				return 0;
 			break;
@@ -366,7 +371,8 @@ static int cc_cipher_sethkey(struct crypto_skcipher *sktfm, const u8 *key,
 		}
 
 		if (ctx_p->cipher_mode == DRV_CIPHER_XTS ||
-		    ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+		    ctx_p->cipher_mode == DRV_CIPHER_ESSIV ||
+		    ctx_p->cipher_mode == DRV_CIPHER_BITLOCKER) {
 			if (hki.hw_key1 == hki.hw_key2) {
 				dev_err(dev, "Illegal hw key numbers (%d,%d)\n",
 					hki.hw_key1, hki.hw_key2);
@@ -564,6 +570,7 @@ static void cc_setup_readiv_desc(struct crypto_tfm *tfm,
 		break;
 	case DRV_CIPHER_XTS:
 	case DRV_CIPHER_ESSIV:
+	case DRV_CIPHER_BITLOCKER:
 		/*  IV */
 		hw_desc_init(&desc[*seq_size]);
 		set_setup_mode(&desc[*seq_size], SETUP_WRITE_STATE1);
@@ -618,6 +625,7 @@ static void cc_setup_state_desc(struct crypto_tfm *tfm,
 		break;
 	case DRV_CIPHER_XTS:
 	case DRV_CIPHER_ESSIV:
+	case DRV_CIPHER_BITLOCKER:
 		break;
 	default:
 		dev_err(dev, "Unsupported cipher mode (%d)\n", cipher_mode);
@@ -637,56 +645,68 @@ static void cc_setup_xex_state_desc(struct crypto_tfm *tfm,
 	int flow_mode = ctx_p->flow_mode;
 	int direction = req_ctx->gen_ctx.op_type;
 	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
-	unsigned int key_len = (ctx_p->keylen / 2);
 	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
-	unsigned int key_offset = key_len;
+	unsigned int key_len;
+	unsigned int key_offset;
 
 	switch (cipher_mode) {
 	case DRV_CIPHER_ECB:
-		break;
 	case DRV_CIPHER_CBC:
 	case DRV_CIPHER_CBC_CTS:
 	case DRV_CIPHER_CTR:
 	case DRV_CIPHER_OFB:
-		break;
-	case DRV_CIPHER_XTS:
-	case DRV_CIPHER_ESSIV:
+		/* No secondary key for these ciphers, so just return */
+		return;
 
-		if (cipher_mode == DRV_CIPHER_ESSIV)
-			key_len = SHA256_DIGEST_SIZE;
+	case DRV_CIPHER_XTS:
+		/* Secondary key is same size as primary key and stored after primary key */
+		key_len = ctx_p->keylen / 2;
+		key_offset = key_len;
+		break;
 
-		/* load XEX key */
-		hw_desc_init(&desc[*seq_size]);
-		set_cipher_mode(&desc[*seq_size], cipher_mode);
-		set_cipher_config0(&desc[*seq_size], direction);
-		if (cc_key_type(tfm) == CC_HW_PROTECTED_KEY) {
-			set_hw_crypto_key(&desc[*seq_size],
-					  ctx_p->hw.key2_slot);
-		} else {
-			set_din_type(&desc[*seq_size], DMA_DLLI,
-				     (key_dma_addr + key_offset),
-				     key_len, NS_BIT);
-		}
-		set_xex_data_unit_size(&desc[*seq_size], nbytes);
-		set_flow_mode(&desc[*seq_size], S_DIN_to_AES2);
-		set_key_size_aes(&desc[*seq_size], key_len);
-		set_setup_mode(&desc[*seq_size], SETUP_LOAD_XEX_KEY);
-		(*seq_size)++;
+	case DRV_CIPHER_ESSIV:
+		/* Secondary key is a digest of primary key and stored after primary key */
+		key_len = SHA256_DIGEST_SIZE;
+		key_offset = ctx_p->keylen / 2;
+		break;
 
-		/* Load IV */
-		hw_desc_init(&desc[*seq_size]);
-		set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
-		set_cipher_mode(&desc[*seq_size], cipher_mode);
-		set_cipher_config0(&desc[*seq_size], direction);
-		set_key_size_aes(&desc[*seq_size], key_len);
-		set_flow_mode(&desc[*seq_size], flow_mode);
-		set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr,
-			     CC_AES_BLOCK_SIZE, NS_BIT);
-		(*seq_size)++;
+	case DRV_CIPHER_BITLOCKER:
+		/* Secondary key is same as primary key */
+		key_len = ctx_p->keylen;
+		key_offset = 0;
 		break;
+
 	default:
 		dev_err(dev, "Unsupported cipher mode (%d)\n", cipher_mode);
 	}
+
+	/* load XEX key */
+	hw_desc_init(&desc[*seq_size]);
+	set_cipher_mode(&desc[*seq_size], cipher_mode);
+	set_cipher_config0(&desc[*seq_size], direction);
+	if (cc_key_type(tfm) == CC_HW_PROTECTED_KEY) {
+		set_hw_crypto_key(&desc[*seq_size],
+				  ctx_p->hw.key2_slot);
+	} else {
+		set_din_type(&desc[*seq_size], DMA_DLLI,
+			     (key_dma_addr + key_offset),
+			     key_len, NS_BIT);
+	}
+	set_xex_data_unit_size(&desc[*seq_size], nbytes);
+	set_flow_mode(&desc[*seq_size], S_DIN_to_AES2);
+	set_key_size_aes(&desc[*seq_size], key_len);
+	set_setup_mode(&desc[*seq_size], SETUP_LOAD_XEX_KEY);
+	(*seq_size)++;
+
+	/* Load IV */
+	hw_desc_init(&desc[*seq_size]);
+	set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
+	set_cipher_mode(&desc[*seq_size], cipher_mode);
+	set_cipher_config0(&desc[*seq_size], direction);
+	set_key_size_aes(&desc[*seq_size], key_len);
+	set_flow_mode(&desc[*seq_size], flow_mode);
+	set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr, CC_AES_BLOCK_SIZE, NS_BIT);
+	(*seq_size)++;
 }
 
 static int cc_out_flow_mode(struct cc_cipher_ctx *ctx_p)
@@ -723,6 +743,7 @@ static void cc_setup_key_desc(struct crypto_tfm *tfm,
 	case DRV_CIPHER_CTR:
 	case DRV_CIPHER_OFB:
 	case DRV_CIPHER_ECB:
+	case DRV_CIPHER_BITLOCKER:
 		/* Load key */
 		hw_desc_init(&desc[*seq_size]);
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
@@ -1061,6 +1082,24 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.std_body = CC_STD_NIST,
 		.sec_func = true,
 	},
+	{
+		.name = "eboiv(cbc(paes))",
+		.driver_name = "eboiv-cbc-paes-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_sethkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = CC_HW_KEY_SIZE,
+			.max_keysize = CC_HW_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_BITLOCKER,
+		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
+		.sec_func = true,
+	},
 	{
 		.name = "ecb(paes)",
 		.driver_name = "ecb-paes-ccree",
@@ -1189,6 +1228,23 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.min_hw_rev = CC_HW_REV_712,
 		.std_body = CC_STD_NIST,
 	},
+	{
+		.name = "eboiv(cbc(aes))",
+		.driver_name = "eboiv-cbc-aes-ccree",
+		.blocksize = AES_BLOCK_SIZE,
+		.template_skcipher = {
+			.setkey = cc_cipher_setkey,
+			.encrypt = cc_cipher_encrypt,
+			.decrypt = cc_cipher_decrypt,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			},
+		.cipher_mode = DRV_CIPHER_BITLOCKER,
+		.flow_mode = S_DIN_to_AES,
+		.min_hw_rev = CC_HW_REV_712,
+		.std_body = CC_STD_NIST,
+	},
 	{
 		.name = "ecb(aes)",
 		.driver_name = "ecb-aes-ccree",
diff --git a/drivers/crypto/ccree/cc_crypto_ctx.h b/drivers/crypto/ccree/cc_crypto_ctx.h
index bd9a1c0896b3..ccf960a0d989 100644
--- a/drivers/crypto/ccree/cc_crypto_ctx.h
+++ b/drivers/crypto/ccree/cc_crypto_ctx.h
@@ -108,6 +108,7 @@ enum drv_cipher_mode {
 	DRV_CIPHER_CBC_CTS = 11,
 	DRV_CIPHER_GCTR = 12,
 	DRV_CIPHER_ESSIV = 13,
+	DRV_CIPHER_BITLOCKER = 14,
 	DRV_CIPHER_RESERVE32B = S32_MAX
 };
 
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

