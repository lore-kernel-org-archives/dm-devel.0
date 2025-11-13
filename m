Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB7A3009F1
	for <dm-devel@lists.linux.dev>; Thu, 13 Nov 2025 06:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763016013; cv=none; b=hZTW118Dr7eY5mxaDYtvjWILq6np8V3CZXepHTVDWTm7icW2SI3bBLWD3JbNAWeGdktH0SgMtAzUWEg7+QD4a+NlwiNvuATG9LaTruU3Akn5OW3qdeIa8DWyFl5YxZXuKt6HaqZ1+cA3zkkM2tRbmwNBgWsEwdiKjkM3bs4fUAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763016013; c=relaxed/simple;
	bh=QcWs+IGmRoflPOk02kprhwK54ytqFiMJKgzVWIWFYrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TB9vpbO0XUOT0ELhZHbDcba4g8/FVFje8MDUPm4zRvv4yxNNq0F2A9JwXFSK300yLIMiCOexJYd36JI10qG8SL0GWNlYtcmkpenOvURtdlENVML9uqTy67VHCKbOkDga+lgHb6Qqb/diDTSC2RN5rSv6K66P0kc4nxZ4q+A7Glk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pU+LVcP/; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pU+LVcP/"
Message-ID: <698ecc2f-0c19-4a9a-a493-f675dc14ec5e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763016004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KaalMo1Owx+Fe0sQv3alWRupfxtG4rkZLE81bZTGHkI=;
	b=pU+LVcP/8FVdfs6CV5GwZsQjqR4BjvPq6xl+O/UWYcUCPMOluYOoJp5Fj+esjV+BR82TUP
	D5sNZ9p4nA03Rg4n+TcrKTpNEcsUob6E0nxhNir+460mGRDnt1IXIPPVEZSXdflLhsS+/T
	QbIbeIJMpKfnDXfjMxi6/Ik0ooWVvFw=
Date: Thu, 13 Nov 2025 14:39:39 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/3] dm-pcache: allow built-in build and rename flush
 helper
To: Li Chen <me@linux.beauty>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Zheng Gu <cengku@gmail.com>
References: <20251111121337.1063443-1-me@linux.beauty>
 <20251111121337.1063443-2-me@linux.beauty>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20251111121337.1063443-2-me@linux.beauty>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 11/11/2025 8:13 PM, Li Chen 写道:
> From: Li Chen <chenl311@chinatelecom.cn>
>
> CONFIG_BCACHE is tristate, so dm-pcache can also be built-in.
> Switch the Makefile to use obj-$(CONFIG_DM_PCACHE) so the target can be
> linked into vmlinux instead of always being a loadable module.
>
> Also rename cache_flush() to pcache_cache_flush() to avoid a global
> symbol clash with sunrpc/cache.c's cache_flush().
>
> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>


Reviewed-by： Dongsheng Yang <dongsheng.yang@linux.dev>

> ---
>   drivers/md/dm-pcache/Makefile    | 2 +-
>   drivers/md/dm-pcache/cache.c     | 2 +-
>   drivers/md/dm-pcache/cache.h     | 2 +-
>   drivers/md/dm-pcache/cache_req.c | 6 +++---
>   4 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/md/dm-pcache/Makefile b/drivers/md/dm-pcache/Makefile
> index 86776e4acad2..cedfd38854f6 100644
> --- a/drivers/md/dm-pcache/Makefile
> +++ b/drivers/md/dm-pcache/Makefile
> @@ -1,3 +1,3 @@
>   dm-pcache-y := dm_pcache.o cache_dev.o segment.o backing_dev.o cache.o cache_gc.o cache_writeback.o cache_segment.o cache_key.o cache_req.o
>   
> -obj-m += dm-pcache.o
> +obj-$(CONFIG_DM_PCACHE) += dm-pcache.o
> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> index d8e92367d947..d516d4904227 100644
> --- a/drivers/md/dm-pcache/cache.c
> +++ b/drivers/md/dm-pcache/cache.c
> @@ -411,7 +411,7 @@ void pcache_cache_stop(struct dm_pcache *pcache)
>   {
>   	struct pcache_cache *cache = &pcache->cache;
>   
> -	cache_flush(cache);
> +	pcache_cache_flush(cache);
>   
>   	cancel_delayed_work_sync(&cache->gc_work);
>   	flush_work(&cache->clean_work);
> diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
> index 1136d86958c8..27613b56be54 100644
> --- a/drivers/md/dm-pcache/cache.h
> +++ b/drivers/md/dm-pcache/cache.h
> @@ -339,7 +339,7 @@ void cache_seg_put(struct pcache_cache_segment *cache_seg);
>   void cache_seg_set_next_seg(struct pcache_cache_segment *cache_seg, u32 seg_id);
>   
>   /* cache request*/
> -int cache_flush(struct pcache_cache *cache);
> +int pcache_cache_flush(struct pcache_cache *cache);
>   void miss_read_end_work_fn(struct work_struct *work);
>   int pcache_cache_handle_req(struct pcache_cache *cache, struct pcache_request *pcache_req);
>   
> diff --git a/drivers/md/dm-pcache/cache_req.c b/drivers/md/dm-pcache/cache_req.c
> index 27f94c1fa968..7854a30e07b7 100644
> --- a/drivers/md/dm-pcache/cache_req.c
> +++ b/drivers/md/dm-pcache/cache_req.c
> @@ -790,7 +790,7 @@ static int cache_write(struct pcache_cache *cache, struct pcache_request *pcache
>   }
>   
>   /**
> - * cache_flush - Flush all ksets to persist any pending cache data
> + * pcache_cache_flush - Flush all ksets to persist any pending cache data
>    * @cache: Pointer to the cache structure
>    *
>    * This function iterates through all ksets associated with the provided `cache`
> @@ -802,7 +802,7 @@ static int cache_write(struct pcache_cache *cache, struct pcache_request *pcache
>    * the respective error code, preventing the flush operation from proceeding to
>    * subsequent ksets.
>    */
> -int cache_flush(struct pcache_cache *cache)
> +int pcache_cache_flush(struct pcache_cache *cache)
>   {
>   	struct pcache_cache_kset *kset;
>   	int ret;
> @@ -827,7 +827,7 @@ int pcache_cache_handle_req(struct pcache_cache *cache, struct pcache_request *p
>   	struct bio *bio = pcache_req->bio;
>   
>   	if (unlikely(bio->bi_opf & REQ_PREFLUSH))
> -		return cache_flush(cache);
> +		return pcache_cache_flush(cache);
>   
>   	if (bio_data_dir(bio) == READ)
>   		return cache_read(cache, pcache_req);
