Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D85AC6379F
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 10:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675678984;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=kS8aZBV7Z+8Rto2UJMm1WufJRMTiZwFbouVdRUNlAU4=;
	b=jCxVfKqcZWDKyT4e0qdD6pm2B7hykB1gN5nxuSthXKnpGB+pBEsKT3pXvZVHfQKYiVRwvf
	3OjR9364ChJWsnnk+HU9gFz74x0+PLpY6+BTNBUDYMv0CZ/Ik5OsFSPP4rIdWEmYWKAjRD
	8KQPmfZWN7Hqbqp06tuAlxg/AqCbHvo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-600-0kZwJ_IhNciisxDbIqyjUA-1; Mon, 06 Feb 2023 05:23:03 -0500
X-MC-Unique: 0kZwJ_IhNciisxDbIqyjUA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7BA8A3810B00;
	Mon,  6 Feb 2023 10:23:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 660BF2026D37;
	Mon,  6 Feb 2023 10:23:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 39744194658D;
	Mon,  6 Feb 2023 10:23:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id E7D1F1946589
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 10:22:59 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BBDD21415127; Mon,  6 Feb 2023 10:22:59 +0000 (UTC)
Received: from formenos.hmeau.com (unknown [10.67.24.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 0EC3C140EBF6;
 Mon,  6 Feb 2023 10:22:59 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1pOydh-007zhJ-B3; Mon, 06 Feb 2023 18:22:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Mon, 06 Feb 2023 18:22:21 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Mon, 06 Feb 2023 18:22:21 +0800
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
Message-Id: <E1pOydh-007zhJ-B3@formenos.hmeau.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH 5/17] net: ipv4: Add scaffolding to change
 completion function signature
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

This patch adds temporary scaffolding so that the Crypto API
completion function can take a void * instead of crypto_async_request.
Once affected users have been converted this can be removed.
    
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/ipv4/ah4.c  |    8 ++++----
 net/ipv4/esp4.c |   20 ++++++++++----------
 2 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/ah4.c b/net/ipv4/ah4.c
index ee4e578c7f20..1fc0231eb1ee 100644
--- a/net/ipv4/ah4.c
+++ b/net/ipv4/ah4.c
@@ -117,11 +117,11 @@ static int ip_clear_mutable_options(const struct iphdr *iph, __be32 *daddr)
 	return 0;
 }
 
-static void ah_output_done(struct crypto_async_request *base, int err)
+static void ah_output_done(crypto_completion_data_t *data, int err)
 {
 	u8 *icv;
 	struct iphdr *iph;
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct xfrm_state *x = skb_dst(skb)->xfrm;
 	struct ah_data *ahp = x->data;
 	struct iphdr *top_iph = ip_hdr(skb);
@@ -262,12 +262,12 @@ static int ah_output(struct xfrm_state *x, struct sk_buff *skb)
 	return err;
 }
 
-static void ah_input_done(struct crypto_async_request *base, int err)
+static void ah_input_done(crypto_completion_data_t *data, int err)
 {
 	u8 *auth_data;
 	u8 *icv;
 	struct iphdr *work_iph;
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct xfrm_state *x = xfrm_input_state(skb);
 	struct ah_data *ahp = x->data;
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 52c8047efedb..8abe07c1ff28 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -244,9 +244,9 @@ static int esp_output_tail_tcp(struct xfrm_state *x, struct sk_buff *skb)
 }
 #endif
 
-static void esp_output_done(struct crypto_async_request *base, int err)
+static void esp_output_done(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	void *tmp;
 	struct xfrm_state *x;
@@ -332,12 +332,12 @@ static struct ip_esp_hdr *esp_output_set_extra(struct sk_buff *skb,
 	return esph;
 }
 
-static void esp_output_done_esn(struct crypto_async_request *base, int err)
+static void esp_output_done_esn(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 
 	esp_output_restore_header(skb);
-	esp_output_done(base, err);
+	esp_output_done(data, err);
 }
 
 static struct ip_esp_hdr *esp_output_udp_encap(struct sk_buff *skb,
@@ -830,9 +830,9 @@ int esp_input_done2(struct sk_buff *skb, int err)
 }
 EXPORT_SYMBOL_GPL(esp_input_done2);
 
-static void esp_input_done(struct crypto_async_request *base, int err)
+static void esp_input_done(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 
 	xfrm_input_resume(skb, esp_input_done2(skb, err));
 }
@@ -860,12 +860,12 @@ static void esp_input_set_header(struct sk_buff *skb, __be32 *seqhi)
 	}
 }
 
-static void esp_input_done_esn(struct crypto_async_request *base, int err)
+static void esp_input_done_esn(crypto_completion_data_t *data, int err)
 {
-	struct sk_buff *skb = base->data;
+	struct sk_buff *skb = crypto_get_completion_data(data);
 
 	esp_input_restore_header(skb);
-	esp_input_done(base, err);
+	esp_input_done(data, err);
 }
 
 /*
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

