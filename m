Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BE08C05027
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 10:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675678982;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=b9VGXDeO1o5tYgOeePhA3gL2r7YJaRQRv1yUqvJnJNg=;
	b=WBHBhSdwaFvyCFKaQt3VN3ADM6x6woay0uv4oIttT0bnkNugycrGLaUEkhcNEAzb05GQLp
	GHCG/oVxzqaoyckAaHsSOtIsfvYCJBuJEr+VrDKykI/y1aC8xz45rAIOy9nsuJ5yUyixyS
	Z76iHbMQ+k5kAFIsotLv3hz0uktCwN8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-vEvZJ63QMAS80kEdinZs1w-1; Mon, 06 Feb 2023 05:22:59 -0500
X-MC-Unique: vEvZJ63QMAS80kEdinZs1w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 960C5848D93;
	Mon,  6 Feb 2023 10:22:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 86260C15BA0;
	Mon,  6 Feb 2023 10:22:57 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1181D19465A8;
	Mon,  6 Feb 2023 10:22:57 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 37B891946589
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 10:22:41 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id CAFB02166B2F; Mon,  6 Feb 2023 10:22:40 +0000 (UTC)
Received: from formenos.hmeau.com (unknown [10.67.24.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 679ED2166B29;
 Mon,  6 Feb 2023 10:22:40 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1pOydY-007zgU-U2; Mon, 06 Feb 2023 18:22:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Mon, 06 Feb 2023 18:22:12 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Mon, 06 Feb 2023 18:22:12 +0800
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
Message-Id: <E1pOydY-007zgU-U2@formenos.hmeau.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 1/17] dm: Add scaffolding to change completion
 function signature
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

This patch adds temporary scaffolding so that the Crypto API
completion function can take a void * instead of crypto_async_request.
Once affected users have been converted this can be removed.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/md/dm-crypt.c     |    8 +++-----
 drivers/md/dm-integrity.c |    4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 2653516bcdef..7609fe39ab8c 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1458,8 +1458,7 @@ static int crypt_convert_block_skcipher(struct crypt_config *cc,
 	return r;
 }
 
-static void kcryptd_async_done(struct crypto_async_request *async_req,
-			       int error);
+static void kcryptd_async_done(crypto_completion_data_t *async_req, int error);
 
 static int crypt_alloc_req_skcipher(struct crypt_config *cc,
 				     struct convert_context *ctx)
@@ -2147,10 +2146,9 @@ static void kcryptd_crypt_read_convert(struct dm_crypt_io *io)
 	crypt_dec_pending(io);
 }
 
-static void kcryptd_async_done(struct crypto_async_request *async_req,
-			       int error)
+static void kcryptd_async_done(crypto_completion_data_t *data, int error)
 {
-	struct dm_crypt_request *dmreq = async_req->data;
+	struct dm_crypt_request *dmreq = crypto_get_completion_data(data);
 	struct convert_context *ctx = dmreq->ctx;
 	struct dm_crypt_io *io = container_of(ctx, struct dm_crypt_io, ctx);
 	struct crypt_config *cc = io->cc;
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index 1388ee35571e..eefe25ed841e 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -955,9 +955,9 @@ static void xor_journal(struct dm_integrity_c *ic, bool encrypt, unsigned sectio
 	async_tx_issue_pending_all();
 }
 
-static void complete_journal_encrypt(struct crypto_async_request *req, int err)
+static void complete_journal_encrypt(crypto_completion_data_t *data, int err)
 {
-	struct journal_completion *comp = req->data;
+	struct journal_completion *comp = crypto_get_completion_data(data);
 	if (unlikely(err)) {
 		if (likely(err == -EINPROGRESS)) {
 			complete(&comp->ic->crypto_backoff);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

