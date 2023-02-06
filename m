Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF628C636D6
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 10:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675678983;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=W8CcsJFzlGg78cee9IHD8/h+3I/7GF7oHD7ZRA48oWw=;
	b=gWpNmCOvndNBD1/K6dLTSrjbkC37ejF7iiZqGravxvER+0nbrE+7wg81lH5gCksVOwuvgk
	tKvOCKIwRXdmNbfvu59QeVanU9S4LMILo5jlP3drvWlCZ7ZOOOQ9RrR9WN37Tjqxmx7oVK
	k+AKzbZLNDn6HR5Ie/Uy0YKML3ZhiA4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-34-1uFDf9vLP5eyNbcM0lnDdQ-1; Mon, 06 Feb 2023 05:23:00 -0500
X-MC-Unique: 1uFDf9vLP5eyNbcM0lnDdQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5F7153810B02;
	Mon,  6 Feb 2023 10:22:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 4B646C15BA0;
	Mon,  6 Feb 2023 10:22:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0DDB2194658F;
	Mon,  6 Feb 2023 10:22:58 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 73F731946589
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 10:22:56 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 47FF72026D3E; Mon,  6 Feb 2023 10:22:56 +0000 (UTC)
Received: from formenos.hmeau.com (unknown [10.67.24.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DA4AD2026D37;
 Mon,  6 Feb 2023 10:22:55 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1pOydd-007zgo-4c; Mon, 06 Feb 2023 18:22:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Mon, 06 Feb 2023 18:22:17 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Mon, 06 Feb 2023 18:22:17 +0800
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
Message-Id: <E1pOydd-007zgo-4c@formenos.hmeau.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 3/17] fs: ecryptfs: Use crypto_wait_req
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

This patch replaces the custom crypto completion function with
crypto_req_done.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 fs/ecryptfs/crypto.c |   30 +++---------------------------
 1 file changed, 3 insertions(+), 27 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index e3f5d7f3c8a0..c3057539f088 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -260,22 +260,6 @@ int virt_to_scatterlist(const void *addr, int size, struct scatterlist *sg,
 	return i;
 }
 
-struct extent_crypt_result {
-	struct completion completion;
-	int rc;
-};
-
-static void extent_crypt_complete(struct crypto_async_request *req, int rc)
-{
-	struct extent_crypt_result *ecr = req->data;
-
-	if (rc == -EINPROGRESS)
-		return;
-
-	ecr->rc = rc;
-	complete(&ecr->completion);
-}
-
 /**
  * crypt_scatterlist
  * @crypt_stat: Pointer to the crypt_stat struct to initialize.
@@ -293,7 +277,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 			     unsigned char *iv, int op)
 {
 	struct skcipher_request *req = NULL;
-	struct extent_crypt_result ecr;
+	DECLARE_CRYPTO_WAIT(ecr);
 	int rc = 0;
 
 	if (unlikely(ecryptfs_verbosity > 0)) {
@@ -303,8 +287,6 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 				  crypt_stat->key_size);
 	}
 
-	init_completion(&ecr.completion);
-
 	mutex_lock(&crypt_stat->cs_tfm_mutex);
 	req = skcipher_request_alloc(crypt_stat->tfm, GFP_NOFS);
 	if (!req) {
@@ -315,7 +297,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 
 	skcipher_request_set_callback(req,
 			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
-			extent_crypt_complete, &ecr);
+			crypto_req_done, &ecr);
 	/* Consider doing this once, when the file is opened */
 	if (!(crypt_stat->flags & ECRYPTFS_KEY_SET)) {
 		rc = crypto_skcipher_setkey(crypt_stat->tfm, crypt_stat->key,
@@ -334,13 +316,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
 	skcipher_request_set_crypt(req, src_sg, dst_sg, size, iv);
 	rc = op == ENCRYPT ? crypto_skcipher_encrypt(req) :
 			     crypto_skcipher_decrypt(req);
-	if (rc == -EINPROGRESS || rc == -EBUSY) {
-		struct extent_crypt_result *ecr = req->base.data;
-
-		wait_for_completion(&ecr->completion);
-		rc = ecr->rc;
-		reinit_completion(&ecr->completion);
-	}
+	rc = crypto_wait_req(rc, &ecr);
 out:
 	skcipher_request_free(req);
 	return rc;
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

