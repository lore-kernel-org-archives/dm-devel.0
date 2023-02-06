Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BACE0C05027
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 10:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675678995;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=RnUF309GWTPS7R2AvRkk4CQvZlZA7Rs5qJyZpvd4rcM=;
	b=NAEfXJ62qIaxlqWCiY7HygXE7SrFNy1EftTswDkiOu6oUs++ni12E57nAii47V0NgeMYN3
	U0UTEK6L6+vsYAGeHgDRuo9O5tOsS5jwUhHvi4FmH6je47sDrdYnCKr+K616WevOMfi0pA
	uXg1S6DrJRB47zodskNshsc3aRL6eMc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-88-hbt--YP3OoWF2YY7J31Hxw-1; Mon, 06 Feb 2023 05:23:12 -0500
X-MC-Unique: hbt--YP3OoWF2YY7J31Hxw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0DC7D3810B00;
	Mon,  6 Feb 2023 10:23:11 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ED7EC492B21;
	Mon,  6 Feb 2023 10:23:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id B9A63194658C;
	Mon,  6 Feb 2023 10:23:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C31EC1946595
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 10:23:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 95ABE1415303; Mon,  6 Feb 2023 10:23:08 +0000 (UTC)
Received: from formenos.hmeau.com (unknown [10.67.24.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 37D1C1415126;
 Mon,  6 Feb 2023 10:23:08 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1pOydp-007ziH-Oe; Mon, 06 Feb 2023 18:22:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Mon, 06 Feb 2023 18:22:29 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Mon, 06 Feb 2023 18:22:29 +0800
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
Message-Id: <E1pOydp-007ziH-Oe@formenos.hmeau.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 9/17] KEYS: DH: Use crypto_wait_req
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch replaces the custom crypto completion function with
crypto_req_done.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 security/keys/dh.c |   30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index b339760a31dd..da64c358474b 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -64,22 +64,6 @@ static void dh_free_data(struct dh *dh)
 	kfree_sensitive(dh->g);
 }
 
-struct dh_completion {
-	struct completion completion;
-	int err;
-};
-
-static void dh_crypto_done(struct crypto_async_request *req, int err)
-{
-	struct dh_completion *compl = req->data;
-
-	if (err == -EINPROGRESS)
-		return;
-
-	compl->err = err;
-	complete(&compl->completion);
-}
-
 static int kdf_alloc(struct crypto_shash **hash, char *hashname)
 {
 	struct crypto_shash *tfm;
@@ -146,7 +130,7 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 	struct keyctl_dh_params pcopy;
 	struct dh dh_inputs;
 	struct scatterlist outsg;
-	struct dh_completion compl;
+	DECLARE_CRYPTO_WAIT(compl);
 	struct crypto_kpp *tfm;
 	struct kpp_request *req;
 	uint8_t *secret;
@@ -266,22 +250,18 @@ long __keyctl_dh_compute(struct keyctl_dh_params __user *params,
 
 	kpp_request_set_input(req, NULL, 0);
 	kpp_request_set_output(req, &outsg, outlen);
-	init_completion(&compl.completion);
 	kpp_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG |
 				 CRYPTO_TFM_REQ_MAY_SLEEP,
-				 dh_crypto_done, &compl);
+				 crypto_req_done, &compl);
 
 	/*
 	 * For DH, generate_public_key and generate_shared_secret are
 	 * the same calculation
 	 */
 	ret = crypto_kpp_generate_public_key(req);
-	if (ret == -EINPROGRESS) {
-		wait_for_completion(&compl.completion);
-		ret = compl.err;
-		if (ret)
-			goto out6;
-	}
+	ret = crypto_wait_req(ret, &compl);
+	if (ret)
+		goto out6;
 
 	if (kdfcopy) {
 		/*
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

