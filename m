Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 736F8C05027
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 10:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675678999;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=cEbjoFwJgjwXsZkAWkj5ipuykUQUIKx1xTV1paJ6R9M=;
	b=VdmRt7u0R6dSEnwqCzwP8R374qCY3NcQtg8Qdk7eKB5eFh+r/HAWj3Su9c9dZgaaG0hw2l
	kqWkWH1SGXHyoY4LONtufqBHVYEAfT4XYD7yjeWaWMsRqVwb90/UVzWTnPi4ro4cNXw+Rg
	m8C/SnaKQAWBB7BDJaqVYtEkYLJ41bE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-n4Yy7L6LMqGA0djhPiTE4w-1; Mon, 06 Feb 2023 05:23:18 -0500
X-MC-Unique: n4Yy7L6LMqGA0djhPiTE4w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C805229AB3ED;
	Mon,  6 Feb 2023 10:23:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id B8B872166B29;
	Mon,  6 Feb 2023 10:23:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 85FDD194658C;
	Mon,  6 Feb 2023 10:23:15 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 7DD411946594
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 10:23:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6EE332166B2B; Mon,  6 Feb 2023 10:23:14 +0000 (UTC)
Received: from formenos.hmeau.com (unknown [10.67.24.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F17F32166B29;
 Mon,  6 Feb 2023 10:23:13 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1pOye0-007zk1-9e; Mon, 06 Feb 2023 18:22:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Mon, 06 Feb 2023 18:22:40 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Mon, 06 Feb 2023 18:22:40 +0800
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
Message-Id: <E1pOye0-007zk1-9e@formenos.hmeau.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH 14/17] net: ipv6: Remove completion function
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

This patch removes the temporary scaffolding now that the comletion
function signature has been converted.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 net/ipv6/ah6.c  |    8 ++++----
 net/ipv6/esp6.c |   16 ++++++++--------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/ah6.c b/net/ipv6/ah6.c
index e43735578a76..01005035ad10 100644
--- a/net/ipv6/ah6.c
+++ b/net/ipv6/ah6.c
@@ -281,12 +281,12 @@ static int ipv6_clear_mutable_options(struct ipv6hdr *iph, int len, int dir)
 	return 0;
 }
 
-static void ah6_output_done(crypto_completion_data_t *data, int err)
+static void ah6_output_done(void *data, int err)
 {
 	int extlen;
 	u8 *iph_base;
 	u8 *icv;
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 	struct xfrm_state *x = skb_dst(skb)->xfrm;
 	struct ah_data *ahp = x->data;
 	struct ipv6hdr *top_iph = ipv6_hdr(skb);
@@ -451,12 +451,12 @@ static int ah6_output(struct xfrm_state *x, struct sk_buff *skb)
 	return err;
 }
 
-static void ah6_input_done(crypto_completion_data_t *data, int err)
+static void ah6_input_done(void *data, int err)
 {
 	u8 *auth_data;
 	u8 *icv;
 	u8 *work_iph;
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 	struct xfrm_state *x = xfrm_input_state(skb);
 	struct ah_data *ahp = x->data;
 	struct ip_auth_hdr *ah = ip_auth_hdr(skb);
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index b9ee81c7dfcf..fddd0cbdede1 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -278,9 +278,9 @@ static void esp_output_encap_csum(struct sk_buff *skb)
 	}
 }
 
-static void esp_output_done(crypto_completion_data_t *data, int err)
+static void esp_output_done(void *data, int err)
 {
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	void *tmp;
 	struct xfrm_state *x;
@@ -368,9 +368,9 @@ static struct ip_esp_hdr *esp_output_set_esn(struct sk_buff *skb,
 	return esph;
 }
 
-static void esp_output_done_esn(crypto_completion_data_t *data, int err)
+static void esp_output_done_esn(void *data, int err)
 {
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 
 	esp_output_restore_header(skb);
 	esp_output_done(data, err);
@@ -879,9 +879,9 @@ int esp6_input_done2(struct sk_buff *skb, int err)
 }
 EXPORT_SYMBOL_GPL(esp6_input_done2);
 
-static void esp_input_done(crypto_completion_data_t *data, int err)
+static void esp_input_done(void *data, int err)
 {
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 
 	xfrm_input_resume(skb, esp6_input_done2(skb, err));
 }
@@ -909,9 +909,9 @@ static void esp_input_set_header(struct sk_buff *skb, __be32 *seqhi)
 	}
 }
 
-static void esp_input_done_esn(crypto_completion_data_t *data, int err)
+static void esp_input_done_esn(void *data, int err)
 {
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 
 	esp_input_restore_header(skb);
 	esp_input_done(data, err);
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

