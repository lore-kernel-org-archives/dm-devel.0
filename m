Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B701D554
	for <dm-devel@lists.linux.dev>; Wed, 25 Sep 2024 15:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727278687; cv=none; b=DFHwQ9kB9kOqiO22qFz430RTaEGhHn8A4Px7vwqYdyfF+BR3gYy3EhkvjCzooAurDflIWqfIJxy0ah4Y9Py5GKm5ud5kPuXtdw+RqidKdO5IwenWKf1y2hRZA1fzHOoNj2rXmkkbnM/n8xaseEXBYZMya7oo9OggGhm52K3+xcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727278687; c=relaxed/simple;
	bh=Qjbcu/zSHX8m+j5MsL49vbJLu6NNufJ/DNgPuDXoRbE=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ht8n01GPN3vDwaMtvKVdaf2cjYdiJW1KmxiaLz8bCw1Iu8fhzKrGOAbfwZRf/3uremD2+I8upLvgiELPtXXYYOhuyyTzepfQmyqFskyWNyeNJXbM+0aYEzokQrsmquOVQpgqn/KYIYlTANkQUgevRsrZHfkAlpatZb/NlN2NsII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GarHZnpC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GarHZnpC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727278684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v+Vw/y+Un4gc140eaobYaC3W+YmumcsjIVB1KbRhzQk=;
	b=GarHZnpCiQYAM2m/sPZO7rZQGqsbT1VLs4O9coDmCZIotW2qr4739oIjyqYO0qAMnmh1bt
	H3M3ItTaHvFVE6aK4I1eXjNgrFD00iVBgpKazN8jmeyGcf6uWkQpoRSYubW/I0JoGpDctA
	ualkmQ1WSEg2z2sTeNf+YrLEIu/g1gU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-375-vQ868Zm-M8qXRubIzK11yg-1; Wed,
 25 Sep 2024 11:38:03 -0400
X-MC-Unique: vQ868Zm-M8qXRubIzK11yg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C2691887E10;
	Wed, 25 Sep 2024 15:38:02 +0000 (UTC)
Received: from [10.45.225.58] (unknown [10.45.225.58])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 585E719560B0;
	Wed, 25 Sep 2024 15:38:00 +0000 (UTC)
Date: Wed, 25 Sep 2024 17:37:57 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: luca.boccassi@gmail.com
cc: dm-devel@lists.linux.dev, snitzer@kernel.org, serge@hallyn.com, 
    wufan@linux.microsoft.com
Subject: Re: [PATCH] dm verity: fallback to platform keyring also if key in
 trusted keyring is rejected
In-Reply-To: <20240922161753.244476-1-luca.boccassi@gmail.com>
Message-ID: <8b212fc8-c67a-2973-fc5c-0cb61d165fd5@redhat.com>
References: <20240922161753.244476-1-luca.boccassi@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Sun, 22 Sep 2024, luca.boccassi@gmail.com wrote:

> From: Luca Boccassi <bluca@debian.org>
> 
> If enabled, we fallback to the platform keyring if the trusted keyring doesn't have
> the key used to sign the roothash. But if pkcs7_verify() rejects the key for other
> reasons, such as usage restrictions, we do not fallback. Do so.
> 
> Follow-up for 6fce1f40e95182ebbfe1ee3096b8fc0b37903269
> 
> Suggested-by: Serge Hallyn <serge@hallyn.com>
> Signed-off-by: Luca Boccassi <bluca@debian.org>
> ---
>  drivers/md/dm-verity-verify-sig.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> index d351d7d39c60..a9e2c6c0a33c 100644
> --- a/drivers/md/dm-verity-verify-sig.c
> +++ b/drivers/md/dm-verity-verify-sig.c
> @@ -127,7 +127,7 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
>  #endif
>  				VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
>  #ifdef CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG_PLATFORM_KEYRING
> -	if (ret == -ENOKEY)
> +	if (ret == -ENOKEY || ret == -EKEYREJECTED)
>  		ret = verify_pkcs7_signature(root_hash, root_hash_len, sig_data,
>  					sig_len,
>  					VERIFY_USE_PLATFORM_KEYRING,
> -- 
> 2.39.5

Hi

Please describe what problem does this patch solve. I.e. why would anyone 
put a key into the trusted keyring that could sign the roothash and 
restrict its usage so that it can't be used to sign the roothash?

In the other places of the kernel, only -ENOKEY is tested:
kexec_kernel_verify_pe_sig:
if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING))
s390_verify_sig:
if (ret == -ENOKEY && IS_ENABLED(CONFIG_INTEGRITY_PLATFORM_KEYRING))
do they need to be converted to -EKEYREJECTED too?

Mikulas

