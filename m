Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDC4331A4D
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 02:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764817052; cv=none; b=hKIh7NEYaKfqI+OOZ7ugQU7d0o/aVZO61YBFbKIA3wE9yFk0Cb3CO8gFy/KBvOkvHAFWcafOaGuCkM4xBFbMMAxFgvgD4YClklSljgDQuyM3Rqg0co7k7X+q+1jimNd6cPh9KlcuwcYJovwdHXBeKtRHZpyktdAFeUE2Pyj1B4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764817052; c=relaxed/simple;
	bh=k+WEUjny71nnWzgKExpsoomV3BSQqX8FjoueJjLMsbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=D4Zwdq5UOLvOM/6XNPjrsBkPnYINhBR5IhE6JWNs/T/Yi+PONYLVxw3PZg44P/x92XkSjfPmbCjxRkacU/qCxZIVctlBDCy2oYzh77GvNONKMHilJ5ze9yPTz7OhuWhcNB7IKmtkX8GJDu8GGTYwjnPwq1lMuzUPa+dLIN0h2Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dWncjoXa; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dWncjoXa"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764817044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iAxtUIh0JHdPgyNO++ncnhkCewtSmVk0aXdP/zfW/8M=;
	b=dWncjoXavuYSYgej9EL0CMGv1jG2/3cxAVUCNlpr4fYB8UYnAi5RQvI4xSzFZmZqwORdxL
	Mylt4EMkUY8EUCnHbYDDo0wLwLvLeQSeVcYGCgSgCJejF/ZJEjAEHuJxLbKWwIKMaHlTnD
	4B1GkVUxpZI7LyXgvaJbXUfoyRTzBb8=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: cengku@gmail.com,
	dm-devel@lists.linux.dev,
	chenl311@chinatelecom.cn,
	mpatocka@redhat.com
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH 1/3] dm-pcache: advance slot index before writing slot
Date: Thu,  4 Dec 2025 02:53:04 +0000
Message-ID: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
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

Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache.c         | 8 ++++----
 drivers/md/dm-pcache/cache_segment.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index 698697a7a73c..9289c016b7c9 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -21,10 +21,10 @@ static void cache_info_write(struct pcache_cache *cache)
 	cache_info->header.crc = pcache_meta_crc(&cache_info->header,
 						sizeof(struct pcache_cache_info));
 
+	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
+
 	memcpy_flushcache(get_cache_info_addr(cache), cache_info,
 			sizeof(struct pcache_cache_info));
-
-	cache->info_index = (cache->info_index + 1) % PCACHE_META_INDEX_MAX;
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

