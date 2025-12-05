Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 562A013D539
	for <dm-devel@lists.linux.dev>; Fri,  5 Dec 2025 05:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764913598; cv=none; b=BduJkBuwXYbhOSCCXN05c1j/PY53eBT2tbeYKVIGjzu02FnUHeFvMh8T7QS58iiWWda+RYN3zd+lEsGmOQCRVvNAXomq71WUQ4/1+xGG5rIoN0CdFaOrQ9UBRiUvDKZB9mtIV+2uMfzxzLovZ90A/ZL6gJnChbVikfAQlu0Gluk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764913598; c=relaxed/simple;
	bh=TJTBJYxNaB6kc44a8beM/+B74WlrWK6+OF9IfMCiYjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4XXvk/MT/9GdNnet9gABMCahnl5nYAvzPDQjJ1yO6k6W6A8OE9Hrm/ZoZRd3GpLam4TRpK0/dLGzR2+FPnZTyeRaXdLZt+yFq2rw29jx0ldc3oh6TidiSlGrizlXpe4nCtaVfAw7IAEAk97rF0y4RF22T2jR+kIyDyeHcCN5a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=garLc42s; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="garLc42s"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764913594;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w8Xa3oZHZJ2ngVxSqp+ySjrfbNoSDi5fnh0Lj1cQp3I=;
	b=garLc42sD64DfUGLXsc+i3PD1semm9wYelgUGYvcf1Txo+9ZU97a6DN4PaO3nP12SFod5N
	bKgo+b62w0cGBL1f24XdTY8uXAV3kwksYDiqBOa9ZeJlZ36XXU23EgcZ+LmTvCnBA2ZXhW
	VicnXul2iBV3BLs0mrGAYtEs2aPxpKM=
From: Dongsheng Yang <dongsheng.yang@linux.dev>
To: cengku@gmail.com,
	dm-devel@lists.linux.dev,
	chenl311@chinatelecom.cn,
	mpatocka@redhat.com
Cc: Dongsheng Yang <dongsheng.yang@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] dm pcache: fix cache info indexing
Date: Fri,  5 Dec 2025 05:46:19 +0000
Message-ID: <20251205054621.1744279-2-dongsheng.yang@linux.dev>
In-Reply-To: <20251205054621.1744279-1-dongsheng.yang@linux.dev>
References: <20251205054621.1744279-1-dongsheng.yang@linux.dev>
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
Reviewed-by: Zheng Gu <cengku@gmail.com>
Cc: stable@vger.kernel.org	# 6.18
---
 drivers/md/dm-pcache/cache.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index d4385d76ac36..534bf07b794f 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -10,7 +10,8 @@ struct kmem_cache *key_cache;
 
 static inline struct pcache_cache_info *get_cache_info_addr(struct pcache_cache *cache)
 {
-	return cache->cache_info_addr + cache->info_index;
+	return (struct pcache_cache_info *)((char *)cache->cache_info_addr +
+						(size_t)cache->info_index * PCACHE_CACHE_INFO_SIZE);
 }
 
 static void cache_info_write(struct pcache_cache *cache)
@@ -49,6 +50,8 @@ static int cache_info_init(struct pcache_cache *cache, struct pcache_cache_optio
 			return -EINVAL;
 		}
 
+		cache->info_index = ((char *)cache_info_addr - (char *)cache->cache_info_addr) / PCACHE_CACHE_INFO_SIZE;
+
 		return 0;
 	}
 
-- 
2.43.0

