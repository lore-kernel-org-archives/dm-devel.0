Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FF3398FBA
	for <dm-devel@lists.linux.dev>; Fri,  5 Dec 2025 05:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764913596; cv=none; b=sWz7qRvOkfGDplyobofsOg1+gw7NFmnJHNFb3O+CV9ozqyWZzdTiBk/+0IkhySEfW0XuO7EZTeyiM0Ke97L5h0xe0vqeJFlvapgV3t25yOsGH9TUYmx99U9ph7r6jh4UwgWRv8kZwUIbrBsYBcC2C8oanNpxkDLqviSBGsqF630=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764913596; c=relaxed/simple;
	bh=HauSw528vbAntAexJxJ37u8PICcqR2VidDppB4u7ZtM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OnEfIlVUMsIGidjfqCFTurzsyS3udeAPU97Z8FqzndVK9ysH1rd97ZXZTKRm5gD3jnhP7H8bpI1WRHrsfZJ2766dZB3kJNQn30UZNCS7K+U1ORIVf+bLVWugKNj+uzlcaedn9i1LrsItEpVOWZnkPJlWeE8ABcju/dZZE1ojhpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SE5QeZ6S; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SE5QeZ6S"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764913591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=zJCmm2nVDezH7tsxi36utmKWuczIMiBC9gosV3rt6Kk=;
	b=SE5QeZ6S+OK0NQR5P3/ET9EPYxKLAml2cZV9JqSiT8yBWNoV7KEB7tGBJ2cqq4rvMOSNGE
	BDzXYNR3pIWzSlN7i96VNwYvsqoOb/j5KBDQEckGgUb1NCTuP3dyj6u5L5LV0UiDds4h/g
	eUNZXKKqxXCYRuEsXP29S6+73EM34wU=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: cengku@gmail.com,
	dm-devel@lists.linux.dev,
	chenl311@chinatelecom.cn,
	mpatocka@redhat.com
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] dm-pcache: advance slot index before writing slot
Date: Fri,  5 Dec 2025 05:46:18 +0000
Message-ID: <20251205054621.1744279-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

In dm-pcache, in order to ensure crash-consistency, a dual-copy scheme
is used to alternately update metadata, and there is a slot index that
records the current slot. However, in the write path the current
implementation writes directly to the current slot indexed by slot
index, and then advances the slot — which ends up overwriting the
existing slot, violating the crash-consistency guarantee.

This patch fixes that behavior, preventing metadata from being
overwritten incorrectly.

In addition, this patch add a missing pmem_wmb() after memcpy_flushcache().

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
Reviewed-by: Zheng Gu <cengku@gmail.com>
Cc: stable@vger.kernel.org	# 6.18
---
 drivers/md/dm-pcache/cache.c         | 8 ++++----
 drivers/md/dm-pcache/cache_segment.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index 698697a7a73c..d4385d76ac36 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -21,10 +21,10 @@ static void cache_info_write(struct pcache_cache *cache)
 	cache_info->header.crc = pcache_meta_crc(&cache_info->header,
 						sizeof(struct pcache_cache_info));
 
+	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
 	memcpy_flushcache(get_cache_info_addr(cache), cache_info,
 			sizeof(struct pcache_cache_info));
-
-	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
+	pmem_wmb();
 }
 
 static void cache_info_init_default(struct pcache_cache *cache);
@@ -93,10 +93,10 @@ void cache_pos_encode(struct pcache_cache *cache,
 	pos_onmedia.header.seq = seq;
 	pos_onmedia.header.crc = cache_pos_onmedia_crc(&pos_onmedia);
 
+	*index = (*index + 1) % PCACHE_META_INDEX_MAX;
+
 	memcpy_flushcache(pos_onmedia_addr, &pos_onmedia, sizeof(struct pcache_cache_pos_onmedia));
 	pmem_wmb();
-
-	*index = (*index + 1) % PCACHE_META_INDEX_MAX;
 }
 
 int cache_pos_decode(struct pcache_cache *cache,
diff --git a/drivers/md/dm-pcache/cache_segment.c b/drivers/md/dm-pcache/cache_segment.c
index f0b58980806e..ae57cc261422 100644
--- a/drivers/md/dm-pcache/cache_segment.c
+++ b/drivers/md/dm-pcache/cache_segment.c
@@ -26,11 +26,11 @@ static void cache_seg_info_write(struct pcache_cache_segment *cache_seg)
 	seg_info->header.seq++;
 	seg_info->header.crc = pcache_meta_crc(&seg_info->header, sizeof(struct pcache_segment_info));
 
+	cache_seg->info_index = (cache_seg->info_index + 1) % PCACHE_META_INDEX_MAX;
+
 	seg_info_addr = get_seg_info_addr(cache_seg);
 	memcpy_flushcache(seg_info_addr, seg_info, sizeof(struct pcache_segment_info));
 	pmem_wmb();
-
-	cache_seg->info_index = (cache_seg->info_index + 1) % PCACHE_META_INDEX_MAX;
 	mutex_unlock(&cache_seg->info_lock);
 }
 
@@ -129,10 +129,10 @@ static void cache_seg_ctrl_write(struct pcache_cache_segment *cache_seg)
 	cache_seg_gen.header.crc = pcache_meta_crc(&cache_seg_gen.header,
 						 sizeof(struct pcache_cache_seg_gen));
 
+	cache_seg->gen_index = (cache_seg->gen_index + 1) % PCACHE_META_INDEX_MAX;
+
 	memcpy_flushcache(get_cache_seg_gen_addr(cache_seg), &cache_seg_gen, sizeof(struct pcache_cache_seg_gen));
 	pmem_wmb();
-
-	cache_seg->gen_index = (cache_seg->gen_index + 1) % PCACHE_META_INDEX_MAX;
 }
 
 static void cache_seg_ctrl_init(struct pcache_cache_segment *cache_seg)
-- 
2.43.0

