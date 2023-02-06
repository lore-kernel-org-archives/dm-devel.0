Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC507C05027
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 10:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675678989;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=cSDZlq+Ah4Pa6REkNqLFKST3F786YNPTCa7dDNzXK9E=;
	b=D6OvCjPmexm6R66zlfAwhzxxvpBPNqSHxqtZWkjsMGxkIFWaUhRfpC4ZgGCopQh59/9Ndy
	SnslHoDqHOQQ5mvP1HaUt6BVgvZub8gQIHe33lzn9gTe+hc2ewB/uSaJli+wISyRqQmbpk
	AEQCuo1h3XplWQtHRxb0+87hFQf+ctA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-KucIGXPPNYu8v1TSLiVvuQ-1; Mon, 06 Feb 2023 05:23:06 -0500
X-MC-Unique: KucIGXPPNYu8v1TSLiVvuQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7F9E3810B03;
	Mon,  6 Feb 2023 10:23:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 804D1C15BAD;
	Mon,  6 Feb 2023 10:23:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 60CAE194658C;
	Mon,  6 Feb 2023 10:23:04 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 96D0C194658C
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 10:23:03 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7B490492B27; Mon,  6 Feb 2023 10:23:03 +0000 (UTC)
Received: from formenos.hmeau.com (unknown [10.67.24.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id C2749492B23;
 Mon,  6 Feb 2023 10:23:02 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1pOydn-007zi3-LG; Mon, 06 Feb 2023 18:22:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Mon, 06 Feb 2023 18:22:27 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Mon, 06 Feb 2023 18:22:27 +0800
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
Message-Id: <E1pOydn-007zi3-LG@formenos.hmeau.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH 8/17] tls: Only use data field in crypto
 completion function
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

The crypto_async_request passed to the completion is not guaranteed
to be the original request object.  Only the data field can be relied
upon.

Fix this by storing the socket pointer with the AEAD request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/tls/tls.h    |    2 ++
 net/tls/tls_sw.c |   40 +++++++++++++++++++++++++++++-----------
 2 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/net/tls/tls.h b/net/tls/tls.h
index 0e840a0c3437..804c3880d028 100644
--- a/net/tls/tls.h
+++ b/net/tls/tls.h
@@ -70,6 +70,8 @@ struct tls_rec {
 	char content_type;
 	struct scatterlist sg_content_type;
 
+	struct sock *sk;
+
 	char aad_space[TLS_AAD_SPACE_SIZE];
 	u8 iv_data[MAX_IV_SIZE];
 	struct aead_request aead_req;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 9ed978634125..5b7f67a7d394 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -38,6 +38,7 @@
 #include <linux/bug.h>
 #include <linux/sched/signal.h>
 #include <linux/module.h>
+#include <linux/kernel.h>
 #include <linux/splice.h>
 #include <crypto/aead.h>
 
@@ -57,6 +58,7 @@ struct tls_decrypt_arg {
 };
 
 struct tls_decrypt_ctx {
+	struct sock *sk;
 	u8 iv[MAX_IV_SIZE];
 	u8 aad[TLS_MAX_AAD_SIZE];
 	u8 tail;
@@ -177,18 +179,25 @@ static int tls_padding_length(struct tls_prot_info *prot, struct sk_buff *skb,
 	return sub;
 }
 
-static void tls_decrypt_done(struct crypto_async_request *req, int err)
+static void tls_decrypt_done(crypto_completion_data_t *data, int err)
 {
-	struct aead_request *aead_req = (struct aead_request *)req;
+	struct aead_request *aead_req = crypto_get_completion_data(data);
+	struct crypto_aead *aead = crypto_aead_reqtfm(aead_req);
 	struct scatterlist *sgout = aead_req->dst;
 	struct scatterlist *sgin = aead_req->src;
 	struct tls_sw_context_rx *ctx;
+	struct tls_decrypt_ctx *dctx;
 	struct tls_context *tls_ctx;
 	struct scatterlist *sg;
 	unsigned int pages;
 	struct sock *sk;
+	int aead_size;
 
-	sk = (struct sock *)req->data;
+	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(aead);
+	aead_size = ALIGN(aead_size, __alignof__(*dctx));
+	dctx = (void *)((u8 *)aead_req + aead_size);
+
+	sk = dctx->sk;
 	tls_ctx = tls_get_ctx(sk);
 	ctx = tls_sw_ctx_rx(tls_ctx);
 
@@ -240,7 +249,7 @@ static int tls_do_decryption(struct sock *sk,
 	if (darg->async) {
 		aead_request_set_callback(aead_req,
 					  CRYPTO_TFM_REQ_MAY_BACKLOG,
-					  tls_decrypt_done, sk);
+					  tls_decrypt_done, aead_req);
 		atomic_inc(&ctx->decrypt_pending);
 	} else {
 		aead_request_set_callback(aead_req,
@@ -336,6 +345,8 @@ static struct tls_rec *tls_get_rec(struct sock *sk)
 	sg_set_buf(&rec->sg_aead_out[0], rec->aad_space, prot->aad_size);
 	sg_unmark_end(&rec->sg_aead_out[1]);
 
+	rec->sk = sk;
+
 	return rec;
 }
 
@@ -417,22 +428,27 @@ int tls_tx_records(struct sock *sk, int flags)
 	return rc;
 }
 
-static void tls_encrypt_done(struct crypto_async_request *req, int err)
+static void tls_encrypt_done(crypto_completion_data_t *data, int err)
 {
-	struct aead_request *aead_req = (struct aead_request *)req;
-	struct sock *sk = req->data;
-	struct tls_context *tls_ctx = tls_get_ctx(sk);
-	struct tls_prot_info *prot = &tls_ctx->prot_info;
-	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
+	struct aead_request *aead_req = crypto_get_completion_data(data);
+	struct tls_sw_context_tx *ctx;
+	struct tls_context *tls_ctx;
+	struct tls_prot_info *prot;
 	struct scatterlist *sge;
 	struct sk_msg *msg_en;
 	struct tls_rec *rec;
 	bool ready = false;
+	struct sock *sk;
 	int pending;
 
 	rec = container_of(aead_req, struct tls_rec, aead_req);
 	msg_en = &rec->msg_encrypted;
 
+	sk = rec->sk;
+	tls_ctx = tls_get_ctx(sk);
+	prot = &tls_ctx->prot_info;
+	ctx = tls_sw_ctx_tx(tls_ctx);
+
 	sge = sk_msg_elem(msg_en, msg_en->sg.curr);
 	sge->offset -= prot->prepend_size;
 	sge->length += prot->prepend_size;
@@ -520,7 +536,7 @@ static int tls_do_encryption(struct sock *sk,
 			       data_len, rec->iv_data);
 
 	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
-				  tls_encrypt_done, sk);
+				  tls_encrypt_done, aead_req);
 
 	/* Add the record in tx_list */
 	list_add_tail((struct list_head *)&rec->list, &ctx->tx_list);
@@ -1485,6 +1501,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	 * Both structs are variable length.
 	 */
 	aead_size = sizeof(*aead_req) + crypto_aead_reqsize(ctx->aead_recv);
+	aead_size = ALIGN(aead_size, __alignof__(*dctx));
 	mem = kmalloc(aead_size + struct_size(dctx, sg, n_sgin + n_sgout),
 		      sk->sk_allocation);
 	if (!mem) {
@@ -1495,6 +1512,7 @@ static int tls_decrypt_sg(struct sock *sk, struct iov_iter *out_iov,
 	/* Segment the allocated memory */
 	aead_req = (struct aead_request *)mem;
 	dctx = (struct tls_decrypt_ctx *)(mem + aead_size);
+	dctx->sk = sk;
 	sgin = &dctx->sg[0];
 	sgout = &dctx->sg[n_sgin];
 
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

