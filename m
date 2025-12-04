Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B72398F85
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 01:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764812312; cv=none; b=e8ZSEScDut27KrGcMFtq+fAITqcK41ZzJyrodn0v23cDYKh1Fvsw2M0p4jbKRvEba7yAtdXsyJch8ge+pFrKz3Gf3zCLJ1lTpxLdH8xMY+v4sTqLyLcFns3hEQcnOVKWVayW1+vfJYgBCYTlk0eYc6B8c3AyYoF+m7ALmwxhtJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764812312; c=relaxed/simple;
	bh=VGzoktw1fKjqk3BbvPg4NUeTmP2JVhMYHO3s+wbDnT0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=G8Dko87Bxnlfx/Gz3Y0osTH5ktlTGA4oWEiG3w9GXQ5m65/Yho+tGmbCSZj+GLzuoQlYlTIw6iTZ7dHIrotr9jN6Yimf/QfeGRNFBca579ocqU3mHhs+GSq9rv4rC3M7t8fwbFRcK2iato+k/yfxM0hhjmIRUX+FfDwdB7Tohjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Z+XZpesb; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Z+XZpesb"
Message-ID: <0af717b0-21c0-404d-82c1-94d9addd4ef5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764812307;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1GzTEsWcDEVEnsOtjpN5c/7lOdCUFBAUkt8h3FDLarY=;
	b=Z+XZpesb55fVdEZ392kXNCqRhRzGnxafocPRit8mVfXjRqca4xMb7D1LR7OgariMPJSkfx
	ZtEH364S+fEWdPjZLrr4NVcAQMSVCgYgS4UawC+6OHlT4IyeN8czTobOq7SP5rn0zXP05X
	uDGCjAeWOBTpE2jmDGQExnRoP6CMBIE=
Date: Thu, 4 Dec 2025 09:38:17 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] dm-pcache: fix metadata indexing and persistence
 issues
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: Li Chen <me@linux.beauty>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Zheng Gu <cengku@gmail.com>
References: <20251202121158.111092-1-me@linux.beauty>
 <65dbab10-a48a-4cfb-8c06-15011e54b1b5@linux.dev>
 <e6170c62-22b9-4d5d-bd97-006a4cecc0b7@linux.dev>
In-Reply-To: <e6170c62-22b9-4d5d-bd97-006a4cecc0b7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 12/4/2025 7:38 AM, Dongsheng Yang 写道:
>
> 在 12/3/2025 1:56 PM, Dongsheng Yang 写道:
>> Hi,
>>
>>     Thanx for your patches, there are some comments inline.
>>
>> According to these comments, I propose an update base on your patch 
>> as [1].
>>
>> BTW, I added a test case for this problem in dtg-tests:
>>
>> https://github.com/DataTravelGuide/dtg-tests/blob/main/pcache.py.data/pcache_misc_tests/case21_gc_percent_persistence_after_recreate.sh 
>>
>>
>> It update gc_percent online and recreate pcache device and check 
>> gc_percen
>>
>>
>> [1]:
>
>
> ->info_index means next slot to write, so advancing it at init stage 
> is correct


We need to think more thoroughly about the usage of the slot index. In 
my original design, all slot indices represent the “current slot”. So at 
initialization it is 0; if loading, we simply point it to the loaded 
slot; and on write we advance afterwards. However, the problem now is 
that in all write functions, they first write to the current slot, then 
advance.

Therefore I believe we should clarify that the meaning of the slot index 
is “the current slot,” and stick to the original design. We only need to 
modify the write functions: first perform the advance, and then write 
into the correct slot.

>
>
> Thanx
>
>>
>> diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
>> index 6d5001548628..4d6db733c9bd 100644
>> --- a/drivers/md/dm-pcache/cache.c
>> +++ b/drivers/md/dm-pcache/cache.c
>> @@ -42,12 +42,7 @@ static int cache_info_init(struct pcache_cache 
>> *cache, struct pcache_cache_optio
>>         if (IS_ERR(cache_info_addr))
>>                 return PTR_ERR(cache_info_addr);
>>
>> -    if (cache_info_addr) {
>> -               int index = ((char *)cache_info_addr - (char 
>> *)cache->cache_info_addr) /
>> -                               PCACHE_CACHE_INFO_SIZE;
>> -
>> -               cache->info_index = (index + 1) % PCACHE_META_INDEX_MAX;
>> -
>> +       if (cache_info_addr) {
>>                 if (opts->data_crc !=
>>                                 (cache->cache_info.flags & 
>> PCACHE_CACHE_FLAGS_DATA_CRC)) {
>>                         pcache_dev_err(pcache, "invalid option for 
>> data_crc: %s, expected: %s",
>> @@ -56,6 +51,8 @@ static int cache_info_init(struct pcache_cache 
>> *cache, struct pcache_cache_optio
>>                         return -EINVAL;
>>                 }
>>
>> +               cache->info_index = ((char *)cache_info_addr - (char 
>> *)cache->cache_info_addr) / PCACHE_CACHE_INFO_SIZE;
>> +
>>                 return 0;
>>         }
>>
>> diff --git a/drivers/md/dm-pcache/cache_segment.c 
>> b/drivers/md/dm-pcache/cache_segment.c
>> index 0b4bb08011ce..0a0016702ce7 100644
>> --- a/drivers/md/dm-pcache/cache_segment.c
>> +++ b/drivers/md/dm-pcache/cache_segment.c
>> @@ -60,7 +60,6 @@ static int cache_seg_info_load(struct 
>> pcache_cache_segment *cache_seg)
>>         cache_seg->info_index =
>>                 ((char *)cache_seg_info_addr - (char 
>> *)cache_seg_info_addr_base) /
>>                 PCACHE_SEG_INFO_SIZE;
>> -       cache_seg->info_index = (cache_seg->info_index + 1) % 
>> PCACHE_META_INDEX_MAX;
>>  out:
>>         mutex_unlock(&cache_seg->info_lock);
>>
>>
>> 在 12/2/2025 8:11 PM, Li Chen 写道:
>>> From: Li Chen <chenl311@chinatelecom.cn>
>>>
>>> dm-pcache stores metadata (cache_info and segment_info) in 4K-aligned
>>> slots on the cache device, using sequence numbers and CRC to identify
>>> the latest valid copy.
>>>
>>> However, the cache_info and segment_info paths were computing their
>>> on-media index using sizeof(struct) instead of the 4K metadata stride.
>>> As a result:
>>>
>>>    * cache_info updates (including gc_percent set via a dmsetup 
>>> message)
>>>      were written to invalid offsets between metadata slots and failed
>>>      to persist across table reloads or reboots.
>>>
>>>    * segment_info indexing became desynchronized, so rotation to the
>>>      "next" slot no longer matched the location returned by
>>>      pcache_meta_find_latest().
>>>
>>> The issue can be reproduced with:
>>>
>>>    dmsetup create pcache_vdb --table \
>>>      "0 $(blockdev --getsz /dev/vdb) pcache /dev/pmem0 /dev/vdb 4 \
>>>       cache_mode writeback data_crc false"
>>>
>>>    # Check default gc_percent (70)
>>>    dmsetup status pcache_vdb
>>>
>>>    # Change gc_percent to 10
>>>    dmsetup message pcache_vdb 0 "gc_percent 10"
>>>
>>>    # Verify change is active in memory
>>>    dmsetup status pcache_vdb
>>>
>>>    # Reboot the system...
>>>
>>>    # Without patch (gc_percent reverts to 70):
>>>    dmsetup status pcache_vdb
>>>
>>>    # With patch (gc_percent persists as 10):
>>>    dmsetup status pcache_vdb
>>>
>>> This series fixes the issue by deriving the metadata slot index from
>>> the pointer returned by pcache_meta_find_latest(), using the 4K stride
>>> (CACHE_INFO_SIZE / SEG_INFO_SIZE). This ensures that updates to
>>> cache_info and segment_info are written to valid slots and remain
>>> consistent with the on-media layout.
>>>
>>> Li Chen (2):
>>>    dm pcache: fix cache info indexing
>>>    dm pcache: fix segment info indexing
>>>
>>>   drivers/md/dm-pcache/cache.c         | 13 ++++++++++---
>>>   drivers/md/dm-pcache/cache_segment.c |  6 +++++-
>>>   2 files changed, 15 insertions(+), 4 deletions(-)
>>>
>>
>
