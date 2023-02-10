Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACD9BC636D6
	for <dm-devel@archiver.kernel.org>; Fri, 10 Feb 2023 07:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1676012949;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=S+V6y5QUE78kJs7nbvLsoV5vd7d2Wndb7IJwv67ePgo=;
	b=KId9eCXVdtxZRTdel6KhlS6IWH1lODStDFxYEZRHninU7mdFBDE5z9tfDAkLo4eI63xhV6
	j23SgH6G4tsnNb5wMegaauhWdOwntRLuhSvV9ffpoKh9fsl/IQvdzW4Jp92ni+EqrG9uDD
	ngr5lzYQRocsGT9TKowAbPGTnWGDOFE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-271-7GQxfCTuNCCqHbJrroAKoQ-1; Fri, 10 Feb 2023 02:09:06 -0500
X-MC-Unique: 7GQxfCTuNCCqHbJrroAKoQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 553F91024D07;
	Fri, 10 Feb 2023 07:09:04 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 6387F492C3F;
	Fri, 10 Feb 2023 07:09:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 2350D1946594;
	Fri, 10 Feb 2023 07:09:01 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 9E1601946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 10 Feb 2023 00:52:24 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 7C069492B00; Fri, 10 Feb 2023 00:52:24 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 73F60492C3F
 for <dm-devel@redhat.com>; Fri, 10 Feb 2023 00:52:24 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 570EB2807D69
 for <dm-devel@redhat.com>; Fri, 10 Feb 2023 00:52:24 +0000 (UTC)
Received: from dfw.source.kernel.org (dfw.source.kernel.org
 [139.178.84.217]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-_joC7pOqOHiLBBS6SIaeqQ-1; Thu, 09 Feb 2023 19:52:15 -0500
X-MC-Unique: _joC7pOqOHiLBBS6SIaeqQ-1
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 2D36661C3D;
 Fri, 10 Feb 2023 00:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFAFC433D2;
 Fri, 10 Feb 2023 00:42:57 +0000 (UTC)
Date: Fri, 10 Feb 2023 02:42:55 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Message-ID: <Y+WTD3TrxaJOPdRg@kernel.org>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOydd-007zgo-4c@formenos.hmeau.com>
MIME-Version: 1.0
In-Reply-To: <E1pOydd-007zgo-4c@formenos.hmeau.com>
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mailman-Approved-At: Fri, 10 Feb 2023 07:09:00 +0000
Subject: Re: [dm-devel] [PATCH 3/17] fs: ecryptfs: Use crypto_wait_req
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Mon, Feb 06, 2023 at 06:22:17PM +0800, Herbert Xu wrote:
> This patch replaces the custom crypto completion function with
> crypto_req_done.

nit: "Replace the custom crypto ..."

> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  fs/ecryptfs/crypto.c |   30 +++---------------------------
>  1 file changed, 3 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
> index e3f5d7f3c8a0..c3057539f088 100644
> --- a/fs/ecryptfs/crypto.c
> +++ b/fs/ecryptfs/crypto.c
> @@ -260,22 +260,6 @@ int virt_to_scatterlist(const void *addr, int size, struct scatterlist *sg,
>  	return i;
>  }
>  
> -struct extent_crypt_result {
> -	struct completion completion;
> -	int rc;
> -};
> -
> -static void extent_crypt_complete(struct crypto_async_request *req, int rc)
> -{
> -	struct extent_crypt_result *ecr = req->data;
> -
> -	if (rc == -EINPROGRESS)
> -		return;
> -
> -	ecr->rc = rc;
> -	complete(&ecr->completion);
> -}
> -
>  /**
>   * crypt_scatterlist
>   * @crypt_stat: Pointer to the crypt_stat struct to initialize.
> @@ -293,7 +277,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
>  			     unsigned char *iv, int op)
>  {
>  	struct skcipher_request *req = NULL;
> -	struct extent_crypt_result ecr;
> +	DECLARE_CRYPTO_WAIT(ecr);
>  	int rc = 0;
>  
>  	if (unlikely(ecryptfs_verbosity > 0)) {
> @@ -303,8 +287,6 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
>  				  crypt_stat->key_size);
>  	}
>  
> -	init_completion(&ecr.completion);
> -
>  	mutex_lock(&crypt_stat->cs_tfm_mutex);
>  	req = skcipher_request_alloc(crypt_stat->tfm, GFP_NOFS);
>  	if (!req) {
> @@ -315,7 +297,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
>  
>  	skcipher_request_set_callback(req,
>  			CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
> -			extent_crypt_complete, &ecr);
> +			crypto_req_done, &ecr);
>  	/* Consider doing this once, when the file is opened */
>  	if (!(crypt_stat->flags & ECRYPTFS_KEY_SET)) {
>  		rc = crypto_skcipher_setkey(crypt_stat->tfm, crypt_stat->key,
> @@ -334,13 +316,7 @@ static int crypt_scatterlist(struct ecryptfs_crypt_stat *crypt_stat,
>  	skcipher_request_set_crypt(req, src_sg, dst_sg, size, iv);
>  	rc = op == ENCRYPT ? crypto_skcipher_encrypt(req) :
>  			     crypto_skcipher_decrypt(req);
> -	if (rc == -EINPROGRESS || rc == -EBUSY) {
> -		struct extent_crypt_result *ecr = req->base.data;
> -
> -		wait_for_completion(&ecr->completion);
> -		rc = ecr->rc;
> -		reinit_completion(&ecr->completion);
> -	}
> +	rc = crypto_wait_req(rc, &ecr);
>  out:
>  	skcipher_request_free(req);
>  	return rc;


Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

