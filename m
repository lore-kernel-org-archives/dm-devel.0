Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06FCEC63797
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 10:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675678985;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=EmzPAdG/qmxOms7AYwg0y1CG4/Z8YDSBoB9D/BOAu5s=;
	b=GPieEO8ccC9rn8+wRTUGgcu+an3IQUIL56zotxgzr5hLg2+Yxt2aRxpwMxfkhCZ27loLi/
	vprH+tn+baYBodmSXfLHQsxG8f2an3/4F8mksJH313YHkVB+ncMYaRA5o1GTde06CW5XS4
	9RrDeuMceiZA4P6jmWFF97nhZsyMj40=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-325-BsEQ5fSSPeWe7pwReilsxw-1; Mon, 06 Feb 2023 05:23:03 -0500
X-MC-Unique: BsEQ5fSSPeWe7pwReilsxw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7441E183B3C0;
	Mon,  6 Feb 2023 10:23:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6439E2026D37;
	Mon,  6 Feb 2023 10:23:00 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3A8AA194658C;
	Mon,  6 Feb 2023 10:23:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id D2A86194658C
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 10:22:58 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B70EA1415127; Mon,  6 Feb 2023 10:22:58 +0000 (UTC)
Received: from formenos.hmeau.com (unknown [10.67.24.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 599E51415113;
 Mon,  6 Feb 2023 10:22:58 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1pOydf-007zgz-7o; Mon, 06 Feb 2023 18:22:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Mon, 06 Feb 2023 18:22:19 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Mon, 06 Feb 2023 18:22:19 +0800
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 dm-devel@redhat.com, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
 Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
 Marcel Holtmann <marcel@holtmann.org>, Johan Hedberg <johan.hedberg@gmail.com>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, linux-bluetooth@vger.kernel.org,
 Steffen Klassert <steffen.klassert@secunet.com>, Jon Maloy <jmaloy@redhat.com>,
 Ying Xue <ying.xue@windriver.com>, Boris Pismenny <borisp@nvidia.com>,
 John Fastabend <john.fastabend@gmail.com>, David Howells <dhowells@redhat.com>,
 Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Message-Id: <E1pOydf-007zgz-7o@formenos.hmeau.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 4/17] Bluetooth: Use crypto_wait_req
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
MIME-Version: 1.0
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch replaces the custom crypto completion function with
crypto_req_done.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/bluetooth/ecdh_helper.c |   37 ++++++-------------------------------
 1 file changed, 6 insertions(+), 31 deletions(-)

diff --git a/net/bluetooth/ecdh_helper.c b/net/bluetooth/ecdh_helper.c
index 989401f116e9..0efc93fdae8a 100644
--- a/net/bluetooth/ecdh_helper.c
+++ b/net/bluetooth/ecdh_helper.c
@@ -25,22 +25,6 @@
 #include <linux/scatterlist.h>
 #include <crypto/ecdh.h>
 
-struct ecdh_completion {
-	struct completion completion;
-	int err;
-};
-
-static void ecdh_complete(struct crypto_async_request *req, int err)
-{
-	struct ecdh_completion *res = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	res->err = err;
-	complete(&res->completion);
-}
-
 static inline void swap_digits(u64 *in, u64 *out, unsigned int ndigits)
 {
 	int i;
@@ -60,9 +44,9 @@ static inline void swap_digits(u64 *in, u64 *out, unsigned int ndigits)
 int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
 			u8 secret[32])
 {
+	DECLARE_CRYPTO_WAIT(result);
 	struct kpp_request *req;
 	u8 *tmp;
-	struct ecdh_completion result;
 	struct scatterlist src, dst;
 	int err;
 
@@ -76,8 +60,6 @@ int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
 		goto free_tmp;
 	}
 
-	init_completion(&result.completion);
-
 	swap_digits((u64 *)public_key, (u64 *)tmp, 4); /* x */
 	swap_digits((u64 *)&public_key[32], (u64 *)&tmp[32], 4); /* y */
 
@@ -86,12 +68,9 @@ int compute_ecdh_secret(struct crypto_kpp *tfm, const u8 public_key[64],
 	kpp_request_set_input(req, &src, 64);
 	kpp_request_set_output(req, &dst, 32);
 	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				 ecdh_complete, &result);
+				 crypto_req_done, &result);
 	err = crypto_kpp_compute_shared_secret(req);
-	if (err == -EINPROGRESS) {
-		wait_for_completion(&result.completion);
-		err = result.err;
-	}
+	err = crypto_wait_req(err, &result);
 	if (err < 0) {
 		pr_err("alg: ecdh: compute shared secret failed. err %d\n",
 		       err);
@@ -165,9 +144,9 @@ int set_ecdh_privkey(struct crypto_kpp *tfm, const u8 private_key[32])
  */
 int generate_ecdh_public_key(struct crypto_kpp *tfm, u8 public_key[64])
 {
+	DECLARE_CRYPTO_WAIT(result);
 	struct kpp_request *req;
 	u8 *tmp;
-	struct ecdh_completion result;
 	struct scatterlist dst;
 	int err;
 
@@ -181,18 +160,14 @@ int generate_ecdh_public_key(struct crypto_kpp *tfm, u8 public_key[64])
 		goto free_tmp;
 	}
 
-	init_completion(&result.completion);
 	sg_init_one(&dst, tmp, 64);
 	kpp_request_set_input(req, NULL, 0);
 	kpp_request_set_output(req, &dst, 64);
 	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				 ecdh_complete, &result);
+				 crypto_req_done, &result);
 
 	err = crypto_kpp_generate_public_key(req);
-	if (err == -EINPROGRESS) {
-		wait_for_completion(&result.completion);
-		err = result.err;
-	}
+	err = crypto_wait_req(err, &result);
 	if (err < 0)
 		goto free_all;
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

