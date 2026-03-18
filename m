Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABABD3E5EE8
	for <dm-devel@lists.linux.dev>; Wed, 18 Mar 2026 16:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773851704; cv=none; b=lKb9rtk5M+aMAuIzKoFbW40aAs8ms2G/+TaLNcSrSCFLsCu4UhhjOmJih29WLFT1xxzdKfhqxxllwON512UAgCav8NZhdE4aLEUiF+OQrUwuK8LN+YRe0Y/wEqSCmR514Bwf3XEX9lJJ4dvLaZJofFDcv3VHTHBJRlW36FkDS0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773851704; c=relaxed/simple;
	bh=qqyhAffxp3UTojgfm5Yedb6WVA5sh7MFtWlvfExcYtA=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fqTx0I5HmIP4AtpySHKgxSdGJZjZIeflCj+4zdOMVrtmicbYKw862hpElpoGKMY+aDQKwZM+Nkwf2fDQRGUQpwpJ21Z2XxYmvmayOwKX4pAZC6SaMB5s19J87ZqVsIcytkTEVYcOGCXAh7ghbVnsvpLbBqDOPqzjbrwQJ7p/yZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SBU4CTpW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SBU4CTpW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773851700;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YnlcKKdFFl4v9uzDAZNgFneLcRMlNwK/su792ECsrBI=;
	b=SBU4CTpWGPIiGRwMbmLHnxhKCDs2SUOol671Pr7ceFB74OVRgVv2AgJ54TbeDiN5AoCfCp
	GcAUzgE27KcC51i5qMPAwfRYEDvkDWIFeLF5jfqPcaJALOFUrhlxrJgpxWNXXo9oWPRE8D
	56QEOh2ZZjO944db6L4dpYkFngFBviE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-151-iMhgdXtEN2KtzlkeEhMdKg-1; Wed,
 18 Mar 2026 12:34:56 -0400
X-MC-Unique: iMhgdXtEN2KtzlkeEhMdKg-1
X-Mimecast-MFC-AGG-ID: iMhgdXtEN2KtzlkeEhMdKg_1773851695
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 73D25195608C;
	Wed, 18 Mar 2026 16:34:55 +0000 (UTC)
Received: from [10.44.32.29] (unknown [10.44.32.29])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF7921953944;
	Wed, 18 Mar 2026 16:34:53 +0000 (UTC)
Date: Wed, 18 Mar 2026 17:34:47 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Keith Busch <kbusch@meta.com>
cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, snitzer@kernel.org, 
    Keith Busch <kbusch@kernel.org>
Subject: Re: [RESEND PATCHv3 2/2] dm-crypt: dynamic scatterlist for many
 segments
In-Reply-To: <20260316150941.1813568-1-kbusch@meta.com>
Message-ID: <08fbfa54-0e19-82b5-01ba-216a4202d2e5@redhat.com>
References: <20260316150229.1771884-1-kbusch@meta.com> <20260316150941.1813568-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 8A7EHidKV_0d9DONIC4e_0KGuxTgI0fs2z4BOEP0eZ8_1773851695
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Mon, 16 Mar 2026, Keith Busch wrote:

> From: Keith Busch <kbusch@kernel.org>
> 
> In the unlikely case where the base bio uses a highly fragmented vector,
> the four inline scatterlist elements may not be enough, so allocate a
> temporary scatterlist when needed.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
> +static int crypt_build_sgl(struct crypt_config *cc, struct scatterlist **psg,
>  			   struct bvec_iter *iter, struct bio *bio,
>  			   int max_segs)
>  {
>  	unsigned int bytes = cc->sector_size;
> +	struct scatterlist *sg = *psg;
>  	struct bvec_iter tmp = *iter;
>  	int segs, i = 0;
>  
>  	bio_advance_iter(bio, &tmp, bytes);
>  	segs = tmp.bi_idx - iter->bi_idx + !!tmp.bi_bvec_done;
> -	if (segs > max_segs)
> -		return -EIO;
> +	if (segs > max_segs) {
> +		sg = kmalloc_array(segs, sizeof(struct scatterlist), GFP_NOIO);
> +		if (!sg)
> +			return -ENOMEM;
> +	}
>  
>  	sg_init_table(sg, segs);
>  	do {

GFP_NOIO allocations may be unavailable when you are swapping to the 
dm-crypt device and the machine runs out of memory temporarily. There 
should be:

sg = kmalloc_array(segs, sizeof(struct scatterlist), GFP_NOWAIT | __GFP_NOMEMALLOC);

and if it fails, allocate "sg" from a mempool with GFP_NOIO (mempool_alloc 
with GFP_NOIO can't fail, it waits until someone frees some entries into 
the mempool).

As there are two consecutive calls to crypt_build_sgl, there should be two 
mempools, one for the first call and the second for the second call. The 
mempools should be sized for the worst possible fragmentation.

Mikulas

