Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CCE2EC0AE
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 16:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764864853; cv=none; b=HDtzwM7YrxAsbMVFBECK2Btz0NJ0HPIbdSBD5m1Y5LWbS5SNl7pbKvLSKT52jULbK08DcyguGbsgXs5sgcR4Ys3Pw8otMZsdOGLm+darInu+JNZBR3oc4a8VW3T0E0F7Z7eaexze33NjpuBTf6HaRRc/XV+Oa6Rml7+tpZv2/44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764864853; c=relaxed/simple;
	bh=B2DfaNX6wI6nokEtV4Ouj9Rpsoy0N4QWnC7NEJu0PFw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=AGCHoF1p932HiAWKATXRIrzx9yTbHblrMyIztWuQdUEIk3x7g9f32vqMv7pogKF2PmnSuVf29SFGzUOMtC+FdMMAEwhO/9bAVwwOekNU9Dgh9rFNpqBUlonGu1vAYM47k9AHsNSQA3rZ1PD0WIWotlrwSafU8QznGp426zsuLNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e1Ksla08; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e1Ksla08"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764864850;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+6tCs+912eC3isb3aVIh+Ed99c+GvaDlwHHFzLKQVBs=;
	b=e1Ksla08phd/o+jJ64GC3Huy5trmfLQCX2QWGPqbJS25AFMEWOStOtXdIVATzN5XTo7VD2
	H3vpB5qLRgwc1tfGQCmgcTvKjbFEF97MO8ui1KMm0SvpcZ5E1tKIy95JniF+4GWntK8oVD
	4ef7ofhMK6ZpPtVmVNDr6m0jZvD3a4o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-660-JhJGXTSuPqOikUMfIvAlKQ-1; Thu,
 04 Dec 2025 11:14:06 -0500
X-MC-Unique: JhJGXTSuPqOikUMfIvAlKQ-1
X-Mimecast-MFC-AGG-ID: JhJGXTSuPqOikUMfIvAlKQ_1764864845
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EA4319560A7;
	Thu,  4 Dec 2025 16:14:05 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65DB319560B4;
	Thu,  4 Dec 2025 16:14:03 +0000 (UTC)
Date: Thu, 4 Dec 2025 17:13:58 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: cengku@gmail.com, dm-devel@lists.linux.dev, chenl311@chinatelecom.cn
Subject: Re: [PATCH 1/3] dm-pcache: advance slot index before writing slot
In-Reply-To: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
Message-ID: <bea8250d-fc7f-6bda-df57-2814e96fd05f@redhat.com>
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5u375ZPoWIFZ1zqHXwAnmkmqKrMAFi-SRthgBVbI1F0_1764864845
X-Mimecast-Originator: redhat.com
Content-Type: multipart/mixed; boundary="-1463811712-1665019886-1764864844=:1494116"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
---1463811712-1665019886-1764864844=:1494116
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Thu, 4 Dec 2025, Dongsheng Yang wrote:

> In dm-pcache, in order to ensure crash-consistency, a dual-copy scheme
> is used to alternately update metadata, and there is a slot index that
> records the current slot. However, in the write path the current
> implementation writes directly to the current slot indexed by slot
> index, and then advances the slot — which ends up overwriting the
> existing slot, violating the crash-consistency guarantee.
> 
> This patch fixes that behavior, preventing metadata from being
> overwritten incorrectly.
> 
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
> ---
>  drivers/md/dm-pcache/cache.c         | 8 ++++----
>  drivers/md/dm-pcache/cache_segment.c | 8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> index 698697a7a73c..9289c016b7c9 100644
> --- a/drivers/md/dm-pcache/cache.c
> +++ b/drivers/md/dm-pcache/cache.c
> @@ -21,10 +21,10 @@ static void cache_info_write(struct pcache_cache *cache)
>  	cache_info->header.crc = pcache_meta_crc(&cache_info->header,
>  						sizeof(struct pcache_cache_info));
>  
> +	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
> +
>  	memcpy_flushcache(get_cache_info_addr(cache), cache_info,
>  			sizeof(struct pcache_cache_info));
> -
> -	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
>  }
>  
>  static void cache_info_init_default(struct pcache_cache *cache);

I'm not sure whether this is bug or not - but memcpy_flushcache doesn't 
guarantee that the cache will be flushed (despite it's name) or that 
writes would be ordered.

You need pmem_wmb(). I see that you are using it at other places.

Mikulas
---1463811712-1665019886-1764864844=:1494116--

