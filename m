Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1A9288C2F
	for <dm-devel@lists.linux.dev>; Wed,  3 Dec 2025 05:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764741410; cv=none; b=Y/TOqPTZmiqIyyM+ppelxb4UL/7ulqW4YbuoRSYMHkb41SrLOIHb3WzbHLLAU0XMc47+iiUY7i8fgyx+2kZu7DsrRFg/jyu/fOKrEh5LJzmPb3HWTjseQwAaqrfQ62h9eUdDUqm3aTByHSXm4ux0fC54Ll0UMO263UkqxG03x6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764741410; c=relaxed/simple;
	bh=5ZrUUDzqyEBt/iATXAB/q6QU9jtVYshbONnz4kURwvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nIv97oz/tCwPC8oHIp2CIbO0blHkceBJj2RdhyQNivOc1Ugf51SAQ50UqgzEb0lNRIZXO4tZJH34Kpfx6EyhCfpEO9d9ckym495uVFt07Mq1Ume/YyUGyqLoSvNGy5ZWtF+Rdvkqc489LjLxKAF9ACemjbpKMsbRpGx5cFLtmFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DUSEGFhZ; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DUSEGFhZ"
Message-ID: <3222d76f-3710-4238-b90e-cd1deb0d0912@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764741403;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N+czyqnIDQE6KDJv0xAhaoeWiZJ0vfby3Nl1tJ+ICKs=;
	b=DUSEGFhZh86O0eVZk/UQa7G7UZsV6v+CKuItK8aWaBweuEKOQ2IWd9wcwWrOHL/hUCzpMh
	2PuYE9hYFz900dXR9vpNtGjRq5ikR1RDd2NkG1spBNiu1obyxjTLXJW63lGFdBzXXuL7G0
	DX4cUKZFKCERh1Fo2TPAvc8Buq2CDo8=
Date: Wed, 3 Dec 2025 13:56:33 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] dm pcache: fix cache info indexing
To: Li Chen <me@linux.beauty>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Zheng Gu <cengku@gmail.com>
References: <20251202121158.111092-1-me@linux.beauty>
 <20251202121158.111092-2-me@linux.beauty>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20251202121158.111092-2-me@linux.beauty>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/2/2025 8:11 PM, Li Chen 写道:
> From: Li Chen <chenl311@chinatelecom.cn>
>
> The on-media cache_info index used sizeof(struct) instead of the
> 4K metadata stride, so gc_percent updates from dmsetup message
> were written between slots and lost after reboot. Use
> PCACHE_CACHE_INFO_SIZE in get_cache_info_addr() and align
> info_index with the slot returned by pcache_meta_find_latest().
>
> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
> ---
>   drivers/md/dm-pcache/cache.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> index 698697a7a73c..6d5001548628 100644
> --- a/drivers/md/dm-pcache/cache.c
> +++ b/drivers/md/dm-pcache/cache.c
> @@ -8,9 +8,11 @@
>   
>   struct kmem_cache *key_cache;
>   
> -static inline struct pcache_cache_info *get_cache_info_addr(struct pcache_cache *cache)
> +static inline struct pcache_cache_info *
> +get_cache_info_addr(struct pcache_cache *cache)
>   {
> -	return cache->cache_info_addr + cache->info_index;
> +	return (struct pcache_cache_info *)((char *)cache->cache_info_addr +
> +						(size_t)cache->info_index * PCACHE_CACHE_INFO_SIZE);
>   }
>   
>   static void cache_info_write(struct pcache_cache *cache)
> @@ -40,7 +42,12 @@ static int cache_info_init(struct pcache_cache *cache, struct pcache_cache_optio
>   	if (IS_ERR(cache_info_addr))
>   		return PTR_ERR(cache_info_addr);
>   
> -	if (cache_info_addr) {
> +    if (cache_info_addr) {


this is unrelated change, and it introduce error in checkpatch.pl

# ./scripts/checkpatch.pl drivers/md/dm-pcache/cache.c
WARNING: please, no spaces at the start of a line
#45: FILE: drivers/md/dm-pcache/cache.c:45:
+    if (cache_info_addr) {$

WARNING: suspect code indent for conditional statements (4, 16)
#45: FILE: drivers/md/dm-pcache/cache.c:45:
+    if (cache_info_addr) {
+               int index = ((char *)cache_info_addr - (char 
*)cache->cache_info_addr) /

total: 0 errors, 2 warnings, 452 lines checked

> +		int index = ((char *)cache_info_addr - (char *)cache->cache_info_addr) /
> +				PCACHE_CACHE_INFO_SIZE;
> +
> +		cache->info_index = (index + 1) % PCACHE_META_INDEX_MAX;


Don't advance info_index at init stage, cache->info_index means the 
current index, not the next index.

It will be advanced in cache_info_write() after write cache_info into 
next slot.

In addition, cache->info_index initialization should be after the 
data_crc checking.

Thanx

> +
>   		if (opts->data_crc !=
>   				(cache->cache_info.flags & PCACHE_CACHE_FLAGS_DATA_CRC)) {
>   			pcache_dev_err(pcache, "invalid option for data_crc: %s, expected: %s",
