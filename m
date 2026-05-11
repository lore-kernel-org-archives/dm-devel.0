Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1013659E8
	for <dm-devel@lists.linux.dev>; Mon, 11 May 2026 11:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778498141; cv=none; b=Uv1flMy8sjVxeCCJgl/dzOWx8flYWSgy2FSp/eDO0QKX7Ju2DjqqGNz4Y2zcfYOi6eVH06MLKKZuaBI4+gxpyQ14OrdYiRlWa6d4PMybzDpEw0XoyjM/MprB9mEYu8XZ5rIV4CguVH0yEdwxqpK5FVVLJvG6gbaJmlX4MwK7zL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778498141; c=relaxed/simple;
	bh=f2Z2zaW0P1huT/4HZRDa6A5DYD6L1/DRR3rmiVyG9Xg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=MT4+mE4IeXnwd7CoXtseC4Tlw5Z+zbb0i2jF+CF/YRStPySmrLl8FUncpI88PXYwVVjke0PZP6/pQ0CgM2l6tGWbdssk42yZ0sHMTdsPcZNgGDB8eeTqHg5rTn/0BhGYjEkSg5N61vXi+aBQWrPm14LTsGpm/MHbcRZH1ay1S0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EUnymntr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EUnymntr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778498138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FsXCbR14P/4XQToQ3fP1sjM3Sp0otiHsChjmD3oghcA=;
	b=EUnymntrw/J5bNoJjtPZKff4nIMDt9d6MEP1WPRGJPOgMQIIJXAAu1FEH3IYImghEI7rg7
	qDzUk24MmW+Kwzzpxjmgvpt8aMRnLsUukagGc9YFwI9YQgeK1BZeARdpGC8R3+6U+RjGQi
	Wv5DbSvVOPoVBJ/vHRGwKrc/tGJvzgY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-241-M_Zw3A5AMJWs4f9yOTpR5g-1; Mon,
 11 May 2026 07:15:34 -0400
X-MC-Unique: M_Zw3A5AMJWs4f9yOTpR5g-1
X-Mimecast-MFC-AGG-ID: M_Zw3A5AMJWs4f9yOTpR5g_1778498133
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6480F19560AA;
	Mon, 11 May 2026 11:15:33 +0000 (UTC)
Received: from [10.44.34.151] (unknown [10.44.34.151])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07C901800465;
	Mon, 11 May 2026 11:15:30 +0000 (UTC)
Date: Mon, 11 May 2026 13:15:28 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Ethan Tidmore <ethantidmore06@gmail.com>
cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
    Benjamin Marzinski <bmarzins@redhat.com>, 
    Eric Biggers <ebiggers@google.com>, 
    Linlin Zhang <linlin.zhang@oss.qualcomm.com>, dm-devel@lists.linux.dev, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dm-inlinecrypt: Fix signedness bug
In-Reply-To: <20260508023716.668783-1-ethantidmore06@gmail.com>
Message-ID: <9d4298c5-24a6-452e-7345-4d49ae61141e@redhat.com>
References: <20260508023716.668783-1-ethantidmore06@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: F6aGGRfOu_i4zOhODdGE4-AGqgqZ-PJa7Zjbvz_XpPA_1778498133
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Hi

Thanks. I merged this into the existing commit.

Mikulas


On Thu, 7 May 2026, Ethan Tidmore wrote:

> The function get_key_size() returns negative error codes and
> ctx->key_size is an unsigned integer, so the check (ctx->key_size < 0)
> is always impossible
> 
> Assign get_key_size() return value to err, check for error code, then
> assign ctx->key_size to err.
> 
> Detected by Smatch:
> drivers/md/dm-inlinecrypt.c:329 inlinecrypt_ctr()
> warn: unsigned 'ctx->key_size' is never less than zero.
> 
> Fixes: 753450f716417 ("dm-inlinecrypt: add target for inline block device encryption")
> Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
> ---
>  drivers/md/dm-inlinecrypt.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-inlinecrypt.c b/drivers/md/dm-inlinecrypt.c
> index 6f804f5a4be6..40d48ba73e23 100644
> --- a/drivers/md/dm-inlinecrypt.c
> +++ b/drivers/md/dm-inlinecrypt.c
> @@ -325,11 +325,13 @@ static int inlinecrypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	}
>  
>  	/* <key> */
> -	ctx->key_size = get_key_size(&argv[1]);
> -	if (ctx->key_size < 0) {
> +	err = get_key_size(&argv[1]);
> +	if (err < 0) {
>  		ti->error = "Cannot parse key size";
>  		return -EINVAL;
>  	}
> +	ctx->key_size = err;
> +
>  	err = inlinecrypt_get_key(argv[1], raw_key, ctx->key_size);
>  	if (err) {
>  		ti->error = "Malformed key string";
> -- 
> 2.54.0
> 

