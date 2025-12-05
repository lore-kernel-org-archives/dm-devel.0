Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9978515665C
	for <dm-devel@lists.linux.dev>; Fri,  5 Dec 2025 03:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764903722; cv=none; b=g0WqmAV1kVT8AjchUnNsKkb0TqKeDl99jTVZXmUYkNevR5R3rC/3MaMoAiko6tyzC/pu/vqwwdtS1b/kMOLfCGy1BIrb5S8REXFqkmU8aHbVtaYGflgTAqtNa0A/7IT9mtNx7TUd+HfQ6mAhDzS+WO926k/dFy+1lac8x9L5rW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764903722; c=relaxed/simple;
	bh=90YGKqhHaOBH4N6YH6JxMllFQX3GgZi/ziQYIaAoROs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uDf1hVFs1IxAO2qJMohzYaZIyTckjRHUpmERXPM3y+MvZyexEdPwzAaCjNQcusMmtnQUyk4jdut+HnwfP3ngIj5qNoJAP0KiXAyx0jcxVebs8GSw56ZOn5Uh1YEyHuifbD6dv+LddhYnSIN3XEQU/KIk+N5qSDrI86a17BB0J58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WJEg7yRs; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WJEg7yRs"
Message-ID: <6686f762-5bf3-401a-b69d-a2876864b187@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764903717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+1HMahJ48Zs/iCqL77hqJnycPlQvcUQd+UiVW1LmoDY=;
	b=WJEg7yRs6Q7E9ndBSbrcZoozeiwT7M4yTtjpiQ6NKn/m3r+cGRhbJe1tRjvb6t/vxwJ2CF
	bWmsLtAoQnCx9PkEpnfG43+OW2ynbcUNSCr/hslBo9XPy0rGfv8gOBGMQ059Ozpw4tsr2u
	1Pi7S9xSD2REZ2DPVV2NhoJTxs4KTsI=
Date: Fri, 5 Dec 2025 11:01:42 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3] dm-pcache: advance slot index before writing slot
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: cengku@gmail.com, dm-devel@lists.linux.dev, chenl311@chinatelecom.cn
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
 <bea8250d-fc7f-6bda-df57-2814e96fd05f@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <bea8250d-fc7f-6bda-df57-2814e96fd05f@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/5/2025 12:13 AM, Mikulas Patocka 写道:
>
> On Thu, 4 Dec 2025, Dongsheng Yang wrote:
>
>> In dm-pcache, in order to ensure crash-consistency, a dual-copy scheme
>> is used to alternately update metadata, and there is a slot index that
>> records the current slot. However, in the write path the current
>> implementation writes directly to the current slot indexed by slot
>> index, and then advances the slot — which ends up overwriting the
>> existing slot, violating the crash-consistency guarantee.
>>
>> This patch fixes that behavior, preventing metadata from being
>> overwritten incorrectly.
>>
>> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
>> ---
>>   drivers/md/dm-pcache/cache.c         | 8 ++++----
>>   drivers/md/dm-pcache/cache_segment.c | 8 ++++----
>>   2 files changed, 8 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
>> index 698697a7a73c..9289c016b7c9 100644
>> --- a/drivers/md/dm-pcache/cache.c
>> +++ b/drivers/md/dm-pcache/cache.c
>> @@ -21,10 +21,10 @@ static void cache_info_write(struct pcache_cache *cache)
>>   	cache_info->header.crc = pcache_meta_crc(&cache_info->header,
>>   						sizeof(struct pcache_cache_info));
>>   
>> +	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
>> +
>>   	memcpy_flushcache(get_cache_info_addr(cache), cache_info,
>>   			sizeof(struct pcache_cache_info));
>> -
>> -	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
>>   }
>>   
>>   static void cache_info_init_default(struct pcache_cache *cache);
> I'm not sure whether this is bug or not


It's a bug, if in-place updating for slot happen, there is a potential 
metadata corruption while powercut happening at the same time.


so I will add

Cc: stable@vger.kernel.org      # 6.18

in V2.

> - but memcpy_flushcache doesn't
> guarantee that the cache will be flushed (despite it's name) or that
> writes would be ordered.
>
> You need pmem_wmb(). I see that you are using it at other places.


Good catch, I will send v2 to add the missing pmem_wmb().


Thanx

>
> Mikulas
