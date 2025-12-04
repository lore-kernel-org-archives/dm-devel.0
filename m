Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597BD3321B0
	for <dm-devel@lists.linux.dev>; Thu,  4 Dec 2025 02:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764817052; cv=none; b=Z4IhsBtqzWSSgyoZH3ShbBrPxfdWtKv1uWZzCtNxjmivIZv45OYWWhOzJVPqwpSJkhNFLrPZ/z5xNm5NQQWL2QeBKkpi2fq6+J9es1YhQlE46iE00gcbsuI/6tcA00wj3bCAzaGRoktfVOo7qGtC9kS7mau8nW3m90OyF9S4AbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764817052; c=relaxed/simple;
	bh=InBo1DQcv0WKPY9iTVT759xMGeGuQlHukQt2IC3+W40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBYteIlUD4hucLdLX7uya807JlqMFJQxczav1kN32yXog+QSYS52hX9k/P5L5sQAAzQnADYg5CnlH92TP5gXQDqcsap1ulrbZB5dQ58VZm87yXH4UbsnyeqoTCM4Bj4vlyiSLjxMaHXV4o96Orf6FjnvAh0fB3H3OSan5Ii+YSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HHuKU19P; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HHuKU19P"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764817046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+S5nvdH83q3SGaImeVxVEDcMhpX+F1cRJxLhPPAhwF4=;
	b=HHuKU19Pd9JWZIDF5XqhoP4xGXpkq+2N8snvmP/+HMcsd2ETD7Y3l9Lc3rzzCBxpxEgO4+
	bhIIUBZvwiYJwDlFCQ9zAjm32PElWOgPAbNB10QHc8F+VRUpdH8xMAMvgDDEPfJKzR2yGx
	f20fajbKWP9w47c0I65QupTtBke8VPc=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: cengku@gmail.com,
	dm-devel@lists.linux.dev,
	chenl311@chinatelecom.cn,
	mpatocka@redhat.com
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH 2/3] dm pcache: fix cache info indexing
Date: Thu,  4 Dec 2025 02:53:05 +0000
Message-ID: <20251204025323.2901775-2-dongsheng.yang@linux.dev>
In-Reply-To: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
References: <20251204025323.2901775-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Li Chen <chenl311@chinatelecom.cn>

The on-media cache_info index used sizeof(struct) instead of the
4K metadata stride, so gc_percent updates from dmsetup message
were written between slots and lost after reboot. Use
PCACHE_CACHE_INFO_SIZE in get_cache_info_addr() and align
info_index with the slot returned by pcache_meta_find_latest().

Signed-off-by: Li Chen <chenl311@chinatelecom.cn>
Signed-off-by: Dongsheng Yang <dongsheng.yang@linux.dev>
---
 drivers/md/dm-pcache/cache.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index 9289c016b7c9..bcc4e509aa69 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -8,9 +8,11 @@
 
 struct kmem_cache *key_cache;
 
-static inline struct pcache_cache_info *get_cache_info_addr(struct pcache_cache *cache)
+static inline struct pcache_cache_info *
+get_cache_info_addr(struct pcache_cache *cache)
 {
-	return cache->cache_info_addr + cache->info_index;
+	return (struct pcache_cache_info *)((char *)cache->cache_info_addr +
+						(size_t)cache->info_index * PCACHE_CACHE_INFO_SIZE);
 }
 
 static void cache_info_write(struct pcache_cache *cache)
@@ -49,6 +51,8 @@ static int cache_info_init(struct pcache_cache *cache, struct pcache_cache_optio
 			return -EINVAL;
 		}
 
+		cache->info_index = ((char *)cache_info_addr - (char *)cache->cache_info_addr) / PCACHE_CACHE_INFO_SIZE;
+
 		return 0;
 	}
 
-- 
2.43.0

