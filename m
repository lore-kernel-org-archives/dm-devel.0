Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68FC2C636D3
	for <dm-devel@archiver.kernel.org>; Fri, 10 Feb 2023 07:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676012949;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=W3A2ueBeLa0rf1xC/3YAQvwtqSpM8l32K3znMF7rl58=;
	b=aXnq9AyyQhJT63zYzM2qUpC2JEmAgwo0/T4WJv6jQXxO3i60sbFYhRYyBd8BmUbbArOExz
	ysw32wLhro4oX86CoT0spGCL5wrBtO6hqaR8EuFhI1s0c0r1z/FfRSt23OUVDzMAH2DDGe
	3hGGRkKBmheR16aW/Is3GS1dTQsbE0I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-444-juPBQQKzOYe0cZ6LhE8hMA-1; Fri, 10 Feb 2023 02:09:05 -0500
X-MC-Unique: juPBQQKzOYe0cZ6LhE8hMA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54CB180D0E0;
	Fri, 10 Feb 2023 07:09:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9ADC540398A2;
	Fri, 10 Feb 2023 07:09:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 872581946597;
	Fri, 10 Feb 2023 07:09:02 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 6B7651946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 10 Feb 2023 00:53:43 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 0720918EC5; Fri, 10 Feb 2023 00:53:43 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id F2EAF18EC1
 for <dm-devel@redhat.com>; Fri, 10 Feb 2023 00:53:42 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D156A38060FE
 for <dm-devel@redhat.com>; Fri, 10 Feb 2023 00:53:42 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-82-4AjlbMMmMHCbKKrkUTcrjw-1; Thu, 09 Feb 2023 19:53:38 -0500
X-MC-Unique: 4AjlbMMmMHCbKKrkUTcrjw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 4DEB1B82396;
 Fri, 10 Feb 2023 00:44:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1B0C433EF;
 Fri, 10 Feb 2023 00:43:58 +0000 (UTC)
Date: Fri, 10 Feb 2023 02:43:55 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <Y+WTS5w9nbsoyZyr@kernel.org>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOydb-007zgc-0p@formenos.hmeau.com>
MIME-Version: 1.0
In-Reply-To: <E1pOydb-007zgc-0p@formenos.hmeau.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mailman-Approved-At: Fri, 10 Feb 2023 07:09:00 +0000
Subject: Re: [dm-devel] [PATCH 2/17] net: macsec: Add scaffolding to change
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
Cc: David Howells <dhowells@redhat.com>, dm-devel@redhat.com,
 keyrings@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Boris Pismenny <borisp@nvidia.com>, John Fastabend <john.fastabend@gmail.com>,
 Tyler Hicks <code@tyhicks.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Johan Hedberg <johan.hedberg@gmail.com>,
 Marcel Holtmann <marcel@holtmann.org>, ecryptfs@vger.kernel.org,
 Mike Snitzer <snitzer@kernel.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Jon Maloy <jmaloy@redhat.com>,
 linux-bluetooth@vger.kernel.org,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Ying Xue <ying.xue@windriver.com>, "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 06, 2023 at 06:22:15PM +0800, Herbert Xu wrote:
> This patch adds temporary scaffolding so that the Crypto API

nit: "Add ..."

> completion function can take a void * instead of crypto_async_request.
> Once affected users have been converted this can be removed.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  drivers/net/macsec.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index bf8ac7a3ded7..b7d9d487ccd2 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -528,9 +528,9 @@ static void count_tx(struct net_device *dev, int ret, int len)
>  	}
>  }
>  
> -static void macsec_encrypt_done(struct crypto_async_request *base, int err)
> +static void macsec_encrypt_done(crypto_completion_data_t *data, int err)
>  {
> -	struct sk_buff *skb = base->data;
> +	struct sk_buff *skb = crypto_get_completion_data(data);
>  	struct net_device *dev = skb->dev;
>  	struct macsec_dev *macsec = macsec_priv(dev);
>  	struct macsec_tx_sa *sa = macsec_skb_cb(skb)->tx_sa;
> @@ -835,9 +835,9 @@ static void count_rx(struct net_device *dev, int len)
>  	u64_stats_update_end(&stats->syncp);
>  }
>  
> -static void macsec_decrypt_done(struct crypto_async_request *base, int err)
> +static void macsec_decrypt_done(crypto_completion_data_t *data, int err)
>  {
> -	struct sk_buff *skb = base->data;
> +	struct sk_buff *skb = crypto_get_completion_data(data);
>  	struct net_device *dev = skb->dev;
>  	struct macsec_dev *macsec = macsec_priv(dev);
>  	struct macsec_rx_sa *rx_sa = macsec_skb_cb(skb)->rx_sa;

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

