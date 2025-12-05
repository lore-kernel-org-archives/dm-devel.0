Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50AD2F8BD3
	for <dm-devel@lists.linux.dev>; Fri,  5 Dec 2025 03:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764903939; cv=none; b=rh8fyYxMDhbItvdS6gybbvmlV1CKR3bgEqU3SyDF4kvZJBi/I1YIwG/cYK0cdoadqaIxtlHBHrY5XrKHrT1jVvauTMWS5SqNbw+gjM7NSM9ajddnXIDAjAsQrS3diEc+BanErDAZ0rcKRRsLo4oltAT8bjMsMdNQsDDxDQgrcZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764903939; c=relaxed/simple;
	bh=fRT0z+GlaQCPTyX2KfZcUvHsIgN04FP9nxIjuJ8jWUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JC54WVQspovnkW1bkW/YAQ3yX0s0caZsSJbazpeMHay5MzHfShZI9fuZPolj8xrHZ9c5+gnhJHuKsu1LK8KEVj2zbFCHCcmezFLSP5RVDbyE2aAqJsHRlO6+eLCplS7QkXuLj/azvfQXIYUpde9UYPgt4AqVf2HqRRtJOZFsTpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=O55h021z; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="O55h021z"
Message-ID: <171cb449-87bf-4e4f-80be-fd16e9f0319b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764903934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOhAt4jFBV9vY4zhytvO2XM2fW6PmotRiPdYtPwl4f8=;
	b=O55h021zuNl9PeIdySY7UAFG+IGoX7W+3wHGaVk7Jy1n46G5MYWl+z8QbWva5sAFreErWg
	EZllZflMtCRhot6wntJiwcNyLFm/FQLNgLOD0nZ6hlf3TL0CE75p8O68DiQ5KD72pd8sFa
	TQwrJFF2G3vy3rrdu7Rw7kJ0Em1THX4=
Date: Fri, 5 Dec 2025 11:05:24 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] dm pcache: fix segment info indexing
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: cengku@gmail.com, dm-devel@lists.linux.dev, chenl311@chinatelecom.cn
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
 <20251204025323.2901775-3-dongsheng.yang@linux.dev>
 <1f27a4db-929a-4271-6628-c2816f3d78fe@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <1f27a4db-929a-4271-6628-c2816f3d78fe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/4/2025 11:59 PM, Mikulas Patocka 写道:
>
> On Thu, 4 Dec 2025, Dongsheng Yang wrote:
>
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
>> Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
>> ---
>>   drivers/md/dm-pcache/cache_segment.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/cache_segment.c
>> index ae57cc261422..9d92e2b067ed 100644
>> --- a/drivers/md/dm-pcache/cache_segment.c
>> +++ b/drivers/md/dm-pcache/cache_segment.c
>> @@ -56,7 +56,10 @@ static int cache_seg_info_load(struct pcache_cache_segment *cache_seg)
>>   		ret = -EIO;
>>   		goto out;
>>   	}
>> -	cache_seg->info_index = cache_seg_info_addr - cache_seg_info_addr_base;
>> +
>> +	cache_seg->info_index =
>> +		((char *)cache_seg_info_addr - (char *)cache_seg_info_addr_base) /
>> +		PCACHE_SEG_INFO_SIZE;
>>   out:
>>   	mutex_unlock(&cache_seg->info_lock);
>>   
> Hi
>
> I already staged the patch below. Which patch is valid? Your new patch or
> the patch that I staged?


Yes, please revert it, I will send a v2 patchset, please pick the v2 patch.


Thanx


>
> Mikulas
>
>
>
> diff --git a/drivers/md/dm-pcache/cache_segment.c
> b/drivers/md/dm-pcache/cache_segment.c
> index f0b58980806e..0b4bb08011ce 100644
> --- a/drivers/md/dm-pcache/cache_segment.c
> +++ b/drivers/md/dm-pcache/cache_segment.c
> @@ -56,7 +56,11 @@ static int cache_seg_info_load(struct
> pcache_cache_segment *cache_seg)
>                  ret = -EIO;
>                  goto out;
>          }
> -       cache_seg->info_index = cache_seg_info_addr - cache_seg_info_addr_base;
> +
> +       cache_seg->info_index =
> +               ((char *)cache_seg_info_addr - (char *)cache_seg_info_addr_base) /
> +               PCACHE_SEG_INFO_SIZE;
> +       cache_seg->info_index = (cache_seg->info_index + 1) % PCACHE_META_INDEX_MAX;
>   out:
>          mutex_unlock(&cache_seg->info_lock);
>
>
