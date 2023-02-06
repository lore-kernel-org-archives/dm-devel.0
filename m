Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C48BC636D6
	for <dm-devel@archiver.kernel.org>; Mon,  6 Feb 2023 10:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675678997;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 references:references:list-id:list-help:list-unsubscribe:
	 list-subscribe:list-post; bh=8zgigmyjBHbVl4BI43uFKxTtKHmgwUsOF8XZxYe6+k0=;
	b=CXKWEOvYRVnnlcnQgtkArYgVRHHYq/Ms01ZfEWtWUIZIuxZiSx40DTsZ8IHAgbOqJAZbnd
	1ynmSB9TLJ0ns4cEL7QbT9/bPA82BtyBerAnsYt+9V4lsyh6T0283PdgtOxqoI9+YK56ci
	bG9nk4Nty/bZo1R3IWAdsP14XA54Uq4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-M-e9gaxfN3ePyCOGSBL5rg-1; Mon, 06 Feb 2023 05:23:15 -0500
X-MC-Unique: M-e9gaxfN3ePyCOGSBL5rg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 75CEE1C29D57;
	Mon,  6 Feb 2023 10:23:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5BFDB14171BB;
	Mon,  6 Feb 2023 10:23:12 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 3DD1F19465A8;
	Mon,  6 Feb 2023 10:23:12 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6397C194658C
 for <dm-devel@listman.corp.redhat.com>; Mon,  6 Feb 2023 10:23:11 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4681A2027001; Mon,  6 Feb 2023 10:23:11 +0000 (UTC)
Received: from formenos.hmeau.com (unknown [10.67.24.12])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DCB142026D37;
 Mon,  6 Feb 2023 10:23:10 +0000 (UTC)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
 by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
 id 1pOydw-007zjD-3q; Mon, 06 Feb 2023 18:22:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation);
 Mon, 06 Feb 2023 18:22:36 +0800
From: "Herbert Xu" <herbert@gondor.apana.org.au>
Date: Mon, 06 Feb 2023 18:22:36 +0800
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
Message-Id: <E1pOydw-007zjD-3q@formenos.hmeau.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Subject: [dm-devel] [PATCH 12/17] net: macsec: Remove completion function
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

 drivers/net/macsec.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index b7d9d487ccd2..becb04123d3e 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -528,9 +528,9 @@ static void count_tx(struct net_device *dev, int ret, int len)
 	}
 }
 
-static void macsec_encrypt_done(crypto_completion_data_t *data, int err)
+static void macsec_encrypt_done(void *data, int err)
 {
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 	struct net_device *dev = skb->dev;
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct macsec_tx_sa *sa = macsec_skb_cb(skb)->tx_sa;
@@ -835,9 +835,9 @@ static void count_rx(struct net_device *dev, int len)
 	u64_stats_update_end(&stats->syncp);
 }
 
-static void macsec_decrypt_done(crypto_completion_data_t *data, int err)
+static void macsec_decrypt_done(void *data, int err)
 {
-	struct sk_buff *skb = crypto_get_completion_data(data);
+	struct sk_buff *skb = data;
 	struct net_device *dev = skb->dev;
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct macsec_rx_sa *rx_sa = macsec_skb_cb(skb)->rx_sa;
--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

