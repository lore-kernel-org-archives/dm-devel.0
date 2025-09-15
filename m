Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628BC341661
	for <dm-devel@lists.linux.dev>; Mon, 15 Sep 2025 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757948826; cv=none; b=ZZBdd6d5wO2bdlDeYmlIOnW65pvKNxWbW7+EOYBFD9xJvAhjQ7TO8jc9uAZc6YaXhnmmqpuCYMjkb7hpgo6ZX0FknX9Pnl+/sdF3VmMVLuJh09aPTLers5/vPL+B15FuLM5BaoXdZoE026kx1IYzvHjPEzfqfEmIsIznujr9srA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757948826; c=relaxed/simple;
	bh=kvUGKctGtLYjY9XMJNeZKVXbWPPgK2fUvUR6RhO5KeM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=Ay7b+jKdaGOUZJ6tJq8VHkQYPklFvnebfjD24MwH+rbQMZPb1Bv81cRDppWhkXyS4YCb6HCx22E/gsw2epoNMVK7nYBbYHCb9VMhc2bhPWoNMddV4YM7aGzc4qZdBwF/fQUwBV5jra4NHJ5AWOAQ22fxcexbxvxchiPsgX6up9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gw2iaTBp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gw2iaTBp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757948823;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l1G5ZFpGDVqxSTUfZeOxzFFZ03jobsF1A2PQq6aEw1Q=;
	b=gw2iaTBpud7gzQRi0EA11JUrN9FefNC3gUBCpux635BnLP0PouLz6+KnHWPINgyiIgdDj9
	4DbVQePmMo5KMRGXUWbfQnJyVaOBa7BS4/GO+mTf5IA2es3PXtAMXBWjWqjQULTRosM2/o
	ljmn2QhQbyNk2WUzgKtCrYicIk9Yvzc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-397-6UIl3k_jOJSkELByYPt6fQ-1; Mon,
 15 Sep 2025 11:06:58 -0400
X-MC-Unique: 6UIl3k_jOJSkELByYPt6fQ-1
X-Mimecast-MFC-AGG-ID: 6UIl3k_jOJSkELByYPt6fQ_1757948818
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF7941955E9A;
	Mon, 15 Sep 2025 15:06:57 +0000 (UTC)
Received: from [10.45.225.219] (unknown [10.45.225.219])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E33919560A2;
	Mon, 15 Sep 2025 15:06:56 +0000 (UTC)
Date: Mon, 15 Sep 2025 17:06:51 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
    dm-devel@lists.linux.dev
Subject: Re: [v2 PATCH 1/2] crypto: ahash - Allow async stack requests when
 specified
In-Reply-To: <9d6b10c1405137ab1d09471897536f830649364f.1757396389.git.herbert@gondor.apana.org.au>
Message-ID: <f1b90764-b2f4-ff90-f4c4-a3ddc04a15f6@redhat.com>
References: <cover.1757396389.git.herbert@gondor.apana.org.au> <9d6b10c1405137ab1d09471897536f830649364f.1757396389.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Hi

Would it be possible to export the function crypto_ahash_stack_req_ok, so 
that I could know up-front whether having a request on the stack will 
succeed or not?

Perhaps the function crypto_ahash_stack_req_ok could take "struct 
crypto_ahash *" argument rather than "struct ahash_request, *" so that I 
would know in advance whether it makes sense to try to build the request 
on the stack or not.

Mikulas


On Tue, 9 Sep 2025, Herbert Xu wrote:

> As it stands stack requests are forbidden for async algorithms
> because of the inability to perform DMA on stack memory.
> 
> However, some async algorithms do not perform DMA and are able
> to handle stack requests.  Allow such uses by addnig a new type
> bit CRYPTO_AHASH_ALG_STACK_REQ.  When it is set on the algorithm
> stack requests will be allowed even if the algorithm is asynchronous.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/ahash.c                 | 22 ++++++++++++++++++----
>  include/crypto/internal/hash.h |  3 +++
>  2 files changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/crypto/ahash.c b/crypto/ahash.c
> index a227793d2c5b..33b2a19169f1 100644
> --- a/crypto/ahash.c
> +++ b/crypto/ahash.c
> @@ -49,6 +49,20 @@ static inline bool crypto_ahash_need_fallback(struct crypto_ahash *tfm)
>  	       CRYPTO_ALG_NEED_FALLBACK;
>  }
>  
> +static inline bool crypto_ahash_stack_req_ok(struct ahash_request *req)
> +{
> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> +
> +	if (!ahash_req_on_stack(req))
> +		return true;
> +
> +	if (!ahash_is_async(tfm))
> +		return true;
> +
> +	return crypto_ahash_alg(tfm)->halg.base.cra_flags &
> +	       CRYPTO_AHASH_ALG_STACK_REQ;
> +}
> +
>  static inline void ahash_op_done(void *data, int err,
>  				 int (*finish)(struct ahash_request *, int))
>  {
> @@ -376,7 +390,7 @@ int crypto_ahash_init(struct ahash_request *req)
>  		return crypto_shash_init(prepare_shash_desc(req, tfm));
>  	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
>  		return -ENOKEY;
> -	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
> +	if (!crypto_ahash_stack_req_ok(req))
>  		return -EAGAIN;
>  	if (crypto_ahash_block_only(tfm)) {
>  		u8 *buf = ahash_request_ctx(req);
> @@ -451,7 +465,7 @@ int crypto_ahash_update(struct ahash_request *req)
>  
>  	if (likely(tfm->using_shash))
>  		return shash_ahash_update(req, ahash_request_ctx(req));
> -	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
> +	if (!crypto_ahash_stack_req_ok(req))
>  		return -EAGAIN;
>  	if (!crypto_ahash_block_only(tfm))
>  		return ahash_do_req_chain(req, &crypto_ahash_alg(tfm)->update);
> @@ -531,7 +545,7 @@ int crypto_ahash_finup(struct ahash_request *req)
>  
>  	if (likely(tfm->using_shash))
>  		return shash_ahash_finup(req, ahash_request_ctx(req));
> -	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
> +	if (!crypto_ahash_stack_req_ok(req))
>  		return -EAGAIN;
>  	if (!crypto_ahash_alg(tfm)->finup)
>  		return ahash_def_finup(req);
> @@ -569,7 +583,7 @@ int crypto_ahash_digest(struct ahash_request *req)
>  
>  	if (likely(tfm->using_shash))
>  		return shash_ahash_digest(req, prepare_shash_desc(req, tfm));
> -	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
> +	if (!crypto_ahash_stack_req_ok(req))
>  		return -EAGAIN;
>  	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
>  		return -ENOKEY;
> diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
> index 6ec5f2f37ccb..79899d36032b 100644
> --- a/include/crypto/internal/hash.h
> +++ b/include/crypto/internal/hash.h
> @@ -23,6 +23,9 @@
>  /* This bit is set by the Crypto API if export_core is not supported. */
>  #define CRYPTO_AHASH_ALG_NO_EXPORT_CORE	0x08000000
>  
> +/* This bit is set by the Crypto API if stack requests are supported. */
> +#define CRYPTO_AHASH_ALG_STACK_REQ	0x10000000
> +
>  #define HASH_FBREQ_ON_STACK(name, req) \
>          char __##name##_req[sizeof(struct ahash_request) + \
>                              MAX_SYNC_HASH_REQSIZE] CRYPTO_MINALIGN_ATTR; \
> -- 
> 2.39.5
> 

