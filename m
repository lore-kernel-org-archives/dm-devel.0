Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B79AC636CD
	for <dm-devel@archiver.kernel.org>; Tue,  7 Feb 2023 07:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1675756574;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yK2eGF2SdQx1pErMTdYLahUaaTlilAFb9d0nZ5BBWIE=;
	b=TnsDbj1iq1Ji9RqcnucoEvT+uYDaWMuALvY6dkh08zr6CjcQ5c/gTHDALwuKOavsZf7dwZ
	Ml44sCflA4O3UJcoLQsUBkmKXDIxqIr3JWO8RI5QBvpgSURutwt/IIiuCGdariFIt1toOP
	hhIxB1r7gCoGNrfnuuGlptLakPgSrxE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-BpvLTak5ObqNJIXryh2J6A-1; Tue, 07 Feb 2023 02:56:10 -0500
X-MC-Unique: BpvLTak5ObqNJIXryh2J6A-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0A6238123B5;
	Tue,  7 Feb 2023 07:56:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 9CFD1492B21;
	Tue,  7 Feb 2023 07:56:07 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 341DB1946A42;
	Tue,  7 Feb 2023 07:56:06 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 21D0E1946589
 for <dm-devel@listman.corp.redhat.com>; Tue,  7 Feb 2023 07:15:30 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 3B5CC2166B2A; Tue,  7 Feb 2023 07:15:30 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast07.extmail.prod.ext.rdu2.redhat.com [10.11.55.23])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 22B7D2166B29
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 07:15:30 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0445B3C02529
 for <dm-devel@redhat.com>; Tue,  7 Feb 2023 07:15:30 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-Fddkx7wxP4-LO8IkbAtNfg-1; Tue, 07 Feb 2023 02:15:26 -0500
X-MC-Unique: Fddkx7wxP4-LO8IkbAtNfg-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 88325B815FB;
 Tue,  7 Feb 2023 07:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A01EC4339B;
 Tue,  7 Feb 2023 07:15:22 +0000 (UTC)
Date: Mon, 6 Feb 2023 23:15:21 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Message-ID: <20230206231521.712f53e5@kernel.org>
In-Reply-To: <E1pOydn-007zi3-LG@formenos.hmeau.com>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOydn-007zi3-LG@formenos.hmeau.com>
MIME-Version: 1.0
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Mailman-Approved-At: Tue, 07 Feb 2023 07:56:04 +0000
Subject: Re: [dm-devel] [PATCH 8/17] tls: Only use data field in crypto
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
Cc: David Howells <dhowells@redhat.com>, dm-devel@redhat.com,
 keyrings@vger.kernel.org, Alasdair Kergon <agk@redhat.com>,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Boris Pismenny <borisp@nvidia.com>, John Fastabend <john.fastabend@gmail.com>,
 Tyler Hicks <code@tyhicks.com>, Paolo Abeni <pabeni@redhat.com>,
 Johan Hedberg <johan.hedberg@gmail.com>, Marcel Holtmann <marcel@holtmann.org>,
 ecryptfs@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>, netdev@vger.kernel.org,
 Eric Dumazet <edumazet@google.com>, Jon Maloy <jmaloy@redhat.com>,
 linux-bluetooth@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Ying Xue <ying.xue@windriver.com>, "David S. Miller" <davem@davemloft.net>
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, 06 Feb 2023 18:22:27 +0800 Herbert Xu wrote:
> -static void tls_encrypt_done(struct crypto_async_request *req, int err)
> +static void tls_encrypt_done(crypto_completion_data_t *data, int err)
>  {
> -	struct aead_request *aead_req = (struct aead_request *)req;
> -	struct sock *sk = req->data;
> -	struct tls_context *tls_ctx = tls_get_ctx(sk);
> -	struct tls_prot_info *prot = &tls_ctx->prot_info;
> -	struct tls_sw_context_tx *ctx = tls_sw_ctx_tx(tls_ctx);
> +	struct aead_request *aead_req = crypto_get_completion_data(data);

All we use aead_req for in this function now is to find rec...

> +	struct tls_sw_context_tx *ctx;
> +	struct tls_context *tls_ctx;
> +	struct tls_prot_info *prot;
>  	struct scatterlist *sge;
>  	struct sk_msg *msg_en;
>  	struct tls_rec *rec;
>  	bool ready = false;
> +	struct sock *sk;
>  	int pending;
>  
>  	rec = container_of(aead_req, struct tls_rec, aead_req);
>  	msg_en = &rec->msg_encrypted;
>  
> +	sk = rec->sk;
> +	tls_ctx = tls_get_ctx(sk);
> +	prot = &tls_ctx->prot_info;
> +	ctx = tls_sw_ctx_tx(tls_ctx);
> +
>  	sge = sk_msg_elem(msg_en, msg_en->sg.curr);
>  	sge->offset -= prot->prepend_size;
>  	sge->length += prot->prepend_size;
> @@ -520,7 +536,7 @@ static int tls_do_encryption(struct sock *sk,
>  			       data_len, rec->iv_data);
>  
>  	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> -				  tls_encrypt_done, sk);
> +				  tls_encrypt_done, aead_req);

... let's just pass rec instead of aead_req here, then?

>  	/* Add the record in tx_list */
>  	list_add_tail((struct list_head *)&rec->list, &ctx->tx_list);

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

