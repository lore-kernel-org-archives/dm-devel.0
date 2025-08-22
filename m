Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A217B23535E
	for <dm-devel@lists.linux.dev>; Fri, 22 Aug 2025 06:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755845634; cv=none; b=o2cdAfvZa+ouUBkS9QTZOugr475ajSJuhu4Lgvys8SU4dZARwxR1LduayYD8ER8513FxczO1ka1JLx+SHjMnsFHgl6g7QTesysn1XuSCbfsm0JABqY6TkLXg2nLp3JuY3HTMclRE0aw2hs5a2c2HAeGfoMeEzwjbXsj7mL2CAp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755845634; c=relaxed/simple;
	bh=/CDElNvGWNfCLZ2Xpd9rlCnpOgeyW1uothqVa1kIWgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fK3s5B2nDhl3j2wj/wImvPKuOh78Cyr+l3cMgrKk3UB5bLufDo8ujK0Z/3kmZm84vCYrSrVfgvNjF9maO/wUvWzA5k5OxkQnCodIObGDyOo3cvURTiT23xOL1gdgoeEJrZdhXam8bSIN/CLluojx+g9Wb9e9DLw28YQlsHDGyOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FvLOZr6a; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FvLOZr6a"
Message-ID: <2f5aa331-aa47-4e81-9bb3-65c771b39913@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755845629;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DzHIPFxBPgUx9BFYdaIJak/G5M7r+nAqrWr6p8ZgjUY=;
	b=FvLOZr6asRWY20kShpM9KHSxvhecny7ixGw3ZUt7QWAD37ylzal0PXqluWuPoe/aHTxpDh
	DssmSBKXkw2StZWCgQgSqVD09l6Sa065/DouwooUOQRXQPGjOJBQVOnlzCnZwblNVL8mt4
	QxmowspfEs1gDWlagueipDiFmT/h0SE=
Date: Fri, 22 Aug 2025 14:53:42 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH] dm-pcache: Fix 64-bit division for 32-bit platforms in
 get_kset_id()
To: Nathan Chancellor <nathan@kernel.org>, Zheng Gu <cengku@gmail.com>,
 Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, patches@lists.linux.dev
References: <20250821-dm-pcache-fix-32-bit-div-err-v1-1-cab5448f44e6@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20250821-dm-pcache-fix-32-bit-div-err-v1-1-cab5448f44e6@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 8/22/2025 4:09 AM, Nathan Chancellor 写道:
> When building for a 32-bit platform (such as ARCH=i386 allmodconfig),
> there is a modpost error:
>
>    ERROR: modpost: "__umoddi3" [drivers/md/dm-pcache/dm-pcache.ko] undefined!
>
> Hacking up the driver Makefile to allow building into the kernel shows
> that the division comes from get_kset_id(), which is inlined into
> cache_key_append() in cache_key.c.
>
> Use the helper div_u64_rem() to avoid emitting a libcall on 32-bit targets.
>
> Fixes: fd5cc4922bef ("dm-pcache: add persistent cache target in device-mapper")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/md/dm-pcache/cache.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
> index b3b361cc406e..b10e721ab1b7 100644
> --- a/drivers/md/dm-pcache/cache.h
> +++ b/drivers/md/dm-pcache/cache.h
> @@ -373,7 +373,9 @@ static inline void *get_key_head_addr(struct pcache_cache *cache)
>   
>   static inline u32 get_kset_id(struct pcache_cache *cache, u64 off)
>   {
> -	return (off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT) % cache->n_ksets;
> +	u32 rem;
> +	div_u64_rem(off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT, cache->n_ksets, &rem);
> +	return rem;
>   }


Hi Nathan,

Thanx for your fix. It looks good to me.

Just one nit about the variable name. I prefer kset_id to rem.

Mikulas, if this looks good to you, could you apply this change to dm-6.18?

Thanx

Dongsheng

diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
index b3b361cc406e..f005c9d9a7aa 100644
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -373,7 +373,11 @@ static inline void *get_key_head_addr(struct 
pcache_cache *cache)

  static inline u32 get_kset_id(struct pcache_cache *cache, u64 off)
  {
-       return (off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT) % cache->n_ksets;
+       u32 kset_id;
+
+       div_u64_rem(off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT, 
cache->n_ksets, &kset_id);
+
+       return kset_id;
  }

  static inline struct pcache_cache_kset *get_kset(struct pcache_cache 
*cache, u32 kset_id)

> re
>   
>   static inline struct pcache_cache_kset *get_kset(struct pcache_cache *cache, u32 kset_id)
>
> ---
> base-commit: fd5cc4922bef4b3c3cd0452f38dcfd066322e9a9
> change-id: 20250821-dm-pcache-fix-32-bit-div-err-4f0695e94784
>
> Best regards,
> --
> Nathan Chancellor <nathan@kernel.org>
>
