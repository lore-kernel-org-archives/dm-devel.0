Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ED12D3A69
	for <dm-devel@lists.linux.dev>; Wed,  3 Dec 2025 23:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764805137; cv=none; b=qz9Ov65Wx6p5JeQdVMYWvtngex8rKJXa3iWw+wYpTbqohc1Yq5l7g/kId/anfExmUGb3IptY0xrNyRwPwBuZj6LjcezVwervPrwU2vRrJb6WEmAb+TjennDJ1CWZVbveiB9zRWOrQMzKK1449XDI1ZZ5AmkPy2NnRwHP0Dne6XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764805137; c=relaxed/simple;
	bh=iVPK+7PrZQ5PLusYvhDq2y7XA/AgZs/DPjgfuoYyoSQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=GpX/E23esD0qOMmYisNL0qPY4hfecPpeLbMKnMjC9UKi9NBB+lzB0w3AQuhoKdzoeTCnJffdGa5HPsfXqLn1WgbVdElYiOnRO3R42GTNSKzqFcYKM6NVFzVXzMK4OGd9mrVxydH9LihUgukyeITDTDQXsYBvm1trz+I+iBvsy68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YKRnOhv2; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YKRnOhv2"
Message-ID: <eede7cda-6621-408f-be86-21c667d7d14f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764805134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uOcOVhZpGAazVqRgpz2TINbzQHgOJW3FPeUkJfHNVmc=;
	b=YKRnOhv2PFuM1nXkDLn3kgMM38mCunkrfUgYbMbVLdWQZR9KrfuPCe2FPCD9y06IcfTLx9
	TWxh3qKnz2+dMWT6SKJs+TvvSY2lN29Etofk/HaxrXV0rTMgMxbx5702wanVN/NvnhetZ/
	odGCe0Q3gPVis6j68QjU5Ov1bB3Oz3M=
Date: Thu, 4 Dec 2025 07:38:51 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] dm pcache: fix segment info indexing
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: Li Chen <me@linux.beauty>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Zheng Gu <cengku@gmail.com>
References: <20251202121158.111092-1-me@linux.beauty>
 <20251202121158.111092-3-me@linux.beauty>
 <8794c32c-790c-4503-a657-3e66bc541cda@linux.dev>
In-Reply-To: <8794c32c-790c-4503-a657-3e66bc541cda@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/3/2025 1:57 PM, Dongsheng Yang 写道:
>
> 在 12/2/2025 8:11 PM, Li Chen 写道:
>> From: Li Chen <chenl311@chinatelecom.cn>
>>
>> Segment info indexing also used sizeof(struct) instead of the
>> 4K metadata stride, so info_index could point between slots and
>> subsequent writes would advance incorrectly. Derive info_index
>> from the pointer returned by the segment meta search using
>> PCACHE_SEG_INFO_SIZE and advance to the next slot for future
>> updates.
>>
>> Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
>> ---
>>   drivers/md/dm-pcache/cache_segment.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-pcache/cache_segment.c 
>> b/drivers/md/dm-pcache/cache_segment.c
>> index f0b58980806e..0b4bb08011ce 100644
>> --- a/drivers/md/dm-pcache/cache_segment.c
>> +++ b/drivers/md/dm-pcache/cache_segment.c
>> @@ -56,7 +56,11 @@ static int cache_seg_info_load(struct 
>> pcache_cache_segment *cache_seg)
>>           ret = -EIO;
>>           goto out;
>>       }
>> -    cache_seg->info_index = cache_seg_info_addr - 
>> cache_seg_info_addr_base;
>> +
>> +    cache_seg->info_index =
>> +        ((char *)cache_seg_info_addr - (char 
>> *)cache_seg_info_addr_base) /
>> +        PCACHE_SEG_INFO_SIZE;
>> +    cache_seg->info_index = (cache_seg->info_index + 1) % 
>> PCACHE_META_INDEX_MAX;
>
>
> Don't advance info_index at init stage.


ignore this incorrect comment, info_index means next slot, we need to 
advance it here.

>
>>   out:
>>       mutex_unlock(&cache_seg->info_lock);
>
