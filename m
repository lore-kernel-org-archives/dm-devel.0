Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AE920C49D
	for <dm-devel@lists.linux.dev>; Tue, 29 Oct 2024 10:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730199203; cv=none; b=HcYpA+ZQgO5gWqtTPj6hzdJN4GQPoDRTDHMSqVAkkSJwiwJesDoiiv6ElFik16iA7+ZQXTGDQFYg1g6xu+NNJlvp71JvSK86DgU7KK/aq2ZRrsYV5NZBVHXe15Qkh9h44y9tstTekcp9fKySFja1+RjNAI0qhADj6wfXOxBSIcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730199203; c=relaxed/simple;
	bh=3f2I4gTtnrvWS0xKIAK7sUX3Hh1MzRe7dq2pvYIdrJM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=r3jR+Y7M/1SdNgnw7u//DbaZIzv7J+43qm8iKjNoXliCW9FvKSm5/nxbUir+7XLaxfBTeGnHAFCdV3vuatLs00OdEwJDsTY9iCA/Tf9s9zb1uxkQB0JYq3Ewcmh6bn0/EbWmQdSggYii/VYPy8fZHovcAecgB7QR6/cXS4oPaPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gB02tLZ1; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gB02tLZ1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730199199;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TyxY+Tcf2+DbuDgYiWlY8cZLoVEhHtFLOIqDPlDrUmg=;
	b=gB02tLZ1Oly4JFfwO2zt+6dKutDmh7KQku1wyZJHd7sx9ocvzxeY7nbdhWAmNfgAjFnzPf
	uxVLxCvrVeDIMB1DWFAFl4U+QQ+aDcW5CM9fSq5HYWToz+FQGAx5+To04v3mV/aZkVWN/V
	ueSd++T3WnCKxTZeEP5EEqIelEI9eZo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-487-Qb9zetvtPCGhY82Bhixx2Q-1; Tue,
 29 Oct 2024 06:53:18 -0400
X-MC-Unique: Qb9zetvtPCGhY82Bhixx2Q-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E7AA19560BE;
	Tue, 29 Oct 2024 10:53:17 +0000 (UTC)
Received: from [10.45.226.64] (unknown [10.45.226.64])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 95D9E19560A3;
	Tue, 29 Oct 2024 10:53:14 +0000 (UTC)
Date: Tue, 29 Oct 2024 11:53:11 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Gax-c <zichenxie0106@gmail.com>
cc: agk@redhat.com, snitzer@kernel.org, heinzm@redhat.com, kbusch@kernel.org, 
    scott.bauer@intel.com, dm-devel@lists.linux.dev, zzjas98@gmail.com, 
    chenyuan0y@gmail.com
Subject: Re: [PATCH] dm: Cast an operand to sector_t to prevent potential
 uint32_t overflow in unstripe_ctr()
In-Reply-To: <20241021195444.13237-1-zichenxie0106@gmail.com>
Message-ID: <fa85ad18-4725-8ac7-1429-83eef450b7e1@redhat.com>
References: <20241021195444.13237-1-zichenxie0106@gmail.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII

Accepted, Thanks.

Mikulas



On Mon, 21 Oct 2024, Gax-c wrote:

> From: Zichen Xie <zichenxie0106@gmail.com>
> 
> This was found by a static analyzer.
> There may be a potential integer overflow issue in
> unstripe_ctr(). uc->unstripe_offset and uc->unstripe_width are
> defined as "sector_t"(uint64_t), while uc->unstripe,
> uc->chunk_size and uc->stripes are all defined as "uint32_t".
> The result of the calculation will be limited to "uint32_t"
> without correct casting.
> So, we recommend adding an extra cast to prevent potential
> integer overflow.
> 
> Fixes: 18a5bf270532 ("dm: add unstriped target")
> Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
> ---
>  drivers/md/dm-unstripe.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-unstripe.c b/drivers/md/dm-unstripe.c
> index 48587c16c445..e8a9432057dc 100644
> --- a/drivers/md/dm-unstripe.c
> +++ b/drivers/md/dm-unstripe.c
> @@ -85,8 +85,8 @@ static int unstripe_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	}
>  	uc->physical_start = start;
>  
> -	uc->unstripe_offset = uc->unstripe * uc->chunk_size;
> -	uc->unstripe_width = (uc->stripes - 1) * uc->chunk_size;
> +	uc->unstripe_offset = (sector_t)uc->unstripe * uc->chunk_size;
> +	uc->unstripe_width = (sector_t)(uc->stripes - 1) * uc->chunk_size;
>  	uc->chunk_shift = is_power_of_2(uc->chunk_size) ? fls(uc->chunk_size) - 1 : 0;
>  
>  	tmp_len = ti->len;
> -- 
> 2.34.1
> 

