Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A0D4C05027
	for <dm-devel@archiver.kernel.org>; Fri, 10 Feb 2023 07:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676012947;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=GhmUeZc/psT9hrGUHR6VYfWURVD4ozqtYm9BElVLPoA=;
	b=QnWQs20pzpQnWvh1dwXnd2ZZRnjuws5uA0xp4iEPO+io0LpGQHif+RpMpl8OvOWMl9nzb1
	gU+CJPGen1Xd2brwIZVZPRGX/Wofyjk1w86HD7ulaCVnb3g4OCR4wgHZ8dIuXsxkUfRPEV
	C+w4acHcAs//PCJU2+m6TcDIiThmB0k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-McfDRuY8MnCLgW51iTUvGg-1; Fri, 10 Feb 2023 02:09:06 -0500
X-MC-Unique: McfDRuY8MnCLgW51iTUvGg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5528F80D0E2;
	Fri, 10 Feb 2023 07:09:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0C5A8C16026;
	Fri, 10 Feb 2023 07:09:02 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 54B6719465B2;
	Fri, 10 Feb 2023 07:09:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE6181946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 10 Feb 2023 00:56:44 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id BE576492B00; Fri, 10 Feb 2023 00:56:44 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B6FD2492C3E
 for <dm-devel@redhat.com>; Fri, 10 Feb 2023 00:56:44 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 95454802314
 for <dm-devel@redhat.com>; Fri, 10 Feb 2023 00:56:44 +0000 (UTC)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-gC2gYVLgM9aiFAqDrfqXNw-1; Thu, 09 Feb 2023 19:56:40 -0500
X-MC-Unique: gC2gYVLgM9aiFAqDrfqXNw-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id D0499B822D1;
 Fri, 10 Feb 2023 00:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C5DC433D2;
 Fri, 10 Feb 2023 00:56:36 +0000 (UTC)
Date: Fri, 10 Feb 2023 02:56:34 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <Y+WWQgP/qTmLN42m@kernel.org>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOye6-007zks-J4@formenos.hmeau.com>
MIME-Version: 1.0
In-Reply-To: <E1pOye6-007zks-J4@formenos.hmeau.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mailman-Approved-At: Fri, 10 Feb 2023 07:09:00 +0000
Subject: Re: [dm-devel] [PATCH 17/17] crypto: api - Remove completion
 function scaffolding
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 06, 2023 at 06:22:46PM +0800, Herbert Xu wrote:
> This patch removes the temporary scaffolding now that the comletion
> function signature has been converted.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

For the 1-17:

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

(nit applies tho to all of them but use your own judgement i guess)

> ---
> 
>  include/linux/crypto.h |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 80f6350fb588..bb1d9b0e1647 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -176,7 +176,6 @@ struct crypto_async_request;
>  struct crypto_tfm;
>  struct crypto_type;
>  
> -typedef void crypto_completion_data_t;
>  typedef void (*crypto_completion_t)(void *req, int err);
>  
>  /**
> @@ -596,11 +595,6 @@ struct crypto_wait {
>  /*
>   * Async ops completion helper functioons
>   */
> -static inline void *crypto_get_completion_data(void *data)
> -{
> -	return data;
> -}
> -
>  void crypto_req_done(void *req, int err);
>  
>  static inline int crypto_wait_req(int err, struct crypto_wait *wait)

BR, Jarkko

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

