Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E68C05027
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 10:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675679005;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=3lHkR5/1cF51jPD/+iut1VrU9CipO8/zroN4cdSXlsc=;
	b=DYKz/Ei6AlukZj2o8IgLyalKTq7cU+7Lv3b5Pchd8y9EwAGs9EgxHaZGEF6FjU1a2BdhOS
	IWX+KI/kXMGF4zz1RcXiw34iQLOPO2E2Rx70UZX8equ2AngWxVP609WE3fSjopJmcTWE81
	eIhq7qlwZNod0w8GPdaj/JCA6avNczY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-644-BUCZJc9NOdqqTTXB-RK2Jw-1; Mon, 06 Feb 2023 05:23:21 -0500
X-MC-Unique: BUCZJc9NOdqqTTXB-RK2Jw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E4D173810B06;
	Mon,  6 Feb 2023 10:23:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D33A4140EBF6;
	Mon,  6 Feb 2023 10:23:19 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id C492B19465A0;
	Mon,  6 Feb 2023 10:23:19 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id A02C01946589
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 10:23:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 82D0A14171BE; Mon,  6 Feb 2023 10:23:18 +0000 (UTC)
Received: from formenos.hmeau.com (unknown [10.67.24.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2437914171B6;
 Mon,  6 Feb 2023 10:23:18 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1pOye2-007zkJ-CU; Mon, 06 Feb 2023 18:22:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Mon, 06 Feb 2023 18:22:42 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Mon, 06 Feb 2023 18:22:42 +0800
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
Message-Id: <E1pOye2-007zkJ-CU@formenos.hmeau.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 15/17] tipc: Remove completion function
 scaffolding
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch removes the temporary scaffolding now that the comletion
function signature has been converted.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/tipc/crypto.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index ab356e7a3870..577fa5af33ec 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -267,10 +267,10 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 			     struct tipc_bearer *b,
 			     struct tipc_media_addr *dst,
 			     struct tipc_node *__dnode);
-static void tipc_aead_encrypt_done(crypto_completion_data_t *data, int err);
+static void tipc_aead_encrypt_done(void *data, int err);
 static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 			     struct sk_buff *skb, struct tipc_bearer *b);
-static void tipc_aead_decrypt_done(crypto_completion_data_t *data, int err);
+static void tipc_aead_decrypt_done(void *data, int err);
 static inline int tipc_ehdr_size(struct tipc_ehdr *ehdr);
 static int tipc_ehdr_build(struct net *net, struct tipc_aead *aead,
 			   u8 tx_key, struct sk_buff *skb,
@@ -830,9 +830,9 @@ static int tipc_aead_encrypt(struct tipc_aead *aead, struct sk_buff *skb,
 	return rc;
 }
 
-static void tipc_aead_encrypt_done(crypto_completion_data_t *data, int err)
+static void tipc_aead_encrypt_done(void *data, int err)
 {
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 	struct tipc_crypto_tx_ctx *tx_ctx = TIPC_SKB_CB(skb)->crypto_ctx;
 	struct tipc_bearer *b = tx_ctx->bearer;
 	struct tipc_aead *aead = tx_ctx->aead;
@@ -954,9 +954,9 @@ static int tipc_aead_decrypt(struct net *net, struct tipc_aead *aead,
 	return rc;
 }
 
-static void tipc_aead_decrypt_done(crypto_completion_data_t *data, int err)
+static void tipc_aead_decrypt_done(void *data, int err)
 {
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 	struct tipc_crypto_rx_ctx *rx_ctx = TIPC_SKB_CB(skb)->crypto_ctx;
 	struct tipc_bearer *b = rx_ctx->bearer;
 	struct tipc_aead *aead = rx_ctx->aead;
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

