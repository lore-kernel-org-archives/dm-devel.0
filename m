Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3B32E9EAD
	for <dm-devel@lists.linux.dev>; Fri,  5 Dec 2025 03:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764903916; cv=none; b=FLYIkW4hvLiy1VSs5Yo8n6KyCvcj6jOdrQ5gHUPiZvovb/P1z5ynWMwOO+b8ja03mGRj4keouTdCnlRu2BkMwHMcJDy8dEycrsYzcjBhCti88+5AtiOK+aH0wyux9xlxYQaMTBDsiAIBsdjLneOZaeLRqJkHvXDkVaUzn2cFDpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764903916; c=relaxed/simple;
	bh=tFBvb3Z93rLF57rsDFKReQTNT6EkTcpEwxKj0ULTRqA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lwz2et+NA3WlMUikfB68aZcGabanI6OJcjUmEorF6wiUkSZ9g/UAa0kk7AOZAui03cXIWnKFuEwA+gItwDjGk78rHid9iBuHBHZgsGw7ZOs9PKPxVvVshRzKT1vkdZj9dLv6I7rGZ5H8KXlgLQFKuVsP7yEDWGcwxP+2ug5mD5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SO/gHYvt; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SO/gHYvt"
Message-ID: <61a94278-617b-4f93-b35e-83b44833d425@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764903910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w7jPE0SDiAGNQB1/jkz7GiztgUoMvHOECTH8EtPwEI8=;
	b=SO/gHYvtIHKevY817D+RvvFYbcMe+Xo0xdNucgupjDcrTUiNEfjuwjPhqonEU6FFGxf3G3
	soi9IRWjfgXlc0fQUrhvNosHopw+Yg7vKTvPnaJyeZnzRTtGKeCTXG+086nJfVkRsBicdO
	P8LIrLn2MDW9WVSoFxTOrFGlg4n/3nM=
Date: Fri, 5 Dec 2025 11:05:05 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 2/3] dm pcache: fix cache info indexing
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: cengku@gmail.com, dm-devel@lists.linux.dev, chenl311@chinatelecom.cn
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
 <20251204025323.2901775-2-dongsheng.yang@linux.dev>
 <e40cf2ec-d087-65f9-45a0-a47119c89ced@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <e40cf2ec-d087-65f9-45a0-a47119c89ced@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/5/2025 12:01 AM, Mikulas Patocka 写道:
>
> On Thu, 4 Dec 2025, Dongsheng Yang wrote:
>
>> From: Li Chen <chenl311@chinatelecom.cn>
>>
>> The on-media cache_info index used sizeof(struct) instead of the
>> 4K metadata stride, so gc_percent updates from dmsetup message
>> were written between slots and lost after reboot. Use
>> PCACHE_CACHE_INFO_SIZE in get_cache_info_addr() and align
>> info_index with the slot returned by pcache_meta_find_latest().
>>
>> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
>> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
>> ---
>>   drivers/md/dm-pcache/cache.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
>> index 9289c016b7c9..bcc4e509aa69 100644
>> --- a/drivers/md/dm-pcache/cache.c
>> +++ b/drivers/md/dm-pcache/cache.c
>> @@ -8,9 +8,11 @@
>>   
>>   struct kmem_cache *key_cache;
>>   
>> -static inline struct pcache_cache_info *get_cache_info_addr(struct pcache_cache *cache)
>> +static inline struct pcache_cache_info *
>> +get_cache_info_addr(struct pcache_cache *cache)
>>   {
>> -	return cache->cache_info_addr + cache->info_index;
>> +	return (struct pcache_cache_info *)((char *)cache->cache_info_addr +
>> +						(size_t)cache->info_index * PCACHE_CACHE_INFO_SIZE);
>>   }
>>   
>>   static void cache_info_write(struct pcache_cache *cache)
>> @@ -49,6 +51,8 @@ static int cache_info_init(struct pcache_cache *cache, struct pcache_cache_optio
>>   			return -EINVAL;
>>   		}
>>   
>> +		cache->info_index = ((char *)cache_info_addr - (char *)cache->cache_info_addr) / PCACHE_CACHE_INFO_SIZE;
>> +
>>   		return 0;
>>   	}
>>   
>> -- 
>> 2.43.0
> I already staged the patch below? Should I revert it and stage your new
> patch?


Yes, please revert it, I will send a v2 patchset, please pick the v2 patch.


Thanx

>
> Mikulas
>
>
> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
> index d8e92367d947..9554d1158450 100644
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
> -       return cache->cache_info_addr + cache->info_index;
> +       return (struct pcache_cache_info *)((char *)cache->cache_info_addr
> +
> +                                               (size_t)cache->info_index * PCACHE_CACHE_INFO_SIZE);
>   }
>
>   static void cache_info_write(struct pcache_cache *cache)
> @@ -40,7 +42,12 @@ static int cache_info_init(struct pcache_cache *cache,
> struct pcache_cache_optio
>          if (IS_ERR(cache_info_addr))
>                  return PTR_ERR(cache_info_addr);
>
> -       if (cache_info_addr) {
> +    if (cache_info_addr) {
> +               int index = ((char *)cache_info_addr - (char *)cache->cache_info_addr) /
> +                               PCACHE_CACHE_INFO_SIZE;
> +
> +               cache->info_index = (index + 1) % PCACHE_META_INDEX_MAX;
> +
>                  if (opts->data_crc !=
>                                  (cache->cache_info.flags & PCACHE_CACHE_FLAGS_DATA_CRC)) {
>                          pcache_dev_err(pcache, "invalid option for data_crc: %s, expected: %s",
>
