Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039028821
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 16:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764864106; cv=none; b=JJZnqQMhANoXewdKBcKJ4k7mcglqmnYqo9FDcCp2kqYRUUe+LS3u6NX/GY23YMJWU2tPM/YLfXVCpqOKPkx4D6b6hcHwfyeDVcmiHvReExRWGGDlxE7zAK4W3zvFIRWx0HGhoYq6d0LSqQ+vA11d2BU0uu8MDdQ9cOacu9uBTds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764864106; c=relaxed/simple;
	bh=F3gx0csC7k/6J2mSRQgKF/NaWC8uBcNKLHxdy8/v24k=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=s4IaW8puDoOO0LGAbEt89YLwIVFUCv3MRHDkLpKy/dWIjNvk2WnwHXLSE/pzcbAdE79J151mrNJRvcmV64mZfG+ki8VDBWN1H9bmM88iAIFN2JjvBz85KpLKq0GgicyJ0i8pVxX0V0s0NLM/dRKPJp0mw6CAK9na0+Pzgm6HPaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WtuigBTO; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WtuigBTO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764864103;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TdRvxJix6f7l84DMQuXi+VdPPSWZLABTOb8TChGWC/w=;
	b=WtuigBTOGabzKGqCqO3rhUr4EZoGXl0TJM5h6C0rCpF6upS87yG1BjFIktmtCuppwsvip2
	VXNgFWvQZ01EATve3eo6X/ELcGXs0nD3OsWMuJvkfunp4X1XDexurahjszj5MTZffDFOYz
	Vn23fLvmV6tPRNJy16XOUk55k4Rt2wE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-XvAwqJAlPTGp351ZpYoyeQ-1; Thu,
 04 Dec 2025 11:01:36 -0500
X-MC-Unique: XvAwqJAlPTGp351ZpYoyeQ-1
X-Mimecast-MFC-AGG-ID: XvAwqJAlPTGp351ZpYoyeQ_1764864095
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC5651955F27;
	Thu,  4 Dec 2025 16:01:34 +0000 (UTC)
Received: from [10.44.33.72] (unknown [10.44.33.72])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3E6941800577;
	Thu,  4 Dec 2025 16:01:32 +0000 (UTC)
Date: Thu, 4 Dec 2025 17:01:27 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: cengku@gmail.com, dm-devel@lists.linux.dev, chenl311@chinatelecom.cn
Subject: Re: [PATCH 2/3] dm pcache: fix cache info indexing
In-Reply-To: <20251204025323.2901775-2-dongsheng.yang@linux.dev>
Message-ID: <e40cf2ec-d087-65f9-45a0-a47119c89ced@redhat.com>
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev> <20251204025323.2901775-2-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nw6SESe9eDqXOOmfsBtIIHKlfNoXnwrZcHeNLRJ-eAg_1764864095
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII



On Thu, 4 Dec 2025, Dongsheng Yang wrote:

> From: Li Chen <chenl311@chinatelecom.cn>
> 
> The on-media cache_info index used sizeof(struct) instead of the
> 4K metadata stride, so gc_percent updates from dmsetup message
> were written between slots and lost after reboot. Use
> PCACHE_CACHE_INFO_SIZE in get_cache_info_addr() and align
> info_index with the slot returned by pcache_meta_find_latest().
> 
> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
> ---
>  drivers/md/dm-pcache/cache.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> index 9289c016b7c9..bcc4e509aa69 100644
> --- a/drivers/md/dm-pcache/cache.c
> +++ b/drivers/md/dm-pcache/cache.c
> @@ -8,9 +8,11 @@
>  
>  struct kmem_cache *key_cache;
>  
> -static inline struct pcache_cache_info *get_cache_info_addr(struct pcache_cache *cache)
> +static inline struct pcache_cache_info *
> +get_cache_info_addr(struct pcache_cache *cache)
>  {
> -	return cache->cache_info_addr + cache->info_index;
> +	return (struct pcache_cache_info *)((char *)cache->cache_info_addr +
> +						(size_t)cache->info_index * PCACHE_CACHE_INFO_SIZE);
>  }
>  
>  static void cache_info_write(struct pcache_cache *cache)
> @@ -49,6 +51,8 @@ static int cache_info_init(struct pcache_cache *cache, struct pcache_cache_optio
>  			return -EINVAL;
>  		}
>  
> +		cache->info_index = ((char *)cache_info_addr - (char *)cache->cache_info_addr) / PCACHE_CACHE_INFO_SIZE;
> +
>  		return 0;
>  	}
>  
> -- 
> 2.43.0

I already staged the patch below? Should I revert it and stage your new 
patch?

Mikulas


diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index d8e92367d947..9554d1158450 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -8,9 +8,11 @@

 struct kmem_cache *key_cache;

-static inline struct pcache_cache_info *get_cache_info_addr(struct pcache_cache *cache)
+static inline struct pcache_cache_info *
+get_cache_info_addr(struct pcache_cache *cache)
 {
-       return cache->cache_info_addr + cache->info_index;
+       return (struct pcache_cache_info *)((char *)cache->cache_info_addr 
+
+                                               (size_t)cache->info_index * PCACHE_CACHE_INFO_SIZE);
 }

 static void cache_info_write(struct pcache_cache *cache)
@@ -40,7 +42,12 @@ static int cache_info_init(struct pcache_cache *cache, 
struct pcache_cache_optio
        if (IS_ERR(cache_info_addr))
                return PTR_ERR(cache_info_addr);

-       if (cache_info_addr) {
+    if (cache_info_addr) {
+               int index = ((char *)cache_info_addr - (char *)cache->cache_info_addr) /
+                               PCACHE_CACHE_INFO_SIZE;
+
+               cache->info_index = (index + 1) % PCACHE_META_INDEX_MAX;
+
                if (opts->data_crc !=
                                (cache->cache_info.flags & PCACHE_CACHE_FLAGS_DATA_CRC)) {
                        pcache_dev_err(pcache, "invalid option for data_crc: %s, expected: %s",

