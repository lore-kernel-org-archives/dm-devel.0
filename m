Return-Path: <SRS0=TXmu=EC=redhat.com=dm-devel-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AEEC4363A
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 08:43:16 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [63.128.21.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 0E2A2207DE
	for <dm-devel@archiver.kernel.org>; Tue, 27 Oct 2020 08:43:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0E2A2207DE
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=benyossef.com
Authentication-Results: mail.kernel.org; spf=tempfail smtp.mailfrom=dm-devel-bounces@redhat.com
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-6CygbNldP9q2y0UyiUtamg-1; Tue, 27 Oct 2020 04:43:12 -0400
X-MC-Unique: 6CygbNldP9q2y0UyiUtamg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72225186DD2E;
	Tue, 27 Oct 2020 08:43:07 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 582766EF46;
	Tue, 27 Oct 2020 08:43:07 +0000 (UTC)
Received: from lists01.pubmisc.prod.ext.phx2.redhat.com (lists01.pubmisc.prod.ext.phx2.redhat.com [10.5.19.33])
	by colo-mx.corp.redhat.com (Postfix) with ESMTP id C9CC644A69;
	Tue, 27 Oct 2020 08:43:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
	[10.11.54.4])
	by lists01.pubmisc.prod.ext.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id 09QDCFxB030575 for <dm-devel@listman.util.phx.redhat.com>;
	Mon, 26 Oct 2020 09:12:15 -0400
Received: by smtp.corp.redhat.com (Postfix)
	id 5BBC42011541; Mon, 26 Oct 2020 13:12:15 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
	(mimecast04.extmail.prod.ext.rdu2.redhat.com [10.11.55.20])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 560332011551
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 13:12:13 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EB9221021F83
	for <dm-devel@redhat.com>; Mon, 26 Oct 2020 13:12:12 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172]) by
	relay.mimecast.com with ESMTP id us-mta-391-13uMw2hqMkeBGy3sG6anuA-1;
	Mon, 26 Oct 2020 09:12:10 -0400
X-MC-Unique: 13uMw2hqMkeBGy3sG6anuA-1
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DCA6D1516;
	Mon, 26 Oct 2020 06:05:17 -0700 (PDT)
Received: from e110176-lin.arm.com (unknown [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 645CB3F68F;
	Mon, 26 Oct 2020 06:05:15 -0700 (PDT)
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
	dm-devel@redhat.com, Song Liu <song@kernel.org>
Date: Mon, 26 Oct 2020 15:04:46 +0200
Message-Id: <20201026130450.6947-4-gilad@benyossef.com>
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
	lists01.pubmisc.prod.ext.phx2.redhat.com id 09QDCFxB030575
X-loop: dm-devel@redhat.com
X-Mailman-Approved-At: Tue, 27 Oct 2020 04:42:30 -0400
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, Ofir Drang <ofir.drang@arm.com>
Subject: [dm-devel] [PATCH 3/4] dm crypt: switch to EBOIV crypto API template
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dm-devel-bounces@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Replace the explicit EBOIV handling in the dm-crypt driver with calls
into the crypto API, which now possesses the capability to perform
this processing within the crypto subsystem.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>

---
 drivers/md/Kconfig    |  1 +
 drivers/md/dm-crypt.c | 61 ++++++++++++++-----------------------------
 2 files changed, 20 insertions(+), 42 deletions(-)

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 30ba3573626c..ca6e56a72281 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -273,6 +273,7 @@ config DM_CRYPT
 	select CRYPTO
 	select CRYPTO_CBC
 	select CRYPTO_ESSIV
+	select CRYPTO_EBOIV
 	help
 	  This device-mapper target allows you to create a device that
 	  transparently encrypts the data on it. You'll need to activate
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 148960721254..cad8f4e3f5d9 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -716,47 +716,18 @@ static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
 	return 0;
 }
 
-static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
-			    const char *opts)
-{
-	if (crypt_integrity_aead(cc)) {
-		ti->error = "AEAD transforms not supported for EBOIV";
-		return -EINVAL;
-	}
-
-	if (crypto_skcipher_blocksize(any_tfm(cc)) != cc->iv_size) {
-		ti->error = "Block size of EBOIV cipher does "
-			    "not match IV size of block cipher";
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
 			    struct dm_crypt_request *dmreq)
 {
-	u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
-	struct skcipher_request *req;
-	struct scatterlist src, dst;
-	struct crypto_wait wait;
-	int err;
-
-	req = skcipher_request_alloc(any_tfm(cc), GFP_NOIO);
-	if (!req)
-		return -ENOMEM;
-
-	memset(buf, 0, cc->iv_size);
-	*(__le64 *)buf = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
 
-	sg_init_one(&src, page_address(ZERO_PAGE(0)), cc->iv_size);
-	sg_init_one(&dst, iv, cc->iv_size);
-	skcipher_request_set_crypt(req, &src, &dst, cc->iv_size, buf);
-	skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
-	err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
-	skcipher_request_free(req);
+	/*
+	 * ESSIV encryption of the IV is handled by the crypto API,
+	 * so compute and pass the sector offset here.
+	 */
+	memset(iv, 0, cc->iv_size);
+	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
 
-	return err;
+	return 0;
 }
 
 static void crypt_iv_elephant_dtr(struct crypt_config *cc)
@@ -777,13 +748,9 @@ static int crypt_iv_elephant_ctr(struct crypt_config *cc, struct dm_target *ti,
 	if (IS_ERR(elephant->tfm)) {
 		r = PTR_ERR(elephant->tfm);
 		elephant->tfm = NULL;
-		return r;
 	}
 
-	r = crypt_iv_eboiv_ctr(cc, ti, NULL);
-	if (r)
-		crypt_iv_elephant_dtr(cc);
-	return r;
+	return 0;
 }
 
 static void diffuser_disk_to_cpu(u32 *d, size_t n)
@@ -1092,7 +1059,6 @@ static struct crypt_iv_operations crypt_iv_random_ops = {
 };
 
 static struct crypt_iv_operations crypt_iv_eboiv_ops = {
-	.ctr	   = crypt_iv_eboiv_ctr,
 	.generator = crypt_iv_eboiv_gen
 };
 
@@ -2739,6 +2705,15 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
 		cipher_api = buf;
 	}
 
+	if (*ivmode && (!strcmp(*ivmode, "eboiv") || !strcmp(*ivmode, "elephant"))) {
+		ret = snprintf(buf, CRYPTO_MAX_ALG_NAME, "eboiv(%s)", cipher_api);
+		if (ret < 0 || ret >= CRYPTO_MAX_ALG_NAME) {
+			ti->error = "Cannot allocate cipher string";
+			return -ENOMEM;
+		}
+		cipher_api = buf;
+	}
+
 	cc->key_parts = cc->tfms_count;
 
 	/* Allocate cipher */
@@ -2817,6 +2792,8 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
 		}
 		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
 			       "essiv(%s(%s),%s)", chainmode, cipher, *ivopts);
+	} else if (*ivmode && (!strcmp(*ivmode, "eboiv") || !strcmp(*ivmode, "elephant"))) {
+		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME, "eboiv(%s(%s))", chainmode, cipher);
 	} else {
 		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
 			       "%s(%s)", chainmode, cipher);
-- 
2.28.0


--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel

