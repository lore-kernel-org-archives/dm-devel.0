Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5ED296BBE
	for <dm-devel@lists.linux.dev>; Wed,  3 Dec 2025 05:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764741402; cv=none; b=hMbrpNpUfsebGs7T2NvpU/z7OTvY040uQqtsGz3zNxnrhV8B2jkO5a/cvPDP/4Iq58lHhtzXeWAmnkCPt52kzdQ8XH+4SksoORlVXL4P27oECes6jINtwc5it51majY2fkwh02tPOmuzVK2K8z3GaKAq6pmkAn7z+q/n85euMjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764741402; c=relaxed/simple;
	bh=Os2TDhuJ1nj47jSNlABmdNpiyorG2hL6wq+Lfs2EIIo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cj7ddX0pa8H6k626BViJlyYcXS9+T5g3FlZU2U0BnOB9Iw44gS96mgrtjWDZ1tbpTfrrXOI2MOzWXrYHvjyfZSAWbHs7ThIH59Yj5EaUgbjRwEYl58OO1cnklCGa44CR0KWIIc3lBKJONVW48T1EYeLyrotd4g8ZYL44tJ1jj/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NSaFK2aI; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NSaFK2aI"
Message-ID: <65dbab10-a48a-4cfb-8c06-15011e54b1b5@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764741385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B4RTDwofKoIRzOfCGUCK/T/Jp4TS47BO2wvcnq17RHQ=;
	b=NSaFK2aIV7/c0MVXk8WNp44utQhD3MRhQccMxkfBviBSiIOdNGj+04x9JxxVu374QS0jnd
	3INyFPU3Cc4c0chXqM7DIBMw6Bp9baNeRV1ag35bpObHEH9ozH9mO+zaFQv7gFIuBQgYgR
	ppZImi+lm7Gh0gStlK4pj94RbiezskI=
Date: Wed, 3 Dec 2025 13:56:17 +0800
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] dm-pcache: fix metadata indexing and persistence
 issues
To: Li Chen <me@linux.beauty>, dm-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org, Zheng Gu <cengku@gmail.com>
References: <20251202121158.111092-1-me@linux.beauty>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <20251202121158.111092-1-me@linux.beauty>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi,

     Thanx for your patches, there are some comments inline.

According to these comments, I propose an update base on your patch as [1].

BTW, I added a test case for this problem in dtg-tests:

https://github.com/DataTravelGuide/dtg-tests/blob/main/pcache.py.data/pcache_misc_tests/case21_gc_percent_persistence_after_recreate.sh

It update gc_percent online and recreate pcache device and check gc_percen


[1]:

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index 6d5001548628..4d6db733c9bd 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -42,12 +42,7 @@ static int cache_info_init(struct pcache_cache 
*cache, struct pcache_cache_optio
         if (IS_ERR(cache_info_addr))
                 return PTR_ERR(cache_info_addr);

-    if (cache_info_addr) {
-               int index = ((char *)cache_info_addr - (char 
*)cache->cache_info_addr) /
-                               PCACHE_CACHE_INFO_SIZE;
-
-               cache->info_index = (index + 1) % PCACHE_META_INDEX_MAX;
-
+       if (cache_info_addr) {
                 if (opts->data_crc !=
                                 (cache->cache_info.flags & 
PCACHE_CACHE_FLAGS_DATA_CRC)) {
                         pcache_dev_err(pcache, "invalid option for 
data_crc: %s, expected: %s",
@@ -56,6 +51,8 @@ static int cache_info_init(struct pcache_cache *cache, 
struct pcache_cache_optio
                         return -EINVAL;
                 }

+               cache->info_index = ((char *)cache_info_addr - (char 
*)cache->cache_info_addr) / PCACHE_CACHE_INFO_SIZE;
+
                 return 0;
         }

diff --git a/drivers/md/dm-pcache/cache_segment.c 
b/drivers/md/dm-pcache/cache_segment.c
index 0b4bb08011ce..0a0016702ce7 100644
--- a/drivers/md/dm-pcache/cache_segment.c
+++ b/drivers/md/dm-pcache/cache_segment.c
@@ -60,7 +60,6 @@ static int cache_seg_info_load(struct 
pcache_cache_segment *cache_seg)
         cache_seg->info_index =
                 ((char *)cache_seg_info_addr - (char 
*)cache_seg_info_addr_base) /
                 PCACHE_SEG_INFO_SIZE;
-       cache_seg->info_index = (cache_seg->info_index + 1) % 
PCACHE_META_INDEX_MAX;
  out:
         mutex_unlock(&cache_seg->info_lock);


在 12/2/2025 8:11 PM, Li Chen 写道:
> From: Li Chen <chenl311@chinatelecom.cn>
>
> dm-pcache stores metadata (cache_info and segment_info) in 4K-aligned
> slots on the cache device, using sequence numbers and CRC to identify
> the latest valid copy.
>
> However, the cache_info and segment_info paths were computing their
> on-media index using sizeof(struct) instead of the 4K metadata stride.
> As a result:
>
>    * cache_info updates (including gc_percent set via a dmsetup message)
>      were written to invalid offsets between metadata slots and failed
>      to persist across table reloads or reboots.
>
>    * segment_info indexing became desynchronized, so rotation to the
>      "next" slot no longer matched the location returned by
>      pcache_meta_find_latest().
>
> The issue can be reproduced with:
>
>    dmsetup create pcache_vdb --table \
>      "0 $(blockdev --getsz /dev/vdb) pcache /dev/pmem0 /dev/vdb 4 \
>       cache_mode writeback data_crc false"
>
>    # Check default gc_percent (70)
>    dmsetup status pcache_vdb
>
>    # Change gc_percent to 10
>    dmsetup message pcache_vdb 0 "gc_percent 10"
>
>    # Verify change is active in memory
>    dmsetup status pcache_vdb
>
>    # Reboot the system...
>
>    # Without patch (gc_percent reverts to 70):
>    dmsetup status pcache_vdb
>
>    # With patch (gc_percent persists as 10):
>    dmsetup status pcache_vdb
>
> This series fixes the issue by deriving the metadata slot index from
> the pointer returned by pcache_meta_find_latest(), using the 4K stride
> (CACHE_INFO_SIZE / SEG_INFO_SIZE). This ensures that updates to
> cache_info and segment_info are written to valid slots and remain
> consistent with the on-media layout.
>
> Li Chen (2):
>    dm pcache: fix cache info indexing
>    dm pcache: fix segment info indexing
>
>   drivers/md/dm-pcache/cache.c         | 13 ++++++++++---
>   drivers/md/dm-pcache/cache_segment.c |  6 +++++-
>   2 files changed, 15 insertions(+), 4 deletions(-)
>
